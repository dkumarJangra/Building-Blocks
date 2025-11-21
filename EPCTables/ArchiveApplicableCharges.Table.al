table 97837 "Archive Applicable Charges"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Unit,Zone,Charge,Brand,Payment Plan,Co-Applicants,Project Price Groups';
            OptionMembers = ,Unit,Zone,Charge,Brand,"Payment Plan","Co-Applicants","Project Price Groups";
        }
        field(3; Description; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Rate/UOM"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Fixed Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "BP Dependency"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Rate Not Allowed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Project Price Dependency Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Discount %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; Applicable; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Net Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Fixed Discount Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Commision Applicable"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Direct Associate"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(18; Sequence; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Discount Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Membership Fee"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50000; "App. Charge Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "App. Charge Name"; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "User ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Archive Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Version No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Project Code", "Code", "Document No.", "Item No.", "Version No.")
        {
            Clustered = true;
        }
        key(Key2; "Document Type", "Code")
        {
        }
        key(Key3; "Document No.", Sequence)
        {
        }
        key(Key4; "Document No.", Applicable, "Membership Fee")
        {
            SumIndexFields = "Net Amount";
        }
    }

    fieldgroups
    {
    }
}

