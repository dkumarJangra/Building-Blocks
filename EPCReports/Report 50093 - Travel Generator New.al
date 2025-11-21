report 50093 "Travel Generator New"
{
    // version Done

    // // BBG1.01 ALLE_NB 261012: Execution of Report through form only.

    ProcessingOnly = true;
    UseRequestPage = false;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Associate Hierarcy with App."; "Associate Hierarcy with App.")
        {
            DataItemTableView = SORTING("Associate Code", "Introducer Code", "Application Code")
                                WHERE("Travel Generated" = CONST(false),
                                      Status = FILTER(Active));
            dataitem("Confirmed Order"; "Confirmed Order")
            {
                DataItemLink = "No." = FIELD("Application Code");
                DataItemTableView = SORTING("No.")
                                    WHERE(Type = FILTER(Normal),
                                          Status = FILTER(Open),
                                          "Travel Generate" = FILTER(false),
                                          "Introducer Code" = FILTER(<> 'IBA9999999'),
                                          "Travel Not Generate" = FILTER(false),
                                          "Application Transfered" = FILTER(false),
                                          "Travel applicable" = FILTER(true));       //Filter added Travel applicable = true 01072025

                trigger OnAfterGetRecord()
                begin
                    //BBG1.00 120813
                    CLEAR(TravelPaymentDet1);
                    TravelPaymentDet1.RESET;
                    TravelPaymentDet1.SETRANGE("Application No.", "No.");
                    TravelPaymentDet1.SETRANGE(Reverse, FALSE);
                    IF TravelPaymentDet1.FINDFIRST THEN BEGIN
                    END ELSE BEGIN
                        InsertTAEntry;
                    END;
                    //InsertTAEntry;

                    //BBG1.00 120813
                end;
            }

            trigger OnPreDataItem()
            begin
                SETRANGE("Posting Date", Stdate, ToDate);
                SETFILTER("Project Code", PCode);
                SETFILTER("Introducer Code", '<>%1', MMCode);
                SETRANGE("Associate Code", MMCode);
                SETRANGE("Region/Rank Code", RegionCode1);
            end;
        }
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

    trigger OnInitReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        WEFDate := TODAY;
    end;

    trigger OnPreReport()
    begin
        // BBG1.01 261012 START
        IF MMCode = '' THEN
            ERROR(Text50003);
        IF PCode = '' THEN
            ERROR(Text50000);
        IF ToDate = 0D THEN
            ERROR(Text50001);
        // BBG1.01 261012 END
        IF DocNo = '' THEN
            ERROR('Enter Document No.');

        IF WEFDate = 0D THEN
            WEFDate := TODAY;
    end;

    var
        CompanyInfo: Record "Company Information";
        Filters: Text[30];
        MMCode: Code[20];
        WEFDate: Date;
        ConfOrder: Record "Confirmed Order";
        Stdate: Date;
        ChainMgt: Codeunit "Unit Post";
        Chain: Record Vendor temporary;
        Chain2: Record Vendor temporary;
        Vendor: Record Vendor;
        Cnt: Integer;
        GetDesc: Codeunit GetDescription;
        Amt: Decimal;
        "Area": Decimal;
        TotalArea: Decimal;
        TravelPaymentDet: Record "Travel Payment Details";
        TravelPaymentdetails: Record "Travel Payment Details";
        TravelPaymentEntry: Record "Travel Payment Entry";
        TravelPaymentEntry1: Record "Travel Payment Entry";
        LineNo: Integer;
        SNo: Integer;
        VendNo: Code[20];
        DocNo: Code[20];
        ProjCode: Code[20];
        ToDate: Date;
        UnitSetup: Record "Unit Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Recordfind: Boolean;
        APPPaymentEntry: Record "Application Payment Entry";
        PCode: Text[200];
        TravelPaymentEntrySheet: Page "Travel Sent for Approval";
        ExistTAEntryDet: Record "Travel Payment Details";
        Month1: Integer;
        Year1: Integer;
        TravelPaymentDet1: Record "Travel Payment Details";
        THeader: Record "Travel Header";
        RegionCode1: Code[10];
        Text50003: Label 'Enter a valid Team Lead.';
        Text50000: Label 'Enter a valid Project Code.';
        Text50001: Label 'Enter a valid date.';
        Text50002: Label 'Document generated successfully.';

    procedure BuildHierarchy(MCode: Code[20])
    var
        Vend: Record Vendor;
        Level: Integer;
    begin
    end;

    procedure InsertTAEntry()
    begin
        SNo := SNo;
        UnitSetup.GET;
        THeader.GET(DocNo);
        Amt := 0;
        APPPaymentEntry.RESET;
        APPPaymentEntry.SETCURRENTKEY("Document No.", "Shortcut Dimension 1 Code", "Posting date");
        APPPaymentEntry.SETRANGE("Document No.", "Confirmed Order"."No.");
        APPPaymentEntry.SETRANGE(Posted, TRUE);
        APPPaymentEntry.SETRANGE("Posting date", 0D, THeader."Receipt Cutoff Date");
        APPPaymentEntry.SETRANGE("Cheque Status", APPPaymentEntry."Cheque Status"::Cleared);
        IF APPPaymentEntry.FINDFIRST THEN BEGIN
            REPEAT
                IF (APPPaymentEntry."Payment Mode" = APPPaymentEntry."Payment Mode"::Bank) AND
                (APPPaymentEntry."Cheque Status" = APPPaymentEntry."Cheque Status"::Cleared)
                THEN BEGIN
                    // IF(APPPaymentEntry."Chq. Cl / Bounce Dt."<=CALCDATE(UnitSetup."No. of Cheque Buffer Days",
                    // APPPaymentEntry."Posting date")) THEN
                    // BEGIN
                    Amt := Amt + APPPaymentEntry.Amount;
                    // END;
                END ELSE
                    Amt := Amt + APPPaymentEntry.Amount;
            UNTIL APPPaymentEntry.NEXT = 0;
            IF Amt >= "Confirmed Order"."Min. Allotment Amount" THEN BEGIN
                Area := "Confirmed Order"."Saleable Area";
                TotalArea := TotalArea + Area;

                TravelPaymentDet.RESET;
                TravelPaymentDet.SETRANGE("Document No.", DocNo);
                IF TravelPaymentDet.FINDLAST THEN
                    SNo := TravelPaymentDet."Line no.";

                TravelPaymentDet.INIT;
                TravelPaymentDet."Document No." := DocNo;
                TravelPaymentDet."Line no." := SNo + 10000;
                TravelPaymentDet.VALIDATE("Project Code", "Confirmed Order"."Shortcut Dimension 1 Code");
                TravelPaymentDet.VALIDATE("Associate Code", MMCode);
                TravelPaymentDet.VALIDATE("Sub Associate Code", "Confirmed Order"."Introducer Code");
                TravelPaymentDet."Application No." := "Confirmed Order"."No.";
                TravelPaymentDet."Posting Date" := "Confirmed Order"."Posting Date";
                TravelPaymentDet."Saleable Area" := Area;
                TravelPaymentDet."Creation Date" := TODAY;
                TravelPaymentDet.Month := Month1;
                TravelPaymentDet.Year := Year1;
                TravelPaymentDet.INSERT;
                SNo := TravelPaymentDet."Line no.";
                "Confirmed Order"."Travel Generate" := TRUE;
                "Confirmed Order".MODIFY;
            END;
        END;
    end;

    procedure InitializeValues(var CustomerNoFilter: Code[20]; var StartDate: Date; var DateFilter: Date; var ProjectCode: Code[20]; var TADocNo: Code[20]; var Month: Integer; var Year: Integer; RegionCode: Code[10])
    begin
        // BBG1.01 261012 START
        MMCode := CustomerNoFilter;
        PCode := ProjectCode;
        Stdate := StartDate;
        ToDate := DateFilter;
        DocNo := TADocNo;
        Month1 := Month;
        Year1 := Year;
        RegionCode1 := RegionCode;
        // BBG1.01 261012 END
    end;
}

