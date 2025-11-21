table 97798 "Unit Maturity"
{
    Caption = 'Bond Maturity';
    DrillDownPageID = "Unit Maturity List";
    LookupPageID = "Unit Maturity List";

    fields
    {
        field(1; "Unit No."; Code[20])
        {
            Caption = 'Unit No.';
            Editable = false;
            TableRelation = "Confirmed Order";
        }
        field(2; "Maturity Type"; Option)
        {
            Caption = 'Maturity Type';
            OptionCaption = ' ,Full Maturity,Defaulting Maturity,Prematurity,Early Redemption';
            OptionMembers = " ","Full Maturity","Defaulting Maturity",Prematurity,"Early Redemption";
        }
        field(3; "Effective Date"; Date)
        {
            Caption = 'Effective Date';
        }
        field(4; Duration; Integer)
        {
            Caption = 'Duration';
            Editable = false;
        }
        field(5; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(6; "Interest Amount"; Decimal)
        {
            Caption = 'Interest Amount';
            Editable = true;
        }
        field(7; "User ID"; Code[20])
        {
            Caption = 'User ID';
            Editable = false;
        }
        field(8; "Marking Date"; Date)
        {
            Caption = 'Marking Date';
            Editable = false;
        }
        field(9; "Return Payment Mode"; Option)
        {
            Caption = 'Return Payment Mode';
            OptionCaption = 'Cash,Cheque,D.D.,Banker''s Cheque,P.O.,Cheque by Post';
            OptionMembers = Cash,Cheque,"D.D.","Banker's Cheque","P.O.","Cheque by Post";
        }
        field(10; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = ' ,Released,Cheque Printed,Posted';
            OptionMembers = " ",Released,"Cheque Printed",Posted;
        }
        field(11; "Cheque No."; Code[10])
        {
            Caption = 'Cheque No.';
            Editable = false;
        }
        field(12; "Cheque Date"; Date)
        {
            Caption = 'Cheque Date';
        }
        field(13; "Bank Code"; Code[10])
        {
            Caption = 'Bank Code';
            TableRelation = "Bank Account";
        }
        field(14; "Posted Doc. No."; Code[20])
        {
            Editable = false;
        }
        field(15; "Bonus Amount"; Decimal)
        {
            Editable = false;
        }
        field(16; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(17; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(18; "Posting Date"; Date)
        {
            Editable = false;
        }
        field(19; "Document Date"; Date)
        {
            Editable = false;
        }
        field(20; "Paid To"; Option)
        {
            Editable = true;
            OptionMembers = " ","Marketing Member","Bond Holder";
        }
        field(21; "Paid To Code"; Code[20])
        {
            Editable = true;
            TableRelation = IF ("Paid To" = CONST("Marketing Member")) Vendor."No."
            ELSE IF ("Paid To" = CONST("Bond Holder")) Customer."No.";
        }
        field(22; "Death Claim"; Boolean)
        {
            Editable = false;
        }
        field(23; "Prematurity Duration"; Decimal)
        {
            Editable = false;

            trigger OnLookup()
            begin
                //vNewDuration := ((vPrematurityDate - recBond."Application Date")-1) / 30;
            end;
        }
        field(24; "Unit Office Code(Paid)"; Code[20])
        {
            Caption = 'Unit Office Code(Paid)';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(25; "Counter Code(Paid)"; Code[20])
        {
            Caption = 'Counter Code(Paid)';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(26; "Last Modified User ID"; Code[20])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Unit No.")
        {
            Clustered = true;
        }
        key(Key2; Status, "Return Payment Mode", "Unit No.", "Maturity Type")
        {
        }
        key(Key3; Status, "Unit No.", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Posting Date", "Return Payment Mode", "Maturity Type")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        BondMaturity: Record "Unit Maturity";
    begin
        BondMaturity.SETRANGE("Unit No.", "Unit No.");
        IF BondMaturity.COUNT > 1 THEN
            ERROR(Text001, "Unit No.");
    end;

    var
        Text001: Label 'Bond %1 already exist.';


    procedure EffectiveDuration(): Integer
    var
        Bond: Record "Confirmed Order";
    begin
        IF "Effective Date" <> 0D THEN BEGIN
            Bond.GET("Unit No.");
            EXIT("Effective Date" - Bond."Posting Date");
        END;
    end;
}

