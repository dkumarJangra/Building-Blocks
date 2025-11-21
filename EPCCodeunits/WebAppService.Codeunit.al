codeunit 50003 "Web App Service"
{

    procedure UpdateUnitStatus(NewUnitmasters: Record "Unit Master"): Text
    Var
        OldUnitMasterLog: record "unit master log";
        VersionNo: integer;
        UnitMasterLog: record "Unit master log";
        DataPushtoOnLineMaster: codeunit "Data Push to OnLine Master";
    Begin


        //240724 Added new code start
        OldUnitMasterLog.RESET;
        OldUnitMasterLog.SETCURRENTKEY("No.", Version);
        OldUnitMasterLog.SETRANGE("No.", NewUnitmasters."No.");
        //OldUnitMasterLog.SETRANGE("Project Code",NewUnitmasters."Project Code");
        IF OldUnitMasterLog.FINDLAST THEN
            VersionNo := OldUnitMasterLog.Version
        ELSE
            VersionNo := 1;
        UnitMasterLog.INIT;
        UnitMasterLog."No." := NewUnitmasters."No.";
        UnitMasterLog.Status := NewUnitmasters.Status;
        UnitMasterLog."Project Code" := NewUnitmasters."Project Code";
        //UnitMasterLog.TRANSFERFIELDS(NewUnitmasters);
        UnitMasterLog.Version := VersionNo + 1;
        UnitMasterLog."Creation Date" := TODAY;
        UnitMasterLog."User ID" := USERID;
        UnitMasterLog."Creation Time" := TIME;
        UnitMasterLog.INSERT;
        //240724 Added new code End
        COMMIT;

        CLEAR(DataPushtoOnLineMaster);
        DataPushtoOnLineMaster.SetUnitMaster(NewUnitmasters);
        IF NOT DataPushtoOnLineMaster.RUN THEN BEGIN
        END;

    END;

    procedure Post_data(secret_key: Text; navision_id: Code[20]; name: Text; mobile: Text; email: Text; team_name: Text; leader_code: Text; parent_code: Code[20]; status: Text; rank_code: Text; rank_description: Text): Text
    var
        Post_JSONString: Text;
        Post_FinalJSON: Text;
        JArray: JsonArray;
        CustObject: JsonObject;
        JsonObject: JsonObject;
        ShiptoObject: JsonObject;
        JsonData: Text;
        JsonData_1: Text;
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
        Post_ResText: text;
        WebLogDetails: Record "Web Log Details";
        OldWebLogDetails: Record "Web Log Details";
        EntryNo: Integer;

    begin

        Clear(CustObject);
        CustObject.Add('secret_key', 'U5Ga0Z1aaNlYHp0MjdEdXJ1aKVVVB1TP');
        CustObject.Add('navision_id', navision_id);
        CustObject.Add('name', name);
        CustObject.Add('mobile', mobile);
        CustObject.Add('email', email);
        CustObject.Add('team_name', team_name);
        CustObject.Add('leader_code', leader_code);
        CustObject.Add('parent_code', parent_code);
        CustObject.Add('status', status);
        CustObject.Add('rank_code', rank_code);
        CustObject.Add('rank_description', rank_description);
        CustObject.WriteTo(Post_FinalJSON);
        //070425 Added Jiva Log Start
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
        WebLogDetails."Function Name" := 'Push_JivaData';
        WebLogDetails.INSERT;
        //070425 Added Jiva Log End

        Headers := Client.DefaultRequestHeaders();
        TextString := STRSUBSTNO(Post_FinalJSON);
        Bytes := cu.Convert(1200, 28591, TextString);
        RequestUrl := 'https://bbgjiva.com/api/navision_associate';
        Request.Method := 'POST';
        Content.WriteFrom(Bytes);
        content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/json; charset=utf-8');
        Client.Post(RequestUrl, Content, HttpWebResponse);
        if HttpWebResponse.IsSuccessStatusCode then begin
            HttpWebResponse.Content.ReadAs(Post_ResText);
            //                Message(JsonResponse);
        End Else begin
            HttpWebResponse.Content.ReadAs(Post_ResText);
            //              Message(RespMsg);
        end;

        //070425 Added Jiva Log Start
        WebLogDetails."Response Date" := TODAY;
        WebLogDetails."Response Description" := COPYSTR(FORMAT(Post_ResText), 1, 1024);
        WebLogDetails."Response Description 2" := COPYSTR(FORMAT(Post_ResText), 1025, 1024);
        WebLogDetails."Response Time" := TIME;
        WebLogDetails.MODIFY;
        //070425 Added Jiva Log End


    end;



}

