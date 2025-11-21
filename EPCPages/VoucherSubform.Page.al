page 97952 "Voucher Sub form"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    DeleteAllowed = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Voucher Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    Editable = false;
                }
                field("Associate Code"; Rec."Associate Code")
                {
                    Editable = false;
                }
                field("Base Amount"; Rec."Base Amount")
                {
                    Visible = false;
                }
                field("Eligible Amount"; Rec."Eligible Amount")
                {
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                }
                field("TDS Amount"; Rec."TDS Amount")
                {
                }
                field(Narration; Rec.Narration)
                {
                }
                field("TDS Applicable"; Rec."TDS Applicable")
                {
                    Visible = false;
                }
                field("Clube 9 Charge Amount"; Rec."Clube 9 Charge Amount")
                {
                    Editable = false;
                }
                field("Plot Incentive Amount"; Rec."Plot Incentive Amount")
                {
                    Visible = false;
                }
                field("Plot Eligible Amount"; Rec."Plot Eligible Amount")
                {
                    Visible = false;
                }
                field("Extent Incentive Amount"; Rec."Extent Incentive Amount")
                {
                    Visible = false;
                }
                field("Extent Eligible Amount"; Rec."Extent Eligible Amount")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

