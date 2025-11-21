tableextension 50089 "BBG Profile Question. Line Ext" extends "Profile Questionnaire Line"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "Customer Contact Set"; Boolean)
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