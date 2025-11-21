table 60763 "Customer Appl. Claim Details"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Creaation Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Member Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Member Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Plot Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "PAN Number"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Booking Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Father Name"; Text[100])
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

