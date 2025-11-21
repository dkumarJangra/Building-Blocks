page 97779 "Payment Plan Details Master"
{
    // BLK2.01 ALLEPG 250111 : Added "Due date calculation Date", "Actual Date".

    DelayedInsert = true;
    Editable = false;
    PageType = Card;
    SourceTable = "Payment Plan Details";
    SourceTableView = SORTING("Milestone Code", "Payment Plan Code", "Charge Code")
                      ORDER(Ascending);
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                    Style = Unfavorable;
                    StyleExpr = TRUE;
                }
                field("Project Code"; Rec."Project Code")
                {
                    Visible = false;
                }
                field("Due Date Calculation"; Rec."Due Date Calculation")
                {
                }
                field("Send SMS Cust for Due Amount"; Rec."Send SMS Cust for Due Amount")
                {
                }
                field("Actual Date"; Rec."Actual Date")
                {
                }
                field("Commision Applicable"; Rec."Commision Applicable")
                {
                }
                field("Direct Associate"; Rec."Direct Associate")
                {
                }
                field("Payment Plan Code"; Rec."Payment Plan Code")
                {
                    Editable = false;
                }
                field("Milestone Code"; Rec."Milestone Code")
                {
                    Editable = false;
                }
                field("Milestone Description"; Rec."Milestone Description")
                {
                    Editable = false;
                }
                field("Charge Code"; Rec."Charge Code")
                {
                    Editable = false;
                }
                field("Charge %"; Rec."Charge %")
                {
                    Editable = false;
                    Style = Unfavorable;
                    StyleExpr = TRUE;
                }
                field("Fixed Amount"; Rec."Fixed Amount")
                {
                    Editable = false;
                    Style = Unfavorable;
                    StyleExpr = TRUE;
                }
                field("Total Charge Amount"; Rec."Total Charge Amount")
                {
                    Editable = false;
                }
                field("Milestone Charge Amount"; Rec."Milestone Charge Amount")
                {
                    Editable = false;
                }
                field("Project Milestone Due Date"; Rec."Project Milestone Due Date")
                {
                }
                field("Buffer Days for AutoPlot Vacat"; Rec."Buffer Days for AutoPlot Vacat")
                {
                }
                field("Auto Plot Vacate Due Date"; Rec."Auto Plot Vacate Due Date")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Update &Milestone Amounts")
                {
                    Caption = 'Update &Milestone Amounts';

                    trigger OnAction()
                    begin
                        IF CONFIRM('Do you want to update the Milestone Amount in Payment Plan Details', TRUE) THEN BEGIN
                            TotalAmount := 0;
                            /*
                            AppCharRec.RESET;
                            //AppCharRec.SETFILTER(AppCharRec."Project Code","Project Code");
                            AppCharRec.SETFILTER(AppCharRec."Document No.","Document No.");
                            IF AppCharRec.FINDFIRST THEN
                             REPEAT
                              RESET;
                              SETFILTER("Project Code",AppCharRec."Project Code");
                              SETFILTER("Document No.",AppCharRec."Document No.");
                              SETFILTER("Charge Code",AppCharRec.Code);
                              IF FINDFIRST THEN
                                REPEAT
                                 "Total Charge Amount":=AppCharRec."Net Amount";
                                 VALIDATE("Total Charge Amount");
                                 MODIFY;
                                UNTIL NEXT=0;
                             UNTIL AppCharRec.NEXT=0;
                             */
                            Application.GET(Rec."Document No.");

                            Rec.RESET;
                            Rec.SETFILTER("Project Code", Rec."Project Code");
                            Rec.SETFILTER("Document No.", Rec."Document No.");
                            //SETFILTER("Charge Code",Code);
                            IF Rec.FINDFIRST THEN
                                REPEAT
                                    IF Rec."Percentage Cum" > 0 THEN BEGIN
                                        Rec."Total Charge Amount" := (Application."Investment Amount" * Rec."Percentage Cum" / 100) - TotalAmount;
                                    END;
                                    IF Rec."Fixed Amount" <> 0 THEN BEGIN
                                        Rec."Total Charge Amount" := Rec."Fixed Amount";
                                    END;

                                    TotalAmount := Rec."Total Charge Amount" + TotalAmount;
                                    //"Total Charge Amount":=AppCharRec."Net Amount";
                                    Rec.VALIDATE("Total Charge Amount");
                                    Rec.MODIFY;
                                UNTIL Rec.NEXT = 0;

                        END;

                        Rec.RESET;
                        //SETFILTER("Project Code",AppCharRec."Project Code");
                        Rec.SETFILTER("Document No.", Rec."Document No.");

                    end;
                }

            }
        }
    }

    var
        PaymentPlanDetails: Record "Payment Plan Details";
        PaymentPlanDetails1: Record "Payment Plan Details";
        PayTermLine: Record "Payment Terms Line Sale";
        a: Integer;
        AppCharRec: Record "Applicable Charges";
        Application: Record Application;
        TotalAmount: Decimal;
}

