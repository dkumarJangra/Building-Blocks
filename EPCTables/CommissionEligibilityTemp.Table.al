table 97860 "Commission Eligibility Temp"
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
            Editable = false;
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
        key(Key11; "Associate Code", "Application No.", "Posting Date")
        {
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
        key(Key15; "Posting Date")
        {
        }
    }

    fieldgroups
    {
    }
}

