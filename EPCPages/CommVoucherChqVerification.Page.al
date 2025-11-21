page 97920 "Comm. Voucher Chq Verification"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Commission Voucher";
    SourceTableView = SORTING("Cheque Status", "Commission Voucher Printed", "Voucher No.")
                      WHERE("Cheque Status" = CONST("Cheque Printed"));
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
                field("Cheque No."; Rec."Cheque No.")
                {
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
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
                action("Remove Cheqno")
                {
                    Caption = 'Remove Cheqno';
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    begin
                        ClearChequeNo;
                    end;
                }
                action("Release and Post Cheques")
                {
                    Caption = 'Release and Post Cheques';
                    ShortCutKey = 'Ctrl+F12';

                    trigger OnAction()
                    begin
                        ReleaseCheques;
                    end;
                }
            }
        }
    }

    var
        Text001: Label 'Please enter Proper Cheque No.';
        Text002: Label 'Posted Document No. %1.';
        VoucherNoFilter: Code[1024];


    procedure ClearChequeNo()
    var
        CommissionVoucher: Record "Commission Voucher";
    begin
        CurrPage.SETSELECTIONFILTER(CommissionVoucher);
        IF CommissionVoucher.FINDSET(TRUE) THEN
            REPEAT
                CommissionVoucher."Cheque No." := '';
                CommissionVoucher."Cheque Date" := 0D;
                CommissionVoucher."Payment A/C Code" := '';
                CommissionVoucher."Cheque Status" := CommissionVoucher."Cheque Status"::"With Cheque";
                CommissionVoucher.MODIFY;
            UNTIL CommissionVoucher.NEXT = 0;
    end;


    procedure ReleaseCheques()
    var
        CommissionVoucher: Record "Commission Voucher";
    begin
        IF CONFIRM('Do you want to post the selected records?') THEN BEGIN
            CurrPage.SETSELECTIONFILTER(CommissionVoucher);
            CommissionVoucher.MODIFYALL("Cheque Status", CommissionVoucher."Cheque Status"::"Cheque Released");
        END;
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

