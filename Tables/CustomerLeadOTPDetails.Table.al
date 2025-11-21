table 60726 "Customer Lead OTP Details"
{

    fields
    {
        field(1; "Lead Id"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; OTP; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Is used"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5; Name; Text[50])
        {
            CalcFormula = Lookup("Customers Lead_2".Name WHERE("No." = FIELD("Lead Id")));
            FieldClass = FlowField;
        }
        field(6; "Mobile No."; Text[30])
        {
            CalcFormula = Lookup("Customers Lead_2"."Mobile Phone No." WHERE("No." = FIELD("Lead Id")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Lead Id", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

