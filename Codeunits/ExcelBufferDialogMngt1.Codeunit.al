codeunit 50038 "Excel Buffer Dialog Mngt_1"
{
    // // Allows capture of cancel button event by using the return value of RUN


    trigger OnRun()
    begin
        Window.UPDATE(1, Progress);
    end;

    var
        Window: Dialog;
        Progress: Integer;
        WindowOpen: Boolean;


    procedure Open(Text: Text)
    begin
        //IF NOT GUIALLOWED THEN
        // EXIT;

        Window.OPEN(Text + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.UPDATE(1, 0);
        WindowOpen := TRUE;
    end;


    procedure SetProgress(pProgress: Integer)
    begin
        Progress := pProgress;
    end;


    procedure Close()
    begin
        IF WindowOpen THEN BEGIN
            Window.CLOSE;
            WindowOpen := FALSE;
        END;
    end;
}

