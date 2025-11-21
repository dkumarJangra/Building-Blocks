page 50216 "Jagritii Customer Req. Details"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Jagriti Customer Details";
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
                field("Site Office"; Rec."Site Office")
                {
                }
                field("Reporting Leader"; Rec."Reporting Leader")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Customer Mobile No."; Rec."Customer Mobile No.")
                {
                }
                field("Customer Application No."; Rec."Customer Application No.")
                {
                }
                field("P.A.N. No."; Rec."P.A.N. No.")
                {
                }
                field("Selection Type"; Rec."Selection Type")
                {
                    Caption = 'Item Types';
                }
                field("Plot No."; Rec."Plot No.")
                {
                }
                field("Plot Extent"; Rec."Plot Extent")
                {
                }
                field("Date of Join"; Rec."Date of Join")
                {
                }
                field("Last Date of Payment"; Rec."Last Date of Payment")
                {
                }
                field("No. of Gold Coins"; Rec."No. of Gold Coins")
                {
                }
                field("No. of Plates"; Rec."No. of Plates")
                {
                }
                field("No. of kamakshi"; Rec."No. of kamakshi")
                {
                }
                field("No. of kalasham"; Rec."No. of kalasham")
                {
                }
                field("Project Name"; Rec."Project Name")
                {
                }
                field("From Plot Extent"; Rec."From Plot Extent")
                {
                }
                field("To Plot Extent"; Rec."To Plot Extent")
                {
                }
                field("From Project Name"; Rec."From Project Name")
                {
                }
                field("To Project Name"; Rec."To Project Name")
                {
                }
                field("From Plot Code"; Rec."From Plot Code")
                {
                }
                field("To Plot Code"; Rec."To Plot Code")
                {
                }
                field("From Payment Plan"; Rec."From Payment Plan")
                {
                }
                field("To Payment Plan"; Rec."To Payment Plan")
                {
                }
                field("Total Amount Paid"; Rec."Total Amount Paid")
                {
                }
                field("From Application No."; Rec."From Application No.")
                {
                }
                field("To Application No."; Rec."To Application No.")
                {
                }
                field("Refund Amount %"; Rec."Refund Amount %")
                {
                }
                field("Refund Amount Paid"; Rec."Refund Amount Paid")
                {
                }
                field("Aadhar No."; Rec."Aadhar No.")
                {
                }
                field("Query Type"; Rec."Query Type")
                {
                }
                field("Customer Aadhar"; Rec."Customer Aadhar")
                {
                }
                field("From Name"; Rec."From Name")
                {
                }
                field("To Name"; Rec."To Name")
                {
                }
                field("From Mobile"; Rec."From Mobile")
                {
                }
                field("To Mobile"; Rec."To Mobile")
                {
                }
                field("From Email"; Rec."From Email")
                {
                }
                field("To Email"; Rec."To Email")
                {
                }
                field("From Address"; Rec."From Address")
                {
                }
                field("To Address"; Rec."To Address")
                {
                }
                field("From CustName"; Rec."From CustName")
                {
                }
                field("To CustName"; Rec."To CustName")
                {
                }
                field("Relation with Customer"; Rec."Relation with Customer")
                {
                }
                field("Old Customer Aadhar"; Rec."Old Customer Aadhar")
                {
                }
                field("New Customer Aadhar"; Rec."New Customer Aadhar")
                {
                }
                field("Co Cust Name"; Rec."Co Cust Name")
                {
                }
                field("Relation With Co Customer"; Rec."Relation With Co Customer")
                {
                }
                field("Co Customer Aadhar"; Rec."Co Customer Aadhar")
                {
                }
                field("Co Customer Pan"; Rec."Co Customer Pan")
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
                field("Correction Of"; Rec."Correction Of")
                {
                }
                field(Remarks; Rec.Remarks)
                {
                }
                field("Amount To Refund"; Rec."Amount To Refund")
                {
                }
            }
            part("Approval Entries"; "Jagriti Approval Entry")
            {
                SubPageLink = "Ref. Entry No." = FIELD("Request No."),
                              "Form Type" = CONST(CustomerForm);
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Customer Detail")
            {
                Image = "Report";

                trigger OnAction()
                begin
                    JagritiCustomerDetails.RESET;
                    JagritiCustomerDetails.SETRANGE("Request No.", Rec."Request No.");
                    IF JagritiCustomerDetails.FINDFIRST THEN
                        REPORT.RUN(50120, TRUE, TRUE, JagritiCustomerDetails);
                end;
            }
            action("Upload Document Details")
            {
                RunObject = Page "Jagrati Document upload Detl.";
                RunPageLink = "Form Type" = CONST(CustomerForm),
                              "Ref. Entry No." = FIELD("Request No.");
            }
            action("--------------------------------")
            {
            }
            action("Affidavit Document")
            {
                Visible = AffidavitUrl;

                trigger OnAction()
                begin
                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Upload Document Jagrati Path");
                    BBGSetups.TESTFIELD("New Upload Doc. Jagrati Path");  //ALLE 280323
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)"); //030325
                    JagritiCustomerURLData.RESET;
                    JagritiCustomerURLData.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiCustomerURLData.SETFILTER("Affidavit Url", '<>%1', '');
                    IF JagritiCustomerURLData.FINDSET THEN BEGIN
                        REPEAT
                            Clear(FileTransferCu);
                            FileTransferCu.JagratiExportFile(BBGSetups."Download Doc. Jagriti Path(BC)", JagritiCustomerURLData."Affidavit Url");
                        // IF FILE.EXISTS(BBGSetups."Upload Document Jagrati Path" + JagritiCustomerURLData."Affidavit Url") THEN
                        //     HYPERLINK(BBGSetups."Upload Document Jagrati Path" + JagritiCustomerURLData."Affidavit Url") //ALLE 280323
                        // ELSE
                        //     HYPERLINK(BBGSetups."New Upload Doc. Jagrati Path" + JagritiCustomerURLData."Affidavit Url");//ALLE 280323
                        UNTIL JagritiCustomerURLData.NEXT = 0;
                    END;
                end;
            }
            action("Orignal Receipt")
            {
                Visible = OrignalReceiptUrl;

                trigger OnAction()
                begin
                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Upload Document Jagrati Path");
                    BBGSetups.TESTFIELD("New Upload Doc. Jagrati Path");  //ALLE 280323
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)"); //030325
                    JagritiCustomerURLData.RESET;
                    JagritiCustomerURLData.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiCustomerURLData.SETFILTER("Orignal Receipt Url", '<>%1', '');
                    IF JagritiCustomerURLData.FINDSET THEN BEGIN
                        REPEAT
                            Clear(FileTransferCu);
                            FileTransferCu.JagratiExportFile(BBGSetups."Download Doc. Jagriti Path(BC)", JagritiCustomerURLData."Orignal Receipt Url");
                        UNTIL JagritiCustomerURLData.NEXT = 0;
                    END;
                end;
            }
            action("Booking Form")
            {
                Visible = BookingFormUrl;

                trigger OnAction()
                begin
                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Upload Document Jagrati Path");
                    BBGSetups.TESTFIELD("New Upload Doc. Jagrati Path");  //ALLE 280323
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)"); //030325
                    JagritiCustomerURLData.RESET;
                    JagritiCustomerURLData.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiCustomerURLData.SETFILTER("Booking Form Url", '<>%1', '');
                    IF JagritiCustomerURLData.FINDSET THEN BEGIN
                        REPEAT
                            Clear(FileTransferCu);
                            FileTransferCu.JagratiExportFile(BBGSetups."Download Doc. Jagriti Path(BC)", JagritiCustomerURLData."Booking Form Url");
                        UNTIL JagritiCustomerURLData.NEXT = 0;
                    END;
                end;
            }
            action("New Customer PAN")
            {
                Visible = NewCustomerpanUrl;

                trigger OnAction()
                begin
                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Upload Document Jagrati Path");
                    BBGSetups.TESTFIELD("New Upload Doc. Jagrati Path");  //ALLE 280323
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)"); //030325
                    JagritiCustomerURLData.RESET;
                    JagritiCustomerURLData.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiCustomerURLData.SETFILTER("New Customer pan Url", '<>%1', '');
                    IF JagritiCustomerURLData.FINDSET THEN BEGIN
                        REPEAT
                            Clear(FileTransferCu);
                            FileTransferCu.JagratiExportFile(BBGSetups."Download Doc. Jagriti Path(BC)", JagritiCustomerURLData."New Customer pan Url");
                        UNTIL JagritiCustomerURLData.NEXT = 0;
                    END;
                end;
            }
            action("New Customer Aadhaar")
            {
                Visible = NewCustomerAdhrUrl;

                trigger OnAction()
                begin
                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Upload Document Jagrati Path");
                    BBGSetups.TESTFIELD("New Upload Doc. Jagrati Path");  //ALLE 280323
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)"); //030325
                    JagritiCustomerURLData.RESET;
                    JagritiCustomerURLData.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiCustomerURLData.SETFILTER("New Customer Adhr Url", '<>%1', '');
                    IF JagritiCustomerURLData.FINDSET THEN BEGIN
                        REPEAT
                            Clear(FileTransferCu);
                            FileTransferCu.JagratiExportFile(BBGSetups."Download Doc. Jagriti Path(BC)", JagritiCustomerURLData."New Customer Adhr Url");
                        UNTIL JagritiCustomerURLData.NEXT = 0;
                    END;
                end;
            }
            action("Customer Aadhaar")
            {
                Visible = CustomerAdhrUrl;

                trigger OnAction()
                begin
                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Upload Document Jagrati Path");
                    BBGSetups.TESTFIELD("New Upload Doc. Jagrati Path");  //ALLE 280323
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)"); //030325
                    JagritiCustomerURLData.RESET;
                    JagritiCustomerURLData.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiCustomerURLData.SETFILTER("Customer Adhr Url", '<>%1', '');
                    IF JagritiCustomerURLData.FINDSET THEN BEGIN
                        REPEAT
                            Clear(FileTransferCu);
                            FileTransferCu.JagratiExportFile(BBGSetups."Download Doc. Jagriti Path(BC)", JagritiCustomerURLData."Customer Adhr Url");
                        UNTIL JagritiCustomerURLData.NEXT = 0;
                    END;
                end;
            }
            action(Receipt)
            {
                Visible = ReceiptUrl;

                trigger OnAction()
                begin
                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Upload Document Jagrati Path");
                    BBGSetups.TESTFIELD("New Upload Doc. Jagrati Path");  //ALLE 280323
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)"); //030325
                    JagritiCustomerURLData.RESET;
                    JagritiCustomerURLData.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiCustomerURLData.SETFILTER("Receipt Url", '<>%1', '');
                    IF JagritiCustomerURLData.FINDSET THEN BEGIN
                        REPEAT
                            Clear(FileTransferCu);
                            FileTransferCu.JagratiExportFile(BBGSetups."Download Doc. Jagriti Path(BC)", JagritiCustomerURLData."Receipt Url");
                        UNTIL JagritiCustomerURLData.NEXT = 0;
                    END;
                end;
            }
            action("Written Letter")
            {
                Visible = WrittenLetterUrl;

                trigger OnAction()
                begin
                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Upload Document Jagrati Path");
                    BBGSetups.TESTFIELD("New Upload Doc. Jagrati Path");  //ALLE 280323
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)"); //030325
                    JagritiCustomerURLData.RESET;
                    JagritiCustomerURLData.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiCustomerURLData.SETFILTER("Written Letter Url", '<>%1', '');
                    IF JagritiCustomerURLData.FINDSET THEN BEGIN
                        REPEAT
                            Clear(FileTransferCu);
                            FileTransferCu.JagratiExportFile(BBGSetups."Download Doc. Jagriti Path(BC)", JagritiCustomerURLData."Written Letter Url");
                        UNTIL JagritiCustomerURLData.NEXT = 0;
                    END;
                end;
            }
            action(Aadhar)
            {
                Visible = AadharUrl;

                trigger OnAction()
                begin
                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Upload Document Jagrati Path");
                    BBGSetups.TESTFIELD("New Upload Doc. Jagrati Path");  //ALLE 280323
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)"); //030325
                    JagritiCustomerURLData.RESET;
                    JagritiCustomerURLData.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiCustomerURLData.SETFILTER(AadharUrl, '<>%1', '');
                    IF JagritiCustomerURLData.FINDSET THEN BEGIN
                        REPEAT
                            Clear(FileTransferCu);
                            FileTransferCu.JagratiExportFile(BBGSetups."Download Doc. Jagriti Path(BC)", JagritiCustomerURLData.AadharUrl);
                        UNTIL JagritiCustomerURLData.NEXT = 0;
                    END;
                end;
            }
            action("Form 32")
            {
                Visible = Form32Url;

                trigger OnAction()
                begin
                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Upload Document Jagrati Path");
                    BBGSetups.TESTFIELD("New Upload Doc. Jagrati Path");  //ALLE 280323
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)"); //030325
                    JagritiCustomerURLData.RESET;
                    JagritiCustomerURLData.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiCustomerURLData.SETFILTER("Form 32 Url", '<>%1', '');
                    IF JagritiCustomerURLData.FINDSET THEN BEGIN
                        REPEAT
                            Clear(FileTransferCu);
                            FileTransferCu.JagratiExportFile(BBGSetups."Download Doc. Jagriti Path(BC)", JagritiCustomerURLData."Form 32 Url");
                        UNTIL JagritiCustomerURLData.NEXT = 0;
                    END;
                end;
            }
            action("PAN Document")
            {
                Visible = PANUrl;

                trigger OnAction()
                begin
                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Upload Document Jagrati Path");
                    BBGSetups.TESTFIELD("New Upload Doc. Jagrati Path");  //ALLE 280323
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)"); //030325
                    JagritiCustomerURLData.RESET;
                    JagritiCustomerURLData.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiCustomerURLData.SETFILTER("PAN Url", '<>%1', '');
                    IF JagritiCustomerURLData.FINDSET THEN BEGIN
                        REPEAT
                            Clear(FileTransferCu);
                            FileTransferCu.JagratiExportFile(BBGSetups."Download Doc. Jagriti Path(BC)", JagritiCustomerURLData."PAN Url");
                        UNTIL JagritiCustomerURLData.NEXT = 0;
                    END;
                end;
            }
            action("Requisition Document")
            {
                Visible = RequisitionUrl;

                trigger OnAction()
                begin
                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Upload Document Jagrati Path");
                    BBGSetups.TESTFIELD("New Upload Doc. Jagrati Path");  //ALLE 280323
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)"); //030325
                    JagritiCustomerURLData.RESET;
                    JagritiCustomerURLData.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiCustomerURLData.SETFILTER("Requisition Url", '<>%1', '');
                    IF JagritiCustomerURLData.FINDSET THEN BEGIN
                        REPEAT
                            Clear(FileTransferCu);
                            FileTransferCu.JagratiExportFile(BBGSetups."Download Doc. Jagriti Path(BC)", JagritiCustomerURLData."Requisition Url");
                        UNTIL JagritiCustomerURLData.NEXT = 0;
                    END;
                end;
            }
            action("Customer Picture")
            {
                Visible = CustomerPictureUrl;

                trigger OnAction()
                begin
                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Upload Document Jagrati Path");
                    BBGSetups.TESTFIELD("New Upload Doc. Jagrati Path");  //ALLE 280323
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)"); //030325
                    JagritiCustomerURLData.RESET;
                    JagritiCustomerURLData.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiCustomerURLData.SETFILTER("Customer Picture Url", '<>%1', '');
                    IF JagritiCustomerURLData.FINDSET THEN BEGIN
                        REPEAT
                            Clear(FileTransferCu);
                            FileTransferCu.JagratiExportFile(BBGSetups."Download Doc. Jagriti Path(BC)", JagritiCustomerURLData."Customer Picture Url");
                        UNTIL JagritiCustomerURLData.NEXT = 0;
                    END;
                end;
            }
            action("Cancellation Form")
            {
                Visible = CancellationFormUrl;

                trigger OnAction()
                begin
                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Upload Document Jagrati Path");
                    BBGSetups.TESTFIELD("New Upload Doc. Jagrati Path");  //ALLE 280323
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)"); //030325
                    JagritiCustomerURLData.RESET;
                    JagritiCustomerURLData.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiCustomerURLData.SETFILTER("Cancellation Form Url", '<>%1', '');
                    IF JagritiCustomerURLData.FINDSET THEN BEGIN
                        REPEAT
                            Clear(FileTransferCu);
                            FileTransferCu.JagratiExportFile(BBGSetups."Download Doc. Jagriti Path(BC)", JagritiCustomerURLData."Cancellation Form Url");
                        UNTIL JagritiCustomerURLData.NEXT = 0;
                    END;
                end;
            }
            action("Bank Passbook")
            {
                Visible = BankPassbookUrl;

                trigger OnAction()
                begin
                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Upload Document Jagrati Path");
                    BBGSetups.TESTFIELD("New Upload Doc. Jagrati Path");  //ALLE 280323
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)"); //030325
                    JagritiCustomerURLData.RESET;
                    JagritiCustomerURLData.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiCustomerURLData.SETFILTER("Bank Passbook Url", '<>%1', '');
                    IF JagritiCustomerURLData.FINDSET THEN BEGIN
                        REPEAT
                            Clear(FileTransferCu);
                            FileTransferCu.JagratiExportFile(BBGSetups."Download Doc. Jagriti Path(BC)", JagritiCustomerURLData."Bank Passbook Url");
                        UNTIL JagritiCustomerURLData.NEXT = 0;
                    END;
                end;
            }
            action("Uploded Document")
            {
                Visible = UplodedDocLink;

                trigger OnAction()
                begin
                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Upload Document Jagrati Path");
                    BBGSetups.TESTFIELD("New Upload Doc. Jagrati Path");  //ALLE 280323
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)"); //030325
                    JagritiCustomerURLData.RESET;
                    JagritiCustomerURLData.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiCustomerURLData.SETFILTER("Uploded Doc Link", '<>%1', '');
                    IF JagritiCustomerURLData.FINDSET THEN BEGIN
                        REPEAT
                            Clear(FileTransferCu);
                            FileTransferCu.JagratiExportFile(BBGSetups."Download Doc. Jagriti Path(BC)", JagritiCustomerURLData."Uploded Doc Link");
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
                    BBGSetups.TESTFIELD("New Upload Doc. Jagrati Path");  //ALLE 280323
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)"); //030325
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
                    BBGSetups.TESTFIELD("New Upload Doc. Jagrati Path");  //ALLE 280323
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)"); //030325
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
                    BBGSetups.TESTFIELD("New Upload Doc. Jagrati Path");  //ALLE 280323
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)"); //030325
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
            action("Yellow Form Proof")
            {
                Visible = YelloformLinlk;

                trigger OnAction()
                begin
                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Upload Document Jagrati Path");
                    BBGSetups.TESTFIELD("New Upload Doc. Jagrati Path");  //ALLE 280323
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)"); //030325
                    JagritiCustomerURLData.RESET;
                    JagritiCustomerURLData.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiCustomerURLData.SETFILTER("Yellow Form Url", '<>%1', '');
                    IF JagritiCustomerURLData.FINDSET THEN BEGIN
                        REPEAT
                            Clear(FileTransferCu);
                            FileTransferCu.JagratiExportFile(BBGSetups."Download Doc. Jagriti Path(BC)", JagritiCustomerURLData."Yellow Form Url");

                        UNTIL JagritiCustomerURLData.NEXT = 0;
                    END;
                end;
            }
            action("Blue Form Proof")
            {
                Visible = BlueFormLink;

                trigger OnAction()
                begin
                    BBGSetups.GET;
                    BBGSetups.TESTFIELD("Upload Document Jagrati Path");
                    BBGSetups.TESTFIELD("New Upload Doc. Jagrati Path");  //ALLE 280323
                    BBGSetups.TestField("Download Doc. Jagriti Path(BC)"); //030325
                    JagritiCustomerURLData.RESET;
                    JagritiCustomerURLData.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiCustomerURLData.SETFILTER("Blue Form Url", '<>%1', '');
                    IF JagritiCustomerURLData.FINDSET THEN BEGIN
                        REPEAT
                            Clear(FileTransferCu);
                            FileTransferCu.JagratiExportFile(BBGSetups."Download Doc. Jagriti Path(BC)", JagritiCustomerURLData."Blue Form Url");
                        UNTIL JagritiCustomerURLData.NEXT = 0;
                    END;
                end;
            }
            action("Update Approver Name")
            {

                trigger OnAction()
                var
                    JagritiApprovalEntry: Record "Jagriti Approval Entry";
                    UserSetup: Record "User Setup";
                begin
                    JagritiApprovalEntry.RESET;
                    JagritiApprovalEntry.SETRANGE("Ref. Entry No.", Rec."Request No.");
                    JagritiApprovalEntry.SETRANGE("Form Type", JagritiApprovalEntry."Form Type"::CustomerForm);
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
                    JagritiApprovalEntry.SETRANGE("Form Type", JagritiApprovalEntry."Form Type"::CustomerForm);
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
                    JagritiApprovalEntry.SETRANGE("Form Type", JagritiApprovalEntry."Form Type"::CustomerForm);
                    JagritiApprovalEntry.SETRANGE("Mail Required", FALSE);
                    JagritiApprovalEntry.SETRANGE(Status, JagritiApprovalEntry.Status::Rejected);
                    IF JagritiApprovalEntry.FINDFIRST THEN BEGIN
                        // IF NOT PendingApproval THEN BEGIN  //251124 Comment line
                        Rec."Request Status" := 'Rejected';
                        Rec."Request Pending From" := '';
                        Rec.MODIFY;
                        // END;  //251124 Comment line
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
        JagritiCustomerDetails: Record "Jagriti Customer Details";
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
        JagritiApprovalEntry: Record "Jagriti Approval Entry";
        YelloformLinlk: Boolean;
        BlueFormLink: Boolean;
        FileTransferCu: codeunit "File Transfer";

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
        YelloformLinlk := FALSE;
        BlueFormLink := FALSE;


        JagritiCustomerURLData.RESET;
        JagritiCustomerURLData.SETRANGE("Form Type", JagritiCustomerURLData."Form Type"::CustomerForm);
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
                IF JagritiCustomerURLData."Yellow Form Url" <> '' THEN
                    YelloformLinlk := TRUE;
                IF JagritiCustomerURLData."Blue Form Url" <> '' THEN
                    BlueFormLink := TRUE;
            UNTIL JagritiCustomerURLData.NEXT = 0;
    end;
}

