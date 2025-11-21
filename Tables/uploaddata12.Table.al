table 50067 "upload data 12"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Value Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Bank Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "App No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Cheque Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Cheque No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Old Posting DAte"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; Amounts; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; Msg; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Mob No."; Text[30])
        {
            FieldClass = Normal;
        }
        field(15; "Black list"; Boolean)
        {
            CalcFormula = Lookup(Vendor."BBG Black List" WHERE("No." = FIELD("document No.")));
            FieldClass = FlowField;
        }
        field(16; "TEam Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Leader Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Sub team code"; Code[20])
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
        key(Key2; "document No.")
        {
        }
        key(Key3; "App No.")
        {
        }
    }

    fieldgroups
    {
    }
}

