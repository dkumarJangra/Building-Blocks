table 97788 "Unit Setup"
{
    // //ALLEDK 210921 Added new field -21.09

    Caption = 'Bond Setup';
    DrillDownPageID = "Job List Archive";
    LookupPageID = "Job List Archive";

    fields
    {
        field(1; "FD Posting Group"; Code[10])
        {
        }
        field(2; "Interest Payment Group"; Code[10])
        {
            TableRelation = "Confirmed Order";
        }
        field(5; "Cash A/c No."; Code[10])
        {
            TableRelation = "Payment Method";
        }
        field(6; "Bank A/C No."; Code[10])
        {
            TableRelation = "Payment Method";
        }
        field(7; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(8; "Late Pmt. Interest A/C"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(9; "Payment Terms"; DateFormula)
        {
            Description = 'Grace period After due Date';
        }
        field(10; "Late Payment Int. %"; Decimal)
        {
        }
        field(11; "Commission A/C"; Code[10])
        {
            TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));
        }
        field(12; "Bonus A/c"; Code[10])
        {
            TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));
        }
        field(13; "Interest A/C"; Code[10])
        {
            TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));
        }
        field(14; "Application Nos."; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(16; "Bonus Payable A/c"; Code[10])
        {
            TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));
        }
        field(17; "Commission Payable A/C"; Code[10])
        {
            TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));
        }
        field(18; "Loan No. Series"; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(19; "Discount Allowed on Bond A/C"; Code[10])
        {
            TableRelation = "Payment Method";
        }
        field(20; "Pmt Sch. Posting No. Series"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(21; "Interest Payable A/C"; Code[10])
        {
            TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));
        }
        field(22; "Cheque in Hand"; Code[10])
        {
            TableRelation = "Payment Method";
        }
        field(23; "DD in Hand"; Code[10])
        {
            TableRelation = "Payment Method";
        }
        field(24; "Comm. No. Series"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(25; "Bonus No. Series"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(26; "Loan Surcharge %"; Decimal)
        {
        }
        field(27; "Loan Surcharge A/C"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(28; "Comm. Payable No. Series"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(29; "Bonus Payable No. Series"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(30; "Bonus on Mat. Payable A/c"; Code[10])
        {
            TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));
        }
        field(31; "Bonus on Mat. A/c"; Code[10])
        {
            TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));
        }
        field(32; "TDS Payable Commission A/c"; Code[10])
        {
            TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));
        }
        field(33; "Comm. Voucher Source Code"; Code[10])
        {
            TableRelation = "Source Code";
        }
        field(34; "Comm. No. Series (Full Chain)"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(35; "Bonus No. Series (Full Chain)"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(36; "Loan Interest %"; Decimal)
        {
        }
        field(37; "Loan Interest A/C"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(38; "Loan A/c"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(39; "Loan Posting No. Series"; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(40; "Dr. Source Code"; Code[10])
        {
            Caption = 'Debit Voucher Source Code';
            TableRelation = "Source Code";
        }
        field(41; "Bonus Dr. Source Code"; Code[10])
        {
            TableRelation = "Source Code";
        }
        field(42; "Cr. Source Code"; Code[10])
        {
            Caption = 'Credit Voucher Source Code';
            TableRelation = "Source Code";
        }
        field(43; "Loan Sch. Posting No. Series"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(45; "RoundingOff(Bonus)"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(46; "RoundingOff(Loan)"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(47; "Rounding Account(RD)"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(48; "NEFT Bank A/c"; Code[10])
        {
            TableRelation = "Bank Account";
        }
        field(49; "NEFT Posted To G/L No."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50; "NEFT Posted Doc No."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(51; "MIS Cut off Date"; Date)
        {
        }
        field(52; "MIS Cash Posting No Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(53; "MIS Cheque Posting No Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(54; "Advance MIS Cheque days"; DateFormula)
        {
        }
        field(55; "Service Charge Amount"; Decimal)
        {
            Caption = 'Service Charge Amount';
        }
        field(56; "Acknowledgement Nos."; Code[10])
        {
            Caption = 'Acknowledgement Nos.';
            TableRelation = "No. Series";
        }
        field(57; "Customer Template Code"; Code[10])
        {
            TableRelation = "Config. Template Header" WHERE("Table ID" = CONST(18));
        }
        field(58; "Service Charge Account"; Code[20])
        {
            TableRelation = "Payment Method";
        }
        field(59; "New Business Template"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(60; "Customer Posting Group"; Code[10])
        {
            TableRelation = "Customer Posting Group";
        }
        field(61; "Dl. Chrg Rounding Precision"; Decimal)
        {
            AutoFormatType = 1;
        }
        field(62; "Dl. Chrg Rounding Type"; Option)
        {
            OptionCaption = 'Nearest,Up,Down';
            OptionMembers = Nearest,Up,Down;
        }
        field(63; "TDS Nature of Deduction"; Code[10])
        {
            TableRelation = "TDS Section"; // "TDS Nature of Deduction";
        }
        field(64; "Cash Max. Amount"; Decimal)
        {
        }
        field(65; "Maturity Posted Doc No."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(66; "Customer Bank Code"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(67; "Comm Voucher Payment Period"; DateFormula)
        {
        }
        field(68; "Bonus Voucher Payment Period"; DateFormula)
        {
        }
        field(69; "Token No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(70; "Bonus Reversal A/c"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(71; "Comm. Voucher Threshold Amount"; Decimal)
        {
        }
        field(72; "Commission Validate Period"; DateFormula)
        {
        }
        field(73; "Vendor Template Code"; Code[10])
        {
            TableRelation = "Config. Template Header" WHERE("Table ID" = CONST(23));
        }
        field(75; "Rounding Account(Commission)"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(76; "MIS Cheque Limit"; Decimal)
        {
        }
        field(77; "Cheque Date Validity"; DateFormula)
        {
        }
        field(78; "Allow Backdated Posting"; Boolean)
        {
        }
        field(79; "Document Date"; Date)
        {
        }
        field(80; "Bonus Calculation"; Boolean)
        {
        }
        field(81; "Corpus %"; Decimal)
        {

            trigger OnValidate()
            begin
                "Incentive Club 9%" := "Corpus %";
            end;
        }
        field(82; "Corpus A/C"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(83; "Bond Reversal Control A/c"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(84; "Corpus Amt. Rounding Precision"; Decimal)
        {
            Caption = 'Corpus Amt. Rounding Precision';
            DecimalPlaces = 0 : 5;
            InitValue = 1;
        }
        field(85; "Registration No. Series"; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(86; "Revenue A/C"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(87; "Bond Penalty Control A/c"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(88; "Transfer A/c"; Code[10])
        {
            TableRelation = "Payment Method";
        }
        field(89; "Travel Amt. Rate"; Decimal)
        {
        }
        field(90; "Min limit for Travel"; Decimal)
        {
        }
        field(91; "Penalty No. Series"; Code[10])
        {
            TableRelation = "No. Series".Code;
        }
        field(92; "Customer No Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(93; "No. of Cheque Buffer Days"; DateFormula)
        {
            Description = 'BBG 151012';
        }
        field(50000; "D.C./C.C./Net Banking A/c No."; Code[10])
        {
            Description = 'BBG1.01';
            TableRelation = "Payment Method";
        }
        field(50001; "Travel Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(50002; "Travel Template Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Travel Template Name"));
        }
        field(50003; "Travel A/C"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50004; "TDS Nature of Deduction TA"; Code[10])
        {
            TableRelation = "TDS Section";// "TDS Nature of Deduction";
        }
        field(50005; "Travel No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50006; "Last Incent. Calculation Date"; Date)
        {
            Description = 'ALLEPG 061112';
        }
        field(50007; "Incentive No."; Code[10])
        {
            Description = 'ALLEPG 061112';
            TableRelation = "No. Series";
        }
        field(50008; "Incentive Summary No."; Code[10])
        {
            Description = 'ALLEPG 061112';
            TableRelation = "No. Series";
        }
        field(50009; "Incentive Summary Buffer No."; Code[10])
        {
            Description = 'ALLEPG 061112';
            TableRelation = "No. Series";
        }
        field(50010; "TDS Nature of Deduction INCT"; Code[10])
        {
            Caption = 'TDS Nature of Deduction Incentive';
            Description = 'ALLEPG 061112';
            TableRelation = "TDS Section";// "TDS Nature of Deduction";
        }
        field(50011; "Incentive A/C"; Code[10])
        {
            Description = 'ALLEPG 061112';
            TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));
        }
        field(50012; "Incentive Voucher Source Code"; Code[10])
        {
            Description = 'ALLEPG 061112';
            TableRelation = "Source Code";
        }
        field(50013; "Hierarchy Head"; Decimal)
        {
        }
        field(50014; "Voucher No. Series"; Code[20])
        {
            Description = 'For Commission,TA,Inc.';
            TableRelation = "No. Series";
        }
        field(50015; "Bank Voucher Template Name"; Code[20])
        {
            Description = 'ALLEPG 061112';
            TableRelation = "Gen. Journal Template";
        }
        field(50016; "Bank Voucher Batch Name"; Code[20])
        {
            Description = 'ALLEPG 061112';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Bank Voucher Template Name"));
        }
        field(50017; "Cash Voucher Template Name"; Code[20])
        {
            Description = 'ALLEPG 061112';
            TableRelation = "Gen. Journal Template";
        }
        field(50018; "Cash Voucher Batch Name"; Code[20])
        {
            Description = 'ALLEPG 061112';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Cash Voucher Template Name"));
        }
        field(50019; "Refund Cash A/C"; Code[10])
        {
            Description = 'ALLETDK061212';
            TableRelation = "Payment Method";
        }
        field(50020; "Refund Cheque A/C"; Code[10])
        {
            Description = 'ALLETDK061212';
            TableRelation = "Payment Method";
        }
        field(50022; "Posting Voucher No. Series"; Code[20])
        {
            Description = 'After Posting Voucher Commission,TA,Inc.';
            TableRelation = "No. Series";
        }
        field(50023; "Transfer Member Temp Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(50024; "Transfer Member Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Transfer Member Temp Name"));
        }
        field(50025; "Transfer Control Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50026; "Ch. Dt. After Days"; DateFormula)
        {
            Description = '050113';
        }
        field(50027; "Incentive Setup No. Series"; Code[20])
        {
            Description = '130113';
            TableRelation = "No. Series";
        }
        field(50028; "Associate to Member No. Series"; Code[20])
        {
            Description = 'ALLEDK 260113';
            TableRelation = "No. Series";
        }
        field(50029; "Member to Member No. Series"; Code[20])
        {
            Description = 'ALLEDK 260113';
            TableRelation = "No. Series";
        }
        field(50030; "Refund No. Series"; Code[20])
        {
            Description = 'ALLEDK 260113';
            TableRelation = "No. Series";
        }
        field(50031; "Discount No. Sereies"; Code[20])
        {
            Description = 'ALLEDK 270113';
            TableRelation = "No. Series";
        }
        field(50032; "Unit R/O"; Decimal)
        {
            Description = 'ALLEDK 160213';
        }
        field(50033; "Cheque Bounce JV No. Series"; Code[20])
        {
            Description = 'ALLETDK 180213';
            TableRelation = "No. Series";
        }
        field(50034; "Adjustment Entry No. Series"; Code[20])
        {
            Description = 'ALLETDK 240213';
            TableRelation = "No. Series";
        }
        field(50035; "Assoc. Recov. Temp Name"; Code[20])
        {
            Description = 'ALLETDK 010313';
            TableRelation = "Gen. Journal Template";
        }
        field(50036; "Assoc. Recov. Batch Name"; Code[20])
        {
            Description = 'ALLETDK 010313';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Assoc. Recov. Temp Name"));
        }
        field(50037; "Project Change JV Account"; Code[20])
        {
            Description = 'ALLETDK 010313';
            TableRelation = "G/L Account";
        }
        field(50038; "Last Date Commission"; Date)
        {
            Description = 'BBG1.00 020413';
            Editable = false;
        }
        field(50039; "Last Commission Generated By"; Code[50])
        {
            Description = 'BBG1.00 020413';
            Editable = false;
            TableRelation = User;
        }
        field(50040; "Incentive Club 9%"; Decimal)
        {
            Description = 'BBG1.00 210413';
        }
        field(50041; "Item No."; Code[20])
        {
            Description = 'BBG1.00 170613';
            TableRelation = Item;
        }
        field(50042; "LD Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50043; "Land Item No."; Code[20])
        {
            Description = 'ALLETDK';
            TableRelation = Item;
        }
        field(50044; "CORPUS Account"; Code[20])
        {
            Description = 'ALLETDK';
            TableRelation = "G/L Account";
        }
        field(50045; "Application Sales No. Series"; Code[20])
        {
            Description = 'ALLETDK';
            TableRelation = "No. Series";
        }
        field(50046; "ARM Doc TA No."; Code[20])
        {
            Description = 'BBG1.2 191213';
        }
        field(50047; "Forfeit Account"; Code[20])
        {
            Description = 'BBG1.6 311213';
            TableRelation = "G/L Account";
        }
        field(50048; "Excess Payment Account"; Code[20])
        {
            Description = 'BBG1.6 311213';
            TableRelation = "G/L Account";
        }
        field(50049; "BBG Discount Account"; Code[20])
        {
            Description = 'BBG1.6 311213';
            TableRelation = "G/L Account";
        }
        field(50050; "Post Inct Summary No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50051; "Post Incentive No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50052; "SMS Password"; Text[20])
        {
            ExtendedDatatype = Masked;
        }
        field(50053; "Incentive elegiblity App. AJVM"; Boolean)
        {
            Description = 'BBG2.00 300714';
        }
        field(50054; "SMS Start Date"; Date)
        {
            Description = 'BBG 2.00 120814';
        }
        field(50055; "Asso. Pmt Voucher No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50057; "Application Cutoff Amount"; Decimal)
        {
            Description = 'Cutoff Amount for Commission Report';
        }
        field(50058; "Application Cutoff Period"; DateFormula)
        {
            Description = 'Cutoff Period for Commission Report';
        }
        field(50059; "Posted TA Credit Memo"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50061; "Application Cutoff Period 2"; DateFormula)
        {
            DataClassification = ToBeClassified;
            Description = 'Cutoff Period for Commission Report';
        }
        field(50201; "Silver Coin Item No."; Code[20])
        {
            TableRelation = Item;
        }
        field(50301; "Report Run Date"; Date)
        {
            Description = 'Report 50011_50082';
        }
        field(50302; "Excel File Save Path"; Text[60])
        {
        }
        field(50303; "Report Run Start Date"; Date)
        {
            Description = 'Report 50041';
        }
        field(50304; "Report Run End Date"; Date)
        {
            Description = 'Report 50041';
        }
        field(50305; "Collection Cutoff Date"; Date)
        {
            Description = 'Report 50041';
        }
        field(50306; "Direct/Team"; Option)
        {
            Description = 'Report 50041';
            OptionCaption = 'Direct,Direct+Team';
            OptionMembers = Direct,"Direct+Team";
        }
        field(50307; "Incl. Uncleared Cheque"; Boolean)
        {
            Description = 'Report 50041';
        }
        field(50308; "Report Run Start Date_1"; Date)
        {
            Description = 'Report 50096';
        }
        field(50309; "Report Run End Date_1"; Date)
        {
            Description = 'Report 50096';
        }
        field(50310; "Collection Cutoff Date_1"; Date)
        {
            Description = 'Report 50096';
        }
        field(50311; "Direct/Team_1"; Option)
        {
            Description = 'Report 50096';
            OptionCaption = 'Direct,Direct+Team';
            OptionMembers = Direct,"Direct+Team";
        }
        field(50312; "Incl. Uncleared Cheque_1"; Boolean)
        {
            Description = 'Report 50096';
        }
        field(50313; "Show All Applications_1"; Boolean)
        {
            Description = 'Report 50096';
        }
        field(50314; "Report Run Start Date_2"; Date)
        {
            Description = 'Report 97782';
        }
        field(50315; "Report Run End Date_2"; Date)
        {
            Description = 'Report 97782';
        }
        field(50316; "Post Type Filter"; Option)
        {
            Description = 'Report 97782';
            OptionCaption = ' ,Incentive,CommissionTA';
            OptionMembers = " ",Incentive,CommissionTA;
        }
        field(50317; "Payment Filters"; Option)
        {
            Description = 'Report 97782';
            OptionCaption = 'Without Adjustment,With Adjustment';
            OptionMembers = "Without Adjustment","With Adjustment";
        }
        field(50318; "Bar Code no. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50319; "Report Batch No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50320; "Report to CC"; Code[60])
        {

            trigger OnValidate()
            begin
                Memberof.RESET;
                Memberof.SETRANGE("User Name", USERID);
                Memberof.SETRANGE(Memberof."Role ID", 'ReportToCC');
                IF NOT Memberof.FINDFIRST THEN
                    ERROR('You are not authorised person');
            end;
        }
        field(50321; "Sales G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50322; "Intercompany Sales NoSeries"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50323; "Intercompany Purchase NoSeries"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50324; "Intercompany Purch. NoSeries"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50325; "Intercompany Purch.Cr NoSeries"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50326; "Intercompany Sales Cr NoSeries"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50327; "Intercompany Purchase Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50328; "Intercompany Sales Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50329; "Purchase_Sales Vendor No."; Code[20])
        {
            TableRelation = Vendor;
        }
        field(50330; "Purchase_Sales Customer No."; Code[20])
        {
            TableRelation = Customer;
        }
        field(50331; "Payment Link"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'web';
        }
        field(50332; "Online Bank Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'web';
        }
        field(50333; "Customer Receipt Path"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'web';
        }
        field(50334; "Cash Amount Limit"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50335; "GST Group Code"; Code[20])
        {
            Caption = 'GST Group Code';
            DataClassification = ToBeClassified;
            TableRelation = "GST Group";

            trigger OnValidate()
            var
                GSTGroup: Record "GST Group"; // 16404;
                SalesReceivablesSetup: Record "Sales & Receivables Setup";
                GenJournalLine2: Record "Gen. Journal Line";
            begin
            end;
        }
        field(50336; "GST Group Type"; Option)
        {
            Caption = 'GST Group Type';
            DataClassification = ToBeClassified;
            Editable = true;
            OptionCaption = 'Goods,Service';
            OptionMembers = Goods,Service;
        }
        field(50337; "GST Place of Supply"; Option)
        {
            Caption = 'GST Place of Supply';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Bill-to Address,Ship-to Address,Location Address';
            OptionMembers = " ","Bill-to Address","Ship-to Address","Location Address";
        }
        field(50338; "HSN/SAC Code"; Code[8])
        {
            Caption = 'HSN/SAC Code';
            DataClassification = ToBeClassified;
            TableRelation = "HSN/SAC".Code WHERE("GST Group Code" = FIELD("GST Group Code"));

            trigger OnValidate()
            var
                GenJournalLine: Record "Gen. Journal Line";
            begin
            end;
        }
        field(50339; "Varita Sales GL Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50340; "Gold No. Series for Proj Chang"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50342; "Sales Threshold Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50343; "Land Agreement No.Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50344; "Land Agreement Exp. G/L No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50345; "Land Agreement Exp. Template"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50346; "Land Agreement Exp. Batch"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50347; "Land Refund Payment Template"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50348; "Land Refund Payment Batch"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50349; "Land Refund No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50351; "Development Charge A/C No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'BBG2.0';
        }
        field(50352; "Verita Bank"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";
        }
        field(50353; "Save Customer Receipt Path"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50354; "Associate Document Path"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50355; "Associate Mail Image Path"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50356; "Plot Vacate minutes"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50357; "Mobile URL Caption"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50358; "Mobile URL"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50359; "Online Booking Single Plot"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50360; "Online Booking Double Plot"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50361; "Android Update Forcefully"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50362; "IOS Version"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50363; "IOS Update Forcefullt"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50364; Pathsala_lable; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50365; "Android Version"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50366; "Allow No. of Associate Online"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50367; "Transfer Days for Option A"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(50368; "Transfer Days for Option B"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(50369; "Transfer Days for Option C"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(50370; "Customer Welcome letter Path"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50371; "Start Process Date for A-B-C"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Company: Record Company;
                vUnitSetup: Record "Unit Setup";
            begin
                Company.RESET;
                Company.SETFILTER(Name, '<>%1', COMPANYNAME);
                IF Company.FINDSET THEN
                    REPEAT
                        vUnitSetup.RESET;
                        vUnitSetup.CHANGECOMPANY(Company.Name);
                        IF vUnitSetup.GET THEN BEGIN
                            vUnitSetup."Start Process Date for A-B-C" := "Start Process Date for A-B-C";
                            vUnitSetup.MODIFY;
                        END;

                    UNTIL Company.NEXT = 0;
            end;
        }
        field(50372; "Buffer Days for Food Court"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(50373; "Android API URL"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'For Geo Fancing';
        }
        field(50374; "Android Version Name"; Text[20])
        {
            DataClassification = ToBeClassified;
            Description = 'For Geo Fancing';
        }
        field(50377; "No. Entries show in Mobile App"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50378; "Gamification Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50379; "Gamification End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50380; "Commission Batch Run Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50381; "Club9 General Journal Template"; Code[10])
        {
            Caption = 'Club9 General Journal Template';
            TableRelation = "Gen. Journal Template";
        }
        field(50382; "Club9 General Journal Batch"; Code[10])
        {
            Caption = 'Club9 General Journal Batch';
            TableRelation = "Gen. Journal Batch" where("Journal Template Name" = field("Club9 General Journal Template"));
        }
        field(50383; "Associate Mail Image"; BLOB)     //040225 Add new field
        {
            Caption = 'Associate Mail Image';
            SubType = Bitmap;

        }
        field(50384; "AJVM Transfer BankAccount Code"; Code[20])     //040225 Add new field
        {
            Caption = 'AJVM Transfer BankAccount Code';
            TableRelation = "Bank Account";
        }
        field(50385; "Stop Change color on Plot"; Boolean)     //040225 Add new field
        {
            Caption = 'Stop Change color on Plot';
            Editable = False;

        }

        field(50386; "Gold/Silver Voucher Item Code"; Code[20])     //040225 Add new field
        {
            Caption = 'Gold/Silver Voucher Item Code';


        }
        field(50387; "Gold/Silver Voucher Template"; Code[20])     //040225 Add new field
        {
            Caption = 'Gold/Silver Voucher Template Code';
            TableRelation = "Item Journal Template";
        }
        field(50388; "Gold/Silver Voucher Batch"; Code[20])     //040225 Add new field
        {
            Caption = 'Gold/Silver Voucher Batch Code';
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("Gold/Silver Voucher Template"));
        }

        field(50389; "Gift Control A/c"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50390; "Perquisite to Associates Exp."; Code[20])
        {
            Caption = 'Perquisite to Associates (Expenses)';
            TableRelation = "G/L Account";
        }

        field(50391; "TDS Nature of Deducation 194R"; Code[20])
        {
            Caption = '194R-TDS Nature of Deducation';
            TableRelation = "TDS Section";

        }
        field(50392; "Gift Inventory Account"; Code[20])
        {
            Caption = 'Gift Inventory Account';
            TableRelation = "G/L Account";
        }

        field(50393; "Gift Vendor Rank Code"; Decimal)
        {
            Caption = 'Gift Vendor Rank Code';
            TableRelation = Rank.Code;
        }

    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        //ALLECK 060313 START
        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETRANGE("Role ID", 'A_UNITSETUP');
        IF NOT Memberof.FINDFIRST THEN
            ERROR('You do not have permission of role:A_UNITSETUP');
        //ALLECK 060313 End
    end;

    var
        BondPostingGrp: Record "Unit Setup";
        Memberof: Record "Access Control";
        Itm: Record "Item Journal Line";

}

