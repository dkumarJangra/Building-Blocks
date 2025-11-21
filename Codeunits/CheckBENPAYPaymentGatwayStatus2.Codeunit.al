codeunit 50105 "Check BENPAY Payment Status_2"
{


    TableNo = "Payment transaction Details";

    trigger OnRun()
    var
        PaymentStatus: Text;
        UnitMaster: Record "Unit Master";
    begin
        PaymenttransactionDetails.RESET;
        PaymenttransactionDetails.SETRANGE("Entry No.", EntryNo_2);
        PaymenttransactionDetails.SETRANGE("Payment From", PaymenttransactionDetails."Payment From"::Benepay);
        PaymenttransactionDetails.SETFILTER("Payment Server Status", '<>%1&<>%2', 'FAILED', 'PAID');  //270525 Added new 'PAID'
        IF PaymenttransactionDetails.FINDSET THEN
            REPEAT
                PmtTransDetails.RESET;
                PmtTransDetails.SETRANGE("Entry No.", PaymenttransactionDetails."Entry No.");
                IF PmtTransDetails.FINDFIRST THEN BEGIN
                    PaymentStatus := '';
                    PaymentStatus := BenepayCallPaymentOrderStatus(PmtTransDetails."Unique Payment Order ID");

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




    procedure Setfilteres(EntryNo_1: Integer)
    begin
        EntryNo_2 := EntryNo_1;
    end;



    procedure GetPaymentGatewayToken(): Text;
    var
        Body: Text;
        HttpWebRequest: HttpRequestMessage;
        HttpWebResponse: HttpResponseMessage;
        HttpWebHeader: HttpHeaders;
        HttpWebClinet: HttpClient;
        HttpWebContent: HttpContent;
        ResponseMsg: Text;
        AuthString: text;
        Base64Convert: Codeunit "Base64 Convert";
        TokenKeylength: Integer;
        Post_ResText_1: text;
        DocPosition: Integer;
        Token_Key: Text;



    begin
        Body := 'grant_type=client_credentials';
        AuthString := STRSUBSTNO('%1:%2', '27dp7b8mt3i5igojj4pmbsrn45', '18u8iv00r2svs5eeieas61nqnvc8grq40fk9n1i9u5adie1bk6bu');
        AuthString := Base64Convert.ToBase64(AuthString);
        AuthString := STRSUBSTNO('Basic %1', AuthString);
        HttpWebRequest.SetRequestUri('https://benecollect-b2b-auth.auth.ap-south-1.amazoncognito.com/oauth2/token');
        HttpWebRequest.Method := 'POST';
        HttpWebContent.WriteFrom(Body);
        HttpWebContent.GetHeaders(HttpWebHeader);
        HttpWebHeader.Clear();
        HttpWebHeader.Add('Content-Type', 'application/x-www-form-urlencoded');
        HttpWebClinet.DefaultRequestHeaders.Add('Authorization', AuthString);

        HttpWebRequest.Content := HttpWebContent;

        if HttpWebClinet.Send(HttpWebRequest, HttpWebResponse) then begin
            HttpWebResponse.Content.ReadAs(ResponseMsg);
        end;
        TokenKeylength := STRLEN(ResponseMsg);
        Post_ResText_1 := COPYSTR(ResponseMsg, 18, 1000);
        DocPosition := STRPOS(Post_ResText_1, '"');
        Token_Key := COPYSTR(Post_ResText_1, 1, DocPosition - 1);
        EXIT(Token_Key);


    end;

    procedure BenepayCallPaymentOrderStatus(OrderId: Text): Text;
    var
        Body: Text;
        HttpWebRequest: HttpRequestMessage;
        HttpWebResponse: HttpResponseMessage;
        HttpWebHeader: HttpHeaders;
        HttpWebClinet: HttpClient;
        HttpWebContent: HttpContent;
        ResponseMsg: Text;
        AuthString: text;
        Base64Convert: Codeunit "Base64 Convert";
        TokenKeylength: Integer;
        Post_ResText_1: text;
        DocPosition: Integer;
        Token_KeyID: Text;
        startposInt: Integer;
        EndPosInt: Integer;
        NewString: Text;
        Jtext: Text;
        Jtext2: Text;
        ResponseText1: Text;
        ArrayJSONManagement: Codeunit "JSON Management";
        JSONManagement: Codeunit "JSON Management";
        ObjectJSONManagement: Codeunit "JSON Management";
        CodeText: TExt;
        ResponsLength: Integer;

    begin
        Body := CreateDataJsonArray(OrderId);

        Token_KeyID := GetPaymentGatewayToken;
        COMMIT;

        HttpWebRequest.SetRequestUri('https://benecollect-api-payment.benepay.io/v2/getTransactionStatus');
        HttpWebRequest.Method := 'POST';
        HttpWebContent.WriteFrom(Body);
        HttpWebContent.GetHeaders(HttpWebHeader);
        HttpWebHeader.Clear();
        //HttpWebHeader.Add('Content-Type', 'application/x-www-form-urlencoded');
        HttpWebClinet.DefaultRequestHeaders.Add('Authorization', 'Bearer ' + Token_KeyID);
        HttpWebHeader.Add('x-api-key', 'iqzqqwlrFu8k9gVJL8vsO16s6j6IX8PK1wqJ4Ep4');

        HttpWebRequest.Content := HttpWebContent;

        if HttpWebClinet.Send(HttpWebRequest, HttpWebResponse) then begin
            HttpWebResponse.Content.ReadAs(ResponseText1);
        end;

        ResponsLength := StrLen(ResponseText1);
        ResponseText1 := CopyStr(ResponseText1, 30, ResponsLength - 30);

        startposInt := STRPOS(ResponseText1, '{');
        EndPosInt := STRPOS(ResponseText1, '}');
        NewString := COPYSTR(ResponseText1, startposInt, EndPosInt - startposInt + 1);
        Jtext := NewString;
        IF Jtext <> '' THEN BEGIN
            JSONManagement.InitializeObject(Jtext);
            ObjectJSONManagement.InitializeObject(Jtext);//CustomerJsonObject);
            ObjectJSONManagement.GetStringPropertyValueByName('transactionStatus', CodeText);
            Jtext2 := CodeText;

        END;
        EXIT(Jtext2);

    end;

    local procedure CreateDataJsonArray(vOrderId: text): Text
    var
        MessageValue: Text;

        JArray: JsonArray;
        JArray_2: JsonArray;
        JArray_1: JsonArray;
        JArray_3: JsonArray;
        ShiptoObject_2: JsonObject;
        CustObject: JsonObject;
        JsonObject: JsonObject;
        JsonObject_1: JsonObject;
        ShiptoObject: JsonObject;
        ShiptoObject_1: JsonObject;
        MainShiptoObject: JsonObject;
        JsonData: Text;
        JsonData_1: Text;
    begin
        Clear(Custobject);
        Clear(JArray_1);
        Custobject.Add('transactionIds', JArray_1);
        Clear(JArray_1);
        JArray_1.add(vOrderId);
        Custobject.Add('requestorTransactionIds', JArray_1);
        Custobject.WriteTo(JsonData);
        EXIT(FORMAT(JsonData));
    end;

    // procedure BenepayCallPaymentOrderStatus1(vPmtOrderId: Text): Text
    // var
    //     TxtCompanyName: Text;
    //     Result: Text;
    //     xmloutstream: OutStream;
    //     ResponseText1: Text;
    //     startposInt: Integer;
    //     EndPosInt: Integer;
    //     NewString: Text;
    //     Jtext: Text;
    //     Jtext2: Text;
    //     AmountLength: Integer;
    //     CustPaymentAmt: Integer;

    //     Request: HttpRequestMessage;
    //     Content: HttpContent;
    //     RespMsg: Text;
    //     Client: HttpClient;
    //     Headers: HttpHeaders;
    //     contentHeaders: HttpHeaders;
    //     Contant: HttpContent;
    //     JsonResponse: Text;
    //     RequestUrl: Text;
    //     TextString: text;
    //     HttpWebResponse: HttpResponseMessage;
    //     Bytes: text;
    //     cu: Codeunit Encoding;
    //     JArray: JsonArray;
    //     CustObject: JsonObject;
    //     JsonObject: JsonObject;
    //     JsonData_1: Text;
    //     ShiptoObject: JsonObject;
    //     JsonData: Text;
    //     DotNetEncodeing: Codeunit DotNet_Encoding;
    //     DotNetArray: Codeunit DotNet_Array;
    //     DotNetArrayBytes: Codeunit DotNet_Array;
    //     ArrayJSONManagement: Codeunit "JSON Management";
    //     JSONManagement: Codeunit "JSON Management";
    //     ObjectJSONManagement: Codeunit "JSON Management";
    //     i: Integer;
    //     CodeText: Text;
    //     CustomerJsonObject: Text;
    //     JsonArrayText: Text;
    //     JsonObjectText: Text;

    //     HtmlEmailBody: text;
    //     FindResponse: Boolean;
    //     JObject: jsonobject;
    //     Tokey_KeyID: TExt;
    //     Base64Convert: Codeunit "Base64 Convert";
    //     AuthString: text;
    // begin
    //     Tokey_KeyID := GetPaymentGatewayToken;
    //     COMMIT;


    //     Headers := Client.DefaultRequestHeaders();
    //     //TextString := STRSUBSTNO(Post_FinalJSON);
    //     //Bytes := cu.Convert(1200, 28591, TextString);
    //     RequestUrl := 'https://benecollect-api-payment.benepay.io/v2/getTransactionStatus';
    //     Request.Method := 'POST';
    //     HtmlEmailBody += '<Body>';

    //     HtmlEmailBody += '<requestorTransactionIds>' + vPmtOrderId + '</requestorTransactionIds>';

    //     HtmlEmailBody += '</Body>';
    //     // HtmlEmailBody += '</Envelope>';

    //     //Message('%1', HtmlEmailBody);
    //     //Content.WriteFrom(Bytes);
    //     Content.WriteFrom(HtmlEmailBody);
    //     content.GetHeaders(Headers);
    //     //Headers.Add('Authorization: Bearer ' + Tokey_KeyID);
    //     Headers.Add('Authorization', 'Bearer ' + Tokey_KeyID);
    //     Headers.Add('x-api-key', 'iqzqqwlrFu8k9gVJL8vsO16s6j6IX8PK1wqJ4Ep4');
    //     Headers.Remove('Content-Type');
    //     Headers.Add('Content-Type', 'text/xml; charset=utf-8');
    //     Client.Post(RequestUrl, Content, HttpWebResponse);
    //     if HttpWebResponse.IsSuccessStatusCode then begin
    //         HttpWebResponse.Content.ReadAs(ResponseText1);
    //         //                Message(JsonResponse);
    //         FindResponse := True;
    //     End Else begin
    //         HttpWebResponse.Content.ReadAs(ResponseText1);
    //         //              Message(RespMsg);
    //     end;


    //     startposInt := STRPOS(ResponseText1, '{');
    //     EndPosInt := STRPOS(ResponseText1, '}');
    //     NewString := COPYSTR(ResponseText1, startposInt, EndPosInt - startposInt + 1);
    //     Jtext := NewString;
    //     IF Jtext <> '' THEN BEGIN
    //         JSONManagement.InitializeObject(Jtext);
    //         ObjectJSONManagement.InitializeObject(Jtext);//CustomerJsonObject);
    //         ObjectJSONManagement.GetStringPropertyValueByName('transactionStatus', CodeText);
    //         Jtext2 := CodeText;

    //     END;
    //     EXIT(Jtext2);
    // END;



}

