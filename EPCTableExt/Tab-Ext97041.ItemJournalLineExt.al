tableextension 97041 "EPC Item Journal Line Ext" extends "Item Journal Line"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50001; "PO No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Order));
        }
        field(50008; "Issue Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'SC--JPL';
            OptionCaption = 'Free,Chargeable';
            OptionMembers = Free,Chargeable;
        }
        field(50015; "Reference No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50020; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'BBG 151012';
        }
        field(50021; "Application Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'BBG 161012';
        }
        field(50031; "Item Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Gold,Silver,Gold_SilverVoucher';  //09042025 Added option Gold_SilverVoucher
            OptionMembers = " ",Gold,Silver,Gold_SilverVoucher;
        }
        field(50016; Narration; Text[200])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50019; "PO Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00 180412';
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