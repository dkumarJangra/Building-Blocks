codeunit 50002 "Associate Web Service_2"
{
    Permissions = TableData "Associate Eligibility Staging" = rim,
                  TableData "Sales Project Wise Setup Hdr" = rim;
    TableNo = "Associate Eligibility Staging";

    trigger OnRun()
    begin
        AssociateEleg.RESET;
        AssociateEleg.SETRANGE("Entry No.", EntryNo_2);
        AssociateEleg.SETRANGE(AssociateEleg."Publish Data", FALSE);
        IF AssociateEleg.FINDSET THEN
            REPEAT
                CallGetPNRWebservice(AssociateEleg."Batch Code", AssociateEleg."Associate Name", AssociateEleg."E-Mail",
                AssociateEleg."Mob. No.", AssociateEleg."Associate Code", AssociateEleg.Amount);
            UNTIL AssociateEleg.NEXT = 0;
        COMMIT;
    end;

    var
        LastName: Text[30];
        EntryNo_2: Integer;
        BatchNos: Code[20];
        AssociateEleg: Record "Associate Eligibility Staging";
        WebError: Record "Associate Eligibility on Web";
        WebError_1: Record "Associate Eligibility on Web";
        //XMLDocument: DotNet XmlDocument;
        MyHTMLFile: File;
        CommAmt: Decimal;
        Request: Text;


    procedure CallGetPNRWebservice(PCCCode: Code[20]; AssociateName: Text[60]; EmailID: Text[100]; MobileNo: Text[30]; AssociateCode: Code[20]; CommissionAmount: Decimal)
    var
        // WebServiceURL: Label '/TravelWebServices/Amadeus.asmx';
        // ContentType: Label 'text/xml; charset=UTF-8';
        SoapAction: Label 'Peoplecart.WCFService/IMemberService/updateKPICommissionData';
        // Text001: Label '<?xml version="1.0" encoding="UTF-8"?>';
        // Text002: Label '<Envelope  xmlns="http://schemas.xmlsoap.org/soap/envelope/">';
        // Text003: Label '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">';
        // WebRequest: DotNet HttpWebRequest;
        // WebResponse: DotNet HttpWebResponse;
        // StreamWriter: DotNet StreamWriter;
        TxtCompanyName: Text;

        Result: Text;
        xmloutstream: OutStream;
        ResponseText1: Text;
        startposInt: Integer;
        EndPosInt: Integer;
        NewString: Text;
        Jtext: Text;
        Jtext2: Text;
        AmountLength: Integer;
        CustPaymentAmt: Integer;

        Request: HttpRequestMessage;
        Content: HttpContent;
        RespMsg: Text;
        Client: HttpClient;
        Headers: HttpHeaders;
        contentHeaders: HttpHeaders;
        Contant: HttpContent;
        JsonResponse: Text;
        RequestUrl: Text;
        TextString: text;
        HttpWebResponse: HttpResponseMessage;
        Bytes: text;
        cu: Codeunit Encoding;
        JArray: JsonArray;
        CustObject: JsonObject;
        JsonObject: JsonObject;
        JsonData_1: Text;
        ShiptoObject: JsonObject;
        JsonData: Text;
        DotNetEncodeing: Codeunit DotNet_Encoding;
        DotNetArray: Codeunit DotNet_Array;
        DotNetArrayBytes: Codeunit DotNet_Array;
        ArrayJSONManagement: Codeunit "JSON Management";
        JSONManagement: Codeunit "JSON Management";
        ObjectJSONManagement: Codeunit "JSON Management";
        i: Integer;
        CodeText: Text;
        CustomerJsonObject: Text;
        JsonArrayText: Text;
        JsonObjectText: Text;

        HtmlEmailBody: text;
        FindResponse: Boolean;
        JObject: jsonobject;

    begin

        WebError.INIT;
        WebError."Entry No." := AssociateEleg."Entry No.";
        WebError."Associate Code" := AssociateEleg."Associate Code";
        WebError."Commission_TA Amount" := AssociateEleg.Amount;
        WebError.Date := TODAY;
        WebError.INSERT;


        Headers := Client.DefaultRequestHeaders();
        //TextString := STRSUBSTNO(Post_FinalJSON);
        //Bytes := cu.Convert(1200, 28591, TextString);
        RequestUrl := 'https://bbgindia.peoplecart.com/WebServices/MemberService.svc';
        Request.Method := 'POST';

        //Request.Timeout := 1000 * 60 * 10;

        HtmlEmailBody := '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">';
        HtmlEmailBody += '<Body>';
        HtmlEmailBody += '<updateKPICommissionData xmlns="Peoplecart.WCFService">';
        HtmlEmailBody += '<A_strTokenKey>' + 'K7pV7aC0-7038-KYGU-7048-M6pV7aC0UbKe' + '</A_strTokenKey>';

        HtmlEmailBody += '<A_strSubDomainName>' + 'bbgindia' + '</A_strSubDomainName>';
        HtmlEmailBody += '<A_xmlMemberDetails>';
        HtmlEmailBody += '<![CDATA[<root>';
        HtmlEmailBody += '<row>';
        HtmlEmailBody += '<FirstName>' + AssociateName + '</FirstName>';
        HtmlEmailBody += '<LastName>' + '' + '</LastName>';
        HtmlEmailBody += '<EmailId>' + '' + '</EmailId>';
        HtmlEmailBody += '<MobileNo>' + '' + '</MobileNo>';
        HtmlEmailBody += '<EmployeeId>' + AssociateCode + '</EmployeeId>';
        HtmlEmailBody += '<CommissionPoints>' + DELCHR(FORMAT(CommissionAmount), '=', ',') + '</CommissionPoints>';
        HtmlEmailBody += '</row>';
        HtmlEmailBody += '</root>]]>';
        HtmlEmailBody += '</A_xmlMemberDetails>';
        HtmlEmailBody += '</updateKPICommissionData>';
        HtmlEmailBody += '</Body>';
        HtmlEmailBody += '</Envelope>';

        Content.WriteFrom(HtmlEmailBody);
        content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'text/xml; charset=utf-8');
        Headers.add('SOAPAction', SoapAction);
        Client.Post(RequestUrl, Content, HttpWebResponse);
        if HttpWebResponse.IsSuccessStatusCode then begin
            HttpWebResponse.Content.ReadAs(ResponseText1);
            WebError."Response Value" := 'Success';
        End Else begin
            HttpWebResponse.Content.ReadAs(ResponseText1);
            WebError."Response Value" := COPYSTR(ResponseText1, 1, 200)
        end;
        WebError.MODIFY;

        // WebRequest := WebRequest.Create('https://bbgindia.peoplecart.com/WebServices/MemberService.svc');
        // WebRequest.UseDefaultCredentials := FALSE; //TRUE;
        // WebRequest.Method := 'POST';
        // WebRequest.Timeout := 1000 * 60 * 10;
        // WebRequest.ContentType := 'text/xml; charset=utf-8';
        // WebRequest.PreAuthenticate := FALSE; //TRUE;
        // WebRequest.Headers.Add('SOAPAction', SoapAction);
        // StreamWriter := StreamWriter.StreamWriter(WebRequest.GetRequestStream);

        // StreamWriter.Write('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">');



        // StreamWriter.Write('<Body>');
        // StreamWriter.Write('<updateKPICommissionData xmlns="Peoplecart.WCFService">');
        // StreamWriter.Write('<A_strTokenKey>' + 'K7pV7aC0-7038-KYGU-7048-M6pV7aC0UbKe' + '</A_strTokenKey>');
        // StreamWriter.Write('<A_strSubDomainName>' + 'bbgindia' + '</A_strSubDomainName>');
        // StreamWriter.Write('<A_xmlMemberDetails>');
        // StreamWriter.Write('<![CDATA[<root>');
        // StreamWriter.Write('<row>');
        // StreamWriter.Write('<FirstName>' + AssociateName + '</FirstName>');
        // StreamWriter.Write('<LastName>' + '' + '</LastName>');
        // StreamWriter.Write('<EmailId>' + '' + '</EmailId>');
        // StreamWriter.Write('<MobileNo>' + '' + '</MobileNo>');
        // StreamWriter.Write('<EmployeeId>' + AssociateCode + '</EmployeeId>');
        // StreamWriter.Write('<CommissionPoints>' + DELCHR(FORMAT(CommissionAmount), '=', ',') + '</CommissionPoints>');
        // StreamWriter.Write('</row>');
        // StreamWriter.Write('</root>]]>');
        // StreamWriter.Write('</A_xmlMemberDetails>');
        // StreamWriter.Write('</updateKPICommissionData>');
        // StreamWriter.Write('</Body>');
        // StreamWriter.Write('</Envelope>');
        // StreamWriter.Close();

        // WebResponse := WebRequest.GetResponse();
        // IF WebResponse.StatusCode <> 200 THEN
        //     WebError."Response Value" := COPYSTR(WebResponse.StatusDescription, 1, 200)
        // ELSE
        //     WebError."Response Value" := 'Success';
        // WebError.MODIFY;
        // XMLDocument := XMLDocument.XmlDocument();
        // XMLDocument.Load(WebResponse.GetResponseStream);

        //NAV 2016 ----END;
    end;


    procedure Setfilteres(EntryNo_1: Integer)
    begin
        EntryNo_2 := EntryNo_1;
    end;
}

