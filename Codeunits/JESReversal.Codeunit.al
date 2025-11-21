codeunit 50070 "JES Reversal entry"
{
    Permissions = tabledata "Purch. Rcpt. Line" = RIM;


    var
        ApplicationChequeStatus: Page "Application Cheque Status";
        PG: page "Purchase Invoice";

    procedure UpdatePPReceipt(Var PurchRcptLine: Record "Purch. Rcpt. Line")
    var

        OldGRNLine2: Record "Purch. Rcpt. Line";
        LineSpacing: Integer;
        DocLineNo: Integer;
        NewGRNLine: Record "Purch. Rcpt. Line";
        Text002: Label 'There is not enough space to insert correction lines.';
        PurchLine: Record "Purchase Line";
        CustomfunctionsEvents: Codeunit "Job Queue for R-50082";
    begin
        //OldGRNLine.RESET;
        //OldGRNLine.Copy(PurchRcptLine);
        IF PurchRcptLine.Findset then
            repeat

                //IF OldGRNLine.GET(PurchRcptLine."Document No.", PurchRcptLine."Line No.") THEN begin
                OldGRNLine2.RESET;
                OldGRNLine2.SETRANGE("Document No.", PurchRcptLine."Document No.");
                OldGRNLine2."Document No." := PurchRcptLine."Document No.";
                OldGRNLine2."Line No." := PurchRcptLine."Line No.";
                OldGRNLine2.FIND('=');
                IF OldGRNLine2.FIND('>') THEN BEGIN
                    LineSpacing := (OldGRNLine2."Line No." - PurchRcptLine."Line No.") DIV 2;
                    IF LineSpacing = 0 THEN
                        ERROR(Text002);
                END ELSE
                    LineSpacing := 10000;
                DocLineNo := PurchRcptLine."Line No." + LineSpacing;

                NewGRNLine.INIT;
                NewGRNLine.COPY(PurchRcptLine);
                NewGRNLine."Line No." := DocLineNo;
                NewGRNLine.Quantity := -PurchRcptLine.Quantity;
                NewGRNLine."Quantity (Base)" := -PurchRcptLine."Quantity (Base)";
                NewGRNLine."Quantity Invoiced" := NewGRNLine."Quantity Invoiced";
                NewGRNLine."Qty. Invoiced (Base)" := NewGRNLine."Qty. Invoiced (Base)";
                NewGRNLine."Qty. Rcd. Not Invoiced" := 0;
                NewGRNLine.Correction := TRUE;
                //EPC2016Upgrade
                //  NewGRNLine."Parallel Quantity To Receive" := -"Parallel Quantity To Receive";
                //  NewGRNLine."Parallel Quantity Received" := -"Parallel Quantity Received";
                NewGRNLine."Dimension Set ID" := PurchRcptLine."Dimension Set ID";
                PurchLine.GET(PurchLine."Document Type"::Order, PurchRcptLine."Order No.", PurchRcptLine."Order Line No.");
                PurchLine.VALIDATE("Quantity Received", (PurchLine."Quantity Received" - ABS(PurchRcptLine.Quantity)));
                PurchLine."Qty. to Receive" := PurchLine.Quantity - PurchLine."Quantity Received";
                PurchLine."Qty. to Invoice" := PurchLine.Quantity - PurchLine."Quantity Invoiced";
                PurchLine."Qty. Received (Base)" := PurchLine."Quantity Received";
                PurchLine."Qty. Rcd. Not Invoiced" := PurchLine."Quantity Received" - PurchLine."Quantity Invoiced";
                PurchLine."Qty. Rcd. Not Invoiced (Base)" := PurchLine."Quantity Received" - PurchLine."Quantity Invoiced";
                PurchLine.MODIFY;
                PurchRcptLine.Correction := TRUE;
                PurchRcptLine.MODIFY;
                NewGRNLine.INSERT;
            until PurchRcptLine.Next = 0;
    END;
}

