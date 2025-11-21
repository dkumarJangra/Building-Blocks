tableextension 50046 "BBG Work type Ext" extends "Work Type"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Break Down"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; Idle; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; Running; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Preventive Maintenance"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00 170412';
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