codeunit 50225 "DGC Whatsup SMS"
{
    trigger OnRun()
    begin

    end;

    procedure CreateBodyForPaymentReminder(FrommobileNo: Text; TomobileNo: Text; Parameter1: Text; Parameter2: Text; Parameter3: Text; Parameter4: Text; Parameter5: Text; Parameter6: Text; LWhatsAppDataPushDetails: Record "WhatsApp Data Push Details")
    var
        RequestJson: JsonObject;
        MessageJson: JsonObject;
        ContentJson: JsonObject;
        TemplateJson: JsonObject;
        RecipientJson: JsonObject;
        LanguageJson: JsonObject;
        ReferenceJson: JsonObject;
        ParameterJson: JsonObject;
        SenderJson: JsonObject;
        PreferencesJson: JsonObject;
        MetaDataJson: JsonObject;
        Json: Text;
    begin
        GWhatsAppDataPushDetails.Reset();
        GWhatsAppDataPushDetails.SetRange("Entry ID", LWhatsAppDataPushDetails."Entry ID");
        IF GWhatsAppDataPushDetails.FindFirst() then;

        MessageJson.Add(channellbl, WABAlbl);

        ContentJson.add(preview_urllbl, false);
        ContentJson.add(typeLbl, TEMPLATElbl);

        TemplateJson.add(templateIdlbl, duereminderlbl);

        ParameterJson.add(Zerolbl, Parameter1);
        ParameterJson.add(Onelbl, Parameter2);
        ParameterJson.Add(Twolbl, Parameter3);
        ParameterJson.Add(Threelbl, Parameter4);
        ParameterJson.Add(Fourlbl, Parameter5);
        ParameterJson.Add(Fivelbl, Parameter6);

        TemplateJson.add(parameterValueslbl, ParameterJson);
        TemplateJson.add(headerTitlelbl, '{{1}}');

        ContentJson.Add(templatevaluelbl, TemplateJson);
        ContentJson.add(shorten_urllbl, true);

        MessageJson.Add(contentlbl, ContentJson);

        RecipientJson.Add(toLbl, TomobileNo);
        RecipientJson.Add(recipient_typeLbl, individualLbl);

        ReferenceJson.add(cust_reflbl, Some_Customer_Reflbl);
        ReferenceJson.add(messageTag1lbl, Message_Tag_Val1lbl);
        ReferenceJson.add(conversationIdlbl, Some_Optional_Conversation_IDlbl);

        RecipientJson.Add(referencelbl, ReferenceJson);
        MessageJson.Add(recipientlbl, RecipientJson);

        SenderJson.Add(fromlbl, FrommobileNo);
        MessageJson.Add(senderlbl, SenderJson);

        PreferencesJson.Add(webHookDNIdlbl, '1001');

        MetaDataJson.add(versionlbl, 'v1.0.9');

        RequestJson.Add(messagelbl, MessageJson);
        RequestJson.Add(metaDatalbl, MetaDataJson);
        RequestJson.WriteTo(Json);
        //Message(Json);
        SendSMS(Json);
    end;

    procedure CreateBodyForPaymentReminderForVendor(FrommobileNo: Text; TomobileNo: Text; Parameter1: Text; Parameter2: Text; Parameter3: Text; Parameter4: Text; Parameter5: Text; Parameter6: Text; LWhatsAppDataPushDetails: Record "WhatsApp Data Push Details")
    var
        RequestJson: JsonObject;
        MessageJson: JsonObject;
        ContentJson: JsonObject;
        TemplateJson: JsonObject;
        RecipientJson: JsonObject;
        LanguageJson: JsonObject;
        ReferenceJson: JsonObject;
        ParameterJson: JsonObject;
        SenderJson: JsonObject;
        PreferencesJson: JsonObject;
        MetaDataJson: JsonObject;
        Json: Text;
    begin
        GWhatsAppDataPushDetailsVend.Reset();
        GWhatsAppDataPushDetailsVend.SetRange("Entry ID", LWhatsAppDataPushDetails."Entry ID");
        IF GWhatsAppDataPushDetailsVend.FindFirst() then;

        MessageJson.Add(channellbl, WABAlbl);

        ContentJson.add(preview_urllbl, false);
        ContentJson.add(typeLbl, TEMPLATElbl);

        TemplateJson.add(templateIdlbl, duereminderlbl);

        ParameterJson.add(Zerolbl, Parameter1);
        ParameterJson.add(Onelbl, Parameter2);
        ParameterJson.Add(Twolbl, Parameter3);
        ParameterJson.Add(Threelbl, Parameter4);
        ParameterJson.Add(Fourlbl, Parameter5);
        ParameterJson.Add(Fivelbl, Parameter6);

        TemplateJson.add(parameterValueslbl, ParameterJson);
        TemplateJson.add(headerTitlelbl, '{{1}}');

        ContentJson.Add(templatevaluelbl, TemplateJson);
        ContentJson.add(shorten_urllbl, true);

        MessageJson.Add(contentlbl, ContentJson);

        RecipientJson.Add(toLbl, TomobileNo);
        RecipientJson.Add(recipient_typeLbl, individualLbl);

        ReferenceJson.add(cust_reflbl, Some_Customer_Reflbl);
        ReferenceJson.add(messageTag1lbl, Message_Tag_Val1lbl);
        ReferenceJson.add(conversationIdlbl, Some_Optional_Conversation_IDlbl);

        RecipientJson.Add(referencelbl, ReferenceJson);
        MessageJson.Add(recipientlbl, RecipientJson);

        SenderJson.Add(fromlbl, FrommobileNo);
        MessageJson.Add(senderlbl, SenderJson);

        PreferencesJson.Add(webHookDNIdlbl, '1001');

        MetaDataJson.add(versionlbl, 'v1.0.9');

        RequestJson.Add(messagelbl, MessageJson);
        RequestJson.Add(metaDatalbl, MetaDataJson);
        RequestJson.WriteTo(Json);
        //Message(Json);
        SendSMSForVendor(Json);
    end;

    procedure CreateBodyForbillPayment(MobileNo: Text; Parameter1: Text; Parameter2: Text; Parameter3: Text)
    var
        RequestJson: JsonObject;
        TemplateJson: JsonObject;
        LanguageJson: JsonObject;
        ComponentsArray: JsonArray;
        ComponentJson: JsonObject;
        ParametersArray: JsonArray;
        ParameterJson: JsonObject;
        Json: Text;
    begin
        // Main request object
        RequestJson.Add(messaging_productLbl, whatsappLbl);
        RequestJson.Add(recipient_typeLbl, individualLbl);
        RequestJson.Add(toLbl, MobileNo);
        RequestJson.Add(typeLbl, templateLbl);

        // Template object
        TemplateJson.Add(nameLbl, bill_paymentLbl);

        // Language object
        LanguageJson.Add(codeLbl, enLbl);
        TemplateJson.Add(languageLbl, LanguageJson);

        // Components array
        ComponentJson.Add(typeLbl, bodyLbl);

        // Parameters array
        AddTextParameter(ParametersArray, Parameter1);
        AddTextParameter(ParametersArray, Parameter2);
        AddTextParameter(ParametersArray, Parameter3);

        ComponentJson.Add(parametersLbl, ParametersArray);
        ComponentsArray.Add(ComponentJson);
        TemplateJson.Add(componentsLbl, ComponentsArray);

        RequestJson.Add(templateLbl, TemplateJson);

        // Convert to text
        RequestJson.WriteTo(Json);
        //CreateRequestFile(Json);
        SendSMS(Json);
    end;

    local procedure AddTextParameter(var ParametersArray: JsonArray; ParameterValue: Text)
    var
        ParameterJson: JsonObject;
    begin
        ParameterJson.Add(typeLbl, textLbl);
        ParameterJson.Add(textLbl, ParameterValue);
        ParametersArray.Add(ParameterJson);
    end;

    procedure CreateBodyForMonthlyBillStatement(MobileNo: Text; Parameter1: Text; AttachmentLink: Text; FileName: Text)
    var
        RequestJson: JsonObject;
        TemplateJson: JsonObject;
        LanguageJson: JsonObject;
        ComponentsArray: JsonArray;
        HeaderComponentJson: JsonObject;
        BodyComponentJson: JsonObject;
        HeaderParametersArray: JsonArray;
        BodyParametersArray: JsonArray;
        DocumentParameterJson: JsonObject;
        DocumentJson: JsonObject;
        TextParameterJson: JsonObject;
        Json: Text;
    begin
        // Main request object
        RequestJson.Add(messaging_productLbl, whatsappLbl);
        RequestJson.Add(recipient_typeLbl, individualLbl);
        RequestJson.Add(toLbl, MobileNo);
        RequestJson.Add(typeLbl, templateLbl);

        // Template object
        TemplateJson.Add(nameLbl, monthly_bill_statementLbl);

        // Language object
        LanguageJson.Add(codeLbl, enLbl);
        TemplateJson.Add(languageLbl, LanguageJson);

        // Header component with document
        HeaderComponentJson.Add(typeLbl, headerlbl);

        // Document parameter
        DocumentJson.Add(linklbl, attachmentlink);
        DocumentJson.Add(filenamelbl, filename);
        DocumentParameterJson.Add(typeLbl, documentlbl);
        DocumentParameterJson.Add(documentlbl, DocumentJson);

        HeaderParametersArray.Add(DocumentParameterJson);
        HeaderComponentJson.Add(parametersLbl, HeaderParametersArray);
        ComponentsArray.Add(HeaderComponentJson);

        // Body component with text parameter
        BodyComponentJson.Add(typeLbl, bodyLbl);

        TextParameterJson.Add(typeLbl, textLbl);
        TextParameterJson.Add(textLbl, Parameter1);

        BodyParametersArray.Add(TextParameterJson);
        BodyComponentJson.Add(parametersLbl, BodyParametersArray);
        ComponentsArray.Add(BodyComponentJson);

        // Add components to template
        TemplateJson.Add(componentsLbl, ComponentsArray);
        RequestJson.Add(templateLbl, TemplateJson);

        // Convert to text and send
        RequestJson.WriteTo(Json);
        //CreateRequestFile(Json);
        SendSMSforMonthlyStatement(Json);
    end;


    procedure CreateBodyForCreditLimit80(MobileNo: Text; Parameter1: Text; Parameter2: Text)
    var
        RequestJson: JsonObject;
        TemplateJson: JsonObject;
        LanguageJson: JsonObject;
        ComponentsArray: JsonArray;
        ComponentJson: JsonObject;
        ParametersArray: JsonArray;
        Json: Text;
    begin
        // Main request object
        RequestJson.Add(messaging_productLbl, whatsappLbl);
        RequestJson.Add(recipient_typeLbl, individualLbl);
        RequestJson.Add(toLbl, MobileNo);
        RequestJson.Add(typeLbl, templateLbl);

        // Template object
        TemplateJson.Add(nameLbl, credit_limit_80Lbl);

        // Language object
        LanguageJson.Add(codeLbl, enLbl);
        TemplateJson.Add(languageLbl, LanguageJson);

        // Body component with parameters
        ComponentJson.Add(typeLbl, bodyLbl);

        AddTextParameter(ParametersArray, Parameter1);
        AddTextParameter(ParametersArray, Parameter2);

        ComponentJson.Add(parametersLbl, ParametersArray);
        ComponentsArray.Add(ComponentJson);

        TemplateJson.Add(componentsLbl, ComponentsArray);
        RequestJson.Add(templateLbl, TemplateJson);

        // Convert to text and send
        RequestJson.WriteTo(Json);
        // CreateRequestFile(Json);
        SendSMS(Json);
    end;

    procedure CreateBodyForCreditLimit(MobileNo: Text; Parameter1: Text; Parameter2: Text)
    var
        RequestJson: JsonObject;
        TemplateJson: JsonObject;
        LanguageJson: JsonObject;
        ComponentsArray: JsonArray;
        ComponentJson: JsonObject;
        ParametersArray: JsonArray;
        Json: Text;
    begin
        // Main request object
        RequestJson.Add(messaging_productLbl, whatsappLbl);
        RequestJson.Add(recipient_typeLbl, individualLbl);
        RequestJson.Add(toLbl, MobileNo);
        RequestJson.Add(typeLbl, templateLbl);

        // Template object
        TemplateJson.Add(nameLbl, credit_limitLbl);

        // Language object
        LanguageJson.Add(codeLbl, enLbl);
        TemplateJson.Add(languageLbl, LanguageJson);

        // Body component with parameters
        ComponentJson.Add(typeLbl, bodyLbl);

        AddTextParameter(ParametersArray, Parameter1);
        AddTextParameter(ParametersArray, Parameter2);

        ComponentJson.Add(parametersLbl, ParametersArray);
        ComponentsArray.Add(ComponentJson);

        TemplateJson.Add(componentsLbl, ComponentsArray);
        RequestJson.Add(templateLbl, TemplateJson);

        // Convert to text and send
        RequestJson.WriteTo(Json);
        // CreateRequestFile(Json);
        SendSMS(Json);
    end;

    procedure CreateBodyForSurchargeInformation(MobileNo: Text; Parameter1: Text; Parameter2: Text)
    var
        RequestJson: JsonObject;
        TemplateJson: JsonObject;
        LanguageJson: JsonObject;
        ComponentsArray: JsonArray;
        ComponentJson: JsonObject;
        ParametersArray: JsonArray;
        Json: Text;
    begin
        // Main request object
        RequestJson.Add(messaging_productLbl, whatsappLbl);
        RequestJson.Add(recipient_typeLbl, individualLbl);
        RequestJson.Add(toLbl, MobileNo);
        RequestJson.Add(typeLbl, templateLbl);

        // Template object
        TemplateJson.Add(nameLbl, surcharge_informationLbl);

        // Language object
        LanguageJson.Add(codeLbl, enLbl);
        TemplateJson.Add(languageLbl, LanguageJson);

        // Body component with parameters
        ComponentJson.Add(typeLbl, bodyLbl);

        AddTextParameter(ParametersArray, Parameter1);
        AddTextParameter(ParametersArray, Parameter2);

        ComponentJson.Add(parametersLbl, ParametersArray);
        ComponentsArray.Add(ComponentJson);

        TemplateJson.Add(componentsLbl, ComponentsArray);
        RequestJson.Add(templateLbl, TemplateJson);

        // Convert to text and send
        RequestJson.WriteTo(Json);
        // CreateRequestFile(Json);
        SendSMS(Json);
    end;

    procedure CreateBodyForCreditLimitVer3(MobileNo: Text; Parameter1: Text; Parameter2: Text; Parameter3: Text)
    var
        RequestJson: JsonObject;
        TemplateJson: JsonObject;
        LanguageJson: JsonObject;
        ComponentsArray: JsonArray;
        ComponentJson: JsonObject;
        ParametersArray: JsonArray;
        Json: Text;
    begin
        // Main request object
        RequestJson.Add(messaging_productLbl, whatsappLbl);
        RequestJson.Add(recipient_typeLbl, individualLbl);
        RequestJson.Add(toLbl, MobileNo);
        RequestJson.Add(typeLbl, templateLbl);

        // Template object
        TemplateJson.Add(nameLbl, credit_limit_ver3Lbl);

        // Language object
        LanguageJson.Add(codeLbl, enLbl);
        TemplateJson.Add(languageLbl, LanguageJson);

        // Body component with parameters
        ComponentJson.Add(typeLbl, bodyLbl);

        AddTextParameter(ParametersArray, Parameter1);
        AddTextParameter(ParametersArray, Parameter2);
        AddTextParameter(ParametersArray, Parameter3);

        ComponentJson.Add(parametersLbl, ParametersArray);
        ComponentsArray.Add(ComponentJson);

        TemplateJson.Add(componentsLbl, ComponentsArray);
        RequestJson.Add(templateLbl, TemplateJson);

        // Convert to text and send
        RequestJson.WriteTo(Json);
        // CreateRequestFile(Json);
        SendSMS(Json);
    end;

    procedure SendSMS(JsonPayload: Text)
    var
        WhatsappIntegrationSetup: Record "Whatsup Integration Setup";
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        ResponseText: Text;
    begin
        WhatsappIntegrationSetup.Get();

        // Set up the request content
        Content.WriteFrom(JsonPayload);
        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Remove(WhatsappIntegrationSetup.Header);
        ContentHeaders.Add(WhatsappIntegrationSetup.Header, WhatsappIntegrationSetup."Header Value");

        // Set up the request message
        RequestMessage.Method := WhatsappIntegrationSetup.Method;
        RequestMessage.SetRequestUri(WhatsappIntegrationSetup."API URL");
        RequestMessage.Content := Content;

        // Add custom headers
        RequestMessage.GetHeaders(Headers);
        Headers.Add(WhatsappIntegrationSetup."Header 2", WhatsappIntegrationSetup."Header Value 2");

        // Send the request
        if not Client.Send(RequestMessage, ResponseMessage) then
            Error('Failed to send WhatsApp message: %1', GetLastErrorText());

        // Handle response
        if ResponseMessage.IsSuccessStatusCode() then begin
            ResponseMessage.Content.ReadAs(ResponseText);
            SaveReponceMessage(ResponseMessage);
            //Message('Success: ' + ResponseText); // Uncomment if needed
        end else begin
            ResponseMessage.Content.ReadAs(ResponseText);
            SaveReponceMessage(ResponseMessage);
            //Error('WhatsApp API error (%1): %2', ResponseMessage.HttpStatusCode(), ResponseText);
        end;
    end;

    procedure SendSMSForVendor(JsonPayload: Text)
    var
        WhatsappIntegrationSetup: Record "Whatsup Integration Setup";
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        ResponseText: Text;
    begin
        WhatsappIntegrationSetup.Get();

        // Set up the request content
        Content.WriteFrom(JsonPayload);
        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Remove(WhatsappIntegrationSetup.Header);
        ContentHeaders.Add(WhatsappIntegrationSetup.Header, WhatsappIntegrationSetup."Header Value");

        // Set up the request message
        RequestMessage.Method := WhatsappIntegrationSetup.Method;
        RequestMessage.SetRequestUri(WhatsappIntegrationSetup."API URL");
        RequestMessage.Content := Content;

        // Add custom headers
        RequestMessage.GetHeaders(Headers);
        Headers.Add(WhatsappIntegrationSetup."Header 2", WhatsappIntegrationSetup."Header Value 2");

        // Send the request
        if not Client.Send(RequestMessage, ResponseMessage) then
            Error('Failed to send WhatsApp message: %1', GetLastErrorText());

        // Handle response
        if ResponseMessage.IsSuccessStatusCode() then begin
            ResponseMessage.Content.ReadAs(ResponseText);
            SaveReponceMessageForVendor(ResponseMessage);
            //Message('Success: ' + ResponseText); // Uncomment if needed
        end else begin
            ResponseMessage.Content.ReadAs(ResponseText);
            SaveReponceMessageForVendor(ResponseMessage);
            //Error('WhatsApp API error (%1): %2', ResponseMessage.HttpStatusCode(), ResponseText);
        end;
    end;

    procedure SaveReponceMessage(var ResponseMessage: HttpResponseMessage)
    var
        JObject: JsonObject;
        JToken: JsonToken;
        RText: Text;
    begin
        if ResponseMessage.IsSuccessStatusCode() then begin
            ResponseMessage.Content.ReadAs(RText);
            IF GWhatsAppDataPushDetails."Receiver Type" = GWhatsAppDataPushDetails."Receiver Type"::Customer then begin
                if not JObject.ReadFrom(RText) then
                    Error('Invalid response, expected a JSON object');
                if JObject.Get('statusCode', JToken) then
                    GWhatsAppDataPushDetails."Whatsup Status Code For Cust" := JToken.AsValue().AsText();
                if JObject.Get('statusDesc', JToken) then
                    GWhatsAppDataPushDetails."Whatsup Status Desc For Cust" := JToken.AsValue().AsText();
                if JObject.Get('mid', JToken) then
                    GWhatsAppDataPushDetails."Whatsup mid For Customer" := JToken.AsValue().AsText();
                GWhatsAppDataPushDetails."Select for send Whatsapp" := False;
                GWhatsAppDataPushDetails."Sent Whatsapp Message For Cust" := True;
                GWhatsAppDataPushDetails."Whats Mess DateTime For Cust" := CurrentDateTime;
                GWhatsAppDataPushDetails.Modify();
                Commit();
            end else begin
                ResponseMessage.Content.ReadAs(RText);

                if not JObject.ReadFrom(RText) then
                    Error('Invalid response, expected a JSON object');
                if JObject.Get('statusCode', JToken) then
                    GWhatsAppDataPushDetails."Whatsup Status Code For Cust" := JToken.AsValue().AsText();
                if JObject.Get('statusDesc', JToken) then
                    GWhatsAppDataPushDetails."Whatsup Status Desc For Cust" := JToken.AsValue().AsText();
                if JObject.Get('mid', JToken) then
                    GWhatsAppDataPushDetails."Whatsup mid For Customer" := JToken.AsValue().AsText();
                GWhatsAppDataPushDetails."Select for send Whatsapp" := False;
                GWhatsAppDataPushDetails."Sent Whatsapp Message For Cust" := True;
                GWhatsAppDataPushDetails."Whats Mess DateTime For Cust" := CurrentDateTime;
                GWhatsAppDataPushDetails.Modify();
                Commit();
            end;
        end;

    end;

    procedure SaveReponceMessageForVendor(var ResponseMessage: HttpResponseMessage)
    var
        JObject: JsonObject;
        JToken: JsonToken;
        RText: Text;
    begin
        if ResponseMessage.IsSuccessStatusCode() then begin
            ResponseMessage.Content.ReadAs(RText);
            IF GWhatsAppDataPushDetailsVend."Receiver Type" = GWhatsAppDataPushDetailsVend."Receiver Type"::Customer then begin
                if not JObject.ReadFrom(RText) then
                    Error('Invalid response, expected a JSON object');
                if JObject.Get('statusCode', JToken) then
                    GWhatsAppDataPushDetailsVend."Whatsup Status Code For Vendor" := JToken.AsValue().AsText();
                if JObject.Get('statusDesc', JToken) then
                    GWhatsAppDataPushDetailsVend."Whatsup Status Desc For Vendor" := JToken.AsValue().AsText();
                if JObject.Get('mid', JToken) then
                    GWhatsAppDataPushDetailsVend."Whatsup mid For Vendor" := JToken.AsValue().AsText();
                GWhatsAppDataPushDetailsVend."Select for send Whatsapp" := False;
                GWhatsAppDataPushDetailsVend."Sent Whatsapp Message For Vend" := True;
                GWhatsAppDataPushDetailsVend."Whats Mess DateTime For Vendor" := CurrentDateTime;
                GWhatsAppDataPushDetailsVend.Modify();
                Commit();
            end else begin
                ResponseMessage.Content.ReadAs(RText);

                if not JObject.ReadFrom(RText) then
                    Error('Invalid response, expected a JSON object');
                if JObject.Get('statusCode', JToken) then
                    GWhatsAppDataPushDetailsVend."Whatsup Status Code For Vendor" := JToken.AsValue().AsText();
                if JObject.Get('statusDesc', JToken) then
                    GWhatsAppDataPushDetailsVend."Whatsup Status Desc For Vendor" := JToken.AsValue().AsText();
                if JObject.Get('mid', JToken) then
                    GWhatsAppDataPushDetailsVend."Whatsup mid For Vendor" := JToken.AsValue().AsText();
                GWhatsAppDataPushDetailsVend."Select for send Whatsapp" := False;
                GWhatsAppDataPushDetailsVend."Sent Whatsapp Message For Vend" := True;
                GWhatsAppDataPushDetailsVend."Whats Mess DateTime For Vendor" := CurrentDateTime;
                GWhatsAppDataPushDetailsVend.Modify();
                Commit();
            end;
        end;

    end;

    procedure SendSMSforMonthlyStatement(JsonPayload: Text)
    var
        WhatsappIntegrationSetup: Record "Whatsup Integration Setup";
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Headers: HttpHeaders;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        ResponseText: Text;
    begin
        WhatsappIntegrationSetup.Get();

        // Set up the request content
        Content.WriteFrom(JsonPayload);
        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', WhatsappIntegrationSetup."Header Value");

        // Set up the request message
        RequestMessage.Method := WhatsappIntegrationSetup.Method;
        RequestMessage.SetRequestUri(WhatsappIntegrationSetup."API URL2"); // Note: Using API URL2
        RequestMessage.Content := Content;

        // Add custom headers
        RequestMessage.GetHeaders(Headers);
        Headers.Add(WhatsappIntegrationSetup."Header 2", WhatsappIntegrationSetup."Header Value 2");

        // Send the request
        if not Client.Send(RequestMessage, ResponseMessage) then
            Error('Failed to send WhatsApp monthly statement: %1', GetLastErrorText());

        // Handle response
        if ResponseMessage.IsSuccessStatusCode() then begin
            ResponseMessage.Content.ReadAs(ResponseText);
            //Message('Success: ' + ResponseText); // Uncomment if needed
        end else begin
            ResponseMessage.Content.ReadAs(ResponseText);
            //Error('WhatsApp API error (%1): %2', ResponseMessage.HttpStatusCode(), ResponseText);
        end;
    end;

    var
        messaging_productLbl: Label 'messaging_product';
        whatsappLbl: Label 'whatsapp';
        nameLbl: Label 'name';
        languageLbl: Label 'language';
        codeLbl: Label 'code';
        enLbl: Label 'en';
        componentsLbl: Label 'components';
        bodyLbl: Label 'body';
        parametersLbl: Label 'parameters';
        textLbl: Label 'text';
        bill_paymentLbl: Label 'bill_payment';
        monthly_bill_statementLbl: Label 'monthly_bill_statement';
        credit_limit_80Lbl: Label 'credit_limit_80';
        credit_limitLbl: Label 'credit_limit';
        surcharge_informationLbl: Label 'surcharge_information';
        credit_limit_ver3Lbl: Label 'credit_limit_ver3';

        headerlbl: Label 'header';
        documentlbl: Label 'document';
        linklbl: Label 'link';
        filenamelbl: Label 'filename';

        //For BBG Start >>
        messagelbl: Label 'message';
        channellbl: Label 'channel';
        contentlbl: Label 'content';
        preview_urllbl: Label 'preview_url';
        typeLbl: Label 'type';
        templateIdlbl: Label 'templateId';
        parameterValueslbl: Label 'parameterValues';
        headerTitlelbl: Label 'headerTitle';
        shorten_urllbl: Label 'shorten_url';
        recipientlbl: Label 'recipient';
        recipient_typeLbl: Label 'recipient_type';
        toLbl: Label 'to';
        referencelbl: Label 'reference';
        cust_reflbl: Label 'cust_ref';
        messageTag1lbl: Label 'messageTag1';
        conversationIdlbl: Label 'conversationId';
        senderlbl: Label 'sender';
        fromlbl: Label 'from';
        preferenceslbl: Label 'preferences';
        webHookDNIdlbl: Label 'webHookDNId';
        metaDatalbl: Label 'metaData';
        versionlbl: Label 'version';
        Zerolbl: Label '0';
        Onelbl: Label '1';
        Twolbl: Label '2';
        Threelbl: Label '3';
        Fourlbl: Label '4';
        Fivelbl: Label '5';
        Sixlbl: Label '6';
        WABAlbl: Label 'WABA';
        TEMPLATElbl: Label 'TEMPLATE';
        templatevaluelbl: Label 'template';
        duereminderlbl: Label 'bcduefinal1';
        individualLbl: Label 'individual';
        Some_Customer_Reflbl: Label 'Some Customer Ref';
        Message_Tag_Val1lbl: Label 'Message Tag Val1';
        Some_Optional_Conversation_IDlbl: Label 'Some Optional Conversation ID';

        GWhatsAppDataPushDetails: Record "WhatsApp Data Push Details";
        GWhatsAppDataPushDetailsVend: Record "WhatsApp Data Push Details";

}