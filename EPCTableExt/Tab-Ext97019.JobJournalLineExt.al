tableextension 97019 "EPC Job Journal Line Ext" extends "Job Journal Line"
{
    fields
    {
        // Add changes to table fields here
        field(60019; "MIN Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00 240212';
        }
        field(60000; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(60001; "PO No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(60008; "Issue Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'SC--JPL';
            OptionCaption = 'Free,Chargeable';
            OptionMembers = Free,Chargeable;
        }
        field(60015; "Reference No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(60016; Narration; Text[200])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(80013; "Fixed Asset No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Asset";
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