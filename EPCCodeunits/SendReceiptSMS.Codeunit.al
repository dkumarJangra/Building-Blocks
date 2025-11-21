codeunit 97768 "Send Receipt SMS"
{
    //     // ALLETDK021112-- Modified code to create single entry for Bank and Cash. And modified to create single entry for clearing cheque.
    //     //              -- Added code to create single bank/cheque entry for Cheque bounce.
    //     // 
    //     // BBG1.00 ALLEDK 050313 Code commented for dim-3
    //     // BBG1.00 250613 Added code for SMS
    //     // ALLEPG 180714 : Code modify for password.
    //     // 
    //     // BBG080914 Added code for check the Payment plan details.
    //     // BBG2.01 090115 Added new function for Associate payment window 'PostAssociatePayment'
    //     // //120816 Added code for not creation of buffer entries in case of commission not reversed.
    //     // 061016 DK CreateTDSENTRy Added new function for Special Payment.
    //     // 
    //     // ALLEDK 10112016  Added code for flow of Receipt Line No.


    //     trigger OnRun()
    //     begin
    //         SendSMS(MobileNo1, SMSText1);
    //         MESSAGE('%1..%2', MobileNo1, SMSText1)
    //     end;

    //     var
    //         CompInfo: Record 79;
    //         "------SMS---------": Integer;
    //         HttpWebRequest: DotNet HttpWebRequest;
    //         HttpWebResponse: DotNet HttpWebResponse;
    //         TextString: DotNet String;
    //         Bytes: DotNet Array;
    //         Encoding: DotNet Encoding;
    //         StreamReader: DotNet StreamReader;
    //         ResText: Text;
    //         StringBuilder: DotNet StringBuilder;
    //         StringWriter: DotNet StringWriter;
    //         JSON: DotNet String;
    //         JSONTextWriter: DotNet JsonTextWriter;
    //         MobileNo1: Text[30];
    //         SMSText1: Text[1000];


    //     procedure SendSMS(MobileNo: Text[30]; SMSText: Text[1000])
    //     var
    //         SMSUrl: Text[500];
    //         JSONString: Text;
    //         FinalJSON: Text;
    //     begin
    //         CompInfo.GET;
    //         StringBuilder := StringBuilder.StringBuilder;
    //         StringWriter := StringWriter.StringWriter(StringBuilder);
    //         JSONTextWriter := JSONTextWriter.JsonTextWriter(StringWriter);
    //         JSONTextWriter.WriteStartObject;
    //         CreateJSONAttribute('userName', 'bbgindia1');
    //         CreateJSONAttribute('priority', '0');
    //         CreateJSONAttribute('referenceId', '1241547676');
    //         CreateJSONAttribute('msgType', '1');
    //         CreateJSONAttribute('senderId', 'BBGIND');
    //         CreateJSONAttribute('message', SMSText);
    //         JSONTextWriter.WritePropertyName('mobileNumbers');
    //         JSONTextWriter.WriteStartObject;
    //         JSONTextWriter.WritePropertyName('messageParams');
    //         JSONTextWriter.WriteStartArray;
    //         JSONTextWriter.WriteStartObject;
    //         CreateJSONAttribute('mobileNumber', '91' + MobileNo);
    //         JSONTextWriter.WriteEndObject;
    //         JSONTextWriter.WriteEndArray;
    //         JSONTextWriter.WriteEndObject;
    //         CreateJSONAttribute('password', CompInfo."SMS Password");
    //         JSONTextWriter.WriteEndObject;
    //         JSON := StringBuilder.ToString();
    //         JSONString := FORMAT(JSON);
    //         FinalJSON := JSONString;
    //         //MESSAGE(FinalJSON);

    //         HttpWebRequest := HttpWebRequest.Create('http://api.synapselive.vectramind.in/v1/multichannel/messages/sendsms');
    //         HttpWebRequest.Method := 'POST';
    //         HttpWebRequest.ContentType := 'application/json';
    //         TextString := STRSUBSTNO(FinalJSON);
    //         Encoding := Encoding.UTF8();
    //         Bytes := Encoding.GetEncoding('iso-8859-1').GetBytes(TextString.ToString);
    //         HttpWebRequest.ContentLength := TextString.Length;
    //         HttpWebRequest.GetRequestStream.Write(Bytes, 0, Bytes.Length);
    //         HttpWebResponse := HttpWebRequest.GetResponse;
    //         StreamReader := StreamReader.StreamReader(HttpWebResponse.GetResponseStream);
    //         ResText := StreamReader.ReadToEnd();
    //         StreamReader.Close();
    //         //MESSAGE(ResText);
    //     end;


    //     procedure CreateJSONAttribute(AttributeName: Text; Value: Variant)
    //     begin
    //         JSONTextWriter.WritePropertyName(AttributeName);
    //         JSONTextWriter.WriteValue(Value);
    //     end;


    //     procedure SMSFilters(P_MobileNo: Text[30]; P_SMSText: Text[1000])
    //     begin
    //         MobileNo1 := P_MobileNo;
    //         SMSText1 := P_SMSText;
    //     end;
}

