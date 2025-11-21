page 50145 "Confirmed DevmntCharge list"
{
    Caption = 'Confirm DevelopmentCharge list';
    CardPageID = "Confirmed Development Charge";
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Confirmed Order";
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
                field("New Total Received Amount"; Rec."New Total Received Amount")
                {
                }
                field("Development Charges"; Rec."Development Charges")
                {
                }
                field("Total Received Dev. Charges"; Rec."Total Received Dev. Charges")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                    Visible = false;
                }
                field("LLP Name"; Rec."LLP Name")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
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

