page 98999 "Remark Input Page"
{
    Caption = 'Remark Input Page';
    PageType = StandardDialog;
    ApplicationArea = all;
    UsageCategory = Administration;
    layout
    {
        area(content)
        {

            field(InputValue; InputValue)
            {
                ApplicationArea = all;
                Caption = 'Remarks';
                QuickEntry = false;
                StyleExpr = TRUE;

            }


        }

    }

    actions
    {
    }




    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var


    begin
        IF CloseAction IN [ACTION::LookupOK, ACTION::OK] THEN
            LookupOKOnPush();


    end;

    var
        InputValue: Text;
        ConfirmedOrder: Record "Confirmed Order";
        GetValue: Code[20];

    procedure GetValues(Var ConforderCode: Code[20])
    begin
        GetValue := ConforderCode;
    end;

    local procedure LookupOKOnPush()
    var

    begin

        ConfirmedOrder.RESET;
        If ConfirmedOrder.GET(GetValue) THEn begin
            ConfirmedOrder."Restriction Remark" := InputValue;
            ConfirmedOrder.MODIFY;
        end;
    end;
}