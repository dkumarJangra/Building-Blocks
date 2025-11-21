report 97796 "Archive Purchase Document"
{
    // version Done

    // NDALLE 051207 Link in StorePurchDocument Function attached to Standard Archive table
    // //NDALLE240108
    // ALLETG RIL0011 23-06-2011: Added code to archive del. schedule lines
    // ALLEPG 271211 : Changed storejobplanning function
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/Archive Purchase Document.rdl';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;


    dataset
    {
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

    labels
    {
    }

    var
        Text001: Label 'Document %1 has been archived.';
        Text002: Label 'Do you want to Restore %1 %2 Version %3?';
        Text003: Label '%1 %2 has been restored.';
        Text004: Label 'Document restored from Version %1.';
        Text005: Label '%1 %2 has been partly posted.\Restore not possible.';
        Text006: Label 'Entries exist for on or more of the following:\  - %1\  - %2\  - %3.\Restoration of document will delete these entries.\Continue with restore?';
        Text007: Label 'Archive %1 no.: %2?';
        Text008: Label 'Item Tracking Line';
        ReleaseSalesDoc: Codeunit "Release Sales Document";//414
        RecTerms: Record Terms;
        RecArchTerms: Record "Terms Archived";
        PurchDlvrSchedule: Record "Purch. Delivery Schedule";
        PurchDlvrScheduleArchive: Record "Unit Setup";
        VersionNo: Integer;

    procedure ArchiveSalesDocument(var SalesHeader: Record "Sales Header")
    begin
        /*
        IF CONFIRM(
          Text007,TRUE,SalesHeader."Document Type",
          SalesHeader."No.")
        THEN BEGIN
          StoreSalesDocument(SalesHeader,FALSE);
          MESSAGE(Text001,SalesHeader."No.");
        END;
        */

    end;

    procedure ArchivePurchDocument(var PurchHeader: Record "Purchase Header")
    begin
        //IF CONFIRM(
        //  Text007,TRUE,PurchHeader."Document Type",
        //  PurchHeader."No.")
        //THEN BEGIN
        StorePurchDocument(PurchHeader, FALSE);
        MESSAGE(Text001, PurchHeader."No.");
        //END;
    end;

    procedure StoreSalesDocument(var SalesHeader: Record "Sales Header"; InteractionExist: Boolean)
    var
        SalesLine: Record "Sales Line";
        SalesHeaderArchive: Record "Sales Header Archive";
        SalesLineArchive: Record "Sales Line Archive";
    begin
        /*
        SalesHeaderArchive.INIT;
        SalesHeaderArchive.TRANSFERFIELDS(SalesHeader);
        SalesHeaderArchive."Archived By" := USERID;
        SalesHeaderArchive."Date Archived" := WORKDATE;
        SalesHeaderArchive."Time Archived" := TIME;
        SalesHeaderArchive."Version No." := GetNextVersionNo(
          DATABASE::"Sales Header",SalesHeader."Document Type",SalesHeader."No.",SalesHeader."Doc. No. Occurrence");
        SalesHeaderArchive."Interaction Exist" := InteractionExist;
        SalesHeaderArchive.INSERT;
        
        StoreDocDim(
          DATABASE::"Sales Header",SalesHeader."Document Type",
          SalesHeader."No.",0,SalesHeader."Doc. No. Occurrence",SalesHeaderArchive."Version No.");
        
        SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.",SalesHeader."No.");
        IF SalesLine.FIND('-') THEN
          REPEAT
            WITH SalesLineArchive DO BEGIN
              INIT;
              TRANSFERFIELDS(SalesLine);
              "Doc. No. Occurrence" := SalesHeader."Doc. No. Occurrence";
              "Version No." := SalesHeaderArchive."Version No.";
              INSERT;
              StoreDocDim(
                DATABASE::"Sales Line",SalesLine."Document Type",SalesLine."Document No.",
                SalesLine."Line No.",SalesHeader."Doc. No. Occurrence","Version No.");
            END
          UNTIL SalesLine.NEXT = 0;
        */

    end;

    procedure StorePurchDocument(var PurchHeader: Record "Purchase Header"; InteractionExist: Boolean)
    var
        PurchLine: Record "Purchase Line";
        PurchHeaderArchive: Record "Purchase Header Archive";
        PurchLineArchive: Record "Purchase Line Archive";
        VersionNo: Integer;
    begin
        PurchHeaderArchive.INIT;
        PurchHeaderArchive.TRANSFERFIELDS(PurchHeader);
        PurchHeaderArchive."Archived By" := USERID;
        PurchHeaderArchive."Date Archived" := WORKDATE;
        PurchHeaderArchive."Time Archived" := TIME;

        //ALLEAA begin
        VersionNo := GetNextVersionNo(
          DATABASE::"Purchase Header", PurchHeader."Document Type", PurchHeader."No.", PurchHeader."Doc. No. Occurrence");
        //PurchHeaderArchive."Version No." := GetNextVersionNo(
        //  DATABASE::"Purchase Header",PurchHeader."Document Type",PurchHeader."No.",PurchHeader."Doc. No. Occurrence");
        PurchHeaderArchive."Version No." := VersionNo;
        //ALLEAA end
        PurchHeaderArchive."Interaction Exist" := InteractionExist;
        PurchHeaderArchive.INSERT;

        StoreDocDim(
          DATABASE::"Purchase Header", PurchHeader."Document Type",
          PurchHeader."No.", 0, PurchHeader."Doc. No. Occurrence", PurchHeaderArchive."Version No.");

        PurchLine.SETRANGE("Document Type", PurchHeader."Document Type");
        PurchLine.SETRANGE("Document No.", PurchHeader."No.");
        IF PurchLine.FIND('-') THEN
            REPEAT
                WITH PurchLineArchive DO BEGIN
                    INIT;
                    TRANSFERFIELDS(PurchLine);
                    "Doc. No. Occurrence" := PurchHeader."Doc. No. Occurrence";
                    "Version No." := PurchHeaderArchive."Version No.";
                    INSERT;
                    StoreDocDim(
                      DATABASE::"Purchase Line", PurchLine."Document Type", PurchLine."Document No.",
                      PurchLine."Line No.", PurchHeader."Doc. No. Occurrence", "Version No.");
                END
            UNTIL PurchLine.NEXT = 0;


        //NDALLE 051207

        RecTerms.SETRANGE("Document Type", PurchHeader."Document Type");
        RecTerms.SETRANGE("Document No.", PurchHeader."No.");
        IF RecTerms.FIND('-') THEN BEGIN
            REPEAT
                RecArchTerms.INIT;
                RecArchTerms."Document Type" := RecTerms."Document Type";
                RecArchTerms."Document No." := RecTerms."Document No.";
                RecArchTerms."Term Type" := RecTerms."Term Type";
                RecArchTerms."Line No." := RecTerms."Line No.";
                RecArchTerms.Narration := RecTerms.Narration;
                //ALLEAA begin
                RecArchTerms."Version No." := VersionNo;
                //RecArchTerms."Version No." := GetNextVersionNoForTerms(
                //  RecTerms."Document Type",RecTerms."Document No.",RecTerms."Term Type",RecTerms."Line No.");
                //ALLEAA end
                RecArchTerms.INSERT;
            UNTIL RecTerms.NEXT = 0;
        END;
        //NDALLE 051207
        /*
        //ALLETG RIL0011 23-06-2011: START>>
        PurchDlvrSchedule.RESET;
        PurchDlvrSchedule.SETRANGE("Document Type",PurchHeader."Document Type");
        PurchDlvrSchedule.SETRANGE("Document No.",PurchHeader."No.");
        IF PurchDlvrSchedule.FINDSET THEN
          REPEAT
            WITH PurchDlvrScheduleArchive DO BEGIN
              INIT;
              TRANSFERFIELDS(PurchDlvrSchedule);
              //"Loan No. Series" := PurchHeader."Doc. No. Occurrence";
              //"Discount Allowed on Bond A/C" := PurchHeaderArchive."Version No.";
              INSERT;
            END
          UNTIL PurchDlvrSchedule.NEXT = 0;
        //ALLETG RIL0011 23-06-2011: END<<
         */

    end;

    procedure RestoreSalesDocument(var SalesHeaderArchive: Record "Sales Header Archive")
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesLineArchive: Record "Sales Line Archive";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        ReservEntry: Record "Reservation Entry";
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        SalesCommentLine: Record "Sales Comment Line";
        TmpSalesCommentLine: Record "Sales Comment Line" temporary;
        SalesPost: Codeunit "Sales-Post";
        NextLine: Integer;
        ConfirmRequired: Boolean;
        RestoreDocument: Boolean;
    begin
        /*
        SalesHeader.GET(SalesHeaderArchive."Document Type",SalesHeaderArchive."No.");
        SalesHeader.TESTFIELD(Status, SalesHeader.Status::Open);
        IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order THEN BEGIN
          SalesShptHeader.RESET;
          SalesShptHeader.SETCURRENTKEY("Order No.");
          SalesShptHeader.SETRANGE("Order No.", SalesHeader."No.");
          IF SalesShptHeader.FIND('-') THEN
            ERROR(Text005, SalesHeader."Document Type", SalesHeader."No.");
          SalesInvHeader.RESET;
          SalesInvHeader.SETCURRENTKEY("Order No.");
          SalesInvHeader.SETRANGE("Order No.", SalesHeader."No.");
          IF SalesInvHeader.FIND('-') THEN
            ERROR(Text005, SalesHeader."Document Type", SalesHeader."No.");
        END;
        
        ConfirmRequired := FALSE;
        ReservEntry.RESET;
        ReservEntry.SETCURRENTKEY(
          "Source ID",
          "Source Ref. No.",
          "Source Type",
          "Source Subtype");
        
        ReservEntry.SETRANGE("Source ID", SalesHeader."No.");
        ReservEntry.SETRANGE("Source Type", DATABASE::"Sales Line");
        ReservEntry.SETRANGE("Source Subtype", SalesHeader."Document Type");
        IF ReservEntry.FIND('-') THEN
          ConfirmRequired := TRUE;
        
        ItemChargeAssgntSales.RESET;
        ItemChargeAssgntSales.SETRANGE("Document Type", SalesHeader."Document Type");
        ItemChargeAssgntSales.SETRANGE("Document No.", SalesHeader."No.");
        IF ItemChargeAssgntSales.FIND('-') THEN
          ConfirmRequired := TRUE;
        
        RestoreDocument := FALSE;
        IF ConfirmRequired THEN BEGIN
          IF CONFIRM(
            Text006, FALSE, ReservEntry.TABLECAPTION, ItemChargeAssgntSales.TABLECAPTION, Text008)
          THEN
            RestoreDocument := TRUE;
        END ELSE
          IF CONFIRM(
            Text002,TRUE,SalesHeaderArchive."Document Type",
            SalesHeaderArchive."No.",SalesHeaderArchive."Version No.")
          THEN
            RestoreDocument := TRUE;
        IF RestoreDocument THEN BEGIN
          SalesCommentLine.RESET;
          SalesCommentLine.SETRANGE("Document Type",SalesHeaderArchive."Document Type");
          SalesCommentLine.SETRANGE("No.",SalesHeaderArchive."No.");
          IF SalesCommentLine.FIND('-') THEN
            REPEAT
              TmpSalesCommentLine.INIT;
              TmpSalesCommentLine.TRANSFERFIELDS(SalesCommentLine);
              TmpSalesCommentLine.INSERT;
            UNTIL SalesCommentLine.NEXT = 0;
        
          SalesHeader.TESTFIELD("Doc. No. Occurrence",SalesHeaderArchive."Doc. No. Occurrence");
          SalesHeader.DELETE(TRUE);
          SalesHeader.INIT;
        
          SalesHeader.SetHideValidationDialog(TRUE);
          SalesHeader."Document Type" := SalesHeaderArchive."Document Type";
          SalesHeader."No." := SalesHeaderArchive."No.";
          SalesHeader.INSERT(TRUE);
          SalesHeader.TRANSFERFIELDS(SalesHeaderArchive);
          SalesHeader.Status := SalesHeader.Status::Open;
        
          IF SalesHeaderArchive."Sell-to Contact No." <> '' THEN
            SalesHeader.VALIDATE("Sell-to Contact No.", SalesHeaderArchive."Sell-to Contact No.")
          ELSE
            SalesHeader.VALIDATE("Sell-to Customer No.", SalesHeaderArchive."Sell-to Customer No.");
          IF SalesHeaderArchive."Bill-to Contact No." <> '' THEN
            SalesHeader.VALIDATE("Bill-to Contact No.", SalesHeaderArchive."Bill-to Contact No.")
          ELSE
            SalesHeader.VALIDATE("Bill-to Customer No.", SalesHeaderArchive."Bill-to Customer No.");
          SalesHeader.VALIDATE("Salesperson Code", SalesHeaderArchive."Salesperson Code");
          SalesHeader.VALIDATE("Payment Terms Code", SalesHeaderArchive."Payment Terms Code");
          SalesHeader.VALIDATE("Payment Discount %", SalesHeaderArchive."Payment Discount %");
          SalesHeader.MODIFY(TRUE);
        
          IF TmpSalesCommentLine.FIND('-') THEN
            REPEAT
              SalesCommentLine.INIT;
              SalesCommentLine.TRANSFERFIELDS(TmpSalesCommentLine);
              SalesCommentLine.INSERT;
            UNTIL TmpSalesCommentLine.NEXT = 0;
        
          SalesCommentLine.SETRANGE("Document Type",SalesHeader."Document Type");
          SalesCommentLine.SETRANGE("No.",SalesHeader."No.");
          IF SalesCommentLine.FIND('+') THEN
            NextLine := SalesCommentLine."Line No.";
          NextLine += 10000;
          SalesCommentLine.INIT;
          SalesCommentLine."Document Type" := SalesHeader."Document Type";
          SalesCommentLine."No." := SalesHeader."No.";
          SalesCommentLine."Line No." := NextLine;
          SalesCommentLine.Date := WORKDATE;
          SalesCommentLine.Comment := STRSUBSTNO(Text004,FORMAT(SalesHeaderArchive."Version No."));
          SalesCommentLine.INSERT;
        
          SalesLineArchive.SETRANGE("Document Type",SalesHeaderArchive."Document Type");
          SalesLineArchive.SETRANGE("Document No.",SalesHeaderArchive."No.");
          SalesLineArchive.SETRANGE("Doc. No. Occurrence",SalesHeaderArchive."Doc. No. Occurrence");
          SalesLineArchive.SETRANGE("Version No.",SalesHeaderArchive."Version No.");
          IF SalesLineArchive.FIND('-') THEN BEGIN
            REPEAT
              WITH SalesLine DO BEGIN
                INIT;
                TRANSFERFIELDS(SalesLineArchive);
                INSERT(TRUE);
                IF Type <> Type::" " THEN BEGIN
                  VALIDATE("No.");
                  IF SalesLineArchive."Variant Code" <> '' THEN
                    VALIDATE("Variant Code", SalesLineArchive."Variant Code");
                  IF Quantity <> 0 THEN
                    VALIDATE(Quantity, SalesLineArchive.Quantity);
                  VALIDATE("Unit Price", SalesLineArchive."Unit Price");
                  VALIDATE("Line Discount %", SalesLineArchive."Line Discount %");
                  IF SalesLineArchive."Inv. Discount Amount" <> 0 THEN
                    VALIDATE("Inv. Discount Amount", SalesLineArchive."Inv. Discount Amount");
                  IF Amount <> SalesLineArchive.Amount THEN
                    VALIDATE(Amount, SalesLineArchive.Amount);
                  VALIDATE(Description, SalesLineArchive.Description);
                END;
                MODIFY(TRUE);
              END
            UNTIL SalesLineArchive.NEXT = 0;
          END;
          SalesHeader.Status := SalesHeader.Status::Released;
          ReleaseSalesDoc.Reopen(SalesHeader);
          MESSAGE(Text003,SalesHeader."Document Type",SalesHeader."No.");
        END;
        */

    end;

    procedure GetNextOccurrenceNo(TableId: Integer; DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocNo: Code[20]): Integer
    var
        SalesHeaderArchive: Record "Sales Header Archive";
        PurchHeaderArchive: Record "Purchase Header Archive";
    begin
        CASE TableId OF
            DATABASE::"Sales Header":
                BEGIN
                    /*
                    SalesHeaderArchive.LOCKTABLE;
                    SalesHeaderArchive.SETRANGE("Document Type",DocType);
                    SalesHeaderArchive.SETRANGE("No.",DocNo);
                    IF SalesHeaderArchive.FIND('+') THEN
                      EXIT(SalesHeaderArchive."Doc. No. Occurrence" + 1)
                    ELSE
                      EXIT(1);
                    */
                END;
            DATABASE::"Purchase Header":
                BEGIN
                    PurchHeaderArchive.LOCKTABLE;
                    PurchHeaderArchive.SETRANGE("Document Type", DocType);
                    PurchHeaderArchive.SETRANGE("No.", DocNo);
                    IF PurchHeaderArchive.FIND('+') THEN
                        EXIT(PurchHeaderArchive."Doc. No. Occurrence" + 1)
                    ELSE
                        EXIT(1);
                END;
        END;

    end;

    procedure GetNextVersionNo(TableId: Integer; DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocNo: Code[20]; DocNoOccurrence: Integer): Integer
    var
        SalesHeaderArchive: Record "Sales Header Archive";
        PurchHeaderArchive: Record "Purchase Header Archive";
    begin
        CASE TableId OF
            DATABASE::"Sales Header":
                BEGIN
                    /*
                      SalesHeaderArchive.LOCKTABLE;
                      SalesHeaderArchive.SETRANGE("Document Type",DocType);
                      SalesHeaderArchive.SETRANGE("No.",DocNo);
                      SalesHeaderArchive.SETRANGE("Doc. No. Occurrence",DocNoOccurrence);
                      IF SalesHeaderArchive.FIND('+') THEN
                        EXIT(SalesHeaderArchive."Version No." + 1)
                      ELSE
                        EXIT(1);
                    */
                END;
            DATABASE::"Purchase Header":
                BEGIN
                    PurchHeaderArchive.LOCKTABLE;
                    PurchHeaderArchive.SETRANGE("Document Type", DocType);
                    PurchHeaderArchive.SETRANGE("No.", DocNo);
                    PurchHeaderArchive.SETRANGE("Doc. No. Occurrence", DocNoOccurrence);
                    IF PurchHeaderArchive.FIND('+') THEN
                        EXIT(PurchHeaderArchive."Version No." + 1)
                    ELSE
                        EXIT(1);
                END;
        END;

    end;

    procedure DocArchiveGranule(): Boolean
    var
        SalesHeaderArchive: Record "Sales Header Archive";
    begin
        /*
        EXIT(SalesHeaderArchive.WRITEPERMISSION);
        */
        EXIT(TRUE);//GKG

    end;

    procedure StoreDocDim(TableId: Integer; DocType: Option; DocNo: Code[20]; LineNo: Integer; DocNoOccurrence: Integer; VersionNo: Integer)
    var
    //DocDimArchive: Record 97764;
    begin
        // ALLE MM Code Commented
        /*
        DocDim.SETRANGE("Table ID",TableId);
        DocDim.SETRANGE("Document Type",DocType);
        DocDim.SETRANGE("Document No.",DocNo);
        DocDim.SETRANGE("Line No.",LineNo);
        IF DocDim.FIND('-') THEN
          REPEAT
            DocDimArchive.INIT;
            DocDimArchive.TRANSFERFIELDS(DocDim);
            DocDimArchive."Version No." := VersionNo;
            DocDimArchive."Doc. No. Occurrence" := DocNoOccurrence;
            DocDimArchive.INSERT;
          UNTIL DocDim.NEXT = 0;
          */
        // ALLE MM Code Commented

    end;

    procedure GetNextVersionNoForTerms(DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocNo: Code[20]; TrmType: Option ,"Sales Tax Comments","Excise Duty Comments","Terms of Payments","Service Tax","Transit Insurance","Inspection Remarks","Packaging & Forwarding","Price Basis","Freight Terms","DD Comm/Bank Charges","Warranty/Guarantee Terms","Entry Tax/Octroi Terms","Installation Terms","Service Tax-Installation"; LineNo: Integer): Integer
    var
        TermArchived: Record "Terms Archived";
    begin
        //NDALLE240108
        TermArchived.LOCKTABLE;
        TermArchived.SETRANGE("Document Type", DocType);
        TermArchived.SETRANGE("Document No.", DocNo);
        TermArchived.SETRANGE("Term Type", TrmType);
        TermArchived.SETRANGE("Line No.", LineNo);
        IF TermArchived.FIND('+') THEN
            EXIT(TermArchived."Version No." + 1)
        ELSE
            EXIT(1);
        //NDALLE240108
    end;

    procedure StoreJob(var Job: Record Job)
    var
        JobArchive: Record "EPC Job Archive";
    begin
        // AIR0013 290311 BEGIN
        JobArchive.INIT;
        JobArchive.TRANSFERFIELDS(Job);
        JobArchive."Archived By" := USERID;
        JobArchive."Date Archived" := WORKDATE;
        JobArchive."Time Archived" := TIME;
        VersionNo := GetNextVersionNoForJob(Job."No.");
        JobArchive."Version No." := VersionNo;
        JobArchive.INSERT;
        StoreJobTask(Job);
        StoreJobPlanning(Job);
        // AIR0013 290311 END
    end;

    procedure GetNextVersionNoForJob(DocNo: Code[20]): Integer
    var
        JobArchive: Record "EPC Job Archive";
    begin
        // AIR0013 290311 BEGIN
        JobArchive.LOCKTABLE;
        JobArchive.SETRANGE("No.", DocNo);
        IF JobArchive.FINDLAST THEN
            EXIT(JobArchive."Version No." + 1)
        ELSE
            EXIT(1);
        // AIR0013 290311 END
    end;

    procedure StoreJobTask(Job: Record Job)
    var
        JobTaskArchive: Record "EPC Job Task Archive";
        JobTask: Record "Job Task";
    begin
        // AIR0013 290311 BEGIN
        JobTask.RESET;
        JobTask.SETRANGE(JobTask."Job No.", Job."No.");
        IF JobTask.FINDSET THEN
            REPEAT
                JobTaskArchive.INIT;
                JobTaskArchive.TRANSFERFIELDS(JobTask);
                JobTaskArchive."Archived By" := USERID;
                JobTaskArchive."Date Archived" := WORKDATE;
                JobTaskArchive."Time Archived" := TIME;
                JobTaskArchive."Version No." := VersionNo;
                JobTaskArchive.INSERT;
            UNTIL JobTask.NEXT = 0;
        // AIR0013 290311 END
    end;

    procedure StoreJobPlanning(Job: Record Job)
    var
        JobPlanningLine1: Record "Job Planning Line";
    begin
        /*/ AIR0013 290311 BEGIN
        JobPlanningLine1.RESET;
        JobPlanningLine1.SETRANGE("Job No.",Job."No.");
        IF JobPlanningLine1.FINDSET THEN
          REPEAT
            JobPlanningArchive.INIT;
            JobPlanningArchive.TRANSFERFIELDS(JobPlanningLine1);
            JobPlanningArchive."Archived By" := USERID;
            JobPlanningArchive."Date Archived" := WORKDATE;
            JobPlanningArchive."Time Archived" := TIME;
            JobPlanningArchive."Version No." := VersionNo;
            JobPlanningArchive.INSERT;
          UNTIL JobPlanningLine1.NEXT = 0;
        // AIR0013 290311 END
         */

    end;
}

