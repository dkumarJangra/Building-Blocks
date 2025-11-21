page 50294 "Target Demand Entry Detail"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Target Demand Entry Detals";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Request No."; Rec."Request No.")
                {
                }
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("Team Code"; Rec."Team Code")
                {
                }
                field("Leader Code"; Rec."Leader Code")
                {
                }
                field("Field Type"; Rec."Field Type")
                {
                }
                field("Field Type Value"; Rec."Field Type Value")
                {
                }
                field(Monthly; Rec.Monthly)
                {
                }
                field(Month; Rec.Month)
                {
                }
                field(Year; Rec.Year)
                {
                }
                field("From Date"; Rec."From Date")
                {
                }
                field("To Date"; Rec."To Date")
                {
                }
                field("No. of Days"; Rec."No. of Days")
                {
                }
                field("Request Date"; Rec."Request Date")
                {
                }
                field("Request Creation Time"; Rec."Request Creation Time")
                {
                }
                field("Request Closing Date"; Rec."Request Closing Date")
                {
                }
                field("Request Closing Time"; Rec."Request Closing Time")
                {
                }
                field(Designation; Rec.Designation)
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Associate Exclude"; Rec."Associate Exclude")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Target Functionality", FALSE);
        IF UserSetup.FINDFIRST THEN
            ERROR('Please contact admin');

        CompanywiseGLAccount.RESET;
        CompanywiseGLAccount.SETRANGE("MSC Company", TRUE);
        IF CompanywiseGLAccount.FINDFIRST THEN
            IF CompanywiseGLAccount."Company Code" <> COMPANYNAME THEN
                ERROR('This process will run in BBP company');
    end;

    var
        Monthly: Boolean;
        Month: Option Jan,Feb,March,April,May,June,July,Aug,Sept,Oct,Nov,Dec;
        Year: Integer;
        FromDate: Date;
        ToDate: Date;
        NoofDays: DateFormula;
        RequestClosingDate: Date;
        Designation: Decimal;
        AssociateFilter: Text;
        FiledTypeFilter: Text;
        DesignationName: Text;
        Vendor: Record Vendor;
        TeamName: Text;
        TargetViewEntryTable: Record "Target View Entry Table";
        Targetfieldmaster: Record "Target field master";
        TargetFieldCaption: array[50] of Text;
        SNo: Integer;
        CompanywiseGLAccount: Record "Company wise G/L Account";
        UserSetup: Record "User Setup";
}

