page 50058 "Asst Elig Web Unit Vacate"
{
    PageType = Card;
    Sourcetable = "Associate Eligibility on Web";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Editable = false;
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Commission_TA Amount"; Rec."Commission_TA Amount")
                {
                }
                field(Date; Rec.Date)
                {
                }
                field("Response Value"; Rec."Response Value")
                {
                }
            }
        }
    }

    actions
    {
    }
}

