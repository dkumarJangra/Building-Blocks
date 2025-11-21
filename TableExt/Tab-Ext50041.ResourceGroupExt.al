tableextension 50041 "BBG Resource Group Ext" extends "Resource Group"
{
    fields
    {
        // Add changes to table fields here
        field(50000; Type; Option)
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Person,Machine';
            OptionMembers = Person,Machine;
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