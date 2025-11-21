page 50413 "R194Gift Lines"
{
    // ALLEPG RAHEE1.00 240212 : Created functions for tracking line.

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

                    trigger OnValidate()
                    begin

                        ItemNoOnAfterValidate;
                    end;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("Description 2"; Rec."Description 2")
                {
                    Visible = true;
                }

                field("R194_Application No."; Rec."R194_Application No.")
                {

                }
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    Editable = false;
                }
                field("Current Stock"; Rec."Current Stock")
                {
                }
                field("Required Qty"; Rec."Required Qty")
                {
                }
                field(Qty; Rec.Qty)
                {
                    Caption = 'Issued Qty';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    Editable = true;
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = false;
                }
                field("Cost Centre Name"; Rec."Cost Centre Name")
                {
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                }
                field(Extent; Rec.Extent)
                {
                    Editable = False;
                }

            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        BBGOnAfterGetCurrRecord;
    end;

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
        BBGOnAfterGetCurrRecord;
    end;

    var
        GatePassHeader: Record "Gate Pass Header";
        MemberOf: Record "Access Control";


    procedure OpenFreeTrackingLines()
    begin
        //TESTFIELD("Journal Line Created");
        Rec.OpenFreeSampleTrackingLines; // BIOMAB1.0
    end;


    procedure GetIndentLineInfo()
    begin
        Rec.GetIndentLines;  //RAHEE1.00 180412
    end;


    procedure GetFOCLineInfo()
    begin
        Rec.GetFOCLines;    //RAHEE1.00 180412
    end;

    local procedure ItemNoOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        CurrPage.UPDATE(FALSE);
    end;

    local procedure BBGOnAfterGetCurrRecord()
    begin
        xRec := Rec;
        Rec.Amount := Rec.Qty * Rec."Unit Cost";
    end;
}

