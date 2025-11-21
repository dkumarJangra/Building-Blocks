page 97992 "Travel Setup Line"
{
    AutoSplitKey = false;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Travel Setup Line New";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Effective Date"; Rec."Effective Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field("Project Code"; Rec."Project Code")
                {
                }
                field(Rate; Rec.Rate)
                {
                }
                field("Branch Code"; Rec."Branch Code")
                {
                }
                field("TA Code"; Rec."TA Code")
                {
                }
                field("New Region / Rank Code"; Rec."New Region / Rank Code")
                {

                }

                field("User ID"; Rec."User ID")
                {
                }
                field("Branch Name"; Rec."Branch Name")
                {
                }
                field("Project Name"; Rec."Project Name")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

