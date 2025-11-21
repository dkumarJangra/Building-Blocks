tableextension 50100 "BBG Item Category Ext" extends "Item Category"
{
    fields
    {
        // Add changes to table fields here
        field(50000; Property; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
        }
        field(50001; Type; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00';
            OptionCaption = ' ,Fuel,Lubricant,Spares,Diesel,Engine oil,Transmission oil,Hydraulic oil,Grease,O/S workshop charges';
            OptionMembers = " ",Fuel,Lubricant,Spares,Diesel,"Engine oil","Transmission oil","Hydraulic oil",Grease,"O/S workshop charges";
        }
        field(50002; Drawing; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00';
        }
        field(50003; Manufacturer; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00';
        }
        field(50004; "Part No."; Boolean)
        {
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