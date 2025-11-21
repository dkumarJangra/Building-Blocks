table 50075 "Arch. Target Vs Achivmt Sumary"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Team Head Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Target Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Achived Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; Month; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(7; Year; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Today Month Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "From Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "To Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Period Duration"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Target Increament %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Entry Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Monthly,Daily';
            OptionMembers = Monthly,Daily;
        }
        field(15; "Version No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Version No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

