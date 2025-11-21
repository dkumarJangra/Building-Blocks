page 97832 "Posted JES"
{
    // //AlleDK 140308 New Report adding for JES

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
                field("GRN No."; Rec."GRN No.")
                {
                    Caption = 'JES No.';
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Sub Document Type"; Rec."Sub Document Type")
                {
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    Caption = 'Work Order No.';

                    trigger OnValidate()
                    begin
                        PurchaseOrderNoOnAfterValidate;
                    end;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Posted GRN No."; Rec."Posted GRN No.")
                {
                    Caption = 'Posted JES No.';
                }
                field("Vendor name"; Rec."Vendor name")
                {
                    Editable = false;
                }
                field(Remarks; Rec.Remarks)
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field("Sent for Approval"; Rec."Sent for Approval")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(Approved; Rec.Approved)
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Total GRN Value"; Rec."Total GRN Value")
                {
                    Caption = 'Total JES Value';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
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
                field(Initiator; Rec.Initiator)
                {
                    Editable = false;
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
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&JES")
            {
                Caption = '&JES';
                action("JES List")
                {
                    Caption = 'JES List';
                    RunObject = Page "GRN List";
                    ShortCutKey = 'Shift+Ctrl+L';
                }
            }
        }
        area(processing)
        {
            action("&Print JES")
            {
                Caption = '&Print JES';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    GRNHdr.RESET;
                    GRNHdr.SETRANGE(GRNHdr."GRN No.", Rec."GRN No.");
                    //GRNHdr.SETRANGE(GRNHdr."Posting Date","Posting Date");
                    IF GRNHdr.FIND('-') THEN
                        REPORT.RUN(97816, TRUE, FALSE, GRNHdr); //AlleDK 140308
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

    local procedure PurchaseOrderNoOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;
}

