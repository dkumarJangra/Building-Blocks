page 50121 "Unit Vacate /MemberChange List"
{
    CardPageID = "Unit Vacate /Member Allocation";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Confirmed Order";
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTableView = WHERE(Status = FILTER(Open));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
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
                field("Unit Code"; Rec."Unit Code")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Last Unit Vacated By"; Rec."Last Unit Vacated By")
                {
                }
                field("Last Unit Vacate Date_Time"; Rec."Last Unit Vacate Date_Time")
                {
                }
            }
        }
    }

    actions
    {
    }
}

