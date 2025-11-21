pageextension 50024 "BBG Purch. Invoice Subform Ext" extends "Purch. Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        modify("Deferral Code")
        {
            Visible = true;
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
        moveafter("No."; "Gen. Prod. Posting Group")
        moveafter("Gen. Prod. Posting Group"; "Gen. Bus. Posting Group")
        moveafter("Gen. Bus. Posting Group"; Description)
        moveafter(Description; "Location Code")
        moveafter("Location Code"; Quantity)
        moveafter(Quantity; "Unit of Measure Code")
        moveafter("Unit of Measure Code"; "Direct Unit Cost")
        moveafter("Direct Unit Cost"; "Line Amount")
        addafter("Line Amount")
        {
            field("Qty. to Invoice"; Rec."Qty. to Invoice")
            {
                ApplicationArea = All;
            }
            field("Ref. Gift Item No."; Rec."Ref. Gift Item No.")
            {
                ApplicationArea = All;
            }
        }

        moveafter("Qty. to Invoice"; "Line Discount %")
        moveafter("Line Discount %"; "Qty. to Assign")
        moveafter("Qty. to Assign"; "Qty. Assigned")
        moveafter("Qty. Assigned"; "Custom Duty Amount")
        moveafter("Custom Duty Amount"; "GST Assessable Value")
        moveafter("GST Assessable Value"; "GST Group Code")
        moveafter("GST Group Code"; "GST Group Type")
        moveafter("GST Group Type"; "HSN/SAC Code")
        moveafter("HSN/SAC Code"; Exempted)
        addafter(Exempted)
        {
            field("Job Code"; Rec."Job Code")
            {
                ApplicationArea = All;
            }
            field("GRN No."; Rec."GRN No.")
            {
                ApplicationArea = All;
            }
            field("GRN Line No."; Rec."GRN Line No.")
            {
                ApplicationArea = All;
            }
            field("PO No."; Rec."PO No.")
            {
                ApplicationArea = All;
            }
            field("PO Line No."; Rec."PO Line No.")
            {
                ApplicationArea = All;
            }
            field("BOQ Code"; Rec."BOQ Code")
            {
                ApplicationArea = All;
            }
        }
        moveafter("BOQ Code"; "Deferral Code")
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
        MemberOf: Record "Access Control";
        DocApproval: Record "Document Type Approval";
        DocInitiator: Record "Document Type Initiator";
        TempSalesTaxAmt: Decimal;
        TempExAmt: Decimal;
        PurchHeader: Record "Purchase Header";
        DocSetup: Record "Document Type Setup";


    trigger OnAfterGetRecord()
    begin
        //JPL55 START
        CurrPage.EDITABLE := FALSE;
        IF PurchHeader.GET(Rec."Document Type", Rec."Document No.") THEN;
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN BEGIN
            IF PurchHeader.Approved = FALSE THEN BEGIN
                IF PurchHeader."Sent for Approval" = FALSE THEN BEGIN
                    IF (USERID = PurchHeader.Initiator) THEN
                        CurrPage.EDITABLE := TRUE
                    ELSE
                        CurrPage.EDITABLE := FALSE;

                END
                ELSE BEGIN
                    DocApproval.RESET;
                    DocApproval.SETRANGE("Document Type", DocApproval."Document Type"::Invoice);
                    DocApproval.SETRANGE("Sub Document Type", PurchHeader."Sub Document Type");
                    DocApproval.SETFILTER("Document No", '%1', PurchHeader."No.");
                    DocApproval.SETRANGE(Initiator, PurchHeader.Initiator);
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
                DocInitiator.RESET;
                DocInitiator.SETRANGE("Document Type", DocInitiator."Document Type"::Invoice);
                DocInitiator.SETRANGE("Sub Document Type", PurchHeader."Sub Document Type");
                DocInitiator.SETRANGE("User Code", PurchHeader.Initiator);
                IF NOT DocInitiator.FIND('-') THEN
                    CurrPage.EDITABLE := FALSE
                ELSE BEGIN
                    IF (DocInitiator."Posting User Code" = UPPERCASE(USERID)) THEN
                        CurrPage.EDITABLE := TRUE
                    ELSE
                        CurrPage.EDITABLE := FALSE;
                END;
            END;
        END ELSE
            //JPL55 STOP
            CurrPage.EDITABLE := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //GKG - for GenDef Prod Posting Grp
        IF Rec.Type = Rec.Type::"Fixed Asset" THEN BEGIN
            PurchHeader.GET(Rec."Document Type"::Invoice, Rec."Document No.");
            IF PurchHeader."Buy-from Vendor No." <> '' THEN BEGIN
                DocSetup.GET(DocSetup."Document Type"::Invoice, PurchHeader."Sub Document Type");
                IF DocSetup."Def. Gen Prod Posting Group" <> '' THEN
                    Rec."Gen. Prod. Posting Group" := DocSetup."Def. Gen Prod Posting Group";
            END;
        END;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        //JPL55 START
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN BEGIN
            PurchHeader.GET(Rec."Document Type", Rec."Document No.");
            PurchHeader.TESTFIELD(Approved, FALSE);
        END;
        //JPL55 STOP
    end;

    trigger OnDeleteRecord(): Boolean
    begin

        //JPL55 START
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETFILTER("Role ID", 'SUPERPO');
        IF NOT MemberOf.FIND('-') THEN BEGIN
            PurchHeader.GET(Rec."Document Type", Rec."Document No.");
            PurchHeader.TESTFIELD(Approved, FALSE);
        END;
        //JPL55 STOP
    end;

    PROCEDURE ShowJobAllocationForm()
    VAR
        JobAllocation: Record "Job Allocation";
        JobAllocationFrm: Page "Job Allocation";
    BEGIN
        //JPL42 START
        JobAllocation.RESET;
        JobAllocation.SETRANGE("Document Type", Rec."Document Type");
        JobAllocation.SETRANGE("Document No.", Rec."Document No.");
        JobAllocation.SETRANGE("Line No.", Rec."Line No.");
        JobAllocationFrm.SETTABLEVIEW(JobAllocation);
        JobAllocationFrm.RUNMODAL;
        //JPL42 STOP
    END;

}