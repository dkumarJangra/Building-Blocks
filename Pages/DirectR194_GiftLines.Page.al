Page 50512 "194R_Gift Voucher Lines"

{

    Caption = '194R_Gift Voucher Lines';
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
                    // Visible = false;
                }
                field("Description 2"; Rec."Description 2")
                {
                    //Visible = false;
                }
                field("R194_Application No."; Rec."R194_Application No.")
                {
                    Caption = 'New Application No.';

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


                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    Visible = false;
                }
                field("Current Stock"; Rec."Current Stock")
                {
                }
                field("Required Qty"; Rec."Required Qty")
                {
                    Editable = false;
                }
                field(Qty; Rec.Qty)
                {
                    Caption = 'Issue Qty';
                    Editable = false;
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
                field("Applies-to Entry"; Rec."Applies-to Entry")
                {

                }
                field("Gift Control Amount"; Rec."Gift Control Amount")
                {

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

