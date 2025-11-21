tableextension 50027 "BBG General Ledger Setup Ext" extends "General Ledger Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "IAL No. Series"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLE-SR-131107 : IBT';
            TableRelation = "No. Series";
        }
        field(50001; "Accounting Location Dimension"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLE-SR-131107 : IBT';
            TableRelation = Dimension;
        }
        field(50002; "Maximum Amount Limit"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00 230211';
        }

        field(90000; "Enable Branch wise User Access"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEMSN01';
        }
        field(90001; "Branch Is"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEMSN01';
            OptionCaption = 'Global Dimension 1,Global Dimension 2,Shortcut Dimension 3,Shortcut Dimension 4,Shortcut Dimension 5,Shortcut Dimension 6,Shortcut Dimension 7,Shortcut Dimension 8';
            OptionMembers = "Global Dimension 1","Global Dimension 2","Shortcut Dimension 3","Shortcut Dimension 4","Shortcut Dimension 5","Shortcut Dimension 6","Shortcut Dimension 7","Shortcut Dimension 8";
        }
        field(90002; "Disable  Vendor Balance - COA"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90003; "Purchase Dept"; Code[20])
        {
            Caption = 'Purchase Dept';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(90004; "Check Payment Budget"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90005; "Dept Budget Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = "G/L Budget Name";
        }
        field(90006; "Dept Budget GL Account"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
        GLAccount: Record "G/L Account";
}