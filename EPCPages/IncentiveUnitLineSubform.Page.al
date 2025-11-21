page 97987 "Incentive Unit Line Subform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Incentive Unit Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Min. Extent"; Rec."Min. Extent")
                {
                }
                field("Max. Extent"; Rec."Max. Extent")
                {
                }
                field(UOM; Rec.UOM)
                {
                }
                field("No. of Units"; Rec."No. of Units")
                {
                }
            }
        }
    }

    actions
    {
    }
}

