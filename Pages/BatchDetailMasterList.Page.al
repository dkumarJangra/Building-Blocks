page 60679 "Batch Detail Master List"
{
    AutoSplitKey = true;
    PageType = List;
    SourceTable = "Batch Detail Master";
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
                field(Batch; Rec.Batch)
                {
                }
                field(Points; Rec.Points)
                {
                }
                field("Rate Per Point"; Rec."Rate Per Point")
                {
                }
            }
        }
    }

    actions
    {
    }
}

