page 60673 "R3 - LEGAL CHECK LIST"
{
    CardPageID = "LAND R3 - LEGAL CHECK Card";
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
                field("KHASRA FOR 1954-55"; Rec."KHASRA FOR 1954-55")
                {
                }
                field("CHESALA FOR 1955-58"; Rec."CHESALA FOR 1955-58")
                {
                }
                field(SETHWAR; Rec.SETHWAR)
                {
                }
            }
        }
    }

    actions
    {
    }
}

