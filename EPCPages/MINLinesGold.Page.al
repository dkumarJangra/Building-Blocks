page 97957 "MIN Lines-Gold"
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
                        CheckEntry;  //070524
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
                    Editable = false;

                    trigger OnValidate()
                    begin
                        CheckEntry;  //070524 Added new code
                        ApplicationNoOnAfterValidate;
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

                    trigger OnValidate()
                    begin
                        CheckEntry;  //070524 Added new code
                        GatePassHeader.RESET;
                        IF GatePassHeader.GET(Rec."Document Type", Rec."Document No.") THEN BEGIN
                            IF GatePassHeader."Item Type" = GatePassHeader."Item Type"::Gold THEN BEGIN
                                IF Rec."Required Qty" > Rec."Gold Coin Qty" THEN
                                    ERROR('You cant consume Quantity greater than=' + FORMAT(Rec."Gold Coin Qty"));
                            END ELSE BEGIN
                                Rec."Issuing Weight" := Rec.Qty * Rec."Silver / Gold in Grams";
                            END;
                        END;
                    end;
                }
                field(Qty; Rec.Qty)
                {
                    Caption = 'Issued Qty';

                    trigger OnValidate()
                    begin
                        GatePassHeader.RESET;
                        IF GatePassHeader.GET(Rec."Document Type", Rec."Document No.") THEN BEGIN
                            IF GatePassHeader."Item Type" = GatePassHeader."Item Type"::Silver THEN BEGIN
                                Rec."Issuing Weight" := Rec.Qty * Rec."Silver / Gold in Grams";
                            END;
                        END;
                    end;
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
                field("Silver / Gold in Grams"; Rec."Silver / Gold in Grams")
                {
                }
                field("Issuing Weight"; Rec."Issuing Weight")
                {
                    Caption = 'issuing weight (grms)';
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

    local procedure ApplicationNoOnAfterValidate()
    begin
        IF GatePassHeader.GET(Rec."Document Type", Rec."Document No.") THEN
            IF GatePassHeader.Type = GatePassHeader.Type::Regular THEN
                ERROR('Type must be Direct');
    end;

    local procedure BBGOnAfterGetCurrRecord()
    begin
        xRec := Rec;
        Rec.Amount := Rec.Qty * Rec."Unit Cost";
    end;

    local procedure CheckEntry()
    begin
        IF Rec."Item No." <> '' THEN BEGIN
            GatePassHeader.RESET;
            IF GatePassHeader.GET(Rec."Document Type", Rec."Document No.") THEN
                IF GatePassHeader."Item Type" = GatePassHeader."Item Type"::Gold THEN
                    ERROR('You can not change the value');
        END;
    end;
}

