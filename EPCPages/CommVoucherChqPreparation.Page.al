page 97919 "Comm. Voucher Chq Preparation"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Commission Voucher";
    SourceTableView = SORTING("Cheque Status", "Commission Voucher Printed", "Voucher No.")
                      WHERE("Payment Mode" = CONST(Cheque),
                            "Commission Voucher Printed" = FILTER(true),
                            "Cheque Status" = FILTER(.. "With Cheque"));
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(VoucherNoFilter; VoucherNoFilter)
                {
                    Caption = 'Voucher No. Filter';

                    trigger OnValidate()
                    begin
                        VoucherNoFilterOnAfterValidate;
                    end;
                }
                field(COUNT; Rec.COUNT)
                {
                    Caption = 'Bonds in Filter';
                    Editable = false;
                }
            }
            repeater(Group)
            {
                Editable = false;
                field("Voucher No."; Rec."Voucher No.")
                {
                    Editable = false;
                }
                field("Voucher Date"; Rec."Voucher Date")
                {
                    Editable = false;
                }
                field("Associate Code"; Rec."Associate Code")
                {
                    Editable = false;
                }
                field("Base Amount"; Rec."Base Amount")
                {
                    Editable = false;
                }
                field("Commission Amount"; Rec."Commission Amount")
                {
                    Editable = false;
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                    Editable = false;
                }
                field("Payment A/C Code"; Rec."Payment A/C Code")
                {
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
                action("Print Cheque")
                {
                    Caption = 'Print Cheque';
                    ShortCutKey = 'Ctrl+F10';

                    trigger OnAction()
                    begin
                        ChequePrint;
                    end;
                }
            }
        }
    }

    var
        VoucherNoFilter: Code[1024];
        Text001: Label 'Please enter Proper Cheque No.';


    procedure ChequePrint()
    var
        //ChequePrintingConfirmation: Page 97935;
        ChequeNoText: Code[20];
        ChequeDate: Date;
        BankAccountNo: Code[20];
        CommissionVoucher: Record "Commission Voucher";
        BankAccount: Record "Bank Account";
        ChequePrintTable: Record "MIS Payment Schedule" temporary;
        ConsiderVoucher: Boolean;
        ReapprovedCommissionVoucher: Record "MIS Payment Schedule";
        BondSetup: Record "Unit Setup";
        CommissionVoucher2: Record "Commission Voucher";
    begin
        /*
        ChequePrintingConfirmation.LOOKUPMODE := TRUE;
        IF ChequePrintingConfirmation.RUNMODAL = ACTION::LookupOK THEN BEGIN
          ChequePrintingConfirmation.GetValues(ChequeNoText,ChequeDate,BankAccountNo);
          CurrPage.SETSELECTIONFILTER(CommissionVoucher);
        
          BankAccount.GET(BankAccountNo);
          ChequePrintTable.DELETEALL;
          IF CommissionVoucher.FINDSET(TRUE,TRUE) THEN BEGIN
            BondSetup.GET;
            REPEAT
             ConsiderVoucher := TRUE;
             IF CommissionVoucher."Voucher Date" < CALCDATE(BondSetup."Comm Voucher Payment Period",TODAY) THEN
               IF NOT ReapprovedCommissionVoucher.GET(CommissionVoucher."Voucher No.") THEN
                 ConsiderVoucher := FALSE;
        
              IF ConsiderVoucher THEN BEGIN
                CommissionVoucher2.GET(CommissionVoucher."Voucher No.");
                CommissionVoucher2."Cheque Status" := CommissionVoucher2."Cheque Status"::"Cheque Printed";
        
                CommissionVoucher2."Cheque No." := ChequeNoText;
                CommissionVoucher2."Cheque Date" := ChequeDate;
                CommissionVoucher2."Payment A/C Code" := BankAccountNo;
                CommissionVoucher2.MODIFY;
        
                ChequePrintTable.INIT;
                ChequePrintTable."Unit No." := CommissionVoucher2."Voucher No.";
                ChequePrintTable."Interest Amount" := CommissionVoucher2."Commission Amount" - CommissionVoucher2."TDS Amount";
                ChequePrintTable."Cheque No." := CommissionVoucher2."Cheque No.";
                ChequePrintTable."Cheque Date" := CommissionVoucher2."Cheque Date";
                ChequePrintTable."Bank Code" := CommissionVoucher2."Payment A/C Code";
                ChequePrintTable."Introducer Code" := CommissionVoucher2."Associate Code";
                ChequePrintTable.INSERT;
                ChequeNoText := INCSTR(ChequeNoText);
              END;
            UNTIL CommissionVoucher.NEXT = 0;
            //CommissionVoucher.MODIFYALL("Cheque Status",CommissionVoucher."Cheque Status"::"Cheque Printed");
            COMMIT;
            CLEAR(ChequePrint);
        //    ChequePrint.SetRecord(ChequePrintTable,1); // ALLE MM Code Commented
            ChequePrint.RUNMODAL;
          END;
        END;
        */

    end;


    procedure SetRecordFilters()
    begin
        Rec.FILTERGROUP(10);
        IF VoucherNoFilter <> '' THEN BEGIN
            Rec.SETFILTER("Voucher No.", VoucherNoFilter);
            VoucherNoFilter := Rec.GETFILTER("Voucher No.");
        END ELSE
            Rec.SETRANGE("Voucher No.");

        Rec.FILTERGROUP(0);
        CurrPage.UPDATE(FALSE);
    end;

    local procedure VoucherNoFilterOnAfterValidate()
    begin
        SetRecordFilters;
    end;
}

