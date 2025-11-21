page 97772 "Payment Terms Line Purchase"
{
    // Alle GA : New form created for multiple payment terms line for one purchase order.
    // 
    // 
    // VSID 0051 ALLE NAM -01-July-05 : Field "Payment Type" Added on the form

    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Payment Terms Line";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                }
                field("Payment Type"; Rec."Payment Type")
                {
                }
                field("Milestone Code"; Rec."Milestone Code")
                {
                }
                field("Payment Term Code"; Rec."Payment Term Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Criteria; Rec.Criteria)
                {
                    Visible = false;
                }
                field("Order Value"; Rec."Order Value")
                {
                    Editable = false;
                }
                field("Criteria Value / Base Amount"; Rec."Criteria Value / Base Amount")
                {
                    Editable = false;
                }
                field("Calculation Type"; Rec."Calculation Type")
                {
                }
                field("Calculation Value"; Rec."Calculation Value")
                {
                }
                field("Due Date Calculation"; Rec."Due Date Calculation")
                {
                }
                field("Due Amount"; Rec."Due Amount")
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field("Payment Made"; Rec."Payment Made")
                {
                    Visible = false;
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
        area(processing)
        {
            action("Refresh Amount")
            {
                Caption = 'Refresh Amount';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin

                    PaymentTermLine.SETRANGE("Document Type", Rec."Document Type");
                    PaymentTermLine.SETRANGE("Document No.", Rec."Document No.");
                    IF PaymentTermLine.FIND('-') THEN BEGIN
                        REPEAT
                            PaymentTermLine.CalculateCriteriaValue;
                            PaymentTermLine.MODIFY;
                        UNTIL PaymentTermLine.NEXT = 0;
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
            action("&Copy Milestone")
            {
                Caption = '&Copy Milestone';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PaymentTermsLine: Record "Payment Terms Line";
                    PaymentTermsLine1: Record "Payment Terms Line";
                    PurchHeader: Record "Purchase Header";
                    PAGEPaymentTermsLine: Page "Payment Terms Line List";
                    PAGEPurchseList: Page "Purchase List";
                begin
                    CLEAR(PAGEPurchseList);
                    CLEAR(PAGEPaymentTermsLine);
                    PurchHeader.RESET;
                    PurchHeader.SETRANGE("Document Type", Rec."Document Type");
                    PaymentTermsLine.RESET;
                    PAGEPurchseList.LOOKUPMODE := TRUE;
                    PAGEPurchseList.SETTABLEVIEW(PurchHeader);
                    IF PAGEPurchseList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        PAGEPurchseList.GETRECORD(PurchHeader);
                        PaymentTermsLine.SETRANGE("Document Type", PurchHeader."Document Type");
                        PaymentTermsLine.SETRANGE("Document No.", PurchHeader."No.");
                        IF PaymentTermsLine.FIND('-') THEN BEGIN
                            PaymentTermsLine1.RESET;
                            REPEAT
                                PaymentTermsLine1.INIT;
                                PaymentTermsLine1.TRANSFERFIELDS(PaymentTermsLine);
                                PaymentTermsLine1."Document Type" := Rec."Document Type";
                                PaymentTermsLine1."Document No." := Rec."Document No.";
                                PaymentTermsLine1."Payment Made" := FALSE;
                                PaymentTermsLine1.Adjust := FALSE;
                                PaymentTermsLine1."Transaction Type" := PaymentTermsLine1."Transaction Type"::Purchase;
                                PaymentTermsLine1.VALIDATE("Criteria Value / Base Amount");
                                PaymentTermsLine1.INSERT(TRUE);
                                PaymentTermsLine1.VALIDATE("Criteria Value / Base Amount");
                                PaymentTermsLine1.MODIFY(TRUE);
                            UNTIL PaymentTermsLine.NEXT = 0;
                        END;
                    END;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec."Transaction Type" := Rec."Transaction Type"::Purchase;
        //VALIDATE("Criteria Value / Base Amount");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Transaction Type" := Rec."Transaction Type"::Purchase;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Transaction Type" := Rec."Transaction Type"::Purchase;
    end;

    trigger OnOpenPage()
    begin
        IF CurrPage.LOOKUPMODE THEN
            CurrPage.EDITABLE := FALSE;

        PurchaseHeader.RESET;
        PurchaseHeader.SETRANGE(PurchaseHeader."No.", Rec."Document No.");
        IF PurchaseHeader.FIND('-') THEN BEGIN
            //  MESSAGE ('%1',PurchaseHeader.Initiator);
            IF ((USERID = PurchaseHeader.Initiator) AND (PurchaseHeader."Sent for Approval" = FALSE) OR
            (USERID = PurchaseHeader."Amendment Initiator") AND NOT (PurchaseHeader."Amendment Approved")) THEN
                CurrPage.EDITABLE := TRUE
            ELSE
                CurrPage.EDITABLE := FALSE;

            memberof.RESET;
            memberof.SETRANGE("User Name", USERID);
            memberof.SETRANGE("Role ID", 'SUPER');
            IF memberof.FIND('-') THEN
                CurrPage.EDITABLE := TRUE;

        END;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        /*
        IF UPPERCASE(GETFILTER("Transaction Type")) = 'PURCHASE' THEN BEGIN
           IF PurchaseHeader.GET("Document Type","Document No.") THEN;
           IF PurchaseHeader."Active Stage" = '' THEN BEGIN
                 PaymentTermLine.COPY(Rec);
                 IF PaymentTermLine.FIND('-') THEN BEGIN
                    PurchaseHeader.VALIDATE(PurchaseHeader."Payment Terms Code",PaymentTermLine."Payment Term Code");
                    PurchaseHeader.VALIDATE(PurchaseHeader."Active Stage",PaymentTermLine."Milestone Code");
                    PurchaseHeader.MODIFY(TRUE);
                  END
           END
        END
        */
        IF Rec."Transaction Type" = Rec."Transaction Type"::Purchase THEN BEGIN
            IF PurchaseHeader.GET(Rec."Document Type", Rec."Document No.") THEN;
            IF PurchaseHeader."Last Stage Completed" = '' THEN BEGIN
                //PaymentTermLine.COPY(Rec);
                PaymentTermLine.RESET;
                PaymentTermLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
                PaymentTermLine.SETRANGE("Document No.", PurchaseHeader."No.");
                PaymentTermLine.SETRANGE("Payment Type", PaymentTermLine."Payment Type"::Running);
                IF PaymentTermLine.FIND('-') THEN BEGIN
                    PurchaseHeader.VALIDATE("Payment Terms Code", PaymentTermLine."Payment Term Code");
                    PurchaseHeader.VALIDATE("Last Stage Completed", PaymentTermLine."Milestone Code");
                    PurchaseHeader.MODIFY(TRUE);
                END
            END
        END

    end;

    var
        PurchaseHeader: Record "Purchase Header";
        PaymentTermLine: Record "Payment Terms Line";
        memberof: Record "Access Control";
}

