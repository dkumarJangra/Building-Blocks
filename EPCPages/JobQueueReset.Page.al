page 50037 "Job Queue Reset"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
    }

    actions
    {
        area(processing)
        {
            action("Reset Job Queue")
            {
                Caption = 'Reset Job Queue';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CODEUNIT.RUN(Codeunit::"Job Queue Dispatcher");

                    MESSAGE('%1', 'Job Queue restart');
                end;
            }
        }
    }

    var
        SmsCodeunit: Codeunit "SMS Features";
}

