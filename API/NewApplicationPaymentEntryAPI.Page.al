page 50406 "NewAppl Payment Entry API"
{
    PageType = API;

    APIVersion = 'v2.0';
    APIGroup = 'PowerBI';
    APIPublisher = 'Alletec';

    EntityCaption = 'NewApplicationPaymentEntryAPI';
    EntitySetCaption = 'NewApplicationPaymentEntryAPI';
    EntitySetName = 'NewApplicationPaymentEntryAPI';
    EntityName = 'NewApplicationPaymentEntryAPI';


    ODataKeyFields = SystemID;
    SourceTable = "NewApplication Payment Entry";

    Extensible = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(chequeStatus; Rec."Cheque Status")
                {
                    Caption = 'Cheque Status';
                }
                field(posted; Rec.Posted)
                {
                    Caption = 'Posted';
                }
                field(shortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Shortcut Dimension 1 Code';
                }
                field(postingdate; Rec."Posting date")
                {
                    Caption = 'Posting date';
                }
                field(paymentMethod; Rec."Payment Method")
                {
                    Caption = 'Payment Method';
                }
                field(chequeNoTransactionNo; Rec."Cheque No./ Transaction No.")
                {
                    Caption = 'Cheque No./ Transaction No.';
                }
                field(chequeDate; Rec."Cheque Date")
                {
                    Caption = 'Cheque Date';
                }
                field(chequeBankandBranch; Rec."Cheque Bank and Branch")
                {
                    Caption = 'Cheque Bank and Branch';
                }
                field(chqClBounceDt; Rec."Chq. Cl / Bounce Dt.")
                {
                    Caption = 'Chq. Cl / Bounce Dt.';
                }
                field(paymentMode; Rec."Payment Mode")
                {
                    Caption = 'Payment Mode';
                }
                field(depositPaidBank; Rec."Deposit/Paid Bank")
                {
                    Caption = 'Deposit/Paid Bank';
                }
                field(depositPaidBankName; Rec."Deposit / Paid Bank Name")
                {
                    Caption = 'Deposit / Paid Bank Name';
                }
                field(userBranchCode; Rec."User Branch Code")
                {
                    Caption = 'User Branch Code';
                }
                field(unitCode; Rec."Unit Code")
                {
                    Caption = 'Unit Code';
                }

                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }

            }
        }
    }

    var
        myInt: Integer;
}