codeunit 50016 "Get Pmt ID Status from Server"
{
    // UpdatePaymentStatus - ) transaction_id, Pg_Status,Pg_Amount,Associate_ID -> response Success, FAil

    TableNo = "Payment transaction Details";

    trigger OnRun()
    var
        PaymentIds: Text;
        UnitMaster: Record "Unit Master";
    begin
        PaymenttransactionDetails.RESET;
        PaymenttransactionDetails.SETRANGE("Entry No.", EntryNo_2);
        PaymenttransactionDetails.SETFILTER("Payment Server Status", '%1', 'paid');
        IF PaymenttransactionDetails.FINDSET THEN
            REPEAT
                PmtTransDetails.RESET;
                PmtTransDetails.SETRANGE("Entry No.", PaymenttransactionDetails."Entry No.");
                IF PmtTransDetails.FINDFIRST THEN BEGIN
                    PaymentIds := '';
                    PaymentIds := CallPaymentID(PmtTransDetails."Unique Payment Order ID");
                    PmtTransDetails."Payment ID" := PaymentIds;
                    PmtTransDetails."Update By Batch" := TRUE;
                    PmtTransDetails.MODIFY;
                END;
            UNTIL PaymenttransactionDetails.NEXT = 0;
    end;

    var
        PaymenttransactionDetails: Record "Payment transaction Details";
        PmtTransDetails: Record "Payment transaction Details";
        // StreamWriter: DotNet StreamWriter;
        // StreamReader: DotNet StreamReader;
        EntryNo_2: Integer;


    procedure CallPaymentID(vPmtOrderId: Text): Text
    var
        WebServiceURL: Label '/TravelWebServices/Amadeus.asmx';
        ContentType: Label 'text/xml; charset=UTF-8';
        SoapAction: Label '/CallRazorPay';
        Text001: Label '<?xml version="1.0" encoding="UTF-8"?>';
        Text002: Label '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">';
        Text003: Label '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">';
        // WebRequest: DotNet HttpWebRequest;
        // WebResponse: DotNet HttpWebResponse;
        // StreamWriter: DotNet StreamWriter;
        TxtCompanyName: Text;
        // JsonConvert: DotNet JsonConvert;
        // JsonFormating: DotNet Formatting;
        Result: Text;
        //JObject: DotNet JObject;
        xmloutstream: OutStream;
        ResponseText1: Text;
        startposInt: Integer;
        EndPosInt: Integer;
        NewString: Text;
        Jtext: Text;
        Jtext2: Text;
        AmountLength: Integer;
        CustPaymentAmt: Integer;
        //JObject2: DotNet JObject;
        Jtext3: Text;
    begin
        //WebRequest := WebRequest.Create('http://localhost/RazorPayIntegration/RazorPay.asmx');
        // WebRequest := WebRequest.Create('http://52.172.215.206:44419/RazorPay.asmx');
        // WebRequest.Method := 'POST';
        // WebRequest.Timeout := 1000 * 60 * 10;
        // WebRequest.ContentType := 'text/xml; charset=utf-8';
        // WebRequest.PreAuthenticate := FALSE; //TRUE;
        // StreamWriter := StreamWriter.StreamWriter(WebRequest.GetRequestStream);
        // StreamWriter.Write('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">');
        // StreamWriter.Write('<Body>');
        // StreamWriter.Write('<CallFatchPaymentDetails xmlns="http://tempuri.org/">');
        // StreamWriter.Write('<OrderNo>' + vPmtOrderId + '</OrderNo>');
        // StreamWriter.Write('</CallFatchPaymentDetails>');
        // StreamWriter.Write('</Body>');
        // StreamWriter.Write('</Envelope>');
        // StreamWriter.Close();
        // WebResponse := WebRequest.GetResponse();
        // StreamReader := StreamReader.StreamReader(WebResponse.GetResponseStream);
        // ResponseText1 := StreamReader.ReadToEnd;
        startposInt := STRPOS(ResponseText1, '{');
        EndPosInt := STRPOS(ResponseText1, '}<');
        NewString := COPYSTR(ResponseText1, startposInt, EndPosInt - startposInt + 1);
        Jtext := NewString;


        IF Jtext <> '' THEN BEGIN
            // JObject := JObject.Parse(Jtext);
            // Jtext2 := JObject.GetValue('items').ToString;  //Pass the value of node in GetValue
            // Jtext2 := DELCHR(Jtext2, '=', '[]');
            // JObject2 := JObject2.Parse(Jtext2);
            // Jtext3 := JObject2.GetValue('id').ToString;  //Pass the value of node in GetValue
        END;
        EXIT(Jtext3);
    end;


    procedure Setfilteres(EntryNo_1: Integer)
    begin
        EntryNo_2 := EntryNo_1;
    end;
}

