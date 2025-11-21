page 50213 "Jagrati Associate Req. Details"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Jagriti Assoicate Details";
    SourceTableView = WHERE("Special Request" = CONST(false));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Request No."; Rec."Request No.")
                {
                }
                field("Request Type"; Rec."Request Type")
                {
                }
                field("Requester ID"; Rec."Requester ID")
                {
                }
                field("Mobile No."; Rec."Mobile No.")
                {
                }
                field("P.A.N. No."; Rec."P.A.N. No.")
                {
                }
                field(Month; Rec.Month)
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("Direct/Team Bonanza Selection"; Rec."Direct/Team Bonanza Selection")
                {
                }
                field("if Direct Applications"; Rec."if Direct Applications")
                {
                }
                field("Customer Application No."; Rec."Customer Application No.")
                {
                }
                field("Selection Type"; Rec."Selection Type")
                {
                }
                field("From Associate ID"; Rec."From Associate ID")
                {
                }
                field("To Associate ID"; Rec."To Associate ID")
                {
                }
                field("Upload Document"; Rec."Upload Document")
                {
                }
                field("Aadhar Card No."; Rec."Aadhar Card No.")
                {
                }
                field("Bank Name"; Rec."Bank Name")
                {
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                }
                field("Bank IFSC Code"; Rec."Bank IFSC Code")
                {
                }
                field("Reporting Leader"; Rec."Reporting Leader")
                {
                }
                field("Site Code"; Rec."Site Code")
                {
                }
                field("Request Date"; Rec."Request Date")
                {
                }
                field("Request Time"; Rec."Request Time")
                {
                }
                field("IBA ID"; Rec."IBA ID")
                {
                }
                field("IBA Name"; Rec."IBA Name")
                {
                }
                field("Associate Id to Activate"; Rec."Associate Id to Activate")
                {
                }
                field("Associate Id to Activate Name"; Rec."Associate Id to Activate Name")
                {
                }
                field("No. of Team Bonanza"; Rec."No. of Team Bonanza")
                {
                }
                field("Extent Value"; Rec."Extent Value")
                {
                }
                field("Team Code"; Rec."Team Code")
                {
                }
                field("Leader Code"; Rec."Leader Code")
                {
                }
                field("Sub Team Code"; Rec."Sub Team Code")
                {
                }
                field("Request Status"; Rec."Request Status")
                {
                }
                field("Request Pending From"; Rec."Request Pending From")
                {
                }
                field(remarks; Rec.remarks)
                {
                    Editable = False;
                }
            }
            part("Approval Entries"; "Jagriti Approval Entry")
            {
                SubPageLink = "Ref. Entry No." = FIELD("Request No."),
                              "Form Type" = CONST(AssociateForm);
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Associate Detail")
            {
                Image = "Report";

                trigger OnAction()
                begin
                    JagritiAssoicateDetails.RESET;
                    JagritiAssoicateDetails.SETRANGE("Request No.", Rec."Request No.");
                    IF JagritiAssoicateDetails.FINDFIRST THEN
                        REPORT.RUN(50121, TRUE, TRUE, JagritiAssoicateDetails);
                end;
            }
            action("Direct Bonanza Details")
            {
                RunObject = Page "Direct Bonanza Details";
                RunPageLink = "Ref. Entry No." = FIELD("Request No.");
            }
            action("Upload Document Details")
            {
                RunObject = Page "Jagrati Document upload Detl.";
                RunPageLink = "Form Type" = CONST(AssociateForm),
                              "Ref. Entry No." = FIELD("Request No.");
            }
            action("--------------------------------")
            {
            }
            action("Uploded Document")
            {
                Visible = UplodedDocLink;

                trigger OnAction()
                begin
                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Upload Document Jagrati Path");
                    BBGSetups.TESTFIELD("New Upload Doc. Jagrati Path");  //ALLE 230823
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)");

                    JagritiCustomerURLData.RESET;
                    JagritiCustomerURLData.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiCustomerURLData.SETFILTER("Uploded Doc Link", '<>%1', '');
                    IF JagritiCustomerURLData.FINDSET THEN BEGIN
                        REPEAT
                            Clear(FileTransferCu);
                            FileTransferCu.JagratiExportFile(BBGSetups."Download Doc. Jagriti Path(BC)", JagritiCustomerURLData."Uploded Doc Link");
                        // IF FILE.EXISTS(BBGSetups."Upload Document Jagrati Path" + JagritiCustomerURLData."Uploded Doc Link") THEN     //ALLE 230823  Added
                        //HYPERLINK(BBGSetups."Upload Document Jagrati Path" + JagritiCustomerURLData."Uploded Doc Link")
                        // ELSE
                        //     HYPERLINK(BBGSetups."New Upload Doc. Jagrati Path" + JagritiCustomerURLData."Uploded Doc Link");  //ALLE 230823 code Added

                        UNTIL JagritiCustomerURLData.NEXT = 0;
                    END;
                end;
            }
            action("PAN Proof")
            {
                Visible = PANProofLink;

                trigger OnAction()
                begin

                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Upload Document Jagrati Path");
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)");
                    JagritiCustomerURLData.RESET;
                    JagritiCustomerURLData.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiCustomerURLData.SETFILTER("PAN Proof Link", '<>%1', '');
                    IF JagritiCustomerURLData.FINDSET THEN BEGIN
                        REPEAT
                            Clear(FileTransferCu);
                            FileTransferCu.JagratiExportFile(BBGSetups."Download Doc. Jagriti Path(BC)", JagritiCustomerURLData."PAN Proof Link");

                        UNTIL JagritiCustomerURLData.NEXT = 0;
                    END;
                end;
            }
            action("Bank Detail Proof")
            {
                Visible = BankDetailProofLink;

                trigger OnAction()
                begin
                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Upload Document Jagrati Path");
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)");
                    JagritiCustomerURLData.RESET;
                    JagritiCustomerURLData.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiCustomerURLData.SETFILTER("Bank Detail Proof Link", '<>%1', '');
                    IF JagritiCustomerURLData.FINDSET THEN BEGIN
                        REPEAT
                            Clear(FileTransferCu);
                            FileTransferCu.JagratiExportFile(BBGSetups."Download Doc. Jagriti Path(BC)", JagritiCustomerURLData."Bank Detail Proof Link");
                        UNTIL JagritiCustomerURLData.NEXT = 0;
                    END;
                end;
            }
            action("Aadhaar Proof")
            {
                Visible = AadhaarProofLink;

                trigger OnAction()
                begin
                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Upload Document Jagrati Path");
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)");
                    JagritiCustomerURLData.RESET;
                    JagritiCustomerURLData.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiCustomerURLData.SETFILTER("Aadhaar Proof Link", '<>%1', '');
                    IF JagritiCustomerURLData.FINDSET THEN BEGIN
                        REPEAT
                            Clear(FileTransferCu);
                            FileTransferCu.JagratiExportFile(BBGSetups."Download Doc. Jagriti Path(BC)", JagritiCustomerURLData."Aadhaar Proof Link");
                        UNTIL JagritiCustomerURLData.NEXT = 0;
                    END;
                end;
            }

            // Code added Start 29072025 
            action("Other Documents")
            {
                Visible = OtherDocumentLink;

                trigger OnAction()
                begin
                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Upload Document Jagrati Path");
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)");
                    JagritiCustomerURLData.RESET;
                    JagritiCustomerURLData.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiCustomerURLData.SETFILTER("Other Doc Urls", '<>%1', '');
                    IF JagritiCustomerURLData.FINDSET THEN BEGIN
                        REPEAT
                            Clear(FileTransferCu);
                            FileTransferCu.JagratiExportFile(BBGSetups."Download Doc. Jagriti Path(BC)", JagritiCustomerURLData."Other Doc Urls");
                        UNTIL JagritiCustomerURLData.NEXT = 0;
                    END;
                end;
            }
            // Code added END 29072025 
            action("Update Approver Name")
            {

                trigger OnAction()
                var
                    JagritiApprovalEntry: Record "Jagriti Approval Entry";
                    UserSetup: Record "User Setup";
                begin
                    JagritiApprovalEntry.RESET;
                    JagritiApprovalEntry.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiApprovalEntry.SETRANGE("Form Type", JagritiApprovalEntry."Form Type"::AssociateForm);
                    IF JagritiApprovalEntry.FINDSET THEN
                        REPEAT
                            UserSetup.RESET;
                            IF UserSetup.GET(JagritiApprovalEntry."Approver ID") THEN BEGIN
                                IF UserSetup."Display Name in Jagriti" <> '' THEN BEGIN
                                    JagritiApprovalEntry."Approver Name" := UserSetup."Display Name in Jagriti";
                                    JagritiApprovalEntry.MODIFY;
                                END;
                            END;
                        UNTIL JagritiApprovalEntry.NEXT = 0;
                end;
            }
            action("Update Status")
            {

                trigger OnAction()
                var
                    PendingApproval: Boolean;
                begin
                    IF (USERID <> 'BCUSER') AND (USERID <> 'NAVUSER4') THEN
                        ERROR('Contact Admin');

                    PendingApproval := FALSE;

                    JagritiApprovalEntry.RESET;
                    JagritiApprovalEntry.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiApprovalEntry.SETRANGE("Form Type", JagritiApprovalEntry."Form Type"::AssociateForm);
                    JagritiApprovalEntry.SETRANGE("Mail Required", FALSE);
                    JagritiApprovalEntry.SETRANGE(Status, JagritiApprovalEntry.Status::Pending);
                    IF JagritiApprovalEntry.FINDFIRST THEN
                        PendingApproval := TRUE;

                    IF NOT PendingApproval THEN BEGIN
                        Rec."Request Status" := 'Completed';
                        Rec."Request Pending From" := '';
                        Rec.MODIFY;
                    END;


                    JagritiApprovalEntry.RESET;
                    JagritiApprovalEntry.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiApprovalEntry.SETRANGE("Form Type", JagritiApprovalEntry."Form Type"::AssociateForm);
                    JagritiApprovalEntry.SETRANGE("Mail Required", FALSE);
                    JagritiApprovalEntry.SETRANGE(Status, JagritiApprovalEntry.Status::Rejected);
                    IF JagritiApprovalEntry.FINDFIRST THEN BEGIN
                        IF NOT PendingApproval THEN BEGIN
                            Rec."Request Status" := 'Rejected';
                            Rec."Request Pending From" := '';
                            Rec.MODIFY;
                        END;
                    END;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ShowDocuments;
    end;

    trigger OnOpenPage()
    begin
        ShowDocuments;
    end;

    var
        JagritiAssoicateDetails: Record "Jagriti Assoicate Details";
        PageUserDocumentAttachment: Page "User Document Attachment";
        RecUserDocumentAttachment: Record "User Document Attachment";
        BBGSetups: Record "BBG Setups";
        JagritiCustomerURLData: Record "Jagriti Customer URL Data";
        "---------Show Documents---": Integer;
        AffidavitUrl: Boolean;
        OrignalReceiptUrl: Boolean;
        BookingFormUrl: Boolean;
        NewCustomerpanUrl: Boolean;
        NewCustomerAdhrUrl: Boolean;
        CustomerAdhrUrl: Boolean;
        ReceiptUrl: Boolean;
        WrittenLetterUrl: Boolean;
        AadharUrl: Boolean;
        Form32Url: Boolean;
        PANUrl: Boolean;
        RequisitionUrl: Boolean;
        CustomerPictureUrl: Boolean;
        CancellationFormUrl: Boolean;
        BankPassbookUrl: Boolean;
        UplodedDocLink: Boolean;
        PANProofLink: Boolean;
        BankDetailProofLink: Boolean;
        AadhaarProofLink: Boolean;
        OtherDocumentLink: Boolean;
        JagritiApprovalEntry: Record "Jagriti Approval Entry";
        FileTransferCu: Codeunit "File Transfer";

    local procedure ShowDocuments()
    var
        JagritiCustomerURLData: Record "Jagriti Customer URL Data";
    begin
        AffidavitUrl := FALSE;
        OrignalReceiptUrl := FALSE;
        BookingFormUrl := FALSE;
        NewCustomerpanUrl := FALSE;
        NewCustomerAdhrUrl := FALSE;
        CustomerAdhrUrl := FALSE;
        ReceiptUrl := FALSE;
        WrittenLetterUrl := FALSE;
        AadharUrl := FALSE;
        Form32Url := FALSE;
        PANUrl := FALSE;
        RequisitionUrl := FALSE;
        CustomerPictureUrl := FALSE;
        CancellationFormUrl := FALSE;
        BankPassbookUrl := FALSE;
        UplodedDocLink := FALSE;
        PANProofLink := FALSE;
        BankDetailProofLink := FALSE;
        AadhaarProofLink := FALSE;
        OtherDocumentLink := False;


        JagritiCustomerURLData.RESET;
        JagritiCustomerURLData.SETRANGE("Form Type", JagritiCustomerURLData."Form Type"::AssociateForm);
        JagritiCustomerURLData.SETRANGE("Ref. Entry No.", Rec."Request No.");
        IF JagritiCustomerURLData.FINDSET THEN
            REPEAT
                IF JagritiCustomerURLData."Affidavit Url" <> '' THEN
                    AffidavitUrl := TRUE;
                IF JagritiCustomerURLData."Orignal Receipt Url" <> '' THEN
                    OrignalReceiptUrl := TRUE;
                IF JagritiCustomerURLData."Booking Form Url" <> '' THEN
                    BookingFormUrl := TRUE;
                IF JagritiCustomerURLData."New Customer pan Url" <> '' THEN
                    NewCustomerpanUrl := TRUE;
                IF JagritiCustomerURLData."New Customer Adhr Url" <> '' THEN
                    NewCustomerAdhrUrl := TRUE;
                IF JagritiCustomerURLData."Customer Adhr Url" <> '' THEN
                    CustomerAdhrUrl := TRUE;
                IF JagritiCustomerURLData."Receipt Url" <> '' THEN
                    ReceiptUrl := TRUE;
                IF JagritiCustomerURLData."Written Letter Url" <> '' THEN
                    WrittenLetterUrl := TRUE;
                IF JagritiCustomerURLData.AadharUrl <> '' THEN
                    AadharUrl := TRUE;
                IF JagritiCustomerURLData."Form 32 Url" <> '' THEN
                    Form32Url := TRUE;
                IF JagritiCustomerURLData."PAN Url" <> '' THEN
                    PANUrl := TRUE;
                IF JagritiCustomerURLData."Requisition Url" <> '' THEN
                    RequisitionUrl := TRUE;
                IF JagritiCustomerURLData."Customer Picture Url" <> '' THEN
                    CustomerPictureUrl := TRUE;
                IF JagritiCustomerURLData."Cancellation Form Url" <> '' THEN
                    CancellationFormUrl := TRUE;
                IF JagritiCustomerURLData."Bank Passbook Url" <> '' THEN
                    BankPassbookUrl := TRUE;
                IF JagritiCustomerURLData."Uploded Doc Link" <> '' THEN
                    UplodedDocLink := TRUE;
                IF JagritiCustomerURLData."PAN Proof Link" <> '' THEN
                    PANProofLink := TRUE;
                IF JagritiCustomerURLData."Bank Detail Proof Link" <> '' THEN
                    BankDetailProofLink := TRUE;
                IF JagritiCustomerURLData."Aadhaar Proof Link" <> '' THEN
                    AadhaarProofLink := TRUE;
                //Code Added start 29072025
                IF JagritiCustomerURLData."Other Doc Urls" <> '' THEN
                    OtherDocumentLink := TRUE;
            //Code Added END 29072025

            UNTIL JagritiCustomerURLData.NEXT = 0;
    end;
}

