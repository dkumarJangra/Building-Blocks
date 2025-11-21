pageextension 50044 "BBG Source Codes Ext" extends "Source Codes"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Source")
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
                    end;
                }
                action("Re&Open")
                {
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        CurrPage.EDITABLE(TRUE);
                    end;
                }
            }
        }
    }

    var
        myInt: Integer;
}