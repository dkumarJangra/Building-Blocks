page 50242 "Associate Lead Menu Lines"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Associate Lead Menu Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry Ref. No."; Rec."Entry Ref. No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("Menu Name"; Rec."Menu Name")
                {
                }
                field(Value; Rec.Value)
                {
                }
                field(Link; Rec.Link)
                {
                }
            }
        }
    }

    actions
    {
    }
}

