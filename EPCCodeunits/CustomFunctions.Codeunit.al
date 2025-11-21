codeunit 50040 "Custom Functions"
{

    trigger OnRun()
    begin
    end;

    var
        GiftGrams: Decimal;
        ProjectwiseDevelopmentCharg: Record "Project wise Development Charg";
        CustomerGiftsSetup_1: Record "Customer Gifts Setup";
        TotalAmtReceived: Decimal;
        ReceivedVeritaAmt: Decimal;
        NoofGifts: Decimal;
        CustomerGiftsSetup: Record "Customer Gifts Setup";
        TotalGramIssued: Decimal;
        GatePassLine: Record "Gate Pass Line";
        Item: Record Item;


    procedure EventEntriesCreation()
    var
        EventDetails: Record "Event Datails";
        OldEventDetails: Record "Event Datails";
        NewEventDetails: Record "Event Datails";
        LastEntryNo: Integer;
        LastEventID: Integer;
        NewEntryNo: Integer;
        NewEventID: Integer;
        FromEntryNo: Integer;
        ToEntryNo: Integer;
    begin

        EventDetails.RESET;
        IF EventDetails.FINDLAST THEN BEGIN
            LastEntryNo := EventDetails."Entry No.";
            LastEventID := EventDetails."Event ID";
        END;

        NewEntryNo := LastEntryNo + 1;
        NewEventID := LastEventID + 1;

        EventDetails.RESET;
        EventDetails.SETRANGE("Event Status", EventDetails."Event Status"::Active);
        IF EventDetails.FINDFIRST THEN
            FromEntryNo := EventDetails."Entry No.";

        EventDetails.RESET;
        EventDetails.SETRANGE("Event Status", EventDetails."Event Status"::Active);
        IF EventDetails.FINDLAST THEN
            ToEntryNo := EventDetails."Entry No.";

        OldEventDetails.RESET;
        OldEventDetails.SETRANGE("Entry No.", FromEntryNo, ToEntryNo);
        OldEventDetails.SETRANGE("Event Status", OldEventDetails."Event Status"::Active);
        OldEventDetails.SETFILTER("Event Date", '<%1', TODAY);
        IF OldEventDetails.FINDFIRST THEN
            REPEAT
                NewEventDetails.RESET;
                NewEventDetails.SETRANGE("Event Name", OldEventDetails."Event Name");
                NewEventDetails.SETRANGE("Event Date", TODAY);
                IF NOT NewEventDetails.FINDFIRST THEN BEGIN
                    NewEventDetails.INIT;
                    NewEventDetails.TRANSFERFIELDS(OldEventDetails);
                    NewEventDetails."Entry No." := NewEntryNo;
                    NewEventDetails."Event ID" := NewEventID;
                    NewEventDetails."Event Date" := TODAY;
                    NewEventDetails.INSERT(TRUE);

                    OldEventDetails."Event Status" := OldEventDetails."Event Status"::"In-Active";
                    OldEventDetails.MODIFY;
                    NewEntryNo := NewEntryNo + 1;
                    NewEventID := NewEventID + 1;
                END;
            UNTIL OldEventDetails.NEXT = 0;
    end;


    procedure SilverGramEligibuility(NewConfirmedOrder: Record "New Confirmed Order"): Decimal
    begin
        GiftGrams := 0;
        TotalAmtReceived := 0;
        ReceivedVeritaAmt := 0;
        NoofGifts := 0;
        NewConfirmedOrder.CALCFIELDS("Total Received Amount");
        ProjectwiseDevelopmentCharg.RESET;
        ProjectwiseDevelopmentCharg.SETRANGE("Project Code", NewConfirmedOrder."Shortcut Dimension 1 Code");
        ProjectwiseDevelopmentCharg.SETFILTER(Amount, '<>%1', 0);
        ProjectwiseDevelopmentCharg.SETRANGE(Status, ProjectwiseDevelopmentCharg.Status::Release);
        IF ProjectwiseDevelopmentCharg.FINDLAST THEN
            ReceivedVeritaAmt := ReceivedVeritaAmt + (NewConfirmedOrder."Saleable Area" * ProjectwiseDevelopmentCharg.Amount);


        CustomerGiftsSetup_1.RESET;
        CustomerGiftsSetup_1.SETCURRENTKEY("Project Code", "Effective Date");
        CustomerGiftsSetup_1.SETRANGE("Project Code", NewConfirmedOrder."Shortcut Dimension 1 Code");
        CustomerGiftsSetup_1.SETFILTER("Effective Date", '<=%1', NewConfirmedOrder."Posting Date"); //300424 added new filter
        CustomerGiftsSetup_1.SETRANGE(Status, CustomerGiftsSetup_1.Status::Release);
        IF CustomerGiftsSetup_1.FINDLAST THEN BEGIN
            CustomerGiftsSetup.RESET;
            CustomerGiftsSetup.SETRANGE("Project Code", NewConfirmedOrder."Shortcut Dimension 1 Code");
            CustomerGiftsSetup.SETRANGE("Effective Date", CustomerGiftsSetup_1."Effective Date"); //300424 added new filter
            IF CustomerGiftsSetup.FINDSET THEN
                REPEAT
                    IF (NewConfirmedOrder."Total Received Amount" + ReceivedVeritaAmt) >= CustomerGiftsSetup."Eligible Amount" THEN BEGIN
                        NoofGifts := (NewConfirmedOrder."Total Received Amount" + ReceivedVeritaAmt) / CustomerGiftsSetup."Eligible Amount";
                        NoofGifts := ROUND(NoofGifts, 1, '=');
                        GiftGrams := CustomerGiftsSetup.Grams * NoofGifts;
                    END;
                UNTIL CustomerGiftsSetup.NEXT = 0;
        END;
        EXIT(GiftGrams);
    end;


    procedure BalancSilverGramEligibility(NewConfirmedOrder: Record "New Confirmed Order"): Decimal
    begin
        GiftGrams := 0;
        TotalAmtReceived := 0;
        ReceivedVeritaAmt := 0;
        NoofGifts := 0;

        NewConfirmedOrder.CALCFIELDS("Total Received Amount");
        ProjectwiseDevelopmentCharg.RESET;
        ProjectwiseDevelopmentCharg.SETRANGE("Project Code", NewConfirmedOrder."Shortcut Dimension 1 Code");
        ProjectwiseDevelopmentCharg.SETFILTER(Amount, '<>%1', 0);
        ProjectwiseDevelopmentCharg.SETRANGE(Status, ProjectwiseDevelopmentCharg.Status::Release);
        IF ProjectwiseDevelopmentCharg.FINDLAST THEN
            ReceivedVeritaAmt := ReceivedVeritaAmt + (NewConfirmedOrder."Saleable Area" * ProjectwiseDevelopmentCharg.Amount);


        CustomerGiftsSetup_1.RESET;
        CustomerGiftsSetup_1.SETCURRENTKEY("Project Code", "Effective Date");
        CustomerGiftsSetup_1.SETRANGE("Project Code", NewConfirmedOrder."Shortcut Dimension 1 Code");
        CustomerGiftsSetup_1.SETFILTER("Effective Date", '<=%1', NewConfirmedOrder."Posting Date"); //300424 added new filter
        CustomerGiftsSetup_1.SETRANGE(Status, CustomerGiftsSetup_1.Status::Release);
        IF CustomerGiftsSetup_1.FINDLAST THEN BEGIN
            CustomerGiftsSetup.RESET;
            CustomerGiftsSetup.SETRANGE("Project Code", NewConfirmedOrder."Shortcut Dimension 1 Code");
            CustomerGiftsSetup.SETRANGE("Effective Date", CustomerGiftsSetup_1."Effective Date"); //300424 added new filter
            IF CustomerGiftsSetup.FINDSET THEN
                REPEAT
                    IF (NewConfirmedOrder."Total Received Amount" + ReceivedVeritaAmt) >= CustomerGiftsSetup."Eligible Amount" THEN BEGIN
                        NoofGifts := (NewConfirmedOrder."Total Received Amount" + ReceivedVeritaAmt) / CustomerGiftsSetup."Eligible Amount";
                        NoofGifts := ROUND(NoofGifts, 1, '=');
                        GiftGrams := CustomerGiftsSetup.Grams * NoofGifts;
                    END;
                UNTIL CustomerGiftsSetup.NEXT = 0;
        END;

        TotalGramIssued := 0;
        GatePassLine.RESET;
        GatePassLine.CHANGECOMPANY(NewConfirmedOrder."Company Name");
        GatePassLine.SETRANGE("Application No.", NewConfirmedOrder."No.");
        GatePassLine.SETRANGE(Status, GatePassLine.Status::Close);
        IF GatePassLine.FINDSET THEN
            REPEAT
                Item.RESET;
                Item.CHANGECOMPANY(NewConfirmedOrder."Company Name");
                IF Item.GET(GatePassLine."Item No.") THEN
                    TotalGramIssued := TotalGramIssued + (GatePassLine.Qty * Item."Silver / Gold in Grams");
            UNTIL GatePassLine.NEXT = 0;

        IF (GiftGrams - TotalGramIssued) > 0 THEN
            EXIT(GiftGrams - TotalGramIssued)
        ELSE
            EXIT(0);
    end;
}

