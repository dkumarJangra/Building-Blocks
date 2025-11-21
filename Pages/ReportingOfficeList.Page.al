page 50102 "Reporting Office List"
{
    CardPageID = "Reporting Office Card";
    PageType = List;
    SourceTable = "Reporting Office Master";
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
                field("Mobile Cluster Name"; Rec."Mobile Cluster Name")
                {
                }
                field("Mobile State Name"; Rec."Mobile State Name")
                {
                    Editable = false;
                }
                field("Mobile State Id"; Rec."Mobile State Id")
                {
                }
                field("Mobile Cluster Sequence"; Rec."Mobile Cluster Sequence")
                {
                }
                field("Region Code"; Rec."Region Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

