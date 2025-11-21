page 97850 "Approved PR Header"
{
    Caption = 'Indent Header';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Purchase Request Header";
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

                    trigger OnAssistEdit()
                    begin

                        PurAndPay.GET;
                        PurAndPay.TESTFIELD("Indent Nos");
                        IF NoSeriesMgt.SelectSeries(PurAndPay."Indent Nos", Rec."Indent No. Series", Rec."Indent No. Series") THEN BEGIN
                            PurAndPay.GET;
                            PurAndPay.TESTFIELD("Indent Nos");
                            NoSeriesMgt.SetSeries(Rec."Document No.");
                            CurrPage.UPDATE;
                        END;
                    end;
                }
                field("Indent Date"; Rec."Indent Date")
                {
                    Editable = "Indent DateEditable";
                }
                field(Requirement; Rec.Requirement)
                {
                    Editable = RequirementEditable;
                }
                field("Required By Date"; Rec."Required By Date")
                {
                    Editable = "Required By DateEditable";
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
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    Editable = "Purchaser CodeEditable";
                    Visible = false;
                }
                field("Purchaser Name"; Rec."Purchaser Name")
                {
                    Editable = false;
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
            part("1"; "Approved PR Lines")
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
                                  "Sub Document Type" = FILTER(' '),
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
            group("&Indent")
            {
                Caption = '&Indent';
                separator("--")
                {
                    Caption = '--';
                }
                action("Purchase Line")
                {
                    Caption = 'Purchase Line';
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
            group("&Functions")
            {
                Caption = '&Functions';
                action("&Change Indent Status")
                {
                    Caption = '&Change Indent Status';

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
                    IF USERID = Rec.Indentor THEN
                        CurrPage.EDITABLE := TRUE
                    ELSE
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
                        IF (DocApproval."Approvar ID" = USERID) OR (DocApproval."Alternate Approvar ID" = USERID) THEN
                            CurrPage.EDITABLE := TRUE
                        ELSE
                            CurrPage.EDITABLE := FALSE;

                    END
                    ELSE BEGIN
                        CurrPage.EDITABLE := FALSE;
                    END;

                END;

            END
            ELSE BEGIN
                MemberOf.RESET;
                MemberOf.SETRANGE("User Name", USERID);
                MemberOf.SETFILTER("Role ID", 'CLOSE-PO');
                IF NOT MemberOf.FIND('-') THEN
                    CurrPage.EDITABLE := FALSE
                ELSE BEGIN
                    CurrPage.EDITABLE := TRUE;
                    "Indent DateEditable" := FALSE;
                    RequirementEditable := FALSE;
                    "Required By DateEditable" := FALSE;
                    IndentorsJustificationEditable := FALSE;
                    ShortcutDimension1CodeEditable := FALSE;
                    "Purchaser CodeEditable" := TRUE;
                END;
            END;
        END;
        //JPL55 STOP

        //ALLEND 191107
        RecRespCenter.RESET;
        RecRespCenter.SETRANGE(Code, Rec."Responsibility Center");
        IF RecRespCenter.FIND('-') THEN BEGIN
            Respname := RecRespCenter.Name;
            Short1name := RecRespCenter."Region Name";
            Locname := RecRespCenter."Location Name";
        END;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Rec.TESTFIELD(Approved, FALSE);
    end;

    trigger OnInit()
    begin
        "Purchaser CodeEditable" := TRUE;
        IndentorsJustificationEditable := TRUE;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", '%1|%2', 'CLOSE-PO', 'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN
            Rec.TESTFIELD(Approved, FALSE);
    end;

    trigger OnOpenPage()
    begin
        IndHdr := Rec;
        //JPL55 START
        IF Rec.FIND('-') THEN
            REPEAT
                vFlag := FALSE;
                MemberOf.RESET;
                MemberOf.SETRANGE("User Name", USERID);
                MemberOf.SETFILTER("Role ID", 'SUPERPO');
                IF NOT MemberOf.FIND('-') THEN BEGIN
                    IF USERID = Rec.Indentor THEN
                        vFlag := TRUE;

                    //SC 10/02/06->>
                    IndEmp.RESET;
                    UsrEmp.RESET;
                    IF IndEmp.GET(Rec.Indentor) THEN BEGIN
                        IF UsrEmp.GET(USERID) THEN BEGIN
                            IF (IndEmp."Global Dimension 2 Code" = UsrEmp."Global Dimension 2 Code") THEN
                                vFlag := TRUE;
                        END;
                    END;
                    //For Purchaser code
                    UsrEmp.RESET;
                    IF UsrEmp.GET(USERID) THEN BEGIN
                        IF UsrEmp."No." = Rec."Purchaser Code" THEN
                            vFlag := TRUE;
                    END;
                    //SC <<-
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
                END
                ELSE
                    Rec.MARK(TRUE);

            UNTIL Rec.NEXT = 0;
        Rec.MARKEDONLY(TRUE);

        //ALLEND 191107
        RecRespCenter.RESET;
        RecRespCenter.SETRANGE(Code, Rec."Responsibility Center");
        IF RecRespCenter.FIND('-') THEN BEGIN
            Respname := RecRespCenter.Name;
            Short1name := RecRespCenter."Region Name";
            Locname := RecRespCenter."Location Name";
        END;


        IF Rec.GET(IndHdr."Document Type", IndHdr."Document No.") THEN;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PurAndPay: Record "Purchases & Payables Setup";
        UserTasksNew: Record "User Tasks New";
        DocTypeApprovalRec: Record "Document Type Approval";
        IndentHdr: Record "Purchase Request Header";
        IndHdr: Record "Purchase Request Header";
        vFlag: Boolean;
        DocApproval: Record "Document Type Approval";
        IndEmp: Record Employee;
        UsrEmp: Record Employee;
        IndDept: Code[20];
        Text002: Label '&Cancel, &Short Closure';
        Short1name: Text[50];
        Respname: Text[50];
        Locname: Text[50];
        RecDimValue: Record "Dimension Value";
        RecLocation: Record Location;
        RecRespCenter: Record "Responsibility Center 1";
        RecUserSetup: Record "User Setup";
        dimvalue: Record "Dimension Value";

        "Indent DateEditable": Boolean;

        RequirementEditable: Boolean;

        "Required By DateEditable": Boolean;

        IndentorsJustificationEditable: Boolean;

        ShortcutDimension1CodeEditable: Boolean;

        "Purchaser CodeEditable": Boolean;
        MemberOf: Record "Access Control";

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.UPDATE;
    end;
}

