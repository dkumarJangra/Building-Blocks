page 97748 "Material Return Lines"
{
    // ALLERP KRN0003 23-08-2010: Location Code control has been made editable

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
                field("Bin Code"; Rec."Bin Code")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    Editable = false;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Cost Centre Name"; Rec."Cost Centre Name")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = true;
                }
                field("Current Stock"; Rec."Current Stock")
                {
                }
                field(Qty; Rec.Qty)
                {
                    Caption = 'Return Qty';
                }
                field("Job No."; Rec."Job No.")
                {
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                }
                field("Fixed Asset No"; Rec."Fixed Asset No")
                {
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Applies-from Entry"; Rec."Applies-from Entry")
                {
                }
                field(Chargeable; Rec.Chargeable)
                {
                    Editable = false;
                }
                field("Min No."; Rec."Min No.")
                {
                    Editable = false;
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
}

