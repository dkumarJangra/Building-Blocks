tableextension 50103 "BBG Value Entry Ext" extends "Value Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50001; Narration; Text[200])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
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