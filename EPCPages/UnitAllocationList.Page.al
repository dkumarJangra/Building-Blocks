page 97907 "Unit Allocation List"
{
    Caption = 'Unit Allocation List';
    CardPageID = "Unit Allocation";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Confirmed Order";
    SourceTableView = WHERE("Unit Code" = FILTER(''),
                            Status = FILTER(Vacate));
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
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field("Unit Code"; Rec."Unit Code")
                {
                }
                field("Last Unit Vacated By"; Rec."Last Unit Vacated By")
                {
                }
                field("Last Unit Vacate Date_Time"; Rec."Last Unit Vacate Date_Time")
                {
                }
                field("Payment Plan"; Rec."Payment Plan")
                {
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                }
                field("Version No."; Rec."Version No.")
                {
                }
                field("Total Received Amount"; Rec."Total Received Amount")
                {
                }
                field("Saleable Area"; Rec."Saleable Area")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("User Id"; Rec."User Id")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
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

