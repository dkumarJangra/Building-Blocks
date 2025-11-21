table 97835 "Voucher Line"
{

    fields
    {
        field(1; "Voucher No."; Code[20])
        {
            TableRelation = "Assoc Pmt Voucher Header"."Document No.";
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
        field(5; Amount; Decimal)
        {
            Editable = true;

            trigger OnValidate()
            var
                ConfirmedOrder: Record "Confirmed Order";
            begin
                VoucherHdr.RESET;
                IF VoucherHdr.GET("Voucher No.") THEN BEGIN
                    IF VoucherHdr."Application No." <> '' THEN
                        IF ConfirmedOrder.GET(VoucherHdr."Application No.") THEN
                            "Shortcut Dimension 1 Code" := ConfirmedOrder."Shortcut Dimension 1 Code";
                    Type := VoucherHdr.Type;
                    "Associate Code" := VoucherHdr."Paid To";
                    "Company Code" := COMPANYNAME;
                END;

                UnitSetup.GET;
                IF Amount > "Eligible Amount" THEN
                    ERROR('Amount should not be greater than Eligible Amount');

                IF Amount < 0 THEN
                    ERROR('Amount should be Positive');

                IF Type = Type::Incentive THEN BEGIN
                    "Clube 9 Charge Amount" := ROUND((Amount * (UnitSetup."Incentive Club 9%" / 100)),
                                          UnitSetup."Corpus Amt. Rounding Precision");
                END ELSE
                    "Clube 9 Charge Amount" := ROUND((Amount * (UnitSetup."Corpus %" / 100)),
                                          UnitSetup."Corpus Amt. Rounding Precision");

                IF Type = Type::Incentive THEN
                    "TDS%" := PostPayment.CalculateTDSPercentage("Associate Code", UnitSetup."TDS Nature of Deduction INCT", "Company Code")
                ELSE
                    IF Type = Type::Commission THEN
                        "TDS%" := PostPayment.CalculateTDSPercentage("Associate Code", UnitSetup."TDS Nature of Deduction", "Company Code")
                    ELSE
                        IF Type = Type::TA THEN
                            "TDS%" := PostPayment.CalculateTDSPercentage("Associate Code", UnitSetup."TDS Nature of Deduction TA", "Company Code");
                Rec."TDS/TCS %" := "TDS%";
                Rec."TDS Amount" := (Amount * "TDS%") / 100;
                Rec.Modify();
            end;
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
            Editable = true;
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
            OptionCaption = ' ,Incentive,Commission,TA';
            OptionMembers = " ",Incentive,Commission,TA;
        }
        field(50002; "Line No."; Integer)
        {
        }
        field(50003; "Incentive Type"; Option)
        {
            OptionCaption = ' ,Direct,Team';
            OptionMembers = " ",Direct,Team;
        }
        field(50004; "Plot Incentive Amount"; Decimal)
        {
        }
        field(50005; "Plot Eligible Amount"; Decimal)
        {
        }
        field(50006; "Extent Incentive Amount"; Decimal)
        {
        }
        field(50007; "Extent Eligible Amount"; Decimal)
        {
        }
        field(50008; "Post Payment"; Boolean)
        {
        }
        field(50009; "Post Invoice"; Boolean)
        {
        }
        field(50010; "New Line No."; Integer)
        {
        }
        field(50011; "Eligible Amount"; Decimal)
        {
            Editable = true;
        }
        field(50012; Narration; Text[60])
        {
            Description = 'ALLECK 130413';

            trigger OnValidate()
            begin
                CLEAR(VoucherHeader);
                VoucherHeader.RESET;
                VoucherHeader.SETRANGE("Document No.", "Voucher No.");
                IF VoucherHeader.FINDFIRST THEN BEGIN
                    IF VoucherHeader.Post THEN BEGIN
                        CLEAR(MemberOf);
                        MemberOf.RESET;
                        MemberOf.SETRANGE("User Name", USERID);
                        MemberOf.SETRANGE("Role ID", 'A_NarrUpdate');
                        IF NOT MemberOf.FINDFIRST THEN
                            ERROR('You are not authorised person to perform this task. Please contact to Admin Dept.');
                    END;
                END
            end;
        }
        field(50013; "Net Amount"; Decimal)
        {
            Description = 'BBG1.00 280713 for special case only';
            Editable = false;
        }
        field(50014; "From MS Company"; Boolean)
        {
            Editable = true;
        }
        field(50015; "Pmt From MS Company Ref No."; Code[20])
        {
            Editable = true;
        }
        field(50016; "Company Code"; Text[30])
        {
            TableRelation = Company;

            trigger OnValidate()
            begin
                VoucherLine.RESET;
                VoucherLine.SETRANGE("Voucher No.", "Voucher No.");
                VoucherLine.SETFILTER("Line No.", '<>%1', "Line No.");
                VoucherLine.SETRANGE("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                IF VoucherLine.FINDFIRST THEN
                    ERROR('You have already select this Project');
            end;
        }
        field(50017; "Correction Need"; Boolean)
        {
        }
        field(50021; "Actual Vizag Data"; Boolean)
        {
        }
        field(50022; "Invoice Reversed"; Boolean)
        {
            CalcFormula = Lookup("Assoc Pmt Voucher Header"."Invoice Reversed" WHERE("Document No." = FIELD("Voucher No.")));
            FieldClass = FlowField;
        }
        field(50023; "Sub Type"; Option)
        {
            CalcFormula = Lookup("Assoc Pmt Voucher Header"."Sub Type" WHERE("Document No." = FIELD("Voucher No."),
                                                                              "Paid To" = FIELD("Associate Code")));
            Description = 'BBG1.00 250713 for Differencate direct Incentive';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = ' ,Regular,Direct,AssociateAdvance';
            OptionMembers = " ",Regular,Direct,AssociateAdvance;
        }
        field(50024; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                Location.GET("Shortcut Dimension 1 Code");
                Location.TESTFIELD("T.A.N. No.");
            end;
        }
    }

    keys
    {
        key(Key1; "Voucher No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Eligible Amount", Amount, "TDS Amount", "Clube 9 Charge Amount";
        }
        key(Key2; "Cheque Status", "Voucher No.")
        {
        }
        key(Key3; "Associate Code", Month, Year, "Posted Doc. No.")
        {
            SumIndexFields = "Base Amount", Amount;
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
            SumIndexFields = "Base Amount", Amount, "TDS Amount", "Clube 9 Charge Amount";
        }
        key(Key8; "Document No.", Type)
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //BBG1.00 210814
        PHeader.RESET;
        PHeader.SETRANGE("No.", "Voucher No.");
        IF PHeader.FINDFIRST THEN
            ERROR('Please post the Voucher from Pending Associate Payment Voucher');
        //BBG1.00 210814

        IF "From MS Company" THEN
            ERROR('You can not delete this Entry.Its created from MSCompany');

        IF NOT "From MS Company" THEN BEGIN

            TravelPaymentEntry.RESET;
            TravelPaymentEntry.SETCURRENTKEY("Voucher No.");
            TravelPaymentEntry.SETRANGE("Voucher No.", "Voucher No.");
            IF TravelPaymentEntry.FINDFIRST THEN
                REPEAT
                    TravelPaymentEntry."Voucher No." := '';
                    TravelPaymentEntry."Post Payment" := FALSE;
                    TravelPaymentEntry.MODIFY;
                UNTIL TravelPaymentEntry.NEXT = 0;

            IncentiveSummary.RESET;
            IncentiveSummary.SETCURRENTKEY("Voucher No.");
            IncentiveSummary.SETRANGE("Voucher No.", "Voucher No.");
            IF IncentiveSummary.FINDFIRST THEN
                REPEAT
                    IncentiveSummary."Voucher No." := '';
                    IncentiveSummary."Post Payment" := FALSE;
                    IncentiveSummary.MODIFY;
                UNTIL IncentiveSummary.NEXT = 0;

            CommissionEntry.RESET;
            CommissionEntry.SETCURRENTKEY("Voucher No.");
            CommissionEntry.SETRANGE("Voucher No.", "Voucher No.");
            IF CommissionEntry.FINDFIRST THEN
                REPEAT
                    CommissionEntry."Voucher No." := '';
                    CommissionEntry.Posted := FALSE;
                    CommissionEntry.MODIFY;
                UNTIL CommissionEntry.NEXT = 0;


            CLEAR(VoucherHdr);
            VoucherHdr.RESET;
            VoucherHdr.SETRANGE("Document No.", "Voucher No.");
            IF VoucherHdr.FINDFIRST THEN BEGIN
                VoucherHdr."Total Elig. Incl Opening" := 0;
                VoucherHdr."Payable Amount (Incl. OP+Dir)" := 0;
                VoucherHdr."Total Deduction (Incl TA Rev)" := 0;
                VoucherHdr."Total Elig. Incl. Opening" := 0;
                VoucherHdr."Total Elig. Excl. Opening" := 0;
                VoucherHdr."Total Club 9" := 0;
                VoucherHdr."Total TDS" := 0;
                VoucherHdr."Net Elig." := 0;
                VoucherHdr."Opening Bal. Rem" := 0;
                VoucherHdr."Net Balance" := 0;
                VoucherHdr."Total Comm/TA Amount" := 0;
                VoucherHdr."Advance Amount" := 0;

                VoucherHdr."Advance Payment" := FALSE;
                VoucherHdr."Check Advance Amount" := FALSE;
                VoucherHdr."Rem. Direct Inv Amt" := 0;
                VoucherHdr."Rem. Opening Inv Amt" := 0;
                VoucherHdr.MODIFY;
            END;
        END;
    end;

    trigger OnModify()
    begin
        TESTFIELD("Associate Code");
    end;

    var
        PaymentMethod: Record "Payment Method";
        Text0001: Label 'Please enter a valid check no.';
        Text0002: Label 'Please enter a valid check date.';
        Text0003: Label 'You cannot change Line No. %1.';
        Text0004: Label 'Cheque Already Cleared and Posted';
        Text0005: Label 'Payment Mode is %1';
        Text0006: Label 'Please enter Cheque Clearance Date';
        TravelPaymentEntry: Record "Travel Payment Entry";
        IncentiveSummary: Record "Incentive Summary";
        CommissionEntry: Record "Commission Entry";
        UnitSetup: Record "Unit Setup";
        PostPayment: Codeunit PostPayment;
        "TDS%": Decimal;
        VoucherHeader: Record "Assoc Pmt Voucher Header";
        VoucherHdr: Record "Assoc Pmt Voucher Header";
        PHeader: Record "Purchase Header";
        VoucherLine: Record "Voucher Line";
        MemberOf: Record "Access Control";
        Location: Record Location;
}

