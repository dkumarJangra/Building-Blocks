codeunit 97747 "Job Queue for R-50041_1"
{
    TableNo = Vendor;

    trigger OnRun()
    begin
        //   REPORT.RUN(50165,FALSE,FALSE,Rec);
        CLEAR(NBATReport);
        Vend.RESET;
        Vend.SETRANGE("No.", VendFilters);
        IF Vend.FINDFIRST THEN BEGIN
            NBATReport.Setfilters(VendFilters, BatchNos, FromDt, ToDt, Entry_No1);
            NBATReport.RUN();
            // ReportOStream := TempBlob.CreateOutStream();
            // NBATReport.SAVEAS('', REPORTFORMAT::Excel, ReportOStream, ReportRecRef);
            // AttachmentStream := TempBlob.CreateInStream();
        end;




    end;


    var
        Vend: Record Vendor;
        NBATReport: Report "New Team Collection Det Job";
        VendFilters: Code[20];
        BatchNos: Code[20];
        FromDt: Date;
        ToDt: Date;
        Entry_No1: Integer;

        Email: Codeunit Email;
        AttachmentStream: InStream;
        HtmlEmailBody: text;
        smtpMail: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        SMTPSetup: Record "Email Account";
        TempBlob: Codeunit "Temp Blob";
        FileNameTxt: Text;
        ReportRecRef: RecordRef;
        ReportOStream: OutStream;
        MailSent: Boolean;
        NewappPayEntry: Record "NewApplication Payment Entry";
        RepotREqMobile: Record "Report Request from Web/Mb.";



    procedure Setfilteres(VendFilter: Code[20]; BatchNo: Code[20]; FromDate: Date; ToDate: Date; Entry_No: Integer)
    begin
        VendFilters := VendFilter;
        BatchNos := BatchNo;
        FromDt := FromDate;
        ToDt := ToDate;
        Entry_No1 := Entry_No;
    end;
}

