tableextension 97050 "BBG Extended Text Line Ext" extends "Extended Text Line"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "BOQ Type"; Option)
        {
            Caption = 'BOQ Type';
            DataClassification = ToBeClassified;
            Description = 'ALLEAA';
            Editable = false;
            OptionCaption = ' ,Sale,Purchase';
            OptionMembers = " ",Sale,Purchase;
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