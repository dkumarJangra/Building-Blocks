page 50125 "New Customer Pmt Tran. Detls"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    Permissions = TableData "Payment transaction Details" = rimd;
    SourceTable = "Payment transaction Details";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Editable = false;
                }
                field("Application Type"; Rec."Application Type")
                {
                    Editable = false;
                }
                field("Application No."; Rec."Application No.")
                {
                    Editable = false;
                }
                field("Associate Id"; Rec."Associate Id")
                {
                    Editable = false;
                }
                field("Payment Server Status"; Rec."Payment Server Status")
                {
                    Editable = false;
                }
                field("Transaction Status"; Rec."Transaction Status")
                {
                    Editable = false;
                }
                field("Payment Server Status Date"; Rec."Payment Server Status Date")
                {
                    Editable = false;
                }
                field("Payment Server Status Time"; Rec."Payment Server Status Time")
                {
                    Editable = false;
                }
                field("Payment Transaction No."; Rec."Payment Transaction No.")
                {
                    Editable = false;
                }
                field("Unique Payment Order ID"; Rec."Unique Payment Order ID")
                {
                    Editable = false;
                }
                field("Plot ID"; Rec."Plot ID")
                {

                    trigger OnValidate()
                    var
                        UnitMaster: Record "Unit Master";
                        UserSetup: Record "User Setup";
                    begin
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Allow Plot Change From Mob.APP", TRUE);
                        IF NOT UserSetup.FINDFIRST THEN
                            ERROR('Contact Admin');
                        IF Rec."Plot ID" <> '' THEN BEGIN
                            UnitMaster.RESET;
                            IF UnitMaster.GET(Rec."Plot ID") THEN BEGIN
                                UnitMaster.TESTFIELD(Status, UnitMaster.Status::Open);
                                UnitMaster.Status := UnitMaster.Status::Booked;
                                UnitMaster."Web Portal Status" := UnitMaster."Web Portal Status"::Booked;
                                UnitMaster.MODIFY;
                                WebAppService.UpdateUnitStatus(UnitMaster);  //210624
                            END;
                        END;
                    end;
                }
                field("Project ID"; Rec."Project ID")
                {
                    Editable = false;
                }
                field("Unit Payment Plan"; Rec."Unit Payment Plan")
                {
                    Editable = false;
                }
                field("Payment Amount"; Rec."Payment Amount")
                {
                    Editable = false;
                }
                field(User_ID; Rec.User_ID)
                {
                    Editable = false;
                }
                field("Receipt Posting Date"; Rec."Receipt Posting Date")
                {
                    Editable = false;
                }
                field("Document Create In NAV"; Rec."Document Create In NAV")
                {
                    Editable = false;
                }
                field("Allotment Amount"; Rec."Allotment Amount")
                {
                    Editable = false;
                }
                field("Booking Amount"; Rec."Booking Amount")
                {
                    Editable = false;
                }
                field("Payment Signature"; Rec."Payment Signature")
                {
                    Editable = false;
                }
                field("Payment ID"; Rec."Payment ID")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(CheckPaymentStatusOnServer)
            {
                Visible = false;

                trigger OnAction()
                begin
                    CompanywiseGLAccount.RESET;
                    CompanywiseGLAccount.SETRANGE("MSC Company", TRUE);
                    IF CompanywiseGLAccount.FINDFIRST THEN
                        IF COMPANYNAME <> CompanywiseGLAccount."Company Code" THEN
                            ERROR('This Process done from -' + CompanywiseGLAccount."Company Code");
                    CLEAR(CheckPaymentGatwayStatus);
                    CheckPaymentGatwayStatus.RUN;
                    COMMIT;
                end;
            }
            action(CreateCustomerReceipt)
            {

                trigger OnAction()
                begin
                    CompanywiseGLAccount.RESET;
                    CompanywiseGLAccount.SETRANGE("MSC Company", TRUE);
                    IF CompanywiseGLAccount.FINDFIRST THEN
                        IF COMPANYNAME <> CompanywiseGLAccount."Company Code" THEN
                            ERROR('This Process done from -' + CompanywiseGLAccount."Company Code");

                    CLEAR(CreateNewReceipt);
                    CreateNewReceipt.RUN;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Allow Mobile App", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');
    end;

    var
        CheckPaymentGatwayStatus: Codeunit "Check Payment Gatway Status";
        CreateNewReceipt: Report "Create New Receipt";
        CompanywiseGLAccount: Record "Company wise G/L Account";
        WebAppService: Codeunit "Web App Service";
}

