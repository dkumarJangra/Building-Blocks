tableextension 97049 "BBG Extended text Header Ext" extends "Extended Text Header"
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