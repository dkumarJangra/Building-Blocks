page 50267 "Customer Appl. calim details"
{
    PageType = List;
    SourceTable = "Customer Appl. Claim Details";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Creaation Time"; Rec."Creaation Time")
                {
                }
                field("Application No."; Rec."Application No.")
                {
                }
                field("Member Code"; Rec."Member Code")
                {
                }
                field("Member Name"; Rec."Member Name")
                {
                }
                field("Plot Code"; Rec."Plot Code")
                {
                }
                field("Project Code"; Rec."Project Code")
                {
                }
                field("PAN Number"; Rec."PAN Number")
                {
                }
                field("Booking Date"; Rec."Booking Date")
                {
                }
                field("Father Name"; Rec."Father Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

