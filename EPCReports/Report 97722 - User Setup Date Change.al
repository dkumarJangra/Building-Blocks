report 97722 "User Setup Date Change"
{
    // version New

    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("User Setup"; "User Setup")
        {

            trigger OnAfterGetRecord()
            begin

                company.RESET;
                company.SETFILTER(Name, '<>%1', CompanywiseGLAccount."Company Code");
                IF company.FINDSET THEN
                    REPEAT
                        UserSetup.RESET;
                        UserSetup.CHANGECOMPANY(company.Name);
                        UserSetup.SETRANGE("User ID", "User ID");
                        IF UserSetup.FINDSET THEN
                            REPEAT
                                UserSetup."Allow Posting From" := "Allow Posting From";
                                UserSetup."Allow Posting To" := "Allow Posting To";
                                UserSetup."View of BALedger Entry" := "View of BALedger Entry";
                                UserSetup."View of Chart of Account" := "View of Chart of Account";
                                UserSetup."View All Vendor ledger Entries" := "View All Vendor ledger Entries";
                                UserSetup.MODIFY;
                            UNTIL UserSetup.NEXT = 0;
                    UNTIL company.NEXT = 0;
            end;

            trigger OnPreDataItem()
            var
                UserSetup: Record "User Setup";
            begin
                UserSetup.RESET;
                UserSetup.SETRANGE("User ID", USERID);
                UserSetup.SETRANGE("Allow User Setup Modify", TRUE);
                IF NOT UserSetup.FINDFIRST THEN
                    ERROR('Contact Admin');

                CompanywiseGLAccount.RESET;
                CompanywiseGLAccount.SETRANGE(CompanywiseGLAccount."MSC Company", TRUE);
                IF CompanywiseGLAccount.FINDFIRST THEN
                    IF CompanywiseGLAccount."Company Code" <> COMPANYNAME THEN
                        ERROR('Please run this batch in -' + CompanywiseGLAccount."Company Code");
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        MESSAGE('%1', 'Date Changed');
    end;

    var
        AllowFrom: Date;
        AllowTo: Date;
        UserSetup: Record "User Setup";
        company: Record Company;
        CompanywiseGLAccount: Record "Company wise G/L Account";
}

