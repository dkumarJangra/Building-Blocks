page 50047 "Refund Bank Acc. No.Correction"
{
    // ALLECK 160313: Added Role for Cheque Correction

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
                    TableRelation = "Application Payment Entry"."Document No." WHERE("Cheque Status" = FILTER(Cleared),
                                                                                      "Cheque No./ Transaction No." = FILTER(<> ''),
                                                                                      "Payment Mode" = FILTER("Refund Bank"));
                }
                field("Nav Bank Account Code"; NBankNo)
                {
                    Caption = 'Nav Bank Account Code';
                    Editable = true;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        APPEntry.RESET;
                        APPEntry.SETRANGE("Document No.", BondNo);
                        APPEntry.SETRANGE("Payment Mode", APPEntry."Payment Mode"::"Refund Bank");
                        APPEntry.SETRANGE("Cheque Status", APPEntry."Cheque Status"::Cleared);
                        APPEntry.SETFILTER(APPEntry."Deposit/Paid Bank", '<>%1', '');
                        APPEntry.SETRANGE(Posted, TRUE);
                        IF APPEntry.FINDFIRST THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"Application Payment Entry List", APPEntry) = ACTION::LookupOK THEN BEGIN
                                ApplicationPaymentEntry := APPEntry;
                                NBankNo := ApplicationPaymentEntry."Deposit/Paid Bank";//ALLECK 180313
                                PostDocNo := ApplicationPaymentEntry."Posted Document No.";
                            END ELSE
                                BankAcc := '';
                        END;
                    end;
                }
                field("Confirmed Order Date"; ApplicationPaymentEntry."Posting date")
                {
                    Caption = 'Confirmed Order Date';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        IF STRLEN(CorrectChequeNo) < 6 THEN
                            ERROR('Wrong Entry No.');
                    end;
                }
                field("Existing Nav Bank Account Code"; ApplicationPaymentEntry."Deposit/Paid Bank")
                {
                    Caption = 'Existing Nav Bank Account Code';
                    Editable = false;
                }
                field("Existing Bank Account Name"; ApplicationPaymentEntry."Deposit / Paid Bank Name")
                {
                    Caption = 'Existing Bank Account Name';
                    Editable = false;
                }
                field("Bank Account Correction"; BankAcCrctn)
                {
                    Caption = 'Bank Account Correction';

                    trigger OnValidate()
                    begin
                        BankAcCrctnOnPush;
                    end;
                }
                field("New Cheque No."; BankCode)
                {
                    Caption = 'New Cheque No.';
                    Enabled = BankCodeEnable;
                    TableRelation = "Bank Account";

                    trigger OnValidate()
                    begin
                        //IF BankAc."No." <>'' THEN
                        IF BankAc.GET(BankCode) THEN BEGIN
                            BankNo := BankAc."Bank Account No.";
                            BankName := BankAc.Name;
                        END;
                    end;
                }
                field("Existing Cheque Bank and Branch"; BankNo)
                {
                    Caption = 'Existing Cheque Bank and Branch';
                    Editable = false;
                    Enabled = BankNoEnable;

                    trigger OnValidate()
                    begin
                        IF BankAc.GET(CrctBnkNo) THEN;
                    end;
                }
                field("New Bank Account No."; BankName)
                {
                    Caption = 'New Bank Account No.';
                    Editable = false;
                    Enabled = BankNameEnable;

                    trigger OnValidate()
                    begin
                        IF STRLEN(CorrectChequeNo) < 6 THEN
                            ERROR('Wrong Entry No.');
                    end;
                }
                field("Posted Document No."; PostDocNo)
                {
                    Caption = 'Posted Document No.';
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        APPEntry.RESET;
                        APPEntry.SETRANGE("Document No.", BondNo);
                        APPEntry.SETRANGE("Cheque Status", APPEntry."Cheque Status"::" ");
                        APPEntry.SETFILTER(APPEntry."Deposit/Paid Bank", '<>%1', '');
                        APPEntry.SETRANGE(Posted, TRUE);
                        IF APPEntry.FINDFIRST THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"Application Payment Entry List", APPEntry) = ACTION::LookupOK THEN BEGIN
                                BankAcc := ApplicationPaymentEntry."Deposit / Paid Bank Name";
                                //ChequeNo := APPEntry."Cheque No./ Transaction No.";
                                ApplicationPaymentEntry := APPEntry;
                                PostDocNo := ApplicationPaymentEntry."Posted Document No.";
                            END ELSE
                                BankAcc := '';
                            //ChequeNo := '';
                        END;
                    end;
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
                        //ALLECK 160313 START
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'A_BANKCODECORRECTION');
                        IF NOT MemberOf.FINDFIRST THEN
                            ERROR('You do not have permission of role  :A_BANKCODECORRECTION');
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        //ALLECK 160313 End

                        IF BondNo = '' THEN
                            ERROR('Please define the Bond No');
                        IF BankCode = '' THEN
                            ERROR('Please define the New Bank Account No.');

                        IF CONFIRM('You are going to change Bank A/C from %1 to %2.\Are you sure?', FALSE, NBankNo, BankCode) THEN BEGIN
                            ApplicationPaymentEntry.SETRANGE("Posted Document No.", ApplicationPaymentEntry."Posted Document No.");//ALLECK 170313
                            IF ApplicationPaymentEntry.FINDSET THEN
                                REPEAT
                                    IF ConfirmedOrder.GET(ApplicationPaymentEntry."Document No.") THEN BEGIN
                                        ConfirmedOrder.TESTFIELD("Application Closed", FALSE);
                                        ConfirmedOrder.TESTFIELD("Registration Status", ConfirmedOrder."Registration Status"::" "); //090921
                                    END;

                                    //ALLECK 170313 START
                                    IF BankAcCrctn THEN
                                        ApplicationPaymentEntry."Deposit/Paid Bank" := BankCode;
                                    ApplicationPaymentEntry.MODIFY;

                                    //ALLECK 170313 END

                                    GLEntry.RESET;
                                    GLEntry.SETCURRENTKEY("Document No.");
                                    GLEntry.SETRANGE("Document No.", ApplicationPaymentEntry."Posted Document No.");
                                    GLEntry.SETRANGE("Source Type", GLEntry."Source Type"::"Bank Account");
                                    IF GLEntry.FINDSET THEN
                                        REPEAT
                                            IF BankAcCrctn THEN
                                                GLEntry."Source No." := BankCode;
                                            GLEntry.MODIFY;
                                        UNTIL GLEntry.NEXT = 0;

                                    BALEntry.RESET;
                                    BALEntry.SETCURRENTKEY("Document No.");
                                    BALEntry.SETRANGE("Document No.", ApplicationPaymentEntry."Posted Document No.");
                                    IF BALEntry.FINDSET THEN
                                        REPEAT
                                            IF BankAcCrctn THEN
                                                BALEntry."Bank Account No." := BankCode;
                                            BALEntry.MODIFY;
                                        UNTIL BALEntry.NEXT = 0;
                                UNTIL ApplicationPaymentEntry.NEXT = 0;

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
        BankNameEnable := TRUE;
        BankCodeEnable := TRUE;
        BankNoEnable := TRUE;
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
        ApplicationPaymentEntry: Record "Application Payment Entry";
        UnitPaymentEntry: Record "Unit Payment Entry";
        PostDocNo: Code[20];
        GLEntry: Record "G/L Entry";
        BALEntry: Record "Bank Account Ledger Entry";
        CheckLedgerEntry: Record "Check Ledger Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        UnitCommCreationBuffer: Record "Unit & Comm. Creation Buffer";
        APPEntry: Record "Application Payment Entry";
        BankAcc: Code[200];
        CrctBnkNo: Code[10];
        BankAcCrctn: Boolean;
        BankAc: Record "Bank Account";
        BankCode: Code[20];
        BankName: Text[150];
        BankNo: Code[20];
        NBankNo: Code[20];

        BankNoEnable: Boolean;

        BankCodeEnable: Boolean;

        BankNameEnable: Boolean;
        Text19022852: Label 'Nav New Bank Account Code';
        Text19003510: Label 'New Bank Account Name';
        MemberOf: Record "Access Control";


    procedure CurrPAGEUpdateControl()
    begin
        BankNoEnable := BankAcCrctn;
        BankCodeEnable := BankAcCrctn;
        BankNameEnable := BankAcCrctn;
    end;

    local procedure BankAcCrctnOnPush()
    begin
        CurrPAGEUpdateControl;
    end;
}

