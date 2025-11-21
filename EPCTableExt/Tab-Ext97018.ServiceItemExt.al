tableextension 97018 "EPC Service Item Ext" extends "Service Item"
{
    fields
    {
        // Add changes to table fields here
        field(50031; "MIN No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00 020312';
        }
        field(50032; "MIN Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00 020312';
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