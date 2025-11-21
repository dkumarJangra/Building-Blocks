page 60668 "Land Lead Sub Page"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Land Lead/Opp Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = EditForfeit;
                field("Document No."; Rec."Document No.")
                {
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                }
                field("Vendor Code"; Rec."Vendor Code")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("PO No."; Rec."PO No.")
                {
                    Caption = '<PO No.>';
                    Visible = false;
                }
                field("PO Date"; Rec."PO Date")
                {
                    Visible = false;
                }
                field("PO Value"; Rec."PO Value")
                {
                    Visible = false;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Payment Amount"; Rec."Payment Amount")
                {
                    Visible = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        IF Rec."Land Type" = Rec."Land Type"::"Non-Agriculture" THEN
                            Rec.TESTFIELD("Unit of Measure Code", 'SQYD');
                    end;
                }
                field("Land Type"; Rec."Land Type")
                {
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        IF Rec."Land Type" = Rec."Land Type"::"Non-Agriculture" THEN
                            Rec.TESTFIELD("Unit of Measure Code", 'SQYD');
                    end;
                }
                field("Area"; Rec.Area)
                {
                }
                field("Quantity In SQYD"; Rec."Quantity In SQYD")
                {
                }
                field("Survey Nos."; Rec."Survey Nos.")
                {
                }
                field("Unit Price"; Rec."Unit Price")
                {
                }
                field("Land Value"; Rec."Land Value")
                {
                }
                field("Area in Acres"; Rec."Area in Acres")
                {
                }
                field("Area in Guntas"; Rec."Area in Guntas")
                {
                }
                field("Area in Ankanan"; Rec."Area in Ankanan")
                {
                    Visible = false;
                }
                field("Area in Cents"; Rec."Area in Cents")
                {
                }
                field("Area in Sq. Yard"; Rec."Area in Sq. Yard")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Land Document Dimension"; Rec."Land Document Dimension")
                {
                }
                field("Total Expense to Vendor"; Rec."Total Expense to Vendor")
                {
                }
                field("Total Payment to Vendor"; Rec."Total Payment to Vendor")
                {
                }
                field("Co-Ordinates"; Rec."Co-Ordinates")
                {
                }
                field("Nature of Deed"; Rec."Nature of Deed")
                {
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                }
                field("Sale Deed No."; Rec."Sale Deed No.")
                {
                    Visible = false;
                }
                field("Date of Registration"; Rec."Date of Registration")
                {
                }
                field("Approval Status"; Rec."Approval Status")
                {
                }
                field("Pending From USER ID"; Rec."Pending From USER ID")
                {
                }
                field("Lead Status"; Rec."Lead Status")
                {
                    Editable = false;
                }
                field("Line Status"; Rec."Line Status")
                {
                    Editable = false;
                }
                field("Inspected By"; Rec."Inspected By")
                {
                }
                field("Inspected Date"; Rec."Inspected Date")
                {
                }
                field("Assigned To"; Rec."Assigned To")
                {
                }
                field(Note; Rec.Note)
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
                Image = "Action";
                action("Vend Payment Milestone")
                {
                    RunObject = Page "Vendor Payment Milestone";
                    RunPageLink = "Land Document No." = FIELD("Document No."),
                                  "Vendor No." = FIELD("Vendor Code"),
                                  "Land Document Line No." = FIELD("Line No.");
                    Visible = false;
                }
                action("Change Line Status")
                {

                    trigger OnAction()
                    var
                        LandLeadOppLine: Record "Land Lead/Opp Line";
                        LandLeadOppHeader: Record "Land Lead/Opp Header";
                        Selection: Integer;
                        ExistsLandLeadOppLine: Record "Land Lead/Opp Line";
                    begin


                        Selection := STRMENU(Text002);
                        IF Selection <> 0 THEN BEGIN
                            IF Selection = 1 THEN
                                Rec."Line Status" := Rec."Line Status"::Open;
                            IF Selection = 2 THEN BEGIN
                                ExistsLandLeadOppLine.RESET;
                                ExistsLandLeadOppLine.SETRANGE("Document Type", ExistsLandLeadOppLine."Document Type"::Opportunity);
                                ExistsLandLeadOppLine.SETRANGE("Lead Document No.", Rec."Document No.");
                                ExistsLandLeadOppLine.SETRANGE("Lead Document Line No.", Rec."Line No.");
                                IF ExistsLandLeadOppLine.FINDFIRST THEN
                                    ERROR('Line already Transftered');

                                Rec."Line Status" := Rec."Line Status"::Forfeit;
                            END;

                            Rec.MODIFY;
                            COMMIT;
                            CLEAR(LandLeadCard);
                            LandLeadOppHeader.RESET;
                            LandLeadOppHeader.GET(Rec."Document Type", Rec."Document No.");
                            LandLeadOppHeader.CalculatesArea(LandLeadOppHeader);

                            MESSAGE('%1', 'Line Status Changed');
                        END;
                    end;
                }
                action("Change Lead Status")
                {

                    trigger OnAction()
                    var
                        LandLeadOppLine: Record "Land Lead/Opp Line";
                        LandLeadOppHeader: Record "Land Lead/Opp Header";
                    begin
                        Rec.TESTFIELD("Approval Status", Rec."Approval Status"::Open);
                        LandLeadOppHeader.RESET;
                        LandLeadOppHeader.SETCURRENTKEY("Lead Document No.");
                        LandLeadOppHeader.SETRANGE("Lead Document No.", Rec."Document No.");
                        IF LandLeadOppHeader.FINDFIRST THEN BEGIN
                            LandLeadOppLine.RESET;
                            LandLeadOppLine.SETRANGE("Document Type", LandLeadOppHeader."Document Type");
                            LandLeadOppLine.SETRANGE("Document No.", LandLeadOppHeader."Document No.");
                            LandLeadOppLine.SETRANGE("Line No.", Rec."Line No.");
                            IF LandLeadOppLine.FINDFIRST THEN
                                ERROR('Land Opportunity already created against this document');
                        END;

                        Selection := STRMENU(Text003);
                        IF Selection <> 0 THEN BEGIN
                            CurrPage.SETSELECTIONFILTER(LandLeadOppLine);
                            IF LandLeadOppLine.FINDSET THEN
                                REPEAT
                                    IF Selection = 1 THEN
                                        LandLeadOppLine."Lead Status" := LandLeadOppLine."Lead Status"::Cancelled;
                                    IF Selection = 2 THEN BEGIN
                                        LandLeadOppLine."Lead Status" := LandLeadOppLine."Lead Status"::Completed;
                                    END;
                                    IF Selection = 3 THEN
                                        LandLeadOppLine."Lead Status" := LandLeadOppLine."Lead Status"::"Under-Process";
                                    LandLeadOppLine.MODIFY;
                                UNTIL LandLeadOppLine.NEXT = 0;
                            MESSAGE('%1', 'Lead Status Changed');
                        END;
                    end;
                }
                action("Sent For Approval")
                {
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Lead Status", Rec."Lead Status"::Completed);
                        LandLeadOppHeader.RESET;
                        LandLeadOppHeader.GET(Rec."Document Type", Rec."Document No.");
                        LandLeadOppHeader.CalculatesArea(LandLeadOppHeader);
                        COMMIT;
                        BBGSetups.GET;
                        IF CONFIRM('Do you want to Send this Document for Approval') THEN BEGIN
                            IF Rec."Approval Status" = Rec."Approval Status"::Rejected THEN
                                ERROR('Document already Rejected')
                            ELSE IF Rec."Approval Status" = Rec."Approval Status"::Approved THEN
                                ERROR('Document already approved.');

                            IF Rec."Vendor Code" <> '' THEN BEGIN
                                IF Rec."Land Type" = Rec."Land Type"::" " THEN
                                    ERROR('Land Type is mandotary. Document No. %1 Line No. %2', Rec."Document No.", Rec."Line No.");
                                IF Rec."Unit of Measure Code" = '' THEN
                                    ERROR('Unit of Measure code can not be blank is mandotary. Document No. %1 Line No. %2', Rec."Document No.", Rec."Line No.");
                            END;

                            Rec."Approval Status" := Rec."Approval Status"::"Pending For Approval";
                            Rec."Pending From USER ID" := BBGSetups."Lead Approver 1";
                            MESSAGE('Document under Pending for Approval');
                        END;
                    end;
                }
                action("&Attach Documents")
                {
                    Caption = '&Attach Documents';
                    RunObject = Page "Land Document Attachment";
                    RunPageLink = "Document Type" = CONST(Document),
                                  "Document No." = FIELD("Document No."),
                                  "Document Line No." = FIELD("Line No.");

                    trigger OnAction()
                    var
                        Document: Record Document;
                        Page_Documents: Page Documents;
                        OldDocument: Record Document;
                    begin
                    end;
                }
                action(Approve)
                {
                    Image = Approve;

                    trigger OnAction()
                    var
                        LandLeadOppLine: Record "Land Lead/Opp Line";
                    begin
                        Rec.TESTFIELD("Lead Status", Rec."Lead Status"::Completed);
                        Rec.TESTFIELD("Approval Status", Rec."Approval Status"::"Pending For Approval");

                        IF (USERID <> Rec."Pending From USER ID") AND (Rec."Pending From USER ID" <> '') THEN
                            ERROR('Approver mismatch');

                        IF CONFIRM('Do you want to Approve this Document') THEN BEGIN
                            BBGSetups.GET();

                            IF USERID = BBGSetups."Lead Approver 1" THEN BEGIN
                                Rec."Approval Status" := Rec."Approval Status"::"Pending For Approval";
                                Rec."Pending From USER ID" := BBGSetups."Lead Approver 2";
                                MESSAGE('Document under Pending for Approval');
                            END ELSE IF BBGSetups."Lead Approver 2" <> Rec."Pending From USER ID" THEN
                                    ERROR('Approver 1 must approve');

                            IF USERID = BBGSetups."Lead Approver 2" THEN BEGIN
                                Rec."Approval Status" := Rec."Approval Status"::Approved;
                                Rec."Pending From USER ID" := '';

                                MESSAGE('Document Approved');
                            END;


                        END;
                    end;
                }
                action("Re-Open Requst")
                {
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Lead Status", Rec."Lead Status"::Completed);
                        IF Rec."Approval Status" = Rec."Approval Status"::Open THEN
                            ERROR('Document is already open');

                        IF CONFIRM('Do you want to Re-open Request') THEN BEGIN
                            Rec."Approval Status" := Rec."Approval Status"::Open;
                            Rec."Pending From USER ID" := '';

                            Rec."Approval Status" := Rec."Approval Status"::Open;
                            Rec.MODIFY;
                            MESSAGE('Document Open');
                        END;
                    end;
                }
                action(Reject)
                {
                    Image = Reject;

                    trigger OnAction()
                    var
                        CommentLine: Record "Land Comment Line";
                    begin

                        Rec.TESTFIELD("Approval Status", Rec."Approval Status"::"Pending For Approval");

                        IF CONFIRM('Do you want to Reject this Document') THEN BEGIN
                            IF Rec."Approval Status" = Rec."Approval Status"::Approved THEN
                                ERROR('Document already approved.');
                            IF Rec."Pending From USER ID" <> '' THEN
                                IF USERID <> Rec."Pending From USER ID" THEN
                                    ERROR('This user - ' + Rec."Pending From USER ID" + ' can only Reject this Document');
                            CommentLine.RESET;
                            CommentLine.SETRANGE("No.", Rec."Document No.");
                            CommentLine.SETRANGE("Creation Date", TODAY);
                            CommentLine.SETRANGE("User ID", USERID);
                            CommentLine.SETRANGE("Document Line No.", Rec."Line No.");
                            IF NOT CommentLine.FINDFIRST THEN
                                ERROR('Please Enter the Comments');


                            IF Rec."Approval Status" = Rec."Approval Status"::"Pending For Approval" THEN BEGIN
                                Rec."Approval Status" := Rec."Approval Status"::Rejected;
                                Rec."Pending From USER ID" := '';
                                MESSAGE('Document Rejected');
                            END;
                        END;
                    end;
                }
                action("Comment Sheet")
                {
                    // RunObject = Page 60714;
                    // RunPageLink = Field1 = FIELD("Document No."),
                    //               Field2 = FIELD("Line No.");
                }
                action("R-1 PPR List")
                {

                    trigger OnAction()
                    var
                        LANDR3LEGALCHECKCard: Page "LAND R3 - LEGAL CHECK Card";
                    begin
                        IF LandLeadHdr.GET(Rec."Document Type", Rec."Document No.") THEN;
                        LandPPRDocumentList.RESET;
                        LandPPRDocumentList.SETRANGE("Document No.", Rec."Document No.");
                        LandPPRDocumentList.SETRANGE("Document Line No.", Rec."Line No.");
                        IF LandPPRDocumentList.FINDFIRST THEN BEGIN
                            PAGE.RUN(Page::"R-1 PRR Card", LandPPRDocumentList);
                        END ELSE BEGIN
                            RecLandPPRDocument.INIT;
                            RecLandPPRDocument."Document No." := Rec."Document No.";
                            RecLandPPRDocument."Document Line No." := Rec."Line No.";
                            RecLandPPRDocument."State Code" := LandLeadHdr."State Code";
                            RecLandPPRDocument."Post Code" := LandLeadHdr."Post Code";
                            RecLandPPRDocument."User ID" := USERID;
                            RecLandPPRDocument.Date := TODAY;
                            RecLandPPRDocument."Type of the land" := Rec."Land Type";
                            RecLandPPRDocument.INSERT;
                            //CLEAR(PageLANDR3LEGALCHECKCard);
                            PAGE.RUN(Page::"R-1 PRR Card", RecLandPPRDocument);
                        END;
                    end;
                }
                action("R-2 Check List Land Doc")
                {

                    trigger OnAction()
                    begin
                        LandPPR_2DocumentList.RESET;
                        LandPPR_2DocumentList.SETRANGE("Document No.", Rec."Document No.");
                        LandPPR_2DocumentList.SETRANGE("Document Line No.", Rec."Line No.");
                        IF LandPPR_2DocumentList.FINDFIRST THEN BEGIN
                            PAGE.RUN(Page::"R-2 Check List Card", LandPPR_2DocumentList);
                        END ELSE BEGIN
                            RecLandPPR_2Document.INIT;
                            RecLandPPR_2Document."Document No." := Rec."Document No.";
                            RecLandPPR_2Document."Document Line No." := Rec."Line No.";
                            RecLandPPR_2Document."Name of the land holder" := Rec."Vendor Name";
                            RecLandPPR_2Document.INSERT;
                            //CLEAR(PageLANDR3LEGALCHECKCard);
                            PAGE.RUN(Page::"R-2 Check List Card", RecLandPPR_2Document);
                        END;
                    end;
                }
                action(TransferLeadToOpportunity)
                {

                    trigger OnAction()
                    var
                        LandLeadOppLine: Record "Land Lead/Opp Line";
                    begin
                        CurrPage.SETSELECTIONFILTER(LandLeadOppLine);
                        LandLeadOppLine.SETRANGE("Lead Status", LandLeadOppLine."Lead Status"::Completed);
                        LandLeadOppLine.SETRANGE("Line Status", LandLeadOppLine."Line Status"::Open);
                        LandLeadOppLine.SETRANGE("Approval Status", LandLeadOppLine."Approval Status"::Approved);
                        IF LandLeadOppLine.FINDSET THEN BEGIN
                            REPEAT
                                Rec.TransferLeadToOpportunity(LandLeadOppLine);
                            UNTIL LandLeadOppLine.NEXT = 0;
                            MESSAGE('%1', 'No. of Lines -' + FORMAT(LandLeadOppLine.COUNT) + ' has been transfered');
                        END ELSE
                            MESSAGE('Nothing Done');
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        EditForfeit := TRUE;
        IF Rec."Line Status" = Rec."Line Status"::Forfeit THEN
            EditForfeit := FALSE
        ELSE
            EditForfeit := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        LandLeaseOppHeader: Record "Land Lead/Opp Header";
    begin
        LandLeaseOppHeader.RESET;
        LandLeaseOppHeader.GET(Rec."Document Type", Rec."Document No.");
        LandLeaseOppHeader.TESTFIELD("Approval Status", LandLeaseOppHeader."Approval Status"::Open);
        Rec."Document Type" := Rec."Document Type"::Lead;
    end;

    var
        Text002: Label '&Open,&Forfeit';
        LandLeadCard: Page "Land Lead Card";
        EditForfeit: Boolean;
        Text003: Label '&Cancelled,&Completed,&Under-Process';
        Selection: Integer;
        LandLeadOppHeader: Record "Land Lead/Opp Header";
        BBGSetups: Record "BBG Setups";
        LandPPRDocumentList: Record "Land R-1 PPR Document Lis_1";
        RecLandPPRDocument: Record "Land R-1 PPR Document Lis_1";
        LandPPR_2DocumentList: Record "Land R-2 PPR  Document List";
        RecLandPPR_2Document: Record "Land R-2 PPR  Document List";
        LandLeadHdr: Record "Land Lead/Opp Header";
}

