page 97792 "Update Milestone Code"
{
    PageType = Card;
    SourceTable = Integer;
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group("Milestone Code")
            {
                Caption = 'Milestone Code';
                field(varMilestoneCode; varMilestoneCode)
                {
                    Caption = 'Milestone Code';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        PaymentTermsLine.RESET;
                        PaymentTermsLine.SETRANGE("Document Type", varDocType);
                        PaymentTermsLine.SETRANGE("Document No.", varDocNo);
                        PaymentTermsLine.SETRANGE("Transaction Type", varTransactionType);
                        PaymentTermsLine.SETRANGE(Adjust, FALSE);
                        IF PaymentTermsLine.FIND('-') THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"GRN Header JES", PaymentTermsLine) = ACTION::LookupOK THEN
                                varMilestoneCode := PaymentTermsLine."Milestone Code";
                        END
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Update Milestone")
            {
                Caption = '&Update Milestone';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    PTL: Record "Payment Terms Line";
                begin
                    IF NOT CONFIRM('Do you want to update the stage') THEN
                        EXIT;
                    PaymentTermsLine.RESET;
                    PaymentTermsLine.SETRANGE(PaymentTermsLine."Document Type", varDocType);
                    PaymentTermsLine.SETRANGE(PaymentTermsLine."Document No.", varDocNo);
                    PaymentTermsLine.SETRANGE(PaymentTermsLine."Transaction Type", varTransactionType);
                    PaymentTermsLine.SETRANGE(PaymentTermsLine."Milestone Code", varMilestoneCode);
                    IF PaymentTermsLine.FIND('-') THEN BEGIN

                        IF varTransactionType = varTransactionType::Sale THEN BEGIN
                            SalesHeader.GET(varDocType, varDocNo);
                            SalesHeader."Last Stage Completed" := PaymentTermsLine."Milestone Code";
                            SalesHeader.VALIDATE("Payment Terms Code", PaymentTermsLine."Payment Term Code");
                            SalesHeader.VALIDATE("Active Stage", '');
                        END
                        ELSE
                            IF varTransactionType = varTransactionType::Purchase THEN BEGIN
                                PurchaseHeader.GET(varDocType, varDocNo);
                                PurchaseHeader."Last Stage Completed" := PaymentTermsLine."Milestone Code";
                                PurchaseHeader.MODIFY;
                                PurchaseHeader.VALIDATE("Payment Terms Code", PaymentTermsLine."Payment Term Code");
                                PurchaseHeader.VALIDATE("Active Stage", '');

                                IF PaymentTermsLine."Payment Type" = PaymentTermsLine."Payment Type"::Running THEN BEGIN
                                    PTL.RESET;
                                    PTL.SETRANGE("Document Type", varDocType);
                                    PTL.SETRANGE("Document No.", varDocNo);
                                    PTL.SETRANGE("Transaction Type", varTransactionType);
                                    PTL.SETRANGE("Payment Type", PTL."Payment Type"::Retention);
                                    IF PTL.FIND('-') THEN BEGIN
                                        PTL.Adjust := TRUE;
                                        PTL.MODIFY;
                                        PurchaseHeader.GET(varDocType, varDocNo);
                                        PurchaseHeader.VALIDATE("Active Stage", PTL."Milestone Code");
                                        PurchaseHeader.VALIDATE("Payment Terms Code", PTL."Payment Term Code");
                                    END
                                END
                            END;
                        PaymentTermsLine.Adjust := TRUE;
                        PaymentTermsLine.MODIFY;

                    END
                    ELSE
                        MESSAGE('All milestones completed');


                    CurrPage.CLOSE;
                    /*
                    PaymentTermsLine.RESET;
                    PaymentTermsLine.SETRANGE(PaymentTermsLine."Document Type",varDocType);
                    PaymentTermsLine.SETRANGE(PaymentTermsLine."Document No.",varDocNo);
                    PaymentTermsLine.SETRANGE(PaymentTermsLine."Transaction Type",varTransactionType);
                    //PaymentTermsLine.SETRANGE(PaymentTermLine."Milestone Code",MilestoneCode);
                    PaymentTermsLine.SETRANGE(PaymentTermsLine."Stage Complete",FALSE);
                    IF PaymentTermsLine.FIND('-') THEN BEGIN
                      "Active Stage" := PaymentTermsLine."Milestone Code";
                      "Completed All Stages" := FALSE;
                      VALIDATE("Payment Terms Code",PaymentTermsLine."Payment Term Code");
                     CurrPAGE.UPDATE;
                    END
                    ELSE BEGIN
                      "Completed All Stages" := TRUE;
                      CurrPAGE.UPDATE;
                    END;
                      */

                end;
            }
        }
    }

    var
        varMilestoneCode: Code[20];
        varDocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        varDocNo: Code[20];
        varTransactionType: Option Sale,Purchase;
        PurchaseHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
        PaymentTermsLine: Record "Payment Terms Line";


    procedure setDocumentType(LocalDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order")
    begin
        varDocType := LocalDocumentType;
    end;


    procedure setDocumentNumber(localDocumentNumber: Code[20])
    begin
        varDocNo := localDocumentNumber;
    end;


    procedure setTransactionType(LocalTransactionType: Option Sale,Purchase)
    begin
        varTransactionType := LocalTransactionType;
    end;
}

