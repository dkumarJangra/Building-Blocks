pageextension 50063 "BBG Purchases & Pay. Setup Ext" extends "Purchases & Payables Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter(General)
        {
            group("BBG Fields")
            {
                Caption = 'BBG Fields';
                field("Reserve Associate Payment Amt"; Rec."Reserve Associate Payment Amt")
                {
                    ApplicationArea = All;
                }
                field("Request No."; Rec."Request No.")
                {
                    ApplicationArea = All;
                }
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