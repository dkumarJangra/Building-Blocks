page 97728 "Purchase Request Lines"
{
    // //ALLE-PKS03 for Setting PAGE to noneditable if Approved
    // ALLERP KRN0014 18-08-2010: function ShowItemVendor has been added
    //                          : Property of Send for Enquiry field set No
    // ALLERP KRN0003 23-08-2010: Location Code control has been made editable
    // ALLERP BugFix  24-11-2010: control of Indented quantity has been added

    AutoSplitKey = true;
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
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    Editable = TypeEditable;
                }
                field("No."; Rec."No.")
                {
                    Editable = "No.Editable";
                }
                field("Variant Code"; Rec."Variant Code")
                {
                }
                field("WO / PO Code"; Rec."WO / PO Code")
                {
                    Visible = false;
                }
                field("Required By Date"; Rec."Required By Date")
                {
                }
                field("PO Line No."; Rec."PO Line No.")
                {
                    Visible = false;
                }
                field("FA SubGroup"; Rec."FA SubGroup")
                {
                }
                field("Job Master Code"; Rec."Job Master Code")
                {
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = ShortcutDimension1CodeEditable;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Job No."; Rec."Job No.")
                {
                }
                field("Job Task No."; Rec."Job Task No.")
                {
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
                field("Last PO Reference No."; Rec."Last PO Reference No.")
                {
                }
                field("Last PO Vendor"; Rec."Last PO Vendor")
                {
                }
                field("Last PO Price"; Rec."Last PO Price")
                {
                }
                field("Delivery Date"; Rec."Delivery Date")
                {
                }
                field("Inspection by"; Rec."Inspection by")
                {
                    Visible = false;
                }
                field(Source; Rec.Source)
                {
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
                    Editable = "Indented QuantityEditable";
                }
                field("Qty. at Indent Creation"; Rec."Qty. at Indent Creation")
                {
                }
                field("Qty. at Indent Approval"; Rec."Qty. at Indent Approval")
                {
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
                field("Purchase UOM"; Rec."Purchase UOM")
                {
                    Visible = false;
                }
                field("Quantity Base"; Rec."Quantity Base")
                {
                    Visible = false;
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
                }
                field("Outstanding TO Qty"; Rec."Outstanding TO Qty")
                {
                }
                field("PO Qty"; Rec."PO Qty")
                {
                }
                field("Job Planning Line No."; Rec."Job Planning Line No.")
                {
                }
                field("Quantity Received T.O"; Rec."Quantity Received T.O")
                {
                }
                field("Quantity Shipped T.O"; Rec."Quantity Shipped T.O")
                {
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
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
        /*IF Approved THEN
        CurrPAGE.EDITABLE:=FALSE
        ELSE
        CurrPAGE.EDITABLE:=TRUE;
        */
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
        PRHeader: Record "Purchase Request Header";
        TotalJobQty: Decimal;
        RecJobPlanningLine: Record "Job Planning Line";
        PurchaseReqLine: Record "Purchase Request Line";
        TotalIndQty: Decimal;

        TypeEditable: Boolean;

        "No.Editable": Boolean;

        "Indent UOMEditable": Boolean;

        "Indented QuantityEditable": Boolean;

        "Direct Unit CostEditable": Boolean;

        AmountEditable: Boolean;

        ShortcutDimension1CodeEditable: Boolean;
        MemberOf: Record "Access Control";


    procedure ShowItemVendor()
    var
        ItemVendor: Record "Product Vendor";
        ItemVendorFrm: Page "Product Vendors";
    begin
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
    end;
}

