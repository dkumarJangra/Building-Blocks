xmlport 50082 "G/L Data Export"
{
    Direction = Export;
    Format = VariableText;
    FileName = 'GL Entries.csv';


    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'Integers';
                SourceTableView = SORTING(Number)
                                  WHERE(Number = CONST(1));
                textelement(EntryNo_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        EntryNo_ := 'Entry No.';
                    end;
                }
                textelement(GLCode_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        GLCode_ := 'G/L Account';
                    end;
                }
                textelement(PostingDate_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        PostingDate_ := 'Posting Date';
                    end;
                }
                textelement(docType_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        docType_ := 'Document Type';
                    end;
                }
                textelement(DocNo_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        DocNo_ := 'Document No.';
                    end;
                }
                textelement(BalAccType_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        BalAccType_ := 'Bal. Account Type';
                    end;
                }
                textelement(BalAccNo_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        BalAccNo_ := 'Bal. Account No.';
                    end;
                }
                textelement(Amt_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Amt_ := 'Amount';
                    end;
                }
                textelement(GD1_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        GD1_ := 'Dimension 1 Code';
                    end;
                }
                textelement(UserID_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        UserID_ := 'User Id';
                    end;
                }
                textelement(SourceCode_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        SourceCode_ := 'Source Code';
                    end;
                }
                textelement(TransNo_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        TransNo_ := 'Transaction No.';
                    end;
                }
                textelement(DebitAmt_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        DebitAmt_ := 'Debit Amount';
                    end;
                }
                textelement(CreditAmt_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        CreditAmt_ := 'Credit Amount';
                    end;
                }
                textelement(DocDate_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        DocDate_ := 'Document Date';
                    end;
                }
                textelement(ExtNo_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ExtNo_ := 'External Document No.';
                    end;
                }
                textelement(SourceType_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        SourceType_ := 'Source Type';
                    end;
                }
                textelement(SourceNo_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        SourceNo_ := 'Source No.';
                    end;
                }
                textelement(Reversed_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Reversed_ := 'Reversed';
                    end;
                }
                textelement(VerifiedBy_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        VerifiedBy_ := 'Verified By';
                    end;
                }
                textelement(CreatedBy_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        CreatedBy_ := 'Created By';
                    end;
                }
                textelement(TransactionType_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        TransactionType_ := 'Transaction Type';
                    end;
                }
                textelement(PostingType_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        PostingType_ := 'Posting Type';
                    end;
                }
                textelement(ChequeNo_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ChequeNo_ := 'Cheque No.';
                    end;
                }
                textelement(ChequeDate_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ChequeDate_ := 'Cheque Date';
                    end;
                }
                textelement(UserBranchCode_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        UserBranchCode_ := 'User Branch Code';
                    end;
                }
                textelement(OrderRefNo_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        OrderRefNo_ := 'Order Ref.No.';
                    end;
                }
                textelement(VendCode_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        VendCode_ := 'Vendor Code';
                    end;
                }
                textelement(VendName_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        VendName_ := 'Vendor Name';
                    end;
                }
                textelement(Desc_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Desc_ := 'Description';
                    end;
                }
                textelement(Narration_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Narration_ := 'Narration';
                    end;
                }
                textelement(ApplicationNo_)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ApplicationNo_ := 'Application No.';
                    end;
                }
            }
            tableelement("G/L Entry"; "G/L Entry")
            {
                RequestFilterFields = "Posting Date";
                XmlName = 'GLEntry';
                fieldelement(EntryNo; "G/L Entry"."Entry No.")
                {
                }
                fieldelement(GLCode; "G/L Entry"."G/L Account No.")
                {
                }
                fieldelement(PostingDate; "G/L Entry"."Posting Date")
                {
                }
                fieldelement(docType; "G/L Entry"."Document Type")
                {
                }
                fieldelement(DocNo; "G/L Entry"."Document No.")
                {
                }
                fieldelement(BalAccType; "G/L Entry"."Bal. Account Type")
                {
                }
                fieldelement(BalAccNo; "G/L Entry"."Bal. Account No.")
                {
                }
                fieldelement(Amt; "G/L Entry".Amount)
                {
                }
                fieldelement(GD1; "G/L Entry"."Global Dimension 1 Code")
                {
                }
                fieldelement(UserID; "G/L Entry"."User ID")
                {
                }
                fieldelement(SourceCode; "G/L Entry"."Source Code")
                {
                }
                fieldelement(TransNo; "G/L Entry"."Transaction No.")
                {
                }
                fieldelement(DebitAmt; "G/L Entry"."Debit Amount")
                {
                }
                fieldelement(CreditAmt; "G/L Entry"."Credit Amount")
                {
                }
                fieldelement(DocDate; "G/L Entry"."Document Date")
                {
                }
                fieldelement(ExtNo; "G/L Entry"."External Document No.")
                {
                }
                fieldelement(SourceType; "G/L Entry"."Source Type")
                {
                }
                fieldelement(SourceNo; "G/L Entry"."Source No.")
                {
                }
                fieldelement(Reversed; "G/L Entry".Reversed)
                {
                }
                fieldelement(VerifiedBy; "G/L Entry"."bbg Verified By")
                {
                }
                fieldelement(CreatedBy; "G/L Entry"."BBG Created By")
                {
                }
                fieldelement(TransactionType; "G/L Entry"."BBg Tranasaction Type")
                {
                }
                fieldelement(PostingType; "G/L Entry"."BBg Posting Type")
                {
                }
                fieldelement(ChequeNo; "G/L Entry"."BBG Cheque No.")
                {
                }
                fieldelement(ChequeDate; "G/L Entry"."BBG Cheque Date")
                {
                }
                fieldelement(UserBranchCode; "G/L Entry"."BBg User Branch Code")
                {
                }
                fieldelement(OrderRefNo; "G/L Entry"."BBG Order Ref No.")
                {
                }
                fieldelement(VendCode; "G/L Entry"."BBG Vendor No.")
                {
                }
                fieldelement(VendName; "G/L Entry"."BBG Vendor Name")
                {
                }
                fieldelement(Desc; "G/L Entry".Description)
                {
                }
                fieldelement(Narration; "G/L Entry"."BBG Narration")
                {
                }
                textelement(APPNo)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    APPNo := '';
                    VendorLedgerEntry.RESET;
                    VendorLedgerEntry.SETCURRENTKEY("Document No.");
                    VendorLedgerEntry.SETRANGE("Document No.", "G/L Entry"."Document No.");
                    VendorLedgerEntry.SETFILTER("Application No.", '<>%1', '');
                    IF VendorLedgerEntry.FINDFIRST THEN BEGIN
                        APPNo := VendorLedgerEntry."Application No.";
                    END;

                    IF APPNo = '' THEN BEGIN
                        CustLedgerEntry.RESET;
                        CustLedgerEntry.SETCURRENTKEY("Document No.");
                        CustLedgerEntry.SETRANGE("Document No.", "G/L Entry"."Document No.");
                        CustLedgerEntry.SETFILTER("BBG App. No. / Order Ref No.", '<>%1', '');
                        IF CustLedgerEntry.FINDFIRST THEN
                            APPNo := CustLedgerEntry."BBg App. No. / Order Ref No.";
                    END;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    var
        VendorLedgerEntry: Record "Vendor ledger Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
}

