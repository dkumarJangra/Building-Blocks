report 50023 "Sales invoice DAta"
{
    // version Done

    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Confirmed Order"; "Confirmed Order")
        {
            DataItemTableView = SORTING("Sales Invoice Applicable", "Registration Date", Status)
                                WHERE(Status = FILTER(Registered),
                                      "Sales Invoice booked" = FILTER(false),
                                      "Sales Invoice Applicable" = FILTER(true));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin

                SalesHeaderInsert("No.");
                ConORder.GET("No.");
                ConORder."Sales Invoice booked" := TRUE;
                ConORder.MODIFY;
                NewconfirmedOrder.RESET;
                IF NewconfirmedOrder.GET("No.") THEN BEGIN
                    NewconfirmedOrder."Sales Invoice booked" := TRUE;
                    NewconfirmedOrder.MODIFY;
                END;
                COMMIT;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Sales Invoice Date"; InvPostDate)
                {
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        ConORder: Record "Confirmed Order";
        InvPostDate: Date;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        UnitSetup: Record "Unit Setup";
        AppPayEntry: Record "Application Payment Entry";
        DiscAmt: Decimal;
        PayTermsLine: Record "Payment Terms Line Sale";
        CorpusAmt: Decimal;
        GLAcc: Record "G/L Account";
        SalesinvExists: Boolean;
        PostSalesinvExists: Boolean;
        RgStDAte: Date;
        RgEndDate: Date;
        NewconfirmedOrder: Record "New Confirmed Order";

    procedure SalesHeaderInsert(APPNo: Code[20])
    var
        SaleSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        SOHeader: Record "Sales Header";
        SaleNo: Code[20];
        SInvHead: Record "Sales Invoice Header";
    begin
        SInvHead.RESET;
        SInvHead.SETRANGE("External Document No.", APPNo);
        SInvHead.SETRANGE("Sell-to Customer No.", "Confirmed Order"."Customer No.");
        IF SInvHead.FINDFIRST THEN BEGIN
            //ERROR('Sales Invoice already exist for the Application No. %1',APPNo)
            "Confirmed Order"."Sales Invoice booked" := TRUE;
            "Confirmed Order".MODIFY;
        END ELSE BEGIN
            SOHeader.RESET;
            SOHeader.SETRANGE("External Document No.", APPNo);
            IF SOHeader.FINDFIRST THEN
                ERROR('Sales Invoice already exist for the Application No. %1', APPNo);
            UnitSetup.GET;
            UnitSetup.TESTFIELD("Application Sales No. Series");
            UnitSetup.TESTFIELD("Sales G/L Account");
            SalesHeader.INIT;
            SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
            SalesHeader."No." := NoSeriesMgt.GetNextNo(UnitSetup."Application Sales No. Series", InvPostDate, TRUE);
            SalesHeader.INSERT(TRUE);
            SalesHeader."Assigned User ID" := USERID;
            SaleNo := SalesHeader."No.";
            SalesHeader.VALIDATE(SalesHeader."Sell-to Customer No.", "Confirmed Order"."Customer No.");
            //SalesHeader.VALIDATE("Posting Date",ConfOrders."Registration Date");
            SalesHeader.VALIDATE("Posting Date", InvPostDate);
            SalesHeader.VALIDATE("External Document No.", "Confirmed Order"."No.");
            SalesHeader.VALIDATE("Location Code", "Confirmed Order"."Shortcut Dimension 1 Code");
            SalesHeader.VALIDATE("Shortcut Dimension 1 Code", "Confirmed Order"."Shortcut Dimension 1 Code");
            SalesHeader."Application No." := "Confirmed Order"."No.";
            SalesHeader."Unit Code" := "Confirmed Order"."Unit Code";
            SalesHeader.Approved := TRUE;
            SalesHeader."Approved Date" := TODAY;
            SalesHeader."Approved Time" := TIME;
            SalesHeader."Sent for Approval Date" := TODAY;
            SalesHeader."Sent for Approval Time" := TIME;
            SalesHeader."Sent for Approval" := TRUE;
            SalesHeader.MODIFY(TRUE);
            SalesLineInsert;
            //  CODEUNIT.RUN(CODEUNIT::"Sales-Post (Yes/No)",SalesHeader);
            CODEUNIT.RUN(CODEUNIT::"Sales-Post", SalesHeader);
            COMMIT;
        END;
    end;

    procedure SalesLineInsert()
    begin

        CLEAR(DiscAmt);
        DiscAmt := 0;
        AppPayEntry.RESET;
        AppPayEntry.SETRANGE("Document No.", "Confirmed Order"."No.");
        AppPayEntry.SETRANGE("Payment Mode", AppPayEntry."Payment Mode"::"Debit Note");
        AppPayEntry.SETRANGE("Associate Code For Disc", 'IBA9999999');
        IF AppPayEntry.FINDSET THEN
            REPEAT
                DiscAmt += AppPayEntry.Amount;
            UNTIL AppPayEntry.NEXT = 0;
        CorpusAmt := 0;
        CLEAR(CorpusAmt);
        PayTermsLine.RESET;
        PayTermsLine.SETRANGE("Document No.", "Confirmed Order"."No.");
        PayTermsLine.SETRANGE("Charge Code", 'EXCESS'); //'Corpus'
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
        //IF CorpusAmt<>0 THEN
        //  SalesLine.VALIDATE("Unit Price","Confirmed Order".Amount-CorpusAmt)
        //ELSE
        SalesLine.VALIDATE("Unit Price", "Confirmed Order".Amount);
        SalesLine."Gen. Prod. Posting Group" := 'GEN';
        SalesLine.MODIFY(TRUE);
    end;
}

