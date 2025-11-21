tableextension 50028 "BBG Item Vendor Ext" extends "Item Vendor"
{
    fields
    {
        // Add changes to table fields here
        field(50000; Category; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'NON RDSO,RDSO PART 1,RDSO PART 2';
            OptionMembers = "NON RDSO","RDSO PART 1","RDSO PART 2";
        }
        field(50001; "RDSO Serial No."; Text[30])
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
}