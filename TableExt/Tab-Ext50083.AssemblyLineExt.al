tableextension 50083 "BBG Assembly Line Ext" extends "Assembly Line"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "Area (in Sqyd)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLE_110823';
            Editable = false;
        }
        field(50002; "Conversion Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLE_110823';
            Editable = false;
        }
        field(50003; "Agreement Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50004; "Agreement Document Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
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