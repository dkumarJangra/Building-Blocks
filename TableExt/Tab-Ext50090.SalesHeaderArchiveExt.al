tableextension 50090 "BBG Sales Header Archive Ext" extends "Sales Header Archive"
{
    fields
    {
        // Add changes to table fields here
        modify("Responsibility Center")
        {
            TableRelation = "Responsibility Center 1";
        }
        field(50001; "Last RA Bill No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0006 27-07-2007';
            TableRelation = "Sales Invoice Header";
        }
        field(50002; "Invoice Type1"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0006 27-07-2007';
            OptionCaption = 'Normal,RA,Escalation';
            OptionMembers = Normal,RA,Escalation;
        }
        field(50018; "Transporter Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00 240212';
        }
        field(50019; Insurance; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00 240212';
        }
        field(98500; "Date Received"; Date)
        {
            Caption = 'Date Received';
            DataClassification = ToBeClassified;
        }
        field(98501; "Time Received"; Time)
        {
            Caption = 'Time Received';
            DataClassification = ToBeClassified;
        }
        field(98502; "BizTalk Request for Sales Qte."; Boolean)
        {
            Caption = 'BizTalk Request for Sales Qte.';
            DataClassification = ToBeClassified;
        }
        field(98503; "BizTalk Sales Order"; Boolean)
        {
            Caption = 'BizTalk Sales Order';
            DataClassification = ToBeClassified;
        }
        field(98509; "Date Sent"; Date)
        {
            Caption = 'Date Sent';
            DataClassification = ToBeClassified;
        }
        field(98510; "Time Sent"; Time)
        {
            Caption = 'Time Sent';
            DataClassification = ToBeClassified;
        }
        field(98513; "BizTalk Sales Quote"; Boolean)
        {
            Caption = 'BizTalk Sales Quote';
            DataClassification = ToBeClassified;
        }
        field(98514; "BizTalk Sales Order Cnfmn."; Boolean)
        {
            Caption = 'BizTalk Sales Order Cnfmn.';
            DataClassification = ToBeClassified;
        }
        field(98518; "Customer Quote No."; Code[20])
        {
            Caption = 'Customer Quote No.';
            DataClassification = ToBeClassified;
        }
        field(98519; "Customer Order No."; Code[20])
        {
            Caption = 'Customer Order No.';
            DataClassification = ToBeClassified;
        }
        field(98521; "BizTalk Document Sent"; Boolean)
        {
            Caption = 'BizTalk Document Sent';
            DataClassification = ToBeClassified;
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