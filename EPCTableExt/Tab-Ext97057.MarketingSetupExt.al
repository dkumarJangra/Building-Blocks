tableextension 50088 "BBG Marketing Setup Ext" extends "Marketing Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "Family Member No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50002; "Visit Schedule No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
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