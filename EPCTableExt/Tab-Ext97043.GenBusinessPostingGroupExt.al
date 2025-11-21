tableextension 97043 "EPC Gen. Bus. Postg. Group Ext" extends "Gen. Business Posting Group"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "Issue Agst WO Not Allowed"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
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