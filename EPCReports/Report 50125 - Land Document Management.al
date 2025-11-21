report 50125 "Land Document Management"
{
    // version Done

    DefaultLayout = RDLC;
    RDLCLayout = './Land Document Management.rdl';
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
        ApplNo: Integer;
        ViewMode: Boolean;
        DocAccMgt: Report "Land Doc Access Management";
        AppMgt: Report "Land Appl. Management Proxy";
        Document: Record "Land Document Attachment";
        W_CLOSEEDITOR: Label 'Close document editor before continuing.';
        W_CLOSEVIEWER: Label 'Close document viewer before continuing.';
        W_ClOSE_OVRRIDE: Label 'Are you sure you want to close even if this will result in changes being lost?';
        I_EDITMODE: Label 'Editing - changes will be saved';
        I_VIEWMODE: Label 'Viewing - changes will be discarded';

    procedure Finish(Silent: Boolean): Boolean
    var
        OkToClose: Boolean;
        ForceClose: Boolean;
        NoError: Boolean;
        FileDate: Date;
        FileTime: Time;
        FileDateTime: DateTime;
    begin
        IF Document."No." = '' THEN EXIT(TRUE);

        // Close automationservers?
        IF ApplNo > 0 THEN
            OkToClose := AppMgt.Close(ApplNo)
        ELSE BEGIN
            // Close non-automation servers?
            IF NOT Silent THEN
                OkToClose := TRUE
            ELSE BEGIN
                // IF FILE.GETSTAMP(Document.GetFileName(), FileDate, FileTime) THEN BEGIN
                //     FileDateTime := CREATEDATETIME(FileDate, FileTime);
                //     // Dont try to delete before 60 sek. has passed
                //     IF ((CURRENTDATETIME - FileDateTime) / 1000) > 60 THEN
                //         OkToClose := TRUE;
                // END ELSE
                //     OkToClose := FALSE;
            END;

        END;

        // Remove document file(s)
        IF OkToClose THEN BEGIN
            // IF EXISTS(Document.GetFileName()) THEN
            //     OkToClose := FILE.ERASE(Document.GetFileName());
            // IF EXISTS(Document.GetAltFileName()) THEN
            //     NoError := FILE.ERASE(Document.GetAltFileName());
        END;

        // If this is only a silent and fast statuscheck, if noclose, then no further actions
        IF Silent THEN EXIT(OkToClose);

        // Force close
        ForceClose := FALSE;
        IF (NOT OkToClose) AND (Tries > 2) THEN
            ForceClose := CONFIRM(W_ClOSE_OVRRIDE);

        // Increment
        Tries := Tries + 1;

        // Close applications first
        IF (NOT OkToClose) AND (NOT ForceClose) THEN BEGIN
            IF ViewMode THEN
                MESSAGE(W_CLOSEVIEWER)
            ELSE
                MESSAGE(W_CLOSEEDITOR);
            EXIT(FALSE);
        END;

        // Unlock document
        IF NOT ViewMode THEN
            DocAccMgt.UnlockByUsr(Document);

        // Clean up
        CLEAR(Document);
        ApplNo := 0;
        Tries := 0;

        EXIT(TRUE);
    end;

    procedure Edit(var DocumentRec: Record "Land Document Attachment"): Boolean
    begin
        // Save old document first if any
        IF NOT Finish(FALSE) THEN
            EXIT(FALSE);

        IF NOT Document.GET(DocumentRec."Document Type", DocumentRec."No.") THEN
            EXIT(FALSE);

        // Office application IS Editable
        ApplNo := AppMgt.IsEditAppl(Document."File Extension");
        ViewMode := ApplNo = 0;

        // Skip to pure viewonly if document does not support edit.
        IF NOT ViewMode THEN BEGIN
            // Lock document
            IF NOT DocAccMgt.LockByUsr(Document) THEN
                EXIT(FALSE);
        END;

        // Show Document
        EXIT(Load());
    end;

    procedure View(var DocumentRec: Record "Land Document Attachment"): Boolean
    begin
        // Save old document first if any
        IF NOT Finish(FALSE) THEN
            EXIT(FALSE);

        IF NOT Document.GET(DocumentRec."Document Type", DocumentRec."No.") THEN
            EXIT(FALSE);

        // Office application IS Editable
        ApplNo := AppMgt.IsEditAppl(Document."File Extension");
        ViewMode := TRUE;

        // Show Document
        EXIT(Load());
    end;

    local procedure Load(): Boolean
    var
        OSIntf: Report "OS Interface Routines";
        OK: Boolean;
        Caption: Text[128];
        FileName: Text[260];
    begin
        FileName := Document.GetFileName();
        OK := FALSE;

        IF ViewMode THEN
            Caption := I_VIEWMODE
        ELSE
            Caption := I_EDITMODE;

        IF DocAccMgt.HasValue(Document) THEN
            IF DocAccMgt.Export(Document, FileName) <> '' THEN BEGIN
                IF ApplNo > 0 THEN
                    AppMgt.Load(ApplNo, Document, Caption, ViewMode)
                ELSE
                    OSIntf.RunByFileName(FileName);
                OK := TRUE;
            END;
        EXIT(OK);
    end;

    procedure Replace(var DocumentRec: Record "Land Document Attachment"): Boolean
    var
        i: Integer;
        Value: Text[250];
        TableRecord: RecordRef;
        TableField: FieldRef;
        KeyField: KeyRef;
        DocAccMgt: Report "Land Doc Access Management";
        TemplateFields: Record "Template Field";
        IntValue: Integer;
        StrValue: Code[20];
        Names: array[100] of Text[250];
        Values: array[100] of Text[250];
    begin
    end;

    local procedure LookupCode(TableNo: Integer; FieldNo: Integer; Value: Code[20]): Text[50]
    var
        i: Integer;
        Desc: Text[50];
        TableRecord: RecordRef;
        TableField: FieldRef;
        KeyField: KeyRef;
    begin
    end;

    procedure InsertText(Value: Text[128])
    begin
    end;
}

