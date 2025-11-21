page 50241 "Associate Lead Menu Card"
{
    PageType = Card;
    SourceTable = "Associate Lead Menu Master";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
            }
            part(""; "Associate Lead Menu Lines")
            {
                SubPageLink = "Entry Ref. No." = FIELD("Entry No.");
            }
        }
    }

    actions
    {
    }
}

