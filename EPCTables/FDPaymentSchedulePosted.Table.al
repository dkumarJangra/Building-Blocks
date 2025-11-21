table 97759 "FD Payment Schedule Posted"
{
    DrillDownPageID = "Rank Card";
    LookupPageID = "Rank Card";

    fields
    {
        field(1; "Unit No."; Code[20])
        {
            Editable = true;
            TableRelation = "Confirmed Order";
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Scheme Code"; Code[20])
        {
            Editable = true;
        }
        field(4; "Project Type"; Code[20])
        {
            TableRelation = "Unit Type";
        }
        field(5; "Customer No."; Code[20])
        {
            TableRelation = Customer;
        }
        field(6; Duration; Integer)
        {
        }
        field(7; "Bond Posting Group"; Code[20])
        {
            TableRelation = "Confirmed Order";
        }
        field(8; "Payment Mode"; Option)
        {
            OptionCaption = ' ,Cash,Cheque,D.D.,Banker''s Cheque,P.O.,Cheque by Post,NEFT';
            OptionMembers = " ",Cash,Cheque,"D.D.","Banker's Cheque","P.O.","Cheque by Post",NEFT;
        }
        field(9; Amount; Decimal)
        {
        }
        field(10; "Original Amount"; Decimal)
        {
        }
        field(12; "Due Date"; Date)
        {
        }
        field(13; "Interest Amount"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(14; "Introducer Code"; Code[20])
        {
            Caption = 'Introducer Code';
            TableRelation = Vendor;
        }
        field(15; "Installment No."; Integer)
        {
        }
        field(16; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(17; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(18; "Year Code"; Integer)
        {
        }
        field(19; "Posted Doc. No."; Code[20])
        {
        }
        field(20; "Payment A/C Code"; Code[10])
        {
            TableRelation = "Bank Account";
        }
        field(21; "Bond Date"; Date)
        {
            Editable = true;
        }
        field(22; "Bond Category"; Option)
        {
            Editable = false;
            OptionMembers = "A Type","B Type";
        }
        field(23; "Paid To/Received From"; Option)
        {
            Editable = true;
            OptionMembers = " ","Marketing Member","Bond Holder";
        }
        field(24; "Paid To/Received From Code"; Code[20])
        {
            Editable = true;
            TableRelation = IF ("Paid To/Received From" = CONST("Marketing Member")) Vendor."No."
            ELSE IF ("Paid To/Received From" = CONST("Bond Holder")) Customer."No.";
        }
        field(26; "Posting Date"; Date)
        {
        }
        field(27; "Unit Office Code(Paid)"; Code[20])
        {
            Caption = 'Unit Office Code(Paid)';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(28; "Counter Code(Paid)"; Code[20])
        {
            Caption = 'Counter Code(Paid)';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(30; "Version No."; Integer)
        {
        }
        field(31; "Document Date"; Date)
        {
        }
        field(32; "Posted By User ID"; Code[20])
        {
        }
        field(33; "Entry Type"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Payment,Interest,Principal,Interest + Principal';
            OptionMembers = " ",Payment,Interest,Principal,"Interest + Principal";
        }
        field(34; "Cheque Date"; Date)
        {
        }
        field(35; "Cheque No."; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "Unit No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        recCustomer: Record Customer;
        gl: Record "G/L Entry";
}

