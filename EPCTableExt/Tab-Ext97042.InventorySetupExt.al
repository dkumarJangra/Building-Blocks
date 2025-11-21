tableextension 97042 "EPC Inventory Setup Ext" extends "Inventory Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Work Center Mandatory in MIN"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50014; "Item Tracking for Joint Ventur"; Code[20])
        {
            Caption = 'Item Tracking for Joint Venture';
            DataClassification = ToBeClassified;
            Description = 'ALLESSS';
            TableRelation = "Item Tracking Code";
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
}