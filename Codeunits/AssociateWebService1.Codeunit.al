codeunit 50001 "Associate Web Service_1"
{
    Permissions = TableData "Associate Eligibility Staging" = rim,
                  TableData "Sales Project Wise Setup Hdr" = rim;

    trigger OnRun()
    begin
        AssociateEleg.RESET;
        AssociateEleg.SETRANGE("Publish Data", FALSE);
        AssociateEleg.SETFILTER("Error Message", '%1', '');
        //AssociateEleg.SETRANGE("Entry No.",1,1);
        IF AssociateEleg.FINDSET THEN BEGIN
            REPEAT
                COMMIT;
                CLEAR(GetAssociateEleg);
                GetAssociateEleg.Setfilteres(AssociateEleg."Entry No.");
                IF NOT GetAssociateEleg.RUN(AssociateEleg) THEN BEGIN
                    AssociateEleg."Error Message" := COPYSTR(GETLASTERRORTEXT, 1, 200); //'Error';
                    AssociateEleg.MODIFY;
                END ELSE BEGIN
                    AssociateEleg."Publish Data" := TRUE;
                    AssociateEleg.MODIFY;
                END;
            UNTIL AssociateEleg.NEXT = 0;
        END ELSE
            MESSAGE('%1', 'Data already push on Web.');

        MESSAGE('%1', 'Process Done');
    end;

    var
        AssociateEleg: Record "Associate Eligibility Staging";
        GetAssociateEleg: Codeunit "Associate Web Service_2";
        CommAmount: Decimal;
}

