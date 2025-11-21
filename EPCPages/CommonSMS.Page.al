page 50055 "Common SMS"
{
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Common SMS Header";
    SourceTableView = WHERE(Status = CONST(Open));
    UsageCategory = Documents;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Document No."; Rec."Document No.")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Creation Time"; Rec."Creation Time")
                {
                }
                field("Created By"; Rec."Created By")
                {
                }
                field(Name; Rec.Name)
                {
                }
            }
            part("1"; "Direct Incentive Payment")
            {
                //SubPageLink = "Document No." = FIELD("Document No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("F&unction")
            {
                Caption = 'F&unction';
                action("Send SMS")
                {
                    Caption = 'Send SMS';

                    trigger OnAction()
                    begin
                        CompInfo.GET;
                        IF CompInfo."Send SMS" THEN BEGIN
                            Rec.TESTFIELD(Status, Rec.Status::Open);
                            CommSMSLine.RESET;
                            CommSMSLine.SETRANGE("Document No.", Rec."Document No.");
                            IF CommSMSLine.FINDSET THEN BEGIN
                                REPEAT
                                    IF CommSMSLine.Vendor <> '' THEN BEGIN
                                        Vendor.RESET;
                                        Vendor.SETFILTER("No.", CommSMSLine.Vendor);
                                        Vendor.SETFILTER("BBG Mob. No.", '<>%1', '');
                                        IF Vendor.FINDFIRST THEN
                                            REPEAT
                                                PostPayment.SendSMS(Vendor."BBG Mob. No.", CommSMSLine."SMS Text");
                                                //ALLEDK15112022 Start
                                                CLEAR(SMSLogDetails);
                                                SmsMessage := '';
                                                SmsMessage1 := '';
                                                SmsMessage := COPYSTR(CommSMSLine."SMS Text", 1, 250);
                                                SmsMessage1 := COPYSTR(CommSMSLine."SMS Text", 251, 250);
                                                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Vendor', Vendor."No.", Vendor.Name, '', '', '', '');
                                            //ALLEDK15112022 END
                                            UNTIL Vendor.NEXT = 0;
                                    END;

                                    IF CommSMSLine.Customer <> '' THEN BEGIN
                                        Customer.RESET;
                                        Customer.SETFILTER("No.", CommSMSLine.Customer);
                                        Customer.SETFILTER("BBG Mobile No.", '<>%1', '');
                                        IF Customer.FINDFIRST THEN
                                            REPEAT
                                                PostPayment.SendSMS(Customer."BBG Mobile No.", CommSMSLine."SMS Text");
                                                CLEAR(SMSLogDetails);
                                                SmsMessage := '';
                                                SmsMessage1 := '';
                                                SmsMessage := COPYSTR(CommSMSLine."SMS Text", 1, 250);
                                                SmsMessage1 := COPYSTR(CommSMSLine."SMS Text", 251, 250);
                                                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, '', '', '', '');
                                            //ALLEDK15112022 END
                                            UNTIL Customer.NEXT = 0;
                                    END;
                                    Rec."Send SMS Date" := TODAY;
                                    Rec."Send SMS Time" := TIME;
                                    Rec.MODIFY;
                                UNTIL CommSMSLine.NEXT = 0;
                                MESSAGE('SMS send successfully');
                                Rec.Status := Rec.Status::Sent;
                                Rec.MODIFY;
                            END;
                        END ELSE
                            MESSAGE('No SMS Sent');
                    end;
                }
                action("Upload SMS")
                {
                    Caption = 'Upload SMS';

                    trigger OnAction()
                    begin
                        CommSMSDataport.SetNo(Rec."Document No.");
                        CommSMSDataport.RUN;
                    end;
                }
            }
        }
    }

    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        CustSMSText: Text[250];
        PostPayment: Codeunit PostPayment;
        CompInfo: Record "Company Information";
        SendSMS: Boolean;
        CommSMSDataport: XMLport "Vendor/Customer Upload";
        CommSMSLine: Record "Common SMS Line";
        SMSLogDetails: Codeunit "SMS Log Details";
        SmsMessage: Text[250];
        SmsMessage1: Text[250];


    procedure UploadSMS(var CommSMSHdr: Record "Common SMS Header")
    var
        CommSMSLn: Record "Common SMS Line";
        CommDataport: XMLport "Vendor Data";
    begin
        CommSMSLn.SETRANGE("Document No.", Rec."Document No.");
        CommSMSLn."Document No." := CommSMSHdr."Document No.";
        XMLPORT.RUN(XmlPort::"Vendor/Customer Upload", TRUE, TRUE, CommSMSLn);
    end;
}

