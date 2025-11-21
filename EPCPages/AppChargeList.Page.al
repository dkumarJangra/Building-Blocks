page 97872 "App. Charge List"
{
    PageType = List;
    SourceTable = "App. Charge Code";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field(Code; Rec.Code)
                {
                }
                field("Sub Payment Plan"; Rec."Sub Payment Plan")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                }
            }
        }
    }

    actions
    {
    }
}

