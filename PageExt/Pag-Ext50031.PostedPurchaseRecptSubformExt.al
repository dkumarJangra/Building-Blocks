pageextension 50031 "BBG Ptd Purch Rcpt Subform Ext" extends "Posted Purchase Rcpt. Subform"
{

    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Undo Receipt")
        {
            action("&UndoJES")
            {
                Caption = '&UndoJES';
                ApplicationArea = All;

                trigger OnAction()
                var
                    OldGRNLine: Record "Purch. Rcpt. Line";
                    OldGRNLine2: Record "Purch. Rcpt. Line";
                    LineSpacing: Integer;
                    DocLineNo: Integer;
                    NewGRNLine: Record "Purch. Rcpt. Line";
                    Text002: Label 'There is not enough space to insert correction lines.';
                    PurchLine: Record "Purchase Line";
                    CustomfunctionsEvents: Codeunit "Job Queue for R-50082";
                    UpdateJESEntry: Codeunit "JES Reversal entry";

                begin
                    // ALLE ANSH NTPC START
                    OldGRNLine := Rec;
                    CurrPage.SETSELECTIONFILTER(OldGRNLine);
                    IF CONFIRM('Do you want to proceed', TRUE) THEN BEGIN

                        IF OldGRNLine.Quantity < 0 THEN
                            ERROR(Text005);
                        IF (OldGRNLine.Type <> OldGRNLine.Type::"G/L Account") AND (OldGRNLine.Type <> OldGRNLine.Type::"Fixed Asset") THEN
                            ERROR(TEXT006);
                        IF OldGRNLine."Qty. Rcd. Not Invoiced" <> OldGRNLine.Quantity THEN
                            ERROR(Text004);

                        IF OldGRNLine.Correction = TRUE THEN
                            ERROR('Already undo');

                        Clear(UpdateJESEntry);
                        UpdateJESEntry.UpdatePPReceipt(OldGRNLine);
                    END;
                    // ALLE ANSH NTPC STOP
                end;
            }

        }
    }

    var
        myInt: Integer;
        Text004: Label 'This receipt has already been invoiced. Undo Receipt can be applied only to posted, but not invoiced receipts.;ENN=This receipt has already been invoiced. Undo Receipt can be applied only to posted, but not invoiced receipts.';
        Text005: Label 'The Receipt has already been undo.';
        TEXT006: Label 'Type should be G/L Account or Fixed Asset.';
}