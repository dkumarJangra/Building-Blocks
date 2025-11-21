page 97782 "Resposibility center form"
{
    PageType = Card;
    SourceTable = "User Setup";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            field("User ID"; Rec."User ID")
            {
                Editable = false;
                Style = Strong;
                StyleExpr = TRUE;
            }
            field("User Name"; User."User Name")
            {
                Editable = false;
                Style = Strong;
                StyleExpr = TRUE;
            }
            field("Sales Resp. Ctr. Filter"; Rec."Sales Resp. Ctr. Filter")
            {
                Caption = 'Responsibility Center';
                Editable = false;
                Style = Strong;
                StyleExpr = TRUE;
            }
            field(RespCenterName; RespCenter.Name)
            {
                Editable = false;
                Style = Strong;
                StyleExpr = TRUE;
            }
            field(Picture; CompanyInfo.Picture)
            {
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(CompanyInfo.Picture);
        IF User.GET(USERID) THEN;
        IF RespCenter.GET(Rec."Sales Resp. Ctr. Filter") THEN;
    end;

    trigger OnOpenPage()
    begin
        Rec.SETFILTER("User ID", USERID);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF NOT CONFIRM(text0001, FALSE)
        THEN
            ERROR('');
    end;

    var
        CompanyInfo: Record "Company Information";
        text0001: Label 'Are you sure you want to close this form';
        RespCenter: Record "Responsibility Center 1";
        User: Record User;
}

