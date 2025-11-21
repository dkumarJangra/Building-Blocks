tableextension 97004 "EPC Location Ext" extends Location
{
    fields
    {
        // Add changes to table fields here
        field(50005; "BBG Branch"; Boolean)
        {
            Caption = 'Branch';
            DataClassification = ToBeClassified;
            Description = 'AlleCK';
        }
        field(50003; "BBG Use As Subcon/Site Location"; Boolean)
        {
            Caption = 'Use As Subcon/Site Location';
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00';
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