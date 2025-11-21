page 97796 "Requisition Line"
{
    // //ALLE-PKS03 for Setting form to noneditable if Approved
    // ALLERP KRN0003 23-08-2010: Location Code control has been made editable

    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Purchase Request Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Send for Enquiry"; Rec."Send for Enquiry")
                {
                }
                field(Type; Rec.Type)
                {
                    Editable = TypeEditable;
                    Visible = false;
                }
                field("No."; Rec."No.")
                {
                    Editable = "No.Editable";
                    Visible = false;
                }
                field("FA SubGroup"; Rec."FA SubGroup")
                {
                }
                field("Job No."; Rec."Job No.")
                {
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                }
                field(Designation; Rec.Designation)
                {
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
                field("Physical Stock"; Rec."Physical Stock")
                {
                    Visible = false;
                }
                field("Location code"; Rec."Location code")
                {
                    Editable = true;
                    Visible = false;
                }
                field("Indent UOM"; Rec."Indent UOM")
                {
                    Editable = "Indent UOMEditable";
                }
                field("Indented Quantity"; Rec."Indented Quantity")
                {
                    Caption = 'Indented Qty';
                    Editable = "Indented QuantityEditable";
                }
                field("Approved Qty"; Rec."Approved Qty")
                {
                    Caption = 'Approved Qty';
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    Editable = "Direct Unit CostEditable";
                }
                field(Amount; Rec.Amount)
                {
                    Editable = AmountEditable;
                }
                field("Required By Date"; Rec."Required By Date")
                {
                    Visible = false;
                }
                field("Purchase UOM"; Rec."Purchase UOM")
                {
                    Visible = false;
                }
                field("Quantity Base"; Rec."Quantity Base")
                {
                }
                field("Base UOM"; Rec."Base UOM")
                {
                }
                field("Qty Per Unit Of Measure"; Rec."Qty Per Unit Of Measure")
                {
                }
                field("Purch Qty Per Unit Of Measure"; Rec."Purch Qty Per Unit Of Measure")
                {
                    Visible = false;
                }
                field("Quantity (Purchase UOM)"; Rec."Quantity (Purchase UOM)")
                {
                    Visible = false;
                }
                field("TO Qty"; Rec."TO Qty")
                {
                    Visible = false;
                }
                field("Outstanding TO Qty"; Rec."Outstanding TO Qty")
                {
                    Visible = false;
                }
                field("PO Qty"; Rec."PO Qty")
                {
                    Visible = false;
                }
                field("Quantity Received T.O"; Rec."Quantity Received T.O")
                {
                    Visible = false;
                }
                field("Quantity Shipped T.O"; Rec."Quantity Shipped T.O")
                {
                    Visible = false;
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    Visible = false;
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                }
                field("Outstanding PO Qty"; Rec."Outstanding PO Qty")
                {
                    Visible = false;
                }
                field("Outstanding PO Amount"; Rec."Outstanding PO Amount")
                {
                    Visible = false;
                }
                field("Base Qty on Indent Line"; Rec."Base Qty on Indent Line")
                {
                    Visible = false;
                }
                field("Base PO Qty on PO Line"; Rec."Base PO Qty on PO Line")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = ShortcutDimension1CodeEditable;
                    Visible = true;

                    trigger OnValidate()
                    begin
                        IF Rec."Shortcut Dimension 1 Code" = 'DUMMY' THEN
                            ERROR('You can not select DUMMY cost center..');

                        dimvalue.RESET;
                        dimvalue.SETRANGE(dimvalue."Dimension Code", 'COST CENTER');
                        dimvalue.SETRANGE(dimvalue.Code, Rec."Shortcut Dimension 1 Code");
                        IF dimvalue.FIND('-') THEN
                            IF dimvalue.Blocked = TRUE THEN
                                ERROR('This cost center is blocked....');
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        DocApproval: Record "Document Type Approval";
    begin
        //ALLE-PKS03
        IF Rec.Approved THEN
            CurrPage.EDITABLE := FALSE
        ELSE
            CurrPage.EDITABLE := TRUE;
        //ALLE-PKS03
        //JPL55 START
        //CurrPAGE.EDITABLE:=TRUE;
        IF IndHdr.GET(Rec."Document Type", Rec."Document No.") THEN;
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN BEGIN
            IF IndHdr.Approved = FALSE THEN BEGIN
                IF IndHdr."Sent for Approval" = FALSE THEN BEGIN
                    IF USERID = IndHdr.Indentor THEN BEGIN
                        CurrPage.EDITABLE := TRUE;
                        TypeEditable := TRUE;
                        "No.Editable" := TRUE;
                        "Indent UOMEditable" := TRUE;
                        "Indented QuantityEditable" := TRUE;
                        "Direct Unit CostEditable" := TRUE;
                        AmountEditable := TRUE;
                        ShortcutDimension1CodeEditable := TRUE;
                    END
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
                        IF (DocApproval."Approvar ID" = USERID) OR (DocApproval."Alternate Approvar ID" = USERID) THEN BEGIN
                            //CurrPAGE.EDITABLE:=TRUE
                            TypeEditable := FALSE;
                            "No.Editable" := FALSE;
                            "Indent UOMEditable" := FALSE;
                            "Indented QuantityEditable" := FALSE;
                            "Direct Unit CostEditable" := FALSE;
                            AmountEditable := FALSE;
                            ShortcutDimension1CodeEditable := FALSE;
                        END ELSE
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

    trigger OnDeleteRecord(): Boolean
    begin
        IndHdr.GET(Rec."Document Type", Rec."Document No.");
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN BEGIN
            IndHdr.TESTFIELD("Sent for Approval", FALSE);
            IndHdr.TESTFIELD(Approved, FALSE);
        END;
    end;

    trigger OnInit()
    begin
        ShortcutDimension1CodeEditable := TRUE;
        "Direct Unit CostEditable" := TRUE;
        "Indented QuantityEditable" := TRUE;
        "Indent UOMEditable" := TRUE;
        "No.Editable" := TRUE;
        TypeEditable := TRUE;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        IndHdr.GET(Rec."Document Type", Rec."Document No.");
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN BEGIN
            IndHdr.TESTFIELD(Approved, FALSE);
            IndHdr.TESTFIELD("Sent for Approval", FALSE);
        END;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        IndHdr.GET(Rec."Document Type", Rec."Document No.");
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN
            IndHdr.TESTFIELD(Approved, FALSE);
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
        dimvalue: Record "Dimension Value";
        MemberOf: Record "Access Control";

        TypeEditable: Boolean;

        "No.Editable": Boolean;

        "Indent UOMEditable": Boolean;

        "Indented QuantityEditable": Boolean;

        "Direct Unit CostEditable": Boolean;

        AmountEditable: Boolean;

        ShortcutDimension1CodeEditable: Boolean;


    procedure ShowItemVendor()
    var
        ItemVendor: Record "Product Vendor";
        ItemVendorFrm: Page "Product Vendors";
    begin
        //ALLEDK300811
        ItemVendor.RESET;
        IF Rec."Job Master Code" = '' THEN BEGIN
            ItemVendor.SETRANGE(Type, Rec.Type);
            ItemVendor.SETRANGE("No.", Rec."No.");
        END ELSE BEGIN
            ItemVendor.SETRANGE(Type, Rec.Type::"Job Master");
            ItemVendor.SETRANGE("No.", Rec."Job Master Code");
        END;
        ItemVendor.SETFILTER("Expiry Date", '>=%1|%2', TODAY, 0D);
        ItemVendorFrm.SETTABLEVIEW(ItemVendor);
        ItemVendorFrm.CallFromMaster;
        ItemVendorFrm.SetPrHeader(Rec."Document Type", Rec."Document No.", Rec."Line No.");
        ItemVendorFrm.RUNMODAL;
        //ALLEDK300811
    end;
}

