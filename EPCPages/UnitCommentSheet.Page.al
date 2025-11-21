page 97892 "Unit Comment Sheet"
{
    PageType = ListPart;
    SourceTable = "Comment Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; Rec.Date)
                {
                }
                field(Code; Rec.Code)
                {
                }
                field(Comment; Rec.Comment)
                {
                }
                // field("User ID"; "User ID")
                // {
                // }
            }
        }
    }

    actions
    {
    }
}

