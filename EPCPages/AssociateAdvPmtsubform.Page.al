page 50088 "Associate Adv. Pmt. subform"
{
    AutoSplitKey = true;
    DelayedInsert = false;
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
                }
                field("Associate Code"; Rec."Associate Code")
                {
                    Editable = true;
                }
                field("Company Code"; Rec."Company Code")
                {
                }
                field("Base Amount"; Rec."Base Amount")
                {
                    Visible = false;
                }
                field("Eligible Amount"; Rec."Eligible Amount")
                {
                    Caption = 'Amount';
                    Editable = true;
                    Visible = true;

                    trigger OnValidate()
                    begin

                        UnitSetup.GET;
                        "TDS%" := PostPayment.CalculateTDSPercentage(Rec."Associate Code", UnitSetup."TDS Nature of Deduction TA", Rec."Company Code");

                        Rec."TDS Amount" := ROUND((Rec."Eligible Amount" * "TDS%" / 100), 1, '=');
                        Rec."Clube 9 Charge Amount" := Rec."Eligible Amount" * UnitSetup."Corpus %" / 100;

                        Rec."Net Amount" := Rec."Eligible Amount" - Rec."TDS Amount" - Rec."Clube 9 Charge Amount";
                        Rec.Amount := Rec."Eligible Amount";
                    end;
                }
                field("TDS Amount"; Rec."TDS Amount")
                {
                }
                field("Clube 9 Charge Amount"; Rec."Clube 9 Charge Amount")
                {
                }
                field(Amount; Rec.Amount)
                {
                    Visible = false;
                }
                field("Net Amount"; Rec."Net Amount")
                {
                    Caption = 'Cheque Amount';
                }
                field(Narration; Rec.Narration)
                {
                }
                field("TDS Applicable"; Rec."TDS Applicable")
                {
                    Visible = false;
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

    var
        VHeader: Record "Assoc Pmt Voucher Header";
        "TDS%": Decimal;
        PostPayment: Codeunit PostPayment;
        UnitSetup: Record "Unit Setup";
}

