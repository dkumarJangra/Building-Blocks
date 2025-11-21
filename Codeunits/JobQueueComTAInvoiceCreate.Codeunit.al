codeunit 50034 "JobQueue Com/TA Invoice Create"
{

    trigger OnRun()
    begin
        // CLEAR(BatchCommissionGeneration);
        // IF NOT BatchCommissionGeneration.RUN THEN BEGIN
        //     JobQueueLogDetails.RESET;
        //     IF JobQueueLogDetails.FINDLAST THEN
        //         EntryNo := JobQueueLogDetails."Entry No."
        //     ELSE
        //         EntryNo := 1;
        //     JobQueueLogDetails.INIT;
        //     JobQueueLogDetails."Entry No." := EntryNo;
        //     JobQueueLogDetails."Process Name" := 'Generate Commission';
        //     JobQueueLogDetails."Process Code" := 'Codeunit 50032';
        //     JobQueueLogDetails."Process Date" := TODAY;
        //     JobQueueLogDetails."Process Time" := TIME;
        //     JobQueueLogDetails."Error Message" := COPYSTR(GETLASTERRORTEXT, 1, 200);
        //     JobQueueLogDetails."Company Name" := COMPANYNAME;
        //     JobQueueLogDetails.INSERT;
        // END;
    end;

    var
        // BatchCommissionGeneration: Codeunit 50031;
        JobQueueLogDetails: Record "Job Queue Log Details";
        EntryNo: Integer;
}

