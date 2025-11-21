page 97730 "Purchase Request Lines List"
{
    // //RAHEE1.00 180412 Added New Function for Get Indent lines on MIN

    Editable = false;
    PageType = List;
    SourceTable = "Purchase Request Line";
    UsageCategory = Lists;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("Indent Date"; Rec."Indent Date")
                {
                }
                field(Approved; Rec.Approved)
                {
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                    Visible = false;
                }
                field("Indent UOM"; Rec."Indent UOM")
                {
                }
                field("Indented Quantity"; Rec."Indented Quantity")
                {
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    Visible = false;
                }
                field("Quantity Base"; Rec."Quantity Base")
                {
                }
                field("Quantity (Purchase UOM)"; Rec."Quantity (Purchase UOM)")
                {
                }
                field("Purchase UOM"; Rec."Purchase UOM")
                {
                }
                field("PO Qty"; Rec."PO Qty")
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
                }
                field("Outstanding PO Amount"; Rec."Outstanding PO Amount")
                {
                }
                field(Indentor; Rec.Indentor)
                {
                    Visible = false;
                }
                field("Current Stock"; Rec."Current Stock")
                {
                    Visible = false;
                }
                field("Required By Date"; Rec."Required By Date")
                {
                    Visible = false;
                }
                field("Indent Status"; Rec."Indent Status")
                {
                }
                field("Location code"; Rec."Location code")
                {
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF CloseAction = ACTION::LookupOK THEN
            LookupOKOnPush;
    end;

    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        POMode: Boolean;
        TransHeader: Record "Transfer Header";
        TransLine: Record "Transfer Line";
        TOMode: Boolean;
        GatepassHeader: Record "Gate Pass Header";
        TOMINMode: Boolean;
        GatePassLine: Record "Gate Pass Line";


    procedure SetPurchHeader(vPurchHeader: Record "Purchase Header")
    begin
        PurchHeader := vPurchHeader;
    end;


    procedure SetPOMode(vPOMode: Boolean)
    begin
        POMode := vPOMode;
    end;


    procedure SetTransHeader(vTransheader: Record "Transfer Header")
    begin
        TransHeader := vTransheader;
    end;


    procedure SetTOMode(vTOMode: Boolean)
    begin
        TOMode := vTOMode;
    end;


    procedure SetGatePassHeader(vGatepassHeader: Record "Gate Pass Header")
    begin
        GatepassHeader := vGatepassHeader;  //RAHEE1.00 180412
    end;


    procedure SetMINMode(vMINMode: Boolean)
    begin
        TOMINMode := vMINMode;  //RAHEE1.00 180412
    end;

    local procedure LookupOKOnPush()
    begin
        IF POMode THEN BEGIN
            CurrPage.SETSELECTIONFILTER(Rec);
            PurchLine.FillIndentLines(Rec, PurchHeader);
        END

        ELSE
            IF TOMode THEN BEGIN
                CurrPage.SETSELECTIONFILTER(Rec);
                TransLine.FillIndentLines(Rec, TransHeader);
            END;
    end;
}

