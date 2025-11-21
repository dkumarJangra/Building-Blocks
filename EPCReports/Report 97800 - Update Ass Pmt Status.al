report 97800 "Update Ass Pmt Status"
{
    // version web

    // 191022 code comment

    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Associate Payment Data"; "Associate Payment Data")
        {
            RequestFilterFields = "Entry No.", "Payment Request No.", "Payment Request Date", "Payment Status";

            trigger OnAfterGetRecord()
            begin

                IF PaymentStatus = PaymentStatus::Approve THEN BEGIN
                    "Associate Payment Data"."Payment Status" := "Associate Payment Data"."Payment Status"::Approved;
                    "Associate Payment Data"."Payment Approved Date" := TODAY;
                    "Associate Payment Data"."Payment Approved By" := USERID;
                    "Associate Payment Data"."Payment Approved Time" := TIME;
                END ELSE IF PaymentStatus = PaymentStatus::Reject THEN BEGIN
                    IF Comments = '' THEN
                        ERROR('Please enter the Payment Rejection Comment');
                    "Associate Payment Data"."Payment Status" := "Associate Payment Data"."Payment Status"::Reject;
                    "Associate Payment Data"."Comment for Rejection" := Comments;
                    Vendor.GET("Associate ID");
                    //191022 code comment Start
                    //  CompanyInformation.GET;   191022 code comment
                    //  IF CompanyInformation."Send SMS" THEN BEGIN
                    //   CLEAR(PostPayment);
                    //   PostPayment.SendSMS(Vendor."Mob. No.",Comments);
                    //END;

                    //191022 code comment END
                    COMMIT;
                    /*
                  IF (Vendor."E-Mail" <> '') AND (Comments <>'') THEN BEGIN
                    unitsetup.GET;
                    Filename := '';
                    Filename := unitsetup."Associate Mail Image Path";
                    SMTPSetup.GET;
                    SMTPMail.CreateMessage(SMTPSetup."Email Sender Name",SMTPSetup."Email Sender Email",Vendor."E-Mail",'Associate Payment',
                        '',TRUE);
                
                    SMTPMail.AppendBody('<br>');
                    SMTPMail.AppendBody('<br/>');
                    SMTPMail.AppendBody('Dear Sir,');
                    SMTPMail.AppendBody('<br/>');
                    SMTPMail.AppendBody('<br>');
                    SMTPMail.AppendBody('Your ID - ' + Vendor."No.");
                    SMTPMail.AppendBody('<br/>');
                    SMTPMail.AppendBody('<br>');
                    SMTPMail.AppendBody(Comments);
                    SMTPMail.AppendBody('<br/>');
                    SMTPMail.AppendBody('<br>');
                    SMTPMail.AppendBody('Regards');
                    SMTPMail.AppendBody('<br/>');
                    SMTPMail.AppendBody('<br>');
                    SMTPMail.AppendBody(SMTPSetup."Email Sender Name");
                    SMTPMail.AppendBody('<br/>');
                    SMTPMail.Send;
                    SLEEP(10000);
                  END;
                  */
                END;
                "Associate Payment Data"."Status update By" := USERID;
                "Associate Payment Data"."Status Update Date" := TODAY;
                "Associate Payment Data"."Status Update Time" := TIME;
                MODIFY;

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Payment Status"; PaymentStatus)
                {
                    ApplicationArea = All;
                }
                field("Payment Rejection Comment"; Comments)
                {
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
        MESSAGE('%1', 'Process Done');
    end;

    trigger OnPreReport()
    begin
        IF PaymentStatus = PaymentStatus::" " THEN
            ERROR('Select the Payment Status');
    end;

    var
        PaymentStatus: Option " ",Reject,Approve;
        Comments: Text;
        CompanyInformation: Record "Company Information";
        PostPayment: Codeunit PostPayment;
        Vendor: Record Vendor;
        SMS: Text;
        unitsetup: Record "Unit Setup";
        Filename: Text;
    //SMTPSetup: Record 409;
    //SMTPMail: Codeunit 400;
}

