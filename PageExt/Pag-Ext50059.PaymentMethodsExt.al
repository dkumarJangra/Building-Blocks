pageextension 50059 "BBG Payment Methods Ext" extends "Payment Methods"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("T&ranslation")
        {
            group(Function)
            {
                Caption = 'Function';
                action("&Release")
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        CurrPage.EDITABLE(FALSE);
                        CurrPage.UPDATE;
                    end;
                }
                action("Re&Open")
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        CurrPage.EDITABLE(TRUE);
                        CurrPage.UPDATE;
                    end;
                }
            }
        }
    }

    var
        myInt: Integer;
}