page 97870 "GRN Lines"
{
    AutoSplitKey = true;
    Editable = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "GRN Line";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                }
                field("GRN No."; Rec."GRN No.")
                {
                }
                field(Type; Rec.Type)
                {
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field("Job Code"; Rec."Job Code")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("Description 2"; Rec."Description 2")
                {
                    Visible = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                }
                field("Weight Qty"; Rec."Weight Qty")
                {
                    Visible = false;
                }
                field("Weight Rate"; Rec."Weight Rate")
                {
                    Visible = false;
                }
                field("Purchase Order Line No."; Rec."Purchase Order Line No.")
                {
                    Editable = false;
                }
                field("Order Qty"; Rec."Order Qty")
                {
                }
                field("Challan Qty"; Rec."Challan Qty")
                {
                }
                field("Received Qty"; Rec."Received Qty")
                {

                    trigger OnValidate()
                    begin
                        ReceivedQtyOnAfterValidate;
                    end;
                }
                field("Accepted Qty"; Rec."Accepted Qty")
                {
                }
                field("Rejected Qty"; Rec."Rejected Qty")
                {
                    Editable = false;
                }
                field("Basic Rate"; Rec."Basic Rate")
                {
                    Editable = false;
                }
                field("Basic Amount"; Rec."Basic Amount")
                {
                    Editable = false;
                }
                field("Excise Percent"; Rec."Excise Percent")
                {
                    Editable = false;
                }
                field("Excise Per Unit"; Rec."Excise Per Unit")
                {
                    Editable = false;
                }
                field("Tot Excise Amount"; Rec."Tot Excise Amount")
                {
                    Editable = false;
                }
                field("Sales Tax %"; Rec."Sales Tax %")
                {
                    Editable = false;
                }
                field("Tot Sales Tax Amt"; Rec."Tot Sales Tax Amt")
                {
                    Editable = false;
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    Editable = false;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    Editable = false;
                }
                field("Accepted Quantity Base"; Rec."Accepted Quantity Base")
                {
                    Editable = false;
                }
                field("Rejected Quantity Base"; Rec."Rejected Quantity Base")
                {
                    Editable = false;
                }
                field("Rejection Note Generated"; Rec."Rejection Note Generated")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Reason for Rejection"; Rec."Reason for Rejection")
                {
                }
                field("Brick Std Cons. Rate"; Rec."Brick Std Cons. Rate")
                {
                    Editable = false;
                }
                field("Cement Std Cons. Rate"; Rec."Cement Std Cons. Rate")
                {
                    Editable = false;
                }
                field("Brick Std Cons. Qty"; Rec."Brick Std Cons. Qty")
                {
                    Editable = false;
                }
                field("Cement Std Cons. Qty"; Rec."Cement Std Cons. Qty")
                {
                    Editable = false;
                }
                field("Brick Actual Cons. Qty"; Rec."Brick Actual Cons. Qty")
                {
                }
                field("Cement Actual Cons. Qty"; Rec."Cement Actual Cons. Qty")
                {
                }
                field("Total Brick Std Cons. Qty"; Rec."Total Brick Std Cons. Qty")
                {
                }
                field("Total Cement Std Cons. Qty"; Rec."Total Cement Std Cons. Qty")
                {
                }
                field("Total Brick Actual Cons. Qty"; Rec."Total Brick Actual Cons. Qty")
                {
                }
                field("Total Cement Actual Cons. Qty"; Rec."Total Cement Actual Cons. Qty")
                {
                }
            }
        }
    }

    actions
    {
    }

    local procedure ReceivedQtyOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;
}

