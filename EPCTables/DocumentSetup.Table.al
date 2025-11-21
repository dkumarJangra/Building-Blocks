table 97773 "Document Setup"
{
    // *** Matriks Doc Version 3 ***
    // By Tim Ahrentl¢v for Matriks A/S.
    // Visit www.matriks.com for news and updates.
    // 
    // 3.05 (2004.12.01):
    // New functions, ExtractFilePath() and ExtractFileNameAndExt().
    // 
    // 3.04 (2004.05.12):
    // File fields and related functions extended to 250 chars.
    // 
    // 3.03 (2004.03.17):
    // ExtractFileName extended with a truncate size parameter.
    // ExtractFileName - ToPos calculated correctly even if no file type extension.
    // StrLastDotPos calculation fixed.
    // 
    // 3.02 (2004.20.01):
    // StrLastDotPos improved to handle wierd filenames.
    // Bugfix in ExtractLastExt. (>1 instead of > 0).
    // 
    // 3.01 (2003.12.02):
    // New local function StrLastDotPos
    // ExtractFileExt and ExtractFileName improved to handle additional dots in path/filename.

    Caption = 'Document Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
        }
        field(2; "Document Nos."; Code[10])
        {
            Caption = 'Document Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(3; "Import Path"; Text[250])
        {
            Caption = 'Importpath';
            DataClassification = ToBeClassified;

            trigger OnLookup()
            begin
                //"Import Path" := FileMgt.BrowseForFolderDialog('Select Import Path', "Import Path", FALSE);
                //Code not supported in BC AllE-AM
            end;

            trigger OnValidate()
            begin
                SetBackSlash("Import Path")
            end;
        }
        field(4; "Export Path"; Text[250])
        {
            Caption = 'Exportpath';
            DataClassification = ToBeClassified;

            trigger OnLookup()
            begin
                //"Export Path" := FileMgt.BrowseForFolderDialog('Select Export Path', "Export Path", FALSE);
                //Code not supported in BC AllE-AM
            end;

            trigger OnValidate()
            begin
                SetBackSlash("Export Path")
            end;
        }
        field(5; "Working Folder Path"; Text[250])
        {
            Caption = 'Workpath';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                SetBackSlash("Working Folder Path")
            end;
        }
        field(6; "Journal Import Path"; Text[250])
        {
            Caption = 'Journal Importpath';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                SetBackSlash("Journal Import Path")
            end;
        }
        field(7; "Journal Backup Path"; Text[250])
        {
            Caption = 'Journal Backuppath';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                SetBackSlash("Journal Backup Path")
            end;
        }
        field(10; "Skip Size (Bytes)"; Integer)
        {
            Caption = 'Skip Size (Bytes)';
            DataClassification = ToBeClassified;
        }
        field(11; "Enable FTP"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'EPTS';
        }
        field(12; "FTP Address"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'EPTS';

            trigger OnValidate()
            begin
                SetFrontSlash("FTP Address");
            end;
        }
        field(13; "FTP Folder"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'EPTS';

            trigger OnValidate()
            begin
                SetFrontSlash("FTP Folder");
            end;
        }
        field(14; "User ID"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'EPTS';
        }
        field(15; Password; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'EPTS';
        }
        field(16; "Approval Audit File Path"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Audit File Upload Path"; Text[150])
        {
            DataClassification = ToBeClassified;
            Description = '270923 Approval Workflow';
        }

        field(18; "Audit File Upload Path(BC)"; Text[150])
        {
            DataClassification = ToBeClassified;
            Description = '270923 Approval Workflow';
        }

        field(19; "Import Path (BC)"; Text[250])
        {
            Caption = 'Import Path (BC)';
            DataClassification = ToBeClassified;


        }

    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Skip Size (Bytes)" := 60089500;
    end;

    var
        FileMgt: Codeunit "File Management";

    local procedure SetBackSlash(var Value: Text[250])
    begin
        IF Value <> '' THEN
            IF Value[STRLEN(Value)] <> '\' THEN
                Value := Value + '\';
    end;


    procedure GetImportPath(): Text[250]
    begin
        IF "Import Path" = '' THEN
            EXIT(GetTmpPath)
        ELSE
            EXIT("Import Path");
    end;


    procedure GetExportPath(): Text[250]
    begin
        IF "Export Path" = '' THEN
            EXIT(GetTmpPath)
        ELSE
            EXIT("Export Path");
    end;


    procedure GetJournalImportPath(): Text[250]
    begin
        IF "Journal Import Path" = '' THEN
            EXIT(GetTmpPath)
        ELSE
            EXIT("Journal Import Path");
    end;


    procedure GetJournalBackupPath(): Text[250]
    begin
        IF "Journal Backup Path" = '' THEN
            EXIT(GetTmpPath)
        ELSE
            EXIT("Journal Backup Path");
    end;


    procedure GetWorkPath(): Text[250]
    begin
        IF "Working Folder Path" = '' THEN
            EXIT(GetTmpPath)
        ELSE
            EXIT("Working Folder Path");
    end;

    local procedure GetTmpPath() result: Text[250]
    begin
        //result := ENVIRON('TEMP');
        result := '';//TEMPORARYPATH;
        IF result = '' THEN
            result := 'c:'; // Panic
        SetBackSlash(result);
        EXIT(result);
    end;

    local procedure StrLastDotPos(var Filename: Text[250]): Integer
    var
        ToPos: Integer;
        FromPos: Integer;
        Flag: Boolean;
    begin
        Flag := TRUE;
        FromPos := STRLEN(Filename);
        WHILE (FromPos > 1) AND Flag DO BEGIN
            IF Filename[FromPos] = '.' THEN
                Flag := FALSE
            ELSE
                FromPos := FromPos - 1;
        END;

        IF FromPos = 1 THEN
            FromPos := 0;

        EXIT(FromPos);
    end;


    procedure ExtractFileExt(FileName: Text[250]): Text[10]
    var
        FromPos: Integer;
    begin
        FromPos := StrLastDotPos(FileName);
        IF FromPos > 1 THEN
            EXIT(COPYSTR(FileName, FromPos + 1))
        ELSE
            EXIT('');
    end;


    procedure ExtractFileName(AbsFileName: Text[250]; TruncSize: Integer): Text[250]
    var
        ToPos: Integer;
        FromPos: Integer;
        Flag: Boolean;
    begin
        Flag := TRUE;
        ToPos := StrLastDotPos(AbsFileName);
        IF ToPos = 0 THEN
            ToPos := STRLEN(AbsFileName) + 1;
        FromPos := ToPos - 1;

        WHILE (FromPos > 1) AND Flag DO BEGIN
            IF (AbsFileName[FromPos - 1] = '\') THEN
                Flag := FALSE
            ELSE
                FromPos := FromPos - 1;
        END;

        // Truncate if filename to long
        IF ((ToPos - FromPos) > TruncSize) AND (TruncSize > 0) THEN
            ToPos := FromPos + TruncSize;

        EXIT(COPYSTR(AbsFileName, FromPos, ToPos - FromPos));
    end;


    procedure ExtractFileNameAndExt(AbsFileName: Text[250]; TruncSize: Integer): Text[250]
    var
        ToPos: Integer;
        FromPos: Integer;
        Flag: Boolean;
    begin
        Flag := TRUE;
        ToPos := STRLEN(AbsFileName) + 1;
        FromPos := ToPos - 1;

        WHILE (FromPos > 1) AND Flag DO BEGIN
            IF (AbsFileName[FromPos - 1] = '\') THEN
                Flag := FALSE
            ELSE
                FromPos := FromPos - 1;
        END;

        // Truncate if filename to long
        IF ((ToPos - FromPos) > TruncSize) AND (TruncSize > 0) THEN
            ToPos := FromPos + TruncSize;

        EXIT(COPYSTR(AbsFileName, FromPos, ToPos - FromPos));
    end;


    procedure ExtractFilePath(AbsFileName: Text[250]; TruncSize: Integer): Text[250]
    var
        ToPos: Integer;
        FromPos: Integer;
        Flag: Boolean;
    begin
        Flag := TRUE;
        ToPos := STRLEN(AbsFileName);

        WHILE (ToPos > 1) AND Flag DO BEGIN
            IF (AbsFileName[ToPos] = '\') THEN
                Flag := FALSE
            ELSE
                ToPos := ToPos - 1;
        END;

        // Truncate if filename to long
        IF (ToPos > TruncSize) AND (TruncSize > 0) THEN
            ToPos := TruncSize;

        EXIT(COPYSTR(AbsFileName, 1, ToPos));
    end;


    procedure SupportAtMatriks()
    var
        CompanyInfo: Record "Company Information";
        SupportUrl: Text[256];
    begin
        IF CompanyInfo.GET() THEN BEGIN
            SupportUrl := UPPERCASE(SERIALNUMBER + ';' + CompanyInfo.Name + ';' + CompanyInfo."Home Page" + ';' + CompanyInfo."E-Mail" + ';'
          );
            SupportUrl := CONVERTSTR(SupportUrl, '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZ -@.&;', 'ZYXVUTSRQPONMLKJIHGFEDCBA9876543210,+-*!_');
            HYPERLINK('http://www.matriks.com/index.html?support=' + SupportUrl);
        END;
    end;

    local procedure SetFrontSlash(var Value: Text[250])
    begin
        IF Value <> '' THEN
            IF Value[STRLEN(Value)] <> '/' THEN
                Value := Value + '/';
    end;
}

