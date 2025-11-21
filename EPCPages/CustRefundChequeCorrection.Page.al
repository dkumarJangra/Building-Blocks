page 50021 "Cust. Refund Cheque Correction"
{
    // ALLECK 160313: Added Role for Cheque Correction
    // ALLEAD-170313: Length of Cheque No/Transaction No. increased from 7 to 20
    // BBG1.8 060113 Added code for filtering Application payment Entry

    PageType = List;
    Permissions = TableData "G/L Entry" = rimd,
                  TableData "Cust. Ledger Entry" = rimd,
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
                field("Confirmed Order No."; BondNo)
                {
                    Caption = 'Confirmed Order No.';
                    TableRelation = "Application Payment Entry"."Document No." WHERE("Payment Mode" = CONST("Refund Bank"),
                                                                                      "Cheque Status" = CONST(Cleared));

                    trigger OnValidate()
                    begin
                        IF BondNo <> '' THEN BEGIN
                            ApplicationPaymentEntry.SETCURRENTKEY(Posted, "Payment Mode", "Cheque Status", "Cheque Date",
                                                           "Document Type", "Document No.", "Document Date", "Posting date");
                            ApplicationPaymentEntry.SETRANGE(Posted, TRUE);
                            ApplicationPaymentEntry.SETRANGE("Payment Mode", ApplicationPaymentEntry."Payment Mode"::"Refund Bank");
                            ApplicationPaymentEntry.SETRANGE("Document No.", BondNo);
                            IF NOT ApplicationPaymentEntry.FINDSET THEN BEGIN
                                CLEAR(ApplicationPaymentEntry);
                                ERROR('Not found');
                            END;
                        END ELSE
                            CLEAR(ApplicationPaymentEntry);
                    end;
                }
                field("Cheque No."; ChequeNo)
                {
                    Caption = 'Cheque No.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        APPEntry.RESET;
                        APPEntry.SETRANGE("Document No.", BondNo);
                        //APPEntry.SETRANGE("Cheque Status",APPEntry."Cheque Status"::" ");
                        APPEntry.SETRANGE("Payment Mode", APPEntry."Payment Mode"::"Refund Bank");
                        //APPEntry.SETFILTER("Cheque No./ Transaction No.",'<>%1','');
                        APPEntry.SETRANGE(Posted, TRUE);
                        IF APPEntry.FINDFIRST THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"Application Payment Entry List", APPEntry) = ACTION::LookupOK THEN BEGIN
                                ChequeNo := APPEntry."Cheque No./ Transaction No.";
                                ApplicationPaymentEntry := APPEntry;
                                PostDocNo := ApplicationPaymentEntry."Posted Document No.";
                            END ELSE
                                ChequeNo := '';
                        END;
                    end;
                }
                field("Existing Cheque No."; ApplicationPaymentEntry."Cheque No./ Transaction No.")
                {
                    Caption = 'Existing Cheque No.';
                    Editable = false;
                }
                field("Existing Cheque Date"; ApplicationPaymentEntry."Cheque Date")
                {
                    Caption = 'Existing Cheque Date';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        IF STRLEN(CorrectChequeNo) < 6 THEN
                            ERROR('Wrong Entry No.');
                    end;
                }
                field("Existing Cheque Bank and Branch"; ApplicationPaymentEntry."Cheque Bank and Branch")
                {
                    Caption = 'Existing Cheque Bank and Branch';
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
                field(ChequeDate; ChequeDate)
                {
                    Caption = 'ChequeDate';
                    Enabled = ChequeDateEnable;
                }
                field("Bank And Branch Correction"; BankBranchCorrection)
                {
                    Caption = 'Bank And Branch Correction';

                    trigger OnValidate()
                    begin
                        BankBranchCorrectionOnPush;
                    end;
                }
                field("Bank And Branch"; BankBranch)
                {
                    Caption = 'Bank And Branch';
                    Enabled = BankBranchEnable;
                }
                field("Posted Document No."; PostDocNo)
                {
                    Caption = 'Posted Document No.';
                    Editable = false;
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
                    begin
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        //ALLECK 160313 START
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'A_CHEQUECORRECTION');
                        IF NOT MemberOf.FINDFIRST THEN
                            ERROR('You do not have permission of role  :A_CHEQUECORRECTION');
                        //ALLECK 160313 End
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        IF BondNo = '' THEN
                            ERROR('Please define the Bond No');
                        IF ChequeNo = '' THEN
                            ERROR('Please define the Cheque No');
                        IF PostDocNo = '' THEN
                            ERROR('Please define the Posted Document No.');
                        IF CorrectChequeNo = '' THEN
                            ERROR('Please define the New Cheque No.');
                        //    IF ChequeDateCorrection THEN
                        IF ChequeDate = 0D THEN
                            ERROR('Please define the Cheque Date');
                        IF BankBranchCorrection THEN
                            IF BankBranch = '' THEN
                                ERROR('Please define the Bank And Branch');

                        IF CONFIRM('Update cheque details') THEN BEGIN
                            //BBG1.8 060113
                            ApplicationPaymentEntry.SETRANGE("Document No.", BondNo);
                            ApplicationPaymentEntry.SETRANGE("Posted Document No.", PostDocNo);
                            ApplicationPaymentEntry.SETRANGE("Cheque No./ Transaction No.", ChequeNo);
                            //BBG1.8 060113
                            IF ApplicationPaymentEntry.FINDFIRST THEN BEGIN
                                IF ConfirmedOrder.GET(ApplicationPaymentEntry."Document No.") THEN BEGIN
                                    ConfirmedOrder.TESTFIELD("Application Closed", FALSE);
                                    ConfirmedOrder.TESTFIELD("Registration Status", ConfirmedOrder."Registration Status"::" "); //090921
                                END;
                                UnitPaymentEntry.RESET;
                                UnitPaymentEntry.SETRANGE("Document No.", ApplicationPaymentEntry."Document No.");
                                UnitPaymentEntry.SETRANGE("Cheque No./ Transaction No.", ApplicationPaymentEntry."Cheque No./ Transaction No.");
                                IF UnitPaymentEntry.FINDSET THEN
                                    REPEAT
                                        IF ChequeNoCorrection THEN
                                            UnitPaymentEntry."Cheque No./ Transaction No." := CorrectChequeNo;
                                        IF ChequeDateCorrection THEN
                                            UnitPaymentEntry."Cheque Date" := ChequeDate;
                                        IF BankBranchCorrection THEN
                                            ApplicationPaymentEntry."Cheque Bank and Branch" := BankBranch;
                                        UnitPaymentEntry.MODIFY;
                                    UNTIL UnitPaymentEntry.NEXT = 0;
                                GLEntry.RESET;
                                GLEntry.SETCURRENTKEY("Document No.");
                                GLEntry.SETRANGE("Document No.", PostDocNo);
                                GLEntry.SETRANGE("BBG Cheque No.", ApplicationPaymentEntry."Cheque No./ Transaction No.");
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
                                BALEntry.SETRANGE("Document No.", PostDocNo);
                                BALEntry.SETRANGE("Cheque No.", ApplicationPaymentEntry."Cheque No./ Transaction No.");
                                IF BALEntry.FINDSET THEN
                                    REPEAT
                                        IF ChequeNoCorrection THEN
                                            BALEntry."Cheque No." := CorrectChequeNo;
                                        IF ChequeDateCorrection THEN
                                            BALEntry."Cheque Date" := ChequeDate;
                                        BALEntry.MODIFY;
                                    UNTIL BALEntry.NEXT = 0;

                                CheckLedgerEntry.RESET;
                                CheckLedgerEntry.SETCURRENTKEY("Document No.");
                                CheckLedgerEntry.SETRANGE("Document No.", PostDocNo);
                                CheckLedgerEntry.SETRANGE("Check No.", ApplicationPaymentEntry."Cheque No./ Transaction No.");
                                IF CheckLedgerEntry.FINDSET THEN
                                    REPEAT
                                        IF ChequeNoCorrection THEN
                                            CheckLedgerEntry."Check No." := CorrectChequeNo;
                                        IF ChequeDateCorrection THEN
                                            CheckLedgerEntry."Check Date" := ChequeDate;
                                        CheckLedgerEntry.MODIFY;
                                    UNTIL CheckLedgerEntry.NEXT = 0;


                                CustLedgerEntry.RESET;
                                CustLedgerEntry.SETCURRENTKEY("Document No.");
                                CustLedgerEntry.SETRANGE("Document No.", PostDocNo);
                                CustLedgerEntry.SETRANGE("BBG Cheque No.", ApplicationPaymentEntry."Cheque No./ Transaction No.");
                                IF CustLedgerEntry.FINDSET THEN
                                    REPEAT
                                        IF ChequeNoCorrection THEN
                                            CustLedgerEntry."BBG Cheque No." := CorrectChequeNo;
                                        IF ChequeDateCorrection THEN
                                            CustLedgerEntry."BBG Cheque Date" := ChequeDate;
                                        CustLedgerEntry.MODIFY;
                                    UNTIL CustLedgerEntry.NEXT = 0;

                                UnitCommCreationBuffer.RESET;
                                UnitCommCreationBuffer.SETRANGE("Application No.", BondNo);
                                UnitCommCreationBuffer.SETRANGE("Cheque No.", ApplicationPaymentEntry."Cheque No./ Transaction No.");
                                IF UnitCommCreationBuffer.FINDFIRST THEN
                                    REPEAT
                                        IF ApplicationPaymentEntry."Cheque No./ Transaction No." = UnitCommCreationBuffer."Cheque No." THEN BEGIN
                                            UnitCommCreationBuffer."Cheque No." := CorrectChequeNo;
                                            UnitCommCreationBuffer.MODIFY;
                                        END;
                                    UNTIL UnitCommCreationBuffer.NEXT = 0;

                                IF ChequeNoCorrection THEN
                                    ApplicationPaymentEntry."Cheque No./ Transaction No." := CorrectChequeNo;
                                IF ChequeDateCorrection THEN
                                    ApplicationPaymentEntry."Cheque Date" := ChequeDate;
                                IF BankBranchCorrection THEN
                                    ApplicationPaymentEntry."Cheque Bank and Branch" := BankBranch;
                                ApplicationPaymentEntry.MODIFY;
                                //UNTIL ApplicationPaymentEntry.NEXT = 0;


                                //------------Update in MSC company  Start---------------------
                                IF ApplicationPaymentEntry."MSC Post Doc. No." <> '' THEN BEGIN
                                    CompanyWise.RESET;
                                    CompanyWise.SETRANGE(CompanyWise."MSC Company", TRUE);
                                    IF CompanyWise.FINDFIRST THEN
                                        IF CompanyWise."Company Code" <> COMPANYNAME THEN BEGIN
                                            CLEAR(GLEntry);
                                            GLEntry.RESET;
                                            GLEntry.CHANGECOMPANY(CompanyWise."Company Code");
                                            GLEntry.SETCURRENTKEY("Document No.");
                                            GLEntry.SETRANGE("Document No.", ApplicationPaymentEntry."MSC Post Doc. No.");
                                            GLEntry.SETRANGE("BBG Cheque No.", ApplicationPaymentEntry."Cheque No./ Transaction No.");
                                            IF GLEntry.FINDSET THEN
                                                REPEAT
                                                    IF ChequeNoCorrection THEN
                                                        GLEntry."BBG Cheque No." := CorrectChequeNo;
                                                    IF ChequeDateCorrection THEN
                                                        GLEntry."BBG Cheque Date" := ChequeDate;
                                                    GLEntry.MODIFY;
                                                UNTIL GLEntry.NEXT = 0;

                                            CLEAR(BALEntry);
                                            BALEntry.RESET;
                                            BALEntry.CHANGECOMPANY(CompanyWise."Company Code");
                                            BALEntry.SETCURRENTKEY("Document No.");
                                            BALEntry.SETRANGE("Document No.", ApplicationPaymentEntry."MSC Post Doc. No.");
                                            BALEntry.SETRANGE("Cheque No.", ApplicationPaymentEntry."Cheque No./ Transaction No.");
                                            IF BALEntry.FINDSET THEN
                                                REPEAT
                                                    IF ChequeNoCorrection THEN
                                                        BALEntry."Cheque No." := CorrectChequeNo;
                                                    IF ChequeDateCorrection THEN
                                                        BALEntry."Cheque Date" := ChequeDate;
                                                    BALEntry.MODIFY;
                                                UNTIL BALEntry.NEXT = 0;

                                            CLEAR(CheckLedgerEntry);
                                            CheckLedgerEntry.RESET;
                                            CheckLedgerEntry.CHANGECOMPANY(CompanyWise."Company Code");
                                            CheckLedgerEntry.SETCURRENTKEY("Document No.");
                                            CheckLedgerEntry.SETRANGE("Document No.", ApplicationPaymentEntry."MSC Post Doc. No.");
                                            CheckLedgerEntry.SETRANGE("Check No.", ApplicationPaymentEntry."Cheque No./ Transaction No.");
                                            IF CheckLedgerEntry.FINDSET THEN
                                                REPEAT
                                                    IF ChequeNoCorrection THEN
                                                        CheckLedgerEntry."Check No." := CorrectChequeNo;
                                                    IF ChequeDateCorrection THEN
                                                        CheckLedgerEntry."Check Date" := ChequeDate;
                                                    CheckLedgerEntry.MODIFY;
                                                UNTIL CheckLedgerEntry.NEXT = 0;

                                            CLEAR(CustLedgerEntry);
                                            CustLedgerEntry.RESET;
                                            CustLedgerEntry.CHANGECOMPANY(CompanyWise."Company Code");
                                            CustLedgerEntry.SETCURRENTKEY("Document No.");
                                            CustLedgerEntry.SETRANGE("Document No.", ApplicationPaymentEntry."MSC Post Doc. No.");
                                            CustLedgerEntry.SETRANGE("BBG Cheque No.", ApplicationPaymentEntry."Cheque No./ Transaction No.");
                                            IF CustLedgerEntry.FINDSET THEN
                                                REPEAT
                                                    IF ChequeNoCorrection THEN
                                                        CustLedgerEntry."BBG Cheque No." := CorrectChequeNo;
                                                    IF ChequeDateCorrection THEN
                                                        CustLedgerEntry."BBG Cheque Date" := ChequeDate;
                                                    CustLedgerEntry.MODIFY;
                                                UNTIL CustLedgerEntry.NEXT = 0;

                                            NewAppPayEntry.RESET;
                                            NewAppPayEntry.SETCURRENTKEY("Posted Document No.");
                                            NewAppPayEntry.SETRANGE("Posted Document No.", ApplicationPaymentEntry."MSC Post Doc. No.");
                                            IF NewAppPayEntry.FINDSET THEN
                                                REPEAT
                                                    IF ChequeNoCorrection THEN
                                                        NewAppPayEntry."Cheque No./ Transaction No." := CorrectChequeNo;
                                                    IF ChequeDateCorrection THEN
                                                        NewAppPayEntry."Cheque Date" := ChequeDate;
                                                    IF BankBranchCorrection THEN
                                                        NewAppPayEntry."Cheque Bank and Branch" := BankBranch;
                                                    NewAppPayEntry.MODIFY;
                                                UNTIL NewAppPayEntry.NEXT = 0;
                                        END;
                                END ELSE BEGIN
                                    NewAppPayEntry.RESET;
                                    NewAppPayEntry.SETCURRENTKEY("Posted Document No.");
                                    NewAppPayEntry.SETRANGE("Posted Document No.", ApplicationPaymentEntry."Posted Document No.");
                                    IF NewAppPayEntry.FINDSET THEN
                                        REPEAT
                                            IF ChequeNoCorrection THEN
                                                NewAppPayEntry."Cheque No./ Transaction No." := CorrectChequeNo;
                                            IF ChequeDateCorrection THEN
                                                NewAppPayEntry."Cheque Date" := ChequeDate;
                                            IF BankBranchCorrection THEN
                                                NewAppPayEntry."Cheque Bank and Branch" := BankBranch;
                                            NewAppPayEntry.MODIFY;
                                        UNTIL NewAppPayEntry.NEXT = 0;

                                END;
                                //------------Update in MSC company End---------------------





                            END;
                            //  ReleaseBondApplication.InsertBondHistory(ApplicationPaymentEntry."Bond No.",'Cheque details Changed.',0,
                            //                                            ApplicationPaymentEntry."Application No.");
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
        ApplicationPaymentEntry: Record "Application Payment Entry";
        UnitPaymentEntry: Record "Unit Payment Entry";
        PostDocNo: Code[20];
        GLEntry: Record "G/L Entry";
        BALEntry: Record "Bank Account Ledger Entry";
        CheckLedgerEntry: Record "Check Ledger Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        UnitCommCreationBuffer: Record "Unit & Comm. Creation Buffer";
        APPEntry: Record "Application Payment Entry";
        CompanyWise: Record "Company wise G/L Account";
        NewAppPayEntry: Record "NewApplication Payment Entry";

        CorrectChequeNoEnable: Boolean;

        ChequeDateEnable: Boolean;

        BankBranchEnable: Boolean;
        MemberOf: Record "Access Control";


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

    local procedure BankBranchCorrectionOnPush()
    begin
        CurrPageUpdateControl;
    end;
}

