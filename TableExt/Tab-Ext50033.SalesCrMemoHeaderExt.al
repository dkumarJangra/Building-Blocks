tableextension 50033 "BBG Sales Cr. Memo Header Ext" extends "Sales Cr.Memo Header"
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
            TableRelation = "Sales Invoice Header" WHERE("Job No." = FIELD("Job No."),
                                                          "Last RA Bill No." = FILTER(''));
        }
        field(50002; "Invoice Type1"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0006 27-07-2007';
            OptionCaption = 'Normal,RA,Escalation';
            OptionMembers = Normal,RA,Escalation;
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
        field(90081; "Job No."; Code[20])
        {
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
        field(98517; "BizTalk Sales Credit Memo"; Boolean)
        {
            Caption = 'BizTalk Sales Credit Memo';
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