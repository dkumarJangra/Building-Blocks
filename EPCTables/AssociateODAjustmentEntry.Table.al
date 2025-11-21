table 50021 "Associate OD Ajustment Entry"
{
    // BBG2.03 24/07/14 Added new code for check the Cheque No. already used or not

    Caption = 'Associate OD Ajustment Entry';
    DataPerCompany = false;
    LookupPageID = "Posted Voucher List";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Associate Code"; Code[20])
        {
            Editable = false;
            TableRelation = Vendor WHERE("BBG Vendor Category" = FILTER("IBA(Associates)"));
        }
        field(3; "From Company Name"; Text[30])
        {
            Editable = false;
            TableRelation = Company;
        }
        field(4; "To Company Name"; Text[30])
        {
            Editable = false;
            TableRelation = Company;
        }
        field(5; "Associate Name"; Text[50])
        {
            Editable = false;
        }
        field(6; "User ID"; Code[20])
        {
            Editable = false;
        }
        field(7; "User Branch Code"; Code[20])
        {
            Editable = false;
            TableRelation = Location WHERE("BBG Branch" = FILTER(true));
        }
        field(8; "Posting Date"; Date)
        {
            Description = 'ALLEDK 061212';
        }
        field(9; "Document Date"; Date)
        {
            Description = 'ALLEDK 061212';
        }
        field(10; "Eligible Amount"; Decimal)
        {
            Editable = false;
        }
        field(11; "Posted Document No."; Code[20])
        {
        }
        field(12; "Line no."; Integer)
        {
        }
        field(13; "Adjust OD Amount"; Decimal)
        {
            Editable = false;
        }
        field(14; "Ref. Line no."; Integer)
        {
        }
        field(15; "Adjusted Amount"; Decimal)
        {
            CalcFormula = Sum("Associate OD Ajustment Entry"."Adjust OD Amount" WHERE("Document No." = FIELD("Document No."),
                                                                                       "Ref. Line no." = FIELD("Line no.")));
            FieldClass = FlowField;
        }
        field(16; "Posted in From Company Name"; Boolean)
        {
        }
        field(17; "Posted in To Company Name"; Boolean)
        {
        }
        field(18; "Sinking Process Done"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line no.")
        {
            Clustered = true;
        }
        key(Key2; "Document No.", "From Company Name")
        {
        }
        key(Key3; "Document No.", "Associate Code")
        {
        }
        key(Key4; "Document No.", "Ref. Line no.")
        {
            SumIndexFields = "Adjust OD Amount";
        }
        key(Key5; "Associate Code", "Sinking Process Done")
        {
        }
    }

    fieldgroups
    {
    }

    var
        GetDescription: Codeunit GetDescription;
        Vendor: Record Vendor;
        BankACC: Record "Bank Account";
        GLACC: Record "G/L Account";
        UnitSetup: Record "Unit Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        UserSetup: Record "User Setup";
        PaymentMethod: Record "Payment Method";
        GLAccount: Record "G/L Account";
        VHeader: Record "Associate Payment Hdr";
        CheckLedgEntry: Record "Check Ledger Entry";
        //VoucherAccount: Record 16547;
        PHeader: Record "Purchase Header";
        APVHeader: Record "Associate Payment Hdr";
        BankLedgEntry: Record "Bank Account Ledger Entry";
        "TDS%": Decimal;
        PostPayment: Codeunit PostPayment;
        AssPmtHdr: Record "Associate Payment Hdr";
        RecAssPmtHdr: Record "Associate Payment Hdr";
        GLSetup: Record "General Ledger Setup";
        TotalAmt: Decimal;
        TravelPaymentEntry: Record "Travel Payment Entry";
        IncentiveSummary: Record "Incentive Summary";
        CommissionEntry: Record "Commission Entry";
        RecAssPmtHdr1: Record "Associate Payment Hdr";


    procedure AssistEdit(OldCommVHdr: Record "Assoc Pmt Voucher Header"): Boolean
    begin
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
    end;


    procedure EntryAlreadyExists()
    var
        AssociatePaymentHdr: Record "Associate Payment Hdr";
    begin
    end;
}

