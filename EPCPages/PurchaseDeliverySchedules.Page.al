page 97789 "Purchase Delivery Schedules"
{
    // //ALLETG RIL0011 22-06-2011:

    AutoSplitKey = true;
    Caption = 'Purchase Delivery Schedules';
    DelayedInsert = true;
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
                field("Document Type"; Rec."Document Type")
                {
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    Visible = false;
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
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
                }
                field("Description 3"; Rec."Description 3")
                {
                    Visible = false;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                }
                field("Schedule Quantity"; Rec."Schedule Quantity")
                {
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    Editable = false;
                }
                field("Received Quantity"; Rec."Received Quantity")
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
        EditableFields;  // ALLEPG 250511
    end;

    var
        PurchaseDeliverySchedule: Record "Purch. Delivery Schedule";
        ScheduleQuantity1: Decimal;
        PurchHdr: Record "Purchase Header";


    procedure EditableFields()
    begin
        //ALLETG RIL0011 22-06-2011: START>>
        // ALLEPG 250511 Start
        PurchHdr.RESET;
        IF PurchHdr.GET(Rec."Document Type", Rec."Document No.") THEN BEGIN
            IF (PurchHdr.Approved = TRUE) THEN BEGIN
                IF (PurchHdr.Amended = TRUE) THEN BEGIN
                    IF (PurchHdr."Amendment Approved" = TRUE) THEN
                        CurrPage.EDITABLE(FALSE);
                END ELSE
                    CurrPage.EDITABLE(FALSE);
            END;
        END;
        // ALLEPG 250511 End
        //ALLETG RIL0011 22-06-2011: END<<
    end;
}

