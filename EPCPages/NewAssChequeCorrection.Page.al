page 50051 "New Ass. Cheque Correction"
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
                        BALEntry.RESET;
                        BALEntry.SETRANGE(Open, TRUE);
                        IF BALEntry.FINDFIRST THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"Bank Account Ledger Entries", BALEntry) = ACTION::LookupOK THEN BEGIN
                                BondNo := BALEntry."Document No.";
                                ChequeNo := BALEntry."Cheque No.";
                                PostDocNo := BALEntry."Document No.";
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
                    begin
                        //ALLECK 160313 START
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'A_CHEQUECORRECTION');
                        IF NOT MemberOf.FINDFIRST THEN
                            ERROR('You do not have permission of role  :A_CHEQUECORRECTION');
                        //ALLECK 160313 End
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        CompanyWise.RESET;
                        CompanyWise.SETRANGE(CompanyWise."MSC Company", TRUE);
                        IF CompanyWise.FINDFIRST THEN BEGIN
                            IF CompanyWise."Company Code" <> COMPANYNAME THEN
                                ERROR('This process will done from MSCompany');
                        END;

                        IF BondNo = '' THEN
                            ERROR('Please select the posted Document No.');
                        IF ChequeNo = '' THEN
                            ERROR('Please define the Cheque No');
                        IF CorrectChequeNo = '' THEN
                            ERROR('Please define the New Cheque No.');
                        IF ChequeDateCorrection THEN
                            IF ChequeDate = 0D THEN
                                ERROR('Please define the Cheque Date');

                        BankCheq := '';

                        IF CONFIRM('Update cheque details') THEN BEGIN
                            AssociatePmtHdr.RESET;
                            AssociatePmtHdr.SETCURRENTKEY("Posted Document No.");
                            AssociatePmtHdr.SETRANGE("Posted Document No.", PostDocNo);
                            IF AssociatePmtHdr.FINDSET THEN BEGIN
                                REPEAT
                                    IF AssociatePmtHdr."Line Type" = AssociatePmtHdr."Line Type"::Header THEN BEGIN
                                        IF ChequeNoCorrection THEN BEGIN
                                            BankCheq := AssociatePmtHdr."Cheque No.";
                                            AssociatePmtHdr."Cheque No." := CorrectChequeNo;
                                        END;
                                        IF ChequeDateCorrection THEN BEGIN
                                            AssociatePmtHdr."Cheque Date" := ChequeDate;
                                        END;
                                        AssociatePmtHdr.MODIFY;

                                    END;
                                    VoucherHeader.RESET;
                                    VoucherHeader.CHANGECOMPANY(AssociatePmtHdr."Company Name");
                                    VoucherHeader.SETCURRENTKEY("Pmt from MS Company Ref. No.");
                                    VoucherHeader.SETRANGE("Pmt from MS Company Ref. No.", AssociatePmtHdr."Document No.");
                                    IF VoucherHeader.FINDFIRST THEN BEGIN
                                        VoucherHeader.CALCFIELDS("Posted Document No.");
                                        IF ChequeNoCorrection THEN
                                            VoucherHeader."Cheque No." := CorrectChequeNo;
                                        IF ChequeDateCorrection THEN
                                            VoucherHeader."Cheque Date" := ChequeDate;
                                        VoucherHeader.MODIFY;
                                    END;
                                UNTIL AssociatePmtHdr.NEXT = 0;

                                GLEntry.RESET;
                                GLEntry.SETCURRENTKEY("Document No.");
                                GLEntry.SETRANGE("Document No.", AssociatePmtHdr."Posted Document No.");
                                GLEntry.SETRANGE(GLEntry."BBG Cheque No.", BankCheq);
                                IF GLEntry.FINDSET THEN
                                    REPEAT
                                        IF ChequeNoCorrection THEN
                                            GLEntry."BBG Cheque No." := CorrectChequeNo;
                                        IF ChequeDateCorrection THEN
                                            GLEntry."BBG Cheque Date" := ChequeDate;
                                        GLEntry.MODIFY;
                                    UNTIL GLEntry.NEXT = 0;

                                BALEntry.RESET;
                                BALEntry.SETCURRENTKEY("Document No.");
                                BALEntry.SETRANGE("Document No.", AssociatePmtHdr."Posted Document No.");
                                BALEntry.SETRANGE("Cheque No.", BankCheq);
                                IF BALEntry.FINDSET THEN
                                    REPEAT
                                        IF ChequeNoCorrection THEN BEGIN
                                            BALEntry."Cheque No." := CopyStr(CorrectChequeNo, 1, 10);
                                            BALEntry."Cheque No.1" := CorrectChequeNo;
                                        END;
                                        IF ChequeDateCorrection THEN
                                            BALEntry."Cheque Date" := ChequeDate;
                                        BALEntry.MODIFY;
                                    UNTIL BALEntry.NEXT = 0;
                            END ELSE BEGIN
                                GLEntry.RESET;
                                GLEntry.SETCURRENTKEY("Document No.");
                                GLEntry.SETRANGE("Document No.", PostDocNo);
                                GLEntry.SETRANGE(GLEntry."BBG Cheque No.", BALEntry."Cheque No.");
                                IF GLEntry.FINDSET THEN
                                    REPEAT
                                        IF ChequeNoCorrection THEN
                                            GLEntry."BBG Cheque No." := CorrectChequeNo;
                                        IF ChequeDateCorrection THEN
                                            GLEntry."BBG Cheque Date" := ChequeDate;
                                        GLEntry.MODIFY;
                                    UNTIL GLEntry.NEXT = 0;

                                VendLedgerEntry.RESET;
                                VendLedgerEntry.SETCURRENTKEY("Document No.");
                                VendLedgerEntry.SETRANGE("Document No.", PostDocNo);
                                VendLedgerEntry.SETRANGE("Cheque No.", BALEntry."Cheque No.");
                                IF VendLedgerEntry.FINDSET THEN
                                    REPEAT
                                        IF ChequeNoCorrection THEN
                                            VendLedgerEntry."Cheque No." := CorrectChequeNo;
                                        IF ChequeDateCorrection THEN
                                            VendLedgerEntry."Cheque Date" := ChequeDate;
                                        VendLedgerEntry.MODIFY;
                                    UNTIL VendLedgerEntry.NEXT = 0;

                                BALEntry.RESET;
                                BALEntry.SETCURRENTKEY("Document No.");
                                BALEntry.SETRANGE("Document No.", PostDocNo);
                                BALEntry.SETRANGE("Cheque No.", BALEntry."Cheque No.");
                                IF BALEntry.FINDSET THEN
                                    REPEAT
                                        IF ChequeNoCorrection THEN begin
                                            BALEntry."Cheque No." := CopyStr(CorrectChequeNo, 1, 10);
                                            BALEntry."Cheque No.1" := CorrectChequeNo;
                                        end;
                                        IF ChequeDateCorrection THEN
                                            BALEntry."Cheque Date" := ChequeDate;
                                        BALEntry.MODIFY;
                                    UNTIL BALEntry.NEXT = 0;
                            END;
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
        CompanyWise: Record "Company wise G/L Account";
        AssociatePmtHdr: Record "Associate Payment Hdr";
        BankCheq: Text[20];

        CorrectChequeNoEnable: Boolean;

        ChequeDateEnable: Boolean;

        BankBranchEnable: Boolean;
        Text19062166: Label 'The functionality is used in MS Company';
        MemberOf: Record "Access Control";


    procedure CurrPAGEUpdateControl()
    begin
        CorrectChequeNoEnable := ChequeNoCorrection;
        ChequeDateEnable := ChequeDateCorrection;
        BankBranchEnable := BankBranchCorrection;
    end;

    local procedure ChequeNoCorrectionOnPush()
    begin
        CurrPAGEUpdateControl;
    end;

    local procedure ChequeDateCorrectionOnPush()
    begin
        CurrPAGEUpdateControl;
    end;
}

