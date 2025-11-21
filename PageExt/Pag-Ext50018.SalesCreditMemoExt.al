pageextension 50018 "BBG Sales Credit Memo Ext" extends "Sales Credit Memo"
{
    layout
    {
        // Add changes to page layout here
        addafter(General)
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

    actions
    {
        // Add changes to page actions here
        addafter("Co&mments")
        {
            group("Customized Approval")
            {
                Caption = 'Customized Approval';
                action("Send for Approval")
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
                            UserTasksNew.AuthorizationSO(UserTasksNew."Transaction Type"::Sale, UserTasksNew."Document Type"::"Credit Memo",
                            UserTasksNew."Sub Document Type"::" ", Rec."No.");

                            //CurrForm.UPDATE(TRUE);
                        END;
                        //JPL STOP

                        //ND
                        MESSAGE('Task Successfully Done for Document No. %1', Rec."No.");
                        //ND
                    end;
                }
                action(Approve1)
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    begin

                        //Approved:=TRUE;
                        //MODIFY;

                        Rec.TESTFIELD("Sent for Approval", TRUE);
                        Rec.TESTFIELD(Approved, FALSE);

                        UserTasksNew.RESET;
                        DocTypeApprovalRec.RESET;
                        DocTypeApprovalRec.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                        DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::"Credit Memo");
                        DocTypeApprovalRec.SETRANGE("Sub Document Type", DocTypeApprovalRec."Sub Document Type"::" ");
                        DocTypeApprovalRec.SETRANGE("Document No", Rec."No.");
                        DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                        DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                        IF DocTypeApprovalRec.FIND('-') THEN BEGIN
                            UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                            "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);

                            UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Sale);
                            UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::"Credit Memo");
                            UserTasksNew.SETRANGE("Sub Document Type", UserTasksNew."Sub Document Type"::" ");
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
                        DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::"Credit Memo");
                        DocTypeApprovalRec.SETRANGE("Sub Document Type", DocTypeApprovalRec."Sub Document Type"::" ");
                        DocTypeApprovalRec.SETRANGE("Document No", Rec."No.");
                        DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                        DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                        IF DocTypeApprovalRec.FIND('-') THEN BEGIN
                            UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                            "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);

                            UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Sale);
                            UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::"Credit Memo");
                            UserTasksNew.SETRANGE("Sub Document Type", UserTasksNew."Sub Document Type"::" ");
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
    }

    var
        myInt: Integer;
        UserTasksNew: Record "User Tasks New";
        DocTypeApprovalRec: Record "Document Type Approval";
        Short1name: Text[50];
        Respname: Text[50];
}