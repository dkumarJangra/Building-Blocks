page 97736 "GRN Line Sub Form"
{
    // ALLERP KRN0003 23-08-2010: Location Code control has been made editable
    // //ALLETG RIL0011 22-06-2011: Code Added
    // ALLEPG RAHEE1.00 240212 : Created functions for tracking line.

    AutoSplitKey = true;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "GRN Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("Description 2"; Rec."Description 2")
                {
                    Editable = true;
                    Visible = true;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Description 3"; Rec."Description 3")
                {
                    Editable = true;
                    Visible = true;
                }
                field("Description 4"; Rec."Description 4")
                {
                    Editable = true;
                    Visible = true;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = true;
                }
                field("Tolerance Percentage"; Rec."Tolerance Percentage")
                {
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    Caption = 'PO No.';
                    Editable = false;
                }
                field("Purchase Order Line No."; Rec."Purchase Order Line No.")
                {
                    Caption = 'PO Line No.';
                    Editable = false;
                }
                field("Order Qty"; Rec."Order Qty")
                {
                    Caption = 'Pending Order Qty';
                    Editable = false;
                }
                field("Challan Qty"; Rec."Challan Qty")
                {
                }
                field("Received Qty"; Rec."Received Qty")
                {

                    trigger OnValidate()
                    begin
                        ReceivedQtyOnAfterValidate;
                    end;
                }
                field("Accepted Qty"; Rec."Accepted Qty")
                {
                    Visible = true;
                }
                field("Excess Qty"; Rec."Excess Qty")
                {
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    Editable = false;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    Editable = false;
                }
                field("Accepted Quantity Base"; Rec."Accepted Quantity Base")
                {
                    Editable = false;
                }
                field("Rejected Quantity Base"; Rec."Rejected Quantity Base")
                {
                    Editable = false;
                }
                field("Reason for Rejection"; Rec."Reason for Rejection")
                {
                }
                field("Rejection Note Generated"; Rec."Rejection Note Generated")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Invoiced Qty"; Rec."Invoiced Qty")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Item &Tracking Lines")
            {
                Caption = 'Item &Tracking Lines';
                Image = ItemTrackingLines;
                ShortCutKey = 'Shift+Ctrl+I';

                trigger OnAction()
                begin
                    //This functionality was copied from page #97735. Unsupported part was commented. Please check it.
                    /*CurrPage.GRNSubForm.PAGE.*/
                    _BBGOpenItemTrackingLines(TRUE);  // RAHEE1.00 240212

                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        GRNHdr.GET(Rec."Document Type", Rec."GRN No.");
        Vendor.GET(GRNHdr."Vendor No.");
        IF Vendor."BBG BHEL" THEN BEGIN
            IF GRNHdr."Sent to Payment Tracking" THEN
                CurrPage.EDITABLE := FALSE
            ELSE
                CurrPage.EDITABLE := TRUE;
        END
        ELSE
            CurrPage.EDITABLE := TRUE;

        /*
        IF GRNHdr.Approved THEN
          CurrPAGE.EDITABLE:=FALSE
        ELSE
          CurrPAGE.EDITABLE:=TRUE;
        */
        /*
        
        //JPL55 START
        GRNHdr.GET("Document Type","GRN No.");
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name",USERID);
        MemberOf.SETFILTER("Role ID",'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN BEGIN
            IF GRNHdr.Approved=FALSE THEN BEGIN
              IF GRNHdr."Sent for Approval"=FALSE THEN BEGIN
        
                IF USERID=GRNHdr.Initiator THEN
                  CurrPage.EDITABLE:=TRUE
                ELSE
                  CurrPage.EDITABLE:=FALSE;
        
              END
              ELSE BEGIN
                DocApproval.RESET;
                DocApproval.SETRANGE("Document Type",DocApproval."Document Type"::GRN);
                DocApproval.SETRANGE("Sub Document Type",GRNHdr."Sub Document Type");
                DocApproval.SETFILTER("Document No",'%1',GRNHdr."GRN No.");
                DocApproval.SETRANGE(Initiator,GRNHdr.Initiator);
                DocApproval.SETRANGE(Status,DocApproval.Status::" ");
                IF DocApproval.FIND('-') THEN BEGIN
                  IF (DocApproval."Approvar ID"=USERID) OR (DocApproval."Alternate Approvar ID"=USERID) THEN
                    CurrPage.EDITABLE:=TRUE
                  ELSE
                    CurrPage.EDITABLE:=FALSE;
        
                END
                ELSE BEGIN
                  CurrPage.EDITABLE:=FALSE;
                END;
        
              END;
        
            END
            ELSE
              CurrPage.EDITABLE:=FALSE;
        END;
        */

    end;

    trigger OnDeleteRecord(): Boolean
    begin
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN
            Rec.TESTFIELD(Approved, FALSE);
        GRNHdr.GET(Rec."Document Type", Rec."GRN No.");
        GRNHdr.TESTFIELD("Sent to Payment Tracking", FALSE);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN
            Rec.TESTFIELD(Approved, FALSE);
    end;

    trigger OnOpenPage()
    begin
        IF CurrPage.LOOKUPMODE THEN
            CurrPage.EDITABLE := FALSE;
    end;

    var
        GRNHdr: Record "GRN Header";
        Vendor: Record Vendor;
        MemberOf: Record "Access Control";
        DocApproval: Record "Document Type Approval";
        GrnLineRec: Record "GRN Line";


    procedure GetPOLines(pGRNHeader: Record "GRN Header")
    begin
        Rec.InsertGRNLines(pGRNHeader);
    end;


    procedure BBGShowDimensions()
    begin
        Rec.ShowDimensions1;
    end;


    procedure GetScheduleLines(pGRNHeader: Record "GRN Header")
    begin
        //ALLETG RIL0011 22-06-2011:
        Rec.InsertGRNLinesfromSchedule(pGRNHeader);
    end;


    procedure _BBGOpenItemTrackingLines(Update: Boolean)
    begin
        Rec.OpenItemTrackingLines(Update);   // RAHEE1.00 240212
    end;


    procedure BBGOpenItemTrackingLines(Update: Boolean)
    begin
        Rec.OpenItemTrackingLines(Update);   // RAHEE1.00 240212
    end;

    local procedure ReceivedQtyOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;
}

