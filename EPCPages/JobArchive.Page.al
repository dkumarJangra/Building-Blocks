page 97801 "Job Archive"
{
    // //ALLE : For form show according to user Responsibility center
    // //ALLESP : For Material supplied by enabled = true
    // ALLEAA - Show Field "BOQ Type" and Update Property "SubPAGELink" from "Job No.=FIELD(No.)" to
    //          "Job No.=FIELD(No.),BOQ Type=FIELD(BOQ Type)"
    // KLND1.00 ALLEPG 190510 : Added document tracking functionality.
    // ALLERP KRN0004 17-08-2010: Menu Item "Project Cosultants" has been added in JOB button
    // ALLERP KRN0011 23-08-2010: Menu Item "New Document Tracking" has been added in JOB button
    // ALLERP KRN0011 05-09-2010: Transmittal Tab deleted
    // ALLETG RIL0100 16-06-2011: Progress Sheet added
    // ALLETG RIL0006 25-07-2011: Changed "RunPAGELink" in Comment commandbutton, from option::14 > to option::Job
    // AIR0013 ALLEPG 290311 : Added code for amendment & amendment approve.
    // //AIR00020 ALLEDK 010811 For Non editable PAGE in case of approval

    Caption = 'Job Archive Card';
    Editable = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "EPC Job Archive";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    Editable = true;
                }
                field(Description; Rec.Description)
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description 2"; Rec."Description 2")
                {
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                }
                field("Bill-to Address"; Rec."Bill-to Address")
                {
                }
                field("Bill-to Address 2"; Rec."Bill-to Address 2")
                {
                }
                field("Bill-to City"; Rec."Bill-to City")
                {
                }
                field("Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
                {
                }
                field("Project Amount"; Rec."Project Amount")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Bill-to Contact No."; Rec."Bill-to Contact No.")
                {
                }
                field("Principal Customer No."; Rec."Principal Customer No.")
                {
                }
                field("Bill Paying Authority"; Rec."Bill Paying Authority")
                {
                }
                field("Search Description"; Rec."Search Description")
                {
                }
                field("Person Responsible"; Rec."Person Responsible")
                {
                }
                field(Blocked; Rec.Blocked)
                {
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                }
                field("BOQ Type"; Rec."BOQ Type")
                {
                }
                field("Contract Type"; Rec."Contract Type")
                {
                }
                field("Project Status"; Rec."Project Status")
                {
                }
                field("Project Site Location"; Rec."Project Site Location")
                {
                }
            }
            part(PhasesSubform; "Job Archive SubForm")
            {
                Editable = PhasesSubPAGEEditable;
                SubPageLink = "Job No." = FIELD("No.");
            }
            group(Posting)
            {
                Caption = 'Posting';
                field("WIP Method"; Rec."WIP Method")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Allow Schedule/Contract Lines"; Rec."Allow Schedule/Contract Lines")
                {
                }
                field("Other Material Requried"; Rec."Other Material Requried")
                {

                    trigger OnValidate()
                    begin
                        OtherMaterialRequriedOnPush;
                    end;
                }
                field("Material Supplied By"; Rec."Material Supplied By")
                {
                    Enabled = "Material Supplied ByEnable";
                }
            }
            group(Duration)
            {
                Caption = 'Duration';
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Ending Date"; Rec."Ending Date")
                {
                }
                field("LOI No."; Rec."LOI No.")
                {
                }
                field("LOI Date"; Rec."LOI Date")
                {
                }
                field("Agreement No."; Rec."Agreement No.")
                {
                }
                field("Agreement Signing Date"; Rec."Agreement Signing Date")
                {
                }
                field("Concession Period (Year)"; Rec."Concession Period (Year)")
                {
                    Caption = 'Concession Period Year/Month';
                }
                field("Concession Period (Month)"; Rec."Concession Period (Month)")
                {
                }
                field("Defect Liability (Year)"; Rec."Defect Liability (Year)")
                {
                    Caption = 'Defect Liability Year/Month';
                }
                field("Defect Liability (Month)"; Rec."Defect Liability (Month)")
                {
                }
                field("Extension Given From"; Rec."Extension Given From")
                {
                }
                field("Extension Given To"; Rec."Extension Given To")
                {
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code"; Rec."Currency Code")
                {
                    Editable = "Currency CodeEditable";

                    trigger OnValidate()
                    begin
                        CurrencyCheck;
                    end;
                }
                field("Invoice Currency Code"; Rec."Invoice Currency Code")
                {
                    Editable = "Invoice Currency CodeEditable";

                    trigger OnValidate()
                    begin
                        CurrencyCheck;
                    end;
                }
                field("Exch. Calculation (Cost)"; Rec."Exch. Calculation (Cost)")
                {
                }
                field("Exch. Calculation (Price)"; Rec."Exch. Calculation (Price)")
                {
                }
            }
            group("WIP and Recognition")
            {
                Caption = 'WIP and Recognition';
                field("WIP Posting Date"; Rec."WIP Posting Date")
                {
                }
                field("Total WIP Sales Amount"; Rec."Total WIP Sales Amount")
                {
                }
                field("Total WIP Cost Amount"; Rec."Total WIP Cost Amount")
                {
                }
                field("Recog. Sales Amount"; Rec."Recog. Sales Amount")
                {
                }
                field("Recog. Costs Amount"; Rec."Recog. Costs Amount")
                {
                }
                field("Calc. WIP Method Used"; Rec."Calc. WIP Method Used")
                {
                }
                field("WIP Posted To G/L"; Rec."WIP Posted To G/L")
                {
                }
                field("WIP G/L Posting Date"; Rec."WIP G/L Posting Date")
                {
                }
                field("Total WIP Sales G/L Amount"; Rec."Total WIP Sales G/L Amount")
                {
                }
                field("Total WIP Cost G/L Amount"; Rec."Total WIP Cost G/L Amount")
                {
                }
                field("Posted WIP Method Used"; Rec."Posted WIP Method Used")
                {
                }
            }
            group(Retention)
            {
                Caption = 'Retention';
                field("Retention Amount %"; Rec."Retention Amount %")
                {
                }
                field("Retention Amount"; Rec."Retention Amount")
                {
                    Editable = false;
                }
                field("Max. Retention Amount"; Rec."Max. Retention Amount")
                {
                }
            }
            group(Advance)
            {
                Caption = 'Advance';
                field("Mobilization Advance"; Rec."Mobilization Advance")
                {
                    Editable = false;
                }
                field("Mobilization Adj Starting %"; Rec."Mobilization Adj Starting %")
                {
                }
                field("Mobilization Adj Ending %"; Rec."Mobilization Adj Ending %")
                {
                }
                field("Mobilization Adv Remained"; Rec."Mobilization Adv Remained")
                {
                    Editable = false;
                }
                field("Equipment Advance"; Rec."Equipment Advance")
                {
                    Editable = false;
                }
                field("Equipment Adj Starting %"; Rec."Equipment Adj Starting %")
                {
                }
                field("Equipment Adj Ending %"; Rec."Equipment Adj Ending %")
                {
                }
                field("Equipment Adv Remained"; Rec."Equipment Adv Remained")
                {
                    Editable = false;
                }
                field("Secured Advance"; Rec."Secured Advance")
                {
                    Editable = false;
                }
                field("Secured Adj Starting %"; Rec."Secured Adj Starting %")
                {
                }
                field("Secured Adj Ending %"; Rec."Secured Adj Ending %")
                {
                }
                field("Secured Adv Remained"; Rec."Secured Adv Remained")
                {
                    Editable = false;
                }
                field("Adhoc Advance"; Rec."Adhoc Advance")
                {
                    Editable = false;
                }
                field("Adhoc Adj Starting %"; Rec."Adhoc Adj Starting %")
                {
                }
                field("Adhoc Adj Ending %"; Rec."Adhoc Adj Ending %")
                {
                }
                field("Adhoc Adv Remained"; Rec."Adhoc Adv Remained")
                {
                    Editable = false;
                }
            }
            group(Deposit)
            {
                Caption = 'Deposit';
                field("Earnest Money Deposit Amt."; Rec."Earnest Money Deposit Amt.")
                {
                    Editable = false;
                }
                field("Initial Security Deposit Amt."; Rec."Initial Security Deposit Amt.")
                {
                    Editable = false;
                }
                field("Performance Gurantee Amt."; Rec."Performance Gurantee Amt.")
                {
                    Editable = false;
                }
                field("Deposit Against Advance"; Rec."Deposit Against Advance")
                {
                    Editable = false;
                }
                field("Security Deposit Amt."; Rec."Security Deposit Amt.")
                {
                    Editable = false;
                }
                field(LC; Rec.LC)
                {
                    Editable = false;
                }
            }
            group(Transmittal)
            {
                Caption = 'Transmittal';
                field("Transmittal No. Series"; Rec."Transmittal No. Series")
                {
                }
            }
            group(Approval)
            {
                Caption = 'Approval';
                field("Job Creation Date"; Rec."Job Creation Date")
                {
                    Caption = 'Creation Date &&Time';
                    Editable = false;
                }
                field("Job Creation Time"; Rec."Job Creation Time")
                {
                    Editable = false;
                }
                field("Sent for Approval Date"; Rec."Sent for Approval Date")
                {
                    Editable = false;
                }
                field("Sent for Approval Time"; Rec."Sent for Approval Time")
                {
                    Editable = false;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    Caption = 'Approved Date &&Time';
                    Editable = false;
                }
                part("Document No Approval"; "Document No Approval")
                {
                    SubPageLink = "Document Type" = CONST(Job),
                                  "Sub Document Type" = FILTER(' '),
                                  Initiator = FIELD(Initiator),
                                  "Document No" = FIELD("No.");
                    SubPageView = SORTING("Document Type", "Sub Document Type", "Document No", Initiator, "Key Responsibility Center", "Line No")
                                  ORDER(Ascending)
                                  WHERE("Document No" = FILTER(<> ''));
                }
                field("Approved Time"; Rec."Approved Time")
                {
                    Editable = false;
                }
                part("User Tasks New sub Form"; "User Tasks New sub Form")
                {
                    SubPageLink = "Transaction Type" = FILTER(Purchase),
                                  "Document Type" = FILTER(Job),
                                  "Document No" = FIELD("No.");
                }
                field(Initiator; Rec.Initiator)
                {
                    Editable = false;
                }
                field("Sent for Approval"; Rec."Sent for Approval")
                {
                    Editable = false;
                }
                field(Approved; Rec.Approved)
                {
                    Editable = false;
                }
            }
            group(Amendment)
            {
                Caption = 'Amendment';
                field(Amended; Rec.Amended)
                {
                    Editable = false;
                }
                field("Amendment Approved"; Rec."Amendment Approved")
                {
                    Editable = false;
                }
                part(""; "Document No Approval")
                {
                    SubPageLink = "Document Type" = CONST("Job Amendment"),
                                  "Sub Document Type" = FILTER(' '),
                                  Initiator = FIELD(Initiator),
                                  "Document No" = FIELD("No.");
                    SubPageView = SORTING("Document Type", "Sub Document Type", "Document No", Initiator, "Key Responsibility Center", "Line No")
                                  ORDER(Ascending)
                                  WHERE("Document No" = FILTER(<> ''));
                }
                field("Amendment Initiator"; Rec."Amendment Initiator")
                {
                    Editable = false;
                }
                field("Amendment Approved Date"; Rec."Amendment Approved Date")
                {
                    Editable = false;
                }
                field("Amendment Approved Time"; Rec."Amendment Approved Time")
                {
                    Editable = false;
                }
            }
            group(Version)
            {
                Caption = 'Version';
                field("Version No."; Rec."Version No.")
                {
                }
                field("Archived By"; Rec."Archived By")
                {
                }
                field("Date Archived"; Rec."Date Archived")
                {
                }
                field("Time Archived"; Rec."Time Archived")
                {
                }
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
                Visible = false;
                action("Send For Approval")
                {
                    Caption = 'Send For Approval';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Sent for Approval", FALSE);//ALLE-PKS16

                        Accept := CONFIRM(Text50001, TRUE, 'Job', Rec."No.");
                        IF NOT Accept THEN EXIT;
                        //ALLE-PKS16
                        IF Rec."Sent for Approval" = FALSE THEN BEGIN
                            Rec.VALIDATE("Sent for Approval", TRUE);
                            Rec."Sent for Approval Date" := TODAY;
                            Rec."Sent for Approval Time" := TIME;
                            Rec.MODIFY;
                            UserTasksNew.AuthorizationPO(UserTasksNew."Transaction Type"::Purchase, UserTasksNew."Document Type"::Job,
                            UserTasksNew."Sub Document Type"::" ", Rec."No.");
                            CurrPage.UPDATE(TRUE);
                        END;
                        MESSAGE('Task Successfully Done for Document No. %1', Rec."No.");
                        //ArchiveMgmt.StoreJob(Rec);
                    end;
                }
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approve;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Sent for Approval", TRUE);
                        Rec.TESTFIELD(Approved, FALSE);


                        UserTasksNew.RESET;
                        DocTypeApprovalRec.RESET;
                        DocTypeApprovalRec.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                        DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::Job);
                        DocTypeApprovalRec.SETRANGE("Sub Document Type", DocTypeApprovalRec."Sub Document Type"::" ");
                        DocTypeApprovalRec.SETRANGE("Document No", Rec."No.");
                        DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                        DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                        IF DocTypeApprovalRec.FIND('-') THEN BEGIN

                            UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                            "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);

                            UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Purchase);
                            UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::Job);
                            UserTasksNew.SETRANGE("Sub Document Type", DocTypeApprovalRec."Sub Document Type"::" ");
                            UserTasksNew.SETRANGE("Document No", Rec."No.");
                            UserTasksNew.SETRANGE(Initiator, Rec.Initiator);
                            UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                            UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                            UserTasksNew.SETRANGE(Status, UserTasksNew.Status::" ");
                            IF UserTasksNew.FIND('-') THEN
                                UserTasksNew.ApproveJob(UserTasksNew);
                        END;
                        IF Rec.Approved = TRUE THEN
                            CurrPage.EDITABLE(FALSE);
                    end;
                }
                action(Return)
                {
                    Caption = 'Return';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Sent for Approval", TRUE);
                        Rec.TESTFIELD(Approved, FALSE);

                        UserTasksNew.RESET;
                        DocTypeApprovalRec.RESET;
                        DocTypeApprovalRec.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                        DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::Job);
                        DocTypeApprovalRec.SETRANGE("Sub Document Type", DocTypeApprovalRec."Sub Document Type"::" ");
                        DocTypeApprovalRec.SETRANGE("Document No", Rec."No.");
                        DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                        DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                        IF DocTypeApprovalRec.FIND('-') THEN BEGIN

                            UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                            "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);

                            UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Purchase);
                            UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::Job);
                            UserTasksNew.SETRANGE("Sub Document Type", DocTypeApprovalRec."Sub Document Type"::" ");
                            UserTasksNew.SETRANGE("Document No", Rec."No.");
                            UserTasksNew.SETRANGE(Initiator, Rec.Initiator);
                            UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                            UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                            UserTasksNew.SETRANGE(Status, UserTasksNew.Status::" ");
                            IF UserTasksNew.FIND('-') THEN
                                UserTasksNew.ReturnPO(UserTasksNew);
                        END;
                    end;
                }
            }
            group("Plan&ning")
            {
                Caption = 'Plan&ning';
                Visible = false;
                action("Resource Allocated per Job")
                {
                    Caption = 'Resource Allocated per Job';
                    RunObject = Page "Resource Allocated per Job";
                }
                action("Project Budget Temporary")
                {
                    Caption = 'Project Budget Temporary';
                    RunObject = Page "Milestone Completed";
                    Visible = false;
                }
                separator(a)
                {
                    Caption = 'a';
                }
                action("Res. &Gr. Allocated per Job")
                {
                    Caption = 'Res. &Gr. Allocated per Job';
                    RunObject = Page "Res. Gr. Allocated per Job";
                }
            }
            group("W&IP")
            {
                Caption = 'W&IP';
                Visible = false;
                action("Calculate WIP")
                {
                    Caption = 'Calculate WIP';
                    Ellipsis = true;
                    Image = CalculateWIP;

                    trigger OnAction()
                    var
                        Job: Record Job;
                    begin
                        Rec.TESTFIELD("No.");
                        Job.COPY(Rec);
                        Job.SETRANGE("No.", Rec."No.");
                        REPORT.RUNMODAL(REPORT::"Job Calculate WIP", TRUE, FALSE, Job);
                    end;
                }
                action("Post WIP to G/L")
                {
                    Caption = 'Post WIP to G/L';
                    Ellipsis = true;
                    Image = Post;

                    trigger OnAction()
                    var
                        Job: Record Job;
                    begin
                        Rec.TESTFIELD("No.");
                        Job.COPY(Rec);
                        Job.SETRANGE("No.", Rec."No.");
                        REPORT.RUNMODAL(REPORT::"Job Post WIP to G/L", TRUE, FALSE, Job);
                    end;
                }
                action("WIP Entries")
                {
                    Caption = 'WIP Entries';
                    RunObject = Page "Job WIP Entries";
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageView = SORTING("Job No.", "Job Posting Group", "WIP Posting Date");
                }
                action("WIP G/L Entries")
                {
                    Caption = 'WIP G/L Entries';
                    RunObject = Page "Job WIP G/L Entries";
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageView = SORTING("Job No.");
                }
            }
            group("&Prices")
            {
                Caption = '&Prices';
                Visible = false;
                action(Resource)
                {
                    Caption = 'Resource';
                    RunObject = Page "Job Resource Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                }
                action(Item)
                {
                    Caption = 'Item';
                    RunObject = Page "Job Item Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                }
                action("G/L Account")
                {
                    Caption = 'G/L Account';
                    RunObject = Page "Job G/L Account Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                }
            }
            group("&Job")
            {
                Caption = '&Job';
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Job),
                                  "No." = FIELD("No.");
                    Visible = false;
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(167),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    Visible = false;
                }
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    RunObject = Page "Job Ledger Entries";
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    Visible = false;
                }
                action("Job Task Lines")
                {
                    Caption = 'Job Task Lines';
                    Image = TaskList;

                    trigger OnAction()
                    var
                        JTLines: Page "Job Task Archive Lines";
                    begin
                        JobTaskArchive.RESET;
                        JobTaskArchive.SETRANGE("Job No.", Rec."No.");
                        JobTaskArchive.SETRANGE("Version No.", Rec."Version No.");
                        IF JobTaskArchive.FINDFIRST THEN
                            IF PAGE.RUNMODAL(Page::"Job Task Archive Lines", JobTaskArchive) = ACTION::LookupOK THEN;
                    end;
                }
                action("Job &Planning Lines")
                {
                    Caption = 'Job &Planning Lines';
                    Visible = false;

                    trigger OnAction()
                    begin
                        CurrPage.PhasesSubform.PAGE.GetJobPlanningLine;
                    end;
                }
                action(Consultant)
                {
                    Caption = 'Consultant';
                    RunObject = Page "Specification Master";
                    Visible = false;
                }
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Job Statistics";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                    Visible = false;
                }
                action("&Attach Documents")
                {
                    Caption = '&Attach Documents';
                    RunObject = Page Documents;
                    Visible = false;
                }
                action("Document Tracking")
                {
                    Caption = 'Document Tracking';
                    RunObject = Page "Application Payments Subform";
                    RunPageLink = "Document No." = FIELD("No.");
                    Visible = false;
                }
                action("Progress Sheet")
                {
                    Caption = 'Progress Sheet';
                    RunObject = Page "Daily Progress Report";
                    Visible = false;
                }
                action("Online Map")
                {
                    Caption = 'Online Map';
                    Visible = false;

                    trigger OnAction()
                    begin
                        Rec.DisplayMap;
                    end;
                }
                action(Escalation)
                {
                    Caption = 'Escalation';
                    RunObject = Page "Purch Delivery Schd. Archive";
                    Visible = false;
                }
                action("BOQ List")
                {
                    Caption = 'BOQ List';
                    RunObject = Page "BOQ Item List";
                    RunPageLink = "Project Code" = FIELD("No."),
                                  "BOQ Type" = FIELD("BOQ Type");
                    Visible = false;
                }
                action("Project Compliance Details")
                {
                    Caption = 'Project Compliance Details';
                    RunObject = Page "Insurance List";
                    RunPageLink = "Global Dimension 1 Code" = FIELD("No.");
                    Visible = false;
                }
                action("Project Extentions")
                {
                    Caption = 'Project Extentions';
                    RunObject = Page "Incentive Calculation List";
                    RunPageLink = "Associate Code" = FIELD("No.");
                    Visible = false;
                }
                action("Work Experience")
                {
                    Caption = 'Work Experience';
                    RunObject = Page "Voucher Sub form Incentive";
                    RunPageLink = "Voucher No." = FIELD("No.");
                    Visible = false;
                }
                action("&Document Tracking")
                {
                    Caption = 'Document Tracking';
                    Visible = false;

                    trigger OnAction()
                    begin
                        //ALLERP KRN0011 Start:
                        Rec.ShowDocument;
                        //ALLERP KRN0011 End:
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Visible = false;
                action("Copy Job")
                {
                    Caption = 'Copy Job';
                    Ellipsis = true;
                    Image = CopyFromTask;
                    //RunObject = Report 1084;
                }
                action("&Send For Approval")
                {
                    Caption = 'Send For Approval';
                    Visible = false;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Sent for Approval", FALSE);//ALLE-PKS16
                        //JPL START
                        IF Rec.Initiator <> UPPERCASE(USERID) THEN
                            ERROR('Un-Authorized Indentor');

                        Accept := CONFIRM(Text50001, TRUE, 'Job', Rec."No.");
                        IF NOT Accept THEN EXIT;
                        //ALLE-PKS16
                        IF Rec."Sent for Approval" = FALSE THEN BEGIN
                            Rec.VALIDATE("Sent for Approval", TRUE);
                            Rec."Sent for Approval Date" := TODAY;
                            Rec."Sent for Approval Time" := TIME;
                            Rec.MODIFY;
                            UserTasksNew.AuthorizationPO(UserTasksNew."Transaction Type"::Purchase, UserTasksNew."Document Type"::Job,
                            UserTasksNew."Sub Document Type"::" ", Rec."No.");
                            CurrPage.UPDATE(TRUE);
                        END;
                        MESSAGE('Task Successfully Done for Document No. %1', Rec."No.");
                        //ArchiveMgmt.StoreJob(Rec);
                    end;
                }
                action("&Approve")
                {
                    Caption = 'Approve';
                    Image = Approve;
                    Visible = false;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Sent for Approval", TRUE);
                        Rec.TESTFIELD(Approved, FALSE);


                        UserTasksNew.RESET;
                        DocTypeApprovalRec.RESET;
                        DocTypeApprovalRec.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                        DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::Job);
                        DocTypeApprovalRec.SETRANGE("Sub Document Type", DocTypeApprovalRec."Sub Document Type"::" ");
                        DocTypeApprovalRec.SETRANGE("Document No", Rec."No.");
                        DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                        DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                        IF DocTypeApprovalRec.FIND('-') THEN BEGIN

                            UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                            "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);

                            UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Purchase);
                            UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::Job);
                            UserTasksNew.SETRANGE("Sub Document Type", DocTypeApprovalRec."Sub Document Type"::" ");
                            UserTasksNew.SETRANGE("Document No", Rec."No.");
                            UserTasksNew.SETRANGE(Initiator, Rec.Initiator);
                            UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                            UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                            UserTasksNew.SETRANGE(Status, UserTasksNew.Status::" ");
                            IF UserTasksNew.FIND('-') THEN
                                UserTasksNew.ApproveJob(UserTasksNew);
                        END;
                        IF Rec.Approved = TRUE THEN
                            CurrPage.EDITABLE(FALSE);
                    end;
                }
                action("&Return")
                {
                    Caption = 'Return';
                    Visible = false;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Sent for Approval", TRUE);
                        Rec.TESTFIELD(Approved, FALSE);

                        UserTasksNew.RESET;
                        DocTypeApprovalRec.RESET;
                        DocTypeApprovalRec.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                        DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::Job);
                        DocTypeApprovalRec.SETRANGE("Sub Document Type", DocTypeApprovalRec."Sub Document Type"::" ");
                        DocTypeApprovalRec.SETRANGE("Document No", Rec."No.");
                        DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                        DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                        IF DocTypeApprovalRec.FIND('-') THEN BEGIN

                            UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                            "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);

                            UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Purchase);
                            UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::Job);
                            UserTasksNew.SETRANGE("Sub Document Type", DocTypeApprovalRec."Sub Document Type"::" ");
                            UserTasksNew.SETRANGE("Document No", Rec."No.");
                            UserTasksNew.SETRANGE(Initiator, Rec.Initiator);
                            UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                            UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                            UserTasksNew.SETRANGE(Status, UserTasksNew.Status::" ");
                            IF UserTasksNew.FIND('-') THEN
                                UserTasksNew.ReturnPO(UserTasksNew);
                        END;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //AIR00020
        PhasesSubPAGEEditable := NOT Rec.Approved;
        //AIR00020
    end;

    trigger OnInit()
    begin
        "Material Supplied ByEnable" := TRUE;
        "Currency CodeEditable" := TRUE;
        "Invoice Currency CodeEditable" := TRUE;
        MapPointVisible := TRUE;
        PhasesSubPAGEEditable := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

        //ALLE
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter();
        //ALLE
        Rec.Blocked := Rec.Blocked::Posting
    end;

    trigger OnOpenPage()
    var
        MapMgt: Codeunit "Online Map Management";
    begin
        IF NOT MapMgt.TestSetup THEN
            MapPointVisible := FALSE;

        CurrencyCheck;
        //ALLE
        IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", UserMgt.GetPurchasesFilter());
            Rec.FILTERGROUP(0);
        END;
        //ALLE
    end;

    var
        UserMgt: Codeunit "User Setup Management";
        ArchiveMgmt: Codeunit ArchiveManagement;
        Accept: Boolean;
        UserTasksNew: Record "User Tasks New";
        DocTypeApprovalRec: Record "Document Type Approval";
        Text50001: Label 'Do you want to Send the %1 No.-%2 For Approval';
        Text50002: Label 'Do you want to Send the %1 No.-%2 For Ammend';
        Ammend: Boolean;
        //ArchivePO: Report 97796;
        JobTaskArchive: Record "EPC Job Task Archive";
        PhasesSubPAGEEditable: Boolean;

        MapPointVisible: Boolean;

        "Invoice Currency CodeEditable": Boolean;

        "Currency CodeEditable": Boolean;

        "Material Supplied ByEnable": Boolean;


    procedure CurrencyCheck()
    begin
        IF Rec."Currency Code" <> '' THEN
            "Invoice Currency CodeEditable" := FALSE
        ELSE
            "Invoice Currency CodeEditable" := TRUE;

        IF Rec."Invoice Currency Code" <> '' THEN
            "Currency CodeEditable" := FALSE
        ELSE
            "Currency CodeEditable" := TRUE;
    end;


    procedure EnableControl()
    begin
        //ALLESP BCL0004 06-07-2007 Start:
        IF Rec."Other Material Requried" = TRUE THEN
            "Material Supplied ByEnable" := TRUE
        ELSE
            "Material Supplied ByEnable" := FALSE;
        //ALLESP BCL0004 06-07-2007 End:
    end;

    local procedure BilltoCustomerNoC1000000115OnA()
    begin
        CurrPage.UPDATE;
    end;

    local procedure OtherMaterialRequriedOnPush()
    begin
        EnableControl; //ALLESP BCL0004 06-07-2007
    end;
}

