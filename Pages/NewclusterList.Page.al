page 60766 "New cluster List"
{
    PageType = List;
    SourceTable = "New Cluster Master";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cluster Code"; Rec."Cluster Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Sequence; Rec.Sequence)
                {
                }
                field("Mobile State Id"; Rec."Mobile State Id")
                {
                }
                field("Mobile State Name"; Rec."Mobile State Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

