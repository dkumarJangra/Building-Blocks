page 97866 "Company Information Card Part"
{
    Caption = 'Company Information';
    PageType = CardPart;
    SourceTable = "Company Information";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(COMPANYNAME; COMPANYNAME)
            {
                Caption = 'Company';
                Style = StrongAccent;
                StyleExpr = TRUE;
            }
            field(Picture; Rec.Picture)
            {
                Caption = 'Picture';
                Importance = Additional;
                ShowCaption = false;
            }
            field(Name; Rec.Name)
            {
                Caption = 'Company Name';
                Importance = Promoted;
                Style = StrongAccent;
                StyleExpr = TRUE;
            }
            field("User ID"; UserSetup."User ID")
            {
                Importance = Promoted;
                Style = Attention;
                StyleExpr = TRUE;
            }
            field("User Name"; User."User Name")
            {
                Caption = 'User Name';
                Style = Attention;
                StyleExpr = TRUE;
            }
            field("Responsibility Center"; UserSetup."Responsibility Center")
            {
                Importance = Promoted;
                Style = Attention;
                StyleExpr = TRUE;
            }
            field("Responsibility Center Desc."; RespCenter.Name)
            {
                Caption = 'Resp. Center Name';
                Style = Attention;
                StyleExpr = TRUE;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Change Responsibility Center")
            {
                Caption = 'Change Responsibility Center';
                Ellipsis = true;
                Image = Responsibility;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;
                ShortCutKey = 'F12';

                trigger OnAction()
                begin
                    PAGE.RUNMODAL(PAGE::"User Resp. Center Selection");
                    UpdateInfo;
                end;
            }
            action("Company Information")
            {
                Caption = 'Company Information';
                Ellipsis = true;
                Image = CompanyInformation;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;

                trigger OnAction()
                begin
                    CLEAR(CompanyInfo);
                    CompanyInfo.EDITABLE := FALSE;
                    CompanyInfo.RUNMODAL;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        UpdateInfo;
    end;

    var
        UserResCenterSetup: Record "User Res. Center Setup";
        UserSetup: Record "User Setup";
        RespCenter: Record "Responsibility Center 1";
        User: Record User;
        CompanyInfo: Page "Company Information";


    procedure UpdateInfo()
    begin
        User.RESET;
        User.SETCURRENTKEY("User Name");
        User.SETRANGE("User Name", USERID);
        IF User.FINDFIRST THEN;
        IF UserSetup.GET(USERID) THEN;
        IF RespCenter.GET(UserSetup."Responsibility Center") THEN;
    end;
}

