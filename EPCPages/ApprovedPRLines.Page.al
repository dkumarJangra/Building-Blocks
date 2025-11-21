page 97851 "Approved PR Lines"
{
    // ALLERP KRN0003 23-08-2010: Location Code control has been made editable

    AutoSplitKey = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Purchase Request Line";
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
                    Editable = false;
                    Visible = false;
                }
                field("Description 3"; Rec."Description 3")
                {
                    Visible = false;
                }
                field("Description 4"; Rec."Description 4")
                {
                    Visible = false;
                }
                field("Current Stock"; Rec."Current Stock")
                {
                    Editable = false;
                }
                field("Physical Stock"; Rec."Physical Stock")
                {
                    Editable = false;
                }
                field("Location code"; Rec."Location code")
                {
                    Editable = true;
                    Visible = false;
                }
                field("Indent UOM"; Rec."Indent UOM")
                {
                    Editable = false;
                }
                field("Indented Quantity"; Rec."Indented Quantity")
                {
                    Caption = 'Indented Qty';
                    Editable = false;
                }
                field("Approved Qty"; Rec."Approved Qty")
                {
                    Caption = 'Approved Qty';
                    Editable = false;
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                }
                field("Required By Date"; Rec."Required By Date")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Quantity Base"; Rec."Quantity Base")
                {
                    Editable = false;
                }
                field("Qty Per Unit Of Measure"; Rec."Qty Per Unit Of Measure")
                {
                    Editable = false;
                }
                field("Purchase UOM"; Rec."Purchase UOM")
                {
                    Visible = false;
                }
                field("Purch Qty Per Unit Of Measure"; Rec."Purch Qty Per Unit Of Measure")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Quantity (Purchase UOM)"; Rec."Quantity (Purchase UOM)")
                {
                    Editable = false;
                    Visible = false;
                }
                field("PO Qty"; Rec."PO Qty")
                {
                    Editable = false;
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    Editable = false;
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                    Editable = false;
                }
                field("Outstanding PO Qty"; Rec."Outstanding PO Qty")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Outstanding PO Amount"; Rec."Outstanding PO Amount")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Base Qty on Indent Line"; Rec."Base Qty on Indent Line")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Base PO Qty on PO Line"; Rec."Base PO Qty on PO Line")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Cost Centre Name"; Rec."Cost Centre Name")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
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
    var
        MemberOf: Record "Access Control";
        DocApproval: Record "Document Type Approval";
    begin
        //JPL55 START
        IndHdr.GET(Rec."Document Type", Rec."Document No.");
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN BEGIN
            IF IndHdr.Approved = FALSE THEN BEGIN
                IF IndHdr."Sent for Approval" = FALSE THEN BEGIN
                    IF USERID = IndHdr.Indentor THEN
                        CurrPage.EDITABLE := TRUE
                    ELSE
                        CurrPage.EDITABLE := FALSE;

                END
                ELSE BEGIN
                    DocApproval.RESET;
                    DocApproval.SETRANGE("Document Type", DocApproval."Document Type"::Indent);
                    //DocApproval.SETRANGE("Sub Document Type",PurchHeader."Sub Document Type");
                    DocApproval.SETFILTER("Document No", '%1', IndHdr."Document No.");
                    DocApproval.SETRANGE(Initiator, IndHdr.Indentor);
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
        //JPL55 STOP
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        TempIndentLine := xRec;
        Rec.INIT;
        Rec.Type := xRec.Type;
    end;

    var
        TempIndentLine: Record "Purchase Request Line";
        IndHdr: Record "Purchase Request Header";
}

