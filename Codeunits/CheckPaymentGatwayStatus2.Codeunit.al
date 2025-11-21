codeunit 50005 "Check Payment Gatway Status_2"
{


    TableNo = "Payment transaction Details";

    trigger OnRun()
    var
        PaymentStatus: Text;
        UnitMaster: Record "Unit Master";
    begin
        PaymenttransactionDetails.RESET;
        PaymenttransactionDetails.SETRANGE("Entry No.", EntryNo_2);
        PaymenttransactionDetails.SETRANGE("Payment From", PaymenttransactionDetails."Payment From"::" ");
        PaymenttransactionDetails.SETFILTER("Payment Server Status", '<>%1', 'paid');  //270525 Added new 'PAID'
        IF PaymenttransactionDetails.FINDSET THEN
            REPEAT
                PmtTransDetails.RESET;
                PmtTransDetails.SETRANGE("Entry No.", PaymenttransactionDetails."Entry No.");
                IF PmtTransDetails.FINDFIRST THEN BEGIN
                    PaymentStatus := '';
                    If PmtTransDetails."Payment From" = PmtTransDetails."Payment From"::" " then
                        PaymentStatus := CallPaymentOrderStatus(PmtTransDetails."Unique Payment Order ID");
                    PmtTransDetails."Payment Server Status" := PaymentStatus;
                    PmtTransDetails."Transaction Status" := 'Success';
                    PmtTransDetails."Payment Server Status Date" := TODAY;
                    PmtTransDetails."Payment Server Status Time" := TIME;
                    PmtTransDetails.MODIFY;
                    IF (PaymentStatus = 'paid') OR (PaymentStatus = 'PAID') THEN BEGIN
                        UnitMaster.RESET;
                        IF UnitMaster.GET(PaymenttransactionDetails."Plot ID") THEN BEGIN
                            IF UnitMaster.Status <> UnitMaster.Status::Booked THEN BEGIN
                                UnitMaster."Web Portal Status" := UnitMaster."Web Portal Status"::Booked;
                                UnitMaster.Status := UnitMaster.Status::Booked;
                                UnitMaster.MODIFY;
                                COMMIT;
                                WebAppService.UpdateUnitStatus(UnitMaster);  //210624
                            END;
                        END;
                    END;
                END;
            UNTIL PaymenttransactionDetails.NEXT = 0;
    end;

    var
        PaymenttransactionDetails: Record "Payment transaction Details";
        PmtTransDetails: Record "Payment transaction Details";
        EntryNo_2: Integer;
        WebAppService: Codeunit "Web App Service";


    procedure CallPaymentOrderStatus(vPmtOrderId: Text): Text
    var
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

        Headers := Client.DefaultRequestHeaders();
        //TextString := STRSUBSTNO(Post_FinalJSON);
        //Bytes := cu.Convert(1200, 28591, TextString);
        //RequestUrl := 'http://52.172.215.206:44419/RazorPay.asmx';  //10112025
        RequestUrl := 'https://iospmt.bbgindia.com:44421/RazorPay.asmx';  //10112025

        Request.Method := 'POST';

        //Request.Timeout := 1000 * 60 * 10;
        HtmlEmailBody := '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">';
        HtmlEmailBody += '<Body>';

        HtmlEmailBody += '<CallFatchSingleOrder xmlns="http://tempuri.org/">';
        // HtmlEmailBody += '<row>';
        HtmlEmailBody += '<OrderNo>' + vPmtOrderId + '</OrderNo>';

        HtmlEmailBody += '</CallFatchSingleOrder>';
        HtmlEmailBody += '</Body>';
        HtmlEmailBody += '</Envelope>';

        //Message('%1', HtmlEmailBody);
        //Content.WriteFrom(Bytes);
        Content.WriteFrom(HtmlEmailBody);
        content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'text/xml; charset=utf-8');
        Client.Post(RequestUrl, Content, HttpWebResponse);



        if HttpWebResponse.IsSuccessStatusCode then begin
            HttpWebResponse.Content.ReadAs(ResponseText1);
            //                Message(JsonResponse);
            FindResponse := True;
        End Else begin
            HttpWebResponse.Content.ReadAs(ResponseText1);
            //              Message(RespMsg);
        end;


        startposInt := STRPOS(ResponseText1, '{');
        EndPosInt := STRPOS(ResponseText1, '}');
        NewString := COPYSTR(ResponseText1, startposInt, EndPosInt - startposInt + 1);
        Jtext := NewString;
        IF Jtext <> '' THEN BEGIN
            JSONManagement.InitializeObject(Jtext);
            ObjectJSONManagement.InitializeObject(Jtext);//CustomerJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('status', CodeText);
            Jtext2 := CodeText;

        END;

        EXIT(Jtext2);


        // WebRequest := WebRequest.Create('http://52.172.215.206:44419/RazorPay.asmx');
        // WebRequest.Method := 'POST';
        // WebRequest.Timeout := 1000 * 60 * 10;
        // WebRequest.ContentType := 'text/xml; charset=utf-8';
        // WebRequest.PreAuthenticate := FALSE; //TRUE;
        // StreamWriter := StreamWriter.StreamWriter(WebRequest.GetRequestStream);
        // StreamWriter.Write('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">');
        // StreamWriter.Write('<Body>');
        // StreamWriter.Write('<CallFatchSingleOrder xmlns="http://tempuri.org/">');
        // StreamWriter.Write('<OrderNo>' + vPmtOrderId + '</OrderNo>');
        // StreamWriter.Write('</CallFatchSingleOrder>');
        // StreamWriter.Write('</Body>');
        // StreamWriter.Write('</Envelope>');
        // StreamWriter.Close();
        // WebResponse := WebRequest.GetResponse();
        // StreamReader := StreamReader.StreamReader(WebResponse.GetResponseStream);
        // ResponseText1 := StreamReader.ReadToEnd;

        // startposInt := STRPOS(ResponseText1, '{');
        // EndPosInt := STRPOS(ResponseText1, '}');
        // NewString := COPYSTR(ResponseText1, startposInt, EndPosInt - startposInt + 1);

        // Jtext := NewString;
        // IF Jtext <> '' THEN BEGIN
        //     JObject := JObject.Parse(Jtext);
        //     Jtext2 := JObject.GetValue('status').ToString;  //Pass the value of node in GetValue
        // END;
        // EXIT(Jtext2);
    end;


    procedure Setfilteres(EntryNo_1: Integer)
    begin
        EntryNo_2 := EntryNo_1;
    end;


}

