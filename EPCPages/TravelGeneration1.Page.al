page 97971 "Travel Generation 1"
{
    // BBG1.00 120813 Added code for check Travel entry already exists without Reversal.
    // 
    // BBG1.9 150114 Added code for update Top Person

    PageType = Card;
    SourceTable = "Travel Header";
    SourceTableView = WHERE("Sent for Approval" = FILTER(false));
    ApplicationArea = All;
    UsageCategory = Documents;
    PromotedActionCategories = 'New,Approve,Report,Request Approval,Navigate,Release,Posting,Prepare,Invoice';
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Document No."; Rec."Document No.")
                {
                }
                field("End Date"; Rec."End Date")
                {
                    Caption = 'Till Date';

                    trigger OnValidate()
                    begin
                        Rec."TA Month" := DATE2DMY(Rec."End Date", 2);
                        Rec.Year := DATE2DMY(Rec."End Date", 3);
                    end;
                }
                field("Region/Rank Code"; Rec."Region/Rank Code")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("Team Lead"; Rec."Team Lead")
                {
                    Caption = 'Associate';

                    trigger OnValidate()
                    begin
                        CustNo := '';

                        /*
                        ChainMgt.InitChain;
                        ChainMgt.ChainFromToUp("Team Lead",TODAY,FALSE);
                        ChainMgt.UpdateChainRank(TODAY);
                        ChainMgt.ReturnChain(Chain);
                        Chain.SETCURRENTKEY("Rank Code");
                        Chain.ASCENDING(FALSE);
                        Integer.SETRANGE(Integer.Number,1,Chain.COUNT);
                        IF Integer.FINDSET THEN
                         REPEAT
                            IF Integer.Number = 1 THEN
                              Chain.FIND('-')
                            ELSE
                              Chain.FINDFIRST;
                         UNTIL Integer.NEXT = 0;
                          IF Vend.GET(Chain."No.") THEN
                            CustNo := Chain."No.";
                        "Top Person" := CustNo;
                        */

                        //BBG1.9 150114
                        Rec.TESTFIELD("End Date");
                        AssHierApp.RESET;
                        AssHierApp.SETRANGE("Introducer Code", Rec."Team Lead");
                        AssHierApp.SETRANGE("Posting Date", 0D, Rec."End Date");
                        AssHierApp.SETFILTER("Parent Code", '<>%1', '');
                        IF AssHierApp.FINDLAST THEN BEGIN
                            Rec."Top Person" := AssHierApp."Associate Code";
                        END ELSE
                            Rec."Top Person" := Rec."Team Lead";
                        //BBG1.9 150114

                    end;
                }
                field("ARM TA Code"; Rec."ARM TA Code")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Vendor_RankCode: Code[10];
                        Vendor: Record Vendor;
                    begin
                        Rec.TESTFIELD("End Date");
                        //IF Type = Type::Team THEN BEGIN

                        Vendor.RESET;
                        IF Vendor.GET(Rec."Top Person") THEN BEGIN

                            TravelSetupline.RESET;
                            TravelSetupline.SETRANGE("Associate Code", Rec."Top Person");
                            TravelSetupline.SETRANGE("Effective Date", Rec."Start Date", Rec."End Date");
                            //TravelSetupline.SETRANGE("Region/Rank Code", Rec."Region/Rank Code");  //Code commented 01072025
                            TravelSetupline.SETRANGE("New Region / Rank Code", Rec."Region/Rank Code");  //Code added 01072025
                            TravelSetupline.SETFILTER("TA Code", '<>%1', '');
                            IF TravelSetupline.FINDFIRST THEN
                                IF PAGE.RUNMODAL(Page::"TA SEtup Line list", TravelSetupline) = ACTION::LookupOK THEN BEGIN
                                    Rec."ARM TA Code" := TravelSetupline."TA Code";
                                    Rec."Project Rate" := TravelSetupline.Rate;
                                    Rec."Start Date" := TravelSetupline."Effective Date";
                                    IF TravelSetupline."End Date" <> 0D THEN
                                        Rec."End Date" := TravelSetupline."End Date";
                                    IF TravelSetupline."End Date" <> 0D THEN BEGIN
                                        Rec."TA Month" := DATE2DMY(TravelSetupline."End Date", 2);
                                        Rec.Year := DATE2DMY(TravelSetupline."End Date", 3);
                                    END;
                                    Rec.MODIFY;
                                END;
                            // END; Code commented 01072025
                        END;


                        /*
                    END;
                     ELSE BEGIN
                      TravelSetupline.RESET;
                      TravelSetupline.SETRANGE("Associate Code","Team Lead");
                      TravelSetupline.SETRANGE("Effective Date","Start Date","End Date");
                      TravelSetupline.SETRANGE("Region/Rank Code","Region/Rank Code");
                      TravelSetupline.SETFILTER("TA Code",'<>%1','');
                      IF TravelSetupline.FINDFIRST THEN
                        IF PAGE.RUNMODAL(50052,TravelSetupline) = ACTION::LookupOK THEN BEGIN
                          "ARM TA Code" := TravelSetupline."TA Code";
                          "Project Rate" := TravelSetupline.Rate;
                          "Start Date" := TravelSetupline."Effective Date";
                          IF TravelSetupline."End Date" <> 0D THEN
                            "End Date" := TravelSetupline."End Date";
                          IF  TravelSetupline."End Date" <> 0D THEN BEGIN
                            "TA Month" := DATE2DMY(TravelSetupline."End Date",2);
                            Year := DATE2DMY(TravelSetupline."End Date",3);
                          END;
                          MODIFY;
                        END;
                    END;
                    */

                    end;
                }
                field("Start Date"; Rec."Start Date")
                {
                    Editable = false;
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("Top Person"; Rec."Top Person")
                {
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        BranchCodeOnAfterValidate;
                    end;
                }
                field("TA Month"; Rec."TA Month")
                {
                    Caption = 'Month';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        IF Rec.Year > 0 THEN
                            CalculateDate;
                    end;
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    Visible = false;
                }
                field(Year; Rec.Year)
                {
                    Caption = 'Year';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        CalculateDate;
                    end;
                }
                field("Receipt Cutoff Date"; Rec."Receipt Cutoff Date")
                {
                }
                field("Total Saleable Area"; Rec."Total Saleable Area")
                {
                }
                field("Total Assigned Amount"; Rec."Total Assigned Amount")
                {
                }
                field("Total Travell Amount"; Rec."Total Travell Amount")
                {
                }
                field("Project Rate"; Rec."Project Rate")
                {
                    Caption = 'Gross TA Rate';
                    Editable = false;
                }
                field("Project Filter"; Rec."Project Filter")
                {
                    Editable = false;
                    Visible = false;
                }
                field(ProjectFilters; ProjectFilter)
                {
                    Caption = 'Project Code';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        GLedgerSEtup.GET;
                        EXIT(PAGELookUpDimFilter(GLedgerSEtup."Global Dimension 1 Code", Text));
                    end;

                    trigger OnValidate()
                    begin
                        ProjectFilterOnAfterValidate;
                    end;
                }
            }
            part(SubformTA; "Travel Payment Details")
            {
                SubPageLink = "Document No." = FIELD("Document No.");
                SubPageView = WHERE(Post = FILTER(false),
                                    "Sent for Approval" = FILTER(false));
            }
            part("2"; "Travel Sent for Approval")
            {
                SubPageLink = "Document No." = FIELD("Document No.");
                SubPageView = WHERE("Sent for Approval" = FILTER(false));
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Calculate Eligibility")
            {
                Caption = '&Approval';
                action("Sent for Approval")
                {
                    Caption = 'Sent for Approval';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        // BBG1.01 231012 START

                        Rec.CALCFIELDS("Total Assigned Amount");
                        Rec.CALCFIELDS("Total Travell Amount");
                        IF Rec."Total Assigned Amount" <> Rec."Total Travell Amount" THEN
                            ERROR('Total assigend amount is not match with Total Travell Amount');

                        IF (Rec."Total Assigned Amount" = 0) OR (Rec."Total Travell Amount" = 0) THEN
                            ERROR('Total assigend amount OR Total Travell Amount can not be less or Zero ');


                        IF NOT CONFIRM(Text50003, FALSE) THEN
                            EXIT;

                        //IF "Project Filter" = '' THEN
                        //  ERROR(Text50002);


                        APPTADetails.RESET;
                        APPTADetails.SETRANGE("Document No.", Rec."Document No.");
                        APPTADetails.SETRANGE(Select, FALSE);  //ALLEDK 190113
                        IF APPTADetails.FINDFIRST THEN
                            REPEAT
                                ConfOrder.RESET;
                                ConfOrder.SETRANGE("No.", APPTADetails."Application No.");
                                IF ConfOrder.FINDFIRST THEN BEGIN
                                    ConfOrder."Travel Generate" := FALSE;
                                    ConfOrder.MODIFY;
                                END;
                            UNTIL APPTADetails.NEXT = 0;



                        TravelPaymentEntry.RESET;
                        TravelPaymentEntry.SETRANGE("Document No.", Rec."Document No.");
                        TravelPaymentEntry.SETRANGE(Approved, FALSE);
                        IF TravelPaymentEntry.FINDSET THEN
                            REPEAT
                                //    TravelPaymentEntry.TESTFIELD("Amount to Pay");
                                TravelPaymentEntry.VALIDATE("Sent for Approval", TRUE);
                                TravelPaymentEntry.VALIDATE(Status, TravelPaymentEntry.Status::Normal);
                                TravelPaymentEntry.MODIFY;
                            UNTIL TravelPaymentEntry.NEXT = 0;

                        APPTADetails.RESET;
                        APPTADetails.SETRANGE("Document No.", Rec."Document No.");
                        //APPTADetails.SETRANGE(Select,TRUE);
                        IF APPTADetails.FINDFIRST THEN
                            REPEAT
                                APPTADetails."Sent for Approval" := TRUE;
                                APPTADetails.MODIFY;
                            UNTIL APPTADetails.NEXT = 0;

                        Rec."Sent for Approval" := TRUE;
                        Rec.MODIFY;


                        MESSAGE(Text50001);
                    end;
                }
            }
            group("Calculate Eligibility1")
            {
                Caption = 'F&unction';
                action("Calculate &Eligibility")
                {
                    Caption = 'Calculate &Eligibility';
                    Image = CalculateHierarchy;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        //ALLECK 060313 START
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        Memberof.RESET;
                        Memberof.SETRANGE(Memberof."User Name", USERID);
                        Memberof.SETRANGE(Memberof."Role ID", 'A_TAGENERATION');
                        IF NOT Memberof.FINDFIRST THEN
                            ERROR('You do not have permission of role :A_TAGENERATION');
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        //ALLECK 060313 End

                        Rec.TESTFIELD("Receipt Cutoff Date");

                        // BBG1.01 261012 START
                        //IF ProjectFilter = '' THEN
                        //  ERROR('Please first define the Project Filter');
                        Rec.TESTFIELD("ARM TA Code");
                        Rec.TESTFIELD("Project Rate");
                        Rec.TESTFIELD("End Date");
                        IF NOT CONFIRM(Text50000, FALSE) THEN
                            EXIT;

                        IF TravelHeader.GET(Rec."Document No.") THEN BEGIN
                            CalculateDate;
                            IF Rec.Type = Rec.Type::Team THEN BEGIN
                                TravelSetupline.RESET;
                                TravelSetupline.SETRANGE("TA Code", Rec."ARM TA Code");
                                IF TravelSetupline.FINDSET THEN
                                    REPEAT
                                        CLEAR(GenerateTAEntry);
                                        GenerateTAEntry.InitializeValues(TravelHeader."Team Lead", Rec."Start Date", Rec."End Date"
                                        , TravelSetupline."Project Code", TravelHeader."Document No.", Rec."TA Month", Rec.Year, Rec."Region/Rank Code");
                                        GenerateTAEntry.RUNMODAL;
                                    //        ,ProjectFilter,TravelHeader."Document No.",MonthNo,Year);
                                    UNTIL TravelSetupline.NEXT = 0;
                            END ELSE BEGIN
                                InsertTPEntry;
                            END;
                            TravelPaymentDetails.RESET;
                            TravelPaymentDetails.SETRANGE("Document No.", Rec."Document No.");
                            TravelPaymentDetails.SETFILTER("Associate Code", '<>%1', '');
                            IF TravelPaymentDetails.FINDFIRST THEN BEGIN
                                CLEAR(AssociatTAHierarchy);
                                AssociatTAHierarchy.InitializeValues(Rec."Team Lead", StartDate, Enddate, Rec."Project Code", Rec."Document No.", Rec."TA Month", Rec.Year
                                                                     , Rec."Region/Rank Code");
                                AssociatTAHierarchy.RUNMODAL;
                            END;
                        END;
                        MESSAGE('Process Complete');
                    end;
                }
                action("Select All")
                {
                    Caption = 'Select All';
                    Image = SelectEntries;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        RecTPaymentDetails.RESET;
                        RecTPaymentDetails.SETRANGE("Document No.", Rec."Document No.");
                        IF RecTPaymentDetails.FINDSET THEN
                            REPEAT
                                RecTPaymentDetails.VALIDATE(Select, TRUE);
                                RecTPaymentDetails.MODIFY;
                            UNTIL RecTPaymentDetails.NEXT = 0;
                    end;
                }
                action("UnSelect All")
                {
                    Caption = 'UnSelect All';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        RecTPaymentDetails.RESET;
                        RecTPaymentDetails.SETRANGE("Document No.", Rec."Document No.");
                        IF RecTPaymentDetails.FINDSET THEN
                            REPEAT
                                RecTPaymentDetails.VALIDATE(Select, FALSE);
                                RecTPaymentDetails.MODIFY;
                            UNTIL RecTPaymentDetails.NEXT = 0;
                    end;
                }
                action(Refresh)
                {
                    Caption = 'Refresh';
                    Image = Refresh;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    var
                        TravelPayEntry_1: Record "Travel Payment Entry";
                    begin

                        Rec.CALCFIELDS("Total Saleable Area");
                        TravelPaymentEntry1.RESET;
                        TravelPaymentEntry1.SETRANGE("Document No.", Rec."Document No.");
                        TravelPaymentEntry1.SETFILTER("TA Rate", '<>%1', 0);
                        IF TravelPaymentEntry1.FINDSET THEN
                            REPEAT
                                TravelPayEntry_1.RESET;
                                TravelPayEntry_1.SETRANGE("Document No.", Rec."Document No.");
                                TravelPayEntry_1.SETRANGE("Sub Associate Code", TravelPaymentEntry1."Sub Associate Code");
                                IF TravelPayEntry_1.FINDSET THEN
                                    REPEAT
                                        TravelPayEntry_1."TA Rate" := TravelPaymentEntry1."TA Rate";
                                        TravelPayEntry_1."Amount to Pay" := TravelPaymentEntry1."TA Rate" * TravelPayEntry_1."Total Area";
                                        TravelPayEntry_1.MODIFY;
                                    UNTIL TravelPayEntry_1.NEXT = 0;
                            UNTIL TravelPaymentEntry1.NEXT = 0;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        BBGOnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        BBGOnAfterGetCurrRecord;
    end;

    var
        Text001: Label 'Do you want to Insert the Lines?';
        Text50000: Label 'Do you want to generate lines?';
        Text50001: Label 'The Document have been sent for approval.';
        Text50003: Label 'Do you want send the Document for approval?';
        Text50002: Label 'There is nothing to send for approval.';
        //"GenerateTAEntry old": Report 50067;
        GenerateTAEntry: Report "Travel Generator New";
        AssociatTAHierarchy: Report "Generate Travel hierarchy";
        TravelPaymentEntry: Record "Travel Payment Entry";
        ChainMgt: Codeunit "Unit Post";
        Chain: Record Vendor temporary;
        "Integer": Record Integer;
        CustNo: Code[20];
        TASetup: Record "Travel Setup Header";
        Vend: Record Vendor;
        APPTADetails: Record "Travel Payment Details";
        TravelPaymentDetails: Record "Travel Payment Details";
        MonthNo: Integer;
        StartDate: Date;
        Enddate: Date;
        TravelHeader: Record "Travel Header";
        RecTPaymentDetails: Record "Travel Payment Details";
        ConfOrder: Record "Confirmed Order";
        ExistTAEntryDet: Record "Travel Payment Details";
        SNo: Integer;
        APPPaymentEntry: Record "Application Payment Entry";
        APPPaymentEntry1: Record "Application Payment Entry";
        UnitSetup: Record "Unit Setup";
        Amt: Decimal;
        "Area": Decimal;
        TravelPaymentDet: Record "Travel Payment Details";
        TravelPaymentEntry1: Record "Travel Payment Entry";
        ProjectFilter: Text[200];
        ResponCenter: Record "Responsibility Center 1";
        GLedgerSEtup: Record "General Ledger Setup";
        TAsetupLine: Record "Travel Setup Line New";
        RespCenter: Record "Responsibility Center 1";
        OtherAmt: Decimal;
        TravelPaymentDet1: Record "Travel Payment Details";
        TravelSetupline: Record "Travel Setup Line New";
        TSetupLine: Record "Travel Setup Line New";
        AssHierApp: Record "Associate Hierarcy with App.";
        Memberof: Record "Access Control";


    procedure CalculateDate()
    begin
        /*
        CASE Month OF
           0: MonthNo := 1;
           1: MonthNo := 2;
           2: MonthNo := 3;
           3: MonthNo := 4;
           4: MonthNo := 5;
           5: MonthNo := 6;
           6: MonthNo := 7;
           7: MonthNo := 8;
           8: MonthNo := 9;
           9: MonthNo := 10;
           10: MonthNo := 11;
           11: MonthNo := 12;
        END;
        
        
        IF (MonthNo = 1) OR (MonthNo = 3) OR (MonthNo = 5) OR (MonthNo = 7) OR (MonthNo = 8) OR (MonthNo = 10) OR (MonthNo = 12) THEN
        BEGIN
          StartDate := DMY2DATE(1,MonthNo,Year);
          Enddate := DMY2DATE(31,MonthNo,Year);
        END;
        
        IF  (MonthNo = 4) OR (MonthNo = 6) OR (MonthNo = 9) OR (MonthNo = 11) THEN BEGIN
          StartDate := DMY2DATE(1,MonthNo,Year);
          Enddate := DMY2DATE(30,MonthNo,Year);
        END;
        
        IF MonthNo = 2 THEN BEGIN
          IF (Year MOD 2 = 0 ) THEN BEGIN
            StartDate := DMY2DATE(1,MonthNo,Year);
            Enddate := DMY2DATE(29,MonthNo,Year);
          END ELSE BEGIN
            StartDate := DMY2DATE(1,MonthNo,Year);
            Enddate := DMY2DATE(28,MonthNo,Year);
          END;
        END;
        
        "Start Date" := StartDate;
        "End Date" := Enddate;
        MODIFY;
         */

    end;


    procedure InsertTPEntry()
    begin
        SNo := 0;
        UnitSetup.GET;
        Rec.TESTFIELD("End Date");

        TSetupLine.RESET;
        TSetupLine.SETRANGE("TA Code", Rec."ARM TA Code");
        IF TSetupLine.FINDFIRST THEN
            REPEAT
                ConfOrder.RESET;
                ConfOrder.SETCURRENTKEY("Introducer Code", "Posting Date");
                ConfOrder.SETRANGE("Introducer Code", Rec."Team Lead");
                ConfOrder.SETRANGE("Posting Date", Rec."Start Date", Rec."End Date");
                ConfOrder.SETFILTER("Shortcut Dimension 1 Code", TSetupLine."Project Code");
                ConfOrder.SETRANGE("Travel Generate", FALSE);
                ConfOrder.SETRANGE(ConfOrder.Type, ConfOrder.Type::Normal);  //ALLEDK210213
                ConfOrder.SETFILTER(Status, '%1|%2', ConfOrder.Status::Open, ConfOrder.Status::Registered);  //ALLEDK 220713
                ConfOrder.SetRange("Travel applicable", True);  //code Added 01072025
                IF ConfOrder.FINDSET THEN BEGIN
                    REPEAT
                        Amt := 0;
                        OtherAmt := 0;
                        APPPaymentEntry1.RESET;
                        APPPaymentEntry1.SETCURRENTKEY("Document No.", "Shortcut Dimension 1 Code", "Posting date");
                        APPPaymentEntry1.SETRANGE("Document No.", ConfOrder."No.");
                        APPPaymentEntry1.SETRANGE(Posted, TRUE);
                        APPPaymentEntry1.SETRANGE("Posting date", 0D, Rec."Receipt Cutoff Date");
                        APPPaymentEntry1.SETRANGE("Cheque Status", APPPaymentEntry1."Cheque Status"::Cleared);
                        IF APPPaymentEntry1.FINDFIRST THEN BEGIN
                            REPEAT
                                IF (APPPaymentEntry1."Payment Mode" = APPPaymentEntry1."Payment Mode"::Bank) AND
                                 (APPPaymentEntry1."Cheque Status" = APPPaymentEntry1."Cheque Status"::Cleared) THEN BEGIN
                                    IF (APPPaymentEntry1."Chq. Cl / Bounce Dt." <= CALCDATE(UnitSetup."No. of Cheque Buffer Days",
                                    APPPaymentEntry1."Posting date")) THEN BEGIN
                                        Amt := Amt + APPPaymentEntry1.Amount;
                                    END;
                                END ELSE
                                    Amt := Amt + APPPaymentEntry1.Amount;
                            UNTIL APPPaymentEntry1.NEXT = 0;
                            IF (Amt >= ConfOrder."Min. Allotment Amount") THEN BEGIN

                                CLEAR(TravelPaymentDet1);  //BBG1.00 120813
                                TravelPaymentDet1.RESET;
                                TravelPaymentDet1.SETRANGE("Application No.", ConfOrder."No.");
                                TravelPaymentDet1.SETRANGE(Reverse, FALSE);
                                IF TravelPaymentDet1.FINDFIRST THEN BEGIN
                                END ELSE BEGIN                                //BBG1.00 120813
                                    TravelPaymentDet.INIT;
                                    TravelPaymentDet."Document No." := Rec."Document No.";
                                    TravelPaymentDet."Line no." := SNo + 10000;
                                    TravelPaymentDet.VALIDATE("Project Code", ConfOrder."Shortcut Dimension 1 Code");
                                    TravelPaymentDet.VALIDATE("Associate Code", Rec."Team Lead");
                                    TravelPaymentDet.VALIDATE("Sub Associate Code", ConfOrder."Introducer Code");
                                    TravelPaymentDet."Application No." := ConfOrder."No.";
                                    TravelPaymentDet."Saleable Area" := ConfOrder."Saleable Area";
                                    TravelPaymentDet."Creation Date" := WORKDATE;
                                    TravelPaymentDet.Month := Rec."TA Month";//MonthNo;
                                    TravelPaymentDet."ARM TA Code" := Rec."ARM TA Code"; //BBG1.2 240114
                                    TravelPaymentDet.Year := Rec.Year;
                                    TravelPaymentDet.INSERT;
                                    SNo := TravelPaymentDet."Line no.";
                                    ConfOrder."Travel Generate" := TRUE;
                                    ConfOrder.MODIFY;
                                END;
                            END;
                        END;
                    UNTIL ConfOrder.NEXT = 0;
                END;
            UNTIL TSetupLine.NEXT = 0;
    end;


    procedure PAGELookUpDimFilter(Dim: Code[20]; var Text: Text[1024]): Boolean
    var
        DimVal: Record "Travel Setup Line New";
        DimValList: Page "Associate Travel Rate List";
    begin
        IF Dim = '' THEN
            EXIT(FALSE);
        DimValList.LOOKUPMODE(TRUE);
        DimVal.SETRANGE("Branch Code", Rec."Branch Code");
        DimVal.SETRANGE(DimVal."Associate Code", Rec."Top Person");
        DimValList.SETTABLEVIEW(DimVal);
        IF DimValList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            DimValList.GETRECORD(DimVal);
            Text := DimValList.GetSelectionFilter;
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE)
    end;

    local procedure BranchCodeOnAfterValidate()
    begin
        Rec.TESTFIELD(Year);
    end;

    local procedure ProjectFilterOnAfterValidate()
    begin
        CurrPage.UPDATE;
        IF ProjectFilter <> '' THEN BEGIN
            Rec."Project Filter" := ProjectFilter;
            TAsetupLine.RESET;
            TAsetupLine.SETRANGE(TAsetupLine."Associate Code", Rec."Top Person");
            TAsetupLine.SETRANGE(TAsetupLine."Effective Date", 0D, Rec."End Date");
            TAsetupLine.SETFILTER(TAsetupLine."Project Code", ProjectFilter);
            IF TAsetupLine.FINDLAST THEN
                Rec."Project Rate" := TAsetupLine.Rate
            ELSE
                Rec."Project Rate" := 0;
        END;
    end;

    local procedure BBGOnAfterGetCurrRecord()
    begin
        xRec := Rec;
        IF xRec."Document No." <> Rec."Document No." THEN
            ProjectFilter := '';
    end;
}

