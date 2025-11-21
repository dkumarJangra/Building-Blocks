tableextension 97005 "EPC User Setup Ext" extends "User Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Responsibility Center"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB';
            TableRelation = "Responsibility Center 1".Code;

            trigger OnValidate()
            begin
                // "Purchase Resp. Ctr. Filter":="Responsibility Center"; //AlleBLK
            end;
        }
        field(50411; "Gamification Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50431; "View of Chart of Account"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50432; "View of BALedger Entry"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50433; "View All Vendor ledger Entries"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50328; "Report ID - 97832 - Run"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50412; "Gamification End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50358; "Mobile Payment Status modify"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50101; "User Branch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location WHERE("BBG Branch" = FILTER(true));
        }
        field(50370; "Registration Status Modify"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50051; "Application Closed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50213; "Refund Amount Modify"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50227; "Allow Re-Send SMS"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50223; "Thumb Impression SMS"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50224; "Registration to SRO SMS"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50225; "Doc Issue from TR DESK SMS"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50226; "Sweet Box Issuefrom TRDESk SMS"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50354; "Allow User Setup Modify"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50220; "Allow for Non Trading Project"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'BBG 160816';
        }
        field(50219; "Allow for Trading Project"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'BBG 160816';
        }
        field(50300; "Allow Receipt on LLP Project"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50350; "Change Unit Company Name"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50434; "BSP4 Update on Project Mster"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50357; "Allow Associate Payment"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; NEFT; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50401; "Import Document"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50200; "Project Approve"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50202; "Project Re-Open"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50211; "Setups Creation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50210; "Setups Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50404; "Allow Gold/Silver Restriction"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50413; "Allow PI SI Unit Price on CO"; Boolean)
        {
            Caption = 'Allow PI SI Unit Price on Confirmed Order';
            DataClassification = ToBeClassified;
            Description = 'ALLESSS';
        }
        field(50214; "MJV Post"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50409; "Refund SMS Submission"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50405; "Refund SMS Initiation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50406; "Refund SMS Verification"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50407; "Refund SMS Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90003; "Spl. Inct. Bonanza Approver ID"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50355; "Allow Unit/Project"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50212; "Project Release"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50204; "Unit Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50205; "Unit Re-Open"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50203; "Unit Creation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50110; "LD Amount Post"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50208; "Associate Re-Open"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50209; "Associate Rank Change"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "MM Chain Management"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50216; "Discount Post"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50221; "Non IBA Vendor Creation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50052; "Plot Reg. Stage 1 and 7"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50053; "Plot Reg. Stage 3"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50054; "Plot Reg. Stage 2"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50055; "Plot Reg. Stage 4_5_6_ 8"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50379; "Allow Back Date Posting"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "NEFT Modification Permission"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50360; "Bank Payment Voucher Verify"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50366; "Contra Voucher Verify"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50361; "Bank Receipt Voucher Verify"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50362; "Cash Receipt Voucher Verify"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50363; "Cash Payment Voucher Verify"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50364; "General Journal Voucher Verify"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50365; "Journal Voucher Verify"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50430; "New Comm Str on Job Allow"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '071223';
        }
        field(50215; "AJVM Post"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50410; "Update Customer Coupon"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90002; "Target Functionality"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50408; "Refund SMS Completed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50371; "Refund Reject Submission"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50372; "Refund Reject Initiation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50373; "Refund Reject Verification"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50374; "Refund Reject Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50375; "Refund Reject Payment"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50402; "Development Company Change"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50403; "Aplication Option Setup Create"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50103; "Commission Report Cuttoff Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(50104; "Modify Posted Narration"; Boolean)      //060325 Added new field
        {
            DataClassification = ToBeClassified;
        }
        field(50105; "Allow Region Code Change"; Boolean)      //061025 Added new field
        {
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