pageextension 50017 "BBG Sales Invoice Ext" extends "Sales Invoice"
{
    layout
    {
        // Add changes to page layout here
        addafter(General)
        {
            group("BBG Fields")
            {
                field(Approved; Rec.Approved)
                {
                    ApplicationArea = All;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ApplicationArea = All;
                }
                field("Approved Time"; Rec."Approved Time")
                {
                    ApplicationArea = All;
                }
                field(Initiator; Rec.Initiator)
                {
                    ApplicationArea = All;
                }
                field("Sent for Approval Date"; Rec."Sent for Approval Date")
                {
                    ApplicationArea = All;
                }
                field("Sent for Approval Time"; Rec."Sent for Approval Time")
                {
                    ApplicationArea = All;
                }
                field("Sent for Approval"; Rec."Sent for Approval")
                {
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                field("Creation Time"; Rec."Creation Time")
                {
                    ApplicationArea = All;
                }
                field("North Zone"; Rec."North Zone")
                {
                    ApplicationArea = All;
                }
                field("South Zone"; Rec."South Zone")
                {
                    ApplicationArea = All;
                }
                field("Percent of Steel"; Rec."Percent of Steel")
                {
                    ApplicationArea = All;
                }
                field("Percent for Rest"; Rec."Percent for Rest")
                {
                    ApplicationArea = All;
                }
                field("Labour Percent"; Rec."Labour Percent")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Co&mments")
        {
            action("Payment Milestones")
            {
                Image = "Page";
                Promoted = true;
                RunObject = Page "Payment Terms Line Sale";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "Document No." = FIELD("No."),
                                  "Transaction Type" = FILTER(Sale);
                ApplicationArea = All;
            }
            action("Transit Documents")
            {
                Image = "Page";
                Promoted = true;
                ApplicationArea = All;
                // RunObject = Page 13705;
                // RunPageLink = Type = CONST(Sale),
                //                   "PO / SO No." = FIELD("No."),
                //                   "Vendor / Customer Ref." = FIELD("Sell-to Customer No.");
            }
        }
        addafter(Approval)
        {
            group("Customized Approval")
            {
                Caption = 'Customized Approval';
                action("Send For Approval")
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    begin

                        //JPL START
                        IF Rec.Initiator <> UPPERCASE(USERID) THEN
                            ERROR('Un-Authorized Initiator');


                        Rec.TESTFIELD("Sent for Approval", FALSE);
                        IF Rec."Sent for Approval" = FALSE THEN BEGIN
                            Rec.VALIDATE("Sent for Approval", TRUE);
                            Rec."Sent for Approval Date" := TODAY;
                            Rec."Sent for Approval Time" := TIME;
                            Rec.MODIFY;
                            UserTasksNew.AuthorizationSO(UserTasksNew."Transaction Type"::Sale, UserTasksNew."Document Type"::"Sale Order",
                            UserTasksNew."Sub Document Type"::Invoice, Rec."No.");

                            //CurrForm.UPDATE(TRUE);
                        END;
                        //JPL STOP

                        //ND
                        MESSAGE('Task Successfully Done for Document No. %1', Rec."No.");
                        //ND
                    end;
                }
                action("&Approved")
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    begin

                        Rec.TESTFIELD("Sent for Approval", TRUE);
                        Rec.TESTFIELD(Approved, FALSE);

                        UserTasksNew.RESET;
                        DocTypeApprovalRec.RESET;
                        DocTypeApprovalRec.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                        DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::"Sale Order");
                        DocTypeApprovalRec.SETRANGE("Sub Document Type", DocTypeApprovalRec."Sub Document Type"::Invoice);
                        DocTypeApprovalRec.SETRANGE("Document No", Rec."No.");
                        DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                        DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                        IF DocTypeApprovalRec.FIND('-') THEN BEGIN
                            UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                            "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);

                            UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Sale);
                            UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::"Sale Order");
                            UserTasksNew.SETRANGE("Sub Document Type", UserTasksNew."Sub Document Type"::Invoice);
                            UserTasksNew.SETRANGE("Document No", Rec."No.");
                            UserTasksNew.SETRANGE(Initiator, Rec.Initiator);
                            UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                            UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                            UserTasksNew.SETRANGE(Status, UserTasksNew.Status::" ");
                            IF UserTasksNew.FIND('-') THEN
                                UserTasksNew.ApproveSO(UserTasksNew);
                        END;
                        IF Rec.Approved = TRUE THEN
                            CurrPage.EDITABLE(FALSE);

                        //ND
                        MESSAGE('Task Successfully Done for Document No. %1', Rec."No.");
                        //ND
                    end;
                }
                action(Return)
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    begin

                        Rec.TESTFIELD("Sent for Approval", TRUE);
                        Rec.TESTFIELD(Approved, FALSE);

                        UserTasksNew.RESET;
                        DocTypeApprovalRec.RESET;
                        DocTypeApprovalRec.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                        DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::"Sale Order");
                        DocTypeApprovalRec.SETRANGE("Sub Document Type", DocTypeApprovalRec."Sub Document Type"::Invoice);
                        DocTypeApprovalRec.SETRANGE("Document No", Rec."No.");
                        DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                        DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                        IF DocTypeApprovalRec.FIND('-') THEN BEGIN
                            UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                            "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);

                            UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Sale);
                            UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::"Sale Order");
                            UserTasksNew.SETRANGE("Sub Document Type", UserTasksNew."Sub Document Type"::Invoice);
                            UserTasksNew.SETRANGE("Document No", Rec."No.");
                            UserTasksNew.SETRANGE(Initiator, Rec.Initiator);
                            UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                            UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                            UserTasksNew.SETRANGE(Status, UserTasksNew.Status::" ");
                            IF UserTasksNew.FIND('-') THEN
                                UserTasksNew.ReturnSO(UserTasksNew);
                        END;

                        //ND
                        MESSAGE('Task Successfully Done for Document No. %1', Rec."No.");
                        //ND
                    end;
                }
            }
        }
        addafter("Move Negative Lines")
        {
            action("Get Job Lines")
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    //ALLEAB
                    Rec.GetJobBudgetLines;
                    //ALLEAB
                end;
            }
            action("Calculate RIT")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CurrPage.SalesLines.PAGE.CalculateRIT;
                end;
            }
        }
        addafter(Preview)
        {
            action("Client Bill")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.RESET;
                    Rec.SETRANGE("No.", Rec."No.");
                    REPORT.RUN(Report::"New CommissionEligibility50082", TRUE, FALSE, Rec);
                end;
            }
        }
    }

    var
        myInt: Integer;
        UserTasksNew: Record "User Tasks New";
        DocTypeApprovalRec: Record "Document Type Approval";
        RecRespCenter: Record "Responsibility Center 1";
        Short1name: Text[50];
        Short2name: Text[50];
        Respname: Text[50];
        Locname: Text[50];
        GLSetup: Record "General Ledger Setup";
        RecPurchRcptLine: Record "Purch. Rcpt. Line";
        RecPL: Record "Purchase Line";
        AppAmount: Decimal;
        CLE: Record "Cust. Ledger Entry";
        ICOutboxTransaction: Record "IC Outbox Transaction";

    trigger OnOpenPage()
    begin
        IF Rec.Approved = TRUE THEN
            CurrPage.EDITABLE(FALSE)
        ELSE
            CurrPage.EDITABLE(TRUE);
    end;

    trigger OnAfterGetRecord()
    begin

        Rec.SETRANGE("Document Type");
        // IF Rec."Re-Dispatch" THEN
        //     ReturnOrderNoVisible := TRUE
        // ELSE
        //     ReturnOrderNoVisible := FALSE;

        //NDALLE
        Short1name := '';
        Short2name := '';
        Respname := '';
        Locname := '';
        IF RecRespCenter.GET(Rec."Responsibility Center") THEN BEGIN
            Respname := RecRespCenter.Name;
            Short1name := RecRespCenter."Region Name";
            Locname := RecRespCenter."Location Name";
        END;

        AppAmount := 0;
        IF (Rec."Applies-to ID" <> '') OR (Rec."Applies-to Doc. No." <> '') THEN BEGIN
            CLE.RESET;
            CLE.SETCURRENTKEY("Customer No.", Open);
            CLE.SETRANGE("Customer No.", Rec."Sell-to Customer No.");
            CLE.SETRANGE(Open, TRUE);
            IF CLE.FIND('-') THEN
                REPEAT
                    IF CLE."Amount to Apply" <> 0 THEN
                        AppAmount := AppAmount + CLE."Amount to Apply";
                UNTIL CLE.NEXT = 0;
        END;
    end;
}