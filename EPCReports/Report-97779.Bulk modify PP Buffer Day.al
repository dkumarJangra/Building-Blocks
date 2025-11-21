report 97779 "Bulk modify PP Buffer Day"
{
    // version APTOL

    DefaultLayout = RDLC;
    RDLCLayout = './Reports/Bulk modify PP Buffer Day.rdl';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Payment Plan Details"; "Payment Plan Details")
        {
            DataItemTableView = WHERE("Document No." = FILTER(''));
            RequestFilterFields = "Project Code";

            trigger OnAfterGetRecord()
            begin
                PaymentPlanDetails.RESET;
                PaymentPlanDetails.SETRANGE("Project Code", "Project Code");
                PaymentPlanDetails.SETRANGE("Payment Plan Code", "Payment Plan Code");
                PaymentPlanDetails.SETRANGE("Milestone Code", "Milestone Code");
                //PaymentPlanDetails.SETRANGE("Due Date Calculation","Due Date Calculation");
                PaymentPlanDetails.SETRANGE("Sub Payment Plan", "Sub Payment Plan");
                PaymentPlanDetails.SETFILTER("Document No.", '<>%1', '');
                //PaymentPlanDetails.SETFILTER("Document No.",'%1','AP2021002977');
                IF PaymentPlanDetails.FINDSET THEN
                    REPEAT
                        PaymentPlanDetails."Buffer Days for AutoPlot Vacat" := "Payment Plan Details"."Buffer Days for AutoPlot Vacat";
                        IF FORMAT("Payment Plan Details"."Buffer Days for AutoPlot Vacat") <> '' THEN
                            PaymentPlanDetails."Auto Plot Vacate Due Date" := CALCDATE("Buffer Days for AutoPlot Vacat", PaymentPlanDetails."Project Milestone Due Date")
                        ELSE
                            PaymentPlanDetails."Auto Plot Vacate Due Date" := PaymentPlanDetails."Project Milestone Due Date";
                        PaymentPlanDetails.MODIFY;
                    UNTIL PaymentPlanDetails.NEXT = 0;
            end;
        }
        dataitem("Confirmed Order"; "Confirmed Order")
        {
            RequestFilterFields = "Shortcut Dimension 1 Code";
            dataitem("Application wise update"; "Payment Plan Details")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.");
                dataitem("Payment Terms Line Sale"; "Payment Terms Line Sale")
                {
                    DataItemLink = "Document No." = FIELD("Document No."),
                                   "Actual Milestone" = FIELD("Milestone Code");
                    DataItemTableView = SORTING("Document Type", "Document No.", Sequence);

                    trigger OnAfterGetRecord()
                    begin
                        IF NewConfirmedOrder.GET("Payment Terms Line Sale"."Document No.") THEN BEGIN
                            NewConfirmedOrder."Allow Auto Plot Vacate" := TRUE;
                            NewConfirmedOrder.MODIFY;
                        END;
                        "Payment Terms Line Sale"."Allow Auto Plot Vacate" := TRUE;
                        IF "Payment Terms Line Sale"."Auto Plot Vacate Due Date" = 0D THEN BEGIN
                            "Payment Terms Line Sale"."Buffer Days for AutoPlot Vacat" := "Application wise update"."Buffer Days for AutoPlot Vacat";
                            "Payment Terms Line Sale"."Auto Plot Vacate Due Date" := "Application wise update"."Auto Plot Vacate Due Date";
                        END;
                        MODIFY;
                    end;
                }
            }
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
        MESSAGE('Done');
    end;

    var
        PaymentPlanDetails: Record "Payment Plan Details";
        NewConfirmedOrder: Record "New Confirmed Order";
}

