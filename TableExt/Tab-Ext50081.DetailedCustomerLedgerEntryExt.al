tableextension 50081 "BBG Dtld Cust. Ledg. Entry Ext" extends "Detailed Cust. Ledg. Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Sub Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            Editable = false;
            OptionCaption = ' ,,,,,,,,,,,,,,Sales,Lease,,,Sale Property,Sale Normal,Lease Property';
            OptionMembers = " ","WO-Project","WO-Normal","Regular PO-Project","Regular PO Normal","Property PO","Direct PO-Normal","GRN for PO","GRN for Aerens","GRN for Packages","GRN for Fabricated Material for WO","JES for WO","GRN-Direct Purchase","Freight Advice",Sales,Lease,"Project Indent","Non-Project Indent","Sale Property","Sale Normal","Lease Property";
        }

        field(50006; "Advance Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0014 22-08-2007';
            OptionCaption = ' ,Mobilization Advance,Equipment Advance,Secured Advance,Adhoc Advance';
            OptionMembers = " ","Mobilization Advance","Equipment Advance","Secured Advance","Adhoc Advance";
        }

        field(90050; "Order Ref No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
        }
        field(90051; "Milestone Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
        }
        field(90052; "Ref Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            OptionCaption = ' ,Order,,,Blanket Order';
            OptionMembers = " ","Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(90064; "Broker Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Allere';
            //TableRelation = Vendor."No." WHERE("Vendor Type" = FILTER(Broker));
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