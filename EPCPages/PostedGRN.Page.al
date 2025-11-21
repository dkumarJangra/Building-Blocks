page 97847 "Posted GRN"
{
    Editable = false;
    PageType = Card;
    SourceTable = "GRN Header";
    SourceTableView = SORTING("Document Type", "GRN No.")
                      ORDER(Ascending)
                      WHERE("Document Type" = FILTER(GRN),
                            Status = FILTER(Close));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Sub Document Type"; Rec."Sub Document Type")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("GRN No."; Rec."GRN No.")
                {
                    Caption = 'GRN No.';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Gate Entry No."; Rec."Gate Entry No.")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Gate Entry Date"; Rec."Gate Entry Date")
                {
                    Editable = false;
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    Caption = 'PO Number';
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        PurchaseOrderNoOnAfterValidate;
                    end;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Vendor name"; Rec."Vendor name")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field("Document Date"; Rec."Document Date")
                {
                    Caption = 'Document Rec Date';
                }
                field("Challan No"; Rec."Challan No")
                {
                    Caption = 'Challan No && Date';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Challan Date"; Rec."Challan Date")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Mode of Transport"; Rec."Mode of Transport")
                {
                }
                field("Vehicle No."; Rec."Vehicle No.")
                {
                }
                field("Transporter Name"; Rec."Transporter Name")
                {
                }
                field("Total GRN Value"; Rec."Total GRN Value")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field(Remarks; Rec.Remarks)
                {
                    MultiLine = true;
                }
            }
            part(""; "GRN Line Sub Form")
            {
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "GRN No." = FIELD("GRN No.");
                SubPageView = SORTING("Document Type", "GRN No.", "Line No.")
                              ORDER(Ascending);
            }
            group(Approval)
            {
                Caption = 'Approval';
                field("Creation Date"; Rec."Creation Date")
                {
                    Caption = 'Creation Date &&Time';
                    Editable = false;
                }
                field("Sent for Approval Date"; Rec."Sent for Approval Date")
                {
                    Editable = false;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    Caption = 'Approved Date &&Time';
                    Editable = false;
                }
                part("1"; "Document No Approval")
                {
                    SubPageLink = "Document Type" = FILTER(GRN),
                                  "Sub Document Type" = FIELD("Sub Document Type"),
                                  Initiator = FIELD(Initiator),
                                  "Document No" = FIELD("GRN No.");
                    SubPageView = SORTING("Document Type", "Sub Document Type", "Document No", Initiator, "Key Responsibility Center", "Line No")
                                  ORDER(Ascending)
                                  WHERE("Document No" = FILTER(<> ''));
                }
                field("Creation Time"; Rec."Creation Time")
                {
                    Editable = false;
                }
                field("Sent for Approval Time"; Rec."Sent for Approval Time")
                {
                    Editable = false;
                }
                field("Approved Time"; Rec."Approved Time")
                {
                    Editable = false;
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
        }
    }

    actions
    {
        area(navigation)
        {
            group("&GRN")
            {
                Caption = '&GRN';
                action("GRN Details")
                {
                    Caption = 'GRN Details';

                    trigger OnAction()
                    begin
                        GRNLINE_1.RESET;
                        IF GRNLINE_1.FINDSET THEN
                            PAGE.RUNMODAL(Page::"GRN Line  List", GRNLINE_1);
                    end;
                }
            }
        }
        area(processing)
        {
            action("&Print GRN")
            {
                Caption = '&Print GRN';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    GRNHdr.RESET;
                    GRNHdr.SETRANGE(GRNHdr."GRN No.", Rec."GRN No.");
                    //GRNHdr.SETRANGE(GRNHdr."Posting Date","Posting Date");
                    IF GRNHdr.FIND('-') THEN
                        REPORT.RUN(97887, TRUE, FALSE, GRNHdr);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", UserMgt.GetPurchasesFilter());
            Rec.FILTERGROUP(0);
        END;


        IF Rec.Approved = TRUE THEN
            CurrPage.EDITABLE(FALSE);
    end;

    var
        GateEntry: Record "Gate Entry Header";// 16552;
        UserTasksNew: Record "User Tasks New";
        DocTypeApprovalRec: Record "Document Type Approval";
        GRNLines: Record "GRN Line";
        tt: Code[20];
        PurchLine: Record "Purchase Line";
        GRNLine: Record "GRN Line";
        PurchHdr: Record "Purchase Header";
        PucrhPost: Codeunit "Purch.-Post";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PurAndPay: Record "Purchases & Payables Setup";
        GRNHdr: Record "GRN Header";
        GRNHdr2: Record "GRN Header";
        UserMgt: Codeunit "EPC User Setup Management";
        GRNLINE_1: Record "GRN Line";

    local procedure PurchaseOrderNoOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;
}

