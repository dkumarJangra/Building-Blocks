codeunit 50061 "Data Push to OnLine Master"
{

    trigger OnRun()
    var
        DataExch1: Record "Data Exch. Field";
        ResponseInStream_L: InStream;
        //HttpStatusCode_L: DotNet HttpStatusCode;
        //ResponseHeaders_L: DotNet NameValueCollection;
        ResponseText: Text;
        FL: File;
        AAAAA: BigText;
    begin
        UpdateUnitStatus;
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
        NewUnitmasters: Record "Unit Master";
        OldWebLogDetails: Record "Web Log Details";
        WebLogDetails: Record "Web Log Details";
        NewConfirmedOrder_4: Record "New Confirmed Order";
        //Updationofplotdetails: Record 60800;
        NoofDays: Text;
        Applicationfind: Boolean;
        UnitPaymentDueDaysupdate: Codeunit "Updation of plot details";
        NoofDaysInteger: Integer;
        Customers: Record Customer;


    procedure SetUnitMaster(NewUnitmasters_2: Record "Unit Master")
    begin
        NewUnitmasters := NewUnitmasters_2;
    end;


    procedure UpdateUnitStatus()
    var
        Post_JSONString: Text;
        Post_FinalJSON: Text;
        NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        TotalAmt: Decimal;
        NewConfirmedorder_2: Record "New Confirmed Order";
        JArray: JsonArray;
        CustObject: JsonObject;
        JsonObject: JsonObject;
        JsonData_1: Text;
        ShiptoObject: JsonObject;
        JsonData: Text;
        DotNetEncodeing: Codeunit DotNet_Encoding;
        DotNetArray: Codeunit DotNet_Array;
        DotNetArrayBytes: Codeunit DotNet_Array;
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
        StatusValue: Text;
        Unitsetup: Record "Unit Setup";
        Companyinformation: Record "Company Information";
        CompamywiseGL: Record "Company wise G/L Account";
        status: text[1020];

    begin

        //NewUnitmasters.GET('GS4/E/P2-0142');
        //Message('%1..%2', CurrentDateTime, '1');
        NoofDays := '';
        Applicationfind := FALSE;
        NoofDaysInteger := 0;
        IF NewUnitmasters."No." <> '' THEN BEGIN
            IF (NOT NewUnitmasters.Reserve) AND (NewUnitmasters.Status = NewUnitmasters.Status::Blocked) THEN BEGIN

                Clear(CustObject);

                CustObject.Add('projectId', NewUnitmasters."Project Code");
                CustObject.Add('plotNo', NewUnitmasters."No.");
                CustObject.Add('status', '5');
                CustObject.Add('facing', '0');
                CustObject.Add('customerName', '');
                CustObject.Add('saleableArea', '');
                CustObject.Add('sizeEast', '');
                CustObject.Add('sizeWest', '');
                CustObject.Add('sizeNorth', '');
                CustObject.Add('sizeSouth', '');
                CustObject.Add('postingDate', '');
                CustObject.Add('paymentPlan', '');
                CustObject.Add('unitPaymentPlan', '');
                CustObject.Add('amount', '');
                CustObject.Add('netDueAmount', '');
                CustObject.Add('paidAmount', '');
                CustObject.Add('mortgage', '0');
                CustObject.Add('remainingDays', '0');
                CustObject.WriteTo(Post_FinalJSON);

            END ELSE BEGIN
                Clear(CustObject);

                CustObject.Add('projectId', NewUnitmasters."Project Code");
                CustObject.Add('plotNo', NewUnitmasters."No.");
                IF NewUnitmasters.Status = NewUnitmasters.Status::Open THEN
                    StatusValue := '0'  //260225 Added new code 
                ELSE
                    IF NewUnitmasters.Status = NewUnitmasters.Status::Blocked THEN
                        StatusValue := '1'  //260225 Added new code 
                    ELSE
                        IF NewUnitmasters.Status = NewUnitmasters.Status::Booked THEN
                            StatusValue := '2'  //260225 Added new code 
                        ELSE
                            IF NewUnitmasters.Status = NewUnitmasters.Status::Registered THEN
                                StatusValue := '3'  //260225 Added new code 
                            ELSE
                                IF NewUnitmasters.Status = NewUnitmasters.Status::Transfered THEN
                                    StatusValue := '4';  //260225 Added new code 
                //260225 Added new code Start

                Unitsetup.GET;
                IF Not Unitsetup."Stop Change color on Plot" THEN begin

                    If StatusValue = '2' THEN begin
                        //Message('%1..%2', CurrentDateTime, '2');
                        TotalAmt := 0;
                        NewConfirmedorder_2.RESET;
                        NewConfirmedorder_2.SETRANGE("Unit Code", NewUnitmasters."No.");
                        IF NewConfirmedorder_2.FINDFIRST THEN BEGIN
                            NewApplicationPaymentEntry.RESET;
                            NewApplicationPaymentEntry.SETRANGE("Document No.", NewConfirmedorder_2."No.");
                            NewApplicationPaymentEntry.SETFILTER("Cheque Status", '<>%1', NewApplicationPaymentEntry."Cheque Status"::Bounced);
                            IF NewApplicationPaymentEntry.FINDSET THEN
                                REPEAT
                                    TotalAmt := TotalAmt + NewApplicationPaymentEntry.Amount;
                                UNTIL NewApplicationPaymentEntry.NEXT = 0;

                            IF (NewConfirmedorder_2.Amount - TotalAmt) <= 0 THEN
                                StatusValue := '6';

                        END;
                        //Message('%1..%2', CurrentDateTime, '3');
                    END;
                END;

                //260225 Added new code End

                CustObject.Add('status', StatusValue);   //260225 Added new code 

                IF NewUnitmasters.Facing = NewUnitmasters.Facing::NA THEN
                    CustObject.Add('facing', '0')
                ELSE
                    IF NewUnitmasters.Facing = NewUnitmasters.Facing::East THEN
                        CustObject.Add('facing', '1')
                    ELSE
                        IF NewUnitmasters.Facing = NewUnitmasters.Facing::West THEN
                            CustObject.Add('facing', '2')
                        ELSE
                            IF NewUnitmasters.Facing = NewUnitmasters.Facing::North THEN
                                CustObject.Add('facing', '3')
                            ELSE
                                IF NewUnitmasters.Facing = NewUnitmasters.Facing::South THEN
                                    CustObject.Add('facing', '4')
                                ELSE
                                    IF NewUnitmasters.Facing = NewUnitmasters.Facing::NorthWest THEN
                                        CustObject.Add('facing', '5')
                                    ELSE
                                        IF NewUnitmasters.Facing = NewUnitmasters.Facing::SouthEast THEN
                                            CustObject.Add('facing', '6')
                                        ELSE
                                            IF NewUnitmasters.Facing = NewUnitmasters.Facing::NorthEast THEN
                                                CustObject.Add('facing', '7')
                                            ELSE
                                                IF NewUnitmasters.Facing = NewUnitmasters.Facing::SouthWest THEN
                                                    CustObject.Add('facing', '8');

                NewConfirmedOrder_4.RESET;
                NewConfirmedOrder_4.SETRANGE("Unit Code", NewUnitmasters."No.");
                IF NewConfirmedOrder_4.FINDFIRST THEN BEGIN
                    Customers.RESET;
                    IF Customers.GET(NewConfirmedOrder_4."Customer No.") THEN;
                    Applicationfind := TRUE;
                    CustObject.Add('customerName', Customers.Name);
                END ELSE
                    CustObject.Add('customerName', NewUnitmasters."Customer Name");
                //Message('%1..%2', CurrentDateTime, '4');


                CustObject.Add('saleableArea', NewUnitmasters."Saleable Area");
                CustObject.Add('sizeEast', NewUnitmasters."Size-East");
                CustObject.Add('sizeWest', NewUnitmasters."Size-West");
                CustObject.Add('sizeNorth', NewUnitmasters."Size-North");
                CustObject.Add('sizeSouth', NewUnitmasters."Size-South");
                CustObject.Add('postingDate', FORMAT(CURRENTDATETIME, 0, '<Day,2>/<Month,2>/<Year4>'));
                CustObject.Add('paymentPlan', NewUnitmasters."Payment Plan");
                TotalAmt := 0;
                NewConfirmedorder_2.RESET;
                NewConfirmedorder_2.SETRANGE("Unit Code", NewUnitmasters."No.");
                IF NewConfirmedorder_2.FINDFIRST THEN BEGIN
                    NewApplicationPaymentEntry.RESET;
                    NewApplicationPaymentEntry.SETRANGE("Document No.", NewConfirmedorder_2."No.");
                    NewApplicationPaymentEntry.SETFILTER("Cheque Status", '<>%1', NewApplicationPaymentEntry."Cheque Status"::Bounced);
                    IF NewApplicationPaymentEntry.FINDSET THEN
                        REPEAT

                            TotalAmt := TotalAmt + NewApplicationPaymentEntry.Amount;
                        UNTIL NewApplicationPaymentEntry.NEXT = 0;
                    //Message('%1..%2', CurrentDateTime, '5');
                    CustObject.Add('unitPaymentPlan', '');
                    CustObject.Add('amount', NewConfirmedorder_2.Amount);
                    IF (NewConfirmedorder_2.Amount - TotalAmt) < 0 THEN
                        CustObject.Add('netDueAmount', '0.00')
                    ELSE
                        CustObject.Add('netDueAmount', NewConfirmedorder_2.Amount - TotalAmt);
                    CustObject.Add('paidAmount', TotalAmt);
                END ELSE BEGIN
                    CustObject.Add('unitPaymentPlan', '');
                    CustObject.Add('amount', '0.00');
                    CustObject.Add('netDueAmount', '0.00');
                    CustObject.Add('paidAmount', '0.00');

                END;
                IF NewUnitmasters.Mortgage THEN
                    CustObject.Add('mortgage', '1')
                ELSE
                    CustObject.Add('mortgage', '0');
                IF Applicationfind THEN BEGIN

                    CLEAR(UnitPaymentDueDaysupdate);
                    NoofDaysInteger := UnitPaymentDueDaysupdate.UpdateNoofDays(NewConfirmedOrder_4);
                    NoofDays := FORMAT(NoofDaysInteger);
                    CustObject.Add('remainingDays', NoofDays);
                END ELSE
                    CustObject.Add('remainingDays', '0');
                //Message('%1..%2', CurrentDateTime, '6');
                CustObject.WriteTo(Post_FinalJSON);

            END;

            //Message('%1', Post_FinalJSON);

            EntryNo := 0;
            OldWebLogDetails.RESET;
            IF OldWebLogDetails.FINDLAST THEN
                EntryNo := OldWebLogDetails."Entry No.";

            WebLogDetails.INIT;
            WebLogDetails."Entry No." := EntryNo + 1;
            WebLogDetails."Request Date" := TODAY;
            WebLogDetails."Request Time" := TIME;
            WebLogDetails."Request Description" := COPYSTR(Post_FinalJSON, 1, 1024);
            WebLogDetails."Request Description 2" := COPYSTR(Post_FinalJSON, 1025, 1024);
            WebLogDetails."Function Name" := 'UpdateUnitStatus';
            WebLogDetails.INSERT;
            COMMIT;

            CompamywiseGL.RESET;
            CompamywiseGL.SetRange("MSC Company", True);
            If CompamywiseGL.FindFirst() THEN begin
                Companyinformation.RESET;
                Companyinformation.ChangeCompany(CompamywiseGL."Company Code");
                Companyinformation.GET;
            end;
            //Message('%1..%2', CurrentDateTime, '7');
            IF NOT Companyinformation."Stop Data Push to WebApp" then BEGIN
                Headers := Client.DefaultRequestHeaders();
                TextString := STRSUBSTNO(Post_FinalJSON);
                Bytes := cu.Convert(1200, 28591, TextString);
                RequestUrl := 'https://gis.bbgindia.com:3110/updaterecord';
                Request.Method := 'POST';
                Content.WriteFrom(Bytes);
                content.GetHeaders(Headers);

                Headers.Remove('Content-Type');
                Headers.Add('Content-Type', 'application/json; charset=utf-8');
                Client.UseServerCertificateValidation(false);  //19082025 added new code
                Client.Post(RequestUrl, Content, HttpWebResponse);
                HttpWebResponse.Content.ReadAs(Post_ResText);

            END ELSE BEGIN

                Post_ResText := 'Stop Send Data to Web App';
            END;
            //Message('%1..%2', CurrentDateTime, '8');

            WebLogDetails."Response Description" := COPYSTR(Post_ResText, 1, 1024);
            WebLogDetails."Response Description 2" := COPYSTR(Post_ResText, 1025, 1024);
            WebLogDetails."Response Date" := TODAY;
            WebLogDetails."Response Time" := TIME;
            WebLogDetails.MODIFY;
        END;
    end;


}

