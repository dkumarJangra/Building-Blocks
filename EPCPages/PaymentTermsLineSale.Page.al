page 97771 "Payment Terms Line Sale"
{
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    SourceTable = "Payment Terms Line Sale";
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
                    Editable = "Document No.Editable";
                }
                field("Commision Applicable"; Rec."Commision Applicable")
                {
                    Editable = "Commision ApplicableEditable";
                }
                field("Direct Associate"; Rec."Direct Associate")
                {
                    Editable = "Direct AssociateEditable";
                }
                field("Charge Code"; Rec."Charge Code")
                {
                    Editable = false;
                }
                field("Criteria Value / Base Amount"; Rec."Criteria Value / Base Amount")
                {
                    Editable = CriteriaValueBaseAmountEditabl;
                }
                field("Comm Generated on Old App"; Rec."Comm Generated on Old App")
                {
                }
                field("Received Amt"; Rec."Received Amt")
                {
                }
                field(RemainingAmt; RemainingAmt)
                {
                    Caption = 'Remaining Amount';
                    Editable = false;
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    Editable = "Payment TypeEditable";
                }
                field(Sequence; Rec.Sequence)
                {
                    Editable = SequenceEditable;
                }
                field("Actual Milestone"; Rec."Actual Milestone")
                {
                    Editable = "Actual MilestoneEditable";
                }
                field("Due Amount"; Rec."Due Amount")
                {
                    Editable = "Due AmountEditable";
                }
                field("First Milestone %"; Rec."First Milestone %")
                {
                }
                field("Second Milestone %"; Rec."Second Milestone %")
                {
                    Editable = "Second Milestone %Editable";
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("Calculation Value"; Rec."Calculation Value")
                {
                    Editable = "Calculation ValueEditable";
                }
                field("Fixed Amount"; Rec."Fixed Amount")
                {
                    Editable = false;
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    Caption = 'Discount/Tax Adjustment Amout';
                }
                field("Due Date"; Rec."Due Date")
                {
                    Editable = "Due DateEditable";
                }
                field("Allow Auto Plot Vacate"; Rec."Allow Auto Plot Vacate")
                {
                    Editable = true;
                }
                field("Buffer Days for AutoPlot Vacat"; Rec."Buffer Days for AutoPlot Vacat")
                {
                    Editable = true;
                }
                field("Auto Plot Vacate Due Date"; Rec."Auto Plot Vacate Due Date")
                {
                }
                field("Buffer Days"; Rec."Buffer Days")
                {
                }
                field("Discount %"; Rec."Discount %")
                {
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("F&unction")
            {
                Caption = 'F&unction';
                action("Archive Payment Milestones")
                {
                    Caption = 'Archive Payment Milestones';
                    RunObject = Page "Archive payment Milestones";
                    RunPageLink = "Document No." = FIELD("Document No.");
                }
            }
        }
        area(processing)
        {
            action("Refresh Amount")
            {
                Caption = 'Refresh Amount';
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin

                    PaymentTermLines.SETRANGE("Document Type", Rec."Document Type");
                    PaymentTermLines.SETRANGE("Document No.", Rec."Document No.");

                    IF PaymentTermLines.FIND('-') THEN BEGIN
                        REPEAT
                            PaymentTermLines.CalculateCriteriaValue;
                            PaymentTermLines.MODIFY;
                        UNTIL PaymentTermLines.NEXT = 0;
                    END;
                    CurrPage.UPDATE(TRUE);

                    /*
                    SETRANGE("Document Type","Document Type");
                    SETRANGE("Document No.","Document No.");
                    IF FIND('-') THEN BEGIN
                      REPEAT
                        //VALIDATE("Calculation Value");
                        CalculateCriteriaValue;
                        MODIFY;
                      UNTIL NEXT=0;
                    END;
                    */

                end;
            }
            action("Insert Milestone")
            {
                Caption = 'Insert Milestone';
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                var
                    TotalAmount: Decimal;
                    LoopingAmount: Decimal;
                begin
                    TotalAmount := 0;
                    OldMileStone := '';
                    PaymentTermLines.RESET;
                    PaymentTermLines.SETRANGE("Document No.", Rec."Document No.");
                    IF PaymentTermLines.FIND('-') THEN
                        //IF CONFIRM('Overwrite Milestones?') THEN
                        //  PaymentTermLines.DELETEALL
                        //ELSE
                        //  EXIT;
                        ERROR('Please delete the existing Milestone');
                    Sno := '001';
                    IF SalesHeader.GET(Rec."Document No.") THEN BEGIN
                        PaymentPlanDetails2.RESET;
                        PaymentPlanDetails2.DELETEALL;
                        PaymentPlanDetails.RESET;
                        PaymentPlanDetails.SETRANGE("Payment Plan Code", SalesHeader."Payment Plan");
                        PaymentPlanDetails.SETRANGE("Document No.", Rec."Document No.");
                        IF PaymentPlanDetails.FINDSET THEN
                            REPEAT
                                PaymentPlanDetails2.COPY(PaymentPlanDetails);
                                TotalAmount := TotalAmount + PaymentPlanDetails2."Milestone Charge Amount";
                                PaymentPlanDetails2.INSERT;
                            UNTIL PaymentPlanDetails.NEXT = 0;

                        Applicablecharge.RESET;
                        Applicablecharge.SETCURRENTKEY("Document No.", Applicablecharge.Sequence);
                        Applicablecharge.SETRANGE("Document No.", Rec."Document No.");
                        Applicablecharge.SETRANGE(Applicable, TRUE);
                        IF Applicablecharge.FINDSET THEN BEGIN
                            MilestoneCodeG := '1';
                            PaymentPlanDetails2.RESET;
                            PaymentPlanDetails2.SETRANGE("Payment Plan Code", SalesHeader."Payment Plan");
                            PaymentPlanDetails2.SETRANGE("Document No.", Rec."Document No.");
                            PaymentPlanDetails2.SETRANGE(Checked, FALSE);
                            IF PaymentPlanDetails2.FINDSET THEN
                                REPEAT
                                    LoopingAmount := 0;
                                    REPEAT
                                        IF Applicablecharge."Net Amount" = PaymentPlanDetails2."Milestone Charge Amount" THEN BEGIN
                                            Rec.CreatePaymentTermsLine(PaymentPlanDetails2."Milestone Code", PaymentPlanDetails2."Milestone Description",
                                            PaymentPlanDetails2."Project Milestone Due Date", PaymentPlanDetails2."Milestone Charge Amount",
                                            Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate");
                                            PaymentPlanDetails2.Checked := TRUE;
                                            PaymentPlanDetails2.MODIFY;
                                            //Applicablecharge.NEXT;
                                            //PaymentPlanDetails2.NEXT;
                                            TotalAmount := TotalAmount - PaymentPlanDetails2."Milestone Charge Amount";
                                            InLoop := TRUE;
                                        END;
                                        IF Applicablecharge."Net Amount" > PaymentPlanDetails2."Milestone Charge Amount" THEN BEGIN
                                            Rec.CreatePaymentTermsLine(PaymentPlanDetails2."Milestone Code", PaymentPlanDetails2."Milestone Description",
                                            PaymentPlanDetails2."Project Milestone Due Date", PaymentPlanDetails2."Milestone Charge Amount",
                                            Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate");
                                            PaymentPlanDetails2.Checked := TRUE;
                                            PaymentPlanDetails2.MODIFY;

                                            TotalAmount := TotalAmount - PaymentPlanDetails2."Milestone Charge Amount";//ALLE PS
                                            LoopingAmount := 0;

                                            Applicablecharge."Net Amount" := Applicablecharge."Net Amount" -
                                              PaymentPlanDetails2."Milestone Charge Amount";

                                            //PaymentPlanDetails2.NEXT;
                                            InLoop := TRUE;
                                        END ELSE
                                            IF Applicablecharge."Net Amount" < PaymentPlanDetails2."Milestone Charge Amount" THEN BEGIN
                                                Rec.CreatePaymentTermsLine(PaymentPlanDetails2."Milestone Code", PaymentPlanDetails2."Milestone Description",
                                                PaymentPlanDetails2."Project Milestone Due Date", Applicablecharge."Net Amount",
                                                Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate");
                                                //PaymentPlanDetails2.Checked := TRUE;

                                                TotalAmount := TotalAmount - Applicablecharge."Net Amount";//ALLE PS
                                                LoopingAmount := PaymentPlanDetails2."Milestone Charge Amount" - Applicablecharge."Net Amount";

                                                PaymentPlanDetails2."Milestone Charge Amount" := PaymentPlanDetails2."Milestone Charge Amount" -
                                                Applicablecharge."Net Amount";
                                                PaymentPlanDetails2.MODIFY;
                                                //Applicablecharge.NEXT;
                                                Applicablecharge."Net Amount" := 0;
                                                //PaymentPlanDetails2.NEXT(-1);

                                                InLoop := TRUE;
                                            END;
                                        IF Applicablecharge."Net Amount" = 0 THEN BEGIN
                                            Applicablecharge.NEXT;
                                        END;

                                    UNTIL (LoopingAmount = 0) OR (TotalAmount = 0);
                                UNTIL (PaymentPlanDetails2.NEXT = 0) OR (TotalAmount = 0);

                            //   UNTIL PaymentPlanDetails2.NEXT=0;

                        END;


                    END;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec."Transaction Type" := Rec."Transaction Type"::Sale;
        RemainingAmt := 0;
        RemainingBrokerageAmt := 0;
        RemainingAmt := Rec."Due Amount" - Rec."Received Amt" - Rec."Discount Amount";
        RemainingBrokerageAmt := Rec."Brokerage Amount" - Rec."Brokerage Paid Amt";
    end;

    trigger OnInit()
    begin
        "Calculation ValueEditable" := TRUE;
        AdjustEditable := TRUE;
        "Due Date CalculationEditable" := TRUE;
        "Brokerage %Editable" := TRUE;
        "Due DateEditable" := TRUE;
        "Payment Term CodeEditable" := TRUE;
        "Second Milestone %Editable" := TRUE;
        "Actual MilestoneEditable" := TRUE;
        "Payment TypeEditable" := TRUE;
        SequenceEditable := TRUE;
        "Charge CodeEditable" := TRUE;
        "Direct AssociateEditable" := TRUE;
        "Commision ApplicableEditable" := TRUE;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Transaction Type" := Rec."Transaction Type"::Sale;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Transaction Type" := Rec."Transaction Type"::Sale;
    end;

    trigger OnOpenPage()
    begin
        "Document No.Editable" := FALSE;
        "Commision ApplicableEditable" := FALSE;
        "Direct AssociateEditable" := FALSE;
        "Charge CodeEditable" := FALSE;
        SequenceEditable := FALSE;
        "Payment TypeEditable" := FALSE;
        "Actual MilestoneEditable" := FALSE;
        "Second Milestone %Editable" := FALSE;
        "Payment Term CodeEditable" := FALSE;
        CriteriaValueBaseAmountEditabl := FALSE;
        "Due AmountEditable" := FALSE;
        "Due DateEditable" := FALSE;
        "Brokerage %Editable" := FALSE;
        "Due Date CalculationEditable" := FALSE;
        AdjustEditable := FALSE;
        "Calculation ValueEditable" := FALSE;
    end;

    var
        SalesHeader: Record Application;
        PaymentTermLine: Record "Payment Terms Line Sale";
        PaymentTermLines: Record "Payment Terms Line Sale";
        OldMileStone: Code[10];
        Customer: Record Customer;
        RemainingAmt: Decimal;
        RemainingBrokerageAmt: Decimal;
        PaymentPlanDetails: Record "Payment Plan Details";
        PaymentPlanDetails1: Record "Payment Plan Details";
        Sno: Code[20];
        Applicablecharge: Record "Applicable Charges";
        PaymentPlanDetails2: Record "Payment Plan Details" temporary;
        CNT: Integer;
        MilestoneCodeG: Code[10];
        InLoop: Boolean;

        "Document No.Editable": Boolean;

        "Commision ApplicableEditable": Boolean;

        "Direct AssociateEditable": Boolean;

        "Charge CodeEditable": Boolean;

        SequenceEditable: Boolean;

        "Payment TypeEditable": Boolean;

        "Actual MilestoneEditable": Boolean;

        "Second Milestone %Editable": Boolean;

        "Payment Term CodeEditable": Boolean;

        CriteriaValueBaseAmountEditabl: Boolean;

        "Due AmountEditable": Boolean;

        "Due DateEditable": Boolean;

        "Brokerage %Editable": Boolean;

        "Due Date CalculationEditable": Boolean;

        AdjustEditable: Boolean;

        "Calculation ValueEditable": Boolean;


    procedure BBGCreatePaymentTermsLine(MilestoneCode: Code[10]; MilestoneDescription: Text[50]; MilestoneDueDate: Date; Milestoneamt: Decimal; ChargeCode: Code[10]; CommisionApplicable: Boolean; DirectAssociate: Boolean)
    begin
        PaymentTermLines.INIT;
        PaymentTermLines.COPY(Rec);
        PaymentTermLines."Payment Type" := PaymentTermLines."Payment Type"::Advance;
        PaymentTermLines.Sequence := Sno;
        Sno := INCSTR(Sno);
        PaymentTermLines."Actual Milestone" := MilestoneCode;
        PaymentTermLines."Payment Plan" := PaymentPlanDetails."Payment Plan Code";
        //PaymentTermLines."Due Amount":=PaymentPlanDetails."Milestone Charge Amount";
        //PaymentTermLine."Broker No.":=SalesHeader."Broker Code";
        //PaymentTermLine."Customer No.":=SalesHeader."Sell-to Customer No.";
        //PaymentTermLine."Salesperson Code":=SalesHeader."Salesperson Code";
        //Customer.GET(SalesHeader."Customer No.");
        //PaymentTermLine."Related Vendor No.":=Customer."Related Vendor No.";
        PaymentTermLines.Description := MilestoneDescription;
        PaymentTermLines."Due Date" := MilestoneDueDate;
        PaymentTermLines."Project Code" := Rec."Project Code";
        PaymentTermLines."Calculation Type" := PaymentTermLines."Calculation Type"::"% age";
        PaymentTermLines."Criteria Value / Base Amount" := Milestoneamt;
        PaymentTermLines."Calculation Value" := 100;
        PaymentTermLines."Due Amount" := ROUND(Milestoneamt, 0.01, '=');
        PaymentTermLines."Charge Code" := ChargeCode;
        PaymentTermLines."Commision Applicable" := CommisionApplicable;
        PaymentTermLines."Direct Associate" := DirectAssociate;
        PaymentTermLines.INSERT(TRUE);
    end;
}

