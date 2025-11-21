table 97769 "Bonus Entry Posted Adjustment"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Editable = false;
        }
        field(2; "Unit No."; Code[20])
        {
            TableRelation = "Confirmed Order";
        }
        field(3; "Posting Date"; Date)
        {
        }
        field(4; "Associate Code"; Code[20])
        {
            Caption = 'Associate Code';
            TableRelation = Vendor;
        }
        field(5; "Base Amount"; Decimal)
        {
        }
        field(6; "Bonus %"; Decimal)
        {
        }
        field(7; "Bonus Amount"; Decimal)
        {
        }
        field(8; "Installment No."; Integer)
        {
        }
        field(9; "Bond Category"; Option)
        {
            Description = 'MPS1.0';
            Editable = false;
            OptionMembers = "A Type","B Type";
        }
        field(10; "Business Type"; Option)
        {
            OptionCaption = 'SELF,CHAIN';
            OptionMembers = SELF,CHAIN;
        }
        field(11; "Introducer Code"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(12; "Scheme Code"; Code[20])
        {
        }
        field(13; "Project Type"; Code[20])
        {
            TableRelation = "Unit Type".Code;
        }
        field(14; Duration; Integer)
        {
        }
        field(15; "Paid To"; Code[20])
        {
            Editable = true;
            TableRelation = Vendor;
        }
        field(16; "Posted Doc. No."; Code[20])
        {
            Editable = true;
        }
        field(17; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Description = 'Payable';
        }
        field(18; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'Payable';
        }
        field(19; "Unit Office Code(Paid)"; Code[20])
        {
            Caption = 'Unit Office Code(Paid)';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(20; "Counter Code(Paid)"; Code[20])
        {
            Caption = 'Counter Code(Paid)';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(21; "Associate Rank"; Integer)
        {
        }
        field(23; "Pmt Received From Code"; Code[20])
        {
            Editable = true;
            TableRelation = Vendor;
        }
        field(24; "Document Date"; Date)
        {
        }
        field(26; "G/L Posting Date"; Date)
        {
        }
        field(27; "G/L Document Date"; Date)
        {
        }
        field(28; "Token No."; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Unit No.", "Installment No.")
        {
            SumIndexFields = "Base Amount", "Bonus Amount";
        }
        key(Key3; "Unit Office Code(Paid)", "Associate Code", "Business Type", "Introducer Code", Duration, "Unit No.", "Posting Date", "Posted Doc. No.")
        {
        }
        key(Key4; "Posted Doc. No.", "Posting Date", "Unit Office Code(Paid)", "Counter Code(Paid)", "Pmt Received From Code")
        {
        }
        key(Key5; "Paid To", "G/L Posting Date", "Associate Code", "Posted Doc. No.")
        {
        }
        key(Key6; "Associate Code", "Business Type", "Bond Category", "Posting Date", Duration)
        {
            SumIndexFields = "Base Amount", "Bonus Amount";
        }
        key(Key7; "Posted Doc. No.", "Paid To", "Associate Code", "Business Type", "G/L Posting Date")
        {
        }
    }

    fieldgroups
    {
    }
}

