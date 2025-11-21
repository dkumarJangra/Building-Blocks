page 97990 "Incentive Summary"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    Editable = false;
    PageType = Card;
    SourceTable = "Incentive Summary";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Incentive Scheme"; Rec."Incentive Scheme")
                {
                }
                field("Calculation Type"; Rec."Calculation Type")
                {
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    Editable = false;
                }
                field("Incentive Application No."; Rec."Incentive Application No.")
                {
                    Editable = false;
                }
                field("Plot Eligible Amount"; Rec."Plot Eligible Amount")
                {
                    Visible = false;
                }
                field("No. of plot"; Rec."No. of plot")
                {
                }
                field("Including Team No. of Plot"; Rec."Including Team No. of Plot")
                {
                }
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field(Month; Rec.Month)
                {
                }
                field("Including Team No. of Extent"; Rec."Including Team No. of Extent")
                {
                }
                field(Year; Rec.Year)
                {
                }
                field("Saleable Area"; Rec."Saleable Area")
                {
                    Caption = 'No. of Extent';
                }
                field("Extent Eligible Amount"; Rec."Extent Eligible Amount")
                {
                    Visible = false;
                }
                field("TDS %"; Rec."TDS %")
                {
                    Visible = false;
                }
                field("TDS Amount"; Rec."TDS Amount")
                {
                    Visible = false;
                }
                field(Level; Rec.Level)
                {
                    Visible = false;
                }
                field(Sequence; Rec.Sequence)
                {
                    Visible = false;
                }
                field("Parent Code"; Rec."Parent Code")
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Visible = false;
                }
                field("Payable Incentive Amount"; Rec."Payable Incentive Amount")
                {
                }
                field("Amount Paid"; Rec."Amount Paid")
                {
                    Visible = false;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                }
                field("Incentive No. Series"; Rec."Incentive No. Series")
                {
                    Visible = false;
                }
                field("Voucher No."; Rec."Voucher No.")
                {
                    Visible = false;
                }
                field("Detail Entry No."; Rec."Detail Entry No.")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
        /*
        //ALLECK 060313 START
        Memberof.RESET;
        Memberof.SETRANGE(Memberof."User ID",USERID);
        Memberof.SETRANGE(Memberof."Role ID",'A_INCENTIVEELIG');
        IF NOT Memberof.FINDFIRST THEN
          ERROR('You do not have permission of role :A_INCENTIVEELIG');
        //ALLECK 060313 End
        */
        // ALLE MM Code Commented as Member of table has been remove in NAV 2016

    end;
}

