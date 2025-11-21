report 97911 "Allow Auto Plot Vacate Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/Allow Auto Plot Vacate Report.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("New Confirmed Order"; "New Confirmed Order")
        {
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin

                TESTFIELD(Status, Status::Open);
                IF NOT "Allow Auto Plot Vacate" THEN BEGIN
                    "Allow Auto Plot Vacate" := TRUE;
                END;
                // ELSE IF "Allow Auto Plot Vacate" THEN
                //"Allow Auto Plot Vacate" := FALSE;

                PayTermLineSale.RESET;
                PayTermLineSale.CHANGECOMPANY("Company Name");
                PayTermLineSale.SETRANGE("Document No.", "No.");
                PayTermLineSale.SETRANGE("Transaction Type", PayTermLineSale."Transaction Type"::Sale);
                IF PayTermLineSale.FINDSET THEN BEGIN
                    REPEAT
                        PayTermLineSale."Allow Auto Plot Vacate" := TRUE;
                        PaymentPlanDetails_1.RESET;
                        PaymentPlanDetails_1.SETRANGE("Document No.", PayTermLineSale."Document No.");
                        PaymentPlanDetails_1.SETRANGE("Milestone Code", PayTermLineSale."Actual Milestone");
                        IF PaymentPlanDetails_1.FINDFIRST THEN BEGIN
                            PayTermLineSale."Buffer Days for AutoPlot Vacat" := PaymentPlanDetails_1."Buffer Days for AutoPlot Vacat";
                            PayTermLineSale."Auto Plot Vacate Due Date" := PaymentPlanDetails_1."Auto Plot Vacate Due Date";
                        END;
                        PayTermLineSale.MODIFY;
                    UNTIL PayTermLineSale.NEXT = 0;

                END;

                MODIFY;
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

    trigger OnPreReport()
    begin
        Docfilters := '';
        Docfilters := "New Confirmed Order".GETFILTER("No.");
        IF Docfilters = '' THEN
            ERROR('Please provide the filter in No. field');
    end;

    var
        PayTermLineSale: Record "Payment Terms Line Sale";
        PaymentPlanDetails_1: Record "Payment Plan Details";
        Docfilters: Text[1000];
}

