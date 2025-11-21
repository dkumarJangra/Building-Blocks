page 50014 "Posted Voucher Sub form"
{
    DelayedInsert = true;
    DeleteAllowed = false;
    Editable = false;
    PageType = ListPart;
    SourceTable = "Voucher Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
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
                    Editable = false;
                    Visible = false;
                }
                field("Eligible Amount"; Rec."Eligible Amount")
                {
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                }
                field("TDS Amount"; Rec."TDS Amount")
                {
                    Editable = false;
                }
                field("TDS Applicable"; Rec."TDS Applicable")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Clube 9 Charge Amount"; Rec."Clube 9 Charge Amount")
                {
                    Caption = 'Club 9 Charge Amount';
                    Editable = false;
                }
                field("Plot Incentive Amount"; Rec."Plot Incentive Amount")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Plot Eligible Amount"; Rec."Plot Eligible Amount")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Extent Incentive Amount"; Rec."Extent Incentive Amount")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Narration; Rec.Narration)
                {
                    Editable = true;
                }
                field("Extent Eligible Amount"; Rec."Extent Eligible Amount")
                {
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

