pageextension 50035 "BBG Posted Sales Invoices Ext" extends "Posted Sales Invoices"
{
    layout
    {
        // Add changes to page layout here
        addafter("Ship-to Country/Region Code")
        {
            field("Unit Code"; Rec."Unit Code")
            {
                ApplicationArea = All;
            }
            field("Registration Date"; Rec."Registration Date")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}