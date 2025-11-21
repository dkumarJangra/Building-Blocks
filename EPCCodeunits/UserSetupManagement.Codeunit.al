codeunit 97720 "EPC User Setup Management"
{
    Permissions = TableData Location = r,
                  TableData "Responsibility Center 1" = r;

    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'customer';
        Text001: Label 'vendor';
        Text002: Label 'This %1 is related to %2 %3. Your identification is setup to process from %2 %4.';
        Text003: Label 'This document will be processed in your %2.';
        UserSetup: Record "User Setup";
        RespCenter: Record "Responsibility Center 1";
        CompanyInfo: Record "Company Information";
        UserLocation: Code[10];
        UserRespCenter: Code[10];
        SalesUserRespCenter: Code[10];
        PurchUserRespCenter: Code[10];
        ServUserRespCenter: Code[10];
        HasGotSalesUserSetup: Boolean;
        HasGotPurchUserSetup: Boolean;
        HasGotServUserSetup: Boolean;


    procedure GetSalesFilter(): Code[50]
    begin
        EXIT(GetSalesFilter2(USERID));
    end;


    procedure GetPurchasesFilter(): Code[50]
    begin
        EXIT(GetPurchasesFilter2(USERID));
    end;


    procedure GetServiceFilter(): Code[50]
    begin
        EXIT(GetServiceFilter2(USERID));
    end;


    procedure GetSalesFilter2(UserCode: Code[50]): Code[50]
    begin
        IF NOT HasGotSalesUserSetup THEN BEGIN
            CompanyInfo.GET;
            SalesUserRespCenter := CompanyInfo."Responsibility Center";
            UserLocation := CompanyInfo."Location Code";
            IF (UserSetup.GET(UserCode)) AND (UserCode <> '') THEN
                IF UserSetup."Sales Resp. Ctr. Filter" <> '' THEN
                    SalesUserRespCenter := UserSetup."Sales Resp. Ctr. Filter";
            HasGotSalesUserSetup := TRUE;
        END;
        EXIT(SalesUserRespCenter);
    end;


    procedure GetPurchasesFilter2(UserCode: Code[50]): Code[50]
    begin
        IF NOT HasGotPurchUserSetup THEN BEGIN
            CompanyInfo.GET;
            PurchUserRespCenter := CompanyInfo."Responsibility Center";
            UserLocation := CompanyInfo."Location Code";
            IF (UserSetup.GET(UserCode)) AND (UserCode <> '') THEN
                IF UserSetup."Purchase Resp. Ctr. Filter" <> '' THEN
                    PurchUserRespCenter := UserSetup."Purchase Resp. Ctr. Filter";
            HasGotPurchUserSetup := TRUE;
        END;
        EXIT(PurchUserRespCenter);
    end;


    procedure GetServiceFilter2(UserCode: Code[50]): Code[50]
    begin
        IF NOT HasGotServUserSetup THEN BEGIN
            CompanyInfo.GET;
            ServUserRespCenter := CompanyInfo."Responsibility Center";
            UserLocation := CompanyInfo."Location Code";
            IF (UserSetup.GET(UserCode)) AND (UserCode <> '') THEN
                IF UserSetup."Service Resp. Ctr. Filter" <> '' THEN
                    ServUserRespCenter := UserSetup."Service Resp. Ctr. Filter";
            HasGotServUserSetup := TRUE;
        END;
        EXIT(ServUserRespCenter);
    end;


    procedure GetRespCenter(DocType: Option Sales,Purchase,Service; AccRespCenter: Code[10]): Code[10]
    var
        AccType: Text[50];
    begin
        CASE DocType OF
            DocType::Sales:
                BEGIN
                    AccType := Text000;
                    UserRespCenter := GetSalesFilter;
                END;
            DocType::Purchase:
                BEGIN
                    AccType := Text001;
                    UserRespCenter := GetPurchasesFilter;
                END;
            DocType::Service:
                BEGIN
                    AccType := Text000;
                    UserRespCenter := GetServiceFilter;
                END;
        END;
        IF (AccRespCenter <> '') AND
           (UserRespCenter <> '') AND
           (AccRespCenter <> UserRespCenter)
        THEN
            MESSAGE(
              Text002 +
              Text003,
              AccType, RespCenter.TABLECAPTION, AccRespCenter, UserRespCenter);
        IF UserRespCenter = '' THEN
            EXIT(AccRespCenter)
        ELSE
            EXIT(UserRespCenter);
    end;


    procedure CheckRespCenter(DocType: Option Sales,Purchase,Service; AccRespCenter: Code[10]): Boolean
    begin
        EXIT(CheckRespCenter2(DocType, AccRespCenter, USERID));
    end;


    procedure CheckRespCenter2(DocType: Option Sales,Purchase,Service; AccRespCenter: Code[20]; UserCode: Code[20]): Boolean
    begin
        CASE DocType OF
            DocType::Sales:
                UserRespCenter := GetSalesFilter2(UserCode);
            DocType::Purchase:
                UserRespCenter := GetPurchasesFilter2(UserCode);
            DocType::Service:
                UserRespCenter := GetServiceFilter2(UserCode);
        END;
        IF (UserRespCenter <> '') AND
           (AccRespCenter <> UserRespCenter)
        THEN
            EXIT(FALSE)
        ELSE
            EXIT(TRUE);
    end;


    procedure GetLocation(DocType: Option Sales,Purchase,Service; AccLocation: Code[10]; RespCenterCode: Code[10]): Code[10]
    begin
        CASE DocType OF
            DocType::Sales:
                UserRespCenter := GetSalesFilter;
            DocType::Purchase:
                UserRespCenter := GetPurchasesFilter;
            DocType::Service:
                UserRespCenter := GetServiceFilter;
        END;
        IF UserRespCenter <> '' THEN
            RespCenterCode := UserRespCenter;
        IF RespCenter.GET(RespCenterCode) THEN
            IF RespCenter."Location Code" <> '' THEN
                UserLocation := RespCenter."Location Code";
        IF AccLocation <> '' THEN
            EXIT(AccLocation)
        ELSE
            EXIT(UserLocation);
    end;
}

