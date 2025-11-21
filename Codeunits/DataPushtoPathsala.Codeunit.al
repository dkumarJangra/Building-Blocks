codeunit 50014 "Data Push to Pathsala"
{
    Permissions = TableData "Data Exch. Field" = rimd;

    trigger OnRun()
    var
        DataExch1: Record "Data Exch. Field";
        ResponseInStream_L: InStream;
        // HttpStatusCode_L: DotNet HttpStatusCode;
        // ResponseHeaders_L: DotNet NameValueCollection;
        ResponseText: Text;
        FL: File;
        AAAAA: BigText;
    begin
        Post_VendorDatatoPathshaalaAPI(VendorFilterValue);
    end;

    var
        //tempblob: Record TempBlob;
        OutStrm: OutStream;
        // JsonTextWriter: DotNet JsonTextWriter;
        // JsonTextReader: DotNet JsonTextReader;
        // StreamWriter: DotNet StreamWriter;
        // StreamReader: DotNet StreamReader;
        // Encoding: DotNet Encoding;
        // StringBuilder: DotNet StringBuilder;
        // StringWriter: DotNet StringWriter;
        // StringReader: DotNet StringReader;
        MessageText: Text;
        //Json: DotNet String;
        OutStrm_1: OutStream;
        // JsonTextWriter_1: DotNet JsonTextWriter;
        // JsonLineObject: DotNet JObject;
        // JsonArray: DotNet JArray;
        // JsonTextReader_1: DotNet JsonTextReader;
        // StreamWriter_1: DotNet StreamWriter;
        // StreamReader_1: DotNet StreamReader;
        // Encoding_1: DotNet Encoding;
        // StringBuilder_1: DotNet StringBuilder;
        // StringWriter_1: DotNet StringWriter;
        // StringReader_1: DotNet StringReader;
        MessageText_1: Text;
        MessageText_2: Text;
        EntryNo: Integer;
        VendName: Text;
        VendPANNO: Code[20];
        VendIntroducerCode: Code[20];
        WebLoginGUID: Guid;
        UniquePayment_ID: Text;
        "----------------------": Integer;
        // Post_HttpWebRequest: DotNet HttpWebRequest;
        // Post_HttpWebResponse: DotNet HttpWebResponse;
        // Post_TextString: DotNet String;
        // Post_Bytes: DotNet Array;
        // Post_Encoding: DotNet Encoding;
        // Post_StreamReader: DotNet StreamReader;
        Post_ResText: Text;
        // Post_StringBuilder: DotNet StringBuilder;
        // Post_StringWriter: DotNet StringWriter;
        // Post_JSON: DotNet String;
        // Post_JSONTextWriter: DotNet JsonTextWriter;
        vUniquePaymentID: Text;
        TransactionPmt_Status: Text;
        DOB: Date;
        MobileAppAssociateMail: Codeunit "Mobile App Associate Mail";
        NewAss_ID: Code[20];
        AllowBooking: Boolean;
        "------------------": Integer;
        // ServicePointManager: DotNet ServicePointManager;
        // SecurityProtocolType: DotNet SecurityProtocolType;
        // HttpCertificateValidator: DotNet RequestValidator;
        VendorFilterValue: Text;

    local procedure CreateJSONAttribute2(AttributeName: Text; Value: Variant): Text
    var
        MessageValue: Text;
    begin
        // JsonTextWriter.WritePropertyName(AttributeName);
        // JsonTextWriter.WriteValue(Value);
    end;


    procedure Post_VendorDatatoPathshaalaAPI(VendorFilters: Text)
    var
        MessageValue: Text;
        SNo: Integer;
        RankCode_1: Record "Rank Code";
        V_Vendor: Record Vendor;
        RegionwiseVendor: Record "Region wise Vendor";
        JArray: JsonArray;
        CustObject: JsonObject;
        JsonObject: JsonObject;
        JsonData_1: Text;
        ShiptoObject: JsonObject;
        JsonData: Text;
        Json: Text;
        Client: HttpClient;
        Headers: HttpHeaders;
        contentHeaders: HttpHeaders;
        Contant: HttpContent;
        JsonResponse: Text;
        RequestUrl: Text;

        cu: Codeunit Encoding;
        DotNetEncodeing: Codeunit DotNet_Encoding;
        DotNetArray: Codeunit DotNet_Array;
        DotNetArrayBytes: Codeunit DotNet_Array;
        Request: HttpRequestMessage;
        Content: HttpContent;
        RespMsg: Text;
        HttpWebResponse: HttpResponseMessage;// DotNet HttpWebResponse;
        JSONString: Text;
        Bytes: Text; //DotNet Array;
        JSONTextWriter: JsonObject;
        FinalJSON: Text;
        TextString: Text;
    begin
        V_Vendor.RESET;
        V_Vendor.SETFILTER("No.", VendorFilters);
        IF V_Vendor.FINDSET THEN BEGIN
            Clear(JArray);
            REPEAT
                Clear(ShiptoObject);
                RegionwiseVendor.RESET;
                RegionwiseVendor.SETRANGE("No.", V_Vendor."No.");
                IF RegionwiseVendor.FINDFIRST THEN BEGIN
                    RankCode_1.RESET;
                    IF RankCode_1.GET(RegionwiseVendor."Region Code", RegionwiseVendor."Rank Code") THEN;
                END;

                //    JsonTextWriter.WriteStartObject;
                ShiptoObject.Add('associate_id', FORMAT(V_Vendor."No."));
                ShiptoObject.Add('username', FORMAT(V_Vendor."BBG Mob. No."));  //V_Vendor."Mob. No."
                ShiptoObject.Add('name', FORMAT(V_Vendor.Name));
                ShiptoObject.Add('email', FORMAT(V_Vendor."E-Mail"));
                ShiptoObject.Add('mobile', FORMAT(V_Vendor."BBG Mob. No."));
                ShiptoObject.Add('password', FORMAT(V_Vendor."BBG Associate Password"));
                ShiptoObject.Add('designation', FORMAT(RankCode_1.Description));
                ShiptoObject.Add('role', FORMAT(RankCode_1.Category));
                JArray.Add(ShiptoObject);
            UNTIL V_Vendor.NEXT = 0;

            CustObject.Add('Data', JArray);
            CustObject.WriteTo(Json);

            JSONString := Format(JSONTextWriter);
            FinalJSON := JSONString;
            Headers := Client.DefaultRequestHeaders();
            TextString := STRSUBSTNO(FinalJSON);
            Bytes := cu.Convert(1200, 28591, TextString);
            RequestUrl := 'https://bbgpathsala.bbgindia.com/api/app-data-sync-link';
            Request.Method := 'POST';
            Content.WriteFrom(Bytes);
            content.GetHeaders(Headers);
            Headers.Remove('Content-Type');
            Headers.Add('Content-Type', 'application/json; charset=utf-8');
            Client.Post(RequestUrl, Content, HttpWebResponse);
            if HttpWebResponse.IsSuccessStatusCode then begin
                HttpWebResponse.Content.ReadAs(RespMsg);
                //                Message(JsonResponse);
            End Else begin
                HttpWebResponse.Content.ReadAs(RespMsg);
                //              Message(RespMsg);
            end;

            // //EXIT(FORMAT(Json));

            // ServicePointManager.SecurityProtocol := SecurityProtocolType.Tls12;
            // Post_HttpWebRequest := Post_HttpWebRequest.Create('https://bbgpathsala.bbgindia.com/api/app-data-sync-link');   //184.168.99.137
            // Post_HttpWebRequest.Method := 'POST';
            // Post_HttpWebRequest.ContentType := 'application/x-www-form-urlencoded'; //'application/json';
            // Post_HttpWebRequest.KeepAlive := TRUE;
            // Post_HttpWebRequest.AllowAutoRedirect := TRUE;
            // Post_HttpWebRequest.Accept('*/*');

            // Post_TextString := STRSUBSTNO('syncCode=' + FORMAT(Json));
            // Post_Encoding := Post_Encoding.UTF8();
            // Post_Bytes := Post_Encoding.GetEncoding('iso-8859-1').GetBytes(Post_TextString.ToString);
            // //Post_HttpWebRequest.ContentLength := Post_TextString.Length;
            // Post_HttpWebRequest.GetRequestStream.Write(Post_Bytes, 0, Post_Bytes.Length);
            // HttpCertificateValidator := HttpCertificateValidator.RequestValidator(Post_HttpWebRequest);

            // Post_HttpWebResponse := Post_HttpWebRequest.GetResponse;
            // Post_StreamReader := Post_StreamReader.StreamReader(Post_HttpWebResponse.GetResponseStream);
            // Post_ResText := Post_StreamReader.ReadToEnd();
            // Post_StreamReader.Close();
            //MESSAGE('%1',Post_ResText);


        END;
    end;


    procedure SetVendValue(VendFilters: Text)
    begin
        VendorFilterValue := VendFilters;
    end;

    // trigger JsonLineObject::PropertyChanged(sender: Variant; e: DotNet PropertyChangedEventArgs)
    // begin
    // end;

    // trigger JsonLineObject::PropertyChanging(sender: Variant; e: DotNet PropertyChangingEventArgs)
    // begin
    // end;

    // trigger JsonLineObject::ListChanged(sender: Variant; e: DotNet ListChangedEventArgs)
    // begin
    // end;

    // trigger JsonLineObject::AddingNew(sender: Variant; e: DotNet AddingNewEventArgs)
    // begin
    // end;

    // trigger JsonLineObject::CollectionChanged(sender: Variant; e: DotNet NotifyCollectionChangedEventArgs)
    // begin
    // end;
}

