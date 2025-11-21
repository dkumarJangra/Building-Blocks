codeunit 97733 "Portal Web Service"
{
    // ALLE_RM_030413:
    //   Added Code for Project Details.


    trigger OnRun()
    begin
    end;

    var
        PortalLoginInfo: Record "Portal Login";
        UnitMaster: Record "Unit Master";
        PlotAllocation: Record "Plot Allocation";
        PlotSetting: Record "Plot Configuration Setting";


    // procedure ValidateLogin(Type: Text[30]; PortalUserID: Text[80]; Password: Text[30]; var PortalLoginDetails: XMLport 50006): Boolean
    // var
    //     pLoginType: Option;
    // begin
    //     EVALUATE(pLoginType, Type);
    //     PortalLoginInfo.SETRANGE("Login Type", pLoginType);
    //     PortalLoginInfo.SETRANGE(UserID, PortalUserID);
    //     PortalLoginInfo.SETRANGE(Password, Password);
    //     PortalLoginInfo.SETRANGE(Approved, TRUE);
    //     IF PortalLoginInfo.FINDFIRST THEN BEGIN
    //         PortalLoginDetails.SETTABLEVIEW(PortalLoginInfo);
    //         PortalLoginDetails.EXPORT;
    //         EXIT(TRUE);
    //     END ELSE
    //         EXIT(FALSE);
    // end;


    // procedure CreateLogin(PortalLogin: XMLport 50003): Boolean
    // begin
    //     IF PortalLogin.IMPORT THEN
    //         EXIT(TRUE)
    //     ELSE
    //         EXIT(FALSE);
    // end;


    // procedure ChangePassword(PortalChangePassword: XMLport 50004): Boolean
    // begin
    //     IF PortalChangePassword.IMPORT THEN
    //         EXIT(TRUE)
    //     ELSE
    //         EXIT(FALSE);
    // end;


    // procedure ForgotPassword(PortalForgotPassword: XMLport 50005; var pUserID: Text[80]; var pPassword: Text[50]): Boolean
    // var
    //     AccountUserID: Text[80];
    //     AccountPassword: Text[50];
    // begin
    //     IF PortalForgotPassword.IMPORT THEN BEGIN
    //         PortalForgotPassword.GetLoginDetails(pUserID, pPassword);
    //         EXIT(TRUE);
    //     END ELSE
    //         EXIT(FALSE);
    // end;


    // procedure CreatePlotAllocation(PlotAllocation: XMLport 50007): Boolean
    // begin
    //     IF PlotAllocation.IMPORT THEN
    //         EXIT(TRUE)
    //     ELSE
    //         EXIT(FALSE);
    // end;


    procedure CancelPlotAllocation(PlotID: Code[50]): Boolean
    begin
        PlotAllocation.SETRANGE(PlotAllocation.Plot_ID, PlotID);
        IF PlotAllocation.FINDFIRST THEN BEGIN
            PlotAllocation.DELETE(TRUE);
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE);
    end;


    procedure GetUnitDetails(var UnitDetails: XMLport "Unit Master"; ProjectCode: Code[30])
    begin
        UnitMaster.RESET;
        UnitMaster.SETRANGE("Project Code", ProjectCode);
        UnitMaster.SETRANGE("Non Usable", FALSE);
        IF UnitMaster.FINDSET THEN BEGIN
            REPEAT
                PlotAllocation.RESET;
                PlotAllocation.SETRANGE(Plot_Number, UnitMaster."No.");
                IF NOT PlotAllocation.FINDFIRST THEN
                    UnitDetails.SetunitMaster(UnitMaster);
            UNTIL UnitMaster.NEXT = 0;
            UnitDetails.EXPORT;
        END
    end;


    procedure ApproveUser(pUserID: Text[80]; Status: Text[5]): Boolean
    begin
        PortalLoginInfo.RESET;
        PortalLoginInfo.SETRANGE(PortalLoginInfo.UserID, pUserID);
        IF PortalLoginInfo.FINDFIRST THEN BEGIN
            IF Status = 'true' THEN
                PortalLoginInfo.Approved := TRUE
            ELSE
                IF Status = 'false' THEN
                    PortalLoginInfo.Approved := FALSE;
            IF PortalLoginInfo.MODIFY THEN
                EXIT(TRUE);
        END ELSE
            EXIT(FALSE);
    end;


    procedure DeletePlotAllocations("Project ID": Code[30]): Boolean
    begin
        PlotAllocation.RESET;
        PlotAllocation.SETRANGE(ProjectID, "Project ID");
        IF PlotAllocation.FINDFIRST THEN BEGIN
            PlotAllocation.DELETEALL;
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE);
    end;


    // procedure CreatePlotSetting("Plot Config. Setting": XMLport 50009): Boolean
    // begin
    //     IF "Plot Config. Setting".IMPORT THEN
    //         EXIT(TRUE)
    //     ELSE
    //         EXIT(FALSE);
    // end;


    procedure ShowPlotSetting("Project ID": Code[30]; var "Plot Config. Setting": XMLport "View Plot Settings"): Boolean
    begin
        PlotSetting.RESET;
        PlotSetting.SETRANGE(ProjectID, "Project ID");
        IF PlotSetting.FINDFIRST THEN BEGIN
            "Plot Config. Setting".SETTABLEVIEW(PlotSetting);
            "Plot Config. Setting".EXPORT;
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE);
    end;


    procedure GetProjectDetails(Type: Option Customer,Vendor,Administrator; var ProjectDetails: XMLport "Responsibility Center"): Boolean
    var
        RespCenter: Record "Responsibility Center 1";
    begin
        IF Type = 0 THEN BEGIN
            RespCenter.RESET;
            RespCenter.SETRANGE(Blocked, FALSE);
            RespCenter.SETRANGE(Published, TRUE);
            IF RespCenter.FINDFIRST THEN BEGIN
                ProjectDetails.SETTABLEVIEW(RespCenter);
                ProjectDetails.EXPORT;
                EXIT(TRUE);
            END ELSE
                EXIT(FALSE);
        END ELSE
            IF Type = 2 THEN BEGIN
                RespCenter.RESET;
                RespCenter.SETRANGE(Blocked, FALSE);
                RespCenter.SETCURRENTKEY("Company Name");
                IF RespCenter.FINDFIRST THEN BEGIN
                    ProjectDetails.SETTABLEVIEW(RespCenter);
                    ProjectDetails.EXPORT;
                    EXIT(TRUE);
                END ELSE
                    EXIT(FALSE);
            END;
    end;
}

