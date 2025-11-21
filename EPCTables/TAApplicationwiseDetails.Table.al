table 50001 "TA Application wise Details"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Application No."; Code[20])
        {
        }
        field(4; "Application Date"; Date)
        {
        }
        field(5; "Introducer Code"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(6; "Introducer Name"; Text[80])
        {
        }
        field(7; "Associate UpLine Code"; Code[20])
        {
        }
        field(8; "Associate Name"; Text[80])
        {
        }
        field(9; "TA Rate"; Decimal)
        {
        }
        field(10; "TA Generation Date"; Date)
        {
        }
        field(11; "TA Amount"; Decimal)
        {
        }
        field(12; "TA Reverse"; Boolean)
        {
        }
        field(13; "TA Detail Line No."; Integer)
        {
        }
        field(14; "Saleable Area"; Decimal)
        {
        }
        field(15; "Gross TA Rate"; Decimal)
        {
            CalcFormula = Sum("Travel Header"."Project Rate" WHERE("Document No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Document No.", "TA Detail Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

