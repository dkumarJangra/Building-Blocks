report 50124 "Land Doc Access Management"
{
    // version BBG2.0

    DefaultLayout = RDLC;
    RDLCLayout = './Land Doc Access Management.rdl';
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

    var
        Tries: Integer;
        W_INUSE: Label 'Document %1 is in use by %2';
        W_INUSE_OVRRIDE: Label 'Are you sure you want to edit this document even if this can result in changes being lost?';
        E_FILELOST: Label 'The document file %1 was removed externally. Document changes lost.';
        E_DOCLOST: Label 'The document %1  was deleted. Document lost.';
        DocSetup: Record "Document Setup";
        Path: Text[250];
        I_IMPORT: Label 'Import Document';
        I_EXPORT: Label 'Export Document';

    local procedure GetStoragePath(): Text[260]
    begin
        // To activate external storage of documents, fill out exit with a path like exit('x:\common\documents\');
        // Remember the terminating '\'.

        // Before activating external storage, please read the following:
        // 1. All users should have read/write access to the pathdestination
        // 2. The path must point to the same physical harddisk folder for *all* MD3 users
        // 3. You can activate external storage in a system that already has documents in the database.
        //    New documents or modifications to existing documents will then be stored outside the DB from then on.
        //    Old documents will still be avalible.
        // 4. The Database backup will *not* backup external documents, if they are stored externally
        // 5. No matriks support is given for loss of documents, if external storage is activated!!!

        IF DocSetup.GET THEN
            Path := DocSetup."Import Path";
        EXIT(Path);
    end;

    local procedure GetFileName(var DocumentRec: Record "Land Document Attachment"): Text[260]
    begin
        //EXIT(GetStoragePath + FORMAT(DocumentRec.GUID) + '.mdoc');
        EXIT(GetStoragePath + FORMAT(DocumentRec.Description) + '.' + FORMAT(DocumentRec."File Extension"));
    end;

    local procedure StoreInDB(): Boolean
    begin
        EXIT(GetStoragePath = '');
    end;

    procedure RecInDB(var DocumentRec: Record "Land Document Attachment"): Boolean
    var
        OK: Boolean;
    begin
        OK := FALSE;

        IF DocumentRec.CALCFIELDS(DocumentRec.Content) THEN
            OK := DocumentRec.Content.HASVALUE;

        EXIT(OK);
    end;

    procedure HasValue(var DocumentRec: Record "Land Document Attachment"): Boolean
    var
        OK: Boolean;
        FileMgt: Codeunit "File Management";
    begin
        OK := FALSE;

        // First check DB
        OK := RecInDB(DocumentRec);

        // If fail, check external storage
        IF NOT OK THEN
            IF NOT (ISNULLGUID(DocumentRec.GUID) OR StoreInDB()) THEN
                //    OK := EXISTS(GetFileName(DocumentRec));
                //OK := FileMgt.ClientFileExists(GetFileName(DocumentRec));
                OK := FileMgt.ServerFileExists(GetFileName(DocumentRec));
        EXIT(OK);
    end;

    procedure Import(var DocumentRec: Record "Land Document Attachment"; FileName: Text[260]): Text[260]
    var
        ImportFileName: Text[260];
        //BLOBRef: Record 99008535 temporary;
        FileMgt: Codeunit "File Management";
        ImportFileName2: Text[260];
        Position: Integer;
    begin
        ImportFileName := '';

        IF StoreInDB() THEN BEGIN// If external storage is not turned on, store in DB.
                                 //ImportFileName := DocumentRec.Content.IMPORT(FileName, FALSE) //ALLE
                                 //ImportFileName := FileMgt.BLOBImport(BLOBRef,FileName);
                                 //DocumentRec.Content := BLOBRef.Blob;
        END ELSE BEGIN
            CLEAR(DocumentRec.Content); // Clear any existing content,
            IF ISNULLGUID(DocumentRec.GUID) THEN
                DocumentRec.GUID := CREATEGUID();
            //ALLE
            //ImportFileName := FileMgt.OpenFileDialog(I_IMPORT, FileName, '(*.*)|*.*');
            //ImportFileName := FileMgt.BLOBImport(BLOBRef,FileName);
            ImportFileName2 := ImportFileName;
            //ImportFileName2 := GetFileName(DocumentRec);
            Position := STRPOS(ImportFileName2, '\');
            IF Position > 0 THEN
                REPEAT
                    ImportFileName2 := COPYSTR(ImportFileName2, Position + 1, STRLEN(ImportFileName2) - Position);
                    Position := STRPOS(ImportFileName2, '\');
                UNTIL Position = 0;
            // FileMgt.CopyClientFile(ImportFileName, FileName + ImportFileName2, TRUE);
            // //FileMgt.BLOBExportToServerFile(BLOBRef,FileName + ImportFileName2);
            // IF COPY(FileName, GetFileName(DocumentRec)) THEN
            //     ImportFileName := FileName;
            // //ALLE
        END;
        EXIT(ImportFileName)
    end;

    procedure Export(var DocumentRec: Record "Land Document Attachment"; FileName: Text[260]): Text[260]
    var
        ExportFileName: Text[260];
        // BLOBRef: Record 99008535 temporary;
        FileMgt: Codeunit "File Management";
    begin
        ExportFileName := '';

        IF RecInDB(DocumentRec) THEN BEGIN
            //ALLE
            //ExportFileName := DocumentRec.Content.EXPORT(FileName, FALSE)
            //BLOBRef.Blob := DocumentRec.Content;
            //ExportFileName := FileMgt.BLOBExport(BLOBRef,FileName,TRUE);
        END ELSE

            // IF COPY(GetFileName(DocumentRec), FileName) THEN BEGIN
            //     //FileMgt.BLOBImportFromServerFile(BLOBRef,FileName);
            //     //FileMgt.DeleteServerFile(FileName);
            //     //ExportFileName := FileMgt.BLOBExport(BLOBRef,FileName,TRUE);
            //     //END ELSE BEGIN   //Testing
            //     ExportFileName := FileName;
            // END;
        EXIT(ExportFileName)
    end;

    procedure Delete(var DocumentRec: Record "Land Document Attachment"): Boolean
    begin
        IF RecInDB(DocumentRec) THEN
            EXIT(FALSE)
        ELSE
            EXIT(true);//ERASE(GetFileName(DocumentRec)
    end;

    procedure Copy(var FromDocRec: Record "Land Document Attachment"; var ToDocRec: Record "Land Document Attachment"): Boolean
    var
        istream: InStream;
        ostream: OutStream;
    begin
        IF RecInDB(FromDocRec) THEN BEGIN
            ToDocRec.Content.CREATEOUTSTREAM(ostream);
            FromDocRec.Content.CREATEINSTREAM(istream);
            // Transfer content and other info
            EXIT(COPYSTREAM(ostream, istream));
        END ELSE BEGIN
            ToDocRec.GUID := CREATEGUID();
            //EXIT(COPY(GetFileName(FromDocRec), GetFileName(ToDocRec)));
        END;
    end;

    procedure LockByUsr(var DocumentRec: Record "Land Document Attachment"): Boolean
    begin
        IF DocumentRec."In Use By" <> '' THEN BEGIN
            IF Tries < 2 THEN BEGIN
                MESSAGE(W_INUSE, DocumentRec."No.", DocumentRec."In Use By");
                Tries := Tries + 1;
                EXIT(FALSE);
            END;

            IF NOT CONFIRM(W_INUSE_OVRRIDE) THEN
                EXIT(FALSE);
        END;

        // Set lock markers and modify database
        IF USERID() = '' THEN
            DocumentRec."In Use By" := '*'
        ELSE
            DocumentRec."In Use By" := USERID();

        DocumentRec.MODIFY(TRUE);
        EXIT(TRUE);
    end;

    procedure UnlockByUsr(var DocumentRec: Record "Land Document Attachment"): Boolean
    var
        OK: Boolean;
        Document: Record "Land Document Attachment";
    begin
        OK := FALSE;

        // Re-Read document to absorb any changes made (external db removals?)
        IF Document.GET(DocumentRec."Document Type", DocumentRec."No.") THEN BEGIN
            Document."In Use By" := '';
            OK := Document.MODIFY(TRUE);
        END ELSE
            MESSAGE(E_DOCLOST + '(' + FORMAT(DocumentRec."Document Type") + ' - ' + DocumentRec."No." + ')-[u]', Document."No.");

        EXIT(OK);
    end;

    procedure ImportAltDoc(var DocumentRec: Record "Land Document Attachment"): Boolean
    var
        OK: Boolean;
        Document: Record "Land Document Attachment";
        ImportName: Text[260];
    begin
        OK := FALSE;
        // Re-Read document to absorb any changes made (external file removals?)
        IF Document.GET(DocumentRec."Document Type", DocumentRec."No.") THEN BEGIN

            // IF EXISTS(Document.GetAltFileName) THEN BEGIN
            //     // Import Document into blob
            //     ImportName := Import(Document, UPPERCASE(Document.GetAltFileName)); // Import altered document
            //     OK := ImportName <> '';
            //     IF OK THEN
            //         OK := Document.MODIFY(TRUE);
            // END ELSE
            //     MESSAGE(E_FILELOST + ' (Document.GetAltFileName)', Document.GetAltFileName);

        END ELSE
            MESSAGE(E_DOCLOST + '(' + FORMAT(DocumentRec."Document Type") + ' - ' + DocumentRec."No." + ')-[i]', Document."No.");

        EXIT(OK);
    end;
}

