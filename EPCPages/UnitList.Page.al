page 97909 "Unit List"
{
    Caption = 'Confirmed Order List';
    CardPageID = "Confirmed Order";
    Editable = false;
    PageType = List;
    SourceTable = "Confirmed Order";
    SourceTableView = WHERE("Application Transfered" = CONST(false));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Unit Code"; Rec."Unit Code")
                {
                }
                field("Payment Plan"; Rec."Payment Plan")
                {
                }
                field("Saleable Area"; Rec."Saleable Area")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Customer Name"; Cust.Name)
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("User Id"; Rec."User Id")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Direct Incentive Amount"; Rec."Direct Incentive Amount")
                {
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                }
                field("Total Received Amount"; Rec."Total Received Amount")
                {
                }
                field("Last Receipt Date"; Rec."Last Receipt Date")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Loan File"; Rec."Loan File")  //251124 field added
                {
                    Visible = false;
                }
                field("New Loan File"; Rec."New Loan File")
                {
                    Caption = 'New Loan File';
                }
                field("Registration No."; Rec."Registration No.")
                {
                }
                field("Registration Date"; Rec."Registration Date")
                {
                }
                field("LLP Name"; Rec."LLP Name")
                {
                    Visible = false;
                }
                field("Registration Bonus Hold(BSP2)"; Rec."Registration Bonus Hold(BSP2)")
                {
                    Editable = false;
                }
                field("Unit Facing"; Rec."Unit Facing")
                {
                }
                field("60 feet road"; Rec."60 feet road")
                {
                }
                field("100 feet road"; Rec."100 feet road")
                {
                }
                field("Travel Generate"; Rec."Travel Generate")
                {
                }
                field("Silver Coin Value"; Rec."Silver Coin Value")
                {
                }
                field("Pass Book No."; Rec."Pass Book No.")
                {
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    Visible = false;
                }
                field("Gold Coin Generated"; Rec."Gold Coin Generated")
                {
                }
                field("Gold Coin Issued"; Rec."Gold Coin Issued")
                {
                }
                field("Silver Coin Generated"; Rec."Silver Coin Generated")
                {
                }
                field("Silver Coin Eligible"; Rec."Silver Coin Eligible")
                {
                }
                field("Silver Coin Issued"; Rec."Silver Coin Issued")
                {
                }
                field("Total Commission Amt."; Rec."Total Commission Amt.")
                {
                }
                field("Gold Coin Value"; Rec."Gold Coin Value")
                {
                }
                field("Restrict Issue for Gold/Silver"; Rec."Restrict Issue for Gold/Silver")
                {
                }
                field("Restriction Remark"; Rec."Restriction Remark")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Unit")
            {
                Caption = '&Unit';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Confirmed Order";
                    RunPageLink = "No." = FIELD("No.");
                    RunPageView = SORTING("No.");
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Cust.RESET;
        IF Cust.GET(Rec."Customer No.") THEN;
    end;

    var
        GetDescription: Codeunit GetDescription;
        Cust: Record Customer;
}

