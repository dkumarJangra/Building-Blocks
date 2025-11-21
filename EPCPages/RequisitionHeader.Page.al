page 97795 "Requisition Header"
{
    // // may 1.1 restricting other than SUPERPO role to edit
    // //ALLE-SR-051107 : Responsibilty center added
    // //ALLE-PKS03 for Setting the Send For Approval to the indent lines
    // //ALLE-PKS 34 for the names of the dimension
    // //ALLE-PKS36 for setting the Editable False to Indent Date

    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Purchase Request Header";
    SourceTableView = SORTING("Document Type", "Document No.")
                      WHERE("Document Type" = FILTER(Indent),
                            "Indent Status" = FILTER(Open),
                            "Sub Document Type" = FILTER(<> ' '));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                }
                field("Indent Date"; Rec."Indent Date")
                {
                    Editable = "Indent DateEditable";
                }
                field("Sub Document Type"; Rec."Sub Document Type")
                {
                    Editable = false;
                }
                field(Requirement; Rec.Requirement)
                {
                    Editable = RequirementEditable;
                }
                field("Required By Date"; Rec."Required By Date")
                {
                    Editable = "Required By DateEditable";

                    trigger OnValidate()
                    begin
                        IF Rec."Required By Date" < Rec."Indent Date" THEN
                            ERROR('Required date is not valid...check indent date..');
                    end;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = ShortcutDimension1CodeEditable;

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
                    Editable = false;
                }
                field(Locname; Locname)
                {
                    Editable = false;
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
                field("Indentor Name"; Rec."Indentor Name")
                {
                    Editable = false;
                    Enabled = true;
                }
                field("Indentors Justification"; Rec."Indentors Justification")
                {
                    Editable = IndentorsJustificationEditable;
                    MultiLine = true;
                }
            }
            part("Indent lines"; "Requisition Line")
            {
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No.");
                SubPageView = SORTING("Document Type", "Document No.", "Line No.")
                              ORDER(Ascending);
            }
            group(Approval)
            {
                Caption = 'Approval';
                part(""; "Document No Approval")
                {
                    SubPageLink = "Document Type" = FILTER(Indent),
                                  "Sub Document Type" = FIELD("Sub Document Type"),
                                  Initiator = FIELD(Indentor),
                                  "Document No" = FIELD("Document No.");
                    SubPageView = SORTING("Document Type", "Sub Document Type", "Document No", Initiator, "Key Responsibility Center", "Line No")
                                  ORDER(Ascending)
                                  WHERE("Document No" = FILTER(<> ''));
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    Caption = 'Creation Date &&Time';
                    Editable = false;
                }
                field("Creation Time"; Rec."Creation Time")
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
                field("Approved Time"; Rec."Approved Time")
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



                        Rec.TESTFIELD("Sent for Approval", FALSE);//ALLE-PKS16
                        //JPL START
                        IF Rec.Indentor <> UPPERCASE(USERID) THEN
                            ERROR('Un-Authorized Indentor');
                        //dds-s
                        Rec.TESTFIELD("Shortcut Dimension 1 Code");
                        //TESTFIELD("Shortcut Dimension 2 Code");
                        Rec.TESTFIELD("Indent Date");
                        Rec.TESTFIELD("Required By Date");
                        IF Rec."Sub Document Type" = Rec."Sub Document Type"::" " THEN BEGIN
                            IndLine.RESET;
                            IndLine.SETRANGE("Document Type", Rec."Document Type");
                            IndLine.SETRANGE("Document No.", Rec."Document No.");
                            IF IndLine.FIND('-') THEN BEGIN
                                REPEAT
                                    IF IndLine.Type <> IndLine.Type::"Fixed Asset" THEN BEGIN
                                        IndLine.TESTFIELD("No.");
                                        IndLine.TESTFIELD("Indented Quantity");
                                        //IndLine.TESTFIELD("Direct Unit Cost");
                                    END;
                                    IndLine.TESTFIELD("Shortcut Dimension 1 Code");
                                //IndLine.TESTFIELD("Shortcut Dimension 2 Code");
                                UNTIL IndLine.NEXT = 0;
                            END ELSE
                                ERROR('Cannot send Blank Indent!');
                        END
                        ELSE BEGIN
                            IndLine.RESET;
                            IndLine.SETRANGE("Document Type", Rec."Document Type");
                            IndLine.SETRANGE("Document No.", Rec."Document No.");
                            IF IndLine.FIND('-') THEN
                                REPEAT
                                    IndLine.TESTFIELD("Indented Quantity");
                                UNTIL IndLine.NEXT = 0;
                        END;

                        //dds-e
                        //ALLE-PKS16
                        Accept := CONFIRM(Text007, TRUE, 'Indent', Rec."Document No.");
                        IF NOT Accept THEN EXIT;
                        //ALLE-PKS16
                        IF Rec."Sent for Approval" = FALSE THEN BEGIN
                            Rec.VALIDATE("Sent for Approval", TRUE);
                            Rec."Sent for Approval Date" := TODAY;
                            Rec."Sent for Approval Time" := TIME;
                            Rec.MODIFY;
                            UserTasksNew.AuthorizationPO(UserTasksNew."Transaction Type"::Purchase, UserTasksNew."Document Type"::Indent,
                            Rec."Sub Document Type", Rec."Document No.");
                            CurrPage.UPDATE(TRUE);

                            //ALLE-PKS03
                            IndLine.RESET;
                            IndLine.SETFILTER(IndLine."Document No.", Rec."Document No.");
                            IF IndLine.FIND('-') THEN
                                REPEAT
                                    IndLine.VALIDATE("Sent for Approval", TRUE);
                                    IndLine.MODIFY;
                                UNTIL IndLine.NEXT = 0;
                            //ALLE-PKS03
                        END;
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




                        UserTasksNew.RESET;
                        DocTypeApprovalRec.RESET;
                        DocTypeApprovalRec.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                        DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::Indent);
                        DocTypeApprovalRec.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                        DocTypeApprovalRec.SETRANGE("Document No", Rec."Document No.");
                        DocTypeApprovalRec.SETRANGE(Initiator, Rec.Indentor);
                        DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                        IF DocTypeApprovalRec.FIND('-') THEN BEGIN

                            UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                            "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);

                            UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Purchase);
                            UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::Indent);
                            UserTasksNew.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                            UserTasksNew.SETRANGE("Document No", Rec."Document No.");
                            UserTasksNew.SETRANGE(Initiator, Rec.Indentor);
                            UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                            UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                            UserTasksNew.SETRANGE(Status, UserTasksNew.Status::" ");
                            IF UserTasksNew.FIND('-') THEN
                                UserTasksNew.ApprovePO(UserTasksNew);
                        END;


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
                        Rec.TESTFIELD("Sent for Approval", TRUE);

                        UserTasksNew.RESET;
                        DocTypeApprovalRec.RESET;
                        DocTypeApprovalRec.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                        DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::Indent);
                        DocTypeApprovalRec.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                        DocTypeApprovalRec.SETRANGE("Document No", Rec."Document No.");
                        DocTypeApprovalRec.SETRANGE(Initiator, Rec.Indentor);
                        DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                        IF DocTypeApprovalRec.FIND('-') THEN BEGIN

                            UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                            "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);

                            UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Purchase);
                            UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::Indent);
                            UserTasksNew.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                            UserTasksNew.SETRANGE("Document No", Rec."Document No.");
                            UserTasksNew.SETRANGE(Initiator, Rec.Indentor);
                            UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                            UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                            UserTasksNew.SETRANGE(Status, UserTasksNew.Status::" ");
                            IF UserTasksNew.FIND('-') THEN
                                UserTasksNew.ReturnPO(UserTasksNew);
                        END;


                        //ND
                        MESSAGE('Task Successfully Done for Document No. %1', Rec."Document No.");
                        //ND
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
                }
            }
        }
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action("Change &Item Indent Status")
                {
                    Caption = 'Change &Item Indent Status';
                    Visible = false;

                    trigger OnAction()
                    var
                        Selection: Integer;
                    begin
                        //Alle-AYN-080605>>
                        //SC->>
                        MemberOf.RESET;
                        MemberOf.SETRANGE("User Name", USERID);
                        MemberOf.SETFILTER("Role ID", 'CLOSE-PO');
                        IF NOT MemberOf.FIND('-') THEN
                            ERROR('You don''t have permission to change the status');
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
                        MemberOf.RESET;
                        MemberOf.SETRANGE("User Name", USERID);
                        MemberOf.SETFILTER("Role ID", 'CLOSE-FA');
                        IF NOT MemberOf.FIND('-') THEN
                            ERROR('You don''t have permission to change the status');
                        //SC <<-

                        Rec."Indent Status" := Rec."Indent Status"::Closed;
                        Rec.MODIFY;
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
                        CurrPage."Indent lines".PAGE.ShowItemVendor  //ALLEDK300811
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

        //JPL55 START
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN BEGIN
            IF Rec.Approved = FALSE THEN BEGIN
                IF Rec."Sent for Approval" = FALSE THEN BEGIN
                    IF USERID = Rec.Indentor THEN BEGIN
                        CurrPage.EDITABLE := TRUE;
                        "Indent DateEditable" := TRUE;
                        RequirementEditable := TRUE;
                        "Required By DateEditable" := TRUE;
                        IndentorsJustificationEditable := TRUE;
                        ShortcutDimension1CodeEditable := TRUE;
                    END ELSE
                        CurrPage.EDITABLE := FALSE;
                END
                ELSE BEGIN
                    DocApproval.RESET;
                    DocApproval.SETRANGE("Document Type", DocApproval."Document Type"::Indent);
                    //DocApproval.SETRANGE("Sub Document Type","Sub Document Type");
                    DocApproval.SETFILTER("Document No", '%1', Rec."Document No.");
                    DocApproval.SETRANGE(Initiator, Rec.Indentor);
                    DocApproval.SETRANGE(Status, DocApproval.Status::" ");
                    IF DocApproval.FIND('-') THEN BEGIN
                        IF (DocApproval."Approvar ID" = USERID) OR (DocApproval."Alternate Approvar ID" = USERID) THEN BEGIN
                            //CurrPAGE.EDITABLE:=TRUE
                            "Indent DateEditable" := FALSE;
                            RequirementEditable := FALSE;
                            "Required By DateEditable" := FALSE;
                            IndentorsJustificationEditable := FALSE;
                            ShortcutDimension1CodeEditable := FALSE;
                        END
                        ELSE
                            CurrPage.EDITABLE := FALSE;
                    END
                    ELSE BEGIN
                        CurrPage.EDITABLE := FALSE;
                    END;
                END;
            END
            ELSE
                CurrPage.EDITABLE := FALSE;
        END;
        //JPL55 STOP
        "Indent DateEditable" := FALSE; //ALLE-PKS36
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN BEGIN
            Rec.TESTFIELD(Approved, FALSE);
            Rec.TESTFIELD("Sent for Approval", FALSE);
        END;
    end;

    trigger OnInit()
    begin
        IndentorsJustificationEditable := TRUE;
        "Required By DateEditable" := TRUE;
        RequirementEditable := TRUE;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN
            Rec.TESTFIELD(Approved, FALSE);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN
            Rec.TESTFIELD(Approved, FALSE);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //ALLE-SR-051107 >>
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter();
        //ALLE-SR-051107 <<
    end;

    trigger OnOpenPage()
    begin
        //ALLE-SR-051107 >>
        IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", UserMgt.GetPurchasesFilter());
            Rec.FILTERGROUP(0);
        END;
        //ALLE-SR-051107 <<
        //JPL55 START
        IndHdr := Rec;
        IF Rec.FIND('-') THEN
            REPEAT
                vFlag := FALSE;
                MemberOf.RESET;
                MemberOf.SETRANGE("User Name", USERID);
                MemberOf.SETFILTER("Role ID", 'CLOSE-PO');
                //MemberOf.SETFILTER("Role ID",'SUPERPO');
                IF NOT MemberOf.FIND('-') THEN BEGIN
                    IF USERID = Rec.Indentor THEN
                        vFlag := TRUE;

                    MemberOf.RESET;
                    MemberOf.SETRANGE("User Name", USERID);
                    MemberOf.SETFILTER("Role ID", 'VIEW-INDENT WFLOW');
                    IF MemberOf.FIND('-') THEN
                        vFlag := TRUE;

                    DocApproval.RESET;
                    DocApproval.SETRANGE("Document Type", DocApproval."Document Type"::Indent);
                    //DocApproval.SETRANGE("Sub Document Type","Sub Document Type");
                    DocApproval.SETFILTER("Document No", '%1', Rec."Document No.");
                    DocApproval.SETRANGE(Initiator, Rec.Indentor);
                    //DocApproval.SETRANGE(Status,DocApproval.Status::" ");
                    IF DocApproval.FIND('-') THEN
                        REPEAT
                            IF (DocApproval."Approvar ID" = USERID) OR (DocApproval."Alternate Approvar ID" = USERID) THEN
                                vFlag := TRUE;
                        UNTIL DocApproval.NEXT = 0;
                    Rec.MARK(vFlag);
                END ELSE
                    Rec.MARK(TRUE);
            UNTIL Rec.NEXT = 0;
        Rec.MARKEDONLY(TRUE);



        IF Rec.GET(IndHdr."Document Type", IndHdr."Document No.") THEN;

        //ALLEND 191107
        RecRespCenter.RESET;
        RecRespCenter.SETRANGE(Code, Rec."Responsibility Center");
        IF RecRespCenter.FIND('-') THEN BEGIN
            Respname := RecRespCenter.Name;
            Short1name := RecRespCenter."Region Name";
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
        MemberOf: Record "Access Control";
        DocApproval: Record "Document Type Approval";
        IndDept: Code[20];
        IndLine: Record "Purchase Request Line";
        dimvalue: Record "Dimension Value";
        UserMgt: Codeunit "EPC User Setup Management";
        Short1name: Text[50];
        Respname: Text[50];
        Locname: Text[50];
        RecDimValue: Record "Dimension Value";
        RecLocation: Record Location;
        RecRespCenter: Record "Responsibility Center 1";
        RecUserSetup: Record "User Setup";
        Text007: Label 'Do you want to Send the %1 No.-%2 For Approval';
        Accept: Boolean;
        Enquiry: Page "Enquiry Vendor Lists";
        PRLIne: Record "Purchase Request Line";
        "Indent DateEditable": Boolean;
        RequirementEditable: Boolean;
        "Required By DateEditable": Boolean;
        IndentorsJustificationEditable: Boolean;
        ShortcutDimension1CodeEditable: Boolean;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.UPDATE;
    end;
}

