table 97808 "Commission Entry Posted"
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
        field(6; "Commission %"; Decimal)
        {
        }
        field(7; "Commission Amount"; Decimal)
        {
        }
        field(9; "Installment No."; Integer)
        {
        }
        field(10; "Bond Category"; Option)
        {
            Editable = false;
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
            TableRelation = "Document Type Initiator"."Document Type" WHERE("Posting User Code" = FIELD("Project Type"));
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
        field(18; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(19; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(20; "Posted Doc. No."; Code[20])
        {
        }
        field(21; "G/L Posting Date"; Date)
        {
        }
        field(22; "G/L Document Date"; Date)
        {
        }
        field(23; "First Year"; Boolean)
        {
            Caption = 'First Year';
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
        }
        key(Key3; "Shortcut Dimension 1 Code", "Associate Code", "Business Type", "Introducer Code", "Project Type", "Scheme Code", Duration, "Unit No.", "Posting Date", "Voucher No.", "Posted Doc. No.")
        {
            SumIndexFields = "Base Amount", "Commission Amount";
        }
        key(Key4; "Voucher No.", "Associate Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")
        {
        }
        key(Key5; "Associate Code", "Business Type", "Bond Category", "Posting Date", Duration, "Installment No.", "First Year", "Scheme Code")
        {
            SumIndexFields = "Base Amount", "Commission Amount";
        }
    }

    fieldgroups
    {
    }
}

