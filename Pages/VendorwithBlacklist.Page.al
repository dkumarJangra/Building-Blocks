page 50106 "Vendor with Blacklist"
{
    Caption = 'Vendor with black list';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Vendor;
    SourceTableView = WHERE("No." = FILTER('IBA*'));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field(Name; Rec.Name)
                {
                    Editable = false;
                }
                field("Name 2"; Rec."Name 2")
                {
                    Editable = false;
                }
                field(Address; Rec.Address)
                {
                    Editable = false;
                    Visible = AddVisible;
                }
                field("Address 2"; Rec."Address 2")
                {
                    Editable = false;
                    Visible = Add2Visible;
                }
                field(City; Rec.City)
                {
                    Editable = false;
                }
                field(Contact; Rec.Contact)
                {
                    Editable = false;
                    Visible = ContactVisible;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    Editable = false;
                    Visible = PhVisible;
                }
                field("Telex No."; Rec."Telex No.")
                {
                    Editable = false;
                }
                field("Vendor Posting Group"; Rec."Vendor Posting Group")
                {
                    Editable = false;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    Editable = false;
                }
                field(Comment; Rec.Comment)
                {
                    Editable = false;
                }
                field(Blocked; Rec.Blocked)
                {
                    Editable = false;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    Editable = false;
                }
                field("Fax No."; Rec."Fax No.")
                {
                    Editable = false;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    Editable = false;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    Editable = false;
                }
                field("Post Code"; Rec."Post Code")
                {
                    Editable = false;
                }
                field(County; Rec.County)
                {
                    Editable = false;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    Editable = false;
                }
                field("P.A.N. No."; Rec."P.A.N. No.")
                {
                    Editable = false;
                }
                field("Old P.A.N. No."; Rec."BBG Old P.A.N. No.")
                {
                    Editable = false;
                }
                field("State Code"; Rec."State Code")
                {
                    Editable = false;
                }
                // field("Vendor Type"; Rec."Vendor Type")
                // {
                //     Editable = false;
                // }
                field("P.A.N. Reference No."; Rec."P.A.N. Reference No.")
                {
                    Editable = false;
                }
                field("P.A.N. Status"; Rec."P.A.N. Status")
                {
                    Editable = false;
                }
                field("GST Registration No."; Rec."GST Registration No.")
                {
                    Editable = false;
                }
                field("GST Vendor Type"; Rec."GST Vendor Type")
                {
                    Editable = false;
                }
                field("Address 3"; Rec."BBG Address 3")
                {
                    Editable = false;
                }
                field("Phone No. 2"; Rec."BBG Phone No. 2")
                {
                    Editable = false;
                    Visible = Ph2Visible;
                }
                field("Mob. No."; Rec."BBG Mob. No.")
                {
                    Visible = MobVisible;
                }
                field("Old Mobile No."; Rec."BBG Old Mobile No.")
                {
                    Editable = false;
                    Visible = MobVisible;
                }
                field("Vendor Category"; Rec."BBG Vendor Category")
                {
                    Editable = false;
                }
                field("Creation Date"; Rec."BBG Creation Date")
                {
                    Editable = false;
                }
                field("Black List"; Rec."BBG Black List")
                {

                    trigger OnValidate()
                    var
                        AssStatus: Text;
                    begin
                        Rec.TESTFIELD("BBG Approval Status BlackList", Rec."BBG Approval Status BlackList"::Approved);

                        CLEAR(WebAppService);
                        RegionwiseVendor.RESET;
                        RegionwiseVendor.SETCURRENTKEY(RegionwiseVendor."No.");
                        RegionwiseVendor.SETRANGE("No.", Rec."No.");
                        IF RegionwiseVendor.FINDFIRST THEN;
                        RankCodeMaster.RESET;
                        RankCodeMaster.SETRANGE("Rank Batch Code", RegionwiseVendor."Region Code");
                        RankCodeMaster.SETRANGE(Code, RegionwiseVendor."Rank Code");
                        IF RankCodeMaster.FINDFIRST THEN;
                        IF Rec."BBG Black List" THEN
                            AssStatus := 'Deactivate'
                        ELSE
                            AssStatus := 'Active';

                        WebAppService.Post_data('', Rec."No.", Rec.Name, Rec."BBG Mob. No.", Rec."E-Mail", Rec."BBG Team Code", Rec."BBG Leader Code", RegionwiseVendor."Parent Code",
                        FORMAT(AssStatus), FORMAT(RegionwiseVendor."Rank Code"), RankCodeMaster.Description);
                        //ALLEDK 221123
                    end;
                }
                field("Cluster Type"; Rec."BBG Cluster Type")
                {
                    Editable = false;
                }
                field(Status; Rec."BBG Status")
                {
                    Editable = false;
                }
                field("Date of Birth"; Rec."BBG Date of Birth")
                {
                    Editable = false;
                }
                field("Date of Joining"; Rec."BBG Date of Joining")
                {
                    Editable = false;
                }
                field(Sex; Rec."BBG Sex")
                {
                    Editable = false;
                }
                field("Marital Status"; Rec."BBG Marital Status")
                {
                    Editable = false;
                }
                field(Introducer; Rec."BBG Introducer")
                {
                    Editable = false;
                }
                field("In-Active Associate"; Rec."BBG In-Active Associate")
                {
                    Editable = false;
                }
                field("BBG Reporting Leader"; Rec."BBG Reporting Leader")
                {

                }

            }
            part(""; "Document Approval Details")
            {
                SubPageLink = "Document No." = FIELD("No."),
                              "Document Type" = CONST("Vendor Black List");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Approvals)
            {
                action("Send For Approval")
                {
                    Caption = 'Send For Approval (For Vendor)';
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    var
                        LineNo: Integer;
                    begin
                        //Vendor

                        Rec.TESTFIELD("BBG Black List", TRUE);
                        Rec.TESTFIELD("BBG Approval Status BlackList", Rec."BBG Approval Status BlackList"::" ");
                        IF CONFIRM('Do  you want to send Document Send for Approval') THEN BEGIN
                            Rec.TESTFIELD("BBG Send for Approval", FALSE);
                            LineNo := 0;
                            RequesttoApproveDocuments.RESET;
                            RequesttoApproveDocuments.SETRANGE("Document Type", RequesttoApproveDocuments."Document Type"::"Vendor Black List");
                            RequesttoApproveDocuments.SETRANGE("Document No.", Rec."No.");
                            IF RequesttoApproveDocuments.FINDLAST THEN
                                LineNo := RequesttoApproveDocuments."Line No.";

                            ApprovalWorkflowforAuditPr.RESET;
                            ApprovalWorkflowforAuditPr.SETRANGE("Document Type", ApprovalWorkflowforAuditPr."Document Type"::"Vendor Black List");
                            ApprovalWorkflowforAuditPr.SETRANGE("Requester ID", USERID);
                            IF ApprovalWorkflowforAuditPr.FINDSET THEN BEGIN
                                REPEAT
                                    RequesttoApproveDocuments.RESET;
                                    RequesttoApproveDocuments.INIT;
                                    RequesttoApproveDocuments."Document Type" := RequesttoApproveDocuments."Document Type"::"Vendor Black List";
                                    RequesttoApproveDocuments."Document No." := Rec."No.";
                                    //RequesttoApproveDocuments."Document Line No." := "Line No.";
                                    RequesttoApproveDocuments."Line No." := LineNo + 10000;
                                    //RequesttoApproveDocuments.Amount := Amount;
                                    //RequesttoApproveDocuments."Posting Date" := "Posting Date";
                                    RequesttoApproveDocuments."Requester ID" := USERID;
                                    RequesttoApproveDocuments."Approver ID" := ApprovalWorkflowforAuditPr."Approver ID";
                                    RequesttoApproveDocuments.Sequence := ApprovalWorkflowforAuditPr.Sequence;
                                    RequesttoApproveDocuments."Requester DateTime" := CURRENTDATETIME;
                                    RequesttoApproveDocuments.INSERT;
                                    LineNo := RequesttoApproveDocuments."Line No."
                              UNTIL ApprovalWorkflowforAuditPr.NEXT = 0;
                                Rec."BBG Send for Approval BlackList" := TRUE;
                                Rec."BBG Send for Aproval Date BList" := TODAY;
                                Rec."BBG Approval Status BlackList" := Rec."BBG Approval Status BlackList"::" ";
                                Rec.MODIFY;
                            END ELSE
                                ERROR('Approver not found against this Sender');
                        END ELSE
                            MESSAGE('Nothing Process');
                    end;
                }
                action(Reopen)
                {
                    Caption = 'Reopen (For Vendor)';

                    trigger OnAction()
                    var
                        Vendor_2: Record Vendor;
                    begin
                        //TESTFIELD("Approval Status BlackList","Approval Status BlackList"::Approved);

                        Rec."BBG Approval Status BlackList" := Rec."BBG Approval Status BlackList"::" ";
                        Rec."BBG Send for Approval BlackList" := FALSE;
                        Rec."BBG Send for Aproval Date BList" := 0D;
                        Rec.MODIFY;
                    end;
                }
                action("Show Document Attachments")
                {
                    Caption = '&Attach Documents (For 7 Server)';
                    Promoted = true;
                    RunObject = Page "Document file Upload";
                    RunPageLink = "Table No." = CONST(23),
                                  "Document No." = FIELD("No.");
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Showfields;
    end;

    trigger OnOpenPage()
    begin
        Showfields;
    end;

    var
        memberof: Record "Access Control";
        MobVisible: Boolean;
        AddVisible: Boolean;
        Add2Visible: Boolean;
        Add3Visible: Boolean;
        PhVisible: Boolean;
        Ph2Visible: Boolean;
        ContactVisible: Boolean;
        RequesttoApproveDocuments: Record "Request to Approve Documents";
        ApprovalWorkflowforAuditPr: Record "Approval Workflow for Audit Pr";
        WebAppService: Codeunit "Web App Service";
        RegionwiseVendor: Record "Region wise Vendor";
        RankCodeMaster: Record "Rank Code";


    procedure Showfields()
    begin
        //BBG2.01 22/07/14
        CLEAR(memberof);
        memberof.RESET;
        memberof.SETRANGE("User Name", USERID);
        memberof.SETRANGE("Role ID", 'VENDLISTINFOVISIBLE');
        IF NOT memberof.FINDFIRST THEN BEGIN
            MobVisible := FALSE;
            AddVisible := FALSE;
            Add2Visible := FALSE;
            Add3Visible := FALSE;
            PhVisible := FALSE;
            Ph2Visible := FALSE;
            ContactVisible := FALSE;
            // ALLE MM NAV 2009 Code Commented
            /*
            CurrPage."Mobile No.".VISIBLE(FALSE);
            CurrPage.Address.VISIBLE(FALSE);
            CurrPage."Address 2".VISIBLE(FALSE);
            CurrPage."Address 3".VISIBLE(FALSE);
            CurrPage."Phone No.".VISIBLE(FALSE);
            CurrPage."Phone No. 2".VISIBLE(FALSE);
            CurrPage.Contact.VISIBLE(FALSE);
            */
            // ALLE MM NAV 2009 Code Commented
        END ELSE BEGIN
            MobVisible := TRUE;
            AddVisible := TRUE;
            Add2Visible := TRUE;
            Add3Visible := TRUE;
            PhVisible := TRUE;
            Ph2Visible := TRUE;
            ContactVisible := TRUE;
        END;

    end;
}

