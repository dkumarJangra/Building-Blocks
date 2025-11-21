report 97752 "Gamification Details Batch"
{
    // version gamification_1

    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                UnitSetup.GET;
                UnitSetup.TESTFIELD("Gamification End Date");
                UnitSetup.TESTFIELD("Gamification Start Date");

                UserSetup.RESET;
                IF UserSetup.GET(USERID) THEN BEGIN
                    StartDate := UserSetup."Gamification Start Date";
                    EndDate := UserSetup."Gamification End Date";
                END;

                IF StartDate = 0D THEN
                    StartDate := UnitSetup."Gamification Start Date";
                IF EndDate = 0D THEN
                    EndDate := UnitSetup."Gamification End Date";


                IndividualRequirements;
                IndividualAllotments;
                IndividualCollections;
                IndividualBookings;
                IndividualRegistrations;
                COMMIT;
            end;

            trigger OnPreDataItem()
            begin
                StartDate := 0D;
                EndDate := 0D;
                GamificationDetails.RESET;
                GamificationDetails.SETRANGE(Type, GamificationDetails.Type::Individual);
                GamificationDetails.DELETEALL;
            end;
        }
        dataitem(SUMMARY; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            var
                GamificationDetails: Record "Gamification Details";
                SNo: Integer;
                BatchDetailMaster: Record "Batch Detail Master";
                v_GamificationDetails: Record "Gamification Details";
                v_GamificationDetails_1: Record "Gamification Details";
            begin
                SNo := 0;
                GamificationDetails.RESET;
                GamificationDetails.SETCURRENTKEY("Document Date", Type, "Document Type", "No. of Records", "Allotment Extent", "Allotment Collection");
                GamificationDetails.SETRANGE("Document Date", TODAY);
                GamificationDetails.SETRANGE(Type, GamificationDetails.Type::Individual);
                GamificationDetails.SETRANGE("Document Type", GamificationDetails."Document Type"::Allotment);
                GamificationDetails.ASCENDING(FALSE);
                IF GamificationDetails.FINDSET THEN
                    REPEAT
                        SNo := SNo + 1;
                        IF SNo < 6 THEN BEGIN
                            BatchDetailMaster.RESET;
                            IF BatchDetailMaster.GET(SNo) THEN BEGIN
                                GamificationDetails.Rank := SNo;
                                GamificationDetails.Batch := BatchDetailMaster.Batch;
                                GamificationDetails.Points := BatchDetailMaster.Points;
                                GamificationDetails."Rate per Point" := BatchDetailMaster."Rate Per Point";
                            END;
                            GamificationDetails."Show Records" := TRUE;

                        END ELSE
                            GamificationDetails.Rank := SNo;
                        GamificationDetails.MODIFY;
                    UNTIL (GamificationDetails.NEXT = 0);// OR (SNo = 5);

                SNo := 0;
                GamificationDetails.RESET;
                GamificationDetails.SETCURRENTKEY("Document Date", Type, "Document Type", "No. of Records", Sankalp, Mahasankalp, "Date of Joining");
                GamificationDetails.SETRANGE("Document Date", TODAY);
                GamificationDetails.SETRANGE(Type, GamificationDetails.Type::Individual);
                GamificationDetails.SETRANGE("Document Type", GamificationDetails."Document Type"::Recruitment);
                GamificationDetails.SETFILTER("Associate Code", '<>%1', 'IBA9999999');
                GamificationDetails.ASCENDING(FALSE);
                IF GamificationDetails.FINDSET THEN
                    REPEAT
                        SNo := SNo + 1;
                        IF SNo < 6 THEN BEGIN
                            BatchDetailMaster.RESET;
                            IF BatchDetailMaster.GET(SNo) THEN BEGIN
                                GamificationDetails.Rank := SNo;
                                GamificationDetails.Batch := BatchDetailMaster.Batch;
                                GamificationDetails.Points := BatchDetailMaster.Points;
                                GamificationDetails."Rate per Point" := BatchDetailMaster."Rate Per Point";
                            END;
                            GamificationDetails."Show Records" := TRUE;
                        END ELSE
                            GamificationDetails.Rank := SNo;
                        GamificationDetails.MODIFY;
                    UNTIL (GamificationDetails.NEXT = 0);// OR (SNo = 5);

                SNo := 0;
                GamificationDetails.RESET;
                GamificationDetails.SETCURRENTKEY("Document Date", Type, "Document Type", "No. of Records", "Registration Extent", "Registration Collection");
                GamificationDetails.SETRANGE("Document Date", TODAY);
                GamificationDetails.SETRANGE(Type, GamificationDetails.Type::Individual);
                GamificationDetails.SETRANGE("Document Type", GamificationDetails."Document Type"::Registration);
                GamificationDetails.ASCENDING(FALSE);
                IF GamificationDetails.FINDSET THEN
                    REPEAT
                        SNo := SNo + 1;
                        IF SNo < 6 THEN BEGIN
                            BatchDetailMaster.RESET;
                            IF BatchDetailMaster.GET(SNo) THEN BEGIN
                                GamificationDetails.Rank := SNo;
                                GamificationDetails.Batch := BatchDetailMaster.Batch;
                                GamificationDetails.Points := BatchDetailMaster.Points;
                                GamificationDetails."Rate per Point" := BatchDetailMaster."Rate Per Point";
                            END;
                            GamificationDetails."Show Records" := TRUE;
                        END ELSE
                            GamificationDetails.Rank := SNo;
                        GamificationDetails.MODIFY;
                    UNTIL (GamificationDetails.NEXT = 0);// OR (SNo = 5);

                SNo := 0;
                GamificationDetails.RESET;
                GamificationDetails.SETCURRENTKEY("Document Date", Type, "Document Type", "Total Values", "Latest DOJ of Application");
                GamificationDetails.SETRANGE("Document Date", TODAY);
                GamificationDetails.SETRANGE(Type, GamificationDetails.Type::Individual);
                GamificationDetails.SETRANGE("Document Type", GamificationDetails."Document Type"::Collection);
                GamificationDetails.ASCENDING(FALSE);
                IF GamificationDetails.FINDSET THEN
                    REPEAT
                        SNo := SNo + 1;
                        IF SNo < 6 THEN BEGIN
                            BatchDetailMaster.RESET;
                            IF BatchDetailMaster.GET(SNo) THEN BEGIN
                                GamificationDetails.Rank := SNo;
                                GamificationDetails.Batch := BatchDetailMaster.Batch;
                                GamificationDetails.Points := BatchDetailMaster.Points;
                                GamificationDetails."Rate per Point" := BatchDetailMaster."Rate Per Point";
                            END;
                            GamificationDetails."Show Records" := TRUE;
                        END ELSE
                            GamificationDetails.Rank := SNo;
                        GamificationDetails.MODIFY;
                    UNTIL (GamificationDetails.NEXT = 0);// OR (SNo = 5);



                SNo := 0;
                GamificationDetails.RESET;
                GamificationDetails.SETCURRENTKEY("Document Date", Type, "Document Type", "No. of Records", "Booking Extent", "Booking Allotment", "Booking Collection");
                GamificationDetails.SETRANGE("Document Date", TODAY);
                GamificationDetails.SETRANGE(Type, GamificationDetails.Type::Individual);
                GamificationDetails.SETRANGE("Document Type", GamificationDetails."Document Type"::Booking);
                GamificationDetails.SETFILTER("Associate Code", '<>%1', 'IBA9999999');
                GamificationDetails.ASCENDING(FALSE);
                IF GamificationDetails.FINDSET THEN
                    REPEAT
                        SNo := SNo + 1;
                        IF SNo < 6 THEN BEGIN
                            BatchDetailMaster.RESET;
                            IF BatchDetailMaster.GET(SNo) THEN BEGIN
                                GamificationDetails.Rank := SNo;
                                GamificationDetails.Batch := BatchDetailMaster.Batch;
                                GamificationDetails.Points := BatchDetailMaster.Points;
                                GamificationDetails."Rate per Point" := BatchDetailMaster."Rate Per Point";
                            END;
                            GamificationDetails."Show Records" := TRUE;
                        END ELSE
                            GamificationDetails.Rank := SNo;
                        GamificationDetails.MODIFY;
                    UNTIL (GamificationDetails.NEXT = 0);// OR (SNo = 5);
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

    trigger OnPostReport()
    begin
        MESSAGE('Process Done');
    end;

    var
        GamificationDetails: Record "Gamification Details";
        Vendor: Record Vendor;
        RecVendor: Record Vendor;
        RegionwiseVendor: Record "Region wise Vendor";
        Sankalap: Integer;
        MahaSankalap: Integer;
        UnitSetup: Record "Unit Setup";
        AssociateLoginDetails: Record "Associate Login Details";
        LatestDOJOFAPP: Date;
        AllotmentExtents: Decimal;
        AllotmentCollections: Decimal;
        RegistrationExtents: Decimal;
        RegistrationCollections: Decimal;
        IndividualAllotment: Decimal;
        NoofAllotements: Integer;
        TeamMaster: Record "Team Master";
        TeamNames: Text;
        v_Vendor: Record Vendor;
        UserSetup: Record "User Setup";
        StartDate: Date;
        EndDate: Date;

    local procedure IndividualRequirements()
    var
        IntroducerCode: Code[20];
        NoofRequirements: Integer;
        v_Vendor: Record Vendor;
        RecVend_1: Record Vendor;
    begin
        UnitSetup.GET;
        AssociateLoginDetails.RESET;
        AssociateLoginDetails.SETRANGE(Status, AssociateLoginDetails.Status::Approved);
        AssociateLoginDetails.SETFILTER(Associate_ID, '<>%1', '');
        AssociateLoginDetails.SETRANGE("Creation Date", StartDate, EndDate);
        IF AssociateLoginDetails.FINDSET THEN
            REPEAT
                v_Vendor.RESET;
                IF v_Vendor.GET(AssociateLoginDetails.Associate_ID) THEN BEGIN
                    v_Vendor."BBG Creation Date" := AssociateLoginDetails."Creation Date";
                    v_Vendor.MODIFY;
                END;
            UNTIL AssociateLoginDetails.NEXT = 0;

        IntroducerCode := '';
        Vendor.RESET;
        Vendor.SETCURRENTKEY("BBG Introducer");
        Vendor.SETRANGE("BBG Vendor Category", Vendor."BBG Vendor Category"::"IBA(Associates)");
        Vendor.SETRANGE("BBG Creation Date", StartDate, EndDate);
        Vendor.SETFILTER("BBG Introducer", '<>%1', '');
        Vendor.SETRANGE("BBG Status", Vendor."BBG Status"::Active);
        IF Vendor.FINDSET THEN
            REPEAT
                IF IntroducerCode <> Vendor."BBG Introducer" THEN BEGIN
                    IntroducerCode := Vendor."BBG Introducer";
                    RecVend_1.RESET;
                    IF RecVend_1.GET(Vendor."BBG Introducer") THEN;
                    MahaSankalap := 0;
                    Sankalap := 0;
                    NoofRequirements := 0;
                    RecVendor.RESET;
                    RecVendor.SETCURRENTKEY("BBG Introducer");
                    RecVendor.SETRANGE("BBG Vendor Category", RecVendor."BBG Vendor Category"::"IBA(Associates)");
                    RecVendor.SETRANGE("BBG Creation Date", StartDate, EndDate);
                    RecVendor.SETRANGE("BBG Introducer", Vendor."BBG Introducer");
                    RecVendor.SETRANGE("BBG Status", RecVendor."BBG Status"::Active);
                    IF RecVendor.FINDSET THEN
                        REPEAT
                            NoofRequirements := NoofRequirements + 1;
                            RegionwiseVendor.RESET;
                            RegionwiseVendor.SETRANGE("No.", RecVendor."No.");
                            IF RegionwiseVendor.FINDFIRST THEN
                                IF RegionwiseVendor."Rank Code" > 1 THEN
                                    MahaSankalap := MahaSankalap + 1
                                ELSE
                                    Sankalap := Sankalap + 1;
                        UNTIL RecVendor.NEXT = 0;
                    IF NoofRequirements > 0 THEN BEGIN
                        TeamNames := '';
                        IF TeamMaster.GET(RecVend_1."BBG Team Code") THEN
                            TeamNames := TeamMaster."Team Name";
                        GamificationDetails.INIT;
                        GamificationDetails."Document Date" := TODAY;
                        GamificationDetails.Type := GamificationDetails.Type::Individual;
                        GamificationDetails."Document Type" := GamificationDetails."Document Type"::Recruitment;
                        GamificationDetails."Associate Code" := Vendor."BBG Introducer";
                        v_Vendor.RESET;
                        v_Vendor.GET(Vendor."BBG Introducer");
                        IF v_Vendor."BBG Alternate Name" = '' THEN
                            GamificationDetails."Associate Name" := v_Vendor.Name
                        ELSE
                            GamificationDetails."Associate Name" := v_Vendor."BBG Alternate Name";

                        GamificationDetails."No. of Records" := NoofRequirements;
                        GamificationDetails."Date of Joining" := RecVend_1."BBG Date of Joining";
                        GamificationDetails.Sankalp := Sankalap;
                        GamificationDetails.Mahasankalp := MahaSankalap;
                        GamificationDetails."Start Date" := StartDate;
                        GamificationDetails."End Date" := EndDate;
                        GamificationDetails."Batch Run Time" := TIME;
                        GamificationDetails."Team Name" := TeamNames;
                        GamificationDetails.INSERT;
                    END;
                END;
            UNTIL Vendor.NEXT = 0;

    end;

    local procedure IndividualCollections()
    var
        NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        v_NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        IntroducerCode: Code[20];
        IndividualColls: Decimal;
        NewConfirmedOrder: Record "New Confirmed Order";
        v_NewConfirmedOrder: Record "New Confirmed Order";
        RecVend_1: Record Vendor;
    begin
        IntroducerCode := '';
        LatestDOJOFAPP := 0D;
        NewConfirmedOrder.RESET;
        NewConfirmedOrder.SETCURRENTKEY("Introducer Code");
        NewConfirmedOrder.SETFILTER("Introducer Code", '<>%1', 'IBA9999999');
        NewConfirmedOrder.SETFILTER(Status, '<>%1', NewConfirmedOrder.Status::Registered);
        IF NewConfirmedOrder.FINDSET THEN
            REPEAT
                IF IntroducerCode <> NewConfirmedOrder."Introducer Code" THEN BEGIN
                    IntroducerCode := NewConfirmedOrder."Introducer Code";
                    RecVend_1.RESET;
                    IF RecVend_1.GET(IntroducerCode) THEN;
                    IndividualColls := 0;
                    LatestDOJOFAPP := 0D;
                    v_NewConfirmedOrder.RESET;
                    v_NewConfirmedOrder.SETCURRENTKEY("Introducer Code", "Posting Date");
                    v_NewConfirmedOrder.SETRANGE("Introducer Code", IntroducerCode);
                    v_NewConfirmedOrder.SETFILTER(Status, '<>%1', v_NewConfirmedOrder.Status::Registered);
                    IF v_NewConfirmedOrder.FINDSET THEN BEGIN
                        REPEAT
                            NewApplicationPaymentEntry.RESET;
                            NewApplicationPaymentEntry.SETRANGE("Document No.", v_NewConfirmedOrder."No.");
                            NewApplicationPaymentEntry.SETRANGE("Posting date", StartDate, EndDate);
                            NewApplicationPaymentEntry.SETFILTER("Cheque Status", '%1|%2', NewApplicationPaymentEntry."Cheque Status"::" ", NewApplicationPaymentEntry."Cheque Status"::Cleared);
                            NewApplicationPaymentEntry.SETFILTER("Payment Mode", '<>%1&<>%2', 6, 7);
                            NewApplicationPaymentEntry.SETRANGE(Posted, TRUE);
                            IF NewApplicationPaymentEntry.FINDSET THEN BEGIN
                                REPEAT
                                    IndividualColls := IndividualColls + NewApplicationPaymentEntry.Amount;
                                UNTIL NewApplicationPaymentEntry.NEXT = 0;
                                LatestDOJOFAPP := v_NewConfirmedOrder."Posting Date";
                            END;
                        UNTIL v_NewConfirmedOrder.NEXT = 0;
                        IF IndividualColls > 0 THEN BEGIN
                            TeamNames := '';
                            TeamMaster.RESET;
                            IF TeamMaster.GET(RecVend_1."BBG Team Code") THEN
                                TeamNames := TeamMaster."Team Name";
                            GamificationDetails.RESET;
                            GamificationDetails.INIT;
                            GamificationDetails."Document Date" := TODAY;
                            GamificationDetails.Type := GamificationDetails.Type::Individual;
                            GamificationDetails."Document Type" := GamificationDetails."Document Type"::Collection;
                            GamificationDetails."Associate Code" := IntroducerCode;
                            v_Vendor.RESET;
                            v_Vendor.GET(IntroducerCode);
                            IF v_Vendor."BBG Alternate Name" = '' THEN
                                GamificationDetails."Associate Name" := v_Vendor.Name
                            ELSE
                                GamificationDetails."Associate Name" := v_Vendor."BBG Alternate Name";

                            GamificationDetails."Total Values" := IndividualColls;
                            GamificationDetails."Latest DOJ of Application" := LatestDOJOFAPP;
                            GamificationDetails."Start Date" := StartDate;
                            GamificationDetails."End Date" := EndDate;
                            GamificationDetails."Batch Run Time" := TIME;
                            GamificationDetails."Team Name" := TeamNames;
                            GamificationDetails.INSERT;
                        END;
                    END;
                END;
            UNTIL NewConfirmedOrder.NEXT = 0;
    end;

    local procedure IndividualRegistrations()
    var
        NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        v_NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        IntroducerCode: Code[20];
        NewConfirmedOrder: Record "New Confirmed Order";
        v_NewConfirmedOrder: Record "New Confirmed Order";
        IndividualRegs: Integer;
        PlotRegistrationDetails: Record "Plot Registration Details";
        v_PlotRegistrationDetails: Record "Plot Registration Details";
        RecVend_1: Record Vendor;
    begin
        IntroducerCode := '';

        PlotRegistrationDetails.RESET;
        PlotRegistrationDetails.SETCURRENTKEY("Introducer Code");
        PlotRegistrationDetails.SETFILTER("Introducer Code", '<>%1', 'IBA9999999');
        PlotRegistrationDetails.SETRANGE("Document Date", StartDate, EndDate);
        IF PlotRegistrationDetails.FINDSET THEN
            REPEAT
                IF IntroducerCode <> PlotRegistrationDetails."Introducer Code" THEN BEGIN
                    IntroducerCode := PlotRegistrationDetails."Introducer Code";
                    RecVend_1.RESET;
                    IF RecVend_1.GET(IntroducerCode) THEN;
                    IndividualRegs := 0;
                    RegistrationExtents := 0;
                    RegistrationCollections := 0;
                    v_PlotRegistrationDetails.RESET;
                    v_PlotRegistrationDetails.SETCURRENTKEY("Introducer Code");
                    v_PlotRegistrationDetails.SETRANGE("Introducer Code", IntroducerCode);
                    v_PlotRegistrationDetails.SETRANGE("Document Date", StartDate, EndDate);
                    IF v_PlotRegistrationDetails.FINDSET THEN BEGIN
                        REPEAT
                            v_PlotRegistrationDetails.CALCFIELDS("Plot Extent");
                            IndividualRegs := IndividualRegs + 1;
                            RegistrationExtents := RegistrationExtents + v_PlotRegistrationDetails."Plot Extent";

                            NewApplicationPaymentEntry.RESET;
                            NewApplicationPaymentEntry.SETRANGE("Document No.", v_PlotRegistrationDetails."No.");
                            //   NewApplicationPaymentEntry.SETRANGE("Posting date",StartDate,EndDate);
                            NewApplicationPaymentEntry.SETFILTER("Cheque Status", '%1|%2', NewApplicationPaymentEntry."Cheque Status"::" ", NewApplicationPaymentEntry."Cheque Status"::Cleared);
                            NewApplicationPaymentEntry.SETFILTER("Payment Mode", '<>%1&<>%2', 6, 7);
                            NewApplicationPaymentEntry.SETRANGE(Posted, TRUE);
                            IF NewApplicationPaymentEntry.FINDSET THEN
                                REPEAT
                                    RegistrationCollections := RegistrationCollections + NewApplicationPaymentEntry.Amount;
                                UNTIL NewApplicationPaymentEntry.NEXT = 0;
                        UNTIL v_PlotRegistrationDetails.NEXT = 0;
                        IF IndividualRegs > 0 THEN BEGIN
                            TeamNames := '';
                            TeamMaster.RESET;
                            IF TeamMaster.GET(RecVend_1."BBG Team Code") THEN
                                TeamNames := TeamMaster."Team Name";
                            GamificationDetails.RESET;
                            GamificationDetails.INIT;
                            GamificationDetails."Document Date" := TODAY;
                            GamificationDetails.Type := GamificationDetails.Type::Individual;
                            GamificationDetails."Document Type" := GamificationDetails."Document Type"::Registration;
                            GamificationDetails."Associate Code" := IntroducerCode;
                            v_Vendor.RESET;
                            v_Vendor.GET(IntroducerCode);
                            IF v_Vendor."BBG Alternate Name" = '' THEN
                                GamificationDetails."Associate Name" := v_Vendor.Name
                            ELSE
                                GamificationDetails."Associate Name" := v_Vendor."BBG Alternate Name";

                            GamificationDetails."No. of Records" := IndividualRegs;
                            GamificationDetails."Registration Extent" := RegistrationExtents;
                            GamificationDetails."Registration Collection" := RegistrationCollections;
                            GamificationDetails."Start Date" := StartDate;
                            GamificationDetails."End Date" := EndDate;
                            GamificationDetails."Batch Run Time" := TIME;
                            GamificationDetails."Team Name" := TeamNames;
                            GamificationDetails.INSERT;
                        END;
                    END;
                END;
            UNTIL PlotRegistrationDetails.NEXT = 0;
    end;

    local procedure IndividualAllotments()
    var
        NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        v_NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        IntroducerCode: Code[20];
        IndividualAllts: Decimal;
        NewConfirmedOrder: Record "New Confirmed Order";
        v_NewConfirmedOrder: Record "New Confirmed Order";
        TotalRecords: Integer;
        UnitPmntE: Record "Unit Master";
        PlotNo: Integer;
        ArcOrd: Record "Archive Confirmed Order";
        RecVend_1: Record Vendor;
    begin
        IntroducerCode := '';
        NewConfirmedOrder.RESET;
        NewConfirmedOrder.SETCURRENTKEY("Introducer Code");
        NewConfirmedOrder.SETFILTER("Introducer Code", '<>%1', 'IBA9999999');
        NewConfirmedOrder.SETRANGE("Posting Date", StartDate, EndDate);
        IF NewConfirmedOrder.FINDSET THEN
            REPEAT
                IF IntroducerCode <> NewConfirmedOrder."Introducer Code" THEN BEGIN
                    IntroducerCode := NewConfirmedOrder."Introducer Code";
                    RecVend_1.RESET;
                    IF RecVend_1.GET(IntroducerCode) THEN;
                    IndividualAllts := 0;
                    TotalRecords := 0;
                    PlotNo := 0;
                    AllotmentExtents := 0;
                    AllotmentCollections := 0;
                    v_NewConfirmedOrder.RESET;
                    v_NewConfirmedOrder.SETCURRENTKEY("Introducer Code");
                    v_NewConfirmedOrder.SETRANGE("Introducer Code", IntroducerCode);
                    v_NewConfirmedOrder.SETRANGE("Posting Date", StartDate, EndDate);
                    IF v_NewConfirmedOrder.FINDSET THEN BEGIN
                        REPEAT
                            IndividualAllts := 0;
                            PlotNo := 0;
                            NewApplicationPaymentEntry.RESET;
                            NewApplicationPaymentEntry.SETRANGE("Document No.", v_NewConfirmedOrder."No.");
                            NewApplicationPaymentEntry.SETRANGE("Posting date", StartDate, EndDate);
                            NewApplicationPaymentEntry.SETFILTER("Cheque Status", '%1|%2', NewApplicationPaymentEntry."Cheque Status"::" ", NewApplicationPaymentEntry."Cheque Status"::Cleared);
                            NewApplicationPaymentEntry.SETRANGE(Posted, TRUE);
                            IF NewApplicationPaymentEntry.FINDSET THEN
                                REPEAT
                                    IndividualAllts := IndividualAllts + NewApplicationPaymentEntry.Amount;
                                    AllotmentCollections := AllotmentCollections + NewApplicationPaymentEntry.Amount;
                                UNTIL NewApplicationPaymentEntry.NEXT = 0;
                            IF v_NewConfirmedOrder."Unit Code" <> '' THEN
                                AllotmentExtents := AllotmentExtents + v_NewConfirmedOrder."Saleable Area";
                            IF IndividualAllts >= v_NewConfirmedOrder."Min. Allotment Amount" THEN BEGIN
                                IF v_NewConfirmedOrder."Unit Code" <> '' THEN BEGIN
                                    IF UnitPmntE.GET(v_NewConfirmedOrder."Unit Code") THEN BEGIN
                                        PlotNo := UnitPmntE."No. of Plots for Incentive Cal";  //170316
                                        IF PlotNo = 0 THEN
                                            PlotNo := UnitPmntE."No. of Plots";   //170316
                                    END;
                                END ELSE BEGIN
                                    ArcOrd.RESET;
                                    ArcOrd.CHANGECOMPANY(v_NewConfirmedOrder."Company Name");
                                    ArcOrd.SETRANGE("No.", v_NewConfirmedOrder."No.");
                                    IF ArcOrd.FINDLAST THEN BEGIN
                                        IF UnitPmntE.GET(ArcOrd."Unit Code") THEN BEGIN
                                            PlotNo := UnitPmntE."No. of Plots for Incentive Cal";  //170316
                                            IF PlotNo = 0 THEN
                                                PlotNo := UnitPmntE."No. of Plots";   //170316
                                        END;
                                    END;
                                END;
                                TotalRecords := TotalRecords + PlotNo;
                            END;
                        UNTIL v_NewConfirmedOrder.NEXT = 0;
                        IF TotalRecords > 0 THEN BEGIN
                            TeamNames := '';
                            TeamMaster.RESET;
                            IF TeamMaster.GET(RecVend_1."BBG Team Code") THEN
                                TeamNames := TeamMaster."Team Name";
                            GamificationDetails.RESET;
                            GamificationDetails.INIT;
                            GamificationDetails."Document Date" := TODAY;
                            GamificationDetails.Type := GamificationDetails.Type::Individual;
                            GamificationDetails."Document Type" := GamificationDetails."Document Type"::Allotment;
                            GamificationDetails."Associate Code" := IntroducerCode;
                            v_Vendor.RESET;
                            v_Vendor.GET(IntroducerCode);
                            IF v_Vendor."BBG Alternate Name" = '' THEN
                                GamificationDetails."Associate Name" := v_Vendor.Name
                            ELSE
                                GamificationDetails."Associate Name" := v_Vendor."BBG Alternate Name";

                            GamificationDetails."No. of Records" := TotalRecords;
                            GamificationDetails."Allotment Extent" := AllotmentExtents;
                            GamificationDetails."Allotment Collection" := AllotmentCollections;
                            GamificationDetails."Start Date" := StartDate;
                            GamificationDetails."End Date" := EndDate;
                            GamificationDetails."Batch Run Time" := TIME;
                            GamificationDetails."Team Name" := TeamNames;
                            GamificationDetails.INSERT;
                        END;
                    END;

                END;
            UNTIL NewConfirmedOrder.NEXT = 0;
    end;

    local procedure IndividualBookings()
    var
        NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        v_NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        NewApplicationPaymentEntry1: Record "NewApplication Payment Entry";
        IntroducerCode: Code[20];
        IndividualColls: Decimal;
        NewConfirmedOrder: Record "New Confirmed Order";
        v_NewConfirmedOrder: Record "New Confirmed Order";
        IndividualBooking: Decimal;
        NoofIndividualBooking: Integer;
        TotalExtent: Decimal;
        MinAllotementExists: Boolean;
        IndividualAllotment1: Decimal;
        StartDate: Date;
        EndDate: Date;
        MonthNo: Integer;
        Years: Integer;
        ConsiderNoofApp: Integer;
        RecVend_1: Record Vendor;
    begin
        IntroducerCode := '';
        NoofIndividualBooking := 0;
        UnitSetup.GET;
        MonthNo := 0;
        StartDate := 0D;
        EndDate := 0D;
        Years := 0;
        MonthNo := DATE2DMY(EndDate, 2);
        Years := DATE2DMY(EndDate, 3);
        StartDate := DMY2DATE(1, MonthNo, Years);
        EndDate := EndDate;
        NewConfirmedOrder.RESET;
        NewConfirmedOrder.SETCURRENTKEY("Introducer Code");
        NewConfirmedOrder.SETFILTER("Introducer Code", '<>%1', 'IBA9999999');
        NewConfirmedOrder.SETFILTER(Status, '<>%1', NewConfirmedOrder.Status::Registered);
        IF NewConfirmedOrder.FINDSET THEN
            REPEAT
                IF IntroducerCode <> NewConfirmedOrder."Introducer Code" THEN BEGIN
                    IntroducerCode := NewConfirmedOrder."Introducer Code";
                    RecVend_1.RESET;
                    IF RecVend_1.GET(IntroducerCode) THEN;
                    IndividualBooking := 0;
                    IndividualColls := 0;
                    IndividualAllotment := 0;
                    NoofAllotements := 0;
                    TotalExtent := 0;
                    NoofIndividualBooking := 0;
                    MinAllotementExists := FALSE;
                    v_NewConfirmedOrder.RESET;
                    v_NewConfirmedOrder.SETCURRENTKEY("Introducer Code", "Posting Date");
                    v_NewConfirmedOrder.SETRANGE("Introducer Code", IntroducerCode);
                    v_NewConfirmedOrder.SETFILTER(Status, '<>%1', v_NewConfirmedOrder.Status::Registered);
                    IF v_NewConfirmedOrder.FINDSET THEN BEGIN
                        REPEAT

                            IndividualAllotment1 := 0;
                            IF (v_NewConfirmedOrder."Posting Date" >= StartDate) AND (v_NewConfirmedOrder."Posting Date" <= EndDate) THEN BEGIN
                                TotalExtent := TotalExtent + v_NewConfirmedOrder."Saleable Area";
                                NewApplicationPaymentEntry1.RESET;
                                NewApplicationPaymentEntry1.SETRANGE("Document No.", v_NewConfirmedOrder."No.");
                                NewApplicationPaymentEntry1.SETRANGE("Posting date", 0D, EndDate - 1);
                                NewApplicationPaymentEntry1.SETFILTER("Cheque Status", '%1|%2', NewApplicationPaymentEntry1."Cheque Status"::" ", NewApplicationPaymentEntry1."Cheque Status"::Cleared);
                                NewApplicationPaymentEntry1.SETFILTER("Payment Mode", '<>%1&<>%2', 6, 7);
                                NewApplicationPaymentEntry1.SETRANGE(Posted, TRUE);
                                IF NewApplicationPaymentEntry1.FINDSET THEN BEGIN
                                    REPEAT
                                        IndividualAllotment1 := IndividualAllotment1 + NewApplicationPaymentEntry1.Amount;
                                    UNTIL NewApplicationPaymentEntry1.NEXT = 0;
                                    IF IndividualAllotment1 >= v_NewConfirmedOrder."Min. Allotment Amount" THEN
                                        MinAllotementExists := TRUE;
                                END;

                                IndividualAllotment := 0;
                                NewApplicationPaymentEntry.RESET;
                                NewApplicationPaymentEntry.SETRANGE("Document No.", v_NewConfirmedOrder."No.");
                                NewApplicationPaymentEntry.SETRANGE("Posting date", 0D, EndDate);
                                NewApplicationPaymentEntry.SETFILTER("Cheque Status", '%1|%2', NewApplicationPaymentEntry."Cheque Status"::" ", NewApplicationPaymentEntry."Cheque Status"::Cleared);
                                NewApplicationPaymentEntry.SETFILTER("Payment Mode", '<>%1&<>%2', 6, 7);
                                NewApplicationPaymentEntry.SETRANGE(Posted, TRUE);
                                IF NewApplicationPaymentEntry.FINDSET THEN BEGIN
                                    REPEAT
                                        IF (NewApplicationPaymentEntry."Posting date" >= StartDate) AND (NewApplicationPaymentEntry."Posting date" <= EndDate) THEN BEGIN
                                            IndividualColls := IndividualColls + NewApplicationPaymentEntry.Amount;
                                            IndividualBooking := IndividualBooking + NewApplicationPaymentEntry.Amount;
                                        END;
                                        IF (v_NewConfirmedOrder."Posting Date" >= StartDate) AND (v_NewConfirmedOrder."Posting Date" <= EndDate) THEN BEGIN
                                            IndividualAllotment := IndividualAllotment + NewApplicationPaymentEntry.Amount;
                                        END;
                                    UNTIL NewApplicationPaymentEntry.NEXT = 0;
                                    IF (IndividualBooking >= 2000) AND (v_NewConfirmedOrder."Unit Code" <> '') THEN BEGIN
                                        IF v_NewConfirmedOrder."Saleable Area" <= 146.66 THEN
                                            NoofIndividualBooking := NoofIndividualBooking + 1
                                        ELSE BEGIN
                                            ConsiderNoofApp := 0;
                                            ConsiderNoofApp := ROUND((v_NewConfirmedOrder."Saleable Area" / 146.66), 1, '<');
                                            NoofIndividualBooking := NoofIndividualBooking + ConsiderNoofApp;
                                        END;
                                    END;
                                END;

                                IF NOT MinAllotementExists THEN BEGIN
                                    IF IndividualAllotment >= v_NewConfirmedOrder."Min. Allotment Amount" THEN
                                        NoofAllotements := NoofAllotements + 1;
                                END;
                            END;  //290722
                        UNTIL v_NewConfirmedOrder.NEXT = 0;
                        IF NoofIndividualBooking > 0 THEN BEGIN
                            TeamNames := '';
                            TeamMaster.RESET;
                            IF TeamMaster.GET(RecVend_1."BBG Team Code") THEN
                                TeamNames := TeamMaster."Team Name";

                            GamificationDetails.RESET;
                            GamificationDetails.INIT;
                            GamificationDetails."Document Date" := TODAY;
                            GamificationDetails.Type := GamificationDetails.Type::Individual;
                            GamificationDetails."Document Type" := GamificationDetails."Document Type"::Booking;
                            GamificationDetails."Associate Code" := IntroducerCode;
                            v_Vendor.RESET;
                            v_Vendor.GET(IntroducerCode);
                            IF v_Vendor."BBG Alternate Name" = '' THEN
                                GamificationDetails."Associate Name" := v_Vendor.Name
                            ELSE
                                GamificationDetails."Associate Name" := v_Vendor."BBG Alternate Name";

                            GamificationDetails."No. of Records" := NoofIndividualBooking;
                            GamificationDetails."Booking Collection" := IndividualColls;
                            GamificationDetails."Booking Extent" := TotalExtent;
                            GamificationDetails."Start Date" := StartDate;
                            GamificationDetails."End Date" := EndDate;
                            GamificationDetails."Booking Allotment" := NoofAllotements;
                            GamificationDetails."Batch Run Time" := TIME;
                            GamificationDetails."Team Name" := TeamNames;
                            GamificationDetails.INSERT;
                        END;
                    END;
                END;
            UNTIL NewConfirmedOrder.NEXT = 0;
    end;
}

