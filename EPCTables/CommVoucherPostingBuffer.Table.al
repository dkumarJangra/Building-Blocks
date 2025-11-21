table 97807 "Comm. Voucher Posting Buffer"
{

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
            Editable = false;
        }
        field(5; "Commission Amount"; Decimal)
        {
            Editable = false;
        }
        field(6; "Payment Mode"; Option)
        {
            OptionCaption = ' ,Cash,Cheque,D.D.,Transfer,D.C./C.C./Net Banking';
            OptionMembers = " ",Cash,Cheque,"D.D.",Transfer,"D.C./C.C./Net Banking";

            trigger OnValidate()
            var
                BondSetup: Record "Unit Setup";
            begin
                //BondSetup.GET;
                //IF "Payment Mode" = "Payment Mode"::Cash THEN
                //  "Payment A/C Code" := BondSetup."Cash A/c No.";
            end;
        }
        field(7; "Payment A/C Code"; Code[20])
        {
            TableRelation = IF ("Payment Mode" = FILTER(<> Cash)) "Bank Account"
            ELSE IF ("Payment Mode" = FILTER(Cash)) "G/L Account";
        }
        field(8; "Cheque No."; Code[10])
        {

            trigger OnValidate()
            begin
                //IF ("Cheque No." <> '') AND NOT (STRLEN("Cheque No.") IN [6,7]) THEN
                //  ERROR(Text0001);
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
        field(10; "Unit Office Code(Paid)"; Code[20])
        {
            Caption = 'Unit Office Code(Paid)';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(11; "Counter Code(Paid)"; Code[20])
        {
            Caption = 'Counter Code(Paid)';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(12; "Posted Doc. No."; Code[20])
        {
        }
        field(13; "Paid To"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(14; "Document Date"; Date)
        {
        }
        field(15; "Posting Date"; Date)
        {
        }
        field(17; Category; Option)
        {
            Editable = false;
            OptionMembers = "A Type","B Type";
        }
        field(18; "TDS Amount"; Decimal)
        {
            Editable = false;
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
        field(50000; "Document No."; Code[20])
        {
        }
        field(50001; Type; Option)
        {
            OptionCaption = 'Commission,Travel';
            OptionMembers = Commission,Travel;
        }
    }

    keys
    {
        key(Key1; "Voucher No.", "Counter Code(Paid)")
        {
            Clustered = true;
        }
        key(Key2; "Cheque Status", "Voucher No.")
        {
        }
        key(Key3; "Associate Code", Month, Year, "Posted Doc. No.")
        {
            SumIndexFields = "Base Amount", "Commission Amount";
        }
        key(Key4; "Associate Code", "Posting Date", "Voucher No.", "Posted Doc. No.", "Unit Office Code(Paid)", "Counter Code(Paid)")
        {
        }
        key(Key5; "Paid To", "Posting Date", "Associate Code", "Posted Doc. No.")
        {
        }
        key(Key6; "Counter Code(Paid)", Status)
        {
        }
        key(Key7; "Document No.", Status)
        {
            SumIndexFields = "Base Amount", "Commission Amount", "TDS Amount", "Clube 9 Charge Amount";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TravelPaymentDetails.RESET;
        TravelPaymentDetails.SETRANGE("Document No.", "Voucher No.");
        IF TravelPaymentDetails.FINDFIRST THEN
            REPEAT
                TravelPaymentDetails."TA Creation on Commission Vouc" := FALSE;
                TravelPaymentDetails.MODIFY;
            UNTIL TravelPaymentDetails.NEXT = 0;
    end;

    trigger OnInsert()
    begin
        //TESTFIELD("Associate Code");
        /*
        IF "Payment Mode" <> "Payment Mode"::Cash THEN BEGIN
          TESTFIELD("Cheque No.");
          TESTFIELD("Cheque Date");
          IF NOT (("Cheque Date" >= WORKDATE) AND ("Cheque Date" < CALCDATE('6M',WORKDATE))) THEN
            ERROR(Text0002);
        END;
         */

    end;

    trigger OnModify()
    begin
        TESTFIELD("Associate Code");
        /*
        IF "Payment Mode" <> "Payment Mode"::Cash THEN BEGIN
          TESTFIELD("Cheque No.");
          TESTFIELD("Cheque Date");
          IF NOT (("Cheque Date" >= WORKDATE) AND ("Cheque Date" < CALCDATE('6M',WORKDATE))) THEN
            ERROR(Text0002);
        END;
         */

    end;

    var
        PaymentMethod: Record "Payment Method";
        Text0001: Label 'Please enter a valid check no.';
        Text0002: Label 'Please enter a valid check date.';
        Text0003: Label 'You cannot change Line No. %1.';
        Text0004: Label 'Cheque Already Cleared and Posted';
        Text0005: Label 'Payment Mode is %1';
        Text0006: Label 'Please enter Cheque Clearance Date';
        TravelPaymentDetails: Record "Travel Payment Entry";
}

