page 60721 "Lead Induction List"
{
    CardPageID = "Land Induction Deatils";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Lead Inducation Details";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Lead ID"; Rec."Lead ID")
                {
                }
                field(Comments; Rec.Comments)
                {
                }
                field("Inducation Kit"; Rec."Inducation Kit")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Associate ID"; Rec."Associate ID")
                {
                }
            }
        }
    }

    actions
    {
    }
}

