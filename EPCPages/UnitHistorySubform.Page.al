page 97902 "Unit History Subform"
{
    Caption = 'History';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Unit History";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field(Description; Rec.Description)
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Date(Workdate)"; Rec."Date(Workdate)")
                {
                }
                field("Date(Today)"; Rec."Date(Today)")
                {
                }
            }
        }
    }

    actions
    {
    }
}

