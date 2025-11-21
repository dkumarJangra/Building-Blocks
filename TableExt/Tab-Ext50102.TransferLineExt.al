tableextension 50102 "BBG Transfer Line Ext" extends "Transfer Line"
{
    fields
    {
        // Add changes to table fields here
        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                RecItem2: Record Item;
                AvailInventory2: Decimal;
                RecTransOrder2: Record "Transfer Header";
                Text50001: Label 'Quantity must be less than or equal to Available Quantity of Item %1 for Location %2 ';
                TransHeader: Record "Transfer Header";
            begin
                //NDALLE 280508
                IF NOT TransHeader."Transfer FG" THEN BEGIN  //RAHEE1.00
                    RecTransOrder2.RESET;
                    RecTransOrder2.SETRANGE(RecTransOrder2."No.", "Document No.");
                    IF RecTransOrder2.FINDFIRST THEN BEGIN
                        RecItem2.RESET;
                        RecItem2.SETRANGE(RecItem2."No.", "Item No.");
                        RecItem2.SETFILTER(RecItem2."Location Filter", RecTransOrder2."Transfer-from Code");
                        IF RecItem2.FINDFIRST THEN BEGIN
                            RecItem2.CALCFIELDS(Inventory);
                            AvailInventory2 := RecItem2.Inventory;
                            IF Quantity > AvailInventory2 THEN
                                ERROR(Text50001, "Item No.", RecTransOrder2."Transfer-from Code");
                        END;
                    END;
                END;  //RAHEE1.00
                      //NDALLE 280508
            end;
        }
        field(50001; "Check FA Item"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'added by ashish for checking FA Item';
        }


        field(50004; "Available Quantity"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                  "Location Code" = FIELD("Transfer-from Code")));
            Description = 'NDALLE 280508';
            Editable = false;
            FieldClass = FlowField;
        }

    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
        LocationRec: Record Location;
        LocationRec1: Record Location;
        PLine: Record "Purchase Line";
        TRHeader: Record "Transfer Header";
        GLSETUP: Record "General Ledger Setup";
        THeader: Record "Transfer Header";
        purchheader: Record "Purchase Header";
        focitemlist: Record "FOC/PO TABLE";
        COUNTX: Integer;
        COUNTY: Integer;
        TransLine: Record "Transfer Line";
        cHK: Record "FOC/PO TABLE";
        IndentLine: Record "Purchase Request Line";
        ToLineRec: Record "Transfer Line";
        DefDimRec: Record "Default Dimension";
        DefDimRec2: Record "Default Dimension";
        IndentLineForm: Page "Purchase Request Lines List";
        TransHeader: Record "Transfer Header";


    PROCEDURE FillFOCLIne();
    BEGIN
    END;


    PROCEDURE GetIndentLines();
    BEGIN
        //ALLE_PKS
        //JPL09 START
        TransHeader.GET("Document No.");
        IndentLine.RESET;
        IndentLine.FILTERGROUP := 2;
        IndentLine.SETRANGE("Document Type", IndentLine."Document Type"::Indent);
        IndentLine.SETRANGE(Approved, TRUE);
        IndentLine.SETRANGE("Indent Status", IndentLine."Indent Status"::Open);
        IndentLine.SETRANGE(IndentLine."Location code", TransHeader."Transfer-to Code");
        IndentLine.FILTERGROUP := 0;
        IndentLine.CALCFIELDS("TO Qty");
        IF IndentLine.FIND('-') THEN
            REPEAT
                IndentLine.CALCFIELDS("TO Qty");
                IndentLine.CALCFIELDS("PO Qty");

                IF (IndentLine."TO Qty" + IndentLine."PO Qty" < IndentLine."Quantity Base") THEN
                    IndentLine.MARK(TRUE);
            UNTIL IndentLine.NEXT = 0;
        IndentLine.MARKEDONLY(TRUE);
        IF IndentLine.FIND('-') THEN BEGIN
            CLEAR(IndentLineForm);
            IndentLineForm.SETTABLEVIEW(IndentLine);
            IndentLineForm.LOOKUPMODE := TRUE;
            IndentLineForm.SetTransHeader(TransHeader);
            IndentLineForm.SetTOMode(TRUE);
            IndentLineForm.RUNMODAL;
        END;
        //JPL09 STOP
        //ALLE_PKS
    END;

}