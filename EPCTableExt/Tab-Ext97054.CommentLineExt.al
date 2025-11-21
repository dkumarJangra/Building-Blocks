tableextension 97054 "BBG Comment Line" extends "Comment Line"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "User ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Alle';
            Editable = false;
        }
        field(50001; "Comment Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETDK';
            OptionCaption = ' ,Associate Change';
            OptionMembers = " ","Associate Change";
        }
        field(50002; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50003; "Creation Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50004; "Document Line No."; Integer)
        {
            DataClassification = ToBeClassified;
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

    trigger OnBeforeDelete()
    begin
        //ALLETDK>>
        IF "Comment Type" <> "Comment Type"::" " THEN
            ERROR('This Comment Cannot be deleted');
        //ALLETDK<<<
    end;
}