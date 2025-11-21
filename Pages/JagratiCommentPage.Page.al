page 60820 "Jagrati comment Input Page"
{
    Caption = 'Jagrati Comment Input';
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
                Caption = 'Enter Comment';
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
        JagratiApprovalEntry: Record "Jagriti Approval Entry";
        GetValue: Integer;

    procedure GetValues(Var EntryNo: Integer)
    begin
        GetValue := EntryNo;
    end;

    local procedure LookupOKOnPush()
    var

    begin

        JagratiApprovalEntry.RESET;
        If JagratiApprovalEntry.GET(GetValue) THEn begin

            JagratiApprovalEntry."Status Comment" := InputValue;
            JagratiApprovalEntry.MODIFY;


        end;
    end;
}