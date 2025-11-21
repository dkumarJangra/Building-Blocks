page 97744 "JES Line Sub Form"
{
    // ALLERP KRN0003 23-08-2010: Location Code control has been made editable
    //                          : Line No and No field made uneditable and invisible

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
                field("Job Code"; Rec."Job Code")
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
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    Caption = 'Work Order No.';
                    Editable = false;
                }
                field("Purchase Order Line No."; Rec."Purchase Order Line No.")
                {
                    Caption = 'Work Order Line No.';
                    Editable = false;
                }
                field("Weight Qty"; Rec."Weight Qty")
                {
                    Visible = false;
                }
                field("Weight Rate"; Rec."Weight Rate")
                {
                    Visible = false;
                }
                field("Order Qty"; Rec."Order Qty")
                {
                    Caption = 'Pending Order Qty';
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
                }
                field("Rejected Qty"; Rec."Rejected Qty")
                {
                    Editable = false;
                }
                field("Basic Rate"; Rec."Basic Rate")
                {
                    Editable = false;
                }
                field("Basic Amount"; Rec."Basic Amount")
                {
                    Editable = false;
                }
                field("Discount %"; Rec."Discount %")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Discount Amt"; Rec."Discount Amt")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Excise Percent"; Rec."Excise Percent")
                {
                    Editable = false;
                }
                field("Excise Per Unit"; Rec."Excise Per Unit")
                {
                    Editable = false;
                }
                field("Tot Excise Amount"; Rec."Tot Excise Amount")
                {
                    Editable = false;
                }
                field("Sales Tax %"; Rec."Sales Tax %")
                {
                    Editable = false;
                }
                field("Tot Sales Tax Amt"; Rec."Tot Sales Tax Amt")
                {
                    Editable = false;
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
                field("Rejection Note Generated"; Rec."Rejection Note Generated")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Invoiced Qty"; Rec."Invoiced Qty")
                {
                    Editable = false;
                }
                field("Brick Std Cons. Rate"; Rec."Brick Std Cons. Rate")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Cement Std Cons. Rate"; Rec."Cement Std Cons. Rate")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Steel Std Cons. Rate"; Rec."Steel Std Cons. Rate")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Brick Std Cons. Qty"; Rec."Brick Std Cons. Qty")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Cement Std Cons. Qty"; Rec."Cement Std Cons. Qty")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Steel Std Cons. Qty"; Rec."Steel Std Cons. Qty")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Brick Actual Cons. Qty"; Rec."Brick Actual Cons. Qty")
                {
                    Visible = false;
                }
                field("Cement Actual Cons. Qty"; Rec."Cement Actual Cons. Qty")
                {
                    Visible = false;
                }
                field("Steel Actual Cons. Qty"; Rec."Steel Actual Cons. Qty")
                {
                    Visible = false;
                }
                field("Total Brick Std Cons. Qty"; Rec."Total Brick Std Cons. Qty")
                {
                    Visible = false;
                }
                field("Total Cement Std Cons. Qty"; Rec."Total Cement Std Cons. Qty")
                {
                    Visible = false;
                }
                field("Total Steel Std Cons. Qty"; Rec."Total Steel Std Cons. Qty")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Total Brick Actual Cons. Qty"; Rec."Total Brick Actual Cons. Qty")
                {
                    Visible = false;
                }
                field("Total Cement Actual Cons. Qty"; Rec."Total Cement Actual Cons. Qty")
                {
                    Visible = false;
                }
                field("Total Steel Actual Cons. Qty"; Rec."Total Steel Actual Cons. Qty")
                {
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
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

        //JPL55 START
        GRNHdr.GET(Rec."Document Type", Rec."GRN No.");
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN BEGIN
            IF GRNHdr.Approved = FALSE THEN BEGIN
                IF GRNHdr."Sent for Approval" = FALSE THEN BEGIN

                    IF USERID = GRNHdr.Initiator THEN
                        CurrPage.EDITABLE := TRUE
                    ELSE
                        CurrPage.EDITABLE := FALSE;

                END
                ELSE BEGIN
                    DocApproval.RESET;
                    DocApproval.SETRANGE("Document Type", DocApproval."Document Type"::GRN);
                    DocApproval.SETRANGE("Sub Document Type", GRNHdr."Sub Document Type");
                    DocApproval.SETFILTER("Document No", '%1', GRNHdr."GRN No.");
                    DocApproval.SETRANGE(Initiator, GRNHdr.Initiator);
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
            ELSE
                CurrPage.EDITABLE := FALSE;
        END;
        //ALLERP End:

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


    procedure GetPOLines(pGRNHeader: Record "GRN Header")
    begin
        Rec.InsertGRNLines(pGRNHeader);
    end;

    local procedure ReceivedQtyOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;
}

