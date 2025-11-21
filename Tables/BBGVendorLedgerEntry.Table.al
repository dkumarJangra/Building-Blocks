
table 80003 "BBG Detailed Vendor LedgEntry"
{
    Caption = 'BBG Detailed Vendor Ledg. Entry';
    DataCaptionFields = "Vendor No.";
    // DrillDownPageID = "Detailed Vendor Ledg. Entries";
    // LookupPageID = "Detailed Vendor Ledg. Entries";
    Permissions = TableData "Detailed Vendor Ledg. Entry" =;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Vendor Ledger Entry No."; Integer)
        {
            Caption = 'Vendor Ledger Entry No.';
            //            TableRelation = "Vendor Ledger Entry";
        }
        field(3; "Entry Type"; Enum "Detailed CV Ledger Entry Type")
        {
            Caption = 'Entry Type';
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(7; Amount; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(8; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
        }
        field(9; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(10; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(11; "User ID"; Code[50])
        {
            Caption = 'User ID';

        }
        field(12; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            //          TableRelation = "Source Code";
        }
        field(13; "Transaction No."; Integer)
        {
            Caption = 'Transaction No.';
        }
        field(14; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(15; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            //        TableRelation = "Reason Code";
        }
        field(16; "Debit Amount"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Debit Amount';
        }
        field(17; "Credit Amount"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount';
        }
        field(18; "Debit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Debit Amount (LCY)';
        }
        field(19; "Credit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount (LCY)';
        }
        field(20; "Initial Entry Due Date"; Date)
        {
            Caption = 'Initial Entry Due Date';
        }
        field(21; "Initial Entry Global Dim. 1"; Code[20])
        {
            Caption = 'Initial Entry Global Dim. 1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(22; "Initial Entry Global Dim. 2"; Code[20])
        {
            Caption = 'Initial Entry Global Dim. 2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(24; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            //      TableRelation = "Gen. Business Posting Group";
        }
        field(25; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            //    TableRelation = "Gen. Product Posting Group";
        }
        field(29; "Use Tax"; Boolean)
        {
            Caption = 'Use Tax';
        }
        field(30; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            //  TableRelation = "VAT Business Posting Group";
        }
        field(31; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            //TableRelation = "VAT Product Posting Group";
        }
        field(35; "Initial Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Initial Document Type';
        }
        field(36; "Applied Vend. Ledger Entry No."; Integer)
        {
            Caption = 'Applied Vend. Ledger Entry No.';
        }
        field(37; Unapplied; Boolean)
        {
            Caption = 'Unapplied';
        }
        field(38; "Unapplied by Entry No."; Integer)
        {
            Caption = 'Unapplied by Entry No.';
            //TableRelation = "Detailed Vendor Ledg. Entry";
        }
        field(39; "Remaining Pmt. Disc. Possible"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Remaining Pmt. Disc. Possible';
        }
        field(40; "Max. Payment Tolerance"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Max. Payment Tolerance';
        }
        field(41; "Tax Jurisdiction Code"; Code[10])
        {
            Caption = 'Tax Jurisdiction Code';
            Editable = false;
            //TableRelation = "Tax Jurisdiction";
        }
        field(42; "Application No."; Integer)
        {
            Caption = 'Application No.';
            Editable = false;
        }
        field(43; "Ledger Entry Amount"; Boolean)
        {
            Caption = 'Ledger Entry Amount';
            Editable = false;
        }
        field(44; "Posting Group"; Code[20])
        {
            Caption = 'Vendor Posting Group';
            Editable = false;
            //TableRelation = "Vendor Posting Group";
        }
        field(45; "Exch. Rate Adjmt. Reg. No."; Integer)
        {
            Caption = 'Exch. Rate Adjmt. Reg. No.';
            Editable = false;
            //TableRelation = "Exch. Rate Adjmt. Reg.";
        }
        field(50000; "Sub Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            OptionCaption = ' ,,,,,,,,,,,,,,Sales,Lease,,,Sale Property,Sale Normal,Lease Property';
            OptionMembers = " ","WO-Project","WO-Normal","Regular PO-Project","Regular PO Normal","Property PO","Direct PO-Normal","GRN for PO","GRN for Aerens","GRN for Packages","GRN for Fabricated Material for WO","JES for WO","GRN-Direct Purchase","Freight Advice",Sales,Lease,"Project Indent","Non-Project Indent","Sale Property","Sale Normal","Lease Property";
        }
        field(50021; "Entry Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'INS1.0';
            Editable = false;
        }

        field(60010; "Emp Advance Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            OptionCaption = ' ,Travel Advance,Salary Advance,LTA Advance,Other Advance,Amex Corporate Card';
            OptionMembers = " ",Travel,Salary,LTA,Other,Amex;
        }
        field(70030; "Provisional Bill"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }

        field(90016; "Posting Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS02--JPL,ALLERE';
            OptionCaption = ' ,Advance,Running,Retention,Secured Advance,Adhoc Advance,Provisional,LD,Mobilization Advance,Equipment Advance,,,,Commission,Travel Allowance,Bonanza,Incentive,CommAndTA';
            OptionMembers = " ",Advance,Running,Retention,"Secured Advance","Adhoc Advance",Provisional,LD,"Mobilization Advance","Equipment Advance",,,,Commission,"Travel Allowance",Bonanza,Incentive,CommAndTA;
        }
        field(50104; "Land Agreement No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(90050; "Order Ref No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 Fields Added to Link Payments with the Milestones--JPL';
        }
        field(90051; "Milestone Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 Fields Added to Link Payments with the Milestones--JPL';
        }
        field(90052; "Ref Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 Fields Added to Link Payments with the Milestones--JPL';
            OptionCaption = ' ,Order,,,Blanket Order';
            OptionMembers = " ","Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(90063; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            //TableRelation = Job;
        }
        field(90064; "Broker Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';

        }
        field(90065; "Tran Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            OptionCaption = ' ,Purchase,Sale';
            OptionMembers = " ",Purchase,Sale;
        }

        FIELD(90080; "Company Name"; Text[30])
        {
            DataClassification = ToBeClassified;

        }

        FIELD(90081; "Company DtlVLE Ledg Entry No."; Integer)
        {
            DataClassification = ToBeClassified;

        }

    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Vendor Ledger Entry No.", "Posting Date")
        {
            IncludedFields = Amount, "Amount (LCY)";
        }
        key(Key3; "Vendor Ledger Entry No.", "Entry Type", "Posting Date")
        {
            IncludedFields = Amount, "Amount (LCY)";
        }
        key(Key4; "Ledger Entry Amount", "Vendor Ledger Entry No.", "Posting Date")
        {
            IncludedFields = Amount, "Amount (LCY)", "Debit Amount", "Credit Amount", "Debit Amount (LCY)", "Credit Amount (LCY)";
        }
        key(Key5; "Initial Document Type", "Entry Type", "Vendor No.", "Currency Code", "Initial Entry Global Dim. 1", "Initial Entry Global Dim. 2", "Posting Date")
        {
            SumIndexFields = Amount, "Amount (LCY)";
        }
        key(Key6; "Vendor No.", "Currency Code", "Initial Entry Global Dim. 1", "Initial Entry Global Dim. 2", "Initial Entry Due Date", "Posting Date")
        {
            SumIndexFields = Amount, "Amount (LCY)";
        }
        key(Key7; "Document No.", "Document Type", "Posting Date")
        {
        }
        key(Key8; "Applied Vend. Ledger Entry No.", "Entry Type")
        {
        }
        key(Key9; "Transaction No.", "Vendor No.", "Entry Type")
        {
        }
        key(Key10; "Application No.", "Vendor No.", "Entry Type")
        {
        }
        key(Key11; "Initial Document Type", "Initial Entry Due Date")
        {
            SumIndexFields = "Amount (LCY)";
        }
        key(Key12; "Entry Type", "Vendor No.", "Posting Date")
        {
            SumIndexFields = "Debit Amount", "Credit Amount", "Debit Amount (LCY)", "Credit Amount (LCY)";
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No.", "Vendor Ledger Entry No.", "Vendor No.", "Posting Date", "Document Type", "Document No.")
        {
        }
    }





}

