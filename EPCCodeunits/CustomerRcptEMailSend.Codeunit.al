codeunit 97762 "Customer Rcpt E-Mail Send"
{

    trigger OnRun()
    begin
        NAppLicationEntry.RESET;
        NAppLicationEntry.SETRANGE("Posting date", TODAY);
        NAppLicationEntry.SETRANGE("Send Mail", TRUE);
        IF NAppLicationEntry.FINDSET THEN
            REPEAT
                NAppLicationEntry."Send Mail" := FALSE;
                NAppLicationEntry.MODIFY;
            UNTIL NAppLicationEntry.NEXT = 0;


        DocNo := '';
        NAppLicationEntry.RESET;
        NAppLicationEntry.SETRANGE("Posting date", TODAY);
        NAppLicationEntry.SETRANGE("Send Mail", FALSE);
        IF NAppLicationEntry.FINDSET THEN
            REPEAT
                IF DocNo <> NAppLicationEntry."Document No." THEN BEGIN
                    DocNo := NAppLicationEntry."Document No.";
                    CLEAR(Codeunit_12);
                    Codeunit_12.SetEmailFilters(NAppLicationEntry."Document No.");
                    IF NOT Codeunit_12.RUN(NAppLicationEntry) THEN BEGIN
                        NAppLicationEntry."Send Mail" := FALSE;
                        NAppLicationEntry.MODIFY;
                        COMMIT;
                    END;
                END;
            UNTIL NAppLicationEntry.NEXT = 0;
        MESSAGE('%1', 'Send Mail');
    end;

    var
        Codeunit_12: Codeunit "Send E-mail to Customer";
        NAppLicationEntry: Record "NewApplication Payment Entry";
        DocNo: Code[20];
}

