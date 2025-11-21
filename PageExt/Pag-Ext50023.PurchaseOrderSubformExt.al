pageextension 50023 "BBG Purchase Order Subform Ext" extends "Purchase Order Subform"
{
    layout
    {
        // Add changes to page layout here
        modify(Quantity)
        {
            trigger OnBeforeValidate()
            var
                PurchaseHeader: Record "Purchase Header";
            begin
                PurchaseHeader.RESET;
                IF PurchaseHeader.GET(Rec."Document Type", Rec."Document No.") THEN
                    IF PurchaseHeader."Land Document No." <> '' THEN
                        CheckTotalPurchLineQty;  //ALLESSS 19/03/24
            end;
        }
        modify("Description 2")
        {
            Visible = true;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        modify("Line Discount %")
        {
            Visible = true;
        }
        modify("Order Date")
        {
            Visible = true;
        }
        modify("Deferral Code")
        {
            Visible = true;
        }
        modify("Bin Code")
        {
            Visible = false;
        }
        modify(FOC)
        {
            Visible = false;
        }
        modify("TDS Section Code")
        {
            Visible = false;
        }
        modify("Nature of Remittance")
        {
            Visible = false;
        }
        modify("Act Applicable")
        {
            Visible = false;
        }
        modify("GST Jurisdiction Type")
        {
            Visible = false;
        }
        modify("GST Credit")
        {
            Visible = false;
        }
        modify("Item Charge Qty. to Handle")
        {
            Visible = false;
        }
        modify("Promised Receipt Date")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = false;
        }
        modify(ShortcutDimCode3)
        {
            Visible = false;
        }
        modify(ShortcutDimCode4)
        {
            Visible = false;
        }
        modify(ShortcutDimCode5)
        {
            Visible = false;
        }
        modify(ShortcutDimCode6)
        {
            Visible = false;
        }
        modify("Over-Receipt Code")
        {
            Visible = false;
        }
        modify("Over-Receipt Quantity")
        {
            Visible = false;
        }



        moveafter(Description; "Description 2")
        addafter("Description 2")
        {
            field("Description 3"; Rec."Description 3")
            {
                ApplicationArea = All;
            }
            field("Description 4"; Rec."Description 4")
            {
                ApplicationArea = All;
            }
            // field("Job Code"; Rec."Job Code")
            // {
            //     ApplicationArea = All;
            // }
            // field("Duplicate in Depreciation Book"; Rec."Duplicate in Depreciation Book")
            // {
            //     ApplicationArea = All;
            // }
            // field("Depreciation Book Code"; Rec."Depreciation Book Code")
            // {
            //     ApplicationArea = All;
            // }
        }
        moveafter("Description 4"; "Location Code")
        moveafter("Location Code"; Quantity)
        moveafter(Quantity; "Gen. Prod. Posting Group")
        moveafter("Gen. Prod. Posting Group"; "Gen. Bus. Posting Group")
        moveafter("Gen. Bus. Posting Group"; "Reserved Quantity")
        addafter("Reserved Quantity")
        {
            field("Job Code"; Rec."Job Code")
            {
                ApplicationArea = All;
            }
        }
        moveafter("Job Code"; "Unit of Measure Code")
        moveafter("Unit of Measure Code"; "Direct Unit Cost")
        addafter("Direct Unit Cost")
        {
            field("Duplicate in Depreciation Book"; Rec."Duplicate in Depreciation Book")
            {
                ApplicationArea = All;
            }
            field("Depreciation Book Code"; Rec."Depreciation Book Code")
            {
                ApplicationArea = All;
            }
        }
        moveafter("Depreciation Book Code"; "Line Amount")
        moveafter("Line Amount"; "Line Discount %")
        moveafter("Line Discount %"; "Qty. to Receive")
        moveafter("Qty. to Receive"; "Quantity Received")
        moveafter("Quantity Received"; "Qty. to Invoice")
        moveafter("Qty. to Invoice"; "Quantity Invoiced")
        moveafter("Quantity Invoiced"; "Qty. to Assign")
        moveafter("Qty. to Assign"; "Qty. Assigned")
        moveafter("Qty. Assigned"; "Custom Duty Amount")
        moveafter("Custom Duty Amount"; "GST Assessable Value")
        moveafter("GST Assessable Value"; "GST Group Code")
        moveafter("GST Group Code"; "GST Group Type")
        moveafter("GST Group Type"; "HSN/SAC Code")
        moveafter("HSN/SAC Code"; Exempted)
        moveafter(Exempted; "Planned Receipt Date")
        moveafter("Planned Receipt Date"; "Expected Receipt Date")
        moveafter("Expected Receipt Date"; "Order Date")
        moveafter("Order Date"; "Deferral Code")
        addafter("Deferral Code")
        {
            field("Order Address Code"; Rec."Order Address Code")
            {
                ApplicationArea = All;
            }
            field("Buy-From GST Registration No"; Rec."Buy-From GST Registration No")
            {
                ApplicationArea = All;
            }
            field("Bill to-Location(POS)"; Rec."Bill to-Location(POS)")
            {
                ApplicationArea = All;
            }
        }


    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        IndentLine: Record "Purchase Request Line";
        MemberOf: Record "Access Control";
        DimVal: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
        DocSetup: Record "Document Type Setup";
        DocApproval: Record "Document Type Approval";
        DepartmentName: Text[50];
        CostCenterName: Text[50];
        DimValue: Record "Dimension Value";
        GenSetup: Record "General Ledger Setup";
        allowbudget: Boolean;
        PurchHeader: Record "Purchase Header";

    trigger OnOpenPage()
    begin
        GLSetup.GET;
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'DDS-FA-FIXED ASSET');
        IF NOT MemberOf.FIND('-') THEN
            allowbudget := TRUE
        ELSE
            allowbudget := FALSE;
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'SUPER');
        IF MemberOf.FIND('-') THEN
            allowbudget := FALSE;
    end;

    trigger OnAfterGetRecord()
    begin
        //CurrForm.EDITABLE:=TRUE;
        //JPL55 START
        IF PurchHeader.GET(Rec."Document Type", Rec."Document No.") THEN;
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN BEGIN
            IF PurchHeader.Amended = FALSE THEN BEGIN
                IF PurchHeader.Approved = FALSE THEN BEGIN
                    IF PurchHeader."Sent for Approval" = FALSE THEN BEGIN
                        IF (USERID = PurchHeader.Initiator) THEN
                            CurrPage.EDITABLE := TRUE
                        ELSE
                            CurrPage.EDITABLE := FALSE;

                    END
                    ELSE BEGIN
                        DocApproval.RESET;
                        DocApproval.SETRANGE("Document Type", DocApproval."Document Type"::"Purchase Order");
                        DocApproval.SETRANGE("Sub Document Type", PurchHeader."Sub Document Type");
                        DocApproval.SETFILTER("Document No", '%1', PurchHeader."No.");
                        DocApproval.SETRANGE(Initiator, PurchHeader.Initiator);
                        DocApproval.SETRANGE(Status, DocApproval.Status::" ");
                        IF DocApproval.FIND('-') THEN BEGIN
                            IF (DocApproval."Approvar ID" = USERID) OR (DocApproval."Alternate Approvar ID" = USERID) THEN
                                CurrPage.EDITABLE := FALSE //CurrPage.EDITABLE:=TRUE
                            ELSE
                                CurrPage.EDITABLE := FALSE;
                        END
                        ELSE BEGIN
                            CurrPage.EDITABLE := FALSE;
                        END;
                    END;
                END
            END
            ELSE BEGIN
                IF PurchHeader.Amended THEN BEGIN
                    IF PurchHeader."Amendment Approved" = FALSE THEN BEGIN
                        DocApproval.RESET;
                        DocApproval.SETRANGE("Document Type", DocApproval."Document Type"::"Purchase Order Amendment");
                        DocApproval.SETRANGE("Sub Document Type", PurchHeader."Sub Document Type");
                        DocApproval.SETFILTER("Document No", '%1', PurchHeader."No.");
                        DocApproval.SETRANGE(Initiator, PurchHeader."Amendment Initiator");
                        DocApproval.SETRANGE(Status, DocApproval.Status::" ");
                        IF DocApproval.FIND('-') THEN BEGIN
                            IF (DocApproval."Approvar ID" = USERID) OR (DocApproval."Alternate Approvar ID" = USERID)
                               OR (PurchHeader."Amendment Initiator" = USERID) THEN
                                CurrPage.EDITABLE := TRUE
                            ELSE
                                CurrPage.EDITABLE := FALSE;
                        END
                        ELSE BEGIN
                            CurrPage.EDITABLE := FALSE;
                        END;
                    END
                    ELSE
                        CurrPage.EDITABLE := FALSE;
                END;
            END;
        END;

        DepartmentName := '';
        CostCenterName := '';
        GenSetup.GET;
        IF Rec."Shortcut Dimension 1 Code" <> '' THEN BEGIN
            DimValue.GET(GenSetup."Global Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
            CostCenterName := DimValue.Name;
        END;
        IF Rec."Shortcut Dimension 2 Code" <> '' THEN BEGIN
            DimValue.GET(GenSetup."Global Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
            DepartmentName := DimValue.Name;
        END;

        //CurrPage.UPDATECONTROLS; // ALLE MM Code Commented

        //JPL55 STOP
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //GKG
        IF Rec.Type = Rec.Type::"G/L Account" THEN BEGIN
            DimVal.RESET;
            PurchHeader.GET(Rec."Document Type"::Order, Rec."Document No.");
            IF PurchHeader."Buy-from Vendor No." <> '' THEN BEGIN
                DocSetup.GET(DocSetup."Document Type"::"Purchase Order", PurchHeader."Sub Document Type");
                IF DocSetup."Control GL Account" <> '' THEN
                    Rec.VALIDATE("No.", DocSetup."Control GL Account");
                Rec."Shortcut Dimension 1 Code" := PurchHeader."Shortcut Dimension 1 Code";
                Rec."Shortcut Dimension 2 Code" := PurchHeader."Shortcut Dimension 2 Code";
                IF DocSetup."Def. Gen Prod Posting Group" <> '' THEN
                    Rec."Gen. Prod. Posting Group" := DocSetup."Def. Gen Prod Posting Group";
            END;
        END;
        //GKG
    end;

    trigger OnModifyRecord(): Boolean
    begin
        //JPL55
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN BEGIN
            PurchHeader.GET(Rec."Document Type", Rec."Document No.");
            IF PurchHeader.Amended = FALSE THEN BEGIN
                PurchHeader.TESTFIELD(Approved, FALSE);
            END;
            IF PurchHeader.Amended THEN BEGIN
                PurchHeader.TESTFIELD(Approved, TRUE);
                PurchHeader.TESTFIELD("Amendment Approved", FALSE);
            END;
        END;

        CheckIndent;
        //JPL55
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        //JPL55
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN BEGIN
            PurchHeader.GET(Rec."Document Type", Rec."Document No.");
            IF PurchHeader.Amended = FALSE THEN BEGIN
                PurchHeader.TESTFIELD(Approved, FALSE);
            END;
            IF PurchHeader.Amended THEN BEGIN
                PurchHeader.TESTFIELD(Approved, TRUE);
                PurchHeader.TESTFIELD("Amendment Approved", FALSE);
            END;
        END;
        //JPL05
    end;

    PROCEDURE ShowLineComments()
    BEGIN
        Rec.ShowLineComments;
    END;

    PROCEDURE GetIndentLineInfo()
    BEGIN
        //JPL09
        Rec.GetIndentLines;
    END;

    PROCEDURE CheckIndent()
    BEGIN

        //JPL09 START

        IF (Rec."Indent Line No" = 0) AND (Rec."Indent No" = '') THEN
            EXIT;

        IndentLine.RESET;
        IndentLine.SETRANGE("Document Type", IndentLine."Document Type"::Indent);
        IndentLine.SETRANGE("Document No.", Rec."Indent No");
        IndentLine.SETRANGE("Line No.", Rec."Indent Line No");
        IndentLine.SETFILTER(Type, '%1|%2|%3', IndentLine.Type::Item, IndentLine.Type::"G/L Account", IndentLine.Type::"Fixed Asset");
        IndentLine.SETRANGE(Approved, TRUE);
        IF Rec."No." <> '' THEN
            IndentLine.SETRANGE("No.", Rec."No.");
        IndentLine.CALCFIELDS("PO Qty");
        IF IndentLine.FIND('-') THEN BEGIN

            IndentLine.TESTFIELD("No.", Rec."No.");
            IndentLine.CALCFIELDS("PO Qty");
            IF (IndentLine."Line No." = xRec."Indent Line No") AND (IndentLine."Document No." = xRec."Indent No") THEN BEGIN
                IF (IndentLine."Quantity Base" - IndentLine."PO Qty" + xRec."Quantity (Base)" < Rec."Quantity (Base)") THEN
                    ERROR('Original Available Indent Qty is less than PO Line Base Qty');
            END
            ELSE BEGIN
                IF (IndentLine."Quantity Base" - IndentLine."PO Qty" < Rec."Quantity (Base)") THEN
                    ERROR('Available Indent Qty is less than PO Line Base Qty');
            END;

        END;
        //JPL09 STOP
    END;

    PROCEDURE ShowSubOrderDetailsForm()
    VAR
        PurchaseLine: Record "Purchase Line";
        SubOrderDetails: Page "Order Subcon. Details Delivery";// 16324;
    BEGIN
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", Rec."Document Type"::Order);
        PurchaseLine.SETRANGE("Document No.", Rec."Document No.");
        PurchaseLine.SETRANGE("No.", Rec."No.");
        PurchaseLine.SETRANGE("Line No.", Rec."Line No.");
        SubOrderDetails.SETTABLEVIEW(PurchaseLine);
        SubOrderDetails.RUNMODAL;
    END;

    PROCEDURE ShowDeliveryScheduleLines();
    BEGIN
        //ALLETG RIL0011 22-06-2011
        Rec.ShowDeliveryScheduleLines;
    END;

    LOCAL PROCEDURE CheckTotalPurchLineQty();
    VAR
        TotalPurchLineQty: Decimal;
        QuantityExceedsErr: Label 'Quantity %1 exceeds than Quantity For PO %2.';
    BEGIN
        //ALLESSS 19/03/24---BEGIN
        CLEAR(TotalPurchLineQty);
        PurchHeader.GET(Rec."Document Type", Rec."Document No.");
        TotalPurchaseLine.RESET;
        TotalPurchaseLine.SETRANGE("Document Type", Rec."Document Type");
        TotalPurchaseLine.SETRANGE("Document No.", Rec."Document No.");
        TotalPurchaseLine.SETRANGE(Type, Rec.Type);
        IF TotalPurchaseLine.FINDSET THEN BEGIN
            TotalPurchaseLine.CALCSUMS(Quantity);
            TotalPurchLineQty := TotalPurchaseLine.Quantity;
        END;
        IF (TotalPurchLineQty + Rec.Quantity) > PurchHeader."Quantity for PO" THEN
            ERROR(QuantityExceedsErr, (TotalPurchLineQty + Rec.Quantity), PurchHeader."Quantity for PO");
        //ALLESSS 19/03/24---END
    END;

}