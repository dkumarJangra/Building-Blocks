tableextension 50076 "BBG Dimension Ext" extends Dimension
{
    fields
    {
        // Add changes to table fields here
        field(55000; "Def. Dimension Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            TableRelation = Dimension;
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