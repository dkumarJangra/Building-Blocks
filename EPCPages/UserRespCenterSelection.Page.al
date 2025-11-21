page 97786 "User Resp. Center Selection"
{
    Caption = 'User Responsibility Center Selection';
    PageType = StandardDialog;
    ApplicationArea = all;
    UsageCategory = Administration;
    layout
    {
        area(content)
        {
            group(Welcome)
            {
                Caption = 'Welcome, Please Select Responsibility Center.';
                field("UserID"; USERID)
                {
                    ApplicationArea = all;
                    Caption = 'User ID';
                    ColumnSpan = 2;
                    Editable = false;
                    Enabled = false;
                    QuickEntry = false;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the User ID field.';
                }
                field(RespCenterCode; RespCenterCode)
                {
                    ApplicationArea = all;
                    Caption = 'Resp. Center Code';
                    QuickEntry = false;
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the value of the Resp. Center Code field.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        UserRespCenterSetup.RESET();
                        UserRespCenterSetup.SETRANGE("User ID", USERID);
                        UserRespCenterSetup.SETFILTER("Responsibility Center", '<>%1', '');
                        IF UserRespCenterSetup.FINDFIRST() THEN BEGIN
                            IF PAGE.RUNMODAL(PAGE::"User Resp center Setup", UserRespCenterSetup) = ACTION::LookupOK THEN
                                RespCenterCode := UserRespCenterSetup."Responsibility Center";
                            IF ResponsibilityCenter.GET(RespCenterCode) THEN;
                        END;
                    end;
                }
                field(UserName; User."Full Name")
                {
                    ApplicationArea = all;
                    Caption = 'User Name';
                    Editable = false;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the User Name field.';
                }
                field(ResponsibilityCenterName; ResponsibilityCenter.Name)
                {
                    ApplicationArea = all;
                    Caption = 'Resp. Center Name';
                    Editable = false;
                    Enabled = false;
                    QuickEntry = false;
                    ToolTip = 'Specifies the value of the Resp. Center Name field.';
                }
            }
        }
        area(factboxes)
        {
            // part("Company Information Card Part"; "Company Information Card Part")
            // {
            //     ApplicationArea = all;
            // }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        UpdateInfo();
    end;

    trigger OnOpenPage()
    begin
        //EPC2016Upgrade
        //  CurrPage.EDITABLE := UserSetupMgmt.CanEditMasters(USERID);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        ClientMgt: Codeunit "Client Type Management";
    // "Client Management";
    begin
        // IF NOT ClientMgt.IsSuperUser(USERID) THEN
        //  IF RespCenterCode = '' THEN  alledk 230922
        //   ERROR('Please select Responsibility Center Code.');   alledk 230922 code comment

        //IF CloseAction = ACTION::LookupOK THEN
        IF CloseAction IN [ACTION::LookupOK, ACTION::OK] THEN
            LookupOKOnPush();
        CompanyInfoCart.Update();
    end;

    var
        CompanyInfo: Record "Company Information";
        User: Record User;
        UserSetup: Record "User Setup";
        //EPCAdminPage: Page "EPC  Admin Role Center";
        ResponsibilityCenter: Record "Responsibility Center 1";
        UserRespCenterSetup: Record "User Res. Center Setup";// "AXT User Res. Center Setup";
        Text001Lbl: Label 'You do not have permissions for responsibility center %1.\Contact your system administrator if you need to have your permissions changed.';
        RespCenterCode: Code[20];
        Flag: Boolean;
        SalesResCenterCode: Code[20];
        PurchResCenterCode: Code[20];
        CompanyInfoCart: Page "Company Information Card Part";
    //UserSetupMgmt: Codeunit "User Setup Management";


    procedure UpdateInfo()
    begin
        //CompanyInfo.GET(); //AR
        IF CompanyInfo.GET() THEN;//AR
        CompanyInfo.CALCFIELDS(Picture);

        User.RESET();
        User.SETCURRENTKEY("User Name");
        User.SETRANGE("User Name", USERID);
        IF User.FINDFIRST() THEN;

        UserSetup.GET(USERID);
        RespCenterCode := UserSetup."Responsibility Center";// "AXT Responsibility Center";
        IF ResponsibilityCenter.GET(RespCenterCode) THEN;
    end;

    local procedure LookupOKOnPush()
    var
    //ClientMgt: Codeunit "Dept. Document Mgt.";// "AXT Client Management";
    begin
        // IF ClientMgt.IsSuperUser(USERID) THEN
        //     IF RespCenterCode = '' THEN
        //         EXIT;

        IF UserRespCenterSetup.GET(USERID, RespCenterCode) THEN BEGIN
            IF UserSetup.GET(USERID) THEN BEGIN
                UserSetup."Responsibility Center" := RespCenterCode;
                UserSetup."Purchase Resp. Ctr. Filter" := RespCenterCode;
                UserSetup."Sales Resp. Ctr. Filter" := RespCenterCode;
                UserSetup."Shortcut Dimension 2 Code" := ResponsibilityCenter."Global Dimension 2 Code"; //ALLE ANSH NTPC
                UserSetup.MODIFY();
                SalesResCenterCode := UserSetup."Sales Resp. Ctr. Filter";
                PurchResCenterCode := UserSetup."Purchase Resp. Ctr. Filter";
            END ELSE BEGIN
                UserSetup.INIT();
                UserSetup."User ID" := USERID;
                UserSetup."Responsibility Center" := RespCenterCode;
                UserSetup."Purchase Resp. Ctr. Filter" := RespCenterCode;
                UserSetup."Sales Resp. Ctr. Filter" := RespCenterCode;
                UserSetup."Shortcut Dimension 2 Code" := ResponsibilityCenter."Global Dimension 2 Code";  // ALLE ANSH
                UserSetup.INSERT();
                SalesResCenterCode := UserSetup."Sales Resp. Ctr. Filter";
                PurchResCenterCode := UserSetup."Purchase Resp. Ctr. Filter";
            END;
        END ELSE
            ERROR(Text001Lbl, RespCenterCode);
        Flag := TRUE;
    end;
}