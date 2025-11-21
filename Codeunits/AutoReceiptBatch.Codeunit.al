codeunit 50028 "Auto Receipt Batch"
{

    trigger OnRun()
    begin

        OldReceipttransferinLLPLog.RESET;
        OldReceipttransferinLLPLog.SETRANGE("Company Name", COMPANYNAME);
        OldReceipttransferinLLPLog.SETFILTER("Creation Date", '<%1', (TODAY - 1));
        IF OldReceipttransferinLLPLog.FINDSET THEN
            REPEAT
                OldReceipttransferinLLPLog.DELETE;
            UNTIL OldReceipttransferinLLPLog.NEXT = 0;


        NewApplicationPaymentEntry.RESET;
        NewApplicationPaymentEntry.SETRANGE("Document Type", NewApplicationPaymentEntry."Document Type"::BOND);
        NewApplicationPaymentEntry.SETFILTER("Posted Document No.", '<>%1', '');
        NewApplicationPaymentEntry.SETRANGE("Receipt post on InterComp", FALSE);
        NewApplicationPaymentEntry.SETFILTER("Cheque Status", '<>%1', NewApplicationPaymentEntry."Cheque Status"::Cancelled);
        NewApplicationPaymentEntry.SETRANGE("Create from MSC Company", TRUE);
        NewApplicationPaymentEntry.SETRANGE("Company Name", COMPANYNAME);
        //NewApplicationPaymentEntry.SETRANGE("Document No.",'AP2223004589');
        IF NewApplicationPaymentEntry.FINDSET THEN
            REPEAT
                COMMIT;
                IF NewApplicationPaymentEntry."Company Name" = COMPANYNAME THEN BEGIN
                    CLEAR(AutoReceiptBatch_1);
                    IF NOT AutoReceiptBatch_1.RUN(NewApplicationPaymentEntry) THEN BEGIN
                        OldReceipttransferinLLPLog.RESET;
                        IF OldReceipttransferinLLPLog.FINDLAST THEN
                            EntryNo := OldReceipttransferinLLPLog."Entry No.";
                        ReceipttransferinLLPLog.INIT;
                        ReceipttransferinLLPLog."Entry No." := EntryNo + 1;
                        ReceipttransferinLLPLog."Application Code" := NewApplicationPaymentEntry."Document No.";
                        ReceipttransferinLLPLog."Posting Date" := NewApplicationPaymentEntry."Posting date";
                        ReceipttransferinLLPLog.Amount := NewApplicationPaymentEntry.Amount;
                        ReceipttransferinLLPLog."Company Name" := COMPANYNAME;
                        ReceipttransferinLLPLog."Error Message" := GETLASTERRORTEXT;
                        ReceipttransferinLLPLog.INSERT;
                    END;

                END;
            UNTIL NewApplicationPaymentEntry.NEXT = 0;
    end;

    var
        AutoReceiptBatch_1: Codeunit "Post Receipts in LLPS";
        NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        ReceipttransferinLLPLog: Record "Receipt transfer in LLP Log";
        OldReceipttransferinLLPLog: Record "Receipt transfer in LLP Log";
        EntryNo: Integer;
}

