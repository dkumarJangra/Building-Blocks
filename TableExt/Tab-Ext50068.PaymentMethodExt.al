tableextension 50068 "BBG Payment method Ext" extends "Payment Method"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Default Payment Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Pending,Cleared';
            OptionMembers = Pending,Cleared;
        }

        field(50002; "Pmt. Meth. For Ass. Payment"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 030313';
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