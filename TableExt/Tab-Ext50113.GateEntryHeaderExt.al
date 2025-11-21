tableextension 50113 "BBG Gate Entry Header Ext" extends "Gate Entry Header"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Inward Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            OptionMembers = "Regular PO","Local Purchase","Packages/Work Orders","Returnable Out-Gatepass";
        }
        field(50001; Status; Option)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            OptionCaption = 'Open,Close';
            OptionMembers = Open,Close;
        }
        field(50009; "Sub Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            OptionCaption = ' ,WO-ICB,WO-NICB,Regular PO,Repeat PO,Confirmatory PO,Direct PO';
            OptionMembers = " ","WO-ICB","WO-NICB","Regular PO","Repeat PO","Confirmatory PO","Direct PO","GRN for PO","GRN for JSPL","GRN for Packages","GRN for Fabricated Material for WO","JES for WO","GRN-Direct Purchase";
        }
        field(50010; "Net Weight"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50011; "Vendor Description"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50012; UOM; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'added by dds--JPL';
            TableRelation = "Unit of Measure";
        }

        field(50015; "Out-Time"; Time)
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