page 50013 "Ass. Cheque Correction"
{
    // ALLECK 160313: Added Role for Cheque Correction
    // ALLEAD-170313: Length of Cheque No/Transaction No. increased from 7 to 20

    PageType = List;
    Permissions = TableData "G/L Entry" = rimd,
                  TableData "Vendor Ledger Entry" = rimd,
                  TableData "Purch. Inv. Header" = rimd,
                  TableData "Bank Account Ledger Entry" = rimd,
                  TableData "Check Ledger Entry" = rimd,
                  TableData "Assoc Pmt Voucher Header" = rimd;
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Posted Document No."; PostDocNo)
                {
                    Caption = 'Posted Document No.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        BankName := '';
                        TransactionNo := 0;
                        BALEntry.RESET;
                        BALEntry.SETRANGE(Open, TRUE);
                        IF BALEntry.FINDFIRST THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"Bank Account Ledger Entries", BALEntry) = ACTION::LookupOK THEN BEGIN
                                BondNo := BALEntry."Document No.";
                                ChequeNo := BALEntry."Cheque No.";
                                PostDocNo := BALEntry."Document No.";
                                PostingDate := BALEntry."Posting Date";
                                TransactionNo := BALEntry."Transaction No.";
                                IF BAccount.GET(BALEntry."Bank Account No.") THEN
                                    BankName := BAccount.Name;
                            END ELSE
                                ChequeNo := '';
                        END;
                    end;
                }
                field("Cheque No."; ChequeNo)
                {
                    Caption = 'Cheque No.';
                    Editable = false;
                }
                field("Cheque Date"; BALEntry."Cheque Date")
                {
                    Caption = 'Cheque Date';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        IF STRLEN(CorrectChequeNo) < 6 THEN
                            ERROR('Wrong Entry No.');
                    end;
                }
                field("Bank Code"; BALEntry."Bank Account No.")
                {
                    Caption = 'Bank Code';
                    Editable = false;
                    Enabled = BankBranchEnable;
                }
                field("Bank Name"; BankName)
                {
                    Caption = 'Bank Name';
                    Editable = false;
                }
                field("Cheque Correction"; ChequeNoCorrection)
                {
                    Caption = 'Cheque Correction';

                    trigger OnValidate()
                    begin
                        ChequeNoCorrectionOnPush;
                    end;
                }
                field("New Cheque No."; CorrectChequeNo)
                {
                    Caption = 'New Cheque No.';
                    Enabled = CorrectChequeNoEnable;

                    trigger OnValidate()
                    begin
                        IF STRLEN(CorrectChequeNo) < 6 THEN
                            ERROR('Wrong Entry No.');
                    end;
                }
                field("Cheque Date Correction"; ChequeDateCorrection)
                {
                    Caption = 'Cheque Date Correction';

                    trigger OnValidate()
                    begin
                        ChequeDateCorrectionOnPush;
                    end;
                }
                field("New Cheque Date"; ChequeDate)
                {
                    Caption = 'New Cheque Date';
                    Enabled = ChequeDateEnable;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Function)
            {
                Caption = 'Function';
                action(Post)
                {
                    Caption = 'Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        ReleaseBondApplication: Codeunit "Release Unit Application";
                        ConfirmedOrder: Record "Confirmed Order";
                        ChequeLength: Integer;
                    begin
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        //ALLECK 160313 START
                        Memberof.SETRANGE(Memberof."User Name", USERID);
                        Memberof.SETRANGE(Memberof."Role ID", 'A_CHEQUECORRECTION');
                        IF NOT Memberof.FINDFIRST THEN
                            ERROR('You do not have permission of role  :A_CHEQUECORRECTION');
                        //ALLECK 160313 End
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        //ERROR('This batch is not in use');

                        IF BondNo = '' THEN
                            ERROR('Please select the posted Document No.');
                        IF ChequeNo = '' THEN
                            ERROR('Please define the Cheque No');
                        IF CorrectChequeNo = '' THEN
                            ERROR('Please define the New Cheque No.');
                        IF ChequeDateCorrection THEN
                            IF ChequeDate = 0D THEN
                                ERROR('Please define the Cheque Date');

                        IF CONFIRM('Update cheque details') THEN BEGIN
                            GLEntry.RESET;
                            GLEntry.SETCURRENTKEY("Document No.");
                            GLEntry.SETRANGE("Document No.", PostDocNo);
                            GLentry.SetRange("Posting Date", PostingDate);
                            //  GLEntry.SETRANGE(GLEntry."BBG Cheque No.", ChequeNo);
                            //GLEntry.SETRANGE("Transaction No.", TransactionNo);
                            IF GLEntry.FINDSET THEN
                                REPEAT
                                    IF ChequeNoCorrection THEN
                                        GLEntry."BBG Cheque No." := CorrectChequeNo;
                                    IF ChequeDateCorrection THEN
                                        GLEntry."BBG Cheque Date" := ChequeDate;
                                    GLEntry.MODIFY;
                                UNTIL GLEntry.NEXT = 0;

                            CheckLedgerEntry.RESET;
                            CheckLedgerEntry.SETCURRENTKEY("Document No.");
                            CheckLedgerEntry.SETRANGE("Document No.", PostDocNo);
                            CheckLedgerEntry.SETRANGE("Check No.", ChequeNo);
                            IF CheckLedgerEntry.FINDSET THEN
                                REPEAT
                                    IF ChequeNoCorrection THEN BEGIN
                                        CheckLedgerEntry."Check No." := CorrectChequeNo;
                                    END;
                                    IF ChequeDateCorrection THEN
                                        CheckLedgerEntry."Check Date" := ChequeDate;
                                    CheckLedgerEntry.MODIFY;
                                UNTIL CheckLedgerEntry.NEXT = 0;


                            VendLedgerEntry.RESET;
                            VendLedgerEntry.SETCURRENTKEY("Document No.");
                            VendLedgerEntry.SETRANGE("Document No.", PostDocNo);
                            VendLedgerEntry.SetRange("Posting Date", PostingDate);
                            //VendLedgerEntry.SETRANGE("Cheque No.", ChequeNo);
                            IF VendLedgerEntry.FINDSET THEN
                                REPEAT
                                    IF ChequeNoCorrection THEN
                                        VendLedgerEntry."Cheque No." := CorrectChequeNo;
                                    IF ChequeDateCorrection THEN
                                        VendLedgerEntry."Cheque Date" := ChequeDate;
                                    VendLedgerEntry.MODIFY;
                                UNTIL VendLedgerEntry.NEXT = 0;

                            CustLedgEntry.RESET;
                            CustLedgEntry.SETCURRENTKEY("Document No.");
                            CustLedgEntry.SETRANGE("Document No.", PostDocNo);
                            CustLedgEntry.SetRange("Posting Date", PostingDate);
                            //CustLedgEntry.SETRANGE("BBG Cheque No.", ChequeNo);
                            IF CustLedgEntry.FINDSET THEN
                                REPEAT
                                    IF ChequeNoCorrection THEN
                                        CustLedgEntry."BBG Cheque No." := CorrectChequeNo;
                                    IF ChequeDateCorrection THEN
                                        CustLedgEntry."BBG Cheque Date" := ChequeDate;
                                    CustLedgEntry.MODIFY;
                                UNTIL CustLedgEntry.NEXT = 0;


                            PIHeader.RESET;
                            PIHeader.SETCURRENTKEY("No.");
                            PIHeader.SETRANGE("No.", PostDocNo);
                            IF PIHeader.FINDSET THEN BEGIN
                                IF ChequeNoCorrection THEN
                                    PIHeader."Cheque No." := CorrectChequeNo;
                                IF ChequeDateCorrection THEN
                                    PIHeader."Cheque Date" := ChequeDate;
                                PIHeader.MODIFY;
                            END;



                            VoucherHeader.RESET;
                            VoucherHeader.SETCURRENTKEY("Posting Date");
                            VoucherHeader.SETRANGE("Posting Date", BALEntry."Posting Date");
                            VoucherHeader.CALCFIELDS("Posted Document No.");
                            VoucherHeader.SETRANGE("Posted Document No.", PostDocNo);
                            IF VoucherHeader.FINDSET THEN BEGIN
                                IF ChequeNoCorrection THEN
                                    VoucherHeader."Cheque No." := CorrectChequeNo;
                                IF ChequeDateCorrection THEN
                                    VoucherHeader."Cheque Date" := ChequeDate;
                                VoucherHeader.MODIFY;
                            END;

                            ChequeLength := 0;
                            ChequeLength := StrLen(CorrectChequeNo);
                            BALEntry.RESET;
                            BALEntry.SETCURRENTKEY("Document No.");
                            BALEntry.SETRANGE("Document No.", PostDocNo);
                            BALEntry.SETRANGE("Cheque No.", ChequeNo);
                            IF BALEntry.FINDSET THEN
                                REPEAT
                                    IF ChequeNoCorrection THEN begin
                                        BALEntry."Cheque No." := copystr(CorrectChequeNo, 1, 10);
                                        BALEntry."Cheque No.1" := CorrectChequeNo;
                                    END;
                                    IF ChequeDateCorrection THEN
                                        BALEntry."Cheque Date" := ChequeDate;
                                    BALEntry.MODIFY;
                                UNTIL BALEntry.NEXT = 0;

                            AppPayEntry.RESET;
                            AppPayEntry.SETCURRENTKEY("Posted Document No.");
                            AppPayEntry.SETRANGE("Posted Document No.", PostDocNo);
                            AppPayEntry.SETRANGE("Cheque No./ Transaction No.", ChequeNo);
                            IF AppPayEntry.FINDFIRST THEN BEGIN
                                IF ConfirmedOrder.GET(AppPayEntry."Document No.") THEN BEGIN
                                    ConfirmedOrder.TESTFIELD("Application Closed", FALSE);
                                    ConfirmedOrder.TESTFIELD("Registration Status", ConfirmedOrder."Registration Status"::" "); //090921
                                END;

                                IF ChequeNoCorrection THEN
                                    AppPayEntry."Cheque No./ Transaction No." := CorrectChequeNo;
                                IF ChequeDateCorrection THEN
                                    AppPayEntry."Cheque Date" := ChequeDate;
                                AppPayEntry.MODIFY;
                            END;

                            /*
                            //----------------For MScompany Start-------
                               CompanyWise.RESET;
                               CompanyWise.SETRANGE(CompanyWise."MSC Company",TRUE);
                               IF CompanyWise.FINDFIRST THEN BEGIN
                                 IF VoucherHeader."Pmt from MS Company Ref. No." <> '' THEN BEGIN
                                    AssociatePmtHdr.RESET;
                                    AssociatePmtHdr.CHANGECOMPANY(CompanyWise."Company Code");
                                    AssociatePmtHdr.SETCURRENTKEY("Document No.");
                                    AssociatePmtHdr.SETRANGE("Document No.",VoucherHeader."Pmt from MS Company Ref. No.");
                                    IF AssociatePmtHdr.FINDSET THEN
                                      REPEAT
                                        IF ChequeNoCorrection THEN
                                          AssociatePmtHdr."Cheque No." := CorrectChequeNo;
                                        IF ChequeDateCorrection THEN
                                          AssociatePmtHdr."Cheque Date" := ChequeDate;
                                        AssociatePmtHdr.MODIFY;
                                      UNTIL BALEntry.NEXT = 0;

                                    GLEntry.RESET;
                                    GLEntry.CHANGECOMPANY(CompanyWise."Company Code");
                                    GLEntry.SETCURRENTKEY("Document No.");
                                    GLEntry.SETRANGE("Document No.",AssociatePmtHdr."Posted Document No.");
                                    GLEntry.SETRANGE(GLEntry."Cheque No.",VoucherHeader."Cheque No.");
                                    IF GLEntry.FINDSET THEN
                                      REPEAT
                                        IF ChequeNoCorrection THEN
                                          GLEntry."Cheque No." := CorrectChequeNo;
                                        IF ChequeDateCorrection THEN
                                          GLEntry."Cheque Date" := ChequeDate;
                                        GLEntry.MODIFY;
                                      UNTIL GLEntry.NEXT = 0;

                                    CheckLedgerEntry.RESET;
                                    CheckLedgerEntry.CHANGECOMPANY(CompanyWise."Company Code");
                                    CheckLedgerEntry.SETCURRENTKEY("Document No.");
                                    CheckLedgerEntry.SETRANGE("Document No.",AssociatePmtHdr."Posted Document No.");
                                    CheckLedgerEntry.SETRANGE("Check No.",VoucherHeader."Cheque No.");
                                    IF CheckLedgerEntry.FINDSET THEN
                                      REPEAT
                                        IF ChequeNoCorrection THEN
                                          CheckLedgerEntry."Check No." := CorrectChequeNo;
                                        IF ChequeDateCorrection THEN
                                          CheckLedgerEntry."Check Date" := ChequeDate;
                                        CheckLedgerEntry.MODIFY;
                                      UNTIL CheckLedgerEntry.NEXT = 0;


                                    BALEntry.RESET;
                                    BALEntry.CHANGECOMPANY(CompanyWise."Company Code");
                                    BALEntry.SETCURRENTKEY("Document No.");
                                    BALEntry.SETRANGE("Document No.",AssociatePmtHdr."Posted Document No.");
                                    BALEntry.SETRANGE("Cheque No.",VoucherHeader."Cheque No.");
                                    IF BALEntry.FINDSET THEN
                                      REPEAT
                                        IF ChequeNoCorrection THEN
                                          BALEntry."Cheque No." := CorrectChequeNo;
                                        IF ChequeDateCorrection THEN
                                          BALEntry."Cheque Date" := ChequeDate;
                                        BALEntry.MODIFY;
                                      UNTIL BALEntry.NEXT = 0;
                                 END;
                              END;
                             */
                            //----------------For MS company End---

                            MESSAGE('Done');
                            CLEARALL;
                        END;

                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        BankBranchEnable := TRUE;
        ChequeDateEnable := TRUE;
        CorrectChequeNoEnable := TRUE;
    end;

    trigger OnOpenPage()
    begin
        CurrPageUpdateControl;
    end;

    var
        ChequeNoCorrection: Boolean;
        CorrectChequeNo: Text[20];
        ChequeDateCorrection: Boolean;
        ChequeDate: Date;
        BankBranchCorrection: Boolean;
        BankBranch: Text[50];
        BondNo: Code[20];
        ChequeNo: Text[20];
        PostDocNo: Code[20];
        PostingDate: DAte;
        GLEntry: Record "G/L Entry";
        BALEntry: Record "Bank Account Ledger Entry";
        CheckLedgerEntry: Record "Check Ledger Entry";
        VendLedgerEntry: Record "Vendor Ledger Entry";
        BankName: Text[60];
        PIHeader: Record "Purch. Inv. Header";
        BAccount: Record "Bank Account";
        VoucherHeader: Record "Assoc Pmt Voucher Header";
        AppPayEntry: Record "Application Payment Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        CompanyWise: Record "Company wise G/L Account";
        AssociatePmtHdr: Record "Associate Payment Hdr";

        CorrectChequeNoEnable: Boolean;

        ChequeDateEnable: Boolean;

        BankBranchEnable: Boolean;
        Text19055783: Label 'The functionality is used in LLP Company..';
        TransactionNo: Integer;
        Memberof: Record "Access Control";


    procedure CurrPageUpdateControl()
    begin
        CorrectChequeNoEnable := ChequeNoCorrection;
        ChequeDateEnable := ChequeDateCorrection;
        BankBranchEnable := BankBranchCorrection;
    end;

    local procedure ChequeNoCorrectionOnPush()
    begin
        CurrPageUpdateControl;
    end;

    local procedure ChequeDateCorrectionOnPush()
    begin
        CurrPageUpdateControl;
    end;
}

