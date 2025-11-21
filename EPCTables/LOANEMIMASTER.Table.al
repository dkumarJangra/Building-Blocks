table 60737 "LOAN EMI MASTER"
{
    Caption = 'LOAN EMI MASTER';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Salaried,NRI,Self-Employed,Self-Employed SEP';
            OptionMembers = " ",Salaried,NRI,"Self-Employed","Self-Employed SEP";

            trigger OnValidate()
            begin
                IF "Document Type" <> "Document Type"::" " THEN
                    TESTFIELD("Field Name", '');
            end;
        }
        field(3; "Field Name"; Text[200])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "Document Type" = "Document Type"::" " THEN
                    ERROR('Document Type must have a value');
            end;
        }
        field(4; "Field Type"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Field Heading"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        LOANEMIMASTER.RESET;
        IF LOANEMIMASTER.FINDLAST THEN
            "Entry No." := LOANEMIMASTER."Entry No." + 1
        ELSE
            "Entry No." := 1;
    end;

    var
        LOANEMIMASTER: Record "LOAN EMI MASTER";
}

