table 97810 "Bonus Posting Buffer"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Editable = true;
        }
        field(3; "Unit No."; Code[20])
        {
            TableRelation = "Confirmed Order";
        }
        field(4; "Posting Date"; Date)
        {
        }
        field(5; "Associate Code"; Code[20])
        {
            Caption = 'Associate Code';
            TableRelation = Vendor;
        }
        field(6; "Base Amount"; Decimal)
        {
        }
        field(7; "Bonus Amount"; Decimal)
        {
            DecimalPlaces = 2 :;
        }
        field(8; "Installment No."; Integer)
        {
        }
        field(9; "Business Type"; Option)
        {
            OptionCaption = 'SELF,CHAIN';
            OptionMembers = SELF,CHAIN;
        }
        field(10; "Introducer Code"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(11; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Description = 'Payable';
        }
        field(12; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'Payable';
        }
        field(13; Duration; Integer)
        {
        }
        field(14; "Paid To"; Code[20])
        {
            Editable = true;
            TableRelation = Vendor;
        }
        field(15; "Posted Doc. No."; Code[20])
        {
            Editable = true;
        }
        field(16; "G/L Posting Date"; Date)
        {
        }
        field(20; "Unit Office Code(Paid)"; Code[20])
        {
            Caption = 'Unit Office Code(Paid)';
        }
        field(21; "Counter Code(Paid)"; Code[20])
        {
            Caption = 'Counter Code(Paid)';
        }
        field(22; "Associate Rank"; Decimal)
        {
            Description = 'BBG1.00 ALLEDK 090313 change data type integer to decimal';
        }
        field(23; "Pmt Received From Code"; Code[20])
        {
            Editable = true;
            TableRelation = Vendor;
        }
        field(25; "Document Date"; Date)
        {
        }
        field(26; "G/L Document Date"; Date)
        {
        }
        field(28; Status; Option)
        {
            OptionCaption = 'Open,Posted,Deleted';
            OptionMembers = Open,Posted,Deleted;
        }
        field(29; "Chain Type"; Option)
        {
            OptionCaption = 'Spot,Full Chain,Monthly';
            OptionMembers = Spot,"Full Chain",Monthly;
        }
        field(30; "Token No."; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Counter Code(Paid)")
        {
            Clustered = true;
        }
        key(Key2; "Unit No.", "Installment No.", Status)
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
        key(Key6; "Counter Code(Paid)", Status)
        {
        }
        key(Key7; "Token No.")
        {
        }
        key(Key8; Status, "Posted Doc. No.", "G/L Posting Date", "Paid To", "Associate Code")
        {
        }
        key(Key9; Status, "Associate Code", "Posted Doc. No.", "G/L Posting Date", "Paid To")
        {
        }
    }

    fieldgroups
    {
    }
}

