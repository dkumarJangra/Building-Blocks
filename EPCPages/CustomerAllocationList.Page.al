page 97906 "Customer Allocation List"
{
    Caption = 'Order List';
    CardPageID = "Unit Vacate /Member Allocation";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Confirmed Order";
    SourceTableView = WHERE("Unit Code" = FILTER(<> ''));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Application No."; Rec."Application No.")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Unit Code"; Rec."Unit Code")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                }
                field("Total Received Amount"; Rec."Total Received Amount")
                {
                }
                field("Saleable Area"; Rec."Saleable Area")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("User Id"; Rec."User Id")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Unit")
            {
                Caption = '&Unit';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Confirmed Order";
                    RunPageLink = "No." = FIELD("No.");
                    RunPageView = SORTING("No.");
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
    }

    var
        GetDescription: Codeunit GetDescription;
}

