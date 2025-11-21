page 60725 "Document file Upload"
{
    Caption = 'Documents';
    DelayedInsert = true;
    PageType = List;
    PopulateAllFields = true;
    SourceTable = Document;
    SourceTableView = SORTING("Document Type", "No.")
                      ORDER(Ascending)
                      WHERE("Document Type" = CONST(Document));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field("Import Path"; Rec."Import Path")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("File Extension"; Rec."File Extension")
                {
                    Editable = false;
                }
                field("Description 2"; Rec."Description 2")
                {
                }
                field("Document Import Date"; Rec."Document Import Date")
                {
                }
                field("Document Import By"; Rec."Document Import By")
                {
                }
                field("Document Import Time"; Rec."Document Import Time")
                {
                }
            }
        }
    }

    actions
    {

        area(processing)
        {
            group("Fu&nkce")
            {
                Caption = 'F&unction';
                action("&Import")
                {
                    Caption = 'Import';
                    Ellipsis = true;
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    //Visible = false;
                    trigger OnAction()
                    var
                        OK: Boolean;
                        FileTransferCU: codeunit "File Transfer";
                    begin
                        UserSetup.GET(USERID);
                        UserSetup.TESTFIELD("Import Document");
                        Clear(FileTransferCU);
                        FileTransferCU.CallAPI_SendfileAuditFiles();

                        //  Rec.Import('', TRUE, TRUE);
                        CurrPage.UPDATE(TRUE);
                    end;
                }
                action(UploadFile)
                {
                    ApplicationArea = all;
                    Caption = 'Upload File';
                    visible = false;

                    trigger OnAction()
                    var
                        client: HttpClient;
                        requestMessage: HttpRequestMessage;
                        responseMessage: HttpResponseMessage;
                        content: HttpContent;
                        headers: HttpHeaders;
                        tb: TextBuilder;
                        base64: Codeunit "Base64 Convert";
                        ContentToBeUploaded: InStream;
                        responseText: Text;
                        filename: Text[100];
                        Msg: Text[100];
                        json: Text;
                    begin
                        // Set up the message content for multipart/form-data
                        filename := '';
                        UploadIntoStream('', '', '', filename, ContentToBeUploaded);
                        json := base64.ToBase64(ContentToBeUploaded);
                        tb.AppendLine('--123456789');
                        tb.AppendLine(StrSubstNo('Content-Disposition: form-data; name="file"; filename="%1"', filename));
                        tb.AppendLine('Content-Type: application/json');
                        tb.AppendLine(); // Empty line required to separate the header information from payload
                        tb.AppendLine(json);
                        tb.AppendLine('--123456789--');

                        // Write the content into HttpContent
                        // (Note: This call will set some header information)
                        //content.WriteFrom('3');
                        //content.WriteFrom(UserId);
                        content.WriteFrom(tb.ToText());

                        // Get Content Headers
                        content.GetHeaders(headers);

                        // update the content header information and define the boundary    
                        if headers.Contains('Content-Type') then headers.Remove('Content-Type');
                        headers.Add('Content-Type', 'multipart/form-data; boundary="123456789"');

                        // Setup the URL
                        requestMessage.SetRequestUri('https://epc.bbgindia.com:44389/api/File/DocPostCRMVisit');

                        // Setup the HTTP Verb
                        requestMessage.Method := 'POST';

                        // Add some request headers like:
                        requestMessage.GetHeaders(headers);
                        headers.Add('Authorization', 'Basic base64-user-password');

                        // Set the content
                        requestMessage.Content := content;

                        // Send the message
                        client.Send(requestMessage, responseMessage);

                        // Return the Status Code
                        // Message(format(responseMessage.HttpStatusCode()));
                        responseMessage.Content.ReadAs(Msg);
                        Message(Msg);
                    end;
                }
                action("&Export")
                {
                    Caption = 'Export';
                    Ellipsis = true;
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        OK: Boolean;
                        DocSetup: Record "Document Setup";
                    begin
                        //Rec.Export('', TRUE, TRUE);
                        //040325 Code added Start
                        DocSetup.GET;
                        DocSetup.TestField("Audit File Upload Path(BC)");
                        Clear(FileTransferCu);
                        FileTransferCu.ExportFile(Rec, '', DocSetup."Audit File Upload Path(BC)");
                        //040325 Code added End
                    end;
                }
                action(ShowDocument)
                {
                    Promoted = true;

                    trigger OnAction()
                    var

                    begin
                        DocumentSetup.GET;
                        DocumentSetup.TESTFIELD("Audit File Upload Path(BC)");   //040325 Added new code
                        Clear(FileTransferCu);  //040325 Added new code
                        FileTransferCu.ExportFile(Rec, '', DocumentSetup."Audit File Upload Path(BC)");  //040325 Added new code

                        //HYPERLINK(DocumentSetup."Audit File Upload Path" + Rec.Description + '.' + Rec."File Extension");
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        BBGOnAfterGetCurrRecord;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        EXIT(NOT Rec.IsInUse(TRUE));
    end;

    trigger OnModifyRecord(): Boolean
    begin
        EXIT(NOT Rec.IsInUse(TRUE));
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        BBGOnAfterGetCurrRecord;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        EXIT(DocMgt.Finish(FALSE));
    end;

    var
        DocMgt: Report "Document Management";
        DocAccMgt: Report "Document Access Management";
        UserSetup: Record "User Setup";
        DocumentSetup: Record "Document Setup";
        FileTransferCu: Codeunit "File Transfer";

    local procedure BBGOnAfterGetCurrRecord()
    begin
        xRec := Rec;
        CurrPage.EDITABLE := Rec."In Use By" = '';
    end;

    local procedure OnTimer()
    begin
        IF DocMgt.Finish(TRUE) THEN
            DocMgt.Finish(FALSE);
    end;
}

