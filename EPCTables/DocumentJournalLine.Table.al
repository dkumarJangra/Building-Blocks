table 97774 "Document Journal Line"
{
    // *** Matriks Doc Ver. 3 ***
    // By Tim Ahrentl¢v for Matriks A/S.
    // Visit www.matriks.com for news and updates.
    // 
    // 3.06 (2005.02.04):
    // ViewDocument changes to use OS Interface Routines.
    // 
    // 3.05 (2004.05.12):
    // File field extended to 250 chars.
    // 
    // 3.04 (2004.03.17):
    // GetImportFilesNames function implement ExtractFilename truncate size parameter.
    // 
    // 3.03 (2004.20.01):
    // Bugfix: Files without extention is now simply ignored. Does not generate error.
    // Improvement: Filesroutines in DocumentSetup used for consistency.
    // 
    // 3.02 (2003.09.22):
    // Bugfix: DocumentRec."Reference No. 2" corrected to DocumentRec."Reference No. 1" in Post Documents.
    // 
    // 3.01 (2003.08.08):
    // Bugfix: Danish text constant for I_PROCDOC was missing and has been added.

    Caption = 'Document Journal Line';

    fields
    {
        field(1; "Import No."; Integer)
        {
            Caption = 'Import No.';
            Editable = false;
        }
        field(2; "Table No."; Integer)
        {
            BlankZero = true;
            Caption = 'Table No.';
            TableRelation = AllObjWithCaption."Object ID";// "Table Information"."Table No.";
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF ("Table No." = CONST(13)) "Salesperson/Purchaser"
            ELSE IF ("Table No." = CONST(15)) "G/L Account"
            ELSE IF ("Table No." = CONST(18)) Customer
            ELSE IF ("Table No." = CONST(23)) Vendor
            ELSE IF ("Table No." = CONST(27)) Item
            ELSE IF ("Table No." = CONST(156)) Resource
            ELSE IF ("Table No." = CONST(167)) Job
            ELSE IF ("Table No." = CONST(270)) "Bank Account"
            ELSE IF ("Table No." = CONST(5050)) Contact
            ELSE IF ("Table No." = CONST(5200)) Employee
            ELSE IF ("Table No." = CONST(5600)) "Fixed Asset"
            ELSE IF ("Table No." = CONST(5628)) Insurance;
        }
        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(5; "Table Name"; Text[30])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object ID" = FIELD("Table No.")));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; Description; Text[50])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(8; "File Name"; Text[250])
        {
            Caption = 'File Name';
            Editable = false;
        }
        field(9; "File Date"; Date)
        {
            Caption = 'File Date';
            ClosingDates = true;
            Editable = false;
        }
        field(10; "File Size"; Integer)
        {
            Caption = 'File Size';
            Editable = false;
        }
        field(11; Ignore; Boolean)
        {
            Caption = 'Ignore';
        }
    }

    keys
    {
        key(Key1; "Import No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        //Files: Record File;// 2000000022;
        DocumentSetup: Record "Document Setup";
        //MatriksDocStorage: Report 97755;
        NoOfRecords: Integer;
        LineCount: Integer;
        I_FETCHDOC: Label 'Fetching documents      @1@@@@@@@@@@@@@';
        I_CHECKDOC: Label 'Checking documents      @1@@@@@@@@@@@@@';
        I_POSTDOC: Label 'Posting documents       @2@@@@@@@@@@@@@';
        I_PROCDOC: Label 'Processing documents    @3@@@@@@@@@@@@@';
        E_NODOC: Label 'No documents to post.';


    procedure Initialize()
    begin
        DocumentSetup.GET;
    end;


    procedure GetImportFileNames()
    var
        DocumentJnlLine: Record "Document Journal Line";
        Window: Dialog;
        ImportNo: Integer;
    begin
        Initialize;

        DocumentJnlLine.DELETEALL;
        ImportNo := 10000;
        //Files.SETRANGE(Path, DocumentSetup.GetJournalImportPath);

        //NoOfRecords := Files.COUNT;
        Window.OPEN(I_FETCHDOC);

        LineCount := 0;
        // IF Files.FIND('-') THEN BEGIN
        //     REPEAT
        //         IF Files."Is a file" THEN BEGIN
        //             IF DocumentSetup.ExtractFileExt(Files.Name) <> '' THEN BEGIN
        //                 DocumentJnlLine.Description := DocumentSetup.ExtractFileName(Files.Name, 50);
        //                 DocumentJnlLine."Import No." := ImportNo;
        //                 DocumentJnlLine."File Name" := Files.Name;
        //                 DocumentJnlLine."File Date" := Files.Date;
        //                 DocumentJnlLine."File Size" := Files.Size;
        //                 DocumentJnlLine.Ignore := Files.Size > DocumentSetup."Skip Size (Bytes)";
        //                 DocumentJnlLine.INSERT(TRUE);
        //                 ImportNo := ImportNo + 10000;
        //                 LineCount := LineCount + 1;
        //                 Window.UPDATE(1, ROUND(LineCount / NoOfRecords * 10000, 1));
        //             END;
        //         END;
        //     UNTIL Files.NEXT = 0;
        // END;
        Window.CLOSE;
    end;


    procedure ViewDocument()
    var
        OSIntf: Report "OS Interface Routines";
    begin
        Initialize;
        TESTFIELD(Ignore, FALSE);
        //IF FILE.EXISTS(DocumentSetup.GetJournalImportPath + "File Name") THEN
        OSIntf.RunByFileName(DocumentSetup.GetJournalImportPath + "File Name");
    end;


    procedure PostDocuments()
    var
        DocumentRec: Record Document;
        DocumentJnlLine: Record "Document Journal Line";
        Window: Dialog;
        Erased: Boolean;
        JnlImportPath: Text[128];
        JnlBackupPath: Text[128];
    begin
        Initialize;

        JnlImportPath := DocumentSetup.GetJournalImportPath;
        JnlBackupPath := DocumentSetup."Journal Backup Path";

        DocumentJnlLine.SETRANGE(Ignore, FALSE);

        NoOfRecords := DocumentJnlLine.COUNT;
        IF NoOfRecords = 0 THEN
            ERROR(E_NODOC);

        Window.OPEN(I_CHECKDOC + '\' + I_POSTDOC + '\' + I_PROCDOC + '\');

        // Checking documents
        LineCount := 0;
        IF DocumentJnlLine.FIND('-') THEN
            REPEAT
                IF DocumentJnlLine."Document No." = '' THEN BEGIN
                    DocumentJnlLine.TESTFIELD("Table No.");
                    DocumentJnlLine.TESTFIELD("No.");
                END;

                ///FILE.EXISTS(JnlImportPath + DocumentJnlLine."File Name");
                LineCount := LineCount + 1;
                Window.UPDATE(1, ROUND(LineCount / NoOfRecords * 10000, 1));
            UNTIL DocumentJnlLine.NEXT = 0;

        // Posting documents
        LineCount := 0;
        IF DocumentJnlLine.FIND('-') THEN
            REPEAT
                CLEAR(DocumentRec);

                // IF DocumentRec.Import(JnlImportPath + DocumentJnlLine."File Name", FALSE) THEN BEGIN
                //     DocumentRec."Table No." := DocumentJnlLine."Table No.";
                //     DocumentRec."Document No." := DocumentJnlLine."Document No.";
                //     DocumentRec."Reference No. 1" := DocumentJnlLine."No.";
                //     DocumentRec."Document Type" := DocumentRec."Document Type"::Document;
                //     DocumentRec.INSERT(TRUE);
                // END;

                LineCount := LineCount + 1;
                Window.UPDATE(2, ROUND(LineCount / NoOfRecords * 10000, 1));
            UNTIL DocumentJnlLine.NEXT = 0;


        // Processing original document files
        LineCount := 0;
        NoOfRecords := DocumentJnlLine.COUNT;
        IF DocumentJnlLine.FIND('-') THEN
            REPEAT
                IF JnlImportPath <> JnlBackupPath THEN BEGIN
                    // FILE.COPY(JnlImportPath + DocumentJnlLine."File Name", JnlBackupPath + DocumentJnlLine."File Name");
                    // FILE.ERASE(JnlImportPath + DocumentJnlLine."File Name");
                END;
                LineCount := LineCount + 1;
                Window.UPDATE(3, ROUND(LineCount / NoOfRecords * 10000, 1));
            UNTIL DocumentJnlLine.NEXT = 0;

        // Finishing up
        Window.CLOSE;
        DocumentJnlLine.DELETEALL;
    end;
}

