codeunit 50045 "Registration Target / Achive"
{

    trigger OnRun()
    begin

        OldRegisteredTargetDetails.RESET;
        OldRegisteredTargetDetails.SETCURRENTKEY(Year, "Month Number");
        IF OldRegisteredTargetDetails.FINDFIRST THEN BEGIN
            UpdateData(OldRegisteredTargetDetails.Year, OldRegisteredTargetDetails."Month Number", OldRegisteredTargetDetails."From Date", OldRegisteredTargetDetails."To Date");

            RegisteredTargetDetails.RESET;
            RegisteredTargetDetails.SETCURRENTKEY(Year, "Month Number");
            //RegisteredTargetDetails.SETRANGE(Year,OldRegisteredTargetDetails.Year);
            //RegisteredTargetDetails.SETFILTER("Month Number",'>%1',OldRegisteredTargetDetails."Month Number");
            //RegisteredTargetDetails.SETRANGE("Region Code",OldRegisteredTargetDetails."Region Code");
            RegisteredTargetDetails.SETFILTER("From Date", '>%1', OldRegisteredTargetDetails."From Date");
            IF RegisteredTargetDetails.FINDSET THEN BEGIN
                REPEAT
                    UpdateData(RegisteredTargetDetails.Year, RegisteredTargetDetails."Month Number", RegisteredTargetDetails."From Date", RegisteredTargetDetails."To Date");
                UNTIL RegisteredTargetDetails.NEXT = 0;
            END;
        END;
        MESSAGE('Process done');
    end;

    var
        OldRegisteredTargetDetails: Record "Registered Target Details";
        RegisteredTargetDetails: Record "Registered Target Details";
        ClusterMaster: Record "New Cluster Master";
        ResponsibilityCenter: Record "Responsibility Center 1";
        NewConfirmedOrder: Record "New Confirmed Order";
        TotalRegPlots: Integer;
        CheckRegisteredTargetDetails: Record "Registered Target Details";
        ExistsMonthNo: Integer;
        LastRegisteredTargetDetails: Record "Registered Target Details";
        RegisteredTargetDetails_1: Record "Registered Target Details";
        TotalTarget: Integer;
        PreviousRegisteredTargetDetails: Record "Registered Target Details";
        PreviousBalance: Integer;
        RegisteredTargetDetails_3: Record "Registered Target Details";
        NoofRecords: Integer;
        NextMonth: Integer;
        NextYear: Integer;
        PlotRegistrationDetails: Record "Plot Registration Details";
        ReceivedDoc: Integer;

    local procedure UpdateData(NewYear: Integer; NewMonthNo: Integer; NewStDate: Date; EndDAte: Date)
    begin

        RegisteredTargetDetails_1.RESET;
        RegisteredTargetDetails_1.SETRANGE(Year, NewYear);
        RegisteredTargetDetails_1.SETRANGE("Month Number", NewMonthNo);
        IF RegisteredTargetDetails_1.FINDSET THEN
            REPEAT
                TotalRegPlots := 0;
                ReceivedDoc := 0;
                ClusterMaster.RESET;
                ClusterMaster.SETCURRENTKEY("Region Code");
                ClusterMaster.SETRANGE("Region Code", RegisteredTargetDetails_1."Region Code");
                IF ClusterMaster.FINDSET THEN BEGIN
                    REPEAT
                        ResponsibilityCenter.RESET;
                        ResponsibilityCenter.SETCURRENTKEY("Cluster Code");
                        ResponsibilityCenter.SETRANGE("Cluster Code", ClusterMaster."Cluster Code");
                        IF ResponsibilityCenter.FINDSET THEN
                            REPEAT
                                NewConfirmedOrder.RESET;
                                NewConfirmedOrder.SETCURRENTKEY("Registration Date", "Shortcut Dimension 1 Code");
                                NewConfirmedOrder.SETRANGE("Registration Date", NewStDate, EndDAte);
                                NewConfirmedOrder.SETRANGE("Shortcut Dimension 1 Code", ResponsibilityCenter.Code);
                                NewConfirmedOrder.SETRANGE(Status, NewConfirmedOrder.Status::Registered);
                                IF NewConfirmedOrder.FINDSET THEN
                                    REPEAT
                                        TotalRegPlots := TotalRegPlots + 1;
                                    UNTIL NewConfirmedOrder.NEXT = 0;

                                PlotRegistrationDetails.RESET;
                                PlotRegistrationDetails.SETCURRENTKEY("Shortcut Dimension 1 Code", "Approved (Stage-3)", "Approved Date (Stage-3)");
                                PlotRegistrationDetails.SETRANGE("Shortcut Dimension 1 Code", ResponsibilityCenter.Code);
                                PlotRegistrationDetails.SETRANGE("Approved (Stage-3)", TRUE);
                                PlotRegistrationDetails.SETRANGE("Approved Date (Stage-3)", NewStDate, EndDAte);
                                IF PlotRegistrationDetails.FINDSET THEN
                                    REPEAT
                                        ReceivedDoc := ReceivedDoc + 1;
                                    UNTIL PlotRegistrationDetails.NEXT = 0;
                            UNTIL ResponsibilityCenter.NEXT = 0;
                    UNTIL ClusterMaster.NEXT = 0;
                    RegisteredTargetDetails_1."Achived Plots" := TotalRegPlots;
                    RegisteredTargetDetails_1.Received := ReceivedDoc;
                    RegisteredTargetDetails_1.MODIFY;
                END;
            UNTIL RegisteredTargetDetails_1.NEXT = 0;

        /*  //080824 Code commented start
        PreviousBalance := 0;
        PreviousRegisteredTargetDetails.RESET;
        PreviousRegisteredTargetDetails.SETFILTER("From Date",'<%1',NewStDate);
        PreviousRegisteredTargetDetails.SETFILTER("Balance Target",'>%1',0);
        IF PreviousRegisteredTargetDetails.FINDLAST THEN BEGIN
          REPEAT
            PreviousBalance := PreviousRegisteredTargetDetails."Balance Target";
          UNTIL PreviousRegisteredTargetDetails.NEXT =0;
        END;
        */  //080824 Code commented END

        TotalTarget := 0;
        TotalRegPlots := 0;
        NoofRecords := 0;
        LastRegisteredTargetDetails.RESET;
        LastRegisteredTargetDetails.SETRANGE(Year, NewYear);
        LastRegisteredTargetDetails.SETRANGE("Month Number", NewMonthNo);
        IF LastRegisteredTargetDetails.FINDSET THEN BEGIN
            REPEAT
                TotalTarget := TotalTarget + LastRegisteredTargetDetails."No. of Plot Target";
                TotalRegPlots := TotalRegPlots + LastRegisteredTargetDetails."Achived Plots";
                NoofRecords := NoofRecords + 1;
            UNTIL LastRegisteredTargetDetails.NEXT = 0;
            //LastRegisteredTargetDetails."Previouse Month Bal. Target" := PreviousBalance;
            //LastRegisteredTargetDetails."Balance Target" := LastRegisteredTargetDetails."Previouse Month Bal. Target" + TotalTarget - TotalRegPlots;
            LastRegisteredTargetDetails.MODIFY;
        END;

        RegisteredTargetDetails_3.RESET;
        RegisteredTargetDetails_3.SETRANGE(Year, NewYear);
        RegisteredTargetDetails_3.SETRANGE("Month Number", NewMonthNo);
        IF RegisteredTargetDetails_3.FINDSET THEN
            REPEAT
                RegisteredTargetDetails_3."Actual Target" := RegisteredTargetDetails_3."No. of Plot Target";// + ROUND((PreviousBalance /NoofRecords),1,'=');
                RegisteredTargetDetails_3.MODIFY;
            UNTIL RegisteredTargetDetails_3.NEXT = 0;

    end;
}

