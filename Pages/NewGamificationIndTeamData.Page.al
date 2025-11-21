page 50222 "New Gamification Ind/Team Data"
{
    PageType = List;
    SourceTable = "Individual and Team wise Gamif";
    SourceTableView = WHERE("Sequence of Data" = FILTER(> 0));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Associat Code"; Rec."Associat Code")
                {
                }
                field("Collection Amount"; Rec."Collection Amount")
                {
                }
                field("Rank Code"; Rec."Rank Code")
                {
                }
                field("Team Head"; Rec."Team Head")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field(Extent; Rec.Extent)
                {
                }
                field("No. of Records"; Rec."No. of Records")
                {
                }
                field("Date of Joining"; Rec."Date of Joining")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field(Batch; Rec.Batch)
                {
                }
                field("No. of Plot Booking"; Rec."No. of Plot Booking")
                {
                }
                field("Sequence of Data"; Rec."Sequence of Data")
                {
                }
            }
        }
    }

    actions
    {
    }
}

