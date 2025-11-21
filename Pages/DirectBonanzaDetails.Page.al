page 50220 "Direct Bonanza Details"
{
    Editable = false;
    PageType = List;
    SourceTable = "Direct Bonanza App. Details";
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
                field("Ref. Entry No."; Rec."Ref. Entry No.")
                {
                }
                field("Application No."; Rec."Application No.")
                {
                }
                field(Extent; Rec.Extent)
                {
                }
            }
        }
    }

    actions
    {
    }
}

