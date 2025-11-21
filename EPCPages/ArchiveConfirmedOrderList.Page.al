page 97974 "Archive Confirmed Order List"
{
    Editable = false;
    PageType = Card;
    SourceTable = "Archive Confirmed Order";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Member Name"; Rec."Member Name")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("User Id"; Rec."User Id")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                }
                field("Version No."; Rec."Version No.")
                {
                }
                field("Amount Received"; Rec."Amount Received")
                {
                }
                field("Branch Code"; Rec."Branch Code")
                {
                }
                field("Total Received Amount"; Rec."Total Received Amount")
                {
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                }
                field("Unit Code"; Rec."Unit Code")
                {
                }
                field("Amount Refunded"; Rec."Amount Refunded")
                {
                }
                field("Archive Date"; Rec."Archive Date")
                {
                }
                field("Archive Time"; Rec."Archive Time")
                {
                }
                field("Saleable Area"; Rec."Saleable Area")
                {
                }
                field("Restrict Issue for Gold/Silver"; Rec."Restrict Issue for Gold/Silver")
                {
                }
                field("Restriction Remark"; Rec."Restriction Remark")
                {
                }
                field("Unit Payment Plan"; Rec."Unit Payment Plan")
                {
                }
                field("Unit Plan Name"; Rec."Unit Plan Name")
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        Customer_1: Record Customer;
        Conforder: Record "Confirmed Order";
}

