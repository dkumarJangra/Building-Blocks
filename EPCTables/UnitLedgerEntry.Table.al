table 97800 "Unit Ledger Entry"
{
    Caption = 'Bond Ledger Entry';
    DrillDownPageID = "Unit Ledger Entry List";
    LookupPageID = "Unit Ledger Entry List";

    fields
    {
        field(1; "Line No."; Integer)
        {
        }
        field(2; "Investment Type"; Option)
        {
            OptionCaption = ' ,RD,FD,MIS';
            OptionMembers = " ",RD,FD,MIS;
        }
        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(6; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(7; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(8; "Unit No."; Code[20])
        {
            Caption = 'Unit No.';
            TableRelation = "Confirmed Order";
        }
        field(9; "Project Type"; Code[20])
        {
            Caption = 'Project Type';
        }
        field(10; "Scheme Code"; Code[20])
        {
            Caption = 'Scheme Code';
        }
        field(11; "Version No."; Integer)
        {
            Caption = 'Version No.';
        }
        field(12; "Bond Category"; Option)
        {
            Caption = 'Bond Category';
            OptionCaption = 'A,B';
            OptionMembers = A,B;
        }
        field(13; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(14; "Associate Code"; Code[20])
        {
            Caption = 'Associate Code';
            TableRelation = Vendor;
        }
        field(15; Duration; Integer)
        {
            Caption = 'Duration';
        }
        field(17; "Installment No."; Integer)
        {
            Caption = 'Installment No.';
        }
        field(21; "Original Amount"; Decimal)
        {
            Caption = 'Original Amount';
        }
        field(22; "Discount Amount"; Decimal)
        {
            Caption = 'Discount Amount';
        }
        field(23; "Late Fine"; Decimal)
        {
        }
        field(24; "Late Fine Collected By Cash"; Boolean)
        {
            Caption = 'Late Fine Collected By Cash';
        }
        field(29; "Cheque Clearance Date"; Date)
        {
            Caption = 'Cheque Clearance Date';
        }
        field(32; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(33; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(34; "User ID"; Code[20])
        {
            Caption = 'User ID';
        }
    }

    keys
    {
        key(Key1; "Unit No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Original Amount";
        }
        key(Key2; "Associate Code", "Posting Date")
        {
            SumIndexFields = "Original Amount";
        }
        key(Key3; "Unit No.", "Installment No.")
        {
        }
        key(Key4; "Scheme Code", "Posting Date", "Associate Code")
        {
        }
    }

    fieldgroups
    {
    }
}

