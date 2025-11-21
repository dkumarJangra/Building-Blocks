table 97806 "Commission Voucher"
{
    Caption = 'Commission Voucher';
    DrillDownPageID = "Member to Member list";
    LookupPageID = "Member to Member list";

    fields
    {
        field(1; "Voucher No."; Code[20])
        {
        }
        field(2; "Voucher Date"; Date)
        {
        }
        field(3; "Associate Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = Vendor;
        }
        field(4; "Base Amount"; Decimal)
        {
        }
        field(5; "Commission Amount"; Decimal)
        {
        }
        field(6; "Payment Mode"; Option)
        {
            OptionCaption = ' ,Cash,Cheque,D.D.,Transfer,D.C./C.C./Net Banking';
            OptionMembers = " ",Cash,Cheque,"D.D.",Transfer,"D.C./C.C./Net Banking";

            trigger OnValidate()
            var
                BondSetup: Record "Unit Setup";
            begin
                BondSetup.GET;
                IF "Payment Mode" = "Payment Mode"::Cash THEN
                    "Payment A/C Code" := BondSetup."Cash A/c No.";
            end;
        }
        field(7; "Payment A/C Code"; Code[20])
        {
            TableRelation = IF ("Payment Mode" = FILTER(<> Cash)) "Bank Account";
        }
        field(8; "Cheque No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF ("Cheque No." <> '') AND NOT (STRLEN("Cheque No.") IN [6, 7]) THEN
                    ERROR(Text0001);
            end;
        }
        field(9; "Cheque Date"; Date)
        {

            trigger OnValidate()
            var
                BondSetup: Record "Unit Setup";
            begin
            end;
        }
        field(16; "Commission Voucher Printed"; Boolean)
        {
        }
        field(17; Category; Option)
        {
            Editable = false;
            OptionMembers = "A Type","B Type";
        }
        field(18; "TDS Amount"; Decimal)
        {
        }
        field(19; "Cheque Status"; Option)
        {
            OptionMembers = " ","With Cheque","Cheque Printed","Cheque Released";
        }
        field(21; "TDS Applicable"; Boolean)
        {
        }
        field(22; Month; Integer)
        {
        }
        field(23; Year; Integer)
        {
        }
        field(24; "Month Last Date"; Date)
        {
        }
        field(25; "Voucher Printing Date"; Date)
        {
        }
        field(26; "TDS/TCS %"; Decimal)
        {
            Caption = 'TDS/TCS %';
            Editable = false;
        }
        field(27; "Clube 9 Charge Amount"; Decimal)
        {
        }
        field(28; Status; Option)
        {
            OptionCaption = 'Open,Posted,Deleted';
            OptionMembers = Open,Posted,Deleted;
        }
        field(29; Type; Option)
        {
            OptionCaption = ' ,Travel';
            OptionMembers = " ",Travel;
        }
        field(30; "Ready for Payment"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Voucher No.")
        {
            Clustered = true;
        }
        key(Key2; "Cheque Status", "Commission Voucher Printed", "Voucher No.")
        {
        }
        key(Key3; "Associate Code", Month, Year)
        {
            SumIndexFields = "Base Amount", "Commission Amount", "TDS Amount";
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        TESTFIELD("Associate Code");
        IF "Payment Mode" <> "Payment Mode"::Cash THEN BEGIN
            TESTFIELD("Cheque No.");
            TESTFIELD("Cheque Date");
            //TESTFIELD("Bank Code");
            IF NOT (("Cheque Date" >= WORKDATE) AND ("Cheque Date" < CALCDATE('6M', WORKDATE))) THEN
                ERROR(Text0002);
        END;
    end;

    trigger OnModify()
    begin
        TESTFIELD("Associate Code");
        IF "Payment Mode" <> "Payment Mode"::Cash THEN BEGIN
            TESTFIELD("Cheque No.");
            TESTFIELD("Cheque Date");
            //TESTFIELD("Bank Code");
            IF NOT (("Cheque Date" >= WORKDATE) AND ("Cheque Date" < CALCDATE('6M', WORKDATE))) THEN
                ERROR(Text0002);
        END;
    end;

    var
        PaymentMethod: Record "Payment Method";
        Text0001: Label 'Please enter a valid check no.';
        Text0002: Label 'Please enter a valid check date.';
        Text0003: Label 'You cannot change Line No. %1.';
        Text0004: Label 'Cheque Already Cleared and Posted';
        Text0005: Label 'Payment Mode is %1';
        Text0006: Label 'Please enter Cheque Clearance Date';


    procedure NetCommissionAmount(): Decimal
    begin
        EXIT(ROUND(("Commission Amount" - "TDS Amount"), 0.01));
    end;
}

