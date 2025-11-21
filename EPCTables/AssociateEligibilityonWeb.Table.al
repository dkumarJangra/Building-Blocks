table 50025 "Associate Eligibility on Web"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Associate Code"; Code[20])
        {
            Editable = true;
            TableRelation = Vendor;
        }
        field(3; "Commission Amount"; Decimal)
        {
        }
        field(4; "Travel Amount"; Decimal)
        {
        }
        field(5; "Commission_TA Amount"; Decimal)
        {
            Editable = true;
        }
        field(6; "Incentive Amount"; Decimal)
        {
            Editable = true;
        }
        field(7; Date; Date)
        {
            Editable = true;
        }
        field(11; "Response Value"; Text[250])
        {
            Editable = false;
        }
        field(12; "Last Record"; Boolean)
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

