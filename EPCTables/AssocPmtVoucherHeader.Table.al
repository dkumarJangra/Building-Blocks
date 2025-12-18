table 97814 "Assoc Pmt Voucher Header"
{
    // BBG2.03 24/07/14 Added new code for check the Cheque No. already used or not

    LookupPageID = "Posted Voucher List";

    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Paid To"; Code[20])
        {
            TableRelation = Vendor WHERE("BBG Vendor Category" = FILTER("IBA(Associates)"));

            trigger OnValidate()
            begin
                EntryAlreadyExists;
                IF "Paid To" <> '' THEN BEGIN
                    ReleaseUnitApp.CheckVendStatus("Paid To"); //BBG 090816

                    Vendor.RESET;
                    Vendor.GET("Paid To");
                    Vendor.TESTFIELD("BBG Black List", FALSE);
                    Name := Vendor.Name;
                    IF Vendor."BBG Hold Payables" = TRUE THEN BEGIN
                        MESSAGE('Code - %1 %2 is on Hold', "Paid To", GetDescription.GetVendorName("Paid To"));
                        "Paid To" := '';
                    END;
                    //ALLEDK 260213
                    IF Vendor."P.A.N. No." = '' THEN
                        Vendor.TESTFIELD(Vendor."P.A.N. Status");
                    //ALLEDK 260213
                END ELSE
                    Name := '';

                "Posting Date" := 0D;
                "Commission Date" := 0D;
                "Advance Amount" := 0;
                "Advance Payment" := FALSE;
                "Bank/G L Code" := '';
                Type := Type::" ";
                "Bank/G L Name" := '';
            end;
        }
        field(3; Month; Option)
        {
            OptionCaption = ' ,January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December;

            trigger OnValidate()
            begin
                EntryAlreadyExists;
                Year := DATE2DWY(TODAY, 3);
            end;
        }
        field(4; Year; Integer)
        {

            trigger OnValidate()
            begin
                EntryAlreadyExists;
            end;
        }
        field(5; "Payment Mode"; Option)
        {
            OptionCaption = ' ,Cash,Bank';
            OptionMembers = " ",Cash,Bank;

            trigger OnValidate()
            begin
                EntryAlreadyExists;
                "Bank/G L Code" := '';
                "Bank/G L Name" := '';
                "Cheque No." := '';
                "Cheque Date" := 0D;
            end;
        }
        field(6; "Bank/G L Code"; Code[20])
        {

            trigger OnLookup()
            begin
                UserSetup.GET(USERID);

                //BBG1.00 ALLEDK 070313
                /*
                
                IF "Payment Mode" = "Payment Mode" :: Bank THEN BEGIN
                  PaymentMethod.RESET;
                  PaymentMethod.SETRANGE("Bal. Account Type",PaymentMethod."Bal. Account Type"::"Bank Account");
                  PaymentMethod.SETRANGE("Pmt. Meth. For Ass. Payment",TRUE); //ALLEDK 030313
                  IF PaymentMethod.FINDFIRST THEN
                  IF PAGE.RUNMODAL(427,PaymentMethod) = ACTION::LookupOK THEN BEGIN
                    "Bank/G L Code" := PaymentMethod.Code;
                    IF BankACC.GET(PaymentMethod."Bal. Account No.") THEN
                      "Bank/G L Name" := BankACC.Name
                    ELSE
                      "Bank/G L Name" := '';
                   END;
                END ELSE IF "Payment Mode" = "Payment Mode" :: Cash THEN BEGIN
                  PaymentMethod.RESET;
                  PaymentMethod.SETRANGE("Bal. Account Type",PaymentMethod."Bal. Account Type"::"G/L Account");
                  PaymentMethod.SETRANGE("Pmt. Meth. For Ass. Payment",TRUE); //ALLEDK 030313
                  IF PaymentMethod.FINDFIRST THEN
                  IF PAGE.RUNMODAL(427,PaymentMethod) = ACTION::LookupOK THEN BEGIN
                    "Bank/G L Code" := PaymentMethod.Code;
                    IF GLACC.GET(PaymentMethod."Bal. Account No.") THEN
                      "Bank/G L Name" := GLACC.Name
                    ELSE
                      "Bank/G L Name" := '';
                
                   END;
                END;
                */

                //BBG1.00 ALLEDK 070313

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

                    CreditVoucherAccount.RESET;
                    CreditVoucherAccount.SETRANGE("Account Type", CreditVoucherAccount."Account Type"::"G/L Account");
                    CreditVoucherAccount.SETFILTER("ARM Account Type", '%1|%2', CreditVoucherAccount."ARM Account Type"::"Assc Payment",
                                             CreditVoucherAccount."ARM Account Type"::Both);
                    CreditVoucherAccount.SETRANGE("Location code", UserSetup."User Branch");
                    CreditVoucherAccount.SETRANGE("Payment Method Code", 'CASH');
                    IF CreditVoucherAccount.FINDFIRST THEN BEGIN
                        IF PAGE.RUNMODAL(Page::"Voucher Posting Credit Account", CreditVoucherAccount) = ACTION::LookupOK THEN BEGIN
                            "Bank/G L Code" := CreditVoucherAccount."Account No.";
                            IF GLACC.GET(CreditVoucherAccount."Account No.") THEN
                                "Bank/G L Name" := GLACC.Name
                            ELSE
                                "Bank/G L Name" := '';
                        END;
                    END;
                    /*
                    DebitVoucherAccount.RESET;
                    DebitVoucherAccount.SETRANGE("Account Type", DebitVoucherAccount."Account Type"::"G/L Account");
                    DebitVoucherAccount.SETFILTER("ARM Account Type", '%1|%2', DebitVoucherAccount."ARM Account Type"::"Assc Payment",
                                             DebitVoucherAccount."ARM Account Type"::Both);
                    DebitVoucherAccount.SETRANGE("Location code", UserSetup."User Branch");
                    DebitVoucherAccount.SETRANGE("Payment Method Code", 'CASH');
                    IF DebitVoucherAccount.FINDFIRST THEN BEGIN
                        IF PAGE.RUNMODAL(98019, DebitVoucherAccount) = ACTION::LookupOK THEN BEGIN
                            "Bank/G L Code" := DebitVoucherAccount."Account No.";
                            IF GLACC.GET(DebitVoucherAccount."Account No.") THEN
                                "Bank/G L Name" := GLACC.Name
                            ELSE
                                "Bank/G L Name" := '';
                        END;
                    END;
                    */
                    //Need to check the code in UAT
                END;

            end;

            trigger OnValidate()
            begin
                IF "Bank/G L Code" = '' THEN
                    "Bank/G L Name" := '';
            end;
        }
        field(7; "Cheque No."; Code[10])
        {

            trigger OnValidate()
            begin
                //BBG2.03 24/07/14
                TESTFIELD("Payment Mode");
                IF "Payment Mode" = "Payment Mode"::Bank THEN BEGIN
                    TESTFIELD("Bank/G L Code");

                    CheckLedgEntry.RESET;
                    CheckLedgEntry.SETCURRENTKEY("Bank Account No.", "Check No.");
                    CheckLedgEntry.SETRANGE("Bank Account No.", "Bank/G L Code");
                    CheckLedgEntry.SETRANGE("Check No.", "Cheque No.");
                    IF CheckLedgEntry.FINDFIRST THEN
                        ERROR('The Cheque No. already used on this Document No. - ' + CheckLedgEntry."Document No.");

                    BankLedgEntry.RESET;
                    BankLedgEntry.SETCURRENTKEY("Bank Account No.", "Cheque No.");
                    BankLedgEntry.SETRANGE("Bank Account No.", "Bank/G L Code");
                    BankLedgEntry.SETRANGE("Cheque No.", "Cheque No.");
                    IF BankLedgEntry.FINDFIRST THEN
                        ERROR('The Cheque No. already used on this Document No. - ' + BankLedgEntry."Document No.");


                    APVHeader.RESET;
                    APVHeader.SETRANGE("Payment Mode", "Payment Mode");
                    APVHeader.SETRANGE("Bank/G L Code", "Bank/G L Code");
                    APVHeader.SETRANGE("Cheque No.", "Cheque No.");
                    IF APVHeader.FINDFIRST THEN
                        ERROR('The Cheque No. already used on this Document No. - ' + APVHeader."Document No.");
                END;
                //BBG2.03 24/07/14
            end;
        }
        field(8; "Cheque Date"; Date)
        {
        }
        field(9; "Bank/G L Name"; Text[50])
        {
        }
        field(10; Name; Text[50])
        {
        }
        field(13; "No. Series"; Code[20])
        {
            Caption = 'Incentive No. Series';
            TableRelation = "No. Series";
        }
        field(14; "Incentive Type"; Option)
        {
            OptionMembers = " ",Direct,Team;

            trigger OnValidate()
            begin
                EntryAlreadyExists;
            end;
        }
        field(15; Type; Option)
        {
            OptionCaption = ' ,Incentive,Commission,TA,ComAndTA';
            OptionMembers = " ",Incentive,Commission,TA,ComAndTA;

            trigger OnValidate()
            begin
                EntryAlreadyExists;
            end;
        }
        field(16; "User ID"; Code[20])
        {
            Editable = false;
        }
        field(17; "User Branch Code"; Code[20])
        {
            Editable = false;
            TableRelation = Location WHERE("BBG Branch" = FILTER(true));
        }
        field(18; Status; Option)
        {
            Editable = false;
            OptionCaption = ' ,Released,Open,Post';
            OptionMembers = " ",Released,Open;
        }
        field(19; "Posting Type"; Option)
        {
            OptionCaption = ' ,Incentive,Commission,TA,CommissionAndTA,ALL';
            OptionMembers = " ",Incentive,Commission,TA,CommissionAndTA,ALL;
        }
        field(20; "Posting Date"; Date)
        {
            Description = 'ALLEDK 061212';

            trigger OnValidate()
            begin
                EntryAlreadyExists;
                IF "Commission Date" > "Posting Date" THEN
                    ERROR('Commission Date must be less than Posting Date');
            end;
        }
        field(21; "Document Date"; Date)
        {
            Description = 'ALLEDK 061212';
        }
        field(22; Post; Boolean)
        {
            Editable = true;
        }
        field(23; "Commission Date"; Date)
        {

            trigger OnValidate()
            begin
                //EntryAlreadyExists;
                TESTFIELD("Posting Date");
                IF "Commission Date" > "Posting Date" THEN
                    ERROR('Commission Date must be less than Posting Date');
            end;
        }
        field(24; "Advance Payment"; Boolean)
        {
        }
        field(25; "Advance Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Advance Payment");
            end;
        }
        field(26; "Payment Amount"; Decimal)
        {
            Description = 'In case of Advance Amount';
            Editable = false;
        }
        field(27; "Eligible Amount"; Decimal)
        {
            CalcFormula = Sum("Voucher Line"."Eligible Amount" WHERE("Voucher No." = FIELD("Document No.")));
            Editable = true;
            FieldClass = FlowField;
        }
        field(28; "Payable Amount"; Decimal)
        {
            CalcFormula = Sum("Voucher Line".Amount WHERE("Voucher No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(29; "TDS Amount"; Decimal)
        {
            CalcFormula = Sum("Voucher Line"."TDS Amount" WHERE("Voucher No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "Club 9 Amount"; Decimal)
        {
            CalcFormula = Sum("Voucher Line"."Clube 9 Charge Amount" WHERE("Voucher No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "Posted Document No."; Code[20])
        {
            CalcFormula = Lookup("G/L Entry"."Document No." WHERE("External Document No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
        field(32; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Description = 'ALLEDK 180213';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(33; "Net Pay after adv. Adj."; Decimal)
        {
            Description = 'ALLEDK 250213';
        }
        field(34; "Rem Amt Opening"; Decimal)
        {
        }
        field(35; "Rem Amt after Opening"; Decimal)
        {
        }
        field(36; "Invoice Reversed"; Boolean)
        {
            Description = 'ALLETDK';
        }
        field(37; "Payment Reversed"; Boolean)
        {
            Description = 'ALLETDK';
        }
        field(38; "Total Elig. Incl Opening"; Decimal)
        {
            Description = 'BBG1.00 130713 for show in Payment Window';
        }
        field(39; "Payable Amount (Incl. OP+Dir)"; Decimal)
        {
            Description = 'BBG1.00 130713 for show in Payment Window';
        }
        field(40; "Total Deduction (Incl TA Rev)"; Decimal)
        {
            Description = 'BBG1.00 130713 for show in Payment Window';
        }
        field(41; "Total Elig. Incl. Opening"; Decimal)
        {
            Description = 'BBG1.00 130713 for show in Payment Window';
        }
        field(42; "Total Elig. Excl. Opening"; Decimal)
        {
            Description = 'BBG1.00 130713 for show in Payment Window';
        }
        field(43; "Total Club 9"; Decimal)
        {
            Description = 'BBG1.00 130713 for show in Payment Window';
        }
        field(44; "Total TDS"; Decimal)
        {
            Description = 'BBG1.00 130713 for show in Payment Window';
        }
        field(45; "Net Elig."; Decimal)
        {
            Description = 'BBG1.00 130713 for show in Payment Window';
        }
        field(46; "Opening Bal. Rem"; Decimal)
        {
            Description = 'BBG1.00 130713 for show in Payment Window';
        }
        field(47; "Net Balance"; Decimal)
        {
            Description = 'BBG1.00 130713 for show in Payment Window';
        }
        field(48; "Total Comm/TA Amount"; Decimal)
        {
            Description = 'BBG1.00 130713 for show in Payment Window';
        }
        field(49; "Check Advance Amount"; Boolean)
        {
            Description = 'BBG1.00 170713 for show in Payment Window';
        }
        field(50; "Sub Type"; Option)
        {
            Description = 'BBG1.00 250713 for Differencate direct Incentive';
            Editable = false;
            OptionCaption = ' ,Regular,Direct,AssociateAdvance';
            OptionMembers = " ",Regular,Direct,AssociateAdvance;
        }
        field(51; "Rem. Direct Inv Amt"; Decimal)
        {
            Description = 'BBG1.00 020813';
            Editable = false;
        }
        field(52; "Rem. Opening Inv Amt"; Decimal)
        {
            Description = 'BBG1.00 020813';
            Editable = false;
        }
        field(50000; "Ignore Advance Payment"; Boolean)
        {
            Description = 'BBG2.01 160714';

            trigger OnValidate()
            begin
                TESTFIELD("Create Invoice Only", FALSE);
            end;
        }
        field(50001; "Create Invoice Only"; Boolean)
        {
            Description = 'BBG2.01 160714';

            trigger OnValidate()
            begin
                TESTFIELD("Ignore Advance Payment", FALSE);
            end;
        }
        field(50002; "From MS Company"; Boolean)
        {
            Editable = false;
        }
        field(50003; "MScompany Posted Doc No."; Code[20])
        {
            Editable = false;
        }
        field(50004; "Pmt from MS Company Ref. No."; Code[20])
        {
            Editable = false;
        }
        field(50005; Recordfind; Boolean)
        {
        }
        field(50006; "Correction req"; Boolean)
        {
        }
        field(50007; "Vizag Data"; Boolean)
        {
        }
        field(50008; "Advance Pmt Amount"; Decimal)
        {
        }
        field(50009; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Confirmed Order"."No." WHERE("Introducer Code" = FIELD("Paid To"),
                                                         Status = FILTER(<> Vacate & <> Cancelled));

            trigger OnValidate()
            var
                BBGSetups: Record "BBG Setups";
            begin
                TESTFIELD("Special Incentive for Bonanza");
                IF "Special Incentive for Bonanza" THEN BEGIN
                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Special Incentive Bonanza G/L");
                    BBGSetups.TESTFIELD("Special Inct. Bonanza Cash G/L");
                    "Payment Mode" := "Payment Mode"::Cash;
                    "Bank/G L Code" := BBGSetups."Special Inct. Bonanza Cash G/L";
                    Type := Type::Incentive;
                END ELSE
                    "Bank/G L Code" := '';
            end;
        }
        field(50010; "Special Incentive for Bonanza"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF NOT "Special Incentive for Bonanza" THEN
                    "Application No." := '';
            end;
        }
        field(50011; "Spl. Inct. Send for Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50012; "Send for App. Spl. Inc Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50013; "Special Incentive Approved"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50014; "Special Inc. Approved By"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50015; "Special Inc. Approved DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50016; "Special Inc. Send By"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50017; "Special Inc. Approver ID"; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50018; "Special Inc. Reject Comment"; Text[200])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("Special Incentive Approved", FALSE);
                TESTFIELD("Special Inc. Rejected", FALSE);
                "Special Inc. Reject Dt." := CURRENTDATETIME;
            end;
        }
        field(50019; "Special Inc. Reject Dt."; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50020; "Special Inc. Rejected"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50021; "Ref. External Doc. No."; Code[50])   //New field added 15122025 
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document No.")
        {
            Clustered = true;
        }
        key(Key2; "Paid To", "Posting Date")
        {
        }
        key(Key3; "From MS Company")
        {
        }
        key(Key4; "Pmt from MS Company Ref. No.")
        {
        }
        key(Key5; "Paid To", "Posting Date", Post, "Invoice Reversed", "Sub Type")
        {
        }
        key(Key6; "Paid To", Post)
        {
        }
        key(Key7; "Posting Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //BBG1.00 200613
        PHeader.RESET;
        PHeader.SETRANGE("No.", "Document No.");
        IF PHeader.FINDFIRST THEN
            ERROR('Please post the Voucher from Pending Associate Payment Voucher');
        //BBG1.00 200613

        VoucherLine.RESET;
        VoucherLine.SETRANGE(VoucherLine."Voucher No.", "Document No.");
        IF VoucherLine.FINDSET THEN
            VoucherLine.DELETEALL(TRUE);
    end;

    trigger OnInsert()
    begin
        IF "Document No." = '' THEN BEGIN
            UnitSetup.GET;
            UnitSetup.TESTFIELD("Voucher No. Series");
            NoSeriesMgt.InitSeries(UnitSetup."Voucher No. Series", xRec."No. Series", WORKDATE, "Document No.",
             "No. Series");
        END;

        "User ID" := USERID;

        IF UserSetup.GET("User ID") THEN BEGIN
            "User Branch Code" := UserSetup."User Branch";
            "Shortcut Dimension 1 Code" := UserSetup."Purchase Resp. Ctr. Filter";
        END;
        "Document Date" := WORKDATE;
    end;

    trigger OnRename()
    begin
        //BBG1.00 210814
        PHeader.RESET;
        PHeader.SETRANGE("No.", "Document No.");
        IF PHeader.FINDFIRST THEN
            ERROR('You can not rename. Please post the Voucher from Pending Associate Payment Voucher');
        //BBG1.00 210814

        VoucherLine.RESET;
        VoucherLine.SETRANGE(VoucherLine."Voucher No.", "Document No.");
        IF VoucherLine.FINDSET THEN
            REPEAT
                VoucherLine."Voucher No." := "Document No.";
                VoucherLine.MODIFY;
            UNTIL VoucherLine.NEXT = 0;
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
        VoucherLine: Record "Voucher Line";
        GLAccount: Record "G/L Account";
        VHeader: Record "Assoc Pmt Voucher Header";
        CheckLedgEntry: Record "Check Ledger Entry";
        //VoucherAccount: Record 16547;//Need to check the code in UAT
        DebitVoucherAccount: Record "Voucher Posting Debit Account";
        CreditVoucherAccount: Record "Voucher Posting Credit Account";
        PHeader: Record "Purchase Header";
        APVHeader: Record "Assoc Pmt Voucher Header";
        BankLedgEntry: Record "Bank Account Ledger Entry";
        ReleaseUnitApp: Codeunit "Release Unit Application";


    procedure AssistEdit(OldCommVHdr: Record "Assoc Pmt Voucher Header"): Boolean
    begin
        UnitSetup.GET;
        //TestNoSeries;
        IF NoSeriesMgt.SelectSeries(UnitSetup."Voucher No. Series", OldCommVHdr."No. Series", "No. Series") THEN BEGIN
            UnitSetup.GET;
            //  TestNoSeries;
            NoSeriesMgt.SetSeries("Document No.");
            EXIT(TRUE);
        END;
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
        RecVoucherLine: Record "Voucher Line";
    begin
        RecVoucherLine.RESET;
        RecVoucherLine.SETRANGE("Voucher No.", "Document No.");
        IF RecVoucherLine.FINDFIRST THEN
            ERROR('Please delete the Existing Lines');
    end;
}

