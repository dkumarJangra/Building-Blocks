
codeunit 70020 "File Transfer"
{
    trigger OnRun()
    begin

    end;

    procedure CallAPI_SendfileDocPostOther(): TExt[100]
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Headers: HttpHeaders;
        RespMsg: Text;
        JObject: JsonObject;
        RequestJson: text;
        FileINStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        Base64String: text;
        RequestUrl: text;
        filename: Text;
        json: text;
        TextBuffer2: Text;
    begin
        UploadIntoStream('', '', '', filename, FileINStream);
        Base64String := Base64Convert.ToBase64(FileINStream);
        Message(Base64String);
        JObject.Add('filename', filename);
        JObject.Add('filecontent', Base64String);
        if JObject.WriteTo(RequestJson) then begin
            PowerAutomatPathDetail.RESET;
            PowerAutomatPathDetail.SetRange("Folder Name", PowerAutomatPathDetail."Folder Name"::DocPostOther);
            If PowerAutomatPathDetail.FindFirst() THEN BEGIN
                RequestUrl := PowerAutomatPathDetail.path; //'https://prod-08.centralindia.logic.azure.com:443/workflows/3888d7ddf1ed4b44b4194a2136ee1ddc/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=X7cwQevPo425EQaUHuGVmyCPupaFiVhSJA5RfkSsm50';
                Request.Method := 'POST';
                Request.SetRequestUri(RequestUrl);
                Content.WriteFrom(RequestJson);
                content.GetHeaders(Headers);
                Headers.Remove('Content-Type');
                Headers.Add('Content-Type', 'application/json');
                Client.Post(RequestUrl, Content, Response);
                if (Response.IsSuccessStatusCode) then begin
                    Response.Content.ReadAs(RespMsg);
                    //Message((RespMsg));
                    Message('Sucess');
                    Exit(filename);
                end else begin
                    Response.Content.ReadAs(RespMsg);
                    Message('Error');
                end;
            end;
        END ELSE
            Error('Path not found');
    end;

    procedure CallAPI_SendfileAuditFiles(): Text[100]
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Headers: HttpHeaders;
        RespMsg: Text;
        JObject: JsonObject;
        RequestJson: text;
        FileINStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        Base64String: text;
        RequestUrl: text;
        filename: Text;
        json: text;
        TextBuffer2: Text;
    begin
        UploadIntoStream('', '', '', filename, FileINStream);
        Base64String := Base64Convert.ToBase64(FileINStream);
        Message(Base64String);
        JObject.Add('filename', filename);
        JObject.Add('filecontent', Base64String);
        if JObject.WriteTo(RequestJson) then begin
            PowerAutomatPathDetail.RESET;
            PowerAutomatPathDetail.SetRange("Folder Name", PowerAutomatPathDetail."Folder Name"::"Audit File");
            If PowerAutomatPathDetail.FindFirst() THEN BEGIN
                RequestUrl := PowerAutomatPathDetail.path; //'https://prod-08.centralindia.logic.azure.com:443/workflows/3888d7ddf1ed4b44b4194a2136ee1ddc/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=X7cwQevPo425EQaUHuGVmyCPupaFiVhSJA5RfkSsm50';
                Request.Method := 'POST';
                Request.SetRequestUri(RequestUrl);
                Content.WriteFrom(RequestJson);
                content.GetHeaders(Headers);
                Headers.Remove('Content-Type');
                Headers.Add('Content-Type', 'application/json');
                Client.Post(RequestUrl, Content, Response);
                if (Response.IsSuccessStatusCode) then begin
                    Response.Content.ReadAs(RespMsg);
                    //Message((RespMsg));
                    Message('Sucess');
                    EXit(filename);
                end else begin
                    Response.Content.ReadAs(RespMsg);
                    Message('Error');
                end;
            end;
        END ELSE
            Error('Path not found');
    end;

    procedure CallAPI_SendfileDocAttachment(): Text[100]
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Headers: HttpHeaders;
        RespMsg: Text;
        JObject: JsonObject;
        RequestJson: text;
        FileINStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        Base64String: text;
        RequestUrl: text;
        filename: Text;
        json: text;
        TextBuffer2: Text;
    begin
        UploadIntoStream('', '', '', filename, FileINStream);
        Base64String := Base64Convert.ToBase64(FileINStream);

        JObject.Add('filename', filename);
        JObject.Add('filecontent', Base64String);
        if JObject.WriteTo(RequestJson) then begin
            PowerAutomatPathDetail.RESET;
            PowerAutomatPathDetail.SetRange("Folder Name", PowerAutomatPathDetail."Folder Name"::"Document Attchment");
            If PowerAutomatPathDetail.FindFirst() THEN BEGIN
                RequestUrl := PowerAutomatPathDetail.path; //'https://prod-08.centralindia.logic.azure.com:443/workflows/3888d7ddf1ed4b44b4194a2136ee1ddc/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=X7cwQevPo425EQaUHuGVmyCPupaFiVhSJA5RfkSsm50';
                Request.Method := 'POST';
                Request.SetRequestUri(RequestUrl);
                Content.WriteFrom(RequestJson);
                content.GetHeaders(Headers);
                Headers.Remove('Content-Type');
                Headers.Add('Content-Type', 'application/json');
                Client.Post(RequestUrl, Content, Response);
                if (Response.IsSuccessStatusCode) then begin
                    Response.Content.ReadAs(RespMsg);
                    //Message((RespMsg));
                    Message('Sucess');
                    Exit(filename);

                end else begin
                    Response.Content.ReadAs(RespMsg);
                    Message('Error');
                end;
            end;
        END ELSE
            Error('Path not found');
    end;

    procedure CallAPI_SendfileProjectDocuments(): text[100]
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Headers: HttpHeaders;
        RespMsg: Text;
        JObject: JsonObject;
        RequestJson: text;
        FileINStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        Base64String: text;
        RequestUrl: text;
        filename: Text;
        json: text;
        TextBuffer2: Text;
    begin
        UploadIntoStream('', '', '', filename, FileINStream);
        Base64String := Base64Convert.ToBase64(FileINStream);
        Message(Base64String);
        JObject.Add('filename', filename);
        JObject.Add('filecontent', Base64String);
        if JObject.WriteTo(RequestJson) then begin
            PowerAutomatPathDetail.RESET;
            PowerAutomatPathDetail.SetRange("Folder Name", PowerAutomatPathDetail."Folder Name"::"Project Documents");
            If PowerAutomatPathDetail.FindFirst() THEN BEGIN
                RequestUrl := PowerAutomatPathDetail.path; //'https://prod-08.centralindia.logic.azure.com:443/workflows/3888d7ddf1ed4b44b4194a2136ee1ddc/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=X7cwQevPo425EQaUHuGVmyCPupaFiVhSJA5RfkSsm50';
                Request.Method := 'POST';
                Request.SetRequestUri(RequestUrl);
                Content.WriteFrom(RequestJson);
                content.GetHeaders(Headers);
                Headers.Remove('Content-Type');
                Headers.Add('Content-Type', 'application/json');
                Client.Post(RequestUrl, Content, Response);
                if (Response.IsSuccessStatusCode) then begin
                    Response.Content.ReadAs(RespMsg);

                    //Message((RespMsg));
                    Message('Sucess');
                    Exit(filename);
                end else begin
                    Response.Content.ReadAs(RespMsg);
                    Message('Error');
                end;
            end;
        END ELSE
            Error('Path not found');
    end;

    procedure CallAPI_SendfileDocAttachJagriti(): Text[100]
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Headers: HttpHeaders;
        RespMsg: Text;
        JObject: JsonObject;
        RequestJson: text;
        FileINStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        Base64Convert: Codeunit "Base64 Convert";
        Base64String: text;
        RequestUrl: text;
        filename: Text;
        json: text;
        TextBuffer2: Text;
    begin
        UploadIntoStream('', '', '', filename, FileINStream);
        Base64String := Base64Convert.ToBase64(FileINStream);

        JObject.Add('filename', filename);
        JObject.Add('filecontent', Base64String);
        if JObject.WriteTo(RequestJson) then begin
            PowerAutomatPathDetail.RESET;
            PowerAutomatPathDetail.SetRange("Folder Name", PowerAutomatPathDetail."Folder Name"::"Document Jagriti");
            If PowerAutomatPathDetail.FindFirst() THEN BEGIN
                RequestUrl := PowerAutomatPathDetail.path; //'https://prod-08.centralindia.logic.azure.com:443/workflows/3888d7ddf1ed4b44b4194a2136ee1ddc/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=X7cwQevPo425EQaUHuGVmyCPupaFiVhSJA5RfkSsm50';
                Request.Method := 'POST';
                Request.SetRequestUri(RequestUrl);
                Content.WriteFrom(RequestJson);
                content.GetHeaders(Headers);
                Headers.Remove('Content-Type');
                Headers.Add('Content-Type', 'application/json');
                Client.Post(RequestUrl, Content, Response);
                if (Response.IsSuccessStatusCode) then begin
                    Response.Content.ReadAs(RespMsg);
                    //Message((RespMsg));
                    Message('Sucess');
                    Exit(filename);

                end else begin
                    Response.Content.ReadAs(RespMsg);
                    Message('Error');
                end;
            end;
        END ELSE
            Error('Path not found');
    end;


    procedure ExportFile(var DocumentRec: Record Document; FileName: Text[260]; FilePath: Text[250]): Text[260]
    var
        ExportFileName: Text[260];
        FileMgt: Codeunit "File Management";
        RequestUrl: text;
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Headers: HttpHeaders;
        RespMsg: Text;
        fileNameL: Text[150];
        tempblob: Codeunit "Temp Blob";
        fileManagment: Codeunit "File Management";
        ReqInstream: InStream;
        ReqOutstream: OutStream;
    begin
        ExportFileName := '';

        // ALLE AKUL START 020125  
        IF DocumentRec."File Extension" = '' then
            RequestUrl := FilePath + FORMAT(DocumentRec.Description)   //'https://epc.bbgindia.com:44389/Uploaded/DocPostOther/'
        else
            RequestUrl := FilePath + FORMAT(DocumentRec.Description) + '.' + DocumentRec."File Extension";


        Request.Method := 'GET';
        Request.SetRequestUri(RequestUrl);
        Request.GetHeaders(Headers);
        Headers.Add('Accept', 'application/json');
        Client.send(Request, Response);
        if (Response.IsSuccessStatusCode) then begin
            Response.Content.ReadAs(ReqInstream);
            tempblob.CreateOutStream(ReqOutstream);
            CopyStream(ReqOutstream, ReqInstream);
            IF DocumentRec."File Extension" = '' then
                fileNameL := DocumentRec.Description
            else
                fileNameL := DocumentRec.Description + '.' + DocumentRec."File Extension";
            fileManagment.BLOBExport(tempblob, fileNameL, true);
        end else begin
            Response.Content.ReadAs(RespMsg);
        end;
        EXIT(ExportFileName)
        // ALLE AKUL STOP 020125  
    end;

    procedure JagratiExportFile(FilePath: Text[250]; FileName: Text[260]): Text[260]
    var
        ExportFileName: Text[260];
        FileMgt: Codeunit "File Management";
        RequestUrl: text;
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Headers: HttpHeaders;
        RespMsg: Text;
        fileNameL: Text[50];
        tempblob: Codeunit "Temp Blob";
        fileManagment: Codeunit "File Management";
        ReqInstream: InStream;
        ReqOutstream: OutStream;
    begin
        ExportFileName := '';

        // ALLE AKUL START 020125  

        //RequestUrl := 'https://epc.bbgindia.com:44389/Uploaded/DocPostOther/' + FORMAT(FileName);
        RequestUrl := FilePath + FORMAT(FileName);
        Request.Method := 'GET';
        Request.SetRequestUri(RequestUrl);
        Request.GetHeaders(Headers);
        Headers.Add('Accept', 'application/json');
        Client.send(Request, Response);
        if (Response.IsSuccessStatusCode) then begin
            Response.Content.ReadAs(ReqInstream);
            tempblob.CreateOutStream(ReqOutstream);
            CopyStream(ReqOutstream, ReqInstream);

            fileNameL := FileName;
            fileManagment.BLOBExport(tempblob, fileNameL, true);
        end else begin
            Response.Content.ReadAs(RespMsg);
        end;
        EXIT(ExportFileName)
        // ALLE AKUL STOP 020125  
    end;

    procedure ExportFileLandProject(var DocumentRec: Record "Land Document Attachment"; FileName: Text[260]; FilePath: Text[250]): Text[260]
    var
        ExportFileName: Text[260];
        FileMgt: Codeunit "File Management";
        RequestUrl: text;
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Headers: HttpHeaders;
        RespMsg: Text;
        fileNameL: Text[50];
        tempblob: Codeunit "Temp Blob";
        fileManagment: Codeunit "File Management";
        ReqInstream: InStream;
        ReqOutstream: OutStream;
    begin
        ExportFileName := '';

        // ALLE AKUL START 020125  
        IF DocumentRec."File Extension" = '' then
            RequestUrl := FilePath + FORMAT(DocumentRec.Description)   //'https://epc.bbgindia.com:44389/Uploaded/DocPostOther/'
        else
            RequestUrl := FilePath + FORMAT(DocumentRec.Description) + '.' + DocumentRec."File Extension";


        Request.Method := 'GET';
        Request.SetRequestUri(RequestUrl);
        Request.GetHeaders(Headers);
        Headers.Add('Accept', 'application/json');
        Client.send(Request, Response);
        if (Response.IsSuccessStatusCode) then begin
            Response.Content.ReadAs(ReqInstream);
            tempblob.CreateOutStream(ReqOutstream);
            CopyStream(ReqOutstream, ReqInstream);
            IF DocumentRec."File Extension" = '' then
                fileNameL := DocumentRec.Description
            else
                fileNameL := DocumentRec.Description + '.' + DocumentRec."File Extension";
            fileManagment.BLOBExport(tempblob, fileNameL, true);
        end else begin
            Response.Content.ReadAs(RespMsg);
        end;
        EXIT(ExportFileName)
        // ALLE AKUL STOP 020125  
    end;

    procedure ExportFileOthers(var FilePath: Text[200]; FileName: Text[260]; FileName2: Text[260]): Text[260]
    var
        ExportFileName: Text[260];
        FileMgt: Codeunit "File Management";
        RequestUrl: text;
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Content: HttpContent;
        Headers: HttpHeaders;
        RespMsg: Text;
        fileNameL: Text[50];
        tempblob: Codeunit "Temp Blob";
        fileManagment: Codeunit "File Management";
        ReqInstream: InStream;
        ReqOutstream: OutStream;
    begin
        ExportFileName := '';

        // ALLE AKUL START 020125  

        RequestUrl := FilePath + FileName;


        Request.Method := 'GET';
        Request.SetRequestUri(RequestUrl);
        Request.GetHeaders(Headers);
        Headers.Add('Accept', 'application/json');
        Client.send(Request, Response);
        if (Response.IsSuccessStatusCode) then begin
            Response.Content.ReadAs(ReqInstream);
            tempblob.CreateOutStream(ReqOutstream);
            CopyStream(ReqOutstream, ReqInstream);

            fileNameL := FileName2;
            fileManagment.BLOBExport(tempblob, fileNameL, true);
        end else begin
            Response.Content.ReadAs(RespMsg);
        end;
        EXIT(ExportFileName)
        // ALLE AKUL STOP 020125  
    end;

    var
        myInt: Integer;
        EventCategory: Enum EventCategory;
        PowerAutomatPathDetail: Record "Power Automat Path Details";
}