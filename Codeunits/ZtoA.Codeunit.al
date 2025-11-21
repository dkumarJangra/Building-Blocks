codeunit 50037 "Z to A"
{

    trigger OnRun()
    begin
        uplodadata12.RESET;
        uplodadata12.SETFILTER("No.", 'IBA*');
        uplodadata12.SETRANGE("BBG Status", uplodadata12."BBG Status"::Active);
        IF uplodadata12.FINDSET THEN
            REPEAT
                COMMIT;
                Vendor.RESET;
                IF Vendor.GET(uplodadata12."No.") THEN BEGIN
                    CLEAR(AtoZ);
                    IF NOT AtoZ.RUN(Vendor) THEN BEGIN
                        // uplodadata12.Msg := COPYSTR(GETLASTERRORTEXT,1,240);
                        // uplodadata12.MODIFY;
                        COMMIT;

                    END;
                END;
            UNTIL uplodadata12.NEXT = 0;


        MESSAGE('%1', 'Done');
    end;

    var
        Vendor: Record Vendor;
        AtoZ: Codeunit AtoZ;
        Errors: Text;
        uplodadata12: Record Vendor;
        TopHeadDetailsA1: Record "Top Head Details A1";
}

