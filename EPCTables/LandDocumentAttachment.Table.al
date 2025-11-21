table 60730 "Land Document Attachment"
{
    // 200623 Check file exist with Name and same type

    Caption = 'Land Document Attachment';
    DataCaptionFields = Description;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Document,Template';
            OptionMembers = Document,Template;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Table No."; Integer)
        {
            BlankZero = true;
            Caption = 'Table No.';
            TableRelation = AllObjWithCaption."Object ID";//  "Table Information"."Table No.";

            trigger OnLookup()
            var
            //TableListRec: Record 2000000028;
            begin
                //IF "Document Type" = "Document Type"::Template THEN BEGIN
                //  SetupNew();
                //  TableListForm.LOOKUPMODE := TRUE;
                //  IF TableListForm.RUNMODAL = ACTION::LookupOK THEN BEGIN
                //    TableListForm.GETRECORD(TableListRec);
                //    "Table No." := TableListRec."Table No.";
                //    CALCFIELDS("Table Name");
                //TmplField.RefreshTemplate(Rec, TRUE);
                //  END;
                //END;
            end;

            trigger OnValidate()
            begin
                IF "Document Type" = "Document Type"::Template THEN BEGIN
                    SetupNew();
                    CALCFIELDS("Table Name");
                    //TmplField.RefreshTemplate(Rec, TRUE);
                END;
            end;
        }
        field(5; "Reference No. 1"; Code[20])
        {
            Caption = 'Reference No. 1';
            TableRelation = IF ("Table No." = CONST(13)) "Salesperson/Purchaser".Code
            ELSE IF ("Table No." = CONST(15)) "G/L Account"."No."
            ELSE IF ("Table No." = CONST(18)) Customer."No."
            ELSE IF ("Table No." = CONST(23)) Vendor."No."
            ELSE IF ("Table No." = CONST(27)) Item."No."
            ELSE IF ("Table No." = CONST(156)) Resource."No."
            ELSE IF ("Table No." = CONST(167)) Job."No."
            ELSE IF ("Table No." = CONST(84)) "Acc. Schedule Name".Name
            ELSE IF ("Table No." = CONST(270)) "Bank Account"."No."
            ELSE IF ("Table No." = CONST(295)) "Reminder Header"."No."
            ELSE IF ("Table No." = CONST(302)) "Finance Charge Memo Header"."No."
            ELSE IF ("Table No." = CONST(5050)) Contact."No."
            ELSE IF ("Table No." = CONST(5071)) Campaign."No."
            ELSE IF ("Table No." = CONST(5076)) "Segment Header"."No."
            ELSE IF ("Table No." = CONST(5200)) Employee."No."
            ELSE IF ("Table No." = CONST(5600)) "Fixed Asset"."No."
            ELSE IF ("Table No." = CONST(5628)) Insurance."No."
            ELSE IF ("Table No." = CONST(5718)) "Nonstock Item"."Entry No."
            ELSE IF ("Table No." = CONST(5740)) "Transfer Header"."No.";
        }
        field(6; "Reference No. 2"; Code[20])
        {
            Caption = 'Reference No.2';
            Editable = false;
        }
        field(7; "Reference No. 3"; Code[20])
        {
            Caption = 'Reference No.3';
        }
        field(10; "Table Name"; Text[30])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE("Object ID" = FIELD("Table No.")));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Template Name"; Code[20])
        {
            Caption = 'Template Name';
            TableRelation = Document."No." WHERE("Document Type" = CONST(Template));
        }
        field(12; Description; Text[50])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                Description := CONVERTSTR(Description, '!"#£@Ÿ$%&/(){[]}=?+`Ù|^~õ*:.;,\<>', '_________________________________');
            end;
        }
        field(13; Content; BLOB)
        {
            Caption = 'Content';
        }
        field(14; "File Extension"; Text[10])
        {
            Caption = 'File Extension';
        }
        field(15; "In Use By"; Code[50])
        {
            Caption = 'In Use By';
            Editable = true;
            //TableRelation = Table2000000002.Field1;
            //ValidateTableRelation = false;
        }
        field(16; Special; Boolean)
        {
            Caption = 'Special';

            trigger OnValidate()
            begin
                //TmplField.RefreshTemplate(Rec, TRUE);
            end;
        }
        field(17; "Document Import Date"; Date)
        {
            Editable = false;
        }
        field(18; "Modified Date"; Date)
        {
            Caption = 'Modified Date';
            Editable = false;
        }
        field(19; "Modified By"; Code[50])
        {
            Caption = 'Modified By';
            Editable = false;
        }
        field(20; Category; Code[10])
        {
            Caption = 'Category';
            TableRelation = "Document Category";
        }
        field(21; Indexed; Boolean)
        {
            Caption = 'Indexed';
        }
        field(22; GUID; Guid)
        {
        }
        field(23; "Line No."; Integer)
        {
            BlankZero = true;
            TableRelation = AllObjWithCaption."Object ID";// "Table Information"."Table No.";

            trigger OnLookup()
            var
            //TableListRec: Record 2000000028;
            begin
            end;
        }
        field(24; "Import Path"; Text[250])
        {
        }
        field(25; "Description 2"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Document Import By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "User Setup";
        }
        field(27; "Document Import Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(28; Applicable; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Attachment Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Term Sheet Signing,Receipt of Title Documents,Mapping of Land record in Google Map,Tonch/Naksha,Completion of TSR,Technical Layout/ Saleable area Feasibility,Aggrement of Sale,Conversion of land,AD[S&LR) Report,Freezing of Layout,Gift Deed between  parties,Execution of Mortgage Deed,Receipt of TLP,Escrow Bank A/c for RERA,Application for RERA,Sanction of RERA,Sale deed copy';
            OptionMembers = " ","Term Sheet Signing","Receipt of Title Documents","Mapping of Land record in Google Map","Tonch/Naksha","Completion of TSR","Technical Layout/ Saleable area Feasibility","Aggrement of Sale","Conversion of land","AD[S&LR) Report","Freezing of Layout","Gift Deed between  parties","Execution of Mortgage Deed","Receipt of TLP","Escrow Bank A/c for RERA","Application for RERA","Sanction of RERA","Sale deed copy";
        }
        field(30; "Document Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Document Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        /*IF "Document Type" = "Document Type"::Template THEN BEGIN
          TmplField.SETRANGE(TmplField."Template Name", "No.");
          TmplField.DELETEALL;
        END;*/
        DocAccMgt.Delete(Rec);

    end;

    trigger OnInsert()
    begin
        SetupNew;
        "Document Import Date" := TODAY;
        "Document Import By" := USERID;
        "Document Import Time" := TIME;
    end;

    trigger OnModify()
    begin
        "Modified Date" := TODAY;
        "Modified By" := USERID;
    end;

    var
        DocumentSetup: Record "Document Setup";
        I_EXPORT: Label 'Export Document';
        I_IMPORT: Label 'Import Document';
        E_NOCONTENT: Label 'No document.';
        E_NONAME: Label 'No name.';
        W_OVERWRITE: Label 'Overwrite existing document?';
        W_ISINUSE: Label 'The document is in use by %1.';
        DocAccMgt: Report "Land Doc Access Management";
        Doc: Record "Land Document Attachment";
        FileNametext1: Text;
        NewFileName: Text;
        FileManagement: Codeunit "File Management";
        BBGSetups: Record "BBG Setups";

    local procedure GetMailAdr(): Text[80]
    var
        CustomerRec: Record Customer;
        VendorRec: Record Vendor;
        ContactRec: Record Contact;
        EmployeeRec: Record Employee;
        BankRec: Record "Bank Account";
    begin
        IF "Reference No. 1" = '' THEN
            EXIT('');

        CASE "Table No." OF
            18:
                IF CustomerRec.GET("Reference No. 1") THEN
                    EXIT(CustomerRec."E-Mail");

            23:
                IF VendorRec.GET("Reference No. 1") THEN
                    EXIT(VendorRec."E-Mail");

            5200:
                IF EmployeeRec.GET("Reference No. 1") THEN
                    EXIT(EmployeeRec."E-Mail");

            5050:
                IF ContactRec.GET("Reference No. 1") THEN
                    EXIT(ContactRec."E-Mail");

            270:
                IF BankRec.GET("Reference No. 1") THEN
                    EXIT(BankRec."E-Mail");

        END;
    end;


    procedure GetFileName(): Text[260]
    begin
        DocumentSetup.GET;
        //EXIT(DocumentSetup.GetWorkPath() + USERID + '_' + "No." + '.' + "File Extension");
        EXIT(DocumentSetup.GetWorkPath() + GetUserId + '_' + "No." + '.' + "File Extension");
    end;


    procedure GetAltFileName(): Text[260]
    begin
        DocumentSetup.GET;
        //EXIT(DocumentSetup.GetWorkPath() + USERID + '_' + "No." + '_' + 'alt' + '.' + "File Extension");
        EXIT(DocumentSetup.GetWorkPath() + GetUserId + '_' + "No." + '_' + 'alt' + '.' + "File Extension");
    end;


    procedure IsInUse(ShowDialog: Boolean): Boolean
    var
        OK: Boolean;
        DocumentRec: Record "Land Document Attachment";
    begin
        OK := DocumentRec.GET("Document Type", "No.");
        IF NOT OK THEN
            EXIT(FALSE);

        OK := DocumentRec."In Use By" = '';
        IF (NOT OK) AND ShowDialog THEN
            MESSAGE(W_ISINUSE, DocumentRec."In Use By");
        EXIT(NOT OK);
    end;


    procedure HasContent(ShowDialog: Boolean): Boolean
    var
        OK: Boolean;
        DocumentRec: Record "Land Document Attachment";
    begin
        OK := FALSE;
        IF "No." <> '' THEN
            IF DocumentRec.GET("Document Type", "Document No.", "Document Line No.", "Line No.") THEN
                OK := DocAccMgt.HasValue(Rec);

        IF (NOT OK) AND ShowDialog THEN
            MESSAGE(E_NOCONTENT);

        EXIT(OK);
    end;


    procedure SetupNew()
    var
        NoSerieMgnt: Codeunit NoSeriesManagement;
    begin
        IF ("No." = '') THEN
            CASE "Document Type" OF
                "Document Type"::Document:
                    BEGIN
                        DocumentSetup.GET;
                        DocumentSetup.TESTFIELD("Document Nos.");
                        NoSerieMgnt.InitSeries(DocumentSetup."Document Nos.", '', 0D, "No.", DocumentSetup."Document Nos.");
                    END;
                "Document Type"::Template:
                    ERROR(E_NONAME);
            END;
    end;


    procedure View(var DocMgt: Report "Land Document Management"): Boolean
    var
        OK: Boolean;
    begin
        IF HasContent(TRUE) THEN
            OK := DocMgt.View(Rec);
        EXIT(OK);
    end;


    procedure Edit(var DocMgt: Report "Land Document Management"): Boolean
    var
        OK: Boolean;
    begin
        IF HasContent(TRUE) THEN
            OK := DocMgt.Edit(Rec);
        EXIT(OK);
    end;


    procedure Import(FileName: Text[260]; ShowDialog: Boolean): Boolean
    var
        ImportName: Text[260];
        v_Document: Record "Land Document Attachment";
    begin
        IF IsInUse(TRUE) THEN
            EXIT;

        DocumentSetup.GET;

        // Initialize ImportPath if empty
        IF FileName = '' THEN BEGIN
            IF NOT ShowDialog THEN
                EXIT(FALSE);
            FileName := DocumentSetup.GetImportPath();
            //IF ShowDialog THEN
            //FileName := FileName + '*';
        END;

        // Already a document?
        IF HasContent(FALSE) THEN
            IF ShowDialog THEN
                IF NOT DIALOG.CONFIRM(W_OVERWRITE, FALSE) THEN
                    EXIT(FALSE);

        // Import document
        //IF ShowDialog THEN BEGIN
        //  FileName := CommonDlgMgt.OpenFile(I_IMPORT, FileName, 4, '*.*', 0);
        //  IF STRPOS(FileName, '*') > 0 THEN EXIT(FALSE); // Cancel
        //END;

        ImportName := DocAccMgt.Import(Rec, FileName);
        //MESSAGE(FORMAT(Content.HASVALUE));
        // Set fields in record
        IF ImportName <> '' THEN BEGIN
            "File Extension" := DocumentSetup.ExtractFileExt(ImportName);
            Description := DocumentSetup.ExtractFileName(ImportName, 50);
            //ALLE-WPIL
            "Import Path" := DocumentSetup."Import Path";
            //200623 Check file exist with Name and same type-------Start
            IF "Document No." <> '' THEN BEGIN
                v_Document.RESET;
                v_Document.SETRANGE("Document No.", "Document No.");
                v_Document.SETRANGE(Description, Description);
                v_Document.SETRANGE("File Extension", "File Extension");
                v_Document.SETRANGE("Import Path", "Import Path");
                IF v_Document.FINDFIRST THEN
                    IF CONFIRM('File already exists.Do you want to replace the file.') THEN BEGIN
                    END ELSE
                        ERROR('Not Import');
            END;
            //200623 Check file exist with Name and same type--------END
        END;

        EXIT(ImportName <> '');
    end;


    procedure Export(FileName: Text[260]; ShowDialog: Boolean): Boolean
    var
        ExportName: Text[260];
        FileMgt: Codeunit "File Management";
    begin
        DocumentSetup.GET;
        ExportName := '';

        IF FileName = '' THEN
            FileName := DocumentSetup.GetExportPath() + Description + '.' + "File Extension";

        IF ShowDialog THEN;
        //     FileName := FileMgt.SaveFileDialog(I_EXPORT, FileName, '(*.' + "File Extension" + ')|*.' + "File Extension");
        // FileManagement.CopyClientFile(DocumentSetup."Import Path" + Description + '.' + "File Extension", FileName, TRUE);

        EXIT(ExportName <> '');
    end;


    procedure Navigate()
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc(TODAY, "Document No.");
        NavigateForm.RUN;
    end;


    procedure Clone()
    var
        DocumentRec: Record "Land Document Attachment";
    begin
        //IF IsInUse(TRUE) THEN
        //  EXIT;

        IF HasContent(TRUE) THEN BEGIN
            DocumentRec.COPY(Rec);

            DocumentRec."In Use By" := '';
            DocumentRec."Modified Date" := 0D;
            DocumentRec."Modified By" := '';

            IF "Document Type" = "Document Type"::Document THEN BEGIN
                DocumentRec."No." := '';
                DocumentRec.INSERT(TRUE);
            END ELSE BEGIN
                DocumentRec."No." := INCSTR("No.");
                IF DocumentRec."No." = '' THEN
                    DocumentRec."No." := "No." + '01';
                WHILE NOT DocumentRec.INSERT DO
                    DocumentRec."No." := INCSTR(DocumentRec."No.");

                // Clone template fields as well
                //IF DocumentRec."Table No." <> 0 THEN
                //TmplField.CloneTemplate("No.",DocumentRec."No.");
            END;
            IF NOT DocAccMgt.RecInDB(Rec) THEN
                DocAccMgt.Copy(Rec, DocumentRec);
        END;
    end;


    procedure Send()
    var
        FileName: Text[250];
        Mail: Codeunit Mail;
    begin
        IF IsInUse(TRUE) THEN
            EXIT;

        DocumentSetup.GET;
        FileName := DocumentSetup.GetWorkPath() + Description + '.' + "File Extension";

        // Export document and create mails with this attachment
        IF Export(FileName, FALSE) THEN BEGIN
            //Mail.NewMessage(GetMailAdr,'',Description,'',FileName, TRUE);
            // Mail.NewMessage(GetMailAdr, '', '', Description, Description, FileName, TRUE);
            // FILE.ERASE(FileName);
        END;
    end;


    procedure Print(): Boolean
    var
        OSIntf: Report "OS Interface Routines";
        Path: Text[250];
        Name: Text[250];
    begin
        IF IsInUse(TRUE) THEN
            EXIT;

        DocumentSetup.GET;
        Path := DocumentSetup.GetWorkPath();
        Name := Description + '.' + "File Extension";

        // Export document and create mails with this attachment
        IF Export(Path + Name, FALSE) THEN BEGIN
            OSIntf.Print(Path, Name);
            //  FILE.ERASE(Path + Name);
        END;
    end;


    procedure GetUserId(): Code[50]
    var
        Position: Integer;
        User: Code[50];
    begin
        User := USERID;
        Position := STRPOS(User, '\');
        IF Position > 0 THEN
            REPEAT
                User := COPYSTR(USERID, Position + 1, STRLEN(User) - Position);
                Position := STRPOS(User, '\');
            UNTIL Position = 0;
        EXIT(User);
    end;


    procedure ImportProjectDoc(FileName: Text[260]; ShowDialog: Boolean): Boolean
    var
        ImportName: Text[260];
    begin
        IF IsInUse(TRUE) THEN
            EXIT;

        BBGSetups.GET;
        DocumentSetup.GET;
        IF FileName = '' THEN BEGIN
            IF NOT ShowDialog THEN
                EXIT(FALSE);
            FileName := BBGSetups."Project Doc Path Save in NAV";//DocumentSetup.GetImportPath();
        END;

        IF HasContent(FALSE) THEN
            IF ShowDialog THEN
                IF NOT DIALOG.CONFIRM(W_OVERWRITE, FALSE) THEN
                    EXIT(FALSE);
        ImportName := DocAccMgt.Import(Rec, FileName);
        IF ImportName <> '' THEN BEGIN
            "File Extension" := DocumentSetup.ExtractFileExt(ImportName);
            Description := DocumentSetup.ExtractFileName(ImportName, 50);
            "Import Path" := BBGSetups."Project Doc Path Save in NAV";  ///DocumentSetup."Import Path";
        END;

        EXIT(ImportName <> '');
    end;


    procedure ExportProjectDoc(FileName: Text[260]; ShowDialog: Boolean): Boolean
    var
        ExportName: Text[260];
        FileMgt: Codeunit "File Management";
    begin
        DocumentSetup.GET;
        BBGSetups.GET;
        ExportName := '';

        IF FileName = '' THEN
            FileName := BBGSetups."Project Doc Path Save in NAV" + Description + '.' + "File Extension";
        //FileName := DocumentSetup.GetExportPath() + Description + '.' + "File Extension";

        IF ShowDialog THEN;
        //     FileName := FileMgt.SaveFileDialog(I_EXPORT, FileName, '(*.' + "File Extension" + ')|*.' + "File Extension");
        // //FileManagement.CopyClientFile(DocumentSetup."Import Path"+ Description + '.' + "File Extension",FileName,TRUE);
        // FileManagement.CopyClientFile(BBGSetups."Project Doc Path Save in NAV" + Description + '.' + "File Extension", FileName, TRUE);

        EXIT(ExportName <> '');
    end;


    procedure SetDocumentlineNo(P_LineNo: Integer)
    begin
    end;
}

