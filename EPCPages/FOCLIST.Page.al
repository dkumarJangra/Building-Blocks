page 97810 "FOC LIST"
{
    // //RAHEE1.00  180412 Added New function for Get FOC Lines.

    Editable = false;
    PageType = Card;
    SourceTable = "FOC/PO TABLE";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("Job Code"; Rec."Job Code")
                {
                }
                field("Item Code"; Rec."Item Code")
                {
                }
                field("Vendor Code"; Rec."Vendor Code")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("Issue From Date"; Rec."Issue From Date")
                {
                }
                field("Issue To Date"; Rec."Issue To Date")
                {
                }
                field("Quantity Issued"; Rec."Quantity Issued")
                {
                }
                field("Quantity Returned"; Rec."Quantity Returned")
                {
                }
                field("Quantity Consumed"; Rec."Quantity Consumed")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Rate (%)"; Rec."Rate (%)")
                {
                }
                field(Amount; Rec.Amount)
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
        GatepassHeader: Record "Gate Pass Header";
        TOMINMode: Boolean;
        GatePassLine: Record "Gate Pass Line";


    procedure getLineNo(LineNo: Integer) "Line No": Integer
    begin
        LineNo := Rec."Line No.";
    end;


    procedure SetGatePassHeader(vGatepassHeader: Record "Gate Pass Header")
    begin
        GatepassHeader := vGatepassHeader;  //RAHEE1.00  180412
    end;


    procedure SetMINMode(vMINMode: Boolean)
    begin
        TOMINMode := vMINMode;            //RAHEE1.00  180412
    end;

    local procedure LookupOKOnPush()
    begin
        //RAHEE1.00 180412
        IF TOMINMode THEN BEGIN
            CurrPage.SETSELECTIONFILTER(Rec);
            GatePassLine.FillFOCLines(Rec, GatepassHeader);
        END;
        //RAHEE1.00 180412
    end;
}

