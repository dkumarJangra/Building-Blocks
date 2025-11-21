report 50109 "Collection Center Chang In App"
{
    Permissions = TableData "G/L Entry" = rimd;
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Application Payment Entry"; "Application Payment Entry")
        {
            DataItemTableView = WHERE("Document Type" = CONST(BOND));
            RequestFilterFields = "Document No.", "Line No.";

            trigger OnAfterGetRecord()
            begin
                "Confirmed Order".RESET;
                "Confirmed Order".SETRANGE("No.", "Document No.");
                "Confirmed Order".SETRANGE("Posting Date", (TODAY - 15), TODAY);
                IF "Confirmed Order".FINDFIRST THEN BEGIN
                    ApplicationPaymentEntry.RESET;
                    ApplicationPaymentEntry.SETRANGE(ApplicationPaymentEntry."Document No.", "Document No.");
                    ApplicationPaymentEntry.SETRANGE("Line No.", "Line No.");
                    IF ApplicationPaymentEntry.FINDFIRST THEN BEGIN
                        IF ApplicationPaymentEntry."Payment Mode" = ApplicationPaymentEntry."Payment Mode"::Cash THEN BEGIN
                            OldGLCode := '';
                            NewGLCode := '';
                            v_GLAccount.RESET;
                            v_GLAccount.SETCURRENTKEY("BBG Branch Code");
                            v_GLAccount.SETRANGE("BBG Branch Code", ApplicationPaymentEntry."User Branch Code");
                            v_GLAccount.SETRANGE("BBG Cash Account", TRUE);
                            IF v_GLAccount.FINDFIRST THEN
                                OldGLCode := v_GLAccount."No.";

                            GLAccount.RESET;
                            GLAccount.SETCURRENTKEY("BBG Branch Code");
                            GLAccount.SETRANGE("BBG Branch Code", NewCollectionCenter);
                            GLAccount.SETRANGE("BBG Cash Account", TRUE);
                            IF GLAccount.FINDFIRST THEN
                                NewGLCode := GLAccount."No.";
                            GLEntry.RESET;
                            GLEntry.SETCURRENTKEY("Document No.");
                            GLEntry.SETRANGE("Document No.", ApplicationPaymentEntry."Posted Document No.");
                            GLEntry.SETRANGE("G/L Account No.", OldGLCode);
                            IF GLEntry.FINDFIRST THEN BEGIN
                                GLEntry."G/L Account No." := NewGLCode;
                                GLEntry.MODIFY;
                            END;
                        END;
                        ApplicationPaymentEntry."User Branch Code" := NewCollectionCenter;
                        ApplicationPaymentEntry."User Branch Name" := CollectionCenterName;
                        ApplicationPaymentEntry.MODIFY;
                        NewApplicationPaymentEntry.RESET;
                        NewApplicationPaymentEntry.SETRANGE("Document No.", ApplicationPaymentEntry."Document No.");
                        NewApplicationPaymentEntry.SETRANGE("Line No.", ApplicationPaymentEntry."Receipt Line No.");
                        IF NewApplicationPaymentEntry.FINDFIRST THEN BEGIN
                            NewApplicationPaymentEntry."User Branch Code" := NewCollectionCenter;
                            NewApplicationPaymentEntry."User Branch Name" := CollectionCenterName;
                            NewApplicationPaymentEntry.MODIFY;
                        END;
                    END;
                END ELSE
                    MESSAGE('Application is older than 15 Days. Please contact Admin.');
            end;

            trigger OnPreDataItem()
            begin
                IF APPCode_2 <> '' THEN
                    "Application Payment Entry".SETRANGE("Document No.", APPCode_2);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("New Collection Center Code"; NewCollectionCenter)
                {
                    TableRelation = "Responsibility Center 1".Code;
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        ResponsibilityCenter.RESET;
                        IF ResponsibilityCenter.GET(NewCollectionCenter) THEN
                            CollectionCenterName := ResponsibilityCenter.Name
                        ELSE
                            CollectionCenterName := '';
                    end;
                }
                field(Name; CollectionCenterName)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
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
        MESSAGE('Process Done');
    end;

    trigger OnPreReport()
    begin
        APPCode_2 := '';
        LineNo := "Application Payment Entry".GETFILTER("Line No.");
        IF LineNo = '' THEN
            ERROR('Please enter Line No.');

        APPCode_2 := APPCode_1;

        IF APPCode_2 = '' THEN
            APPCode_2 := "Application Payment Entry".GETFILTER("Document No.");

        IF APPCode_2 = '' THEN
            ERROR('Please enter Document No.');

        AccessControl.RESET;
        AccessControl.SETRANGE(AccessControl."User Name", USERID);
        AccessControl.SETRANGE(AccessControl."Role ID", 'COLLECTION CENTER CH');
        IF NOT AccessControl.FINDFIRST THEN
            ERROR('Contact Admin');
    end;

    var
        "Confirmed Order": Record "Confirmed Order";
        ResponsibilityCenter: Record "Responsibility Center 1";
        NewCollectionCenter: Code[20];
        CollectionCenterName: Text;
        ApplicationNofilter: Text;
        ApplicationPaymentEntry: Record "Application Payment Entry";
        NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        GLEntry: Record "G/L Entry";
        GLAccount: Record "G/L Account";
        v_GLAccount: Record "G/L Account";
        OldGLCode: Code[20];
        NewGLCode: Code[20];
        AccessControl: Record "Access Control";
        LineNo: Text;
        APPCode_1: Code[20];
        APPCode_2: Code[20];

    procedure FilterValue(APPCode: Code[20])
    begin
        APPCode_1 := APPCode;
    end;
}

