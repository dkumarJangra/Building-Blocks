table 50076 "New Commission Entry-1"
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
            CalcFormula = Lookup("Confirmed Order"."Registration Bonus Hold(BSP2)" WHERE("No." = FIELD("Application No.")));
            Description = 'BBG1.00 210613';
            Editable = false;
            FieldClass = FlowField;
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
        field(50017; "User ID"; Code[20])
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
    }

    fieldgroups
    {
    }
}

