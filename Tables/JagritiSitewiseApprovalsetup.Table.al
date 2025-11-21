table 60706 "Jagriti Sitewise Approvalsetup"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Request Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,GOLD / SILVER,CHANGE OF PAYMENT OPTION,RE-ALLOT / CHANGE OF PLOT,FUND TRANSFER,PLOT CANCELLATION / REFUND,CUSTOMER CORRECTIONS / RECTIFICATIONS,PLOT REGISTRATION,SITE DEVELOPMENT,IBA Enquiry,Associate ID Activation,Sales ID Change,Associate Bank Update,Enquiry,Bonanza,OTHER,LINK DOCUMENTS REQUEST,Special Plot Change,Special Option Change,Special Gold/Silver,Special Loan Files Price Update,Project Price Change,Unit Price Change';
            OptionMembers = " ","GOLD / SILVER","CHANGE OF PAYMENT OPTION","RE-ALLOT / CHANGE OF PLOT","FUND TRANSFER","PLOT CANCELLATION / REFUND","CUSTOMER CORRECTIONS / RECTIFICATIONS","PLOT REGISTRATION","SITE DEVELOPMENT","IBA Enquiry","Associate ID Activation","Sales ID Change","Associate Bank Update",Enquiry,Bonanza,OTHER,"LINK DOCUMENTS REQUEST","Special Plot Change","Special Option Change","Special Gold/Silver","Special Loan Files Price Update","Project Price Change","Unit Price Change";
        }
        field(3; "Site Code"; Option)
        {
            Caption = 'Branch Office';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,South-HYD,East-HYD,West-HYD,VIZAG,Amaravati,Warangal,Khammam,Karimnagar,Kurnool,Nellore,Mahabub Nagar';
            OptionMembers = " ","South-HYD","East-HYD","West-HYD",VIZAG,Amaravati,Warangal,Khammam,Karimnagar,Kurnool,Nellore,"Mahabub Nagar";
        }
        field(5; "Approver ID"; Code[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "Approver ID" <> '' THEN BEGIN
                    JagartiSitewiseApprovesetup.RESET;
                    JagartiSitewiseApprovesetup.SETRANGE("Document Type", "Document Type");
                    JagartiSitewiseApprovesetup.SETRANGE("Site Code", "Site Code");
                    JagartiSitewiseApprovesetup.SETRANGE("Approver ID", "Approver ID");
                    JagartiSitewiseApprovesetup.SETRANGE("Approval Required", "Approval Required");
                    IF JagartiSitewiseApprovesetup.FINDFIRST THEN;
                    //ERROR('Record already exist with Entry No. -'+FORMAT("Entry No."));
                END;
            end;
        }
        field(7; "Approver Name"; Text[80])
        {
            CalcFormula = Lookup(User."Full Name" WHERE("User Name" = FIELD("Approver ID")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "E-mail ID"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Alternative Approver ID 1"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Alternative Approver Name"; Text[80])
        {
            CalcFormula = Lookup(User."Full Name" WHERE("User Name" = FIELD("Alternative Approver ID 1")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Approval Required"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Alternative Approver ID 2"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Alternative Approver Name 2"; Text[80])
        {
            CalcFormula = Lookup(User."Full Name" WHERE("User Name" = FIELD("Alternative Approver ID 2")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Alternative Approver ID 3"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Alternative Approver Name 3"; Text[80])
        {
            CalcFormula = Lookup(User."Full Name" WHERE("User Name" = FIELD("Alternative Approver ID 3")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Alternative Approver ID 4"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Alternative Approver Name 4"; Text[80])
        {
            CalcFormula = Lookup(User."Full Name" WHERE("User Name" = FIELD("Alternative Approver ID 4")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Alternative Approver ID 5"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Alternative Approver Name 5"; Text[80])
        {
            CalcFormula = Lookup(User."Full Name" WHERE("User Name" = FIELD("Alternative Approver ID 5")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "Alternative Approver ID 6"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Alternative Approver Name 6"; Text[80])
        {
            CalcFormula = Lookup(User."Full Name" WHERE("User Name" = FIELD("Alternative Approver ID 6")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(25; "Alternative Approver ID 7"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Alternative Approver Name 7"; Text[80])
        {
            CalcFormula = Lookup(User."Full Name" WHERE("User Name" = FIELD("Alternative Approver ID 7")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(27; "Alternative Approver ID 8"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Alternative Approver Name 8"; Text[80])
        {
            CalcFormula = Lookup(User."Full Name" WHERE("User Name" = FIELD("Alternative Approver ID 8")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(29; "Alternative Approver ID 9"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Alternative Approver Name 9"; Text[80])
        {
            CalcFormula = Lookup(User."Full Name" WHERE("User Name" = FIELD("Alternative Approver ID 9")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "Alternative Approver ID 10"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Alternative Approver Name 10"; Text[80])
        {
            CalcFormula = Lookup(User."Full Name" WHERE("User Name" = FIELD("Alternative Approver ID 10")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33; "Sms Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Submission,Initiation,Verification,Approval,Payment';
            OptionMembers = " ",Submission,Initiation,Verification,Approval,Payment;
        }
        field(34; "Alternative Approver ID 11"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Alternative Approver Name 11"; Text[80])
        {
            CalcFormula = Lookup(User."Full Name" WHERE("User Name" = FIELD("Alternative Approver ID 10")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(36; "Alternative Approver ID 12"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Alternative Approver Name 12"; Text[80])
        {
            CalcFormula = Lookup(User."Full Name" WHERE("User Name" = FIELD("Alternative Approver ID 10")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(38; "Alternative Approver ID 13"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(39; "Alternative Approver Name 13"; Text[80])
        {
            CalcFormula = Lookup(User."Full Name" WHERE("User Name" = FIELD("Alternative Approver ID 10")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Alternative Approver ID 14"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(41; "Alternative Approver Name 14"; Text[80])
        {
            CalcFormula = Lookup(User."Full Name" WHERE("User Name" = FIELD("Alternative Approver ID 10")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(42; "Alternative Approver ID 15"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(43; "Alternative Approver Name 15"; Text[80])
        {
            CalcFormula = Lookup(User."Full Name" WHERE("User Name" = FIELD("Alternative Approver ID 10")));
            Editable = false;
            FieldClass = FlowField;
        }

        Field(47; "Checker Approval ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        Field(48; "Checker Approval ID 2"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        Field(49; "Checker Approval ID 3"; Code[20])
        {
            DataClassification = ToBeClassified;

        }

        Field(50; "Checker Approval Name"; Text[100])
        {

            Editable = False;
            CalcFormula = Lookup(User."Full Name" WHERE("User Name" = FIELD("Checker Approval ID")));

            FieldClass = FlowField;

        }
        Field(51; "Checker Approval Name 2"; Text[100])
        {

            Editable = False;
            CalcFormula = Lookup(User."Full Name" WHERE("User Name" = FIELD("Checker Approval ID 2")));

            FieldClass = FlowField;
        }
        Field(52; "Checker Approval Name 3"; Text[100])
        {

            Editable = False;
            CalcFormula = Lookup(User."Full Name" WHERE("User Name" = FIELD("Checker Approval ID 3")));

            FieldClass = FlowField;
        }
        Field(53; "Initiator ID"; Code[50])
        {
            DataClassification = ToBeClassified;


        }
        Field(54; "Initiator ID Name"; Text[100])
        {

            Editable = False;
            CalcFormula = Lookup(User."Full Name" WHERE("User Name" = FIELD("Initiator ID")));
            FieldClass = FlowField;
        }

    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Document Type", "Site Code", "Approver ID", "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        JagartiSitewiseApprovesetup.RESET;
        IF JagartiSitewiseApprovesetup.FINDLAST THEN
            "Entry No." := JagartiSitewiseApprovesetup."Entry No." + 1
        ELSE
            "Entry No." := 1;
    end;

    var
        Vendor: Record Vendor;
        JagartiSitewiseApprovesetup: Record "Jagriti Sitewise Approvalsetup";
}

