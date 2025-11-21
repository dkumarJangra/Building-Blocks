tableextension 50111 "BBG Party Ext" extends Party
{
    fields
    {
        // Add changes to table fields here
        field(50001; "206AB"; Boolean)
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