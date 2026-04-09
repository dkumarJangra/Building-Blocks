page 60841 "Posted WhatsApp data push"
{
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Ptd WhatsApp Data Push Details";
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Receiver Type"; Rec."Receiver Type")
                {

                }
                field("Application No."; Rec."Application No.")
                {
                    Editable = false;
                }
                field("Associate ID"; Rec."Associate ID")
                {
                    Editable = false;
                }
                field("Associate Name"; Rec."Associate Name")
                {
                    Editable = false;
                }
                field("Associate Mobile No."; Rec."Associate Mobile No.")
                {
                    Editable = false;
                }
                field("Associate E-Mail"; Rec."Associate E-Mail")
                {
                    Editable = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Editable = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    Editable = false;
                }
                field("Custommer Mobile No."; Rec."Custommer Mobile No.")
                {
                    Editable = false;
                }
                field("Customer Email"; Rec."Customer Email")
                {
                    Editable = false;
                }
                field("Project No."; Rec."Project No.")
                {
                    Editable = false;
                }
                field("Project Name"; Rec."Project Name")
                {
                    Editable = false;
                }
                field("Posting Date/DOJ"; Rec."Posting Date/DOJ")
                {
                    Editable = false;
                }
                field("Plot No."; Rec."Plot No.")
                {
                    Editable = false;
                }
                field("No. of Days"; Rec."No. of Days")
                {
                    Editable = false;
                }
                field("Start Date"; Rec."Start Date")
                {
                    Editable = false;
                }
                field("End Date"; Rec."End Date")
                {
                    Editable = false;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    Editable = false;
                }
                field("Received Amount"; Rec."Received Amount")
                {
                    Editable = false;
                }
                field("Min. allotment Amount"; Rec."Min. allotment Amount")
                {
                    Editable = false;
                }
                field("Send Via"; Rec."Send Via")
                {

                }
                field("Select for send Whatsapp"; Rec."Select for send Whatsapp")
                {

                }
                field("Select for send Email"; Rec."Select for send Email")
                {

                }
                field("Sent Email"; Rec."Sent Email")
                {
                    Editable = false;
                }
                field("Email Error message"; Rec."Email Err mess For Vendor")
                {
                    Caption = 'Email Error Message For Vendor';
                    Editable = false;
                }
                field("Whatsup Status Code"; Rec."Whatsup Status Code For Vendor")
                {
                    Caption = 'Whatsup Status Code For Vendor';
                    Editable = false;
                }
                field("Whatsup Status Description"; Rec."Whatsup Status Desc For Vendor")
                {
                    Caption = 'Whatsup Status Description for Vendor';
                    Editable = false;
                }
                field("Whatsup mid"; Rec."Whatsup mid For Vendor")
                {
                    Caption = 'Whatsup mid For Vendor';
                    Editable = false;
                }
                field("Creation Date Time"; Rec."Creation Date Time")
                {
                    Editable = false;
                }
                field("Email Error message For Cust"; Rec."Email Error message For Cust")
                {
                    Caption = 'Email Error Message For Customer';
                    Editable = false;
                }
                field("Whatsup Status Code For Cust"; Rec."Whatsup Status Code For Cust")
                {
                    Caption = 'Whatsup Status Code For Customer';
                    Editable = false;
                }
                field("Whatsup Status Desc For Cust"; Rec."Whatsup Status Desc For Cust")
                {
                    Caption = 'Whatsup Status Description for Customer';
                    Editable = false;
                }
                field("Whatsup mid For Customer"; Rec."Whatsup mid For Customer")
                {
                    Caption = 'Whatsup mid For Customer';
                    Editable = false;
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Calculate Data")
            {
                Visible = false;
                RunObject = Codeunit 50048;
            }
            Action("Select All")
            {
                Visible = false;
                trigger OnAction()
                var
                    WhatsappDataPush: Record "WhatsApp Data Push Details";
                begin
                    WhatsappDataPush.RESET;
                    WhatsappDataPush.SetRange("Send Via", WhatsappDataPush."Send Via"::Whatsup);
                    IF WhatsappDataPush.FindSet() then
                        repeat
                            WhatsappDataPush."Select for send Whatsapp" := True;
                            WhatsappDataPush.Modify;
                        Until WhatsappDataPush.Next = 0;

                    WhatsappDataPush.RESET;
                    WhatsappDataPush.SetRange("Send Via", WhatsappDataPush."Send Via"::"Whatsup And Email");
                    IF WhatsappDataPush.FindSet() then
                        repeat
                            WhatsappDataPush."Select for send Whatsapp" := True;
                            WhatsappDataPush."Select for send Email" := True;
                            WhatsappDataPush.Modify;
                        Until WhatsappDataPush.Next = 0;

                    WhatsappDataPush.RESET;
                    WhatsappDataPush.SetRange("Send Via", WhatsappDataPush."Send Via"::Email);
                    IF WhatsappDataPush.FindSet() then
                        repeat
                            WhatsappDataPush."Select for send Email" := True;
                            WhatsappDataPush.Modify;
                        Until WhatsappDataPush.Next = 0;


                    Message('All records has been selected for Send Whatsapp Message');

                end;

            }
            Action("Un-Select All")
            {
                Visible = false;
                trigger OnAction()
                var
                    WhatsappDataPush: Record "WhatsApp Data Push Details";
                begin
                    WhatsappDataPush.RESET;
                    WhatsappDataPush.SetRange("Send Via", WhatsappDataPush."Send Via"::Whatsup);
                    IF WhatsappDataPush.FindSet() then
                        repeat
                            WhatsappDataPush."Select for send Whatsapp" := false;
                            WhatsappDataPush.Modify;
                        Until WhatsappDataPush.Next = 0;

                    WhatsappDataPush.RESET;
                    WhatsappDataPush.SetRange("Send Via", WhatsappDataPush."Send Via"::Email);
                    IF WhatsappDataPush.FindSet() then
                        repeat
                            WhatsappDataPush."Select for send Email" := false;
                            WhatsappDataPush.Modify;
                        Until WhatsappDataPush.Next = 0;

                    WhatsappDataPush.RESET;
                    WhatsappDataPush.SetRange("Send Via", WhatsappDataPush."Send Via"::"Whatsup And Email");
                    IF WhatsappDataPush.FindSet() then
                        repeat
                            WhatsappDataPush."Select for send Whatsapp" := false;
                            WhatsappDataPush."Select for send Email" := false;
                            WhatsappDataPush.Modify;
                        Until WhatsappDataPush.Next = 0;

                    Message('All records has been un-selected');
                end;
            }

            Action("Send Whatsapp Message")
            {
                Visible = false;
                trigger OnAction()
                var
                    WhatsappDataPush: Record "WhatsApp Data Push Details";
                    DGCWhatsupSMS: Codeunit "DGC Whatsup SMS";
                    SendWhatsupEmail: Codeunit "Send Whatsup Email";
                    Cust: Record customer;
                    DueAmount: Decimal;
                    WhatsupSetup: Record "Whatsup Integration Setup";
                begin
                    IF Confirm('Do you want to push the Whatsapp Message?') THEN begin
                        WhatsupSetup.Get();
                        WhatsappDataPush.RESET;
                        WhatsappDataPush.SetRange("Select for send Whatsapp", True);
                        IF WhatsappDataPush.FindSet() then BEGIN
                            repeat
                                IF WhatsappDataPush."Receiver Type" = WhatsappDataPush."Receiver Type"::Customer then
                                    DGCWhatsupSMS.CreateBodyForPaymentReminder(WhatsupSetup.Password, WhatsappDataPush."Custommer Mobile No.", WhatsappDataPush."Customer Name", format(WhatsappDataPush."Total Amount"), Format(WhatsappDataPush."End Date"), WhatsappDataPush."Project Name", Format(WhatsappDataPush."Plot No."), Format(WhatsappDataPush."Application No."), WhatsappDataPush)
                                Else if WhatsappDataPush."Receiver Type" = WhatsappDataPush."Receiver Type"::Associate then
                                    DGCWhatsupSMS.CreateBodyForPaymentReminderForVendor(WhatsupSetup.Password, WhatsappDataPush."Associate Mobile No.", WhatsappDataPush."Associate Name", format(WhatsappDataPush."Total Amount"), Format(WhatsappDataPush."End Date"), WhatsappDataPush."Project Name", Format(WhatsappDataPush."Plot No."), Format(WhatsappDataPush."Application No."), WhatsappDataPush)
                                Else if WhatsappDataPush."Receiver Type" = WhatsappDataPush."Receiver Type"::"Customer & Associate" then begin
                                    DGCWhatsupSMS.CreateBodyForPaymentReminder(WhatsupSetup.Password, WhatsappDataPush."Custommer Mobile No.", WhatsappDataPush."Customer Name", format(WhatsappDataPush."Total Amount"), Format(WhatsappDataPush."End Date"), WhatsappDataPush."Project Name", Format(WhatsappDataPush."Plot No."), Format(WhatsappDataPush."Application No."), WhatsappDataPush);
                                    DGCWhatsupSMS.CreateBodyForPaymentReminderForVendor(WhatsupSetup.Password, WhatsappDataPush."Associate Mobile No.", WhatsappDataPush."Associate Name", format(WhatsappDataPush."Total Amount"), Format(WhatsappDataPush."End Date"), WhatsappDataPush."Project Name", Format(WhatsappDataPush."Plot No."), Format(WhatsappDataPush."Application No."), WhatsappDataPush);
                                end;
                            Until WhatsappDataPush.Next = 0;
                            Message('Messages has been sent to Customers');
                        end ELSE
                            Message('No record found');
                    END ELSE
                        Message('Nothing to Process');
                END;

            }
            Action("Send Email")
            {
                trigger OnAction()
                var
                    WhatsappDataPush: Record "WhatsApp Data Push Details";
                    DGCWhatsupSMS: Codeunit "DGC Whatsup SMS";
                    SendWhatsupEmail: Codeunit "Send Whatsup Email";
                    Cust: Record customer;
                    DueAmount: Decimal;
                begin
                    IF Confirm('Do you want to push the Whatsapp Message?') THEN begin
                        WhatsappDataPush.RESET();
                        WhatsappDataPush.SetRange("Select for send Email", true);
                        IF WhatsappDataPush.FindSet() then BEGIN
                            repeat
                                IF WhatsappDataPush."Receiver Type" = WhatsappDataPush."Receiver Type"::Customer Then begin
                                    CLEAR(SendWhatsupEmail);
                                    IF WhatsappDataPush."Customer Email" <> '' THEN BEGIN
                                        DueAmount := WhatsappDataPush."Total Amount" - WhatsappDataPush."Received Amount";
                                        If DueAmount < 0 then
                                            DueAmount := 0;
                                        SendWhatsupEmail.SetEmailfilters(WhatsappDataPush."Customer Email", WhatsappDataPush."Customer Name",
                                        WhatsappDataPush."Application No.", WhatsappDataPush."Project Name", WhatsappDataPush."Plot No.", WhatsappDataPush."Start Date", DueAmount);
                                        IF NOT SendWhatsupEmail.RUN THEN BEGIN
                                            WhatsappDataPush."Email Error message For Cust" := CopyStr(GetLastErrorText, 1, 250);
                                        END ELSE
                                            WhatsappDataPush."Sent Email" := True;
                                    END ELSE
                                        WhatsappDataPush."Email Error message For Cust" := 'Customer Email Id not define';

                                    WhatsappDataPush."Select for send Email" := False;
                                    WhatsappDataPush.Modify;
                                    Commit;
                                end Else if WhatsappDataPush."Receiver Type" = WhatsappDataPush."Receiver Type"::Associate Then begin
                                    IF WhatsappDataPush."Associate E-Mail" <> '' THEN BEGIN
                                        DueAmount := WhatsappDataPush."Total Amount" - WhatsappDataPush."Received Amount";
                                        If DueAmount < 0 then
                                            DueAmount := 0;
                                        SendWhatsupEmail.SetEmailfilters(WhatsappDataPush."Associate E-Mail", WhatsappDataPush."Associate Name",
                                        WhatsappDataPush."Application No.", WhatsappDataPush."Project Name", WhatsappDataPush."Plot No.", WhatsappDataPush."Start Date", DueAmount);
                                        IF NOT SendWhatsupEmail.RUN THEN BEGIN
                                            WhatsappDataPush."Email Err mess For Vendor" := CopyStr(GetLastErrorText, 1, 250);
                                        END ELSE
                                            WhatsappDataPush."Sent Email" := True;
                                    END ELSE
                                        WhatsappDataPush."Email Err mess For Vendor" := 'Customer Email Id not define';

                                    WhatsappDataPush."Select for send Email" := False;
                                    WhatsappDataPush.Modify;
                                    Commit;
                                end Else if WhatsappDataPush."Receiver Type" = WhatsappDataPush."Receiver Type"::"Customer & Associate" Then begin
                                    //For Customer
                                    IF WhatsappDataPush."Customer Email" <> '' THEN BEGIN
                                        DueAmount := WhatsappDataPush."Total Amount" - WhatsappDataPush."Received Amount";
                                        If DueAmount < 0 then
                                            DueAmount := 0;
                                        SendWhatsupEmail.SetEmailfilters(WhatsappDataPush."Customer Email", WhatsappDataPush."Customer Name",
                                        WhatsappDataPush."Application No.", WhatsappDataPush."Project Name", WhatsappDataPush."Plot No.", WhatsappDataPush."Start Date", DueAmount);
                                        IF NOT SendWhatsupEmail.RUN THEN BEGIN
                                            WhatsappDataPush."Email Error message For Cust" := CopyStr(GetLastErrorText, 1, 250);
                                        END ELSE
                                            WhatsappDataPush."Sent Email" := True;
                                    END ELSE
                                        WhatsappDataPush."Email Error message For Cust" := 'Customer Email Id not define';

                                    //For Associate
                                    IF WhatsappDataPush."Associate E-Mail" <> '' THEN BEGIN
                                        DueAmount := WhatsappDataPush."Total Amount" - WhatsappDataPush."Received Amount";
                                        If DueAmount < 0 then
                                            DueAmount := 0;
                                        SendWhatsupEmail.SetEmailfilters(WhatsappDataPush."Associate E-Mail", WhatsappDataPush."Associate Name",
                                        WhatsappDataPush."Application No.", WhatsappDataPush."Project Name", WhatsappDataPush."Plot No.", WhatsappDataPush."Start Date", DueAmount);
                                        IF NOT SendWhatsupEmail.RUN THEN BEGIN
                                            WhatsappDataPush."Email Err mess For Vendor" := CopyStr(GetLastErrorText, 1, 250);
                                        END ELSE
                                            WhatsappDataPush."Sent Email" := True;
                                    END ELSE
                                        WhatsappDataPush."Email Err mess For Vendor" := 'Customer Email Id not define';

                                    WhatsappDataPush."Select for send Email" := False;
                                    WhatsappDataPush.Modify;
                                    Commit;
                                end;
                            Until WhatsappDataPush.Next = 0;
                            Message('Messages has been sent to Customers');
                        end ELSE
                            Message('No record found');
                    END;
                End;
            }
            action("Receiver Type - Customer")
            {
                Visible = false;
                trigger OnAction()
                var
                    WhatsAppDataPushDetails: Record "WhatsApp Data Push Details";
                begin
                    CurrPage.SetSelectionFilter(WhatsAppDataPushDetails);
                    IF WhatsAppDataPushDetails.Findset() Then
                        repeat
                            WhatsAppDataPushDetails."Receiver Type" := WhatsAppDataPushDetails."Receiver Type"::Customer;
                            WhatsAppDataPushDetails.Modify();
                        until WhatsAppDataPushDetails.Next() = 0;
                    CurrPage.Update();
                end;
            }
            action("Receiver Type - Associate")
            {
                Visible = false;
                trigger OnAction()
                var
                    WhatsAppDataPushDetails: Record "WhatsApp Data Push Details";
                begin
                    CurrPage.SetSelectionFilter(WhatsAppDataPushDetails);
                    IF WhatsAppDataPushDetails.FindSet() Then
                        repeat
                            WhatsAppDataPushDetails."Receiver Type" := WhatsAppDataPushDetails."Receiver Type"::Associate;
                            WhatsAppDataPushDetails.Modify();
                        until WhatsAppDataPushDetails.Next() = 0;
                    CurrPage.Update();
                end;
            }
            action("Receiver Type - Both")
            {
                Visible = false;
                Caption = 'Receiver Type - Customer and Associate';
                trigger OnAction()
                var
                    WhatsAppDataPushDetails: Record "WhatsApp Data Push Details";
                begin
                    CurrPage.SetSelectionFilter(WhatsAppDataPushDetails);
                    IF WhatsAppDataPushDetails.FindSet() Then
                        repeat
                            WhatsAppDataPushDetails."Receiver Type" := WhatsAppDataPushDetails."Receiver Type"::"Customer & Associate";
                            WhatsAppDataPushDetails.Modify();
                        until WhatsAppDataPushDetails.Next() = 0;
                    CurrPage.Update();
                end;
            }
            action("Send Via - Whatsup")
            {
                Visible = false;
                trigger OnAction()
                var
                    WhatsAppDataPushDetails: Record "WhatsApp Data Push Details";
                begin
                    CurrPage.SetSelectionFilter(WhatsAppDataPushDetails);
                    IF WhatsAppDataPushDetails.FindSet() Then
                        repeat
                            WhatsAppDataPushDetails."Send Via" := WhatsAppDataPushDetails."Send Via"::Whatsup;
                            WhatsAppDataPushDetails."Select for send Whatsapp" := true;
                            WhatsAppDataPushDetails.Modify();
                        until WhatsAppDataPushDetails.Next() = 0;
                    CurrPage.Update();
                end;
            }
            action("Send Via - Email")
            {
                Visible = false;
                trigger OnAction()
                var
                    WhatsAppDataPushDetails: Record "WhatsApp Data Push Details";
                begin
                    CurrPage.SetSelectionFilter(WhatsAppDataPushDetails);
                    IF WhatsAppDataPushDetails.FindSet() Then
                        repeat
                            WhatsAppDataPushDetails."Send Via" := WhatsAppDataPushDetails."Send Via"::Email;
                            WhatsAppDataPushDetails."Select for send Email" := true;
                            WhatsAppDataPushDetails.Modify();
                        until WhatsAppDataPushDetails.Next() = 0;
                    CurrPage.Update();
                end;
            }
            action("Send Via - Both")
            {
                Caption = 'Send Via - Whatsup and Email';
                trigger OnAction()
                var
                    WhatsAppDataPushDetails: Record "WhatsApp Data Push Details";
                begin
                    CurrPage.SetSelectionFilter(WhatsAppDataPushDetails);
                    IF WhatsAppDataPushDetails.FindSet() Then
                        repeat
                            WhatsAppDataPushDetails."Send Via" := WhatsAppDataPushDetails."Send Via"::"Whatsup And Email";
                            WhatsAppDataPushDetails."Select for send Whatsapp" := true;
                            WhatsAppDataPushDetails."Select for send Email" := true;
                            WhatsAppDataPushDetails.Modify();
                        until WhatsAppDataPushDetails.Next() = 0;
                    CurrPage.Update();
                end;
            }

        }

    }

    var
        UnitPaymentDueDaysupdate: Codeunit 50048;
        NewUnitmasters: Record 97821;
        Updationofplotdetails: Record 60811;

}

