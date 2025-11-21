page 60676 "R-2 Check list"
{
    CardPageID = "R-2 Check List Card";
    Editable = false;
    PageType = List;
    SourceTable = "Land R-2 PPR  Document List";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field("Name of the land holder"; Rec."Name of the land holder")
                {
                }
                field(Pattadar; Rec.Pattadar)
                {
                }
                field(Possessor; Rec.Possessor)
                {
                }
                field("Survey No./ Sub-Division No."; Rec."Survey No./ Sub-Division No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

