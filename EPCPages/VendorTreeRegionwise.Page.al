page 50073 "Vendor Tree Region wise"
{
    Editable = false;
    PageType = List;
    SourceTable = "Vendor Tree";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Region/Rank Code"; Rec."Region/Rank Code")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field("Effective Date"; Rec."Effective Date")
                {
                }
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Parent Code"; Rec."Parent Code")
                {
                }
                field("Rank Code"; Rec."Rank Code")
                {
                }
                field("Rank Description"; Rec."Rank Description")
                {
                }
                field("Associate Name"; Rec."Associate Name")
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

