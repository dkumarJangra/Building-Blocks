page 50090 "Company wise G/L"
{
    PageType = Card;
    SourceTable = "Company wise G/L Account";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Company Code"; Rec."Company Code")
                {
                }
                field("Receivable Account"; Rec."Receivable Account")
                {
                }
                field("Receivable Account Name"; Rec."Receivable Account Name")
                {
                }
                field("Payable Account"; Rec."Payable Account")
                {
                }
                field("Payable Account Name"; Rec."Payable Account Name")
                {
                }
                field("MSC Company"; Rec."MSC Company")
                {
                    Editable = false;
                }
                field("Development Company"; Rec."Development Company")
                {
                }
            }
        }
    }

    actions
    {
    }
}

