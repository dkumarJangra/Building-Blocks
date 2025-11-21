page 50032 "Associate Bank Correction"
{
    // ALLECK 160313: Added Role for Cheque Correction
    // ALLEAD-170313: Length of Cheque No/Transaction No. increased from 7 to 20

    PageType = List;
    Permissions = TableData "G/L Entry" = rimd,
                  TableData "Cust. Ledger Entry" = rimd,
                  TableData "Vendor Ledger Entry" = rimd,
                  TableData "Purch. Inv. Header" = rimd,
                  TableData "Bank Account Ledger Entry" = rimd,
                  TableData "Check Ledger Entry" = rimd,
                  TableData "Detailed Cust. Ledg. Entry" = rimd,
                  TableData "Detailed Vendor Ledg. Entry" = rimd,
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
                        BALEntry.RESET;
                        BALEntry.SETRANGE(Open, TRUE);
                        BALEntry.SETRANGE(Reversed, FALSE);
                        IF BALEntry.FINDFIRST THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"Bank Account Ledger Entries", BALEntry) = ACTION::LookupOK THEN BEGIN
                                BondNo := BALEntry."Document No.";
                                ChequeNo := BALEntry."Cheque No.";
                                PostDocNo := BALEntry."Document No.";
                                //BankNo := BALEntry."Bank Account No.";
                                IF BAccount.GET(BALEntry."Bank Account No.") THEN
                                    BankName := BAccount.Name;
                            END ELSE
                                ChequeNo := '';
                        END;
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
                field("Bank Correction"; BankCodeCorrection)
                {
                    Caption = 'Bank Correction';

                    trigger OnValidate()
                    begin
                        CurrPAGEUpdateControl;
                    end;
                }
                field("New Bank Code"; CorrectBankCode)
                {
                    Caption = 'New Bank Code';
                    Enabled = CorrectBankCodeEnable;
                    TableRelation = "Bank Account";
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
                    begin
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016

                        IF PostDocNo <> '' THEN BEGIN
                            BankAccReconciliationLine.RESET;
                            BankAccReconciliationLine.SETRANGE("Document No.", PostDocNo);
                            IF BankAccReconciliationLine.FINDFIRST THEN
                                ERROR('Check BRS');
                        END;
                        //ALLECK 160313 START
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'A_CHEQUECORRECTION');
                        IF NOT MemberOf.FINDFIRST THEN
                            ERROR('You do not have permission of role  :A_CHEQUECORRECTION');
                        //ALLECK 160313 End
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        IF BondNo = '' THEN
                            ERROR('Please select the posted Document No.');
                        IF CorrectBankCode = '' THEN
                            ERROR('Please define the New Bank Code');

                        Companywise.RESET;
                        Companywise.SETRANGE("MSC Company", TRUE);
                        IF Companywise.FINDFIRST THEN BEGIN
                            IF Companywise."Company Code" = COMPANYNAME THEN BEGIN
                                IF CONFIRM('Update Bank details') THEN BEGIN
                                    GLEntry.RESET;
                                    GLEntry.SETCURRENTKEY("Document No.");
                                    GLEntry.SETRANGE("Document No.", PostDocNo);
                                    GLEntry.SETRANGE("Bal. Account No.", BALEntry."Bank Account No.");
                                    GLEntry.SETRANGE("Transaction No.", BALEntry."Transaction No.");
                                    IF GLEntry.FINDSET THEN
                                        REPEAT
                                            IF BankCodeCorrection THEN
                                                GLEntry."Bal. Account No." := CorrectBankCode;
                                            GLEntry.MODIFY;
                                        UNTIL GLEntry.NEXT = 0;

                                    GLEntry.RESET;
                                    GLEntry.SETCURRENTKEY("Document No.");
                                    GLEntry.SETRANGE("Document No.", PostDocNo);
                                    GLEntry.SETRANGE("Source No.", BALEntry."Bank Account No.");
                                    GLEntry.SETRANGE("Transaction No.", BALEntry."Transaction No.");
                                    IF GLEntry.FINDSET THEN
                                        REPEAT
                                            IF BankCodeCorrection THEN
                                                GLEntry."Source No." := CorrectBankCode;
                                            GLEntry.MODIFY;
                                        UNTIL GLEntry.NEXT = 0;


                                    CheckLedgerEntry.RESET;
                                    CheckLedgerEntry.SETCURRENTKEY("Document No.");
                                    CheckLedgerEntry.SETRANGE("Document No.", PostDocNo);
                                    //CheckLedgerEntry.SETRANGE("Check No.",BALEntry."Cheque No.");
                                    CheckLedgerEntry.SETRANGE("Bank Account Ledger Entry No.", BALEntry."Entry No.");
                                    CheckLedgerEntry.SETRANGE("Bank Account No.", BALEntry."Bank Account No.");
                                    IF CheckLedgerEntry.FINDSET THEN
                                        REPEAT
                                            IF BankCodeCorrection THEN
                                                CheckLedgerEntry."Bank Account No." := CorrectBankCode;
                                            CheckLedgerEntry.MODIFY;
                                        UNTIL CheckLedgerEntry.NEXT = 0;

                                    BALEntry.RESET;
                                    BALEntry.SETCURRENTKEY("Document No.");
                                    BALEntry.SETRANGE("Document No.", PostDocNo);
                                    BALEntry.SETRANGE("Cheque No.", BALEntry."Cheque No.");
                                    IF BALEntry.FINDSET THEN
                                        REPEAT
                                            IF BankCodeCorrection THEN
                                                BALEntry."Bank Account No." := CorrectBankCode;
                                            BALEntry.MODIFY;
                                        UNTIL BALEntry.NEXT = 0;

                                    AssociatePaymentHdr.RESET;
                                    AssociatePaymentHdr.SETCURRENTKEY("Posted Document No.");
                                    AssociatePaymentHdr.SETRANGE("Posted Document No.", PostDocNo);
                                    IF AssociatePaymentHdr.FINDSET THEN
                                        REPEAT
                                            IF BAccount.GET(CorrectBankCode) THEN;
                                            VoucherHeader.RESET;
                                            VoucherHeader.CHANGECOMPANY(AssociatePaymentHdr."Company Name");
                                            VoucherHeader.SETCURRENTKEY("Pmt from MS Company Ref. No.");
                                            VoucherHeader.SETRANGE("Pmt from MS Company Ref. No.", AssociatePaymentHdr."Document No.");
                                            IF VoucherHeader.FINDSET THEN
                                                REPEAT
                                                    IF BankCodeCorrection THEN BEGIN
                                                        VoucherHeader."Bank/G L Code" := CorrectBankCode;
                                                        VoucherHeader."Bank/G L Name" := BAccount.Name;
                                                    END;
                                                    VoucherHeader.MODIFY;
                                                UNTIL VoucherHeader.NEXT = 0;
                                            AssociatePaymentHdr."Bank/G L Code" := CorrectBankCode;
                                            AssociatePaymentHdr."Bank/G L Name" := BAccount.Name;
                                            AssociatePaymentHdr.MODIFY;
                                        UNTIL AssociatePaymentHdr.NEXT = 0;
                                    MESSAGE('Done');
                                    CLEARALL;
                                END;
                            END ELSE BEGIN
                                IF CONFIRM('Update Bank details') THEN BEGIN
                                    GLEntry.RESET;
                                    GLEntry.SETCURRENTKEY("Document No.");
                                    GLEntry.SETRANGE("Document No.", PostDocNo);
                                    GLEntry.SETRANGE("Bal. Account No.", BALEntry."Bank Account No.");
                                    GLEntry.SETRANGE("Transaction No.", BALEntry."Transaction No.");
                                    IF GLEntry.FINDSET THEN
                                        REPEAT
                                            IF BankCodeCorrection THEN
                                                GLEntry."Bal. Account No." := CorrectBankCode;
                                            GLEntry.MODIFY;
                                        UNTIL GLEntry.NEXT = 0;

                                    GLEntry.RESET;
                                    GLEntry.SETCURRENTKEY("Document No.");
                                    GLEntry.SETRANGE("Document No.", PostDocNo);
                                    GLEntry.SETRANGE("Source No.", BALEntry."Bank Account No.");
                                    GLEntry.SETRANGE("Transaction No.", BALEntry."Transaction No.");
                                    IF GLEntry.FINDSET THEN
                                        REPEAT
                                            IF BankCodeCorrection THEN
                                                GLEntry."Source No." := CorrectBankCode;
                                            GLEntry.MODIFY;
                                        UNTIL GLEntry.NEXT = 0;


                                    CheckLedgerEntry.RESET;
                                    CheckLedgerEntry.SETCURRENTKEY("Document No.");
                                    CheckLedgerEntry.SETRANGE("Document No.", PostDocNo);
                                    //CheckLedgerEntry.SETRANGE("Check No.",BALEntry."Cheque No.");
                                    CheckLedgerEntry.SETRANGE("Bank Account Ledger Entry No.", BALEntry."Entry No.");
                                    CheckLedgerEntry.SETRANGE("Bank Account No.", BALEntry."Bank Account No.");
                                    IF CheckLedgerEntry.FINDSET THEN
                                        REPEAT
                                            IF BankCodeCorrection THEN
                                                CheckLedgerEntry."Bank Account No." := CorrectBankCode;
                                            CheckLedgerEntry.MODIFY;
                                        UNTIL CheckLedgerEntry.NEXT = 0;


                                    VendLedgerEntry.RESET;
                                    VendLedgerEntry.SETCURRENTKEY("Document No.");
                                    VendLedgerEntry.SETRANGE("Document No.", PostDocNo);
                                    VendLedgerEntry.SETRANGE("Bal. Account No.", BALEntry."Bank Account No.");
                                    VendLedgerEntry.SETRANGE("Transaction No.", BALEntry."Transaction No.");
                                    IF VendLedgerEntry.FINDSET THEN
                                        REPEAT
                                            IF BankCodeCorrection THEN
                                                VendLedgerEntry."Bal. Account No." := CorrectBankCode;
                                            VendLedgerEntry.MODIFY;
                                        UNTIL VendLedgerEntry.NEXT = 0;

                                    CustLedgEntry.RESET;
                                    CustLedgEntry.SETCURRENTKEY("Document No.");
                                    CustLedgEntry.SETRANGE("Document No.", PostDocNo);
                                    CustLedgEntry.SETRANGE("Bal. Account No.", BALEntry."Bank Account No.");
                                    CustLedgEntry.SETRANGE("Transaction No.", BALEntry."Transaction No.");
                                    IF CustLedgEntry.FINDSET THEN
                                        REPEAT
                                            IF BankCodeCorrection THEN
                                                CustLedgEntry."Bal. Account No." := CorrectBankCode;
                                            CustLedgEntry.MODIFY;
                                        UNTIL CustLedgEntry.NEXT = 0;


                                    PIHeader.RESET;
                                    PIHeader.SETCURRENTKEY("No.");
                                    PIHeader.SETRANGE("No.", PostDocNo);
                                    IF PIHeader.FINDFIRST THEN BEGIN
                                        IF BankCodeCorrection THEN
                                            PIHeader."Bal. Account No." := CorrectBankCode;

                                        PIHeader.MODIFY;
                                    END;


                                    /*
                                         VoucherHeader.RESET;
                                         VoucherHeader.SETCURRENTKEY("Posting Date");
                                         VoucherHeader.SETRANGE("Posting Date",GLEntry."Posting Date");
                                         IF VoucherHeader.FINDSET THEN BEGIN
                                           REPEAT
                                             VoucherHeader.CALCFIELDS("Posted Document No.");
                                             IF VoucherHeader."Posted Document No." = PostDocNo THEN BEGIN
                                               IF BankCodeCorrection THEN
                                                 VoucherHeader."Bank/G L Code" := CorrectBankCode;
                                                 VoucherHeader.MODIFY;
                                             END;
                                           UNTIL VoucherHeader.NEXT =0;
                                         END;
                                         */

                                    BALEntry.RESET;
                                    BALEntry.SETCURRENTKEY("Document No.");
                                    BALEntry.SETRANGE("Document No.", PostDocNo);
                                    BALEntry.SETRANGE("Cheque No.", BALEntry."Cheque No.");
                                    IF BALEntry.FINDSET THEN
                                        REPEAT
                                            IF BankCodeCorrection THEN
                                                BALEntry."Bank Account No." := CorrectBankCode;
                                            BALEntry.MODIFY;
                                        UNTIL BALEntry.NEXT = 0;



                                    MESSAGE('Done');
                                    CLEARALL;
                                END;
                            END;
                        END;

                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        CorrectBankCodeEnable := TRUE;
        BankBranchEnable := TRUE;
    end;

    trigger OnOpenPage()
    begin
        CurrPAGEUpdateControl;
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
        BankCodeCorrection: Boolean;
        CorrectBankCode: Code[20];
        BankNo: Code[20];
        Companywise: Record "Company wise G/L Account";
        AssociatePaymentHdr: Record "Associate Payment Hdr";

        BankBranchEnable: Boolean;

        CorrectBankCodeEnable: Boolean;
        MemberOf: Record "Access Control";
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";


    procedure CurrPAGEUpdateControl()
    begin
        //CurrPAGE.CorrectChequeNo.ENABLED(ChequeNoCorrection);
        //CurrPAGE.ChequeDate.ENABLED(ChequeDateCorrection);
        BankBranchEnable := BankBranchCorrection;
        CorrectBankCodeEnable := BankCodeCorrection;
    end;
}

