codeunit 97769 "Post Genjnl Lines Check"
{

    trigger OnRun()
    begin
    end;


    procedure CheckNarration(P_GenJnlLine: Record "Gen. Journal Line")
    var
        v_GenJournalLine: Record "Gen. Journal Line";
        GenJournalNarration: Record "Gen. Journal Narration"; //"16549";
    begin
        v_GenJournalLine.RESET;
        v_GenJournalLine.SETRANGE("Journal Template Name", P_GenJnlLine."Journal Template Name");
        v_GenJournalLine.SETRANGE("Journal Batch Name", P_GenJnlLine."Journal Batch Name");
        IF v_GenJournalLine.FINDSET THEN
            REPEAT
                GenJournalNarration.RESET;
                GenJournalNarration.SETRANGE("Journal Template Name", v_GenJournalLine."Journal Template Name");
                GenJournalNarration.SETRANGE("Journal Batch Name", v_GenJournalLine."Journal Batch Name");
                GenJournalNarration.SETRANGE("Document No.", v_GenJournalLine."Document No.");
                IF GenJournalNarration.FINDFIRST THEN
                    GenJournalNarration.TESTFIELD(Narration)
                ELSE
                    ERROR('Please define Narration against Document No. - ' + v_GenJournalLine."Document No.");
            UNTIL v_GenJournalLine.NEXT = 0;
    end;
}

