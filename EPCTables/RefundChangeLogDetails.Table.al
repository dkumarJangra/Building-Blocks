table 50077 "Refund Change Log Details"
{
    Caption = 'New Confirmed Order';
    DataPerCompany = false;
    DrillDownPageID = "Confirm Order List (POC)";
    LookupPageID = "Confirm Order List (POC)";

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
            NotBlank = true;
        }
        field(2; "Customer No."; Code[20])
        {
            Editable = false;
            TableRelation = Customer;
        }
        field(3; "Introducer Code"; Code[20])
        {
            Caption = 'IBA Code';
            Editable = false;
            TableRelation = Vendor WHERE("BBG Vendor Category" = FILTER("IBA(Associates)"),
                                          "BBG Status" = FILTER(Active | Provisional));
        }
        field(4; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(6; Status; Option)
        {
            Editable = true;
            OptionCaption = 'Open,,,,,,,,,,,,Registered,Cancelled,Vacate,Forfeit';
            OptionMembers = Open,Documented,"Cash Dispute","Documentation Dispute",Verified,Active,"Death Claim","Maturity Claim","Maturity Dispute",Matured,Dispute,"Blocked (Loan)",Registered,Cancelled,Vacate,Forfeit;
        }
        field(8; Amount; Decimal)
        {
            Description = 'Investment Amount';
            Editable = false;
        }
        field(9; "Posting Date"; Date)
        {
            Editable = true;
        }
        field(10; "Document Date"; Date)
        {
            Editable = false;
        }
        field(11; "Refund SMS Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Initiated,Verified,Approved,Submission,Rejected,Completed';
            OptionMembers = " ",Initiated,Verified,Approved,Submission,Rejected,Completed;
        }
        field(12; "Refund Initiate Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Refund Rejection Remark"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Refund Rejection SMS Sent"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; "Min. Allotment Amount"; Decimal)
        {
            Editable = false;
        }
        field(16; "Modified By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Modify Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Modify Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Old Refund SMS Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Initiated,Verified,Approved,Submission,Rejected,Completed';
            OptionMembers = " ",Initiated,Verified,Approved,Submission,Rejected,Completed;
        }
        field(20; "Old Refund Initiate Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Old Refund Rejection Remark"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Old Refund Rejection SMS Sent"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Submission Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Completed Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Rejected Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

