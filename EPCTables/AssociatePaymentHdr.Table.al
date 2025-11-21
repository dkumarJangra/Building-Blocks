table 50018 "Associate Payment Hdr"
{
    // BBG2.03 24/07/14 Added new code for check the Cheque No. already used or not

    Caption = 'Associate Payment Hdr';
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

            trigger OnValidate()
            begin
                IF "Associate Code" <> '' THEN BEGIN
                    Vendor.RESET;
                    Vendor.GET("Associate Code");
                    "Associate Name" := Vendor.Name;
                    IF Vendor."BBG Hold Payables" = TRUE THEN BEGIN
                        MESSAGE('Code - %1 %2 is on Hold', "Associate Code", GetDescription.GetVendorName("Associate Code"));
                        "Associate Code" := '';
                    END;
                END ELSE
                    "Associate Name" := '';

                "Posting Date" := 0D;
                "Cut-off Date" := 0D;
                "Bank/G L Code" := '';
                Type := Type::" ";
                "Bank/G L Name" := '';
            end;
        }
        field(3; "Company Name"; Text[30])
        {
            Editable = false;
            TableRelation = Company;
        }
        field(4; "Team Head"; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                IF "Team Head" <> '' THEN BEGIN
                    Vendor.RESET;
                    Vendor.GET("Team Head");
                    "Team Head Name" := Vendor.Name;
                    IF Vendor."BBG Hold Payables" = TRUE THEN BEGIN
                        MESSAGE('Code - %1 %2 is on Hold', "Team Head", GetDescription.GetVendorName("Team Head"));
                        "Team Head Name" := '';
                    END;
                END ELSE
                    "Team Head Name" := '';
            end;
        }
        field(5; "Payment Mode"; Option)
        {
            OptionCaption = ' ,Cash,Bank';
            OptionMembers = " ",Cash,Bank;

            trigger OnValidate()
            begin
                "Bank/G L Code" := '';
                "Bank/G L Name" := '';
                "Cheque No." := '';
                "Cheque Date" := 0D;
                IF "Line Type" = "Line Type"::Header THEN
                    TESTFIELD("Payment Mode")
                ELSE
                    TESTFIELD("Payment Mode", "Payment Mode"::" ");
            end;
        }
        field(6; "Bank/G L Code"; Code[20])
        {

            trigger OnLookup()
            begin
                IF ("Line Type" = "Line Type"::Header) THEN
                    TESTFIELD("Payment Mode")
                ELSE
                    TESTFIELD("Payment Mode", "Payment Mode"::" ");


                UserSetup.GET(USERID);


                IF ("Payment Mode" = "Payment Mode"::Bank) THEN BEGIN

                    CreditVoucherAccount.RESET;
                    CreditVoucherAccount.SETRANGE("Account Type", CreditVoucherAccount."Account Type"::"Bank Account");
                    CreditVoucherAccount.SETFILTER("ARM Account Type", '%1|%2', CreditVoucherAccount."ARM Account Type"::"Assc Payment",
                                             CreditVoucherAccount."ARM Account Type"::Both);
                    CreditVoucherAccount.SETRANGE("Location code", UserSetup."User Branch");
                    CreditVoucherAccount.SETRANGE("Payment Method Code", 'Bank');
                    CreditVoucherAccount.SETRANGE(Type, CreditVoucherAccount.Type::"Bank Payment Voucher");
                    IF CreditVoucherAccount.FINDFIRST THEN BEGIN
                        IF PAGE.RUNMODAL(Page::"Voucher Posting Credit Account", CreditVoucherAccount) = ACTION::LookupOK THEN BEGIN
                            "Bank/G L Code" := CreditVoucherAccount."Account No.";
                            IF BankACC.GET(CreditVoucherAccount."Account No.") THEN
                                "Bank/G L Name" := BankACC.Name
                            ELSE
                                "Bank/G L Name" := '';
                        END;
                    END;
                    //Need to check the code in UAT

                END;


                IF ("Payment Mode" = "Payment Mode"::Cash) THEN BEGIN

                    DebitVoucherAccount.RESET;
                    DebitVoucherAccount.SETRANGE("Account Type", DebitVoucherAccount."Account Type"::"G/L Account");
                    DebitVoucherAccount.SETFILTER("ARM Account Type", '%1|%2', DebitVoucherAccount."ARM Account Type"::"Assc Payment",
                                             DebitVoucherAccount."ARM Account Type"::Both);
                    DebitVoucherAccount.SETRANGE("Location code", UserSetup."User Branch");
                    DebitVoucherAccount.SETRANGE("Payment Method Code", 'CASH');
                    IF DebitVoucherAccount.FINDFIRST THEN BEGIN
                        IF PAGE.RUNMODAL(Page::"New Voucher Accounts", DebitVoucherAccount) = ACTION::LookupOK THEN BEGIN
                            "Bank/G L Code" := DebitVoucherAccount."Account No.";
                            IF GLACC.GET(DebitVoucherAccount."Account No.") THEN
                                "Bank/G L Name" := GLACC.Name
                            ELSE
                                "Bank/G L Name" := '';
                        END;
                    END;
                    //Need to check the code in UAT

                END;

            end;

            trigger OnValidate()
            begin
                IF "Bank/G L Code" = '' THEN
                    "Bank/G L Name" := '';

                IF "Line Type" = "Line Type"::Header THEN
                    TESTFIELD("Payment Mode")
                ELSE
                    TESTFIELD("Payment Mode", "Payment Mode"::" ");
            end;
        }
        field(7; "Cheque No."; Code[20])
        {

            trigger OnValidate()
            begin
                TESTFIELD("Payment Mode");
                IF ("Line Type" = "Line Type"::Header) AND ("Payment Mode" = "Payment Mode"::Bank) THEN
                    TESTFIELD("Payment Mode")
                ELSE
                    TESTFIELD("Payment Mode", "Payment Mode"::" ");

                IF "Payment Mode" = "Payment Mode"::Bank THEN BEGIN
                    TESTFIELD("Bank/G L Code");
                    IF "Cheque No." <> '' THEN BEGIN
                        CheckLedgEntry.RESET;
                        CheckLedgEntry.SETCURRENTKEY("Bank Account No.", "Check No.");
                        CheckLedgEntry.SETRANGE("Bank Account No.", "Bank/G L Code");
                        CheckLedgEntry.SETRANGE("Check No.", "Cheque No.");
                        IF CheckLedgEntry.FINDFIRST THEN
                            ERROR('The Cheque No. already used on this Document No. - ' + CheckLedgEntry."Document No.");

                        BankLedgEntry.RESET;
                        BankLedgEntry.SETCURRENTKEY("Bank Account No.", "Cheque No.");
                        BankLedgEntry.SETRANGE("Bank Account No.", "Bank/G L Code");
                        ChequeLength := StrLen("Cheque No.");
                        IF ChequeLength > 10 then
                            BankLedgEntry.SETRANGE("Cheque No.1", "Cheque No.")
                        ELSE
                            BankLedgEntry.SETRANGE("Cheque No.", "Cheque No.");
                        IF BankLedgEntry.FINDFIRST THEN
                            ERROR('The Cheque No. already used on this Document No. - ' + BankLedgEntry."Document No.");


                        APVHeader.RESET;
                        APVHeader.SETRANGE("Payment Mode", "Payment Mode");
                        APVHeader.SETRANGE("Bank/G L Code", "Bank/G L Code");
                        APVHeader.SETRANGE("Cheque No.", "Cheque No.");
                        APVHeader.SETFILTER("Document No.", '<>%1', "Document No.");
                        IF APVHeader.FINDFIRST THEN
                            ERROR('The Cheque No. already used on this Entry No. - ' + FORMAT(APVHeader."Document No."));
                    END;
                END;
                //BBG2.03 24/07/14
            end;
        }
        field(8; "Cheque Date"; Date)
        {

            trigger OnValidate()
            begin
                IF ("Line Type" = "Line Type"::Header) AND ("Payment Mode" = "Payment Mode"::Bank) THEN
                    TESTFIELD("Payment Mode")
                ELSE
                    TESTFIELD("Payment Mode", "Payment Mode"::" ");
            end;
        }
        field(9; "Bank/G L Name"; Text[50])
        {
        }
        field(10; "Associate Name"; Text[50])
        {
            Editable = false;
        }
        field(11; "Team Head Name"; Text[50])
        {
            Caption = 'Team Head Name';
            Editable = false;

            trigger OnValidate()
            begin
                TESTFIELD("Associate Code");
                TESTFIELD("Company Name");
            end;
        }
        field(12; "Incentive Type"; Option)
        {
            OptionMembers = " ",Direct,Team;

            trigger OnValidate()
            begin
                TESTFIELD("Team Head");
            end;
        }
        field(13; Type; Option)
        {
            Editable = false;
            OptionCaption = ' ,Incentive,Commission,TA,ComAndTA';
            OptionMembers = " ",Incentive,Commission,TA,ComAndTA;
        }
        field(14; "User ID"; Code[20])
        {
            Editable = false;
        }
        field(15; "User Branch Code"; Code[20])
        {
            Editable = false;
            TableRelation = Location WHERE("BBG Branch" = FILTER(true));
        }
        field(16; Status; Option)
        {
            Editable = false;
            OptionCaption = ' ,Released,Open,Post';
            OptionMembers = " ",Released,Open;
        }
        field(17; "Posting Type"; Option)
        {
            OptionCaption = ' ,Incentive,Commission,TA,ComAndTA,ALL';
            OptionMembers = " ",Incentive,Commission,TA,ComAndTA,ALL;
        }
        field(18; "Posting Date"; Date)
        {
            Description = 'ALLEDK 061212';

            trigger OnValidate()
            begin
                IF "Cut-off Date" > "Posting Date" THEN
                    ERROR('Commission Date must be less than Posting Date');
            end;
        }
        field(19; "Document Date"; Date)
        {
            Description = 'ALLEDK 061212';
        }
        field(20; Post; Boolean)
        {
            Editable = true;

            trigger OnValidate()
            begin
                IF NOT Post THEN
                    "Posted on LLP Company" := FALSE;
                "Rejected/Approved" := "Rejected/Approved"::" ";
                "Update Comm/TA Entries" := FALSE;
                MODIFY;
            end;
        }
        field(21; "Cut-off Date"; Date)
        {
            Editable = false;

            trigger OnValidate()
            begin
                //EntryAlreadyExists;
                TESTFIELD("Posting Date");
                IF "Cut-off Date" > "Posting Date" THEN
                    ERROR('Commission Date must be less than Posting Date');
            end;
        }
        field(22; "Eligible Amount"; Decimal)
        {
            Editable = false;
        }
        field(23; "Associate Approved Amt."; Decimal)
        {
            Editable = false;
        }
        field(24; "TDS Amount"; Decimal)
        {
            Editable = true;
        }
        field(25; "Club 9 Amount"; Decimal)
        {
            Editable = true;
        }
        field(26; "Posted Document No."; Code[20])
        {
        }
        field(27; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Description = 'ALLEDK 180213';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(29; "Payment Reversed"; Boolean)
        {
            Description = 'ALLETDK';
        }
        field(30; "Sub Type"; Option)
        {
            Description = 'BBG1.00 250713 for Differencate direct Incentive';
            Editable = true;
            OptionCaption = ' ,Regular,Direct,AssociateAdvance';
            OptionMembers = " ",Regular,Direct,AssociateAdvance;
        }
        field(31; "Ignore Advance Payment"; Boolean)
        {
            Description = 'BBG2.01 160714';

            trigger OnValidate()
            begin
                TESTFIELD("Create Invoice Only", FALSE);
                Memberof.RESET;
                Memberof.SETRANGE("User Name", USERID);
                Memberof.SETRANGE("Role ID", 'IgnoreAdvPayment');
                IF NOT Memberof.FINDFIRST THEN
                    ERROR('You are not authorised person to perform this task');
                TotalAmt := 0;
                UnitSetup.GET;
                UnitSetup.CHANGECOMPANY("Company Name");
                IF Type = Type::Incentive THEN
                    "TDS%" := PostPayment.CalculateTDSPercentage("Associate Code", UnitSetup."TDS Nature of Deduction INCT", "Company Name")
                ELSE IF Type = Type::Commission THEN
                    "TDS%" := PostPayment.CalculateTDSPercentage("Associate Code", UnitSetup."TDS Nature of Deduction", "Company Name")
                ELSE IF Type = Type::TA THEN
                    "TDS%" := PostPayment.CalculateTDSPercentage("Associate Code", UnitSetup."TDS Nature of Deduction TA", "Company Name");

                IF "Net Payable (As per Actual)" <> 0 THEN BEGIN
                    GLSetup.GET;
                    RecAssPmtHdr.RESET;
                    RecAssPmtHdr.SETRANGE("Document No.", "Document No.");
                    RecAssPmtHdr.SETRANGE("Associate Code", "Associate Code");
                    RecAssPmtHdr.SETRANGE("Company Name", "Company Name");
                    IF RecAssPmtHdr.FINDSET THEN BEGIN
                        REPEAT
                            TotalAmt := TotalAmt + RecAssPmtHdr."Payable Amount";
                        UNTIL RecAssPmtHdr.NEXT = 0;
                        IF ("Advance Amount" > 0) AND (NOT "Ignore Advance Payment") THEN BEGIN
                            "Amt applicable for Payment" := ROUND((TotalAmt - "Advance Amount") - ROUND(((TotalAmt - "Advance Amount") * "TDS%" / 100), 1, '=')
                                      - ((TotalAmt - "Advance Amount") * UnitSetup."Corpus %" / 100), GLSetup.
                                      "Inv. Rounding Precision (LCY)", '=');

                            "TDS Amount" := ROUND(((TotalAmt - "Advance Amount") * "TDS%" / 100), 1, '=');
                            "Club 9 Amount" := ((TotalAmt - "Advance Amount") * UnitSetup."Corpus %" / 100);

                        END ELSE BEGIN
                            "Amt applicable for Payment" := ROUND((TotalAmt) - ROUND(((TotalAmt) * "TDS%" / 100), 1, '=')
                                        - ((TotalAmt) * UnitSetup."Corpus %" / 100), GLSetup.
                                        "Inv. Rounding Precision (LCY)", '=');

                            "TDS Amount" := ROUND(((TotalAmt) * "TDS%" / 100), 1, '=');
                            "Club 9 Amount" := ((TotalAmt) * UnitSetup."Corpus %" / 100);
                        END;
                    END;
                END ELSE BEGIN
                    "TDS Amount" := 0;
                    "Club 9 Amount" := 0;
                    "Amt applicable for Payment" := 0;
                END;
            end;
        }
        field(32; "Create Invoice Only"; Boolean)
        {
            Description = 'BBG2.01 160714';

            trigger OnValidate()
            begin
                TESTFIELD("Ignore Advance Payment", FALSE);
            end;
        }
        field(33; "Rejected/Approved"; Option)
        {
            OptionCaption = ' ,Approved,Rejected,Not Allowed';
            OptionMembers = " ",Approved,Rejected,"Not Allowed";

            trigger OnValidate()
            begin
                TESTFIELD("Company Name");
                TESTFIELD(Post, FALSE);
                IF "Line Type" = "Line Type"::Header THEN BEGIN
                    TESTFIELD("Payment Mode");
                    TESTFIELD("Bank/G L Code");
                    IF "Payment Mode" = "Payment Mode"::Bank THEN BEGIN
                        TESTFIELD("Cheque No.");
                        TESTFIELD("Cheque Date");
                    END;
                END;

                AssPmtHdr.RESET;
                AssPmtHdr.SETRANGE("Associate Code", "Associate Code");
                AssPmtHdr.SETRANGE(Post, FALSE);
                AssPmtHdr.SETRANGE("User ID", "User ID");
                AssPmtHdr.SETRANGE("Company Name", "Company Name");
                AssPmtHdr.SETRANGE("Rejected/Approved", "Rejected/Approved"::Approved);
                IF NOT AssPmtHdr.FINDFIRST THEN
                    IF "Rejected/Approved" = "Rejected/Approved"::Approved THEN
                        TESTFIELD("Amt applicable for Payment");
            end;
        }
        field(34; "Amt applicable for Payment"; Decimal)
        {
            Editable = true;
        }
        field(35; "Associate Bank No."; Code[20])
        {
        }
        field(36; "Net Payable (As per Actual)"; Decimal)
        {
            Editable = true;
        }
        field(37; "Advance Amount"; Decimal)
        {
            Editable = true;
        }
        field(38; "Payable Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                IF "Eligible Amount" < "Payable Amount" THEN
                    ERROR('Payable Amount should be less than Eligible Amount');

                UnitSetup.GET;
                UnitSetup.CHANGECOMPANY("Company Name");
                IF Type = Type::Incentive THEN
                    "TDS%" := PostPayment.CalculateTDSPercentage("Associate Code", UnitSetup."TDS Nature of Deduction INCT", "Company Name")
                ELSE IF Type = Type::Commission THEN
                    "TDS%" := PostPayment.CalculateTDSPercentage("Associate Code", UnitSetup."TDS Nature of Deduction", "Company Name")
                ELSE IF Type = Type::TA THEN
                    "TDS%" := PostPayment.CalculateTDSPercentage("Associate Code", UnitSetup."TDS Nature of Deduction TA", "Company Name");

                TotalAmt := 0;
                IF "Net Payable (As per Actual)" <> 0 THEN BEGIN
                    GLSetup.GET;
                    RecAssPmtHdr.RESET;
                    RecAssPmtHdr.SETRANGE("Document No.", "Document No.");
                    RecAssPmtHdr.SETRANGE("Associate Code", "Associate Code");
                    RecAssPmtHdr.SETRANGE("Company Name", "Company Name");
                    IF RecAssPmtHdr.FINDSET THEN BEGIN
                        REPEAT
                            TotalAmt := TotalAmt + RecAssPmtHdr."Payable Amount";
                        UNTIL RecAssPmtHdr.NEXT = 0;
                        IF ("Advance Amount" > 0) AND (NOT "Ignore Advance Payment") THEN BEGIN
                            "Amt applicable for Payment" := ROUND((TotalAmt - "Advance Amount") - ROUND(((TotalAmt - "Advance Amount") * "TDS%" / 100), 1, '=')
                                      - ((TotalAmt - "Advance Amount") * UnitSetup."Corpus %" / 100), GLSetup.
                                      "Inv. Rounding Precision (LCY)", '=');

                            "TDS Amount" := ROUND(((TotalAmt - "Advance Amount") * "TDS%" / 100), 1, '=');
                            "Club 9 Amount" := ((TotalAmt - "Advance Amount") * UnitSetup."Corpus %" / 100);

                        END ELSE BEGIN
                            "Amt applicable for Payment" := ROUND((TotalAmt) - ROUND(((TotalAmt) * "TDS%" / 100), 1, '=')
                                        - ((TotalAmt) * UnitSetup."Corpus %" / 100), GLSetup.
                                        "Inv. Rounding Precision (LCY)", '=');

                            "TDS Amount" := ROUND(((TotalAmt) * "TDS%" / 100), 1, '=');
                            "Club 9 Amount" := ((TotalAmt) * UnitSetup."Corpus %" / 100);
                        END;
                    END;
                END ELSE BEGIN
                    "TDS Amount" := 0;
                    "Club 9 Amount" := 0;
                    "Amt applicable for Payment" := 0;
                END;
            end;
        }
        field(39; "Line Type"; Option)
        {
            OptionCaption = ' ,Header,Line';
            OptionMembers = " ",Header,Line;

            trigger OnValidate()
            begin
                RecAssPmtHdr1.RESET;
                RecAssPmtHdr1.SETRANGE("Document No.", "Document No.");
                RecAssPmtHdr1.SETRANGE("Line Type", "Line Type"::Header);
                IF NOT RecAssPmtHdr1.FINDFIRST THEN BEGIN
                END ELSE IF "Sub Type" = "Sub Type"::Regular THEN
                        ERROR('You can not change the value');
            end;
        }
        field(40; "Total Payable Amount"; Decimal)
        {
            CalcFormula = Sum("Associate Payment Hdr"."Eligible Amount" WHERE("Document No." = FIELD("Document No."),
                                                                               Post = CONST(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(41; "From MS Company"; Boolean)
        {
            Editable = false;
        }
        field(42; "Posted on LLP Company"; Boolean)
        {
            Editable = true;
        }
        field(43; "Cheque Amount"; Decimal)
        {

            trigger OnValidate()
            var
                TotalAmt_1: Decimal;
            begin
                TESTFIELD("Rejected/Approved", "Rejected/Approved"::" ");
                //AssPmtHdr.RESET;
                //AssPmtHdr.SETRANGE("Associate Code","Associate Code");
                //AssPmtHdr.SETRANGE(Post,FALSE);
                //AssPmtHdr.SETRANGE("User ID","User ID");
                //AssPmtHdr.SETRANGE("Company Name","Company Name");
                //AssPmtHdr.SETRANGE("Line Type",AssPmtHdr."Line Type"::Header);
                //IF AssPmtHdr.FINDFIRST THEN

                TESTFIELD("Line Type", "Line Type"::Header);


                IF "Cheque Amount" < 0 THEN
                    ERROR('Cheque amount should not be -ve value');
                /* //220815
                IF ("Cheque Amount" = 0) AND ("Payable Amount" = "Eligible Amount") THEN
                  "Amt applicable for Payment" := ABS("Net Payable (As per Actual)");
                
                IF xRec."Cheque Amount" <> "Cheque Amount" THEN
                  "Payable Amount" := "Eligible Amount";
                
                */ //220815

                TotalAmt_1 := 0;
                RecAssPmtHdr1.RESET;
                RecAssPmtHdr1.SETRANGE("Document No.", "Document No.");
                IF RecAssPmtHdr1.FINDSET THEN
                    REPEAT
                        TotalAmt_1 := TotalAmt_1 + RecAssPmtHdr1."Eligible Amount";
                    UNTIL RecAssPmtHdr1.NEXT = 0;
                IF "Cheque Amount" > TotalAmt_1 THEN
                    ERROR('Cheque Amount can not be greater than =' + FORMAT(TotalAmt_1));

            end;
        }
        field(44; "Line No."; Integer)
        {
        }
        field(45; "Update Comm/TA Entries"; Boolean)
        {
        }
        field(46; "Reversal done in LLP Companies"; Boolean)
        {
            Editable = true;
        }
        field(47; "Inv Reversed in LLP Companies"; Boolean)
        {
            Editable = true;
        }
        field(48; "Pmt. Reversed in LLPCompanies"; Boolean)
        {
            Editable = true;
        }
        field(49; Narration; Text[60])
        {
        }
        field(50; "Record Find"; Boolean)
        {
        }
        field(51; "Select for Delete Entries"; Boolean)
        {
        }
        field(52; "TA Amount"; Decimal)
        {
            Editable = true;
        }
        field(53; "Create TA Entry by Batch"; Boolean)
        {
            Editable = false;
        }
        field(54; "Payment Amount"; Decimal)
        {
        }
        field(55; "TDS in LLP"; Decimal)
        {
        }
        field(56; "TA Amount elg"; Decimal)
        {
        }
        field(57; "Create TA Entry Only"; Boolean)
        {
        }
        field(58; "Post TA Entry in LLP"; Boolean)
        {
        }
        field(59; "Sms Sent"; Boolean)
        {
            Editable = false;
        }
        field(60; "Not Refresh Amount"; Boolean)
        {
            Editable = false;
        }
        field(61; "Recheck Entries"; Boolean)
        {
            Editable = false;
        }
        field(50000; "G/L Amount"; Decimal)
        {
            CalcFormula = Sum("G/L Entry"."Debit Amount" WHERE("BBG Comp Code" = FIELD("Company Name"),
                                                                "Document No." = FIELD("Posted Document No.")));
            FieldClass = FlowField;
        }
        field(50001; "Adjust OD Amount"; Decimal)
        {
            Editable = false;
        }
        field(50002; Remark; Text[30])
        {
        }
        field(50003; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Special Incentive for Bonanza"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Associate Code", Post)
        {
        }
        key(Key3; "Associate Code", Post, "Rejected/Approved")
        {
            SumIndexFields = "Eligible Amount";
        }
        key(Key4; "Associate Code", "Company Name")
        {
        }
        key(Key5; "Associate Code", "Payment Reversed", "Reversal done in LLP Companies")
        {
        }
        key(Key6; "Document No.", "Company Name")
        {
        }
        key(Key7; "Posted Document No.")
        {
        }
        key(Key8; "Recheck Entries")
        {
        }
        key(Key9; "Document No.", "Associate Code")
        {
        }
        key(Key10; "User ID", "Rejected/Approved", Post)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD("Rejected/Approved", "Rejected/Approved"::" ");
        TESTFIELD(Post, FALSE);

        IF Type = Type::TA THEN BEGIN
            TravelPaymentEntry.RESET;
            TravelPaymentEntry.CHANGECOMPANY("Company Name");
            TravelPaymentEntry.SETCURRENTKEY("Voucher No.");
            TravelPaymentEntry.SETRANGE("Voucher No.", "Document No.");
            IF TravelPaymentEntry.FINDFIRST THEN
                REPEAT
                    TravelPaymentEntry."Voucher No." := '';
                    TravelPaymentEntry."Post Payment" := FALSE;
                    TravelPaymentEntry.MODIFY;
                UNTIL TravelPaymentEntry.NEXT = 0;
        END;
        IF Type = Type::Incentive THEN BEGIN
            IncentiveSummary.RESET;
            IncentiveSummary.CHANGECOMPANY("Company Name");
            IncentiveSummary.SETCURRENTKEY("Voucher No.");
            IncentiveSummary.SETRANGE("Voucher No.", "Document No.");
            IF IncentiveSummary.FINDFIRST THEN
                REPEAT
                    IncentiveSummary."Voucher No." := '';
                    IncentiveSummary."Post Payment" := FALSE;
                    IncentiveSummary.MODIFY;
                UNTIL IncentiveSummary.NEXT = 0;
        END;
        IF Type = Type::Commission THEN BEGIN
            CommissionEntry.RESET;
            CommissionEntry.CHANGECOMPANY("Company Name");
            CommissionEntry.SETCURRENTKEY("Voucher No.");
            CommissionEntry.SETRANGE("Voucher No.", "Document No.");
            IF CommissionEntry.FINDFIRST THEN
                REPEAT
                    CommissionEntry."Voucher No." := '';
                    CommissionEntry.Posted := FALSE;
                    CommissionEntry.MODIFY;
                UNTIL CommissionEntry.NEXT = 0;
        END;
    end;

    trigger OnInsert()
    begin

        "User ID" := USERID;

        IF UserSetup.GET("User ID") THEN BEGIN
            "User Branch Code" := UserSetup."User Branch";
            "Shortcut Dimension 1 Code" := UserSetup."Purchase Resp. Ctr. Filter";
        END;
        "Document Date" := WORKDATE;
    end;

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
        //VoucherAccount: Record 16547;//Need to check the code in UAT
        DebitVoucherAccount: Record "Voucher Posting Debit Account";
        CreditVoucherAccount: Record "Voucher Posting Credit Account";
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
        Memberof: Record "Access Control";
        ChequeLength: integer;


    procedure AssistEdit(OldCommVHdr: Record "Assoc Pmt Voucher Header"): Boolean
    begin
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        CASE Type OF
            Type::Incentive:
                EXIT(UnitSetup."Incentive Summary Buffer No.");
            Type::Commission:
                EXIT(UnitSetup."Comm. Payable No. Series");
            Type::TA:
                EXIT(UnitSetup."Travel No. Series");
        END;
    end;


    procedure EntryAlreadyExists()
    var
        AssociatePaymentHdr: Record "Associate Payment Hdr";
    begin
    end;
}

