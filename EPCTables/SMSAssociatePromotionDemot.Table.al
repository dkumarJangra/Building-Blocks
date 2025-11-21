table 50024 "SMS Associate Promotion/Demot"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Associate Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "User Id"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Active Data"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(5; "Current Associate Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "From Associate Creation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "From Associate Change"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "From Customer Cheque Bounce"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "From Associate Promotion"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "SMS Send"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.", "User Id")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

