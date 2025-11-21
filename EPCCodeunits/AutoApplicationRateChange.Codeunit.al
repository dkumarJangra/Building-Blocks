codeunit 97766 "Auto Application Rate Change"
{

    trigger OnRun()
    var
        ApplicationRateChangeSetup: Record "Application Rate Change Setup";
        v_NewConfirmedOrder: Record "New Confirmed Order";
    begin
        ApplicationRateChangeSetup.RESET;
        ApplicationRateChangeSetup.SETRANGE(Status, ApplicationRateChangeSetup.Status::Active);
        ApplicationRateChangeSetup.SETRANGE("Project Code", NewConfirmedOrder."Shortcut Dimension 1 Code");
        ApplicationRateChangeSetup.SETRANGE("Payment Option", ApplicationRateChangeSetup."Payment Option"::A);
        IF ApplicationRateChangeSetup.FINDSET THEN
            REPEAT
                NewConfirmedOrder.RESET;
                NewConfirmedOrder.SETFILTER(Status, '%1|%2', NewConfirmedOrder.Status::Open, NewConfirmedOrder.Status::Vacate);
                NewConfirmedOrder.SETRANGE("Shortcut Dimension 1 Code", ApplicationRateChangeSetup."Project Code");
                IF NewConfirmedOrder.FINDSET THEN
                    REPEAT


                    UNTIL NewConfirmedOrder.NEXT = 0;
            UNTIL ApplicationRateChangeSetup.NEXT = 0;
    end;

    var
        NewConfirmedOrder: Record "New Confirmed Order";
}

