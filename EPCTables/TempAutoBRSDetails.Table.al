table 60670 "Temp Auto BRS Details"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Transaction Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Value Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Reference No."; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Transaction Description"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Transaction Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "USER ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Bank Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Find BRS Entries"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "New Reference No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "New Transaction Description"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "BALEntry Exists"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Cheque No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Posting Date"; Date)
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
}

