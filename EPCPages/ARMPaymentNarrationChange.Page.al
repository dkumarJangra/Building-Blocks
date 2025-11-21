page 50042 "ARM Payment Narration Change"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    DeleteAllowed = false;
    Editable = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = Card;
    SourceTable = "Voucher Line";
    ApplicationArea = All;
    UsageCategory = Documents;

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
                field("Voucher No."; Rec."Voucher No.")
                {
                    Editable = false;
                }
                field(Narration; Rec.Narration)
                {
                    Editable = true;

                    trigger OnValidate()
                    begin
                        IF CONFIRM('Do you want to change Narration ?', TRUE) THEN BEGIN
                        END ELSE
                            Rec.Narration := xRec.Narration;
                    end;
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
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

