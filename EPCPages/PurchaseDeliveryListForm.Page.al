page 97790 "Purchase Delivery List Form"
{
    // ALLETG RIL0011 23-06-2011: New list form created

    PageType = Card;
    SourceTable = "Purch. Delivery Schedule";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("No."; Rec."No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                }
                field("Schedule Quantity"; Rec."Schedule Quantity")
                {
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                }
                field("Received Quantity"; Rec."Received Quantity")
                {
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                }
                field("Description 3"; Rec."Description 3")
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
        GRNHeader: Record "GRN Header";
        GRNMode: Boolean;
        GRNLine: Record "GRN Line";
        PurchaseDeliverySchedule: Record "Purch. Delivery Schedule";


    procedure SetGRNHeader(vGRNHeader: Record "GRN Header")
    begin
        GRNHeader := vGRNHeader;
    end;


    procedure SetGRNMode(vGRNMode: Boolean)
    begin
        GRNMode := vGRNMode;
    end;

    local procedure LookupOKOnPush()
    begin
        IF GRNMode THEN BEGIN
            CurrPage.SETSELECTIONFILTER(Rec);
            /*
            PurchaseDeliverySchedule := Rec;
            IF Rec.FINDSET THEN BEGIN
              REPEAT
                MESSAGE('%1  %2',Rec."Document Line No.",Rec."Line No.");
              UNTIL Rec.NEXT = 0;
            END;
            */
            GRNLine.FillGRNLinesFromSchedule(Rec, GRNHeader);
        END;

    end;
}

