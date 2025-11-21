codeunit 97737 "Application Sales Invoice"
{

    trigger OnRun()
    begin
    end;

    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        UnitSetup: Record "Unit Setup";
        COrd: Record "Confirmed Order";
        Text001: Label 'Do you want to post Sales Invoice with Posting Date %1 ?';
        AppPayEntry: Record "Application Payment Entry";
        DiscAmt: Decimal;
        PayTermsLine: Record "Payment Terms Line Sale";
        CorpusAmt: Decimal;
        GLAcc: Record "G/L Account";
        ConfOrders: Record "Confirmed Order";
        SalesinvExists: Boolean;
        PostSalesinvExists: Boolean;


    procedure SalesHeaderInsert(AppNo: Code[20]; CallFromBatch: Boolean; RegStDate_1: Date; RegEndDate_1: Date; InvPostDate_1: Date)
    var
        SaleSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SOHeader: Record "Sales Header";
        SaleNo: Code[20];
        SInvHead: Record "Sales Invoice Header";
    begin
        IF NOT CallFromBatch THEN BEGIN
            ConfOrders.GET(AppNo);
            ConfOrders.TESTFIELD("Registration No.");
            ConfOrders.TESTFIELD("Registration Date");
            SInvHead.RESET;
            SInvHead.SETRANGE("External Document No.", AppNo);
            IF SInvHead.FINDFIRST THEN
                ERROR('Sales Invoice already exist for the Application No. %1', AppNo);
            SOHeader.RESET;
            SOHeader.SETRANGE("External Document No.", AppNo);
            IF SOHeader.FINDFIRST THEN
                ERROR('Sales Invoice already exist for the Application No. %1', AppNo);
            UnitSetup.GET;
            UnitSetup.TESTFIELD("Application Sales No. Series");
            UnitSetup.TESTFIELD("Sales G/L Account");
            SalesHeader.INIT;
            SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
            SalesHeader."No." := NoSeriesMgt.GetNextNo(UnitSetup."Application Sales No. Series", InvPostDate_1, TRUE);
            SalesHeader.INSERT(TRUE);
            SaleNo := SalesHeader."No.";
            SalesHeader.VALIDATE(SalesHeader."Sell-to Customer No.", ConfOrders."Customer No.");
            //SalesHeader.VALIDATE("Posting Date",ConfOrders."Registration Date");
            SalesHeader.VALIDATE("Posting Date", InvPostDate_1);
            SalesHeader.VALIDATE("External Document No.", ConfOrders."No.");
            SalesHeader.VALIDATE("Location Code", ConfOrders."Shortcut Dimension 1 Code");
            SalesHeader.VALIDATE("Shortcut Dimension 1 Code", ConfOrders."Shortcut Dimension 1 Code");
            SalesHeader."Application No." := ConfOrders."No.";
            SalesHeader."Unit Code" := ConfOrders."Unit Code";
            SalesHeader.Approved := TRUE;
            SalesHeader."Approved Date" := TODAY;
            SalesHeader."Approved Time" := TIME;
            SalesHeader."Sent for Approval Date" := TODAY;
            SalesHeader."Sent for Approval Time" := TIME;
            SalesHeader."Sent for Approval" := TRUE;
            SalesHeader.MODIFY(TRUE);
            SalesLineInsert;
            CODEUNIT.RUN(CODEUNIT::"Sales-Post (Yes/No)", SalesHeader);
            COMMIT;
            ConfOrders."Sales Invoice booked" := TRUE;
            ConfOrders.MODIFY;
        END ELSE BEGIN
            ConfOrders.RESET;
            // ConfOrders.SETRANGE("Method Applicable",ConfOrders."Method Applicable"::"Normal Method");
            ConfOrders.SETRANGE("Sales Invoice booked", FALSE);
            ConfOrders.SETRANGE("Sales Invoice Applicable", TRUE);
            ConfOrders.SETRANGE("Registration Date", RegStDate_1, RegEndDate_1);
            ConfOrders.SETRANGE("Application Transfered", FALSE);
            IF ConfOrders.FINDSET THEN
                REPEAT
                    SalesinvExists := FALSE;
                    ConfOrders.TESTFIELD("Registration No.");
                    ConfOrders.TESTFIELD("Registration Date");
                    SInvHead.RESET;
                    SInvHead.SETRANGE("External Document No.", ConfOrders."No.");
                    IF SInvHead.FINDFIRST THEN
                        SalesinvExists := TRUE;
                    SOHeader.RESET;
                    SOHeader.SETRANGE("External Document No.", ConfOrders."No.");
                    IF SOHeader.FINDFIRST THEN BEGIN
                        SalesinvExists := TRUE;
                        SalesHeader := SOHeader;
                    END;
                    UnitSetup.GET;
                    UnitSetup.TESTFIELD("Application Sales No. Series");
                    //    GLAcc.GET(UnitSetup."CORPUS Account");
                    //    GLAcc.TESTFIELD("Gen. Prod. Posting Group");
                    IF NOT SalesinvExists THEN BEGIN
                        SalesHeader.INIT;
                        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                        SalesHeader."No." := NoSeriesMgt.GetNextNo(UnitSetup."Application Sales No. Series", InvPostDate_1, TRUE);
                        SalesHeader.INSERT(TRUE);
                        SaleNo := SalesHeader."No.";
                        SalesHeader.VALIDATE(SalesHeader."Sell-to Customer No.", ConfOrders."Customer No.");
                        //SalesHeader.VALIDATE("Posting Date",ConfOrders."Registration Date");
                        SalesHeader.VALIDATE("Posting Date", InvPostDate_1);
                        SalesHeader.VALIDATE("External Document No.", ConfOrders."No.");
                        SalesHeader.VALIDATE("Location Code", ConfOrders."Shortcut Dimension 1 Code");
                        SalesHeader.VALIDATE("Shortcut Dimension 1 Code", ConfOrders."Shortcut Dimension 1 Code");
                        SalesHeader."Application No." := ConfOrders."No.";
                        SalesHeader."Unit Code" := ConfOrders."Unit Code";
                        SalesHeader.Approved := TRUE;
                        SalesHeader."Approved Date" := TODAY;
                        SalesHeader."Approved Time" := TIME;
                        SalesHeader."Sent for Approval Date" := TODAY;
                        SalesHeader."Sent for Approval Time" := TIME;
                        SalesHeader."Sent for Approval" := TRUE;
                        SalesHeader.MODIFY(TRUE);
                        SalesLineInsert;
                        ConfOrders."Sales Invoice booked" := TRUE;
                        ConfOrders.MODIFY;
                        COMMIT;
                        CODEUNIT.RUN(CODEUNIT::"Sales-Post", SalesHeader);

                    END;
                UNTIL ConfOrders.NEXT = 0;
            //     COMMIT;
            //     REPORT.RUN(REPORT::"Batch Post Sales Invoices",FALSE,FALSE,SalesHeader);
        END;
    end;


    procedure SalesLineInsert()
    begin

        CLEAR(DiscAmt);
        DiscAmt := 0;
        AppPayEntry.RESET;
        AppPayEntry.SETRANGE("Document No.", ConfOrders."No.");
        AppPayEntry.SETRANGE("Payment Mode", AppPayEntry."Payment Mode"::"Debit Note");
        AppPayEntry.SETRANGE("Associate Code For Disc", 'IBA9999999');
        IF AppPayEntry.FINDSET THEN
            REPEAT
                DiscAmt += AppPayEntry.Amount;
            UNTIL AppPayEntry.NEXT = 0;
        CorpusAmt := 0;
        CLEAR(CorpusAmt);
        PayTermsLine.RESET;
        PayTermsLine.SETRANGE("Document No.", ConfOrders."No.");
        PayTermsLine.SETRANGE("Charge Code", 'CORPUS');
        IF PayTermsLine.FINDLAST THEN
            CorpusAmt := PayTermsLine."Due Amount";

        SalesLine.INIT;
        SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := 10000;
        SalesLine.INSERT(TRUE);
        SalesLine.VALIDATE("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
        SalesLine.VALIDATE(Type, SalesLine.Type::"G/L Account");
        SalesLine.VALIDATE("No.", UnitSetup."Sales G/L Account");
        //SalesLine.VALIDATE(Quantity,ConfOrders."Saleable Area");
        SalesLine.VALIDATE(Quantity, 1);
        IF CorpusAmt <> 0 THEN
            SalesLine.VALIDATE("Unit Price", ConfOrders.Amount - CorpusAmt)
        ELSE
            SalesLine.VALIDATE("Unit Price", ConfOrders.Amount);
        SalesLine."Gen. Prod. Posting Group" := 'GEN';
        SalesLine.MODIFY(TRUE);
    end;
}

