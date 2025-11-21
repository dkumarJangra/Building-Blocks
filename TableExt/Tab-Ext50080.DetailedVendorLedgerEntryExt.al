tableextension 50080 "BBG Dtled Vend Ledg. Entry Ext" extends "Detailed Vendor Ledg. Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Sub Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            OptionCaption = ' ,,,,,,,,,,,,,,Sales,Lease,,,Sale Property,Sale Normal,Lease Property';
            OptionMembers = " ","WO-Project","WO-Normal","Regular PO-Project","Regular PO Normal","Property PO","Direct PO-Normal","GRN for PO","GRN for Aerens","GRN for Packages","GRN for Fabricated Material for WO","JES for WO","GRN-Direct Purchase","Freight Advice",Sales,Lease,"Project Indent","Non-Project Indent","Sale Property","Sale Normal","Lease Property";
        }
        field(50021; "Entry Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'INS1.0';
            Editable = false;
        }

        field(60010; "Emp Advance Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            OptionCaption = ' ,Travel Advance,Salary Advance,LTA Advance,Other Advance,Amex Corporate Card';
            OptionMembers = " ",Travel,Salary,LTA,Other,Amex;
        }
        field(70030; "Provisional Bill"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
    }

    keys
    {

    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}