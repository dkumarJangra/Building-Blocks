table 60673 "Batch Detail Master"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; Batch; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Points; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Rate Per Point"; Decimal)
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

