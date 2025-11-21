xmlport 50062 "General Jnl Line Upload"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                AutoSave = false;
                XmlName = 'GeneralJnlLineUpload';
                textelement(JournalTemplateName)
                {
                }
                textelement(JournalBatchName)
                {
                }
                textelement(PostingDate)
                {
                }
                textelement(DocumentNo)
                {
                }
                textelement(DocType)
                {
                }
                textelement(AccountType)
                {
                }
                textelement(AccountNo)
                {
                }
                textelement(ExternalDocNo)
                {
                }
                textelement(BalAccountType)
                {
                }
                textelement(BalAccountNo)
                {
                }
                textelement(Amt)
                {
                }
                textelement(PostingType)
                {
                }
                textelement(ChqNo)
                {
                }
                textelement(CheqDate)
                {
                }
                textelement(linenarration1)
                {
                    XmlName = 'LineNarration1';
                }
                textelement(srccode)
                {
                    XmlName = 'SrcCode';
                }

                trigger OnPreXmlItem()
                begin

                    MESSAGE('Batch Run Successfully');
                end;

                trigger OnAfterInsertRecord()
                begin
                    ValidateVariable;
                    GenJournalLine.RESET;
                    GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", JournalTemplateName);
                    GenJournalLine.SETRANGE("Journal Batch Name", JournalBatchName);
                    IF GenJournalLine.FINDLAST THEN
                        LineNo := GenJournalLine."Line No.";

                    IF GenJournalBatch.GET(JournalTemplateName, JournalBatchName) THEN;

                    GenJournalLine.INIT;
                    GenJournalLine."Journal Template Name" := JournalTemplateName;
                    GenJournalLine."Journal Batch Name" := JournalBatchName;
                    GenJournalLine."Line No." := LineNo + 10000;
                    GenJournalLine."Document No." := DocumentNo;
                    GenJournalLine.INSERT(TRUE);

                    GenJournalLine.VALIDATE("Posting Date", PostingDate1);
                    GenJournalLine.VALIDATE("Document Date", PostingDate1);
                    IF DocType <> '' THEN
                        GenJournalLine.VALIDATE("Document Type", DocType1);
                    GenJournalLine.VALIDATE("Account Type", AccountType1);
                    GenJournalLine.VALIDATE("Account No.", AccountNo1);
                    IF ExternalDocNo <> '' THEN
                        GenJournalLine.VALIDATE("External Document No.", ExternalDocNo1);
                    GenJournalLine.VALIDATE("Bal. Account Type", BalAccountType1);
                    GenJournalLine.VALIDATE("Bal. Account No.", BalAccountNo1);
                    GenJournalLine.VALIDATE(Amount, Amt1);
                    GenJournalLine.VALIDATE("Posting Type", PostingType1);
                    //  GenJournalLine.VALIDATE("Shortcut Dimension 1 Code",ProjCode);
                    GenJournalLine."BBG Cheque No." := ChqNo1;
                    GenJournalLine."Cheque No." := CopyStr(ChqNo1, 1, 10);
                    GenJournalLine."Cheque Date" := CheqDate1;
                    GenJournalLine.VALIDATE("Posting No. Series", GenJournalBatch."Posting No. Series");

                    GenJournalLine.Verified := TRUE;
                    GenJournalLine."Source Code" := SrcCode1;
                    GenJournalLine.MODIFY;

                    NarrationLength := 0;
                    NarrationLength := STRLEN(LineNarration1);

                    IF LineNarration1 <> '' THEN BEGIN
                        GenJournalNarration.RESET;
                        GenJournalNarration.INIT;
                        GenJournalNarration."Journal Template Name" := JournalTemplateName;
                        GenJournalNarration."Journal Batch Name" := JournalBatchName;
                        GenJournalNarration."Document No." := DocumentNo;
                        //  GenJournalNarration."Gen. Journal Line No." := GenJournalLine."Line No."; // Code commented because instead of line narration ,voucher narration to be uploaded
                        GenJournalNarration."Gen. Journal Line No." := 0;
                        GenJournalNarration."Line No." := 10000;
                        GenJournalNarration.Narration := COPYSTR(LineNarration1, 1, 50);
                        GenJournalNarration.INSERT;
                        IF NarrationLength > 50 THEN BEGIN
                            GenJournalNarration.RESET;
                            GenJournalNarration.INIT;
                            GenJournalNarration."Journal Template Name" := JournalTemplateName;
                            GenJournalNarration."Journal Batch Name" := JournalBatchName;
                            GenJournalNarration."Document No." := DocumentNo;
                            //    GenJournalNarration."Gen. Journal Line No." := GenJournalLine."Line No."; // Code commented because instead of line narration ,voucher narration to be uploaded
                            GenJournalNarration."Gen. Journal Line No." := 0;
                            GenJournalNarration."Line No." := 20000;
                            GenJournalNarration.Narration := COPYSTR(LineNarration1, 51, 50);
                            GenJournalNarration.INSERT;
                        END;
                    END;
                    // MESSAGE('Uploaded Successfully %1',SrcCode1);
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
        USERSETUP: Record "User setup";
        BondSetup: Record "Unit setup";
        PostedDocNo: Code[20];
        NoSeriesMgt: Codeunit "Noseriesmanagement";
        ChqNo1: Code[20];
        CheqDate1: Date;
        BankACC: Record "Bank Account";
        JournalTemplateName1: Code[30];
        JournalBatchName1: Code[30];
        PostingDate1: Date;
        LineNo: Integer;
        AccountType1: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        AccountNo1: Code[40];
        BalAccountType1: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        Amt1: Decimal;
        ProjCode1: Code[40];
        PostingType1: Option " ",Advance,Running,Retention,"Secured Advance","Adhoc Advance",Provisional,LD,"Mobilization Advance","Equipment Advance",,,,Commission,"Travel Allowance",,Incentive,CommAndTA;
        BalAccountNo1: Code[40];
        GenJournalLine: Record "Gen. Journal Line";
        DocType1: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        ExternalDocNo1: Code[30];
        SNo: Integer;
        DocumentNo1: Code[20];
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJournalNarration: Record "Gen. Journal Narration";
        NarrationLength: Integer;
        Narration1: Text;
        Narration2: Text;
        SrcCode1: Code[20];

    local procedure ValidateVariable()
    begin
        EVALUATE(JournalTemplateName1, JournalTemplateName);
        EVALUATE(JournalBatchName1, JournalBatchName);
        EVALUATE(PostingDate1, PostingDate);
        EVALUATE(DocumentNo1, DocumentNo);
        EVALUATE(DocType1, DocType);
        EVALUATE(AccountType1, AccountType);
        EVALUATE(AccountNo1, AccountNo);
        EVALUATE(ExternalDocNo1, ExternalDocNo);
        EVALUATE(BalAccountType1, BalAccountType);
        EVALUATE(BalAccountNo1, BalAccountNo);
        EVALUATE(Amt1, Amt);
        EVALUATE(PostingType1, PostingType);
        EVALUATE(ChqNo1, ChqNo);
        EVALUATE(CheqDate1, CheqDate);
        EVALUATE(SrcCode1, SrcCode);
    end;
}

