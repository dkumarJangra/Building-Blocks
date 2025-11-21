tableextension 50045 "BBG Reversal Entry Ext" extends "Reversal Entry"
{
    fields
    {
        // Add changes to table fields here

    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
        Text50000: Label '"You cannot reverse %1 No. %2 because the entry is either applied to an entry or has been changed by a batch job. "';
        GLEntry: Record "G/L Entry";
        Text004: Label 'You can only reverse entries that were posted from a journal.';
        Text003: Label 'You cannot reverse %1 No. %2 because the entry has a related check ledger entry.';
        Text006: Label 'You cannot reverse %1 No. %2 because the entry is closed.';



    PROCEDURE BBGTestFieldError();
    VAR
        AssocPmtVoucherHeader: Record "Assoc Pmt Voucher Header";
        DocNo_2: Code[20];
        OldDate: Date;
        DocLength: Integer;
    BEGIN
        //IF NOT CommPayVoucher.GET(GLEntry."External Document No.") THEN
        //ERROR(Text004); //ALLETDK040613
        //  ERROR('Commission related entries should be reversed from Posted Payable Voucher form')
        //ELSE
        IF NOT AutoReverse THEN
            DocNo_2 := '';
        IF GLEntry."External Document No." <> '' THEN BEGIN
            IF NOT AssocPmtVoucherHeader.GET(GLEntry."External Document No.") THEN BEGIN
                DocLength := STRLEN(GLEntry."External Document No.") - 2;
                DocNo_2 := COPYSTR(GLEntry."External Document No.", 1, DocLength);
                IF NOT AssocPmtVoucherHeader.GET(DocNo_2) THEN
                    ERROR(Text004);
            END;
        END;
        //  ERROR(Text004);
    END;









}