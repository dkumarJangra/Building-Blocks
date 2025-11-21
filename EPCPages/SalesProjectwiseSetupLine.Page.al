page 50057 "Sales Project wise Setup Line"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = "Sales Project Wise Setup Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Project Code"; Rec."Project Code")
                {
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                }
                field("Effective From Date"; Rec."Effective From Date")
                {
                }
                field("Effective To Date"; Rec."Effective To Date")
                {
                }
                field("Sales %"; Rec."Sales %")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Creation Time"; Rec."Creation Time")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    actions
    {
    }
}

