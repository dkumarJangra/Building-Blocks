tableextension 50000 "BBG Standard Text Ext" extends "Standard Text"
{
    fields
    {
        // Add changes to table fields here

        field(50003; "BBG For Enquiry"; Boolean)
        {
            Caption = 'For Enquiry';
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00 050412';
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