codeunit 50039 "SMS Log Details"
{

    trigger OnRun()
    begin
    end;

    var
        SMSLogDetails: Record "SMS Log Details";
        EntryNo: Integer;
        userName: Text;
        User: Record User;


    procedure SMSValue(SMSText: Text[250]; SMSText2: Text[250]; PartyTypes: Text; PartyCode: Code[20]; PartyName: Text[100]; FunctionalityName: Text[250]; ProjectID: Code[20]; ProjectName: Text[100]; ApplicationCode: Code[20])
    begin
        EntryNo := 0;
        SMSLogDetails.RESET;
        IF SMSLogDetails.FINDLAST THEN
            EntryNo := SMSLogDetails."Entry No.";

        SMSLogDetails.RESET;
        SMSLogDetails.INIT;
        SMSLogDetails."Entry No." := EntryNo + 1;
        SMSLogDetails."SMS Date" := TODAY;
        SMSLogDetails."SMS Time" := TIME;
        SMSLogDetails."User ID" := USERID;
        SMSLogDetails.Message := SMSText;
        SMSLogDetails."Message 1" := SMSText2;
        IF PartyTypes = 'Customer' THEN
            SMSLogDetails."Party Type" := SMSLogDetails."Party Type"::Customer
        ELSE
            SMSLogDetails."Party Type" := SMSLogDetails."Party Type"::Vendor;
        SMSLogDetails."Party Code" := PartyCode;
        SMSLogDetails."Party Name" := PartyName;
        SMSLogDetails."Function/activity name" := FunctionalityName;
        User.RESET;
        User.SETRANGE("User Name", USERID);
        IF User.FINDFIRST THEN
            SMSLogDetails."User Name" := User."Full Name";
        SMSLogDetails."Project ID" := ProjectID;
        SMSLogDetails."Project Name" := ProjectName;
        SMSLogDetails."LLP Name" := COMPANYNAME;
        SMSLogDetails."Application No." := ApplicationCode;
        SMSLogDetails.INSERT;
    end;
}

