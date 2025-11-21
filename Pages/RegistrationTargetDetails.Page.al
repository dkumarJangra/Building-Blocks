page 50299 "Registration Target Details"
{
    DelayedInsert = true;
    DeleteAllowed = true;
    Editable = true;
    PageType = List;
    SourceTable = "Registered Target Details";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Month; Rec.Month)
                {
                }
                field(Year; Rec.Year)
                {
                }
                field("Region Code"; Rec."Region Code")
                {
                }
                field("No. of Plot Target"; Rec."No. of Plot Target")
                {
                }
                field("Achived Plots"; Rec."Achived Plots")
                {
                }
                field("Previouse Month Bal. Target"; Rec."Previouse Month Bal. Target")
                {
                }
                field("Balance Target"; Rec."Balance Target")
                {
                }
                field(Received; Rec.Received)
                {
                }
                field("Actual Target"; Rec."Actual Target")
                {
                }
                field("Created By"; Rec."Created By")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Creation Time"; Rec."Creation Time")
                {
                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                }
                field("Last Modified Time"; Rec."Last Modified Time")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Update Data")
            {
                Image = process;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Codeunit "Registration Target / Achive";
            }
        }
    }
}

