tableextension 50104 "BBG Inventory Post. Setup Ext" extends "Inventory Posting Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Bin Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location Code"));
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