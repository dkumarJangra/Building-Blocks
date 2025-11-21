page 97989 "Incentive Detail Entry"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    Editable = false;
    PageType = Card;
    SourceTable = "Incentive Detail Entry";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Incentive Application No."; Rec."Incentive Application No.")
                {
                }
                field("Incentive Scheme"; Rec."Incentive Scheme")
                {
                    Editable = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                }
                field(Month; Rec.Month)
                {
                }
                field(Year; Rec.Year)
                {
                }
                field("Team Incentive Scheme"; Rec."Team Incentive Scheme")
                {
                }
                field("Team Calculation Type"; Rec."Team Calculation Type")
                {
                }
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("Application Date"; Rec."Application Date")
                {
                }
                field("No. of Units"; Rec."No. of Units")
                {
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                }
                field("Amount Received"; Rec."Amount Received")
                {
                }
                field("Application No."; Rec."Application No.")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("BSP1 Amount"; Rec."BSP1 Amount")
                {
                }
                field("Unit No."; Rec."Unit No.")
                {
                }
                field("Plot Value"; Rec."Plot Value")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                }
                field("Valid Application"; Rec."Valid Application")
                {
                }
                field("Calculation Type"; Rec."Calculation Type")
                {
                }
                field("Incentive No. Series"; Rec."Incentive No. Series")
                {
                }
                field("Saleable Area"; Rec."Saleable Area")
                {
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
        Memberof.SETRANGE(Memberof."Role ID",'A_INCENTIVEQUAL');
        IF NOT Memberof.FINDFIRST THEN
          ERROR('You do not have permission of role :A_INCENTIVEQUAL');
        //ALLECK 060313 End
        */
        // ALLE MM Code Commented as Member of table has been remove in NAV 2016

    end;
}

