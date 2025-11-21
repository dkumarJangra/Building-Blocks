page 97746 "Inward Gate Pass Lines"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Gate Pass Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Outward Gatepass Entry No"; Rec."Outward Gatepass Entry No")
                {

                    trigger OnValidate()
                    begin
                        OutwardGatepassEntryNoOnAfterV;
                    end;
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("Description 2"; Rec."Description 2")
                {
                    Visible = true;
                }
                field("Description 3"; Rec."Description 3")
                {
                }
                field("Description 4"; Rec."Description 4")
                {
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                }
                field(Qty; Rec.Qty)
                {
                    Caption = 'Quantity';

                    trigger OnValidate()
                    begin
                        Rec.VALIDATE("Outward Gatepass Entry No");
                    end;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Visible = true;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Visible = true;
                }
                field("Cost Centre Name"; Rec."Cost Centre Name")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        GatePassHeader.RESET;
        GatePassHeader.SETRANGE("Document No.", Rec."Document No.");
        IF GatePassHeader.FIND('-') THEN BEGIN
            Rec."Shortcut Dimension 1 Code" := GatePassHeader."Shortcut Dimension 1 Code";
            Rec."Shortcut Dimension 2 Code" := GatePassHeader."Shortcut Dimension 2 Code";
            Rec."Cost Centre Name" := GatePassHeader."Cost Centre Name";
            Rec."Purchase Order No." := GatePassHeader."Purchase Order No.";
            Rec."Gen. Bus. Posting Group" := GatePassHeader."Gen. Business Posting Group";
            Rec."Location Code" := GatePassHeader."Location Code";
        END;
    end;

    var
        GatePassHeader: Record "Gate Pass Header";

    local procedure OutwardGatepassEntryNoOnAfterV()
    begin
        CurrPage.SAVERECORD;
    end;
}

