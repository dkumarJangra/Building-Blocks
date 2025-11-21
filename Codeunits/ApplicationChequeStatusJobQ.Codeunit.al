codeunit 50035 "Application Cheque Status JobQ"
{

    trigger OnRun()
    begin
        CLEAR(ApplicationChequeStatus);
        ApplicationChequeStatus.CreateApplicationLines(TRUE);
        COMMIT;
        ApplicationChequeStatus.UpdateApplicationCheqStatus(TRUE);
        COMMIT;
    end;

    var
        ApplicationChequeStatus: Page "Application Cheque Status";
        PG: page "Purchase Invoice";
}

