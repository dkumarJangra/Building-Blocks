table 60692 "Customer Lead Prof. Answer"
{
    Caption = 'Contact Profile Answer';
    DrillDownPageID = "Profile Contacts";

    fields
    {
        field(1; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Customers Lead_2";

            trigger OnValidate()
            var
                Cont: Record "Customers Lead_2";
            begin
                IF Cont.GET("Contact No.") THEN
                    "Contact Company No." := Cont."Company No."
                ELSE
                    "Contact Company No." := '';
            end;
        }
        field(2; "Contact Company No."; Code[20])
        {
            Caption = 'Contact Company No.';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Customers Lead_2" WHERE(Type = CONST(Company));
        }
        field(3; "Profile Questionnaire Code"; Code[10])
        {
            Caption = 'Profile Questionnaire Code';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Profile Questionnaire Header";

            trigger OnValidate()
            var
                ProfileQuestnHeader: Record "Profile Questionnaire Header";
            begin
                ProfileQuestnHeader.GET("Profile Questionnaire Code");
                "Profile Questionnaire Priority" := ProfileQuestnHeader.Priority;
            end;
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;
            TableRelation = "Profile Questionnaire Line"."Line No." WHERE("Profile Questionnaire Code" = FIELD("Profile Questionnaire Code"),
                                                                           Type = CONST(Answer));

            trigger OnValidate()
            var
                ProfileQuestnLine: Record "Profile Questionnaire Line";
            begin
                ProfileQuestnLine.GET("Profile Questionnaire Code", "Line No.");
                "Answer Priority" := ProfileQuestnLine.Priority;
            end;
        }
        field(5; Answer; Text[250])
        {
            CalcFormula = Lookup("Profile Questionnaire Line".Description WHERE("Profile Questionnaire Code" = FIELD("Profile Questionnaire Code"),
                                                                                 "Line No." = FIELD("Line No.")));
            Caption = 'Answer';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Contact Company Name"; Text[100])
        {
            CalcFormula = Lookup(Contact."Company Name" WHERE("No." = FIELD("Contact No.")));
            Caption = 'Contact Company Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Contact Name"; Text[100])
        {
            CalcFormula = Lookup(Contact.Name WHERE("No." = FIELD("Contact No.")));
            Caption = 'Contact Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Profile Questionnaire Priority"; Option)
        {
            Caption = 'Profile Questionnaire Priority';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Very Low,Low,Normal,High,Very High';
            OptionMembers = "Very Low",Low,Normal,High,"Very High";
        }
        field(9; "Answer Priority"; Option)
        {
            Caption = 'Answer Priority';
            DataClassification = ToBeClassified;
            OptionCaption = 'Very Low (Hidden),Low,Normal,High,Very High';
            OptionMembers = "Very Low (Hidden)",Low,Normal,High,"Very High";
        }
        field(10; "Last Date Updated"; Date)
        {
            Caption = 'Last Date Updated';
            DataClassification = ToBeClassified;
        }
        field(11; "Questions Answered (%)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Questions Answered (%)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
        }
    }

    keys
    {
        key(Key1; "Contact No.", "Profile Questionnaire Code", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Contact No.", "Answer Priority", "Profile Questionnaire Priority")
        {
        }
        key(Key3; "Profile Questionnaire Code", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ProfileQuestnLine: Record "Profile Questionnaire Line";
    begin
    end;

    trigger OnInsert()
    var
        ContProfileAnswer: Record "Contact Profile Answer";
        ProfileQuestnLine: Record "Profile Questionnaire Line";
        ProfileQuestnLine2: Record "Profile Questionnaire Line";
        ProfileQuestnLine3: Record "Profile Questionnaire Line";
    begin
        ProfileQuestnLine.GET("Profile Questionnaire Code", "Line No.");
        ProfileQuestnLine.TESTFIELD(Type, ProfileQuestnLine.Type::Answer);

        ProfileQuestnLine2.GET("Profile Questionnaire Code", QuestionLineNo);
        ProfileQuestnLine2.TESTFIELD("Auto Contact Classification", FALSE);

        IF NOT ProfileQuestnLine2."Multiple Answers" THEN BEGIN
            ContProfileAnswer.RESET;
            ProfileQuestnLine3.RESET;
            ProfileQuestnLine3.SETRANGE("Profile Questionnaire Code", "Profile Questionnaire Code");
            ProfileQuestnLine3.SETRANGE(Type, ProfileQuestnLine3.Type::Question);
            ProfileQuestnLine3.SETFILTER("Line No.", '>%1', ProfileQuestnLine2."Line No.");
            IF ProfileQuestnLine3.FINDFIRST THEN
                ContProfileAnswer.SETRANGE(
                  "Line No.", ProfileQuestnLine2."Line No.", ProfileQuestnLine3."Line No.")
            ELSE
                ContProfileAnswer.SETFILTER("Line No.", '>%1', ProfileQuestnLine2."Line No.");
            ContProfileAnswer.SETRANGE("Contact No.", "Contact No.");
            ContProfileAnswer.SETRANGE("Profile Questionnaire Code", "Profile Questionnaire Code");
            IF ContProfileAnswer.FINDFIRST THEN
                ERROR(Text000, ProfileQuestnLine2.FIELDCAPTION("Multiple Answers"));
        END;

        IF PartOfRating THEN BEGIN
            INSERT;
            UpdateContactClassification.UpdateRating("Contact No.");
            DELETE;
        END;

        TouchContact("Contact No.");
    end;

    var
        Text000: Label 'This Question does not allow %1.';
        UpdateContactClassification: Report "Update Contact Classification";


    procedure Question(): Text[50]
    var
        ProfileQuestnLine: Record "Profile Questionnaire Line";
    begin
        IF ProfileQuestnLine.GET("Profile Questionnaire Code", QuestionLineNo) THEN
            EXIT(ProfileQuestnLine.Description)
    end;

    local procedure QuestionLineNo(): Integer
    var
        ProfileQuestnLine: Record "Profile Questionnaire Line";
    begin
        WITH ProfileQuestnLine DO BEGIN
            RESET;
            SETRANGE("Profile Questionnaire Code", Rec."Profile Questionnaire Code");
            SETFILTER("Line No.", '<%1', Rec."Line No.");
            SETRANGE(Type, Type::Question);
            IF FINDLAST THEN
                EXIT("Line No.")
        END;
    end;

    local procedure TouchContact(ContactNo: Code[20])
    var
        Cont: Record "Customers Lead_2";
    begin
        Cont.LOCKTABLE;
        Cont.GET(ContactNo);
        Cont."Last Date Modified" := TODAY;
        Cont.MODIFY;
    end;

    local procedure PartOfRating(): Boolean
    var
        Rating: Record Rating;
        ProfileQuestnLine: Record "Profile Questionnaire Line";
        ProfileQuestnLine2: Record "Profile Questionnaire Line";
    begin
        Rating.SETCURRENTKEY("Rating Profile Quest. Code", "Rating Profile Quest. Line No.");
        Rating.SETRANGE("Rating Profile Quest. Code", "Profile Questionnaire Code");

        ProfileQuestnLine.GET("Profile Questionnaire Code", "Line No.");
        ProfileQuestnLine.GET("Profile Questionnaire Code", ProfileQuestnLine.FindQuestionLine);

        ProfileQuestnLine2 := ProfileQuestnLine;
        ProfileQuestnLine2.SETRANGE(Type, ProfileQuestnLine2.Type::Question);
        ProfileQuestnLine2.SETRANGE("Profile Questionnaire Code", ProfileQuestnLine2."Profile Questionnaire Code");
        IF ProfileQuestnLine2.NEXT <> 0 THEN
            Rating.SETRANGE("Rating Profile Quest. Line No.", ProfileQuestnLine."Line No.", ProfileQuestnLine2."Line No.")
        ELSE
            Rating.SETFILTER("Rating Profile Quest. Line No.", '%1..', ProfileQuestnLine."Line No.");

        EXIT(Rating.FINDFIRST);
    end;
}

