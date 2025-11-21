report 97772 "OS Interface Routines"
{
    // version Done

    DefaultLayout = RDLC;
    RDLCLayout = './OS Interface Routines.rdl';
    ApplicationArea = All;

    dataset
    {
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    procedure Print(Path: Text[250]; Name: Text[250])
    var
        // MSShell: Automation;
        // Folder: Automation;
        // Item: Automation;
        ExitFlag: Boolean;
    begin
        ExitFlag := FALSE;

        //CREATE(MSShell); // ALLE MM Code Commented
        //Folder := MSShell.NameSpace(Path); // ALLE MM Code Commented

        // IF NOT ISCLEAR(Folder) THEN BEGIN
        //     Item := Folder.ParseName(Name);
        //     IF NOT ISCLEAR(Item) THEN BEGIN
        //         Item.InvokeVerb('Print');
        //         ExitFlag := TRUE;
        //     END;
        // END;

        // CLEAR(Item);
        // CLEAR(Folder);
        //CLEAR(MSShell); // ALLE MM Code Commented
    end;

    procedure RunByFileName(FileName: Text[250])
    var
        // MSShell: Automation;
        // Folder: Automation;
        // Item: Automation;
        FolderName: Text[250];
        ItemName: Text[250];
        DocumentSetup: Record "Document Setup";
        ExitFlag: Boolean;
    begin
        ExitFlag := FALSE;

        FolderName := DocumentSetup.ExtractFilePath(FileName, 0);
        ItemName := DocumentSetup.ExtractFileNameAndExt(FileName, 0);

        //CREATE(MSShell); // ALLE MM Code Commented
        // Folder := MSShell.NameSpace(FolderName);

        // IF NOT ISCLEAR(Folder) THEN BEGIN
        //     Item := Folder.ParseName(ItemName);
        //     IF NOT ISCLEAR(Item) THEN BEGIN
        //         Item.InvokeVerb();
        //         ExitFlag := TRUE;
        //     END;
        // END;

        // CLEAR(Item);
        // CLEAR(Folder);
        //CLEAR(MSShell); // ALLE MM Code Commented
    end;

    procedure OfficeVersion() Version: Integer
    var
        VersionStr: Text[30];
    begin
        // Works on Word application. So mixed word/excel versions beware!     ({00020905-0000-0000-C000-000000000046} 8.1)
        //CREATE(wordApp,TRUE); // ALLE MM Code Commented
        Version := 10; // Default office xp
                       //VersionStr := wordApp.Version; // ALLE MM Code Commented
        IF STRPOS(VersionStr, '11') > 0 THEN
            Version := 11 ELSE // Office 2003
            IF STRPOS(VersionStr, '10') > 0 THEN
                Version := 10 ELSE // Office XP
                IF STRPOS(VersionStr, '9') > 0 THEN
                    Version := 9 ELSE   // Office 2000
                    IF STRPOS(VersionStr, '8') > 0 THEN Version := 8;       // Office 97 (no planned support)
                                                                            //wordApp.Quit; // ALLE MM Code Commented
                                                                            //CLEAR(wordApp); // ALLE MM Code Commented
    end;
}

