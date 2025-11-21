Page 50239 "Gold_Silver Voucher Lines"
{

    Caption = 'Gold/Silver Voucher Lines';
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Gate Pass Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
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
                    Visible = false;
                }
                field("Application No."; Rec."Application No.")
                {
                    Caption = 'Application No.';
                    Editable = true;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD("Item No.");
                    end;
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("PO Line No."; Rec."PO Line No.")
                {
                    Visible = false;
                }
                field("Description 2"; Rec."Description 2")
                {
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
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = true;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = true;
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
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    Visible = false;
                }
                field("Job No."; Rec."Job No.")
                {
                    Visible = false;
                }
                field("Fixed Asset No"; Rec."Fixed Asset No")
                {
                    Visible = false;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    Visible = false;
                }
                field("Current Stock"; Rec."Current Stock")
                {
                }
                field("Required Qty"; Rec."Required Qty")
                {
                    Editable = true;
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
                field("Journal Line Created"; Rec."Journal Line Created")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Debit Note Created"; Rec."Debit Note Created")
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
        "Confirmed Order": Record "Confirmed Order";
        ApplicationNo: Code[20];


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

