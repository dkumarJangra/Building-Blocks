codeunit 50012 "Send Customer Receipt As PDF"
{

    trigger OnRun()
    var
        Customer: Record Customer;
    begin
        UnitSetup.GET;
        UnitSetup.TESTFIELD("Save Customer Receipt Path");
        DocumentNo := '';
        NewApplicationPaymentEntry.RESET;
        NewApplicationPaymentEntry.SETRANGE("Document Type", NewApplicationPaymentEntry."Document Type"::BOND);
        //NewApplicationPaymentEntry.SETRANGE("Document No.",'AP2021001553');
        NewApplicationPaymentEntry.SETRANGE("Posting date", TODAY);
        NewApplicationPaymentEntry.SETRANGE("PDF Created", FALSE);
        IF NewApplicationPaymentEntry.FINDSET THEN BEGIN
            REPEAT
                NewConfirmedOrder.GET(NewApplicationPaymentEntry."Document No.");
                IF DocumentNo <> NewApplicationPaymentEntry."Document No." THEN BEGIN
                    Filename := UnitSetup."Save Customer Receipt Path" + NewApplicationPaymentEntry."Document No." + '.PDF';
                    CLEAR(MemberReceipt_12_Mail);
                    MemberReceipt_12_Mail.SetPostFilter(NewConfirmedOrder."No.", NewApplicationPaymentEntry."Posted Document No.");
                    MemberReceipt_12_Mail.Run(); //SAVEASPDF(Filename);
                    //REPORT.SAVEASPDF(97723, Filename, NewConfirmedOrder);
                END;
                COMMIT;
                // CLEAR(SMTPMail);
                // SMTPSetup.GET;
                Customer.RESET;
                IF Customer.GET(NewConfirmedOrder."Customer No.") THEN BEGIN
                    // SMTPMail.CreateMessage(SMTPSetup."Email Sender Name", SMTPSetup."Email Sender Email", Customer."E-Mail", 'Payment Receipt',
                    //    '', TRUE);

                    // SMTPMail.AppendBody('<br>');
                    // SMTPMail.AppendBody('<br/>');
                    // SMTPMail.AppendBody('Dear Sir / Madam,');
                    // SMTPMail.AppendBody('<br/>');
                    // SMTPMail.AppendBody('<br>');
                    // SMTPMail.AppendBody('Please find the attachment of Payment Receipt');
                    // SMTPMail.AppendBody('<br/>');
                    // SMTPMail.AppendBody('<br>');
                    // SMTPMail.AppendBody('Regards');
                    // SMTPMail.AppendBody('<br/>');
                    // SMTPMail.AppendBody('<br>');
                    // SMTPMail.AppendBody(SMTPSetup."Email Sender Name");
                    // SMTPMail.AppendBody('<br/>');
                    // SMTPMail.AddAttachment(Filename, Filename);
                    // SMTPMail.Send;
                    SLEEP(10000);
                END;

            UNTIL NewApplicationPaymentEntry.NEXT = 0;
        END;
    end;

    var
        NewConfirmedOrder: Record "New Confirmed Order";
        NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        DocumentNo: Code[20];
        Filename: Text;
        UnitSetup: Record "Unit Setup";
        //SMTPSetup: Record "SMTP Mail Setup";
        //SMTPMail: Codeunit 400;
        MemberReceipt_12_Mail: Report "Member Receipt_12_Mail";
}

