tableextension 97011 "EPC Item Ledger Entry Ext" extends "Item Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50020; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'BBG 151012';
        }
        field(50030; "Item Type"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = true;
            OptionCaption = ' ,Gold,Silver,Gold_SilverVoucher';
            OptionMembers = " ",Gold,Silver,Gold_SilverVoucher;
        }
        field(50001; "PO No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(80030; "Transfer FG"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00';
        }
        field(50009; "Issue Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'SC Added--JPL';
            OptionCaption = 'Free,Chargeable';
            OptionMembers = Free,Chargeable;
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