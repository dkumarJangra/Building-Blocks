pageextension 50121 "Sales Invoice List Ext" extends "Sales Invoice List"
{
    layout
    {
        addlast(Control1)
        {
        }
    }

    actions
    {
        addlast(processing)
        {
            // action("Custom Action")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Custom action for Sales Invoice List.';
            //     Image = Action;

            //     trigger OnAction()
            //     begin
            //         Message('Custom action executed.');
            //     end;
            // }
        }
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        rec.SetRange("Inter Sales Document", false);
    end;
}