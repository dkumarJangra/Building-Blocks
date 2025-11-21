page 97808 "FD List"
{
    // +------------------------------------------+
    // | Voith Turbo Private Limited , Hyderabad  |
    // +------------------------------------------+
    // 
    // -------------------------------------------------------------------------------------------------------------
    // Local Specifications
    // -------------------------------------------------------------------------------------------------------------
    // Nr. Update    Date       SS         No.      Description
    // -------------------------------------------------------------------------------------------------------------
    // L01           30.06.09   Hyd_Msr             Created.

    Editable = false;
    PageType = Card;
    SourceTable = "Fixed Deposit Details";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("FD No."; Rec."FD No.")
                {
                }
                field("FD Start date"; Rec."FD Start date")
                {
                }
                field("Bank Name"; Rec."Bank Name")
                {
                }
                field("Bank FD Account No."; Rec."Bank FD Account No.")
                {
                }
                field("FD maturity date"; Rec."FD maturity date")
                {
                }
                field("FD Amount"; Rec."FD Amount")
                {
                }
                field("Interest rate"; Rec."Interest rate")
                {
                }
                field("Intrest Amount"; Rec."Intrest Amount")
                {
                }
                field("Total Maturity Amount"; Rec."Total Maturity Amount")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnClosePage()
    begin
        CurrPage.SETSELECTIONFILTER(Rec);
        Rec.MODIFYALL(Selected, TRUE);
    end;

    trigger OnOpenPage()
    begin
        Rec.SETRANGE(Selected, TRUE);
        Rec.MODIFYALL(Selected, FALSE);
        Rec.RESET;
    end;
}

