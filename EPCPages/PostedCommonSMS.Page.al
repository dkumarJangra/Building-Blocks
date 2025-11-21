page 50056 "Posted Common SMS"
{
    Editable = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Common SMS Header";
    SourceTableView = WHERE(Status = CONST(Sent));
    ApplicationArea = All;
    UsageCategory = Documents;
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
                field("Created By"; Rec."Created By")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Creation Time"; Rec."Creation Time")
                {
                }
                field("Send SMS Date"; Rec."Send SMS Date")
                {
                }
                field("Send SMS Time"; Rec."Send SMS Time")
                {
                }
            }
            part("Direct Incentive Payment"; "Direct Incentive Payment")
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

