page 50044 "Voucher Sub form Incentive"
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
            repeater(General)
            {
                field(Type; Rec.Type)
                {
                    Editable = true;
                    OptionCaption = ' ,Incentive,Commission,TA';

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field("Associate Code"; Rec."Associate Code")
                {
                    Editable = true;

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field("Company Code"; Rec."Company Code")
                {

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field("Base Amount"; Rec."Base Amount")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field("Eligible Amount"; Rec."Eligible Amount")
                {
                    Caption = 'Amount';
                    Editable = true;
                    Visible = true;

                    trigger OnValidate()
                    begin
                        CheckStatus;
                        Rec.VALIDATE(Amount, Rec."Eligible Amount");
                        Rec."Net Amount" := Rec.Amount - Rec."TDS Amount" - Rec."Clube 9 Charge Amount";
                    end;
                }
                field(Amount; Rec.Amount)
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field("TDS Amount"; Rec."TDS Amount")
                {

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field("Clube 9 Charge Amount"; Rec."Clube 9 Charge Amount")
                {
                    Editable = false;

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field("Net Amount"; Rec."Net Amount")
                {

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field(Narration; Rec.Narration)
                {

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field("TDS Applicable"; Rec."TDS Applicable")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field("Plot Incentive Amount"; Rec."Plot Incentive Amount")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field("Plot Eligible Amount"; Rec."Plot Eligible Amount")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field("Extent Incentive Amount"; Rec."Extent Incentive Amount")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field("Extent Eligible Amount"; Rec."Extent Eligible Amount")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        VHeader: Record "Assoc Pmt Voucher Header";

    local procedure CheckStatus()
    begin
        VHeader.RESET;
        IF VHeader.GET(Rec."Voucher No.") THEN BEGIN
            IF VHeader."Special Incentive for Bonanza" THEN
                VHeader.TESTFIELD("Spl. Inct. Send for Approval", FALSE);
        END;
    end;
}

