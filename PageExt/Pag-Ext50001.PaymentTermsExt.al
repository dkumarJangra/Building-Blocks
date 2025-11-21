pageextension 50001 "BBG Payment Terms Ext" extends "Payment Terms"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addlast(ActionGroupCRM)
        {
            group(Function)
            {
                Caption = 'Function';
                action("&Release")
                {
                    Caption = '&Release';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        CurrPage.EDItable(FALSE);
                        CurrPage.UPDATE;
                    end;
                }
                action("Re&Open")
                {
                    Caption = 'Re&Open';
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        CurrPage.Editable(TRUE);
                        CurrPage.UPDATE;
                    end;
                }
            }
        }
    }

    var
        myInt: Integer;
}