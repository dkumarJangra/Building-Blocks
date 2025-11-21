report 97753 "Gamification Team Detail Batch"
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



                TeamRequirements;
                TeamAllotments;
                TeamCollections;
                TeamBooking;
                TeamRegistrations;
                COMMIT;
            end;

            trigger OnPreDataItem()
            begin
                GamificationDetails.RESET;
                GamificationDetails.SETRANGE(Type, GamificationDetails.Type::Team);
                GamificationDetails.DELETEALL;
                StartDate := 0D;
                EndDate := 0D;
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
                GamificationDetails.SETRANGE(Type, GamificationDetails.Type::Team);
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
                GamificationDetails.SETRANGE(Type, GamificationDetails.Type::Team);
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
                GamificationDetails.SETRANGE(Type, GamificationDetails.Type::Team);
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
                GamificationDetails.SETRANGE(Type, GamificationDetails.Type::Team);
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
                GamificationDetails.SETRANGE(Type, GamificationDetails.Type::Team);
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
        Vendor: Record Vendor;
        GamificationTeamHierarchy: Record "Gamification Team Hierarchy";
        GamificationTeamHierarchy_1: Record "Gamification Team Hierarchy";
        TeamMaster: Record "Team Master";
        v_Vendrs: Record Vendor;
        StartDate: Date;
        EndDate: Date;
        UserSetup: Record "User Setup";

    local procedure TeamRequirements()
    var
        IntroducerCode: Code[20];
        NoofRequirements: Integer;
        v_Vendor: Record Vendor;
        NewAssociateHierwithAppl: Record "New Associate Hier with Appl.";
        v_Vendor_1: Record Vendor;
        v_GamificationDetails: Record "Gamification Details";
        TeamTopHead: Code[20];
        v_GamificationTeamHierarchy: Record "Gamification Team Hierarchy";
        AssociateCode: Code[20];
    begin
        TeamTopHead := '';
        UnitSetup.GET;
        GamificationTeamHierarchy.RESET;
        GamificationTeamHierarchy.SETCURRENTKEY("Team Top Head");
        IF GamificationTeamHierarchy.FINDSET THEN
            REPEAT
                IF TeamTopHead <> GamificationTeamHierarchy."Team Top Head" THEN BEGIN
                    TeamTopHead := GamificationTeamHierarchy."Team Top Head";
                    IntroducerCode := '';
                    MahaSankalap := 0;
                    Sankalap := 0;
                    NoofRequirements := 0;
                    AssociateCode := '';
                    GamificationTeamHierarchy_1.RESET;
                    GamificationTeamHierarchy_1.SETCURRENTKEY("Team Top Head", "Associate Code");
                    GamificationTeamHierarchy_1.SETRANGE("Team Top Head", GamificationTeamHierarchy."Team Top Head");
                    GamificationTeamHierarchy_1.SETRANGE(DOJ, StartDate, EndDate);
                    IF GamificationTeamHierarchy_1.FINDSET THEN
                        REPEAT
                            IF AssociateCode <> GamificationTeamHierarchy_1."Associate Code" THEN BEGIN
                                AssociateCode := GamificationTeamHierarchy_1."Associate Code";
                                NoofRequirements := NoofRequirements + 1;
                                RegionwiseVendor.RESET;
                                RegionwiseVendor.SETRANGE("No.", GamificationTeamHierarchy_1."Associate Code");
                                IF RegionwiseVendor.FINDFIRST THEN
                                    IF RegionwiseVendor."Rank Code" > 1 THEN
                                        MahaSankalap := MahaSankalap + 1
                                    ELSE
                                        Sankalap := Sankalap + 1;
                            END;
                        UNTIL GamificationTeamHierarchy_1.NEXT = 0;
                    IF NoofRequirements > 0 THEN BEGIN
                        v_Vendor_1.RESET;
                        IF v_Vendor_1.GET(GamificationTeamHierarchy."Team Top Head") THEN;
                        TeamMaster.RESET;
                        IF TeamMaster.GET(v_Vendor_1."BBG Team Code") THEN;
                        GamificationDetails.INIT;
                        GamificationDetails."Document Date" := TODAY;
                        GamificationDetails.Type := GamificationDetails.Type::Team;
                        GamificationDetails."Document Type" := GamificationDetails."Document Type"::Recruitment;
                        GamificationDetails."Associate Code" := GamificationTeamHierarchy."Team Top Head";
                        v_Vendrs.RESET;
                        v_Vendrs.GET(GamificationTeamHierarchy."Team Top Head");
                        IF v_Vendrs."BBG Alternate Name" = '' THEN
                            GamificationDetails."Associate Name" := v_Vendrs.Name
                        ELSE
                            GamificationDetails."Associate Name" := v_Vendrs."BBG Alternate Name";

                        GamificationDetails."No. of Records" := NoofRequirements;
                        GamificationDetails."Date of Joining" := v_Vendor_1."BBG Date of Joining";
                        GamificationDetails.Sankalp := Sankalap;
                        GamificationDetails.Mahasankalp := MahaSankalap;
                        GamificationDetails."Start Date" := StartDate;
                        GamificationDetails."End Date" := EndDate;
                        GamificationDetails."Batch Run Time" := TIME;
                        GamificationDetails."Team Name" := TeamMaster."Team Name";
                        GamificationDetails.INSERT;
                    END;
                END;
            UNTIL GamificationTeamHierarchy.NEXT = 0;
    end;

    local procedure TeamCollections()
    var
        NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        v_NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        IntroducerCode: Code[20];
        IndividualColls: Decimal;
        NewConfirmedOrder: Record "New Confirmed Order";
        v_NewConfirmedOrder: Record "New Confirmed Order";
        NewAssociateHierwithAppl: Record "New Associate Hier with Appl.";
        v_Vendor_1: Record Vendor;
    begin
        Vendor.RESET;
        Vendor.SETRANGE("BBG Top Associate for Gamification", TRUE);
        IF Vendor.FINDSET THEN
            REPEAT
                v_Vendor_1.RESET;
                v_Vendor_1.SETRANGE("BBG Black List", FALSE);
                v_Vendor_1.SETRANGE("No.", Vendor."No.");
                IF v_Vendor_1.FINDSET THEN
                    REPEAT
                        IndividualColls := 0;
                        LatestDOJOFAPP := 0D;
                        NewAssociateHierwithAppl.RESET;
                        NewAssociateHierwithAppl.SETCURRENTKEY("Associate Code", "Application Code");
                        NewAssociateHierwithAppl.SETRANGE("Associate Code", v_Vendor_1."No.");
                        NewAssociateHierwithAppl.SETRANGE(Status, NewAssociateHierwithAppl.Status::Active);
                        IF NewAssociateHierwithAppl.FINDSET THEN
                            REPEAT
                                v_NewConfirmedOrder.RESET;
                                v_NewConfirmedOrder.SETRANGE("No.", NewAssociateHierwithAppl."Application Code");
                                v_NewConfirmedOrder.SETFILTER(Status, '<>%1', v_NewConfirmedOrder.Status::Registered);
                                IF v_NewConfirmedOrder.FINDFIRST THEN BEGIN
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
                                END;

                            UNTIL NewAssociateHierwithAppl.NEXT = 0;
                        IF IndividualColls > 0 THEN BEGIN
                            TeamMaster.RESET;
                            IF TeamMaster.GET(v_Vendor_1."BBG Team Code") THEN;
                            GamificationDetails.RESET;
                            GamificationDetails.INIT;
                            GamificationDetails."Document Date" := TODAY;
                            GamificationDetails.Type := GamificationDetails.Type::Team;
                            GamificationDetails."Document Type" := GamificationDetails."Document Type"::Collection;
                            GamificationDetails."Associate Code" := v_Vendor_1."No.";
                            v_Vendrs.RESET;
                            v_Vendrs.GET(v_Vendor_1."No.");
                            IF v_Vendrs."BBG Alternate Name" = '' THEN
                                GamificationDetails."Associate Name" := v_Vendrs.Name
                            ELSE
                                GamificationDetails."Associate Name" := v_Vendrs."BBG Alternate Name";

                            GamificationDetails."Total Values" := IndividualColls;
                            //GamificationDetails."Latest DOJ of Application" := LatestDOJOFAPP;
                            GamificationDetails."Start Date" := StartDate;
                            GamificationDetails."End Date" := EndDate;
                            GamificationDetails."Batch Run Time" := TIME;
                            GamificationDetails."Team Name" := TeamMaster."Team Name";
                            GamificationDetails.INSERT;
                        END;
                    UNTIL v_Vendor_1.NEXT = 0;
            UNTIL Vendor.NEXT = 0;
    end;

    local procedure TeamRegistrations()
    var
        NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        v_NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        IntroducerCode: Code[20];
        NewConfirmedOrder: Record "New Confirmed Order";
        v_NewConfirmedOrder: Record "New Confirmed Order";
        IndividualRegs: Integer;
        NewAssociateHierwithAppl: Record "New Associate Hier with Appl.";
        v_Vendor_1: Record Vendor;
        v_PlotRegistrationDetails: Record "Plot Registration Details";
    begin
        IntroducerCode := '';
        Vendor.RESET;
        Vendor.SETRANGE("BBG Top Associate for Gamification", TRUE);
        IF Vendor.FINDSET THEN
            REPEAT
                v_Vendor_1.RESET;
                v_Vendor_1.SETRANGE("BBG Black List", FALSE);
                v_Vendor_1.SETRANGE("No.", Vendor."No.");
                IF v_Vendor_1.FINDSET THEN
                    REPEAT
                        IndividualRegs := 0;
                        RegistrationExtents := 0;
                        RegistrationCollections := 0;
                        NewAssociateHierwithAppl.RESET;
                        NewAssociateHierwithAppl.SETCURRENTKEY("Associate Code", "Application Code");
                        NewAssociateHierwithAppl.SETRANGE("Associate Code", v_Vendor_1."No.");
                        NewAssociateHierwithAppl.SETRANGE(Status, NewAssociateHierwithAppl.Status::Active);
                        IF NewAssociateHierwithAppl.FINDSET THEN
                            REPEAT
                                v_PlotRegistrationDetails.CALCFIELDS("Plot Extent");
                                v_PlotRegistrationDetails.RESET;
                                v_PlotRegistrationDetails.SETRANGE("No.", NewAssociateHierwithAppl."Application Code");
                                v_PlotRegistrationDetails.SETRANGE("Document Date", StartDate, EndDate);
                                IF v_PlotRegistrationDetails.FINDFIRST THEN BEGIN
                                    IndividualRegs := IndividualRegs + 1;
                                    RegistrationExtents := RegistrationExtents + v_PlotRegistrationDetails."Plot Extent";
                                    NewApplicationPaymentEntry.RESET;
                                    NewApplicationPaymentEntry.SETRANGE("Document No.", v_PlotRegistrationDetails."No.");
                                    NewApplicationPaymentEntry.SETFILTER("Cheque Status", '%1|%2', NewApplicationPaymentEntry."Cheque Status"::" ", NewApplicationPaymentEntry."Cheque Status"::Cleared);
                                    NewApplicationPaymentEntry.SETRANGE(Posted, TRUE);
                                    IF NewApplicationPaymentEntry.FINDSET THEN
                                        REPEAT
                                            RegistrationCollections := RegistrationCollections + NewApplicationPaymentEntry.Amount;
                                        UNTIL NewApplicationPaymentEntry.NEXT = 0;
                                END;
                            UNTIL NewAssociateHierwithAppl.NEXT = 0;
                        IF IndividualRegs > 0 THEN BEGIN
                            TeamMaster.RESET;
                            IF TeamMaster.GET(v_Vendor_1."BBG Team Code") THEN;
                            GamificationDetails.RESET;
                            GamificationDetails.INIT;
                            GamificationDetails."Document Date" := TODAY;
                            GamificationDetails.Type := GamificationDetails.Type::Team;
                            GamificationDetails."Document Type" := GamificationDetails."Document Type"::Registration;
                            GamificationDetails."Associate Code" := v_Vendor_1."No.";
                            v_Vendrs.RESET;
                            v_Vendrs.GET(v_Vendor_1."No.");
                            IF v_Vendrs."BBG Alternate Name" = '' THEN
                                GamificationDetails."Associate Name" := v_Vendrs.Name
                            ELSE
                                GamificationDetails."Associate Name" := v_Vendrs."BBG Alternate Name";

                            GamificationDetails."No. of Records" := IndividualRegs;
                            GamificationDetails."Registration Extent" := RegistrationExtents;
                            GamificationDetails."Registration Collection" := RegistrationCollections;
                            GamificationDetails."Start Date" := StartDate;
                            GamificationDetails."End Date" := EndDate;
                            GamificationDetails."Batch Run Time" := TIME;
                            GamificationDetails."Team Name" := TeamMaster."Team Name";
                            GamificationDetails.INSERT;
                        END;

                    UNTIL v_Vendor_1.NEXT = 0;
            UNTIL Vendor.NEXT = 0;
    end;

    local procedure TeamAllotments()
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
        NewAssociateHierwithAppl: Record "New Associate Hier with Appl.";
        v_Vendor_1: Record Vendor;
    begin
        UnitSetup.GET;
        Vendor.RESET;
        Vendor.SETRANGE("BBG Black List", FALSE);
        Vendor.SETRANGE("BBG Top Associate for Gamification", TRUE);
        IF Vendor.FINDSET THEN
            REPEAT
                v_Vendor_1.RESET;
                v_Vendor_1.SETRANGE("BBG Black List", FALSE);
                v_Vendor_1.SETRANGE("No.", Vendor."No.");
                IF v_Vendor_1.FINDSET THEN
                    REPEAT
                        IndividualAllts := 0;
                        TotalRecords := 0;
                        PlotNo := 0;
                        AllotmentExtents := 0;
                        AllotmentCollections := 0;
                        NewAssociateHierwithAppl.RESET;
                        NewAssociateHierwithAppl.SETCURRENTKEY("Associate Code", "Application Code");
                        NewAssociateHierwithAppl.SETRANGE("Associate Code", v_Vendor_1."No.");
                        NewAssociateHierwithAppl.SETRANGE(Status, NewAssociateHierwithAppl.Status::Active);
                        IF NewAssociateHierwithAppl.FINDSET THEN
                            REPEAT
                                v_NewConfirmedOrder.RESET;
                                v_NewConfirmedOrder.SETRANGE("No.", NewAssociateHierwithAppl."Application Code");
                                v_NewConfirmedOrder.SETRANGE("Posting Date", StartDate, EndDate);
                                IF v_NewConfirmedOrder.FINDSET THEN BEGIN
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

                                    END;
                                    TotalRecords := TotalRecords + PlotNo;
                                END;
                            UNTIL NewAssociateHierwithAppl.NEXT = 0;
                        IF TotalRecords > 0 THEN BEGIN
                            TeamMaster.RESET;
                            IF TeamMaster.GET(v_Vendor_1."BBG Team Code") THEN;
                            GamificationDetails.RESET;
                            GamificationDetails.INIT;
                            GamificationDetails."Document Date" := TODAY;
                            GamificationDetails.Type := GamificationDetails.Type::Team;
                            GamificationDetails."Document Type" := GamificationDetails."Document Type"::Allotment;
                            GamificationDetails."Associate Code" := v_Vendor_1."No.";
                            v_Vendrs.RESET;
                            v_Vendrs.GET(v_Vendor_1."No.");
                            IF v_Vendrs."BBG Alternate Name" = '' THEN
                                GamificationDetails."Associate Name" := v_Vendrs.Name
                            ELSE
                                GamificationDetails."Associate Name" := v_Vendrs."BBG Alternate Name";

                            GamificationDetails."No. of Records" := TotalRecords;
                            GamificationDetails."Allotment Extent" := AllotmentExtents;
                            GamificationDetails."Allotment Collection" := AllotmentCollections;
                            GamificationDetails."Start Date" := StartDate;
                            GamificationDetails."End Date" := EndDate;
                            GamificationDetails."Batch Run Time" := TIME;
                            GamificationDetails."Team Name" := TeamMaster."Team Name";
                            GamificationDetails.INSERT;
                        END;
                    UNTIL v_Vendor_1.NEXT = 0;
            UNTIL Vendor.NEXT = 0;
    end;

    local procedure TeamBooking()
    var
        NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        v_NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        IntroducerCode: Code[20];
        IndividualColls: Decimal;
        NewConfirmedOrder: Record "New Confirmed Order";
        v_NewConfirmedOrder: Record "New Confirmed Order";
        NewAssociateHierwithAppl: Record "New Associate Hier with Appl.";
        v_Vendor_1: Record Vendor;
        TotalExtent: Decimal;
        MinAllotementExists: Boolean;
        IndividualAllotment1: Decimal;
        "------------------------------------": Integer;
        NewApplicationPaymentEntry1: Record "NewApplication Payment Entry";
        IndividualBooking: Decimal;
        IndividualAllotment: Decimal;
        NoofIndividualBooking: Integer;
        StartDate: Date;
        EndDate: Date;
        MonthNo: Integer;
        Years: Integer;
        NoofAllotements: Integer;
        ConsiderNoofApp: Integer;
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


        v_Vendor_1.RESET;
        v_Vendor_1.SETCURRENTKEY("BBG Top Associate for Gamification", "BBG Black List");
        v_Vendor_1.SETRANGE("BBG Top Associate for Gamification", TRUE);
        v_Vendor_1.SETRANGE("BBG Black List", FALSE);
        IF v_Vendor_1.FINDSET THEN
            REPEAT
                IndividualColls := 0;
                LatestDOJOFAPP := 0D;
                TotalExtent := 0;
                NoofIndividualBooking := 0;
                IndividualColls := 0;
                IndividualBooking := 0;
                NoofAllotements := 0;
                NewAssociateHierwithAppl.RESET;
                NewAssociateHierwithAppl.SETCURRENTKEY("Associate Code", "Application Code");
                NewAssociateHierwithAppl.SETRANGE("Associate Code", v_Vendor_1."No.");
                NewAssociateHierwithAppl.SETRANGE(Status, NewAssociateHierwithAppl.Status::Active);
                IF NewAssociateHierwithAppl.FINDSET THEN
                    REPEAT
                        v_NewConfirmedOrder.RESET;
                        v_NewConfirmedOrder.SETRANGE("No.", NewAssociateHierwithAppl."Application Code");
                        v_NewConfirmedOrder.SETFILTER(Status, '<>%1', v_NewConfirmedOrder.Status::Registered);
                        IF v_NewConfirmedOrder.FINDFIRST THEN BEGIN
                            MinAllotementExists := FALSE;

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
                                //END;  //ALLEK290722
                                IndividualAllotment := 0;
                                IndividualBooking := 0;
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
                            END;  //ALLEK290722
                        END;
                    UNTIL NewAssociateHierwithAppl.NEXT = 0;
                IF NoofIndividualBooking > 0 THEN BEGIN
                    TeamMaster.RESET;
                    IF TeamMaster.GET(v_Vendor_1."BBG Team Code") THEN;
                    GamificationDetails.RESET;
                    GamificationDetails.INIT;
                    GamificationDetails."Document Date" := TODAY;
                    GamificationDetails.Type := GamificationDetails.Type::Team;
                    GamificationDetails."Document Type" := GamificationDetails."Document Type"::Booking;
                    GamificationDetails."Associate Code" := v_Vendor_1."No.";
                    v_Vendrs.RESET;
                    v_Vendrs.GET(v_Vendor_1."No.");
                    IF v_Vendrs."BBG Alternate Name" = '' THEN
                        GamificationDetails."Associate Name" := v_Vendrs.Name
                    ELSE
                        GamificationDetails."Associate Name" := v_Vendrs."BBG Alternate Name";

                    GamificationDetails."No. of Records" := NoofIndividualBooking;
                    GamificationDetails."Booking Collection" := IndividualColls;
                    GamificationDetails."Booking Extent" := TotalExtent;
                    GamificationDetails."Start Date" := StartDate;
                    GamificationDetails."End Date" := EndDate;
                    GamificationDetails."Booking Allotment" := NoofAllotements;
                    GamificationDetails."Batch Run Time" := TIME;
                    GamificationDetails."Team Name" := TeamMaster."Team Name";
                    GamificationDetails.INSERT;
                END;
            UNTIL v_Vendor_1.NEXT = 0;
    end;
}

