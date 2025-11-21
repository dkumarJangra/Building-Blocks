page 97776 "Project Price Group Details"
{
    PageType = Card;
    SourceTable = "Project Price Group Details";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Project Code"; Rec."Project Code")
                {
                    Visible = true;
                }
                field("Project Price Group"; Rec."Project Price Group")
                {
                    Visible = true;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Ending Date"; Rec."Ending Date")
                {
                }
                field("Sales Rate (per sq ft)"; Rec."Sales Rate (per sq ft)")
                {
                }
                field("Lease Rate (per sq ft)"; Rec."Lease Rate (per sq ft)")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        IF CurrPage.LOOKUPMODE THEN
            CurrPage.EDITABLE := FALSE;
    end;
}

