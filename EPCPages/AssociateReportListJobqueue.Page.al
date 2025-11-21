page 97915 "Associate Report List_Jobqueue"
{
    Editable = false;
    PageType = List;
    SourceTable = "Report Data for E-Mail";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Report ID"; Rec."Report ID")
                {
                }
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Report Name"; Rec."Report Name")
                {
                }
                field("Report Batch No."; Rec."Report Batch No.")
                {
                }
                field("E-Mail Send"; Rec."E-Mail Send")
                {
                }
                field("Error Message"; Rec."Error Message")
                {
                }
                field("Report Run Date"; Rec."Report Run Date")
                {
                }
                field("E_Mail Send Error Message"; Rec."E_Mail Send Error Message")
                {
                }
                field("E_Mail Send Error"; Rec."E_Mail Send Error")
                {
                }
                field("Report Run Time"; Rec."Report Run Time")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Re-Send E_Mail")
            {

                trigger OnAction()
                var
                    Codeunit_12: Codeunit "Send E-mail to Associate";
                    ReportDataforEMail: Record "Report Data for E-Mail";
                begin
                    ReportDataforEMail.RESET;
                    //ReportDataforEMail.SETRANGE("Entry No.","Entry No.");
                    ReportDataforEMail.SETRANGE("Report Run Date", Rec."Report Run Date");
                    ReportDataforEMail.SETFILTER("Report Name", '<>%1', '');
                    ReportDataforEMail.SETRANGE("E-Mail Send", FALSE);
                    IF ReportDataforEMail.FINDSET THEN
                        REPEAT
                            CLEAR(Codeunit_12);
                            Codeunit_12.SetEmailFilters(ReportDataforEMail."E-Mail Send", ReportDataforEMail."Report Name");
                            IF NOT Codeunit_12.RUN(ReportDataforEMail) THEN BEGIN
                                ReportDataforEMail."E_Mail Send Error Message" := GETLASTERRORTEXT;
                                ReportDataforEMail."E_Mail Send Error" := TRUE;
                                ReportDataforEMail.MODIFY;
                                COMMIT;
                            END;
                        UNTIL ReportDataforEMail.NEXT = 0;
                    MESSAGE('%1', 'Send Mail');
                end;
            }
        }
    }
}

