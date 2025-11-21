page 98003 "Gold Coin SetupList"
{
    CardPageID = "Gold Coin Hdr";
    PageType = List;
    SourceTable = "Gold Coin Hdr";
    UsageCategory = Lists;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Plot Size"; Rec."Plot Size")
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

