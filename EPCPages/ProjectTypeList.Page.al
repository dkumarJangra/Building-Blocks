page 97887 "Project Type List"
{
    CardPageID = "Unit Type Card";
    PageType = List;
    SourceTable = "Unit Type";
    SourceTableView = WHERE(Blocked = FILTER(false));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(Description; Rec.Description)
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                }
                field("Bond Nos."; Rec."Bond Nos.")
                {
                    Caption = 'Unit No.';
                }
            }
        }
    }

    actions
    {
    }
}

