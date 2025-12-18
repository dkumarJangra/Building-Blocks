codeunit 50047 "Updation of plot details"
{

    trigger OnRun()
    begin
        TestNoofdays.DELETEALL;
        UpdateNoofDaysforOpenApplications('');
        COMMIT;
        Updationofplotdetails.RESET;
        IF Updationofplotdetails.FINDSET THEN
            REPEAT
                NewUnitmasters.RESET;
                IF NewUnitmasters.GET(Updationofplotdetails."Plot No.") THEN;
                CLEAR(DataPushtoOnLineMaster);
                DataPushtoOnLineMaster.SetUnitMaster(NewUnitmasters);
                IF NOT DataPushtoOnLineMaster.RUN THEN BEGIN
                END;
            UNTIL Updationofplotdetails.NEXT = 0;
    end;

    var
        NewConfirmedOrder1: Record "New Confirmed Order";
        PaymentPlanDetails: Record "Payment Plan Details";
        DueDate: Date;
        TestNoofdays: Record "Updation of plot details";
        DataInsert: Boolean;
        NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        EndDate: Date;
        StartDt: Date;
        MinAmount: Decimal;
        ResponsibilityCenter: Record "Responsibility Center 1";
        NoofDays: Integer;
        NewConfirmedOrder_2: Record "New Confirmed Order";
        Updationofplotdetails: Record "Updation of plot details";
        NewUnitmasters: Record "Unit Master";
        DataPushtoOnLineMaster: Codeunit "Data Push to OnLine Master";


    procedure UpdateNoofDaysforOpenApplications(UnitCode: Code[20])
    begin
        NewConfirmedOrder1.RESET;
        //NewConfirmedOrder.SETRANGE("Posting Date",010424D,TODAY);
        NewConfirmedOrder1.SETRANGE(Status, NewConfirmedOrder1.Status::Open);
        IF UnitCode <> '' THEN
            NewConfirmedOrder1.SETRANGE("Unit Code", UnitCode)
        ELSE
            NewConfirmedOrder1.SETFILTER("Unit Code", '<>%1', '');
        IF NewConfirmedOrder1.FINDSET THEN
            REPEAT
                NoofDays := UpdateNoofDays(NewConfirmedOrder1);
            UNTIL NewConfirmedOrder1.NEXT = 0;
    end;


    procedure UpdateNoofDays(NewConfirmedOrder: Record "New Confirmed Order"): Integer
    begin
        StartDt := TODAY;

        NewConfirmedOrder_2.RESET;
        IF NewConfirmedOrder_2.GET(NewConfirmedOrder."No.") THEN BEGIN
            Updationofplotdetails.RESET;
            // IF NOT Updationofplotdetails.GET(NewConfirmedOrder_2."No.") THEN BEGIN
            If updationofplotdetails.Get(NewConfirmedOrder_2."No.") Then begin
                Exit(updationofplotdetails."No. Of Days")
            End else begin
                ResponsibilityCenter.RESET;

                IF ResponsibilityCenter.GET(NewConfirmedOrder."Shortcut Dimension 1 Code") THEN BEGIN
                    // ResponsibilityCenter.TESTFIELD(ResponsibilityCenter."Min. Amt. Single plot for Web");
                    // ResponsibilityCenter.TESTFIELD("Min. Amt. Double plot for Web");
                    // ResponsibilityCenter.TESTFIELD("Min. Amt. Days (First Day)");
                    // ResponsibilityCenter.TESTFIELD("Min. Amt. Option Change Day");
                    // ResponsibilityCenter.TESTFIELD("Option A Days (First Days)");
                    // ResponsibilityCenter.TESTFIELD("Option A Option Change Days");
                    // ResponsibilityCenter.TESTFIELD("Option B Days (First Days)");
                    // ResponsibilityCenter.TESTFIELD("Option B Option Change Days");
                    // ResponsibilityCenter.TESTFIELD("Option C Days (First Days)");
                    // ResponsibilityCenter.TESTFIELD("Option C Option Change Days");
                    // ResponsibilityCenter.TESTFIELD("Allotment Amt Days (First Day)");
                    // ResponsibilityCenter.TESTFIELD("Allotment Amt. Change Days");   //Comment code 110325
                END;

                NewConfirmedOrder.CALCFIELDS("Total Received Amount");
                IF NewConfirmedOrder.Amount > NewConfirmedOrder."Total Received Amount" THEN BEGIN
                    IF ABS(NewConfirmedOrder.Amount - NewConfirmedOrder."Total Received Amount") > 10 THEN BEGIN
                        DueDate := 0D;
                        EndDate := 0D;
                        MinAmount := 0;
                        DataInsert := FALSE;
                        DueDate := NewConfirmedOrder."Posting Date";
                        IF NewConfirmedOrder."Saleable Area" < 293.33 THEN
                            MinAmount := ResponsibilityCenter."Min. Amt. Single plot for Web"
                        ELSE
                            MinAmount := ResponsibilityCenter."Min. Amt. Double plot for Web";

                        IF NewConfirmedOrder."Total Received Amount" < MinAmount THEN BEGIN
                            EndDate := NewConfirmedOrder."Posting Date" + ResponsibilityCenter."Min. Amt. Option Change Day";
                            DueDate := NewConfirmedOrder."Posting Date" + ResponsibilityCenter."Min. Amt. Days (First Day)";

                            IF (StartDt >= DueDate) AND (StartDt <= EndDate) THEN BEGIN
                                TestNoofdays.INIT;
                                TestNoofdays."Application No." := NewConfirmedOrder."No.";
                                TestNoofdays."Plot No." := NewConfirmedOrder."Unit Code";
                                TestNoofdays."No. of Days" := (EndDate - StartDt);
                                TestNoofdays."Start Date" := DueDate;
                                TestNoofdays."End Date" := EndDate;
                                TestNoofdays."Total Amount" := NewConfirmedOrder.Amount;
                                TestNoofdays."Received Amount" := NewConfirmedOrder."Total Received Amount";
                                TestNoofdays."Min. allotment Amount" := NewConfirmedOrder."Min. Allotment Amount";
                                TestNoofdays."Creation Date Time" := CURRENTDATETIME;
                                TestNoofdays.INSERT;
                                DataInsert := TRUE;
                            END ELSE
                                IF (NOT DataInsert) AND (StartDt > EndDate) THEN BEGIN
                                    TestNoofdays.INIT;
                                    TestNoofdays."Application No." := NewConfirmedOrder."No.";
                                    TestNoofdays."Plot No." := NewConfirmedOrder."Unit Code";
                                    TestNoofdays."No. of Days" := (EndDate - StartDt);
                                    TestNoofdays."Start Date" := DueDate;
                                    TestNoofdays."End Date" := EndDate;
                                    TestNoofdays."Total Amount" := NewConfirmedOrder.Amount;
                                    TestNoofdays."Received Amount" := NewConfirmedOrder."Total Received Amount";
                                    TestNoofdays."Min. allotment Amount" := NewConfirmedOrder."Min. Allotment Amount";
                                    TestNoofdays."Creation Date Time" := CURRENTDATETIME;
                                    TestNoofdays.INSERT;
                                    DataInsert := TRUE;
                                END ELSE
                                    IF (NOT DataInsert) AND (StartDt < EndDate) THEN BEGIN
                                        TestNoofdays.INIT;
                                        TestNoofdays."Application No." := NewConfirmedOrder."No.";
                                        TestNoofdays."Plot No." := NewConfirmedOrder."Unit Code";
                                        TestNoofdays."No. of Days" := (EndDate - StartDt);
                                        TestNoofdays."Start Date" := DueDate;
                                        TestNoofdays."End Date" := EndDate;
                                        TestNoofdays."Total Amount" := NewConfirmedOrder.Amount;
                                        TestNoofdays."Received Amount" := NewConfirmedOrder."Total Received Amount";
                                        TestNoofdays."Min. allotment Amount" := NewConfirmedOrder."Min. Allotment Amount";
                                        TestNoofdays."Creation Date Time" := CURRENTDATETIME;
                                        TestNoofdays.INSERT;
                                        DataInsert := TRUE;
                                    END;

                        END;

                        IF (NewConfirmedOrder."Total Received Amount" < NewConfirmedOrder."Min. Allotment Amount") AND (NOT DataInsert) THEN BEGIN
                            EndDate := NewConfirmedOrder."Posting Date" + ResponsibilityCenter."Allotment Amt. Change Days";
                            DueDate := NewConfirmedOrder."Posting Date" + ResponsibilityCenter."Allotment Amt Days (First Day)";
                            IF (StartDt >= DueDate) AND (StartDt <= EndDate) THEN BEGIN
                                TestNoofdays.INIT;
                                TestNoofdays."Application No." := NewConfirmedOrder."No.";
                                TestNoofdays."Plot No." := NewConfirmedOrder."Unit Code";
                                TestNoofdays."No. of Days" := (EndDate - StartDt);
                                TestNoofdays."Start Date" := DueDate;
                                TestNoofdays."End Date" := EndDate;
                                TestNoofdays."Total Amount" := NewConfirmedOrder.Amount;
                                TestNoofdays."Received Amount" := NewConfirmedOrder."Total Received Amount";
                                TestNoofdays."Min. allotment Amount" := NewConfirmedOrder."Min. Allotment Amount";
                                TestNoofdays."Creation Date Time" := CURRENTDATETIME;
                                TestNoofdays.INSERT;
                                DataInsert := TRUE;
                            END ELSE
                                IF (NOT DataInsert) AND (StartDt > EndDate) THEN BEGIN
                                    TestNoofdays.INIT;
                                    TestNoofdays."Application No." := NewConfirmedOrder."No.";
                                    TestNoofdays."Plot No." := NewConfirmedOrder."Unit Code";
                                    TestNoofdays."No. of Days" := (EndDate - StartDt);
                                    TestNoofdays."Start Date" := DueDate;
                                    TestNoofdays."End Date" := EndDate;
                                    TestNoofdays."Total Amount" := NewConfirmedOrder.Amount;
                                    TestNoofdays."Received Amount" := NewConfirmedOrder."Total Received Amount";
                                    TestNoofdays."Min. allotment Amount" := NewConfirmedOrder."Min. Allotment Amount";
                                    TestNoofdays."Creation Date Time" := CURRENTDATETIME;
                                    TestNoofdays.INSERT;
                                    DataInsert := TRUE;
                                END ELSE
                                    IF (NOT DataInsert) AND (StartDt < EndDate) THEN BEGIN
                                        TestNoofdays.INIT;
                                        TestNoofdays."Application No." := NewConfirmedOrder."No.";
                                        TestNoofdays."Plot No." := NewConfirmedOrder."Unit Code";
                                        TestNoofdays."No. of Days" := (EndDate - StartDt);
                                        TestNoofdays."Start Date" := DueDate;
                                        TestNoofdays."End Date" := EndDate;
                                        TestNoofdays."Total Amount" := NewConfirmedOrder.Amount;
                                        TestNoofdays."Received Amount" := NewConfirmedOrder."Total Received Amount";
                                        TestNoofdays."Min. allotment Amount" := NewConfirmedOrder."Min. Allotment Amount";
                                        TestNoofdays."Creation Date Time" := CURRENTDATETIME;
                                        TestNoofdays.INSERT;
                                        DataInsert := TRUE;
                                    END;
                        END;


                        IF (NewConfirmedOrder."Unit Payment Plan" = '1006') AND (NOT DataInsert) THEN BEGIN
                            EndDate := NewConfirmedOrder."Posting Date" + ResponsibilityCenter."Option A Option Change Days";
                            DueDate := NewConfirmedOrder."Posting Date" + ResponsibilityCenter."Option A Days (First Days)";
                            IF (StartDt >= DueDate) AND (StartDt <= EndDate) THEN BEGIN
                                TestNoofdays.INIT;
                                TestNoofdays."Application No." := NewConfirmedOrder."No.";
                                TestNoofdays."Plot No." := NewConfirmedOrder."Unit Code";
                                TestNoofdays."No. of Days" := (EndDate - StartDt);
                                TestNoofdays."Start Date" := DueDate;
                                TestNoofdays."End Date" := EndDate;
                                TestNoofdays."Total Amount" := NewConfirmedOrder.Amount;
                                TestNoofdays."Received Amount" := NewConfirmedOrder."Total Received Amount";
                                TestNoofdays."Min. allotment Amount" := NewConfirmedOrder."Min. Allotment Amount";
                                TestNoofdays."Creation Date Time" := CURRENTDATETIME;
                                TestNoofdays.INSERT;
                                DataInsert := TRUE;

                            END ELSE
                                IF (NOT DataInsert) AND (StartDt > EndDate) THEN BEGIN
                                    TestNoofdays.INIT;
                                    TestNoofdays."Application No." := NewConfirmedOrder."No.";
                                    TestNoofdays."Plot No." := NewConfirmedOrder."Unit Code";
                                    TestNoofdays."No. of Days" := (EndDate - StartDt);
                                    TestNoofdays."Start Date" := DueDate;
                                    TestNoofdays."End Date" := EndDate;
                                    TestNoofdays."Total Amount" := NewConfirmedOrder.Amount;
                                    TestNoofdays."Received Amount" := NewConfirmedOrder."Total Received Amount";
                                    TestNoofdays."Min. allotment Amount" := NewConfirmedOrder."Min. Allotment Amount";
                                    TestNoofdays."Creation Date Time" := CURRENTDATETIME;
                                    TestNoofdays.INSERT;
                                    DataInsert := TRUE;
                                END ELSE
                                    IF (NOT DataInsert) AND (StartDt < EndDate) THEN BEGIN
                                        TestNoofdays.INIT;
                                        TestNoofdays."Application No." := NewConfirmedOrder."No.";
                                        TestNoofdays."Plot No." := NewConfirmedOrder."Unit Code";
                                        TestNoofdays."No. of Days" := (EndDate - StartDt);
                                        TestNoofdays."Start Date" := DueDate;
                                        TestNoofdays."End Date" := EndDate;
                                        TestNoofdays."Total Amount" := NewConfirmedOrder.Amount;
                                        TestNoofdays."Received Amount" := NewConfirmedOrder."Total Received Amount";
                                        TestNoofdays."Min. allotment Amount" := NewConfirmedOrder."Min. Allotment Amount";
                                        TestNoofdays."Creation Date Time" := CURRENTDATETIME;
                                        TestNoofdays.INSERT;
                                        DataInsert := TRUE;
                                    END;
                        END;
                        IF (NewConfirmedOrder."Unit Payment Plan" = '1007') AND (NOT DataInsert) THEN BEGIN
                            EndDate := NewConfirmedOrder."Posting Date" + ResponsibilityCenter."Option B Option Change Days";
                            DueDate := NewConfirmedOrder."Posting Date" + ResponsibilityCenter."Option B Days (First Days)";
                            IF (StartDt >= DueDate) AND (StartDt <= EndDate) THEN BEGIN
                                TestNoofdays.INIT;
                                TestNoofdays."Application No." := NewConfirmedOrder."No.";
                                TestNoofdays."Plot No." := NewConfirmedOrder."Unit Code";
                                TestNoofdays."No. of Days" := (EndDate - StartDt);
                                TestNoofdays."Start Date" := DueDate;
                                TestNoofdays."End Date" := EndDate;
                                TestNoofdays."Total Amount" := NewConfirmedOrder.Amount;
                                TestNoofdays."Received Amount" := NewConfirmedOrder."Total Received Amount";
                                TestNoofdays."Min. allotment Amount" := NewConfirmedOrder."Min. Allotment Amount";
                                TestNoofdays."Creation Date Time" := CURRENTDATETIME;
                                TestNoofdays.INSERT;
                                DataInsert := TRUE;
                            END ELSE
                                IF (NOT DataInsert) AND (StartDt > EndDate) THEN BEGIN
                                    TestNoofdays.INIT;
                                    TestNoofdays."Application No." := NewConfirmedOrder."No.";
                                    TestNoofdays."Plot No." := NewConfirmedOrder."Unit Code";
                                    TestNoofdays."No. of Days" := (EndDate - StartDt);
                                    TestNoofdays."Start Date" := DueDate;
                                    TestNoofdays."End Date" := EndDate;
                                    TestNoofdays."Total Amount" := NewConfirmedOrder.Amount;
                                    TestNoofdays."Received Amount" := NewConfirmedOrder."Total Received Amount";
                                    TestNoofdays."Min. allotment Amount" := NewConfirmedOrder."Min. Allotment Amount";
                                    TestNoofdays."Creation Date Time" := CURRENTDATETIME;
                                    TestNoofdays.INSERT;
                                    DataInsert := TRUE;
                                END ELSE
                                    IF (NOT DataInsert) AND (StartDt < EndDate) THEN BEGIN
                                        TestNoofdays.INIT;
                                        TestNoofdays."Application No." := NewConfirmedOrder."No.";
                                        TestNoofdays."Plot No." := NewConfirmedOrder."Unit Code";
                                        TestNoofdays."No. of Days" := (EndDate - StartDt);
                                        TestNoofdays."Start Date" := DueDate;
                                        TestNoofdays."End Date" := EndDate;
                                        TestNoofdays."Total Amount" := NewConfirmedOrder.Amount;
                                        TestNoofdays."Received Amount" := NewConfirmedOrder."Total Received Amount";
                                        TestNoofdays."Min. allotment Amount" := NewConfirmedOrder."Min. Allotment Amount";
                                        TestNoofdays."Creation Date Time" := CURRENTDATETIME;
                                        TestNoofdays.INSERT;
                                        DataInsert := TRUE;
                                    END;
                        END;
                        IF (NewConfirmedOrder."Unit Payment Plan" = '1008') AND (NOT DataInsert) THEN BEGIN
                            EndDate := NewConfirmedOrder."Posting Date" + ResponsibilityCenter."Option C Option Change Days";
                            DueDate := NewConfirmedOrder."Posting Date" + ResponsibilityCenter."Option C Days (First Days)";
                            IF (StartDt >= DueDate) AND (StartDt <= EndDate) THEN BEGIN
                                TestNoofdays.INIT;
                                TestNoofdays."Application No." := NewConfirmedOrder."No.";
                                TestNoofdays."Plot No." := NewConfirmedOrder."Unit Code";
                                TestNoofdays."No. of Days" := (EndDate - StartDt);
                                TestNoofdays."Start Date" := DueDate;
                                TestNoofdays."End Date" := EndDate;
                                TestNoofdays."Total Amount" := NewConfirmedOrder.Amount;
                                TestNoofdays."Received Amount" := NewConfirmedOrder."Total Received Amount";
                                TestNoofdays."Min. allotment Amount" := NewConfirmedOrder."Min. Allotment Amount";
                                TestNoofdays."Creation Date Time" := CURRENTDATETIME;
                                TestNoofdays.INSERT;
                                DataInsert := TRUE;
                            END ELSE
                                IF (NOT DataInsert) AND (StartDt > EndDate) THEN BEGIN
                                    TestNoofdays.INIT;
                                    TestNoofdays."Application No." := NewConfirmedOrder."No.";
                                    TestNoofdays."Plot No." := NewConfirmedOrder."Unit Code";
                                    TestNoofdays."No. of Days" := (EndDate - StartDt);
                                    TestNoofdays."Start Date" := DueDate;
                                    TestNoofdays."End Date" := EndDate;
                                    TestNoofdays."Total Amount" := NewConfirmedOrder.Amount;
                                    TestNoofdays."Received Amount" := NewConfirmedOrder."Total Received Amount";
                                    TestNoofdays."Min. allotment Amount" := NewConfirmedOrder."Min. Allotment Amount";
                                    TestNoofdays."Creation Date Time" := CURRENTDATETIME;
                                    TestNoofdays.INSERT;
                                    DataInsert := TRUE;
                                END ELSE
                                    IF (NOT DataInsert) AND (StartDt < EndDate) THEN BEGIN
                                        TestNoofdays.INIT;
                                        TestNoofdays."Application No." := NewConfirmedOrder."No.";
                                        TestNoofdays."Plot No." := NewConfirmedOrder."Unit Code";
                                        TestNoofdays."No. of Days" := (EndDate - StartDt);
                                        TestNoofdays."Start Date" := DueDate;
                                        TestNoofdays."End Date" := EndDate;
                                        TestNoofdays."Total Amount" := NewConfirmedOrder.Amount;
                                        TestNoofdays."Received Amount" := NewConfirmedOrder."Total Received Amount";
                                        TestNoofdays."Min. allotment Amount" := NewConfirmedOrder."Min. Allotment Amount";
                                        TestNoofdays."Creation Date Time" := CURRENTDATETIME;
                                        TestNoofdays.INSERT;
                                        DataInsert := TRUE;
                                    END;
                        END;
                    END;
                END;
            END;
        END;
        EXIT(TestNoofdays."No. of Days");
    end;
}