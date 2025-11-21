table 97839 "Archive Payment Plan Details"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Payment Plan Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Milestone Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Charge Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Charge %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Milestone Description"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Total Charge Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Milestone Charge Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Discount %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Project Milestone Due Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Group Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Fixed Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; Completed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Sale/Lease"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Sale,Lease';
            OptionMembers = " ",Sale,Lease;
        }
        field(18; "Due Date Calculation"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Actual Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Commision Applicable"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Direct Associate"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Percentage Cum"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(23; Checked; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Default Setup"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Version No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Project Code", "Payment Plan Code", "Milestone Code", "Charge Code", "Document No.", "Sale/Lease", "Version No.")
        {
            Clustered = true;
            SumIndexFields = "Milestone Charge Amount";
        }
        key(Key2; "Milestone Code", "Payment Plan Code", "Charge Code", "Sale/Lease")
        {
        }
    }

    fieldgroups
    {
    }
}

