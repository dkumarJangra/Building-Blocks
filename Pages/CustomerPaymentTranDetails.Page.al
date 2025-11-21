page 50104 "Customer Payment Tran. Details"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
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
                }
                field("Application Type"; Rec."Application Type")
                {
                }
                field("Application No."; Rec."Application No.")
                {
                }
                field("Member Code"; Rec."Member Code")
                {
                }
                field("Associate Id"; Rec."Associate Id")
                {
                }
                field("Payment Server Status"; Rec."Payment Server Status")
                {
                }
                field("Transaction Status"; Rec."Transaction Status")
                {
                }
                field("Payment Server Status Date"; Rec."Payment Server Status Date")
                {
                }
                field("Payment Server Status Time"; Rec."Payment Server Status Time")
                {
                }
                field("Transaction Status Date"; Rec."Transaction Status Date")
                {
                    Visible = false;
                }
                field("Transaction Status Time"; Rec."Transaction Status Time")
                {
                    Visible = false;
                }
                field("Payment Transaction No."; Rec."Payment Transaction No.")
                {
                }
                field("Unique Payment Order ID"; Rec."Unique Payment Order ID")
                {
                }
                field("Plot ID"; Rec."Plot ID")
                {
                }
                field("Project ID"; Rec."Project ID")
                {
                }
                field("Unit Payment Plan"; Rec."Unit Payment Plan")
                {
                }
                field("Payment Amount"; Rec."Payment Amount")
                {
                }
                field("Mobile No."; Rec."Mobile No.")
                {
                }
                field("Member Name"; Rec."Member Name")
                {
                }
                field("Member Name 2"; Rec."Member Name 2")
                {
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                }
                field(User_ID; Rec.User_ID)
                {
                }
                field("Receipt Posting Date"; Rec."Receipt Posting Date")
                {
                }
                field("Document Create In NAV"; Rec."Document Create In NAV")
                {
                }
                field("Send Payment Link"; Rec."Send Payment Link")
                {
                }
                field("Member Father Name"; Rec."Member Father Name")
                {
                }
                field("Address 1"; Rec."Address 1")
                {
                }
                field("Address 2"; Rec."Address 2")
                {
                }
                field("Address 3"; Rec."Address 3")
                {
                }
                field("Pin Code"; Rec."Pin Code")
                {
                }
                field("Allotment Amount"; Rec."Allotment Amount")
                {
                }
                field("Booking Amount"; Rec."Booking Amount")
                {
                }
                field("Unit Sink"; Rec."Unit Sink")
                {
                }
                field("Payment Signature"; Rec."Payment Signature")
                {
                }
                field("Payment ID"; Rec."Payment ID")
                {
                }
                field("Is Active for Payment"; Rec."Is Active for Payment")
                {
                }
                field("Payment Duration Time"; Rec."Payment Duration Time")
                {
                }
                field("Mode of Prospect Meet"; Rec."Mode of Prospect Meet")
                {
                }
                field("Income Level"; Rec."Income Level")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("State Code"; Rec."State Code")
                {
                }
                field("District Code"; Rec."District Code")
                {

                }
                field("Mandal Code"; Rec."Mandal Code")
                {

                }
                field("Village Code"; Rec."Village Code")
                {

                }
                field("Whats App No."; Rec."Whats App No.")
                {
                }
                field("Do you own your own house"; Rec."Do you own your own house")
                {
                }
                field("Preffered Day/ Time"; Rec."Preffered Day/ Time")
                {
                }
                field(Education; Rec.Education)
                {
                }
                field("What vehicle do you own"; Rec."What vehicle do you own")
                {
                }
                field(Gender; Rec.Gender)
                {
                }
                field("Marital Status"; Rec."Marital Status")
                {
                }
                field("Presence on Social Media"; Rec."Presence on Social Media")
                {
                }
                field("No of Plots you own"; Rec."No of Plots you own")
                {
                }
                field("Member E-mail"; Rec."Member E-mail")
                {
                }
                field("Site Visit"; Rec."Site Visit")
                {
                }
                field("How do you know BBG"; Rec."How do you know BBG")
                {
                }
                field("Have you transacted with BBG"; Rec."Have you transacted with BBG")
                {
                }
                field(Occupation; Rec.Occupation)
                {
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
                Caption = 'Create Customer Receipt';

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

            // action("&Attach Documents")
            // {
            //     Caption = '&Attach Documents';
            //     //Promoted = true;
            //     RunObject = Page "Application Aadhaar Attachment";
            //     RunPageLink = "Table No." = CONST(50016),
            //                   "Ref. Pmt Entry No." = FIELD("Entry No.");
            //     ApplicationArea = All;
            // }
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
}

