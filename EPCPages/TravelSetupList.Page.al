page 97994 "Travel Setup List"
{
    CardPageID = "Travel Setup Header";
    Editable = false;
    PageType = List;
    SourceTable = "Travel Setup Header";
    UsageCategory = Lists;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Effective Date"; Rec."Effective Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

