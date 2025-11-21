tableextension 50031 "BBG Sales Invoice Header Ext" extends "Sales Invoice Header"
{
    fields
    {
        // Add changes to table fields here
        modify("Responsibility Center")
        {
            TableRelation = "Responsibility Center 1";
        }


        field(50003; "Bill Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0016 27-08-2007';
        }
        field(50004; "Bill End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0016 27-08-2007';
        }
        field(50006; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0016 27-08-2007';
            TableRelation = Job;
        }
        field(50007; "Region Dimension Name"; Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE(Code = FIELD("Shortcut Dimension 1 Code")));
            Editable = false;
            FieldClass = FlowField;
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
        field(50031; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50032; "Unit Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50051; "Registration Date"; Date)
        {
            CalcFormula = Lookup("Confirmed Order"."Registration Date" WHERE("No." = FIELD("Application No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50100; "Consignment No."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(90072; "Client Bill Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Opened,Closed';
            OptionMembers = Opened,Closed;
        }
        field(90073; "Client Bill Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Raised,Certified';
            OptionMembers = " ",Raised,Certified;
        }
        field(90074; "Raised Client Bill Ref. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(90081; "Job No."; Code[20])
        {
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