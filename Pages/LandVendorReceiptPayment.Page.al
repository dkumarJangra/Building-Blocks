page 50164 "Land Vendor Receipt Payment"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Land Vendor Receipt Payment";
    SourceTableView = WHERE(Posted = CONST(false));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                }
                field("Payment Transaction Type"; Rec."Payment Transaction Type")
                {
                }
                field("Payment Mode"; Rec."Payment Mode")
                {

                    trigger OnValidate()
                    begin
                        ExistsOppDocument;
                    end;
                }
                field("Payment Method"; Rec."Payment Method")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Account Type"; Rec."Account Type")
                {
                }
                field("Account No."; Rec."Account No.")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("TDS Nature of Deduction"; Rec."TDS Nature of Deduction")
                {
                }
                field("Assessee Code"; Rec."Assessee Code")
                {
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                }
                field("User Branch Code"; Rec."User Branch Code")
                {
                }
                field("User Branch Name"; Rec."User Branch Name")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Created By"; Rec."Created By")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field(Narration; Rec.Narration)
                {
                }
                field(Remarks; Rec.Remarks)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Function")
            {
                action("Post Payment")
                {

                    trigger OnAction()
                    begin
                        IF CONFIRM('Do you want to post the Entry') THEN BEGIN
                            Rec.TESTFIELD(Posted, FALSE);
                            Rec.TESTFIELD("Payment Transaction Type");
                            PostRefund(Rec);
                            MESSAGE('Posting Done');
                        END ELSE
                            ERROR('Nothing to Post');
                    end;
                }
            }
        }
    }

    var
        LandVendorReceiptPayment: Record "Land Vendor Receipt Payment";
        GenJnlLine: Record "Gen. Journal Line";
        UnitSetup: Record "Unit Setup";
        LineNo: Integer;
        DocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenJnlLineDevCharge: Record "Gen. Journal Line";
        LandAgreementHeader: Record "Land Agreement Header";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        UserSetup: Record "User Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        BBGSetups: Record "BBG Setups";
        LandLeadOppHeader: Record "Land Lead/Opp Header";
        LineNarrationTextLength: Integer;


    procedure PostRefund(LandVendRcptPayment: Record "Land Vendor Receipt Payment")
    var
        D_ConfOrder: Record "New Confirmed Order";
        PostedDocNo: Code[20];
        Line: Integer;
        PaymentMethod: Record "Payment Method";
        BondPostingGroup1: Record "Customer Posting Group";
        CashAmount: Decimal;
        CashPmtMethod: Record "Payment Method";
        NarrationText1: Text[200];
        NarrationText2: Text[200];
        ApplBankAmount: Decimal;
        V_LandVendorReceiptPayment: Record "Land Vendor Receipt Payment";
        ShortCutDime1Code: Code[20];
    begin
        LandVendRcptPayment.TESTFIELD("Payment Mode");

        ShortCutDime1Code := '';
        LandAgreementHeader.RESET;
        LandAgreementHeader.SETRANGE("Document No.", LandVendRcptPayment."Document No.");
        IF LandAgreementHeader.FINDFIRST THEN BEGIN
            LandAgreementHeader.TESTFIELD("Shortcut Dimension 1 Code");
            ShortCutDime1Code := LandAgreementHeader."Shortcut Dimension 1 Code";
        END ELSE BEGIN
            LandVendRcptPayment.TESTFIELD("Shortcut Dimension 1 Code");
            ShortCutDime1Code := LandVendRcptPayment."Shortcut Dimension 1 Code";
        END;

        UnitSetup.GET;
        UnitSetup.TESTFIELD("Land Refund Payment Template");
        UnitSetup.TESTFIELD("Land Refund Payment Batch");
        UnitSetup.TESTFIELD("Land Refund No. Series");
        PostedDocNo := '';
        BBGSetups.GET;
        BBGSetups.TESTFIELD("Land Bank Pmt. Batch Name");
        BBGSetups.TESTFIELD("Land Bank Pmt. Template Name");
        BBGSetups.TESTFIELD("Land Payment No. Series");
        IF LandVendRcptPayment."Payment Mode" = LandVendRcptPayment."Payment Mode"::Payment THEN BEGIN
            PostedDocNo := NoSeriesMgt.GetNextNo(BBGSetups."Land Payment No. Series", TODAY, TRUE);
            IF LandVendRcptPayment.Narration <> '' THEN
                NarrationText1 := LandVendRcptPayment.Narration
            ELSE
                NarrationText1 := 'Land Payment Amout - ' + COPYSTR(LandVendRcptPayment."Document No.", 1, 30);

            GenJnlLineDevCharge.RESET;
            GenJnlLineDevCharge.SETFILTER("Journal Template Name", BBGSetups."Land Bank Pmt. Template Name");
            GenJnlLineDevCharge.SETRANGE("Journal Batch Name", BBGSetups."Land Bank Pmt. Batch Name");
            GenJnlLineDevCharge.DELETEALL;

            Line := 10000;
            IF PaymentMethod.GET(Rec."Payment Method") THEN;
            GenJnlLineDevCharge.INIT;
            GenJnlLineDevCharge."Journal Template Name" := BBGSetups."Land Bank Pmt. Template Name";
            GenJnlLineDevCharge."Journal Batch Name" := BBGSetups."Land Bank Pmt. Batch Name";
            GenJnlLineDevCharge."Line No." := Line;
            GenJnlLineDevCharge.VALIDATE("Posting Date", LandVendRcptPayment."Posting Date"); //BBG1.00 ALLEDK 120313
            GenJnlLineDevCharge.VALIDATE("Document Date", LandVendRcptPayment."Posting Date");
            GenJnlLineDevCharge.VALIDATE("Party Type", GenJnlLineDevCharge."Party Type"::Vendor);
            GenJnlLineDevCharge.VALIDATE("Party Code", LandVendRcptPayment."Account No.");
            GenJnlLineDevCharge.VALIDATE(Amount, LandVendRcptPayment.Amount);
            GenJnlLineDevCharge."Document Type" := GenJnlLineDevCharge."Document Type"::Payment;
            GenJnlLineDevCharge."Document No." := PostedDocNo;
            GenJnlLineDevCharge."Shortcut Dimension 1 Code" := ShortCutDime1Code;
            GenJnlLineDevCharge."Posting Type" := GenJnlLineDevCharge."Posting Type"::Running;
            GenJnlLineDevCharge."Order Ref No." := LandVendRcptPayment."Document No.";
            GenJnlLineDevCharge.Description := 'Land Vendor Payment';
            GenJnlLineDevCharge.VALIDATE("Location Code", ShortCutDime1Code);
            GenJnlLineDevCharge.VALIDATE("TDS Section Code", LandVendRcptPayment."TDS Nature of Deduction");
            // IF LandVendRcptPayment."Assessee Code" <> '' THEN
            //     GenJnlLineDevCharge."Assessee Code" := LandVendRcptPayment."Assessee Code";
            GenJnlLineDevCharge.VALIDATE("Bal. Account Type", LandVendRcptPayment."Bal. Account Type");
            GenJnlLineDevCharge.VALIDATE("Bal. Account No.", LandVendRcptPayment."Bal. Account No.");
            GenJnlLineDevCharge.VALIDATE("Shortcut Dimension 1 Code", ShortCutDime1Code);
            GeneralLedgerSetup.GET;
            GenJnlLineDevCharge.ValidateShortcutDimCode(5, LandAgreementHeader."Document No.");
            GenJnlLineDevCharge."Source Code" := 'BANKPYMTV';
            GenJnlLineDevCharge."Cheque No." := LandVendRcptPayment."Cheque No.";
            GenJnlLineDevCharge."Cheque Date" := LandVendRcptPayment."Cheque Date";
            GenJnlLineDevCharge.INSERT;
            InitVoucherNarration(GenJnlLineDevCharge."Journal Template Name", GenJnlLineDevCharge."Journal Batch Name", GenJnlLineDevCharge."Document No.",
              GenJnlLineDevCharge."Line No.", GenJnlLineDevCharge."Line No.", NarrationText1);
            PostGenJnlLinesDevCharge(GenJnlLineDevCharge, TRUE);
            IF V_LandVendorReceiptPayment.GET(LandVendRcptPayment."Document Type", LandVendRcptPayment."Document No.", LandVendRcptPayment."Document Line No.", LandVendRcptPayment."Line No.") THEN BEGIN
                V_LandVendorReceiptPayment.Posted := TRUE;
                V_LandVendorReceiptPayment."Refund Posted Document No." := PostedDocNo;
                V_LandVendorReceiptPayment.MODIFY;
            END;
        END ELSE BEGIN
            PostedDocNo := NoSeriesMgt.GetNextNo(UnitSetup."Land Refund No. Series", TODAY, TRUE);
            IF LandVendRcptPayment.Narration <> '' THEN
                NarrationText1 := LandVendRcptPayment.Narration
            ELSE
                NarrationText1 := 'Land Amout Reversed - ' + COPYSTR(LandVendRcptPayment."Document No.", 1, 30);

            GenJnlLineDevCharge.RESET;
            GenJnlLineDevCharge.SETFILTER("Journal Template Name", UnitSetup."Land Refund Payment Template");
            GenJnlLineDevCharge.SETRANGE("Journal Batch Name", UnitSetup."Land Refund Payment Batch");
            GenJnlLineDevCharge.DELETEALL;

            Line := 10000;
            IF PaymentMethod.GET(Rec."Payment Method") THEN;
            GenJnlLineDevCharge.INIT;
            GenJnlLineDevCharge."Journal Template Name" := UnitSetup."Land Refund Payment Template";
            GenJnlLineDevCharge."Journal Batch Name" := UnitSetup."Land Refund Payment Batch";
            GenJnlLineDevCharge."Line No." := Line;
            GenJnlLineDevCharge.VALIDATE("Posting Date", LandVendRcptPayment."Posting Date"); //BBG1.00 ALLEDK 120313
            GenJnlLineDevCharge.VALIDATE("Document Date", LandVendRcptPayment."Posting Date");
            GenJnlLineDevCharge.VALIDATE("Account Type", LandVendRcptPayment."Account Type");
            GenJnlLineDevCharge.VALIDATE("Account No.", LandVendRcptPayment."Account No.");
            GenJnlLineDevCharge.VALIDATE(Amount, LandVendRcptPayment.Amount);
            GenJnlLineDevCharge."Document Type" := GenJnlLineDevCharge."Document Type"::Refund;
            GenJnlLineDevCharge."Document No." := PostedDocNo;
            GenJnlLineDevCharge."Shortcut Dimension 1 Code" := ShortCutDime1Code;
            GenJnlLineDevCharge."Posting Type" := GenJnlLineDevCharge."Posting Type"::Running;
            GenJnlLineDevCharge."Order Ref No." := LandVendRcptPayment."Document No.";
            GenJnlLineDevCharge.Description := 'Land Vendor Pmt Refund';
            GenJnlLineDevCharge.VALIDATE("Location Code", ShortCutDime1Code);
            GenJnlLineDevCharge.VALIDATE("Bal. Account Type", LandVendRcptPayment."Bal. Account Type");
            GenJnlLineDevCharge.VALIDATE("Bal. Account No.", LandVendRcptPayment."Bal. Account No.");
            GenJnlLineDevCharge.VALIDATE("Shortcut Dimension 1 Code", ShortCutDime1Code);
            GeneralLedgerSetup.GET;
            GenJnlLineDevCharge.ValidateShortcutDimCode(5, LandAgreementHeader."Document No.");
            GenJnlLineDevCharge."Source Code" := 'BANKPYMTV';
            GenJnlLineDevCharge."Cheque No." := LandVendRcptPayment."Cheque No.";
            GenJnlLineDevCharge."Cheque Date" := LandVendRcptPayment."Cheque Date";
            GenJnlLineDevCharge.INSERT;
            InitVoucherNarration(GenJnlLineDevCharge."Journal Template Name", GenJnlLineDevCharge."Journal Batch Name", GenJnlLineDevCharge."Document No.",
              GenJnlLineDevCharge."Line No.", GenJnlLineDevCharge."Line No.", NarrationText1);
            PostGenJnlLinesDevCharge(GenJnlLineDevCharge, FALSE);
            IF V_LandVendorReceiptPayment.GET(LandVendRcptPayment."Document Type", LandVendRcptPayment."Document No.", LandVendRcptPayment."Document Line No.", LandVendRcptPayment."Line No.") THEN BEGIN
                V_LandVendorReceiptPayment.Posted := TRUE;
                V_LandVendorReceiptPayment."Refund Posted Document No." := PostedDocNo;
                V_LandVendorReceiptPayment.MODIFY;
            END;
        END;
    end;


    procedure InitVoucherNarration(JnlTemplate: Code[10]; JnlBatch: Code[10]; DocumentNo: Code[20]; GenJnlLineNo: Integer; NarrationLineNo: Integer; LineNarrationText: Text[200])
    var
        GenJnlNarration: Record "Gen. Journal Narration";// 16549;
        LineNo: Integer;
        PayToName: Text[50];
        Cust: Record Customer;
        Vend: Record Vendor;
        OldGenJnlNarration: Record "Gen. Journal Narration";// 16549;
    begin
        OldGenJnlNarration.RESET;
        OldGenJnlNarration.SETRANGE("Journal Template Name", JnlTemplate);
        OldGenJnlNarration.SETRANGE("Journal Batch Name", JnlBatch);
        OldGenJnlNarration.SETRANGE("Document No.", DocumentNo);
        OldGenJnlNarration.SETRANGE("Gen. Journal Line No.", GenJnlLineNo);
        OldGenJnlNarration.SETRANGE("Line No.", NarrationLineNo);
        IF NOT OldGenJnlNarration.FINDFIRST THEN BEGIN
            LineNarrationTextLength := STRLEN(LineNarrationText);
            GenJnlNarration.INIT;
            GenJnlNarration."Journal Template Name" := JnlTemplate;
            GenJnlNarration."Journal Batch Name" := JnlBatch;
            GenJnlNarration."Document No." := DocumentNo;
            GenJnlNarration."Gen. Journal Line No." := GenJnlLineNo;
            GenJnlNarration."Line No." := NarrationLineNo;
            GenJnlNarration.Narration := COPYSTR(LineNarrationText, 1, 50);
            GenJnlNarration.INSERT;
            IF LineNarrationTextLength > 50 THEN BEGIN
                GenJnlNarration.INIT;
                GenJnlNarration."Journal Template Name" := JnlTemplate;
                GenJnlNarration."Journal Batch Name" := JnlBatch;
                GenJnlNarration."Document No." := DocumentNo;
                GenJnlNarration."Gen. Journal Line No." := GenJnlLineNo;
                GenJnlNarration."Line No." := NarrationLineNo + 10000;
                GenJnlNarration.Narration := COPYSTR(LineNarrationText, 51, 50);
                GenJnlNarration.INSERT;
            END;
            IF LineNarrationTextLength > 100 THEN BEGIN
                GenJnlNarration.INIT;
                GenJnlNarration."Journal Template Name" := JnlTemplate;
                GenJnlNarration."Journal Batch Name" := JnlBatch;
                GenJnlNarration."Document No." := DocumentNo;
                GenJnlNarration."Gen. Journal Line No." := GenJnlLineNo;
                GenJnlNarration."Line No." := NarrationLineNo + 20000;
                GenJnlNarration.Narration := COPYSTR(LineNarrationText, 101, 50);
                GenJnlNarration.INSERT;
            END;

            IF LineNarrationTextLength > 150 THEN BEGIN
                GenJnlNarration.INIT;
                GenJnlNarration."Journal Template Name" := JnlTemplate;
                GenJnlNarration."Journal Batch Name" := JnlBatch;
                GenJnlNarration."Document No." := DocumentNo;
                GenJnlNarration."Gen. Journal Line No." := GenJnlLineNo;
                GenJnlNarration."Line No." := NarrationLineNo + 30000;
                GenJnlNarration.Narration := COPYSTR(LineNarrationText, 151, 50);
                GenJnlNarration.INSERT;
            END;
        END;
    end;


    procedure PostGenJnlLinesDevCharge(GenJournalLine_2: Record "Gen. Journal Line"; BankPayment: Boolean)
    begin
        CLEAR(GenJnlPostLine);
        CLEAR(GenJnlPostBatch);
        UserSetup.GET(USERID);
        IF BankPayment THEN BEGIN
            BBGSetups.GET;
            BBGSetups.TESTFIELD("Land Bank Pmt. Template Name");
            BBGSetups.TESTFIELD("Land Bank Pmt. Batch Name");
            GenJournalLine_2.SETRANGE("Journal Template Name", BBGSetups."Land Bank Pmt. Template Name");
            GenJournalLine_2.SETRANGE("Journal Batch Name", BBGSetups."Land Bank Pmt. Batch Name");
            IF GenJournalLine_2.FINDFIRST THEN BEGIN
                REPEAT
                    //GenJnlPostLine.SetDocumentNo(GenJournalLine_2."Document No.");
                    GenJnlPostLine.RunWithCheck(GenJournalLine_2);
                UNTIL GenJournalLine_2.NEXT = 0;
            END;
        END ELSE BEGIN
            UnitSetup.GET;
            UnitSetup.TESTFIELD("Land Refund Payment Template");
            UnitSetup.TESTFIELD("Land Refund Payment Batch");

            GenJournalLine_2.SETRANGE("Journal Template Name", UnitSetup."Land Refund Payment Template");
            GenJournalLine_2.SETRANGE("Journal Batch Name", UnitSetup."Land Refund Payment Batch");
            IF GenJournalLine_2.FINDFIRST THEN BEGIN
                REPEAT
                    //GenJnlPostLine.SetDocumentNo(GenJournalLine_2."Document No.");
                    GenJnlPostLine.RunWithCheck(GenJournalLine_2);
                UNTIL GenJournalLine_2.NEXT = 0;
            END;
        END;
        //GenJnlPostBatch.DeleteGenJournalNarration(GenJournalLine_2);
        GenJournalLine_2.DELETEALL;
    end;

    local procedure ExistsOppDocument()
    var
        LandLeadLine: Record "Land Lead/Opp Line";
        LandLeadOppHeader: Record "Land Lead/Opp Header";
        LandLeadOppLine: Record "Land Lead/Opp Line";
        LandAgreementHeader: Record "Land Agreement Header";
        LandAgreementLine: Record "Land Agreement Line";
    begin
        IF Rec."Document Type" = Rec."Document Type"::Lead THEN BEGIN
            LandLeadLine.RESET;
            LandLeadLine.SETRANGE("Document No.", Rec."Document No.");
            LandLeadLine.SETRANGE("Line No.", Rec."Document Line No.");
            LandLeadLine.SETFILTER("Vendor Code", '<>%1', '');
            IF LandLeadLine.FINDFIRST THEN BEGIN
                LandLeadOppHeader.RESET;
                LandLeadOppHeader.SETCURRENTKEY("Lead Document No.");
                LandLeadOppHeader.SETRANGE("Lead Document No.", LandLeadLine."Document No.");
                IF LandLeadOppHeader.FINDFIRST THEN BEGIN
                    LandLeadOppLine.RESET;
                    LandLeadOppLine.SETRANGE("Document No.", LandLeadOppHeader."Document No.");
                    LandLeadOppLine.SETRANGE("Line No.", LandLeadLine."Line No.");
                    IF LandLeadOppLine.FINDFIRST THEN
                        ERROR('Opportunity Document already created');
                END;
            END;
        END;

        IF Rec."Document Type" = Rec."Document Type"::Opportunity THEN BEGIN
            LandLeadLine.RESET;
            LandLeadLine.SETRANGE("Document No.", Rec."Document No.");
            LandLeadLine.SETRANGE("Line No.", Rec."Document Line No.");
            LandLeadLine.SETFILTER("Vendor Code", '<>%1', '');
            IF LandLeadLine.FINDFIRST THEN BEGIN
                LandAgreementHeader.RESET;
                LandAgreementHeader.SETCURRENTKEY("Opportunity Document No.");
                LandAgreementHeader.SETRANGE("Opportunity Document No.", LandLeadLine."Document No.");
                IF LandAgreementHeader.FINDFIRST THEN BEGIN
                    LandAgreementLine.RESET;
                    LandAgreementLine.SETRANGE("Document No.", LandAgreementHeader."Document No.");
                    LandAgreementLine.SETRANGE("Line No.", LandLeadLine."Line No.");
                    IF LandAgreementLine.FINDFIRST THEN
                        ERROR('Agreement Document already created');
                END;
            END;
        END;
    end;

    local procedure CheckPostingDate()
    begin
        /*
        UserSetup.RESET;
        IF UserSetup.GET(USERID) THEN BEGIN
          IF UserSetup."Allow Back Date Posting" THEN BEGIN
            IF "Posting Date" > TODAY THEN
              ERROR('Posting Date can not be greater than ='+FORMAT(TODAY));
          END ELSE
            IF "Posting Date" <> TODAY THEN
              ERROR('Posting Date can not be differ from Today Date ='+FORMAT(TODAY));
        END;
        
        
        IF "Document Type" = "Document Type"::Lead THEN BEGIN
          LandLeadOppHeader.RESET;
          LandLeadOppHeader.SETRANGE("Document Type",LandLeadOppHeader."Document Type"::Lead);
          LandLeadOppHeader.SETRANGE("Document No.","Document No.");
          IF LandLeadOppHeader.FINDFIRST THEN BEGIN
            IF "Posting Date" < LandLeadOppHeader."Creation Date" THEN
              ERROR('Posting date can not be less than = '+FORMAT(LandLeadOppHeader."Creation Date"));
            IF "Posting Date" > TODAY THEN
              ERROR('Posting data can not be greater than = '+FORMAT(TODAY));
          END;
        
        END ELSE IF "Document Type" = "Document Type"::Opportunity THEN BEGIN
          LandLeadOppHeader.RESET;
          LandLeadOppHeader.SETRANGE("Document Type",LandLeadOppHeader."Document Type"::Opportunity);
          LandLeadOppHeader.SETRANGE("Document No.","Document No.");
          IF LandLeadOppHeader.FINDFIRST THEN BEGIN
            IF "Posting Date" < LandLeadOppHeader."Creation Date" THEN
              ERROR('Posting date can not be less than = '+FORMAT(LandLeadOppHeader."Creation Date"));
            IF "Posting Date" > TODAY THEN
              ERROR('Posting data can not be greater than = '+FORMAT(TODAY));
          END;
        END ELSE IF "Document Type" = "Document Type"::Agreement THEN BEGIN
          LandAgreementHeader.RESET;
          LandAgreementHeader.SETRANGE("Document No.","Document No.");
          IF LandAgreementHeader.FINDFIRST THEN BEGIN
            IF "Posting Date" < LandAgreementHeader."Creation Date" THEN
              ERROR('Posting date can not be less than = '+FORMAT(LandAgreementHeader."Creation Date"));
            IF "Posting Date" > TODAY THEN
              ERROR('Posting data can not be greater than = '+FORMAT(TODAY));
          END;
        END;
        */

    end;
}

