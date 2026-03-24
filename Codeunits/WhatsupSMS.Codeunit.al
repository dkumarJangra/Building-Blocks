codeunit 50225 "DGC Whatsup SMS"
{
    trigger OnRun()
    begin

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
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', WhatsappIntegrationSetup."Header Value");

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
            //Message('Success: ' + ResponseText); // Uncomment if needed
        end else begin
            ResponseMessage.Content.ReadAs(ResponseText);
            //Error('WhatsApp API error (%1): %2', ResponseMessage.HttpStatusCode(), ResponseText);
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
        recipient_typeLbl: Label 'recipient_type';
        toLbl: Label 'to';
        typeLbl: Label 'type';
        templateLbl: Label 'template';
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
        individualLbl: Label 'individual';
        headerlbl: Label 'header';
        documentlbl: Label 'document';
        linklbl: Label 'link';
        filenamelbl: Label 'filename';

}