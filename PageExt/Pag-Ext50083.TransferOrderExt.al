pageextension 50083 "BBG Transfer Order Ext" extends "Transfer Order"
{
    layout
    {
        // Add changes to page layout here
        addafter(General)
        {
            group("BBG Fields")
            {
                Caption = 'BBG Fields';
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;

                }
                field("PO code"; Rec."PO code")
                {
                    Caption = 'WO / PO code';
                    ApplicationArea = All;
                }
                field("Order Status"; Rec."Order Status")
                {
                    ApplicationArea = All;

                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;

                }
                field("Sent for Approval"; Rec."Sent for Approval")
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
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("O&rder")
        {
            action("Change Posting Date")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec."Posting Date" := TODAY;
                    Rec.MODIFY;
                end;
            }
            action("Send for Approval")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                    IF Rec.Initiator <> UPPERCASE(USERID) THEN
                        ERROR('Un-Authorized Initiator');

                    Rec.TESTFIELD("Shortcut Dimension 1 Code");
                    //RAHEE1.00
                    TRLine.RESET;
                    TRLine.SETRANGE("Document No.", Rec."No.");
                    IF TRLine.FINDSET THEN
                        REPEAT
                            IF TRLine."PO CODE" <> '' THEN
                                TRLine.TESTFIELD(TRLine."PO Line No.");
                        UNTIL TRLine.NEXT = 0;
                    //RAHEE1.00


                    TransLine.RESET;
                    TransLine.SETRANGE("Document No.", Rec."No.");
                    IF TransLine.FIND('-') THEN BEGIN
                        REPEAT
                            TransLine.TESTFIELD("Item No.");
                            TransLine.TESTFIELD(Quantity);
                            TransLine.TESTFIELD("Shortcut Dimension 1 Code");
                            //Alleab-FA:
                            ItemRec.RESET;
                            ItemRec.GET(TransLine."Item No.");
                            IF NOT ItemRec."FA Item" THEN
                                //Alleab-FA:
                                TransLine.TESTFIELD("Shortcut Dimension 2 Code");
                        UNTIL TransLine.NEXT = 0;
                    END ELSE
                        ERROR('Cannot send Blank Document!');



                    Rec.TESTFIELD("Sent for Approval", FALSE);
                    IF Rec."Sent for Approval" = FALSE THEN BEGIN
                        Rec.VALIDATE("Sent for Approval", TRUE);

                        //ALLE-PKS16
                        Accept := CONFIRM(Text007, TRUE, 'Transfer Order', Rec."No.");
                        IF NOT Accept THEN EXIT;
                        //ALLE-PKS16

                        Rec."Sent for Approval Date" := TODAY;
                        Rec."Sent for Approval Time" := TIME;
                        Rec.MODIFY;
                        UserTasksNew.AuthorizationTO(UserTasksNew."Transaction Type"::Purchase, UserTasksNew."Document Type"::"Transfer Order",
                        Rec."Sub Document Type", Rec."No.");


                    END;
                    //JPL STOP

                    //ND
                    MESSAGE('Task Successfully Done for Document No. %1', Rec."No.");
                    //ND
                end;
            }
            action(Approve)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                    Rec.TESTFIELD("Sent for Approval", TRUE);
                    Rec.TESTFIELD(Approved, FALSE);

                    UserTasksNew.RESET;
                    DocTypeApprovalRec.RESET;
                    DocTypeApprovalRec.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                    DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::"Transfer Order");
                    DocTypeApprovalRec.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                    DocTypeApprovalRec.SETRANGE("Document No", Rec."No.");
                    DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                    DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                    IF DocTypeApprovalRec.FIND('-') THEN BEGIN

                        UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                        "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);

                        UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Purchase);
                        UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::"Transfer Order");
                        UserTasksNew.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                        UserTasksNew.SETRANGE("Document No", Rec."No.");
                        UserTasksNew.SETRANGE(Initiator, Rec.Initiator);
                        UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                        UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                        UserTasksNew.SETRANGE(Status, UserTasksNew.Status::" ");
                        IF UserTasksNew.FIND('-') THEN
                            UserTasksNew.ApproveTO(UserTasksNew);
                    END;
                    IF Rec.Approved = TRUE THEN
                        CurrPage.EDITABLE(FALSE);
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
                    DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::"Transfer Order");
                    DocTypeApprovalRec.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                    DocTypeApprovalRec.SETRANGE("Document No", Rec."No.");
                    DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                    DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                    IF DocTypeApprovalRec.FIND('-') THEN BEGIN

                        UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                        "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);

                        UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Purchase);
                        UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::"Transfer Order");
                        UserTasksNew.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                        UserTasksNew.SETRANGE("Document No", Rec."No.");
                        UserTasksNew.SETRANGE(Initiator, Rec.Initiator);
                        UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                        UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                        UserTasksNew.SETRANGE(Status, UserTasksNew.Status::" ");
                        IF UserTasksNew.FIND('-') THEN
                            UserTasksNew.ReturnTO(UserTasksNew);
                    END;
                end;
            }


        }
    }

    var
        myInt: Integer;
        TransHead: Record "Transfer Header";
        vFlag: Boolean;
        Memberof: Record "Access Control";
        DocApproval: Record "Document Type Approval";
        ALLE: Integer;
        UserTasksNew: Record "User Tasks New";
        DocTypeApprovalRec: Record "Document Type Approval";
        UserMgt: Codeunit "EPC User Setup Management";
        costname: Text[120];
        dept: Text[120];
        DimValue: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
        Short1name: Text[50];
        Respname: Text[50];
        Locname: Text[50];
        RecDimValue: Record "Dimension Value";
        RecLocation: Record Location;
        RecRespCenter: Record "Responsibility Center 1";
        RecUserSetup: Record "User Setup";
        TransLine: Record "Transfer Line";
        "Location code": Record Location;
        Accept: Boolean;
        ItemRec: Record Item;
        TRLine: Record "Transfer Line";
        Text007: Label 'Do you want to Send the %1 No.-%2 For Approval';
}