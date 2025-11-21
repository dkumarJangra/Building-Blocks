page 60780 "Unit Master log Entries"
{
    PageType = List;
    SourceTable = "Unit Master Log";
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Version"; Rec."Version")
                {
                }
                field(Status; Rec.Status)
                {

                }
                field("Web Portal Status"; Rec."Web Portal Status")
                {

                }
                field("User ID"; Rec."User ID")
                {

                }
                field("Creation Date"; Rec."Creation Date")
                {

                }
                field("Creation Time"; Rec."Creation Time")
                {

                }
                field("Saleable Area"; Rec."Saleable Area")
                {

                }
                field("Project Code"; Rec."Project Code")
                {

                }

                field("Sell to Customer No."; Rec."Sell to Customer No.")
                {

                }
                field("Payment Plan"; Rec."Payment Plan")
                {

                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {

                }
                field(Freeze; Rec.Freeze)
                {

                }
                field("Customer Code"; Rec."Customer Code")
                {

                }

            }
        }
    }

    actions
    {
    }
}

