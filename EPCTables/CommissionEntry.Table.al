table 97805 "Commission Entry"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Editable = true;
        }
        field(2; "Application No."; Code[20])
        {
            TableRelation = "Confirmed Order";
        }
        field(3; "Posting Date"; Date)
        {
        }
        field(4; "Associate Code"; Code[20])
        {
            Caption = 'Associate Code';
            TableRelation = Vendor WHERE("BBG Vendor Category" = FILTER("IBA(Associates)"));
        }
        field(5; "Base Amount"; Decimal)
        {
        }
        field(6; "Commission %"; Decimal)
        {
        }
        field(7; "Commission Amount"; Decimal)
        {
            DecimalPlaces = 2 :;
        }
        field(8; "On Hold"; Boolean)
        {
            Editable = true;
        }
        field(9; "Installment No."; Integer)
        {
        }
        field(10; "Bond Category"; Option)
        {
            Description = 'MPS1.0';
            OptionMembers = "A Type","B Type";
        }
        field(11; "Business Type"; Option)
        {
            OptionCaption = 'SELF,CHAIN';
            OptionMembers = SELF,CHAIN;
        }
        field(12; "Introducer Code"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(13; "Scheme Code"; Code[20])
        {
        }
        field(14; "Project Type"; Code[20])
        {
            TableRelation = "Unit Type".Code;
        }
        field(15; Duration; Integer)
        {
        }
        field(16; "Associate Rank"; Decimal)
        {
        }
        field(17; "Voucher No."; Code[20])
        {
            Editable = true;
        }
        field(23; "First Year"; Boolean)
        {
            Caption = 'First Year';
        }
        field(24; Reversal; Boolean)
        {
        }
        field(25; "TDS %"; Decimal)
        {
            Enabled = false;
        }
        field(26; "TDS Amount"; Decimal)
        {
            Enabled = false;
        }
        field(27; "Direct to Associate"; Boolean)
        {
        }
        field(28; "Remaining Amt of Direct"; Boolean)
        {
            Description = 'In case of Direct commission payment';
        }
        field(29; "Remaining Amount"; Decimal)
        {
            Description = 'Balance commision amount for payment';
            Editable = true;
        }
        field(50002; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50003; Discount; Boolean)
        {
        }
        field(50004; Posted; Boolean)
        {
        }
        field(50005; "Opening Entries"; Boolean)
        {
            Editable = true;
        }
        field(50006; "Adjust Remaining Amt"; Boolean)
        {
        }
        field(50007; "Before update Rem Amount"; Decimal)
        {
            Description = 'BBG1.00 060513';
        }
        field(50008; Remark; Text[60])
        {
        }
        field(50009; CreditMemo; Boolean)
        {
        }
        field(50010; "Registration Bonus Hold(BSP2)"; Boolean)
        {
            Description = 'BBG1.00 210613';
            Editable = false;
        }
        field(50011; "Remaning amt new"; Decimal)
        {
        }
        field(50012; "Record find on VLE"; Boolean)
        {
        }
        field(50013; "Previouse Remaing Amt 210713"; Decimal)
        {
            Description = 'BBG1.00';
        }
        field(50014; Reverse2; Boolean)
        {
        }
        field(50015; "Manual Opening RB"; Boolean)
        {
        }
        field(50016; "For Testing"; Boolean)
        {
        }
        field(50017; "User ID"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(50018; "Commission Run Date"; Date)
        {
            Editable = true;
        }
        field(50019; "Charge Code"; Code[10])
        {
            Editable = true;
        }
        field(50020; "Unit Payment Line No."; Integer)
        {
        }
        field(50021; "Application DOJ"; Date)
        {
            CalcFormula = Lookup("Confirmed Order"."Posting Date" WHERE("No." = FIELD("Application No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50022; "Company Name"; Text[30])
        {
            Editable = false;
            TableRelation = Company;
        }
        field(50024; RecordFind; Boolean)
        {
        }
        field(50025; "Check Record"; Boolean)
        {
        }
        field(50026; "Check Comm Amt"; Decimal)
        {
        }
        field(50027; "Pmt User ID"; Code[20])
        {
        }
        field(50028; "Pmt Date Time"; DateTime)
        {
        }
        field(50029; "Commission Revs. by RefundCheq"; Boolean)
        {
            Description = 'ALLE270415 Commission reversed by Refund Cheque';
        }
        field(50030; "Refund considered in Ref. Rev."; Boolean)
        {
            Description = 'ALLE270415 Refund entries considered in undo Refund reversal';
        }
        field(50031; "Refund Entry with Comm Rev."; Boolean)
        {
            CalcFormula = Lookup("Application Payment Entry"."Commission Reversed" WHERE("Commission Reversed" = FILTER(true),
                                                                                          "Document No." = FIELD("Application No.")));
            FieldClass = FlowField;
        }
        field(50041; "Entry Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'INS1.0';
            Editable = false;
        }
        field(50050; "Create Credit memo from batch"; Boolean)
        {
            Editable = false;
        }
        field(50051; "Commission Transfered"; Boolean)
        {
        }
        field(50100; "TDS Deducted on Invoice"; Decimal)
        {
            CalcFormula = Sum("TDS Entry"."TDS Amount" WHERE("Document Type" = FILTER(Invoice),
                                                              "Document No." = FIELD("Voucher No.")));
            FieldClass = FlowField;
        }
        field(60000; "Check Entry Exists"; Boolean)
        {
        }
        field(60001; "Vizag data"; Boolean)
        {
        }
        field(60002; "Old Posted"; Boolean)
        {
        }
        field(60003; "Transfer Entry"; Boolean)
        {
        }
        field(60004; "Invoice Date"; Date)
        {
            Editable = true;
        }
        field(60005; "Comm Rev from Batch"; Boolean)
        {
        }
        field(60006; "Old company Name"; Text[30])
        {
            Editable = false;
            TableRelation = Company;
        }
        field(60007; Month_1; Integer)
        {
        }
        field(60008; Year_1; Integer)
        {
        }
        field(60009; "Invoice Post Date"; Date)
        {
        }
        field(60010; "App Transfered"; Boolean)
        {
            Editable = false;
        }
        field(60011; "Associate Block"; Boolean)
        {
            CalcFormula = Lookup(Vendor."BBG Black List" WHERE("No." = FIELD("Associate Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60012; "GNV No"; Boolean)
        {
            Editable = false;
        }
        field(60013; "Voucher Posting Date"; Date)
        {
            CalcFormula = Lookup("Vendor Ledger Entry"."Posting Date" WHERE("Document No." = FIELD("Voucher No.")));
            FieldClass = FlowField;
        }
        field(60014; "TDS Base Amount"; Decimal)
        {
            CalcFormula = Sum("TDS Entry"."TDS Base Amount" WHERE("Document Type" = FILTER(Invoice),
                                                                   "Document No." = FIELD("Voucher No.")));
            FieldClass = FlowField;
        }
        field(60015; "App Transfer in LLP"; Boolean)
        {
            Editable = false;
        }
        field(60016; "Post Date 1"; Date)
        {
            CalcFormula = Lookup("G/L Entry"."Posting Date" WHERE("Document No." = FIELD("Voucher No.")));
            FieldClass = FlowField;
        }
        field(60017; "Post Date 2"; Date)
        {
            CalcFormula = Lookup("G/L Entry"."Posting Date" WHERE("External Document No." = FIELD("Voucher No.")));
            FieldClass = FlowField;
        }
        field(60018; "Apply Value"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60019; "Project Change Diff Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60020; "TDS Adjust Entry"; Boolean)
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
        key(Key2; "Application No.", "Installment No.", "Voucher No.")
        {
        }
        key(Key3; "Voucher No.", "Associate Code", "Business Type", "Introducer Code", "Project Type", "Scheme Code", Duration, "Application No.", "Posting Date", "On Hold")
        {
        }
        key(Key4; "Associate Code", "Business Type", "Introducer Code", "Project Type", "Scheme Code", Duration, "Application No.", "Posting Date", "On Hold")
        {
            SumIndexFields = "Base Amount", "Commission Amount";
        }
        key(Key5; "Associate Code", "Bond Category", "Posting Date", "On Hold", "Voucher No.")
        {
        }
        key(Key6; "Associate Code", "Business Type", "Bond Category", "Posting Date", "On Hold", Duration, "Installment No.", "First Year", "Scheme Code", "Voucher No.")
        {
            SumIndexFields = "Base Amount", "Commission Amount";
        }
        key(Key7; "Application No.", "Associate Code", "Commission %")
        {
        }
        key(Key8; "Voucher No.", "Posting Date", "Associate Code")
        {
        }
        key(Key9; "Associate Code", "Posting Date")
        {
        }
        key(Key10; "Application No.", "Voucher No.", "Associate Code", "Commission Amount")
        {
            SumIndexFields = "Base Amount", "Commission Amount";
        }
        key(Key11; "Associate Code", "Application No.", "Posting Date", Discount, "Opening Entries", "Direct to Associate", "Remaining Amt of Direct", "Registration Bonus Hold(BSP2)")
        {
            SumIndexFields = "Commission Amount";
        }
        key(Key12; "Associate Code", "Shortcut Dimension 1 Code", "Application No.")
        {
        }
        key(Key13; "Application No.", "Associate Code", "Business Type", "Direct to Associate", "Introducer Code")
        {
            SumIndexFields = "Base Amount", "Commission Amount";
        }
        key(Key14; "Application No.", "Associate Rank", "Associate Code", "Commission %")
        {
        }
        key(Key15; "Shortcut Dimension 1 Code")
        {
        }
        key(Key16; "Associate Code", "Posting Date", "Opening Entries", "Remaining Amt of Direct")
        {
        }
        key(Key17; "Posting Date")
        {
        }
        key(Key18; "Associate Code", "Commission Run Date")
        {
        }
        key(Key19; "Application No.", "Charge Code", "Business Type", "Direct to Associate")
        {
            SumIndexFields = "Base Amount";
        }
        key(Key20; "Application No.", "Business Type", "Opening Entries", "Direct to Associate")
        {
            SumIndexFields = "Base Amount";
        }
        key(Key21; "Commission Run Date")
        {
        }
        key(Key22; "Application No.", "Business Type", "Direct to Associate", "Commission Amount")
        {
            SumIndexFields = "Base Amount";
        }
        key(Key23; "Associate Code", "Entry No.", Posted, "Commission Amount")
        {
        }
        key(Key24; "Associate Code", "Remaining Amount", "Opening Entries")
        {
        }
        key(Key25; "Associate Code", "Posting Date", Posted, "Remaining Amt of Direct", "Opening Entries")
        {
        }
        key(Key26; "Associate Code", "Voucher No.")
        {
        }
        key(Key27; "Vizag data", "Associate Code")
        {
        }
        key(Key28; Posted, "Opening Entries")
        {
        }
        key(Key29; "Old company Name", "Associate Code", "Invoice Post Date")
        {
        }
        key(Key30; "Associate Code", Year_1, Month_1)
        {
        }
        key(Key31; "Application No.", "Direct to Associate", Posted)
        {
        }
        key(Key32; "Application No.", "Voucher No.", Posted, "Invoice Date")
        {
            SumIndexFields = "Commission Amount";
        }
        key(Key33; "Application No.", "Apply Value", Posted, "Associate Code")
        {
        }
    }

    fieldgroups
    {
    }
}

