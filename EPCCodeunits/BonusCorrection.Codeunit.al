codeunit 97731 "Bonus Correction"
{

    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'Please enter Posted Document No.';
        Text002: Label 'Please enter Received from Code.';
        Text003: Label 'Please enter Unit Office Code.';
        GenJnlLine: Record "Gen. Journal Line" temporary;
        GetDescription: Codeunit GetDescription;


    procedure BonusCorrection(UnitOfficeCodeCorr: Boolean; UnitOfficeCode: Code[20]; PaidToCorr: Boolean; ReceivedFrom: Code[20]; PostedDocNo: Code[20])
    begin
        IF PostedDocNo = '' THEN
            ERROR(Text001);

        IF PaidToCorr THEN
            IF ReceivedFrom = '' THEN
                ERROR(Text002);

        IF UnitOfficeCodeCorr THEN
            IF UnitOfficeCode = '' THEN
                ERROR(Text003);

        UpdatePostedBonus(PostedDocNo, ReceivedFrom, PaidToCorr, UnitOfficeCodeCorr, UnitOfficeCode);
    end;


    procedure UpdatePostedBonus(PostedDocNo: Code[20]; ReceivedFrom: Code[20]; PaidToCorr: Boolean; UnitOfficeCodeCorr: Boolean; UnitOfficeCode: Code[20])
    var
        BonusPostingBuffer: Record "Bonus Posting Buffer";
        BonusEntryPosted: Record "Bonus Entry Posted";
        DocumentType: Option Application,RD,FD,MIS,BOND,Commission,Bonus;
    begin
        BonusPostingBuffer.SETCURRENTKEY(Status, "Posted Doc. No.", "G/L Posting Date", "Paid To", "Associate Code");
        BonusPostingBuffer.SETRANGE(Status, BonusPostingBuffer.Status::Posted);
        BonusPostingBuffer.SETRANGE("Posted Doc. No.", PostedDocNo);
        IF BonusPostingBuffer.FINDSET THEN
            REPEAT
                IF PaidToCorr THEN
                    BonusPostingBuffer."Paid To" := ReceivedFrom;

                IF UnitOfficeCodeCorr THEN
                    BonusPostingBuffer."Unit Office Code(Paid)" := UnitOfficeCode;

                BonusPostingBuffer.MODIFY;
            UNTIL BonusPostingBuffer.NEXT = 0
        ELSE BEGIN
            BonusEntryPosted.SETCURRENTKEY("Posted Doc. No.", "Paid To", "Associate Code", "Business Type", "G/L Posting Date");
            BonusEntryPosted.SETRANGE("Posted Doc. No.", PostedDocNo);
            IF BonusEntryPosted.FINDSET THEN
                REPEAT
                    IF PaidToCorr THEN
                        BonusEntryPosted."Paid To" := ReceivedFrom;

                    IF UnitOfficeCodeCorr THEN
                        BonusEntryPosted."Unit Office Code(Paid)" := UnitOfficeCode;

                    BonusEntryPosted.MODIFY;

                UNTIL BonusEntryPosted.NEXT = 0;
        END;

        DocumentType := DocumentType::Bonus;
        BondReverseEntry(PostedDocNo, DocumentType, '', '', 0D, 0D);
        GLEntryUpdate(PostedDocNo, PaidToCorr, 1, ReceivedFrom, UnitOfficeCodeCorr, UnitOfficeCode);
    end;


    procedure BondReverseEntry(PostedDocNo: Code[20]; DocumentType: Option Application,RD,FD,MIS,BOND,Commission,Bonus; ApplicationNo: Code[20]; BondNo: Code[20]; PostingDate: Date; DocumentDate: Date)
    var
        BondReversalEntries: Record "Unit Reversal Entries";
        UserSetup: Record "User Setup";
        LineNo: Integer;
    begin
        BondReversalEntries.SETRANGE("Document Type", DocumentType);
        BondReversalEntries.SETRANGE("Document No.", PostedDocNo);
        IF BondReversalEntries.FINDLAST THEN
            LineNo := BondReversalEntries."Line No." + 10000
        ELSE
            LineNo := 10000;

        BondReversalEntries.INIT;
        BondReversalEntries."Document Type" := DocumentType;
        BondReversalEntries."Document No." := PostedDocNo;
        BondReversalEntries."Line No." := LineNo;
        BondReversalEntries."Application No." := ApplicationNo;
        BondReversalEntries."Unit No." := BondNo;
        BondReversalEntries."Posted. Doc. No." := PostedDocNo;
        BondReversalEntries."Posting date" := PostingDate;
        BondReversalEntries."Document Date" := DocumentDate;
        BondReversalEntries."User ID" := USERID;
        BondReversalEntries."Reverse Date" := GetDescription.GetDocomentDate;
        BondReversalEntries."Reverse Time" := TIME;

        BondReversalEntries.INSERT;
    end;


    procedure GLEntryUpdate(PostedDocNo: Code[20]; PaidToCorr: Boolean; ReceivedFromType: Option " ","Marketing Member","Bond Holder"; ReceivedFrom: Code[20]; UnitOfficeCodeCorr: Boolean; UnitOfficeCode: Code[20])
    var
        GLEntry: Record "G/L Entry";
    begin
        GLEntry.SETCURRENTKEY("Document No.", "Posting Date", Amount);
        GLEntry.SETRANGE("Document No.", PostedDocNo);
        IF GLEntry.FINDSET THEN
            REPEAT
                IF PaidToCorr THEN BEGIN
                    GLEntry."BBG Paid To/Received From" := ReceivedFromType;
                    GLEntry."BBG Paid To/Received From Code" := ReceivedFrom;
                END;

                IF UnitOfficeCodeCorr THEN
                    GLEntry."Global Dimension 1 Code" := UnitOfficeCode;

                GLEntry.MODIFY;
            UNTIL GLEntry.NEXT = 0;
    end;
}

