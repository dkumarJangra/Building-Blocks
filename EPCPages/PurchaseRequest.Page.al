page 97727 "Purchase Request"
{
    // // may 1.1 restricting other than SUPERPO role to edit
    // //ALLE-SR-051107 : Responsibilty center added
    // //ALLE-PKS03 for Setting the Send For Approval to the indent lines
    // //ALLE-PKS 34 for the names of the dimension
    // //ALLE-PKS36 for setting the Editable False to Indent Date
    // ALLERP bugFix 29-11-2010: Menu Item of Indent made invisible.
    // ALLEPG RIL1.06 080911 : Code added for indent return
    // ALLEPG 041111 : Job No & Job Task No. should be mandatory.
    // ALLEPG 271211 : Added code to verify job must be approved before get planning lines

    InsertAllowed = true;
    PageType = Card;
    SourceTable = "Purchase Request Header";
    SourceTableView = SORTING("Document Type", "Document No.")
                      WHERE("Document Type" = FILTER(Indent),
                            "Indent Status" = FILTER(Open),
                            "Sub Document Type" = FILTER(' '));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Workflow Sub Document Type"; Rec."Workflow Sub Document Type")
                {
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                }
                field("Indent Date"; Rec."Indent Date")
                {
                    Editable = "Indent DateEditable";
                }
                field(Requirement; Rec.Requirement)
                {
                }
                field("Required By Date"; Rec."Required By Date")
                {
                    Caption = 'Required By Date';

                    trigger OnValidate()
                    begin
                        IF Rec."Required By Date" < Rec."Indent Date" THEN
                            ERROR('Required date is not valid...check indent date..');
                    end;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;

                    trigger OnValidate()
                    begin
                        //may 1.0 for restricting cost centers that are blocked...

                        IF Rec."Shortcut Dimension 1 Code" = 'DUMMY' THEN
                            ERROR('You can not select DUMMY cost center..');

                        dimvalue.RESET;
                        dimvalue.SETRANGE(dimvalue."Dimension Code", 'COST CENTER');
                        dimvalue.SETRANGE(dimvalue.Code, Rec."Shortcut Dimension 1 Code");
                        IF dimvalue.FIND('-') THEN
                            IF dimvalue.Blocked = TRUE THEN
                                ERROR('This cost center is blocked....');
                        ShortcutDimension1CodeOnAfterV;
                    end;
                }
                field(Short1name; Short1name)
                {
                    Editable = false;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                }
                field(Respname; Respname)
                {
                    Editable = false;
                }
                field("Location code"; Rec."Location code")
                {
                    Editable = true;
                }
                field(Locname; Locname)
                {
                    Editable = false;
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    Editable = "Purchaser CodeEditable";
                    Visible = false;
                }
                field("Job Code"; Rec."Job Code")
                {
                }
                field("Indent Type"; Rec."Indent Type")
                {
                }
                field("PO code"; Rec."PO code")
                {
                    Caption = 'WO/ PO Code';
                    Visible = false;
                }
                field("Indent Value"; Rec."Indent Value")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Indent Status"; Rec."Indent Status")
                {
                    Editable = false;
                }
                field(Indentor; Rec.Indentor)
                {
                    Editable = false;
                }
                field("Indentors Justification"; Rec."Indentors Justification")
                {
                    MultiLine = true;
                }
            }
            part("Indent lines"; "Purchase Request Lines")
            {
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No.");
                SubPageView = SORTING("Document Type", "Document No.", "Line No.")
                              ORDER(Ascending);
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Approval")
            {
                Caption = '&Approval';
                action("Send for Approval")
                {
                    Caption = 'Send for Approval';

                    trigger OnAction()
                    begin
                        IF Rec."Shortcut Dimension 1 Code" <> Rec."Responsibility Center" THEN
                            ERROR(' Please check, Region Dimension code is different from Responsibility Center code');


                        Rec.TESTFIELD("Indentors Justification");  // ALLEAA
                        Rec.TESTFIELD("Sent for Approval", FALSE);//ALLE-PKS16
                        //JPL START
                        IF Rec.Indentor <> UPPERCASE(USERID) THEN
                            ERROR('Un-Authorized Indentor');
                        //dds-s
                        Rec.TESTFIELD("Shortcut Dimension 1 Code");
                        //TESTFIELD("Shortcut Dimension 2 Code");
                        Rec.TESTFIELD("Indent Date");
                        Rec.TESTFIELD("Required By Date");
                        Rec.TESTFIELD("Indentors Justification");
                        IndLine.RESET;
                        IndLine.SETRANGE("Document Type", Rec."Document Type");
                        IndLine.SETRANGE("Document No.", Rec."Document No.");
                        IF IndLine.FIND('-') THEN BEGIN
                            REPEAT
                                IF IndLine.Type <> IndLine.Type::"Fixed Asset" THEN BEGIN
                                    IndLine.TESTFIELD("No.");
                                    IndLine.TESTFIELD("Approved Qty");
                                    IndLine.TESTFIELD("Indented Quantity");
                                    IndLine.TESTFIELD("Job No.");
                                    IndLine.TESTFIELD("Job Task No.");
                                    //IndLine.TESTFIELD("Direct Unit Cost");
                                END;
                                IndLine.TESTFIELD("Shortcut Dimension 1 Code");
                                IndLine.TESTFIELD("Shortcut Dimension 2 Code");
                            // ALLEPG 041111 Start


                            // ALLEPG 041111 End
                            UNTIL IndLine.NEXT = 0;
                        END ELSE
                            ERROR('Cannot send Blank Indent!');

                        //dds-e
                        //ALLE-PKS16
                        Accept := CONFIRM(Text007, TRUE, 'Indent', Rec."Document No.");
                        IF NOT Accept THEN EXIT;

                        IF ApprovalsMgmt1.CheckPurchaseIndentApprovalsWorkflowEnabled(Rec) THEN
                            ApprovalsMgmt1.OnSendPurchaseIndentDocForApproval(Rec);

                        //ALLE-PKS03
                        IndLine.RESET;
                        IndLine.SETFILTER(IndLine."Document No.", Rec."Document No.");
                        IF IndLine.FIND('-') THEN
                            REPEAT
                                IndLine.VALIDATE("Sent for Approval", TRUE);
                                IndLine.MODIFY;
                            UNTIL IndLine.NEXT = 0;
                        //ALLE-PKS03
                        //JPL STOP

                        //ND
                        MESSAGE('Task Successfully Done for Document No. %1', Rec."Document No.");
                        //ND
                    end;
                }
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approve;

                    trigger OnAction()
                    var
                        ILE: Record "Item Ledger Entry";
                    begin

                        IF Rec."Shortcut Dimension 1 Code" <> Rec."Responsibility Center" THEN
                            ERROR(' Please check, Region Dimension code is different from Responsibility Center code');

                        //added by dds-14Feb2008
                        IndLine.RESET;
                        IndLine.SETRANGE("Document Type", Rec."Document Type");
                        IndLine.SETRANGE("Document No.", Rec."Document No.");
                        IF IndLine.FIND('-') THEN BEGIN
                            REPEAT
                                IF IndLine.Type = IndLine.Type::"Fixed Asset" THEN BEGIN

                                    IndLine.TESTFIELD(IndLine."FA SubGroup");
                                END
                                ELSE
                                    IF (IndLine.Type = IndLine.Type::"G/L Account") OR (IndLine.Type = IndLine.Type::Item) THEN BEGIN
                                        IndLine.TESTFIELD("No.");
                                        IndLine.TESTFIELD("Indented Quantity");
                                        //IndLine.TESTFIELD("Direct Unit Cost");
                                    END;
                                IndLine.TESTFIELD("Shortcut Dimension 1 Code");
                            //IndLine.TESTFIELD("Shortcut Dimension 2 Code");
                            UNTIL IndLine.NEXT = 0;
                        END ELSE
                            ERROR('Cannot send Blank Indent!');

                        Rec.TESTFIELD("Sent for Approval", TRUE);
                        Rec.TESTFIELD(Approved, FALSE);//ALLE-PKS16


                        IndLine.RESET;
                        IndLine.SETRANGE("Document Type", Rec."Document Type");
                        IndLine.SETRANGE("Document No.", Rec."Document No.");
                        IF IndLine.FIND('-') THEN
                            REPEAT
                                ILE.RESET;
                                ILE.SETCURRENTKEY("Location Code", "Item No.");
                                ILE.SETRANGE("Item No.", IndLine."No.");
                                ILE.SETRANGE("Location Code", Rec."Responsibility Center");
                                IF ILE.FINDFIRST THEN BEGIN
                                    ILE.CALCSUMS(ILE.Quantity);
                                    IndLine."Qty. at Indent Approval" := ILE.Quantity;
                                    IndLine.MODIFY;
                                END;
                            UNTIL IndLine.NEXT = 0;


                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RECORDID);
                        //ND
                        MESSAGE('Task Successfully Done for Document No. %1', Rec."Document No.");
                        //ND
                    end;
                }
                action(Return)
                {
                    Caption = 'Return';

                    trigger OnAction()
                    begin
                        // RIL1.06 080911 Start
                        Flag := FALSE;
                        PRLine2.RESET;
                        PRLine2.SETRANGE("Document Type", Rec."Document Type");
                        PRLine2.SETRANGE("Document No.", Rec."Document No.");
                        IF PRLine2.FINDFIRST THEN
                            REPEAT
                                IF (PRLine2."PO Qty" <> 0) OR (PRLine2."TO Qty" <> 0) THEN
                                    Flag := TRUE;
                            UNTIL PRLine2.NEXT = 0;

                        IF Rec.Approved AND NOT Flag THEN BEGIN
                            UserTasksNew2.RESET;
                            DocTypeApprovalRec2.RESET;
                            DocTypeApprovalRec2.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                            DocTypeApprovalRec2.SETRANGE("Document Type", DocTypeApprovalRec2."Document Type"::Indent);
                            DocTypeApprovalRec2.SETRANGE("Sub Document Type", DocTypeApprovalRec2."Sub Document Type"::" ");
                            DocTypeApprovalRec2.SETRANGE("Document No", Rec."Document No.");
                            DocTypeApprovalRec2.SETRANGE(Initiator, Rec.Indentor);
                            DocTypeApprovalRec2.SETRANGE(Status, DocTypeApprovalRec2.Status::Approved);
                            IF DocTypeApprovalRec2.FIND('-') THEN BEGIN
                                DocTypeApprovalRec2.Status := DocTypeApprovalRec2.Status::" ";
                                DocTypeApprovalRec2.MODIFY;

                                UserTasksNew2.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                              "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);
                                UserTasksNew2.SETRANGE("Transaction Type", UserTasksNew2."Transaction Type"::Purchase);
                                UserTasksNew2.SETRANGE("Document Type", UserTasksNew2."Document Type"::Indent);
                                UserTasksNew2.SETRANGE("Sub Document Type", UserTasksNew2."Sub Document Type"::" ");
                                UserTasksNew2.SETRANGE("Document No", Rec."Document No.");
                                UserTasksNew2.SETRANGE(Initiator, Rec.Indentor);
                                UserTasksNew2.SETRANGE("Document Approval Line No", DocTypeApprovalRec2."Line No");
                                UserTasksNew2.SETRANGE("Approvar ID", DocTypeApprovalRec2."Approvar ID");
                                UserTasksNew2.SETRANGE(Status, UserTasksNew2.Status::Approved);
                                IF UserTasksNew2.FIND('-') THEN BEGIN
                                    UserTasksNew2.Status := UserTasksNew2.Status::" ";
                                    UserTasksNew2.MODIFY;
                                END;
                            END;
                            UserTasksNew.RESET;
                            DocTypeApprovalRec.RESET;
                            DocTypeApprovalRec.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                            DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::Indent);
                            DocTypeApprovalRec.SETRANGE("Sub Document Type", DocTypeApprovalRec."Sub Document Type"::" ");
                            DocTypeApprovalRec.SETRANGE("Document No", Rec."Document No.");
                            DocTypeApprovalRec.SETRANGE(Initiator, Rec.Indentor);
                            DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                            IF DocTypeApprovalRec.FIND('-') THEN BEGIN

                                UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                                "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);

                                UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Purchase);
                                UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::Indent);
                                UserTasksNew.SETRANGE("Sub Document Type", UserTasksNew."Sub Document Type"::" ");
                                UserTasksNew.SETRANGE("Document No", Rec."Document No.");
                                UserTasksNew.SETRANGE(Initiator, Rec.Indentor);
                                UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                                UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                                UserTasksNew.SETRANGE(Status, UserTasksNew.Status::" ");
                                IF UserTasksNew.FIND('-') THEN
                                    UserTasksNew.ReturnPO(UserTasksNew);
                            END;

                            IF UserTasksNew.Status = UserTasksNew.Status::Returned THEN BEGIN
                                VendorEnquiryDetails.RESET;
                                VendorEnquiryDetails.SETRANGE("Indent No.", Rec."Document No.");
                                IF VendorEnquiryDetails.FINDFIRST THEN
                                    REPEAT
                                        VendorEnquiryDetails.Status := VendorEnquiryDetails.Status::Cancel;
                                        VendorEnquiryDetails.MODIFY;
                                    UNTIL VendorEnquiryDetails.NEXT = 0;
                            END;

                            MESSAGE('Task Successfully Done for Document No. %1', Rec."Document No.");

                        END;
                        // RIL1.06 080911 End

                        //TESTFIELD("Sent for Approval",TRUE);
                        IF (Rec."Sent for Approval") AND NOT (Rec.Approved) THEN BEGIN
                            UserTasksNew.RESET;
                            DocTypeApprovalRec.RESET;
                            DocTypeApprovalRec.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                            DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::Indent);
                            DocTypeApprovalRec.SETRANGE("Sub Document Type", DocTypeApprovalRec."Sub Document Type"::" ");
                            DocTypeApprovalRec.SETRANGE("Document No", Rec."Document No.");
                            DocTypeApprovalRec.SETRANGE(Initiator, Rec.Indentor);
                            DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                            IF DocTypeApprovalRec.FIND('-') THEN BEGIN

                                UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                                "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);

                                UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Purchase);
                                UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::Indent);
                                UserTasksNew.SETRANGE("Sub Document Type", UserTasksNew."Sub Document Type"::" ");
                                UserTasksNew.SETRANGE("Document No", Rec."Document No.");
                                UserTasksNew.SETRANGE(Initiator, Rec.Indentor);
                                UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                                UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                                UserTasksNew.SETRANGE(Status, UserTasksNew.Status::" ");
                                IF UserTasksNew.FIND('-') THEN
                                    UserTasksNew.ReturnPO(UserTasksNew);
                            END;


                            MESSAGE('Task Successfully Done for Document No. %1', Rec."Document No.");
                        END;
                    end;
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntries.Setfilters2(DATABASE::"Purchase Request Header", Rec."Document No.");
                        ApprovalEntries.RUN;
                    end;
                }
            }
            group("&Indent")
            {
                Caption = '&Indent';
                separator("--")
                {
                    Caption = '--';
                }
                action("Purchase Order Line")
                {
                    Caption = 'Purchase Order Line';
                    RunObject = Page "Purchase Lines";
                    RunPageLink = "Indent No" = FIELD("Document No.");
                    RunPageView = SORTING("Document Type", "Indent No", "Indent Line No")
                                  ORDER(Ascending)
                                  WHERE("Document Type" = FILTER(Order));
                    Visible = false;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Change &Item Indent Status")
                {
                    Caption = 'Change &Item Indent Status';

                    trigger OnAction()
                    var
                        Selection: Integer;
                    begin
                        //Alle-AYN-080605>>
                        //SC->>
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        /*
                        MemberOf.RESET;
                        MemberOf.SETRANGE("User ID",USERID);
                        MemberOf.SETFILTER("Role ID",'CLOSE-PO');
                        IF NOT MemberOf.FIND('-') THEN
                           ERROR('You don''t have permission to change the status');
                        */
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        //SC <<-


                        Selection := STRMENU(Text002, 2);
                        IF Selection <> 0 THEN BEGIN
                            Rec.CloseIndent(Selection);
                        END;
                        //Alle-AYN-080605<<

                    end;
                }
                action("Change &FA Indent Status")
                {
                    Caption = 'Change &FA Indent Status';

                    trigger OnAction()
                    begin
                        //SC->>
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        /*
                        MemberOf.RESET;
                        MemberOf.SETRANGE("User ID",USERID);
                        MemberOf.SETFILTER("Role ID",'CLOSE-FA');
                        IF NOT MemberOf.FIND('-') THEN
                           ERROR('You don''t have permission to change the status');
                        */
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        //SC <<-

                        Rec."Indent Status" := Rec."Indent Status"::Closed;
                        Rec.MODIFY;

                    end;
                }
                action("Get &Job Planning Lines")
                {
                    Caption = 'Get &Job Planning Lines';

                    trigger OnAction()
                    begin
                        // ALLEPG 271211 Start
                        IF Job.GET(Rec."Job Code") THEN
                            IF NOT Job.Approved THEN
                                ERROR('Project not yet approved')
                            ELSE BEGIN
                                IF ((Job.Amended) AND (NOT Job."Amendment Approved")) THEN
                                    ERROR('Project is under amendment');
                                CLEAR(TaskLines);
                                JobPlanningLine.RESET;
                                JobPlanningLine.SETRANGE(JobPlanningLine."Job No.", Rec."Job Code");
                                //JobPlanningLine.SETRANGE(JobPlanningLine."Job Task No.","Job Task");
                                JobPlanningLine.SETRANGE(JobPlanningLine."Line Type", JobPlanningLine."Line Type"::Schedule);
                                IF Rec."Indent Type" = Rec."Indent Type"::Supply THEN
                                    JobPlanningLine.SETRANGE(JobPlanningLine.Type, JobPlanningLine.Type::Item)
                                ELSE
                                    JobPlanningLine.SETRANGE(JobPlanningLine.Type, JobPlanningLine.Type::"G/L Account");

                                IF JobPlanningLine.FINDFIRST THEN
                                //KNLD1.00 150311
                                BEGIN
                                    REPEAT
                                        JobPlanningLine.CALCFIELDS("Indent Quantity");
                                        IF (JobPlanningLine."Indent Quantity" < JobPlanningLine.Quantity) THEN
                                            JobPlanningLine.MARK(TRUE);
                                    UNTIL JobPlanningLine.NEXT = 0;
                                    JobPlanningLine.MARKEDONLY(TRUE);
                                    IF JobPlanningLine.FINDFIRST THEN BEGIN
                                        TaskLines.Setpurchseheader(Rec."Document Type", Rec."Document No.");
                                        TaskLines.SETTABLEVIEW(JobPlanningLine);
                                        TaskLines.RUNMODAL;
                                    END;
                                    //KNLD1.00 150311
                                END;
                            END;
                        // ALLEPG 271211 End
                    end;
                }
                action("&Generate Enquiry")
                {
                    Caption = 'Generate Enquiry';
                    Visible = false;

                    trigger OnAction()
                    begin
                        //IF NOT ("Indent Status" IN["Indent Status"::Approved ,"Indent Status"::"Offer Received","Indent Status"::"Sent for Enquiry"]) THEN
                        IF NOT Rec.Approved THEN
                            ERROR('Enquiry cannot Be generated before approval');
                        CLEAR(Enquiry);

                        PRLIne.RESET;
                        PRLIne.SETRANGE("Document Type", Rec."Document Type");
                        PRLIne.SETRANGE("Document No.", Rec."Document No.");
                        PRLIne.SETRANGE(PRLIne."Send for Enquiry", TRUE);
                        IF NOT PRLIne.FIND('-') THEN
                            ERROR('You must Select Atlest one Line Before Creating Inquiry');

                        Enquiry.SetPrHeader(Rec."Document Type", Rec."Document No.");
                        Enquiry.RUNMODAL;
                    end;
                }
                action("Generate Enquiry")
                {
                    Caption = 'Generate Enquiry';

                    trigger OnAction()
                    begin
                        IF NOT Rec.Approved THEN
                            ERROR(Text50001);
                        CurrPage."Indent lines".PAGE.ShowItemVendor
                    end;
                }
            }
            action("&Print")
            {
                Caption = '&Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    IndentHdr.RESET;
                    IndentHdr.SETRANGE(IndentHdr."Document No.", Rec."Document No.");
                    IF IndentHdr.FIND('-') THEN
                        REPORT.RUN(97735, TRUE, FALSE, IndentHdr);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //ALLE-PKS 34
        RecRespCenter.RESET;
        RecRespCenter.SETRANGE(Code, Rec."Responsibility Center");
        IF RecRespCenter.FIND('-') THEN BEGIN
            Respname := RecRespCenter.Name;
            Short1name := RecRespCenter."Region Name";
            Locname := RecRespCenter."Location Name";
        END;
        //ALLE-PKS 34
        CurrPage.EDITABLE := TRUE;
        IF Rec."Sent for Approval" THEN
            "Indent DateEditable" := FALSE
        ELSE
            "Indent DateEditable" := TRUE;
        /*
        //JPL55 START
        MemberOf.RESET;
        MemberOf.SETRANGE("User ID",USERID);
        MemberOf.SETFILTER("Role ID",'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN BEGIN
          IF Approved=FALSE THEN BEGIN
            IF "Sent for Approval"=FALSE THEN BEGIN
              IF USERID=Indentor THEN BEGIN
                CurrPAGE.EDITABLE:=TRUE;
                CurrPAGE."Indent Date".EDITABLE := TRUE;
                CurrPAGE.Requirement.EDITABLE  := TRUE;
                CurrPAGE."Required By Date".EDITABLE  := TRUE;
                CurrPAGE."Indentors Justification".EDITABLE  := TRUE;
                CurrPAGE."Shortcut Dimension 1 Code".EDITABLE  := TRUE;
              END ELSE
                CurrPAGE.EDITABLE:=FALSE;
            END
            ELSE BEGIN
              DocApproval.RESET;
              DocApproval.SETRANGE("Document Type",DocApproval."Document Type"::Indent);
              //DocApproval.SETRANGE("Sub Document Type","Sub Document Type");
              DocApproval.SETFILTER("Document No",'%1',"Document No.");
              DocApproval.SETRANGE(Initiator,Indentor);
              DocApproval.SETRANGE(Status,DocApproval.Status::" ");
              IF DocApproval.FIND('-') THEN BEGIN
                IF (DocApproval."Approvar ID"=USERID) OR (DocApproval."Alternate Approvar ID"=USERID) THEN BEGIN
                  //CurrPAGE.EDITABLE:=TRUE
                  CurrPAGE."Indent Date".EDITABLE := FALSE;
                  CurrPAGE.Requirement.EDITABLE  := FALSE;
                  CurrPAGE."Required By Date".EDITABLE  := FALSE;
                  CurrPAGE."Indentors Justification".EDITABLE  := FALSE;
                  CurrPAGE."Shortcut Dimension 1 Code".EDITABLE  := FALSE;
                END
                ELSE
                  CurrPAGE.EDITABLE:=FALSE;
              END
              ELSE BEGIN
                CurrPAGE.EDITABLE:=FALSE;
              END;
            END;
          END
          ELSE
            CurrPAGE.EDITABLE:=FALSE;
        END;
        //JPL55 STOP
        CurrPAGE."Indent Date".EDITABLE := FALSE; //ALLE-PKS36
         */

    end;

    trigger OnDeleteRecord(): Boolean
    begin
        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
        /*
        MemberOf.RESET;
        MemberOf.SETRANGE("User ID",USERID);
        MemberOf.SETFILTER("Role ID",'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN BEGIN
          TESTFIELD(Approved,FALSE);
          TESTFIELD("Sent for Approval",FALSE);
        END;
        */
        // ALLE MM Code Commented as Member of table has been remove in NAV 2016

    end;

    trigger OnInit()
    begin
        "Purchaser CodeEditable" := TRUE;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
        /*
        MemberOf.RESET;
        MemberOf.SETRANGE("User ID",USERID);
        MemberOf.SETFILTER("Role ID",'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN
          TESTFIELD(Approved,FALSE);
        */
        // ALLE MM Code Commented as Member of table has been remove in NAV 2016

    end;

    trigger OnModifyRecord(): Boolean
    begin
        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
        /*
        MemberOf.RESET;
        MemberOf.SETRANGE("User ID",USERID);
        MemberOf.SETFILTER("Role ID",'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN
          TESTFIELD(Approved,FALSE);
        */
        // ALLE MM Code Commented as Member of table has been remove in NAV 2016

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //ALLE-SR-051107 >>
        Rec."Responsibility Center" := UserSetupMgt.GetPurchasesFilter();
        //ALLE-SR-051107 <<
    end;

    trigger OnOpenPage()
    begin


        IF UserSetupMgt.GetPurchasesFilter <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", UserSetupMgt.GetPurchasesFilter);
            Rec.FILTERGROUP(0);
        END;


        //ALLE-SR-051107 >>
        /*
        
        //ALLE-SR-051107 <<
         //JPL55 START
        IndHdr:=Rec;
        IF FIND('-') THEN
        REPEAT
          vFlag:=FALSE;
          // ALLE MM Code Commented as Member of table has been remove in NAV 2016
          {
          MemberOf.RESET;
          MemberOf.SETRANGE("User ID",USERID);
          MemberOf.SETFILTER("Role ID",'CLOSE-PO');
          //MemberOf.SETFILTER("Role ID",'SUPERPO');
          IF NOT MemberOf.FIND('-') THEN
          BEGIN
            IF USERID=Indentor THEN
              vFlag:=TRUE;
        
            MemberOf.RESET;
            MemberOf.SETRANGE("User ID",USERID);
            MemberOf.SETFILTER("Role ID",'VIEW-INDENT WFLOW');
            IF MemberOf.FIND('-') THEN
              vFlag:=TRUE;
          }
         // ALLE MM Code Commented as Member of table has been remove in NAV 2016
            DocApproval.RESET;
            DocApproval.SETRANGE("Document Type",DocApproval."Document Type"::Indent);
            //DocApproval.SETRANGE("Sub Document Type","Sub Document Type");
            DocApproval.SETFILTER("Document No",'%1',"Document No.");
            DocApproval.SETRANGE(Initiator,Indentor);
            //DocApproval.SETRANGE(Status,DocApproval.Status::" ");
            IF DocApproval.FIND('-') THEN
            REPEAT
              IF (DocApproval."Approvar ID"=USERID) OR (DocApproval."Alternate Approvar ID"=USERID) THEN
                vFlag:=TRUE;
            UNTIL DocApproval.NEXT=0;
            MARK(vFlag);
          //END ELSE
            MARK(TRUE);
        UNTIL NEXT=0;
        Rec.MARKEDONLY(TRUE);
        
        //may 1.1 Restricting normal users to edit the purchaser code...
        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
        {
        MemberOf.SETRANGE("User ID",USERID);
        //MemberOf.SETFILTER("Role ID",'SUPERPO');
        MemberOf.SETFILTER("Role ID",'CLOSE-PO');
        IF  MemberOf.FIND('-') THEN
          "Purchaser CodeEditable" := TRUE
        ELSE
          "Purchaser CodeEditable" := FALSE;
          }
        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
        //may 1.1 End.
        */

        IF Rec.GET(IndHdr."Document Type", IndHdr."Document No.") THEN;

        //ALLEND 191107
        RecRespCenter.RESET;
        RecRespCenter.SETRANGE(Code, Rec."Responsibility Center");
        IF RecRespCenter.FIND('-') THEN BEGIN
            Respname := RecRespCenter.Name;
            Short1name := RecRespCenter.Name;
            Locname := RecRespCenter."Location Name";
        END;

    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PurAndPay: Record "Purchases & Payables Setup";
        UserTasksNew: Record "User Tasks New";
        DocTypeApprovalRec: Record "Document Type Approval";
        IndentHdr: Record "Purchase Request Header";
        Text002: Label '&Cancel, &Short Closure';
        IndHdr: Record "Purchase Request Header";
        vFlag: Boolean;
        DocApproval: Record "Document Type Approval";
        IndDept: Code[20];
        IndLine: Record "Purchase Request Line";
        dimvalue: Record "Dimension Value";
        UserSetupMgt: Codeunit "EPC User Setup Management";
        Short1name: Text[50];
        Respname: Text[50];
        Locname: Text[50];
        RecDimValue: Record "Dimension Value";
        RecLocation: Record Location;
        RecRespCenter: Record "Responsibility Center 1";
        RecUserSetup: Record "User Setup";
        Text007: Label 'Do you want to Send the %1 No.-%2 For Approval';
        Accept: Boolean;
        JobPlanningLine: Record "Job Planning Line";
        TaskLines: Page "Get Job Planning Line";
        Enquiry: Page "Enquiry Vendor Lists";
        PRLIne: Record "Purchase Request Line";
        Text50001: Label 'Enquiry cannot Be generated before approval';
        UserTasksNew2: Record "User Tasks New";
        DocTypeApprovalRec2: Record "Document Type Approval";
        PRLine2: Record "Purchase Request Line";
        Flag: Boolean;
        VendorEnquiryDetails: Record "Vendor Enquiry Details";
        Job: Record Job;

        "Indent DateEditable": Boolean;

        "Purchaser CodeEditable": Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ApprovalsMgmt1: Codeunit MyCodeunit;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.UPDATE;
    end;
}

