tableextension 50016 "Sales Comment Line Ext" extends "Sales Comment Line"
{
    fields
    {
        // Add changes to table fields here
        field(50000; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Name of Work,Authority for work';
            OptionMembers = " ","Name of Work","Authority for work";
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