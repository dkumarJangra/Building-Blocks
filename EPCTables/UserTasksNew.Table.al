table 97736 "User Tasks New"
{
    // //NDALLE 211205
    // //for blk to remove hr & grn part for time being
    // //dds - for alt user - done on 24Dec2008
    // ALLEPG RIL1.05 050911 : Code added for invoice return.
    // ALLEPG RIL1.06 080911 : Code added for Indent Return.
    // ALLEPG 271211 : Code added for job amendment & archive.
    // 
    //  //RAHEE1.00 040512 Added code for not required approver in case of Material Reutrn Subcon to Main Site.
    // ALLECK 070613: Added code for Return Approval


    fields
    {
        field(1; "Transaction Type"; Option)
        {
            Caption = 'Transaction Type';
            OptionCaption = 'Purchase,Sale';
            OptionMembers = Purchase,Sale;
        }
        field(2; "Document Type"; Option)
        {
            OptionCaption = 'Indent,Purchase Order,Purchase Order Amendment,GRN,Invoice,Leave,OD,Sale Order,Debit Note,Transfer Order,Credit Memo,Award Note,Job,Job Amendment,Enquiry,Service Invoice,Quote,Contract Quote,Sale quote,Sales Order Amendment';
            OptionMembers = Indent,"Purchase Order","Purchase Order Amendment",GRN,Invoice,Leave,OD,"Sale Order","Debit Note","Transfer Order","Credit Memo","Award Note",Job,"Job Amendment",Enquiry,"Service Invoice",Quote,"Contract Quote","Sale quote","Sales Order Amendment";
        }
        field(4; "Sub Document Type"; Option)
        {
            OptionCaption = ' ,WO-ICB,WO-NICB,Regular PO,Repeat PO,Confirmatory PO,Direct PO,GRN for PO,GRN for JSPL,GRN for Packages,GRN for Fabricated Material for WO,JES for WO,GRN-Direct Purchase,Freight Advice,Order,Invoice,Direct TO,Regular TO,Quote,FA,Man Power,Leave,Travel,Others,FA Sale,Hire';
            OptionMembers = " ","WO-ICB","WO-NICB","Regular PO","Repeat PO","Confirmatory PO","Direct PO","GRN for PO","GRN for JSPL","GRN for Packages","GRN for Fabricated Material for WO","JES for WO","GRN-Direct Purchase","Freight Advice","Order",Invoice,"Direct TO","Regular TO",Quote,FA,"Man Power",Leave,Travel,Others,"FA Sale",Hire;
        }
        field(5; "Document No"; Code[20])
        {
        }
        field(6; Initiator; Code[20])
        {
        }
        field(7; "Document Approval Line No"; Integer)
        {
        }
        field(8; "Approvar ID"; Code[20])
        {
        }
        field(9; "Alternate Approvar ID"; Code[20])
        {
        }
        field(10; "Min Amount Limit"; Decimal)
        {
            Description = 'na';
        }
        field(11; "Max Amount Limit"; Decimal)
        {
            Description = 'na';
        }
        field(12; "Sent Date"; Date)
        {
            Caption = 'Sent Date';
        }
        field(13; "Sent Time"; Time)
        {
            Caption = 'Sent Time';
        }
        field(14; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = ' ,Approved,Returned,Not Required,Rejected';
            OptionMembers = " ",Approved,Returned,"Not Required",Rejected;
        }
        field(15; Activity; Option)
        {
            Caption = 'Activity';
            Description = 'na';
            OptionCaption = 'Authorization';
            OptionMembers = Authorization;
        }
        field(16; "Task/Authorization Level"; Integer)
        {
            Caption = 'Task/Authorization Level';
            Description = 'na';
        }
        field(17; Description; Text[80])
        {
            Caption = 'Description';
        }
        field(18; "Received From"; Code[20])
        {
            Caption = 'Received From';
            NotBlank = true;
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "User Management";
            begin
                LoginMgt.DisplayUserInformation("User ID"); //LookupUserID("User ID");
            end;

            trigger OnValidate()
            var
                LoginMgt: Codeunit "User Management";
            begin
                //LoginMgt.ValidateUserID("User ID");
            end;
        }
        field(21; "User ID"; Code[20])
        {
            Caption = 'User ID';
            Description = 'na';
            NotBlank = true;
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "User Management";
            begin
                LoginMgt.DisplayUserInformation("User ID"); //LookupUserID("User ID");
            end;

            trigger OnValidate()
            var
                LoginMgt: Codeunit "User Management";
            begin
                //LoginMgt.ValidateUserID("User ID");
            end;
        }
        field(22; "Message Sent"; Boolean)
        {
            Caption = 'Message Sent';
        }
        field(23; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Description = '?';
        }
        field(24; "Message Displayed"; Boolean)
        {
            Caption = 'Message Displayed';
        }
        field(25; "Authorised Date"; Date)
        {
            Caption = 'Authorised Date';
        }
        field(26; "Authorised Time"; Time)
        {
            Caption = 'Authorised Time';
        }
        field(27; "Approval Remarks"; Text[50])
        {
        }
        field(50001; "Responsibility Centre"; Code[10])
        {
            TableRelation = "Responsibility Center 1".Code;
        }
        field(50002; "Responsibility Centre Name"; Text[50])
        {
        }
        field(50003; "Initiator Remarks"; Text[200])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No", "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status)
        {
        }
        key(Key3; "Sent Date", "Sent Time", Status)
        {
        }
        key(Key4; Status)
        {
        }
        key(Key5; "Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No", "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status, "Message Displayed")
        {
        }
        key(Key6; "Document Type", "Sub Document Type", Status)
        {
        }
    }

    fieldgroups
    {
    }

    var
        LoginMgt: Codeunit "User Management";
        Text001: Label 'Do you want to Accept the request %1 ?';
        Text002: Label 'Do you want to Reject this task %1 ?';
        Text13000: Label 'No Setup exists for this Amount.';
        Text13001: Label 'Do you want to send the document for Authorization?';
        Text13002: Label 'The Document Is Authorized, You Cannot Resend For Authorization';
        Text13003: Label 'You Cannot Resend For Authorization';
        Text13004: Label 'This Order Has been Rejected. Please Create A New Order.';
        Text13700: Label 'You have %1 new Task(s).';
        Text13701: Label 'Order Created';
        Text13702: Label 'for your approval';
        Text13703: Label 'You have received the undermentioned document for authorisation: ';
        Text13704: Label 'Document Type: Purchase  ';
        Text13705: Label 'Document No.: ';
        Text13706: Label 'Document Date:';
        Text13707: Label 'Vendor Name : ';
        Text13708: Label 'You are requested to verify and authorise the above document at the earliest. ';
        Text13709: Label 'Thank you, ';
        Text13710: Label 'From:  ';
        Text13711: Label 'Document Type: Sales ';
        Text13712: Label 'Customer Name : ';
        Text13713: Label 'for your approval (alternate user) ';
        Text13714: Label 'Kindly note that the primary person ';
        Text13715: Label ' responsible for authorising the document has not taken any action within the stipulated period ';
        Text13716: Label 'and since you are the alternate person to authorise this document, hence the same is being sent for your approval.';
        Text13717: Label 'Document Type: ';
        Text13718: Label 'Not Authorised ';
        Text13719: Label 'To: ';
        Text13720: Label 'The undermentioned document has been RETURNED WITHOUT BEING AUTHORISED';
        Text13721: Label 'since the authorised signatory';
        Text13722: Label 'has not seen the document in the time specified. ';
        Text13723: Label 'You are requested to kindly resend the same for authorisation or forward it to ';
        Text13724: Label 'another authorised signatory. ';
        Text13725: Label 'No Body Is Responding to the mails.';
        Text13726: Label 'Approved';
        Text13727: Label 'The undermentioned document has been  APPROVED ';
        Text13728: Label 'You are requested to kindly proceed with subsequent processes and ensure prompt closure of this document.';
        Text13729: Label 'Rejected';
        Text13730: Label 'The undermentioned document has been REJECTED. ';
        Text13731: Label 'You are requested to kindly refer to the comments on the document to know the reason  for this document not being approved and take necessary action.';
        PurchHeader: Record "Purchase Header";
        UserTasks: Record "User Tasks New";
        UserSetup: Record "User Setup";
        GLSetup: Record "General Ledger Setup";
        Company: Record "Company Information";
        PurchSetup: Record "Purchases & Payables Setup";
        WFPurchLine: Record "Purchase Line";
        PurchaseHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
        SalesSetup: Record "Sales & Receivables Setup";
        User: Record User;
        PurchaseOrder: Page "Purchase Order";
        SalesOrder: Page "Sales Order";
        PurchaseQuote: Page "Purchase Quote";
        SalesQuote: Page "Sales Quote";
        PurchaseInvoice: Page "Purchase Invoice";
        SalesInvoice: Page "Sales Invoice";
        Mail: Codeunit Mail;
        ReleasePurchaseDocument: Codeunit "Release Purchase Document";
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        File1: File;
        HideDialog: Boolean;
        ErrorNo: Integer;
        EntryNo: Integer;
        Link: Text[1000];
        FileName: Text[250];
        Context: Text[1000];
        I: Integer;
        WFAmount: Decimal;
        IsValid: Boolean;
        WaitTask: Boolean;
        OrderUserID: Code[20];
        "--Alle": Integer;
        DocTypeApprovalRec: Record "Document Type Approval";
        DocTypeSetupRec: Record "Document Type Setup";
        DocTypeInitiatorRec: Record "Document Type Initiator";
        loopflag: Integer;
        IndHeader: Record "Purchase Request Header";
        IndLine: Record "Purchase Request Line";
        IndentHeader: Record "Purchase Request Header";
        IndHdrForm: Page "Purchase Request List";
        PurchHeader1: Record "Purchase Header";
        PurchLine1: Record "Purchase Line";
        GRNHeader: Record "GRN Header";
        GRNLine: Record "GRN Line";
        UserSetupCC: Record "User Setup";
        DocInitiatorCC: Record "Document Type Initiator";
        Err1: Label 'Reject Option works only for Leave and OD';
        WFSaleLine: Record "Sales Line";
        SaleLine1: Record "Sales Line";
        RespCode: Code[10];
        RespName: Text[50];
        ResCentreCode: Record "Responsibility Center 1";
        TransHeader: Record "Transfer Header";
        TransLine: Record "Transfer Line";
        AwardNote: Record "Print Approval";
        AwardPurcahseLine: Record "Purchase Line";
        AwardPurcahseHeader: Record "Purchase Header";
        job: Record Job;
        IndentLine: Record "Purchase Request Line";
        ArchiveManagement: Codeunit MyCodeunit;
        RescpCenter: Record "Responsibility Center 1";


    procedure AuthorizationPO("pTransaction Type": Option Purchase,Sale; "pDocument Type": Option Indent,"Purchase Order","Purchase Order Amendment",GRN,Invoice,Leave,OD,"Sale Order","Debit Note","Transfer Order","Credit Memo","Award Note",Job; "pSub Document Type": Option " ","WO-ICB","WO-NICB","Regular PO","Repeat PO","Confirmatory PO","Direct PO","GRN for PO","GRN for JSPL","GRN for Packages","GRN for Fabricated Material for WO","JES for WO","GRN-Direct Purchase","Freight Advice","Order",Invoice; "pDocument No.": Code[20])
    begin
        RespName := '';
        RespCode := '';
        Company.GET;
        IF "pTransaction Type" = "pTransaction Type"::Purchase THEN BEGIN
            DocTypeSetupRec.GET("pDocument Type", "pSub Document Type");
            IF NOT DocTypeSetupRec."Approval Required" THEN
                EXIT;
            loopflag := 0;
            WFAmount := 0;
            IsValid := FALSE;
            IF "pDocument Type" = "pDocument Type"::Indent THEN BEGIN
                IndHeader.GET(IndHeader."Document Type"::Indent, "pDocument No.");
                RespCode := IndHeader."Responsibility Center";
                ResCentreCode.GET(IndHeader."Responsibility Center");
                RespName := ResCentreCode.Name;
                IndLine.SETRANGE("Document Type", IndHeader."Document Type"::Indent);
                IndLine.SETRANGE("Document No.", "pDocument No.");
                IF IndLine.FIND('-') THEN
                    REPEAT
                        WFAmount := WFAmount + IndLine.Amount;
                    UNTIL IndLine.NEXT = 0;
                IF IndHeader.Approved THEN
                    ERROR(Text13002);
                IF NOT IndHeader."Sent for Approval" THEN
                    ERROR('This document has not been sent for approval.');
            END;
            IF "pDocument Type" = "pDocument Type"::"Purchase Order" THEN BEGIN
                PurchHeader.GET(PurchHeader."Document Type"::Order, "pDocument No.");
                RespCode := PurchHeader."Responsibility Center";
                ResCentreCode.GET(PurchHeader."Responsibility Center");
                RespName := ResCentreCode.Name;
                WFPurchLine.SETRANGE("Document Type", PurchHeader."Document Type"::Order);
                WFPurchLine.SETRANGE("Document No.", "pDocument No.");
                IF WFPurchLine.FIND('-') THEN
                    REPEAT
                        // WFAmount := WFAmount + WFPurchLine."Amount To Vendor" + WFPurchLine."TDS Amount" + WFPurchLine."Work Tax Amount";
                        WFAmount := WFAmount + WFPurchLine.Amount; //+ WFPurchLine. + WFPurchLine."Work Tax Amount";
                    UNTIL WFPurchLine.NEXT = 0;
                IF PurchHeader.Approved THEN
                    ERROR(Text13002);
                IF NOT PurchHeader."Sent for Approval" THEN
                    ERROR('This document has not been sent for approval.');
            END;
            //Purchase Order Amendment
            IF "pDocument Type" = "pDocument Type"::"Purchase Order Amendment" THEN BEGIN
                PurchHeader.GET(PurchHeader."Document Type"::Order, "pDocument No.");
                RespCode := PurchHeader."Responsibility Center";
                ResCentreCode.GET(PurchHeader."Responsibility Center");
                RespName := ResCentreCode.Name;
                WFPurchLine.SETRANGE("Document Type", PurchHeader."Document Type"::Order);
                WFPurchLine.SETRANGE("Document No.", "pDocument No.");
                IF WFPurchLine.FIND('-') THEN
                    REPEAT
                        //WFAmount := WFAmount + WFPurchLine."Amount To Vendor" + WFPurchLine."TDS Amount" + WFPurchLine."Work Tax Amount";
                        WFAmount := WFAmount + WFPurchLine.Amount; //+ WFPurchLine."TDS Amount" + WFPurchLine."Work Tax Amount";
                    UNTIL WFPurchLine.NEXT = 0;
                IF PurchHeader."Amendment Approved" THEN
                    ERROR(Text13002);
            END;
            //Invoice
            IF "pDocument Type" = "pDocument Type"::Invoice THEN BEGIN
                PurchHeader.GET(PurchHeader."Document Type"::Invoice, "pDocument No.");
                RespCode := PurchHeader."Responsibility Center";
                ResCentreCode.GET(PurchHeader."Responsibility Center");
                RespName := ResCentreCode.Name;
                PurchLine1.SETRANGE("Document Type", PurchHeader."Document Type"::Invoice);
                PurchLine1.SETRANGE("Document No.", "pDocument No.");
                IF PurchLine1.FIND('-') THEN
                    REPEAT
                        WFAmount := WFAmount + PurchLine1.Amount;
                    UNTIL PurchLine1.NEXT = 0;

                IF NOT PurchHeader."Sent for Approval" THEN
                    ERROR('This document has not been sent for approval.');

                IF PurchHeader.Approved THEN BEGIN
                    //ALLECK 040613 START
                    PurchHeader."Sent for Approval" := FALSE;
                    PurchHeader.Approved := FALSE;
                    PurchHeader."Sent for Approval Time" := 0T;
                    PurchHeader."Sent for Approval Date" := 0D;
                    PurchHeader."Approved Date" := 0D;
                    PurchHeader."Approved Time" := 0T;
                    PurchHeader."Approved Return" := TRUE;
                    PurchHeader.MODIFY;
                    //ALLECK 040613 END
                END;
                //  ERROR (Text13002);         //ALLECK 040613
            END;

            // Debit note
            IF "pDocument Type" = "pDocument Type"::"Debit Note" THEN BEGIN
                PurchHeader.GET(PurchHeader."Document Type"::"Credit Memo", "pDocument No.");
                RespCode := PurchHeader."Responsibility Center";
                ResCentreCode.GET(PurchHeader."Responsibility Center");
                RespName := ResCentreCode.Name;
                PurchLine1.SETRANGE("Document Type", PurchHeader."Document Type"::"Credit Memo");
                PurchLine1.SETRANGE("Document No.", "pDocument No.");
                IF PurchLine1.FIND('-') THEN
                    REPEAT
                        WFAmount := WFAmount + PurchLine1.Amount;
                    UNTIL PurchLine1.NEXT = 0;
                IF PurchHeader.Approved THEN
                    ERROR(Text13002);
                IF NOT PurchHeader."Sent for Approval" THEN
                    ERROR('This document has not been sent for approval.');
            END;
            //GRN
            IF "pDocument Type" = "pDocument Type"::GRN THEN BEGIN
                GRNHeader.GET(GRNHeader."Document Type"::GRN, "pDocument No.");
                RespCode := GRNHeader."Responsibility Center";
                ResCentreCode.GET(GRNHeader."Responsibility Center");
                RespName := ResCentreCode.Name;
                GRNLine.SETRANGE("Document Type", GRNHeader."Document Type"::GRN);
                GRNLine.SETRANGE("GRN No.", "pDocument No.");
                IF GRNHeader.Approved THEN
                    ERROR(Text13002);
                IF NOT GRNHeader."Sent for Approval" THEN
                    ERROR('This document has not been sent for approval.');
            END;
            //JOB
            IF "pDocument Type" = "pDocument Type"::Job THEN BEGIN
                job.GET("pDocument No.");
                RespCode := job."Responsibility Center";
                ResCentreCode.GET(job."Responsibility Center");
                //RespName:=JOB.Name;
                IF job.Approved THEN
                    ERROR(Text13002);
                IF NOT job."Sent for Approval" THEN
                    ERROR('This document has not been sent for approval.');
            END;

            DocTypeApprovalRec.RESET;
            DocTypeApprovalRec.SETRANGE("Document Type", "pDocument Type");
            DocTypeApprovalRec.SETRANGE("Sub Document Type", "pSub Document Type");
            DocTypeApprovalRec.SETRANGE("Document No", "pDocument No.");
            IF "pDocument Type" = "pDocument Type"::"Purchase Order" THEN
                DocTypeApprovalRec.SETRANGE(Initiator, PurchHeader.Initiator);
            IF "pDocument Type" = "pDocument Type"::"Purchase Order Amendment" THEN
                DocTypeApprovalRec.SETRANGE(Initiator, PurchHeader."Amendment Initiator");
            IF "pDocument Type" = "pDocument Type"::Indent THEN
                DocTypeApprovalRec.SETRANGE(Initiator, IndHeader.Indentor);
            IF "pDocument Type" = "pDocument Type"::Invoice THEN
                DocTypeApprovalRec.SETRANGE(Initiator, PurchHeader.Initiator);
            IF "pDocument Type" = "pDocument Type"::GRN THEN
                DocTypeApprovalRec.SETRANGE(Initiator, GRNHeader.Initiator);
            DocTypeApprovalRec.SETRANGE(DocTypeApprovalRec.Status, DocTypeApprovalRec.Status::" ");
            IF DocTypeApprovalRec.FIND('-') THEN BEGIN
                REPEAT
                    DocTypeApprovalRec."Document Responsibility Centre" := RespCode;
                    DocTypeApprovalRec."Document Resposibility Name" := RespName;
                    //write code to check for amount based approval
                    IF (DocTypeApprovalRec."Min Amount Limit" = 0) AND
                      (DocTypeApprovalRec."Max Amount Limit" = 0)
                    THEN
                        loopflag := 1;
                    IF NOT ((DocTypeApprovalRec."Min Amount Limit" = 0) AND
                      (DocTypeApprovalRec."Max Amount Limit" = 0))
                    THEN BEGIN
                        IF ((WFAmount >= DocTypeApprovalRec."Min Amount Limit") AND
                          (WFAmount <= DocTypeApprovalRec."Max Amount Limit"))  //OR
                                                                                // (WFAmount >DocTypeApprovalRec."Max Amount Limit")
                        THEN
                            loopflag := 1
                        ELSE BEGIN
                            DocTypeApprovalRec.Status := DocTypeApprovalRec.Status::"Not Required";
                            DocTypeApprovalRec.MODIFY;
                        END;
                    END;
                    IF loopflag = 1 THEN BEGIN
                        UserSetup.GET(DocTypeApprovalRec."Approvar ID");
                        //        IF Company."Mail Required" THEN BEGIN
                        //          IF  "pDocument Type"="pDocument Type"::Indent THEN BEGIN
                        //            IndHdrForm.SETTABLEVIEW(IndHeader);
                        //            Context := IndHdrForm.URL;
                        //            FileName := IndHdrForm.CAPTION + '.URL';
                        //          END;
                        //          IF  "pDocument Type"="pDocument Type"::Invoice THEN BEGIN
                        //            PurchaseHeader.GET(PurchaseHeader."Document Type"::Invoice,"pDocument No.");
                        //            PurchaseInvoice.SETTABLEVIEW(PurchaseHeader);
                        //            Context := PurchaseInvoice.URL;
                        //            FileName := PurchaseInvoice.CAPTION + '.URL';
                        //          END;
                        //          IF  "pDocument Type"="pDocument Type"::"Purchase Order" THEN BEGIN
                        //            PurchaseHeader.SETRANGE("Document Type",PurchHeader."Document Type");
                        //            PurchaseHeader.SETRANGE("No.",PurchHeader."No.");
                        //            IF PurchaseHeader.FIND('-') THEN BEGIN
                        //              IF PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order THEN BEGIN
                        //                PurchaseOrder.SETTABLEVIEW(PurchaseHeader);
                        //                Context := PurchaseOrder.URL;
                        //                FileName := PurchaseOrder.CAPTION + '.URL';
                        //              END;
                        //            END;
                        //          END;
                        //          IF  "pDocument Type"="pDocument Type"::"Purchase Order Amendment" THEN BEGIN
                        //            PurchaseHeader.SETRANGE("Document Type",PurchHeader."Document Type");
                        //            PurchaseHeader.SETRANGE("No.",PurchHeader."No.");
                        //            IF PurchaseHeader.FIND('-') THEN BEGIN
                        //              IF PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order THEN BEGIN
                        //                PurchaseOrder.SETTABLEVIEW(PurchaseHeader);
                        //                Context := PurchaseOrder.URL;
                        //                FileName := PurchaseOrder.CAPTION + '.URL';
                        //              END;
                        //            END;
                        //          END;
                        //          REPEAT
                        //            I := STRPOS(Context,' ');
                        //            IF I <> 0 THEN BEGIN
                        //              Context := DELSTR(Context,I,1);
                        //              Context := INSSTR(Context,'%20',I);
                        //            END;
                        //          UNTIL (I=0);
                        //          IF ISCLEAR(MAPIHandler) THEN
                        //            CREATE(MAPIHandler);
                        //          ErrorNo := 0;
                        //          User.GET(UserSetup."User ID");
                        //          MAPIHandler.ToName := UserSetup."E-Mail";
                        //          MAPIHandler.CCName := '';
                        //          MAPIHandler.Subject :=  "pDocument No." + ' ' + Text13702;
                        //          MAPIHandler.AddBodyText(Text13719 + User.Name);
                        //          MAPIHandler.AddBodyText('');
                        //          MAPIHandler.AddBodyText(Text13703);
                        //          MAPIHandler.AddBodyText('');
                        //          IF "pDocument Type"="pDocument Type"::Indent THEN  BEGIN
                        //            MAPIHandler.AddBodyText(Text13704 + FORMAT(IndHeader."Document Type"));
                        //            MAPIHandler.AddBodyText(Text13705 + ' ' +  IndHeader."Document No.");
                        //            MAPIHandler.AddBodyText('Indent Date:' + ' ' + FORMAT(IndHeader."Indent Date"));
                        //            MAPIHandler.AddBodyText('');
                        //          END;
                        //          IF "pDocument Type"="pDocument Type"::"Purchase Order" THEN  BEGIN
                        //            MAPIHandler.AddBodyText(Text13704 + FORMAT(PurchaseHeader."Document Type"));
                        //            MAPIHandler.AddBodyText(Text13705 + ' ' +  PurchaseHeader."No.");
                        //            MAPIHandler.AddBodyText(Text13706 + ' ' + FORMAT(PurchaseHeader."Document Date"));
                        //            MAPIHandler.AddBodyText('');
                        //            MAPIHandler.AddBodyText(Text13707 + PurchaseHeader."Buy-from Vendor Name");
                        //          END;
                        //          IF "pDocument Type"="pDocument Type"::"Purchase Order Amendment" THEN  BEGIN
                        //            MAPIHandler.AddBodyText(Text13704 + FORMAT(PurchaseHeader."Document Type"));
                        //            MAPIHandler.AddBodyText(Text13705 + ' ' +  PurchaseHeader."No.");
                        //            MAPIHandler.AddBodyText(Text13706 + ' ' + FORMAT(PurchaseHeader."Document Date"));
                        //            MAPIHandler.AddBodyText('');
                        //            MAPIHandler.AddBodyText(Text13707 + PurchaseHeader."Buy-from Vendor Name");
                        //          END;
                        //          IF "pDocument Type"="pDocument Type"::Invoice THEN  BEGIN
                        //            MAPIHandler.AddBodyText(Text13704 + FORMAT(PurchaseHeader."Document Type"));
                        //            MAPIHandler.AddBodyText(Text13705 + ' ' +  PurchaseHeader."No.");
                        //            MAPIHandler.AddBodyText(Text13706 + ' ' + FORMAT(PurchaseHeader."Document Date"));
                        //            MAPIHandler.AddBodyText('');
                        //            MAPIHandler.AddBodyText(Text13707 + PurchaseHeader."Buy-from Vendor Name");
                        //          END;
                        //          IF "pDocument Type"="pDocument Type"::GRN THEN  BEGIN
                        //            MAPIHandler.AddBodyText(Text13704 + FORMAT(GRNHeader."Document Type"));
                        //            MAPIHandler.AddBodyText(Text13705 + ' ' +  GRNHeader."GRN No.");
                        //            MAPIHandler.AddBodyText(Text13706 + ' ' + FORMAT(GRNHeader."Posting Date"));
                        //            MAPIHandler.AddBodyText('');
                        //          END;
                        //          MAPIHandler.AddBodyText('');
                        //          MAPIHandler.AddBodyText(Text13708);
                        //          MAPIHandler.AddBodyText(' ');
                        //          MAPIHandler.AddBodyText(Text13709);
                        //          MAPIHandler.AddBodyText(' ');
                        //          User.GET(USERID);
                        //          MAPIHandler.AddBodyText(Text13710 + User.Name);
                        //          //MAPIHandler.AttachFileName := FileName;
                        //          MAPIHandler.OpenDialog := FALSE;//bkbk
                        //          MAPIHandler.Send;
                        //          ErrorNo := MAPIHandler.ErrorStatus;
                        //        END;
                        UserTasks.LOCKTABLE;
                        UserTasks.SETCURRENTKEY("Entry No.");
                        IF UserTasks.FIND('+') THEN
                            EntryNo := UserTasks."Entry No." + 1
                        ELSE
                            EntryNo := 1;
                        UserTasks.INIT;
                        UserTasks."Entry No." := EntryNo;
                        UserTasks."Transaction Type" := "pTransaction Type";
                        UserTasks."Document Type" := "pDocument Type";
                        UserTasks."Sub Document Type" := "pSub Document Type";
                        UserTasks."Document No" := "pDocument No.";
                        UserTasks.Initiator := DocTypeApprovalRec.Initiator;
                        UserTasks."Document Approval Line No" := DocTypeApprovalRec."Line No";
                        UserTasks."Approvar ID" := DocTypeApprovalRec."Approvar ID";
                        UserTasks."Alternate Approvar ID" := DocTypeApprovalRec."Alternate Approvar ID";
                        UserTasks."Min Amount Limit" := DocTypeApprovalRec."Min Amount Limit";
                        UserTasks."Max Amount Limit" := DocTypeApprovalRec."Max Amount Limit";
                        UserTasks."Responsibility Centre" := DocTypeApprovalRec."Document Responsibility Centre";
                        UserTasks."Responsibility Centre Name" := DocTypeApprovalRec."Document Resposibility Name";
                        UserTasks."Received From" := USERID;
                        UserTasks."Sent Date" := TODAY;
                        UserTasks."Sent Time" := TIME;
                        UserTasks.Activity := UserTasks.Activity;
                        UserTasks."Message Sent" := TRUE;
                        UserTasks.Description := 'Approve ' + FORMAT("pDocument Type") + ' ' + FORMAT("pSub Document Type") +
                          ' ' + FORMAT("pDocument No.");
                        UserTasks.Status := UserTasks.Status::" ";
                        UserTasks.INSERT;
                    END;//loopflag
                UNTIL (DocTypeApprovalRec.NEXT = 0) OR (loopflag = 1);
            END;
            IF loopflag = 0 THEN BEGIN
                IF "pDocument Type" = "pDocument Type"::Indent THEN BEGIN
                    IndHeader.VALIDATE(Approved, TRUE);
                    IndHeader."Approved Date" := TODAY;
                    IndHeader."Approved Time" := TIME;
                    IndHeader.MODIFY;
                    UserSetup.GET(IndHeader.Indentor);
                END;
                IF "pDocument Type" = "pDocument Type"::"Purchase Order" THEN BEGIN
                    PurchHeader.VALIDATE(Approved, TRUE);
                    PurchHeader."Approved Date" := TODAY;
                    PurchHeader."Approved Time" := TIME;
                    PurchHeader.MODIFY;
                    UserSetup.GET(PurchHeader.Initiator);
                END;
                IF "pDocument Type" = "pDocument Type"::"Purchase Order Amendment" THEN BEGIN
                    PurchHeader.VALIDATE("Amendment Approved", TRUE);
                    PurchHeader."Amendment Approved Date" := TODAY;
                    PurchHeader."Amendment Approved Time" := TIME;
                    PurchHeader.MODIFY;
                    UserSetup.GET(PurchHeader."Amendment Initiator");
                END;
                IF "pDocument Type" = "pDocument Type"::Invoice THEN BEGIN
                    PurchHeader.VALIDATE(Approved, TRUE);
                    PurchHeader."Approved Date" := TODAY;
                    PurchHeader."Approved Time" := TIME;
                    PurchHeader.MODIFY;
                    UserSetup.GET(PurchHeader.Initiator);
                END;
                IF "pDocument Type" = "pDocument Type"::GRN THEN BEGIN
                    GRNHeader.VALIDATE(Approved, TRUE);
                    GRNHeader."Approved Date" := TODAY;
                    GRNHeader."Approved Time" := TIME;
                    GRNHeader.MODIFY;
                    UserSetup.GET(GRNHeader.Initiator);
                END;

                IF "pDocument Type" = "pDocument Type"::Job THEN BEGIN
                    job.VALIDATE(Approved, TRUE);
                    job."Approved Date" := TODAY;
                    job."Approved Time" := TIME;
                    job.MODIFY;
                    UserSetup.GET(job.Initiator);
                END;

                //    IF Company."Mail Required" THEN BEGIN
                //      IF ISCLEAR(MAPIHandler) THEN
                //        CREATE(MAPIHandler);

                //      ErrorNo := 0;
                //      User.GET(UserSetup."User ID");
                //      MAPIHandler.ToName := UserSetup."E-Mail";
                //      MAPIHandler.CCName := '';
                //      DocInitiatorCC.GET("pDocument Type","pSub Document Type",UserSetup."User ID");
                //      IF DocInitiatorCC."CC Mail - User Code"<>'' THEN BEGIN
                //        UserSetupCC.GET(DocInitiatorCC."CC Mail - User Code");
                //        MAPIHandler.CCName := UserSetupCC."E-Mail";
                //      END;

                //      MAPIHandler.Subject :=  "pDocument No." + ' ' + Text13702;
                //      MAPIHandler.AddBodyText(Text13719 + User.Name);
                //      MAPIHandler.AddBodyText('');
                //      MAPIHandler.AddBodyText(Text13703);
                //      MAPIHandler.AddBodyText('');
                //      IF "pDocument Type"="pDocument Type"::Indent THEN  BEGIN
                //        MAPIHandler.AddBodyText(Text13704 + FORMAT(IndHeader."Document Type"));
                //        MAPIHandler.AddBodyText(Text13705 + ' ' +  IndHeader."Document No.");
                ///        MAPIHandler.AddBodyText('Indent Date:' + ' ' + FORMAT(IndHeader."Indent Date"));
                ////        MAPIHandler.AddBodyText('');
                ////      END;
                //      IF "pDocument Type"="pDocument Type"::"Purchase Order" THEN  BEGIN
                //        MAPIHandler.AddBodyText(Text13704 + FORMAT(PurchaseHeader."Document Type"));
                //        MAPIHandler.AddBodyText(Text13705 + ' ' +  PurchaseHeader."No.");
                //        MAPIHandler.AddBodyText(Text13706 + ' ' + FORMAT(PurchaseHeader."Document Date"));
                //        MAPIHandler.AddBodyText('');
                //        MAPIHandler.AddBodyText(Text13707 + PurchaseHeader."Buy-from Vendor Name");
                //      END;
                //      IF "pDocument Type"="pDocument Type"::"Purchase Order Amendment" THEN  BEGIN
                //        MAPIHandler.AddBodyText(Text13704 + FORMAT(PurchaseHeader."Document Type"));
                //        MAPIHandler.AddBodyText(Text13705 + ' ' +  PurchaseHeader."No.");
                //        MAPIHandler.AddBodyText(Text13706 + ' ' + FORMAT(PurchaseHeader."Document Date"));
                //        MAPIHandler.AddBodyText('');
                //        MAPIHandler.AddBodyText(Text13707 + PurchaseHeader."Buy-from Vendor Name");
                //      END;
                //      IF "pDocument Type"="pDocument Type"::Invoice THEN  BEGIN
                //        MAPIHandler.AddBodyText(Text13704 + FORMAT(PurchaseHeader."Document Type"));
                //        MAPIHandler.AddBodyText(Text13705 + ' ' +  PurchaseHeader."No.");
                //        MAPIHandler.AddBodyText(Text13706 + ' ' + FORMAT(PurchaseHeader."Document Date"));
                //        MAPIHandler.AddBodyText('');
                //        MAPIHandler.AddBodyText(Text13707 + PurchaseHeader."Buy-from Vendor Name");
                //      END;
                //      IF "pDocument Type"="pDocument Type"::GRN THEN  BEGIN
                //        MAPIHandler.AddBodyText(Text13704 + FORMAT(GRNHeader."Document Type"));
                //        MAPIHandler.AddBodyText(Text13705 + ' ' +  GRNHeader."GRN No.");
                //        MAPIHandler.AddBodyText(Text13706 + ' ' + FORMAT(GRNHeader."Posting Date"));
                //        MAPIHandler.AddBodyText('');
                //      END;
                //      MAPIHandler.AddBodyText('');
                //      MAPIHandler.AddBodyText('The Document has been approved.');
                //      MAPIHandler.AddBodyText(' ');
                //      MAPIHandler.AddBodyText(Text13709);
                //      MAPIHandler.AddBodyText(' ');
                //      User.GET(USERID);
                //      MAPIHandler.AddBodyText(Text13710 + User.Name);
                //      MAPIHandler.OpenDialog := FALSE;
                //      MAPIHandler.Send;
                //      ErrorNo := MAPIHandler.ErrorStatus;
                //    END;
            END;
        END;
    end;


    procedure ApprovePO(var UserTask: Record "User Tasks New")
    begin
        IF NOT ((UserTask."Approvar ID" = UPPERCASE(USERID)) OR
  ((UserTask."Alternate Approvar ID" = UPPERCASE(USERID)) AND (UserTask."Alternate Approvar ID" <> '')))
THEN
            ERROR('Un-Authorised User');
        IF UserTask.Status <> UserTask.Status::" " THEN
            ERROR('Cannot approve such line');
        Company.GET;
        IF CONFIRM(Text001, TRUE, UserTask."Document No") THEN BEGIN
            //for Purchase Transaction
            DocTypeApprovalRec.RESET;
            DocTypeApprovalRec.SETRANGE("Document Type", UserTask."Document Type");
            DocTypeApprovalRec.SETRANGE("Sub Document Type", UserTask."Sub Document Type");
            DocTypeApprovalRec.SETRANGE("Document No", UserTask."Document No");
            DocTypeApprovalRec.SETRANGE(Initiator, UserTask.Initiator);
            DocTypeApprovalRec.SETRANGE("Line No", UserTask."Document Approval Line No");
            DocTypeApprovalRec.SETRANGE("Approvar ID", UserTask."Approvar ID");
            DocTypeApprovalRec.SETRANGE(DocTypeApprovalRec.Status, DocTypeApprovalRec.Status::" ");
            IF NOT DocTypeApprovalRec.FIND('-') THEN
                ERROR('This request cannot be processed');
            DocTypeApprovalRec."Authorized Date" := TODAY;
            DocTypeApprovalRec."Authorized Time" := TIME;
            DocTypeApprovalRec."Authorized ID" := UPPERCASE(USERID);
            DocTypeApprovalRec.Status := DocTypeApprovalRec.Status::Approved;
            DocTypeApprovalRec.MODIFY;
            UserTask."Authorised Date" := TODAY;
            UserTask."Authorised Time" := TIME;
            UserTask.Status := UserTask.Status::Approved;
            UserTask.MODIFY;
            //Call PO Authorisation function
            DocTypeApprovalRec.RESET;
            DocTypeApprovalRec.SETRANGE("Document Type", UserTask."Document Type");
            DocTypeApprovalRec.SETRANGE("Sub Document Type", UserTask."Sub Document Type");
            DocTypeApprovalRec.SETRANGE("Document No", UserTask."Document No");
            DocTypeApprovalRec.SETRANGE(Initiator, UserTask.Initiator);
            DocTypeApprovalRec.SETRANGE(DocTypeApprovalRec.Status, DocTypeApprovalRec.Status::" ");
            IF DocTypeApprovalRec.FIND('-') THEN
                UserTask.AuthorizationPO(UserTask."Transaction Type", UserTask."Document Type", UserTask."Sub Document Type", UserTask."Document No")
            ELSE BEGIN
                //Approve Indent
                IF UserTask."Document Type" = UserTask."Document Type"::Indent THEN BEGIN
                    IndHeader.GET(IndHeader."Document Type"::Indent, UserTask."Document No");
                    IndHeader.VALIDATE(Approved, TRUE);
                    IndHeader."Approved Date" := TODAY;
                    IndHeader."Approved Time" := TIME;
                    IndHeader.MODIFY;
                    UserSetup.GET(IndHeader.Indentor);
                END;
                // ALLEAA
                /*IF "Document Type"="Document Type"::"Award Note" THEN BEGIN
                  AwardNote.GET("Document No");
                  AwardNote.VALIDATE(Approved,TRUE);
                  AwardNote."Approved Date":=TODAY;
                  AwardNote."Approved Time":=TIME;
                  AwardNote.MODIFY;
                  UserSetup.GET(AwardNote.Initiator);
                END;
                // ALLEAA
                 */
                //Approve PO
                IF UserTask."Document Type" = UserTask."Document Type"::"Purchase Order" THEN BEGIN
                    PurchHeader.GET(PurchHeader."Document Type"::Order, UserTask."Document No");
                    PurchHeader.VALIDATE(Approved, TRUE);
                    PurchHeader."Approved Date" := TODAY;
                    PurchHeader."Approved Time" := TIME;
                    PurchHeader.MODIFY;
                    UserSetup.GET(PurchHeader.Initiator);
                END;
                //Approve AmPO
                IF UserTask."Document Type" = UserTask."Document Type"::"Purchase Order Amendment" THEN BEGIN
                    PurchHeader.GET(PurchHeader."Document Type"::Order, UserTask."Document No");
                    PurchHeader.VALIDATE("Amendment Approved", TRUE);
                    PurchHeader."Amendment Approved Date" := TODAY;
                    PurchHeader."Amendment Approved Time" := TIME;
                    PurchHeader.MODIFY;
                    UserSetup.GET(PurchHeader."Amendment Initiator");
                END;
                //Approve Invoice
                IF UserTask."Document Type" = UserTask."Document Type"::Invoice THEN BEGIN
                    PurchHeader.GET(PurchHeader."Document Type"::Invoice, UserTask."Document No");
                    PurchHeader.VALIDATE(Approved, TRUE);
                    PurchHeader."Approved Date" := TODAY;
                    PurchHeader."Approved Time" := TIME;
                    PurchHeader.MODIFY;
                    UserSetup.GET(PurchHeader.Initiator);
                END;
                //Approve Debit Note
                IF UserTask."Document Type" = UserTask."Document Type"::"Debit Note" THEN BEGIN
                    PurchHeader.GET(PurchHeader."Document Type"::"Credit Memo", UserTask."Document No");
                    PurchHeader.VALIDATE(Approved, TRUE);
                    PurchHeader."Approved Date" := TODAY;
                    PurchHeader."Approved Time" := TIME;
                    PurchHeader.MODIFY;
                    UserSetup.GET(PurchHeader.Initiator);
                END;
                //Approve GRN
                IF UserTask."Document Type" = UserTask."Document Type"::GRN THEN BEGIN
                    GRNHeader.GET(GRNHeader."Document Type"::GRN, UserTask."Document No");
                    GRNHeader.VALIDATE(Approved, TRUE);
                    GRNHeader."Approved Date" := TODAY;
                    GRNHeader."Approved Time" := TIME;
                    GRNHeader.MODIFY;
                    UserSetup.GET(GRNHeader.Initiator);
                END;
                //Send mail to initiator
                UserSetup.GET(DocTypeApprovalRec.Initiator);
                //        IF Company."Mail Required" THEN BEGIN
                //          IF  "Document Type"="Document Type"::Indent THEN  BEGIN
                //            IndHdrForm.SETTABLEVIEW(IndHeader);
                //            Context := IndHdrForm.URL;
                //            FileName := IndHdrForm.CAPTION + '.URL';
                //          END;
                //          IF  "Document Type"="Document Type"::Invoice THEN BEGIN
                //            PurchaseInvoice.SETTABLEVIEW(PurchaseHeader);
                //            Context := PurchaseInvoice.URL;
                //            FileName := PurchaseInvoice.CAPTION + '.URL';
                //          END;
                //          IF  "Document Type"="Document Type"::"Purchase Order" THEN
                //          BEGIN
                //            PurchaseHeader.SETRANGE("Document Type",PurchHeader."Document Type");
                //            PurchaseHeader.SETRANGE("No.",PurchHeader."No.");
                //            IF PurchaseHeader.FIND('-') THEN BEGIN
                //              IF PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order THEN BEGIN
                //                PurchaseOrder.SETTABLEVIEW(PurchaseHeader);
                //                Context := PurchaseOrder.URL;
                //                FileName := PurchaseOrder.CAPTION + '.URL';
                //              END;
                //            END;
                //          END;
                //          IF  "Document Type"="Document Type"::"Purchase Order Amendment" THEN
                //          BEGIN
                //            PurchaseHeader.SETRANGE("Document Type",PurchHeader."Document Type");
                //            PurchaseHeader.SETRANGE("No.",PurchHeader."No.");
                //            IF PurchaseHeader.FIND('-') THEN BEGIN
                //              IF PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order THEN BEGIN
                //                PurchaseOrder.SETTABLEVIEW(PurchaseHeader);
                //                Context := PurchaseOrder.URL;
                //                FileName := PurchaseOrder.CAPTION + '.URL';
                //              END;
                //            END;
                //          END;
                //          REPEAT
                //            I := STRPOS(Context,' ');
                //            IF I <> 0 THEN BEGIN
                //              Context := DELSTR(Context,I,1);
                //              Context := INSSTR(Context,'%20',I);
                //            END;
                //          UNTIL (I=0);
                //          IF ISCLEAR(MAPIHandler) THEN
                //            CREATE(MAPIHandler);
                //          ErrorNo := 0;
                //          User.GET(UserSetup."User ID");
                //          MAPIHandler.ToName := UserSetup."E-Mail";
                //          MAPIHandler.CCName := '';
                //          DocInitiatorCC.GET(UserTask."Document Type",UserTask."Sub Document Type",UserSetup."User ID");
                //          IF DocInitiatorCC."CC Mail - User Code"<>'' THEN BEGIN
                //            UserSetupCC.GET(DocInitiatorCC."CC Mail - User Code");
                //            MAPIHandler.CCName := UserSetupCC."E-Mail";
                //          END;
                //          IF "Document Type"="Document Type"::Indent THEN  BEGIN
                //            MAPIHandler.Subject :=  IndHeader."Document No." + ' ' + Text13702;
                //            MAPIHandler.AddBodyText(Text13719 + User.Name);
                //            MAPIHandler.AddBodyText('');
                //            MAPIHandler.AddBodyText('The undermentioned document has been approved.');
                //            MAPIHandler.AddBodyText('');
                //        MAPIHandler.AddBodyText(Text13704 + FORMAT(IndHeader."Document Type"));
                //            MAPIHandler.AddBodyText(Text13705 + ' ' +  IndHeader."Document No.");
                //          MAPIHandler.AddBodyText('Indent Date:' + ' ' + FORMAT(IndHeader."Indent Date"));
                //            MAPIHandler.AddBodyText('');
                //          END;
                //          IF "Document Type"="Document Type"::"Purchase Order" THEN  BEGIN
                //            MAPIHandler.Subject :=  PurchHeader."No." + ' ' + Text13702;
                //            MAPIHandler.AddBodyText(Text13719 + User.Name);
                //            MAPIHandler.AddBodyText('');
                //            MAPIHandler.AddBodyText('The undermentioned document has been approved.');
                //            MAPIHandler.AddBodyText('');
                //            MAPIHandler.AddBodyText(Text13704 + FORMAT(PurchHeader."Document Type"));
                //            MAPIHandler.AddBodyText(Text13705 + ' ' +  PurchHeader."No.");
                //            MAPIHandler.AddBodyText(Text13706 + ' ' + FORMAT(PurchHeader."Document Date"));
                //            MAPIHandler.AddBodyText('');
                //            MAPIHandler.AddBodyText(Text13707 + PurchHeader."Buy-from Vendor Name");
                //          END;
                //
                //          IF "Document Type"="Document Type"::"Purchase Order Amendment" THEN  BEGIN
                //            MAPIHandler.Subject :=  PurchHeader."No." + ' ' + Text13702;
                //            MAPIHandler.AddBodyText(Text13719 + User.Name);
                //            MAPIHandler.AddBodyText('');
                //            MAPIHandler.AddBodyText('The undermentioned document has been approved.');
                //            MAPIHandler.AddBodyText('');
                //            MAPIHandler.AddBodyText(Text13704 + FORMAT(PurchHeader."Document Type"));
                //            MAPIHandler.AddBodyText(Text13705 + ' ' +  PurchHeader."No.");
                //            MAPIHandler.AddBodyText(Text13706 + ' ' + FORMAT(PurchHeader."Document Date"));
                //            MAPIHandler.AddBodyText('');
                //            MAPIHandler.AddBodyText(Text13707 + PurchHeader."Buy-from Vendor Name");
                //          END;
                //          IF "Document Type"="Document Type"::Invoice THEN  BEGIN
                //            MAPIHandler.Subject :=  PurchHeader."No." + ' ' + Text13702;
                //            MAPIHandler.AddBodyText(Text13719 + User.Name);
                //            MAPIHandler.AddBodyText('');
                //            MAPIHandler.AddBodyText('The undermentioned document has been approved.');
                //            MAPIHandler.AddBodyText('');
                //            MAPIHandler.AddBodyText(Text13704 + FORMAT(PurchHeader."Document Type"));
                //            MAPIHandler.AddBodyText(Text13705 + ' ' +  PurchHeader."No.");
                //            MAPIHandler.AddBodyText(Text13706 + ' ' + FORMAT(PurchHeader."Document Date"));
                //            MAPIHandler.AddBodyText('');
                //            MAPIHandler.AddBodyText(Text13707 + PurchHeader."Buy-from Vendor Name");
                //          END;
                //          IF "Document Type"="Document Type"::GRN THEN  BEGIN
                //            MAPIHandler.Subject :=  GRNHeader."GRN No." + ' ' + Text13702;
                //            MAPIHandler.AddBodyText(Text13719 + User.Name);
                //            MAPIHandler.AddBodyText('');
                //            MAPIHandler.AddBodyText('The undermentioned document has been approved.');
                //            MAPIHandler.AddBodyText('');
                //            MAPIHandler.AddBodyText(Text13704 + FORMAT(GRNHeader."Document Type"));
                //            MAPIHandler.AddBodyText(Text13705 + ' ' +  GRNHeader."GRN No.");
                //            MAPIHandler.AddBodyText(Text13706 + ' ' + FORMAT(GRNHeader."Posting Date"));
                //            MAPIHandler.AddBodyText('');
                //        END;
                //          MAPIHandler.AddBodyText('');
                //          User.GET(USERID);
                //          MAPIHandler.AddBodyText(Text13710 + User.Name);
                //          MAPIHandler.OpenDialog := FALSE;
                //          MAPIHandler.Send;
                //          ErrorNo := MAPIHandler.ErrorStatus;
                //        END;
            END;

        END;

    end;


    procedure ReleaseDocument()
    var
        ReleasePurchaseDocument: Codeunit "Release Purchase Document";
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        //ReleaseTransDocument: Codeunit 5708;
        PurchHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
        TransferHeader: Record "Transfer Header";
    begin
        /*
        WITH UserTask DO BEGIN
          IF "Transaction Type" = "Transaction Type" :: Purchase THEN BEGIN
             PurchHeader.GET("Document Type","Document No.");
             ReleasePurchaseDocument.RUN(PurchHeader);
          END;
          IF "Transaction Type" = "Transaction Type" :: Sale THEN BEGIN
            SalesHeader.GET("Document Type","Document No.");
            ReleaseSalesDocument.RUN(SalesHeader);
          END;
        END;
        */

    end;


    procedure ReturnPO(var UserTask: Record "User Tasks New")
    begin
        loopflag := 0;
        IF NOT ((UserTask."Approvar ID" = UPPERCASE(USERID)) OR
          ((UserTask."Alternate Approvar ID" = UPPERCASE(USERID)) AND (UserTask."Alternate Approvar ID" <> '')))
        THEN
            ERROR('Un-Authorised User');
        /*
         IF Status<>Status::" " THEN
           ERROR('Cannot return such line');
         */
        Company.GET;
        IF CONFIRM(Text002, TRUE, UserTask."Document No") THEN BEGIN
            DocTypeApprovalRec.RESET;
            DocTypeApprovalRec.SETRANGE("Document Type", UserTask."Document Type");
            DocTypeApprovalRec.SETRANGE("Sub Document Type", UserTask."Sub Document Type");
            DocTypeApprovalRec.SETRANGE("Document No", UserTask."Document No");
            DocTypeApprovalRec.SETRANGE(Initiator, UserTask.Initiator);
            DocTypeApprovalRec.SETFILTER(DocTypeApprovalRec.Status, '<>%1', DocTypeApprovalRec.Status::" ");
            IF DocTypeApprovalRec.FIND('+') THEN BEGIN
                REPEAT
                    IF DocTypeApprovalRec.Status = DocTypeApprovalRec.Status::"Not Required" THEN BEGIN
                        DocTypeApprovalRec.Status := DocTypeApprovalRec.Status::" ";
                        DocTypeApprovalRec.MODIFY;
                    END ELSE
                        loopflag := 1;
                UNTIL (DocTypeApprovalRec.NEXT(-1) = 0) OR (loopflag = 1);
            END;
            DocTypeApprovalRec.RESET;
            DocTypeApprovalRec.SETRANGE("Document Type", UserTask."Document Type");
            DocTypeApprovalRec.SETRANGE("Sub Document Type", UserTask."Sub Document Type");
            DocTypeApprovalRec.SETRANGE("Document No", UserTask."Document No");
            DocTypeApprovalRec.SETRANGE(Initiator, UserTask.Initiator);
            DocTypeApprovalRec.SETFILTER(DocTypeApprovalRec.Status, '<>%1', DocTypeApprovalRec.Status::" ");
            IF DocTypeApprovalRec.FIND('+') THEN BEGIN
                DocTypeApprovalRec."Authorized Date" := 0D;
                DocTypeApprovalRec."Authorized Time" := 0T;
                DocTypeApprovalRec.Status := DocTypeApprovalRec.Status::" ";
                DocTypeApprovalRec.MODIFY;
                UserTask."Authorised Date" := TODAY;
                UserTask."Authorised Time" := TIME;
                UserTask.Status := UserTask.Status::Returned;
                UserTask.MODIFY;
                DocTypeApprovalRec.RESET;
                DocTypeApprovalRec.SETRANGE("Document Type", UserTask."Document Type");
                DocTypeApprovalRec.SETRANGE("Sub Document Type", UserTask."Sub Document Type");
                DocTypeApprovalRec.SETRANGE("Document No", UserTask."Document No");
                DocTypeApprovalRec.SETRANGE(Initiator, UserTask.Initiator);
                DocTypeApprovalRec.SETRANGE(DocTypeApprovalRec.Status, DocTypeApprovalRec.Status::" ");
                IF DocTypeApprovalRec.FIND('-') THEN
                    UserTask.AuthorizationPO(UserTask."Transaction Type", UserTask."Document Type", UserTask."Sub Document Type", UserTask."Document No");
            END ELSE BEGIN
                UserTask."Authorised Date" := TODAY;
                UserTask."Authorised Time" := TIME;
                UserTask.Status := UserTask.Status::Returned;
                UserTask.MODIFY;
                IF UserTask."Document Type" = UserTask."Document Type"::Indent THEN BEGIN
                    IndHeader.GET(IndHeader."Document Type"::Indent, UserTask."Document No");
                    IndHeader.VALIDATE("Sent for Approval", FALSE);
                    IndHeader."Sent for Approval Date" := 0D;
                    IndHeader."Sent for Approval Time" := 0T;
                    // RIL1.06 080911 Start
                    IF IndHeader.Approved THEN BEGIN
                        IndHeader.VALIDATE(Approved, FALSE);
                        IndHeader."Approved Date" := 0D;
                        IndHeader."Approved Time" := 0T;
                    END;
                    IndentLine.RESET;
                    IndentLine.SETRANGE("Document Type", IndHeader."Document Type");
                    IndentLine.SETRANGE("Document No.", IndHeader."Document No.");
                    IF IndentLine.FINDFIRST THEN
                        REPEAT
                            IndentLine."Sent for Approval" := FALSE;
                            IndentLine.Approved := FALSE;
                            IndentLine.MODIFY;
                        UNTIL IndentLine.NEXT = 0;
                    // RIL1.06 080911 End
                    IndHeader.MODIFY;
                    UserSetup.GET(IndHeader.Indentor);
                END;
                IF UserTask."Document Type" = UserTask."Document Type"::"Purchase Order" THEN BEGIN
                    PurchHeader.GET(PurchHeader."Document Type"::Order, UserTask."Document No");
                    PurchHeader.VALIDATE("Sent for Approval", FALSE);
                    PurchHeader."Sent for Approval Date" := 0D;
                    PurchHeader."Sent for Approval Time" := 0T;
                    PurchHeader.MODIFY;
                    UserSetup.GET(PurchHeader.Initiator);
                END;
                IF UserTask."Document Type" = UserTask."Document Type"::"Purchase Order Amendment" THEN BEGIN
                    PurchHeader.GET(PurchHeader."Document Type"::Order, UserTask."Document No");
                    PurchHeader.VALIDATE("Sent for Approval AWO", FALSE);
                    PurchHeader."Sent for Approval AWO Date" := 0D;
                    PurchHeader."Sent for Approval AWO Time" := 0T;
                    PurchHeader.MODIFY;
                    UserSetup.GET(PurchHeader.Initiator);
                END;
                IF UserTask."Document Type" = UserTask."Document Type"::Invoice THEN BEGIN
                    PurchHeader.GET(PurchHeader."Document Type"::Invoice, UserTask."Document No");
                    PurchHeader.VALIDATE("Sent for Approval", FALSE);
                    PurchHeader."Sent for Approval Date" := 0D;
                    PurchHeader."Sent for Approval Time" := 0T;
                    // RIL1.05 050911 Start
                    IF PurchHeader.Approved THEN BEGIN
                        PurchHeader.VALIDATE(Approved, FALSE);
                        PurchHeader."Approved Date" := 0D;
                        PurchHeader."Approved Time" := 0T;
                    END;
                    // RIL1.05 050911 End
                    PurchHeader.MODIFY;
                    UserSetup.GET(PurchHeader.Initiator);
                END;
                IF UserTask."Document Type" = UserTask."Document Type"::"Debit Note" THEN BEGIN
                    PurchHeader.GET(PurchHeader."Document Type"::"Credit Memo", UserTask."Document No");
                    PurchHeader.VALIDATE("Sent for Approval", FALSE);
                    PurchHeader."Sent for Approval Date" := 0D;
                    PurchHeader."Sent for Approval Time" := 0T;
                    PurchHeader.MODIFY;
                    UserSetup.GET(PurchHeader.Initiator);
                END;
                IF UserTask."Document Type" = UserTask."Document Type"::GRN THEN BEGIN
                    GRNHeader.GET(GRNHeader."Document Type"::GRN, UserTask."Document No");
                    GRNHeader.VALIDATE("Sent for Approval", FALSE);
                    GRNHeader."Sent for Approval Date" := 0D;
                    GRNHeader."Sent for Approval Time" := 0T;
                    GRNHeader.MODIFY;
                    UserSetup.GET(GRNHeader.Initiator);
                END;
                IF UserTask."Document Type" = UserTask."Document Type"::Job THEN BEGIN
                    job.GET(UserTask."Document No");
                    job.VALIDATE("Sent for Approval", FALSE);
                    job."Sent for Approval Date" := 0D;
                    job."Sent for Approval Time" := 0T;
                    job.MODIFY;
                    UserSetup.GET(job.Initiator);
                END;

            END;
        END;

    end;


    procedure RejectPO(var UserTask: Record "User Tasks New")
    begin
        IF NOT (UserTask."Document Type" IN [UserTask."Document Type"::Leave, UserTask."Document Type"::OD]) THEN
            ERROR(Err1);
        loopflag := 0;
        IF NOT ((UserTask."Approvar ID" = UPPERCASE(USERID)) OR
          ((UserTask."Alternate Approvar ID" = UPPERCASE(USERID)) AND (UserTask."Alternate Approvar ID" <> '')))
        THEN
            ERROR('Un-Authorised User');

        IF UserTask.Status <> UserTask.Status::" " THEN
            ERROR('Cannot reject such line');
        Company.GET;
        IF CONFIRM(Text002, TRUE, UserTask."Document No") THEN BEGIN
            DocTypeApprovalRec.RESET;
            DocTypeApprovalRec.SETRANGE("Document Type", UserTask."Document Type");
            DocTypeApprovalRec.SETRANGE("Sub Document Type", UserTask."Sub Document Type");
            DocTypeApprovalRec.SETRANGE("Document No", UserTask."Document No");
            DocTypeApprovalRec.SETRANGE(Initiator, UserTask.Initiator);
            DocTypeApprovalRec.SETFILTER(DocTypeApprovalRec.Status, '%1', DocTypeApprovalRec.Status::" ");
            IF DocTypeApprovalRec.FIND('-') THEN BEGIN
                DocTypeApprovalRec."Authorized Date" := TODAY;
                DocTypeApprovalRec."Authorized Time" := TIME;
                DocTypeApprovalRec.Status := DocTypeApprovalRec.Status::Rejected;
                DocTypeApprovalRec.MODIFY;
                UserTask."Authorised Date" := TODAY;
                UserTask."Authorised Time" := TIME;
                UserTask.Status := UserTask.Status::Rejected;
                UserTask.MODIFY;
            END;
        END;
    end;


    procedure AuthorizationSO("sTransaction Type": Option Purchase,Sale; "sDocument Type": Option Indent,"Purchase Order","Purchase Order Amendment",GRN,Invoice,Leave,OD,"Sale Order"; "sSub Document Type": Option " ","WO-ICB","WO-NICB","Regular PO","Repeat PO","Confirmatory PO","Direct PO","GRN for PO","GRN for JSPL","GRN for Packages","GRN for Fabricated Material for WO","JES for WO","GRN-Direct Purchase","Freight Advice","Order",Invoice; "sDocument No.": Code[20])
    begin
        Company.GET;
        IF "sTransaction Type" = "sTransaction Type"::Sale THEN BEGIN
            DocTypeSetupRec.GET("sDocument Type", "sSub Document Type");
            IF NOT DocTypeSetupRec."Approval Required" THEN
                EXIT;
            loopflag := 0;
            WFAmount := 0;
            IsValid := FALSE;
            IF (("sDocument Type" = "sDocument Type"::"Sale Order") AND ("sSub Document Type" = "sSub Document Type"::Order)) THEN BEGIN
                SalesHeader.GET(SalesHeader."Document Type"::Order, "sDocument No.");
                WFSaleLine.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
                WFSaleLine.SETRANGE("Document No.", "sDocument No.");
                IF WFSaleLine.FIND('-') THEN
                    REPEAT
                        //WFAmount := WFAmount + WFSaleLine."Amount To Customer" + WFSaleLine."TDS/TCS Amount";
                        WFAmount := WFAmount + WFSaleLine.Amount;
                    UNTIL WFSaleLine.NEXT = 0;
                IF SalesHeader.Approved THEN
                    ERROR(Text13002);
                IF NOT SalesHeader."Sent for Approval" THEN
                    ERROR('This document has not been sent for approval.');
            END;
            IF (("sDocument Type" = "sDocument Type"::"Sale Order") AND ("sSub Document Type" = "sSub Document Type"::Invoice)) THEN BEGIN
                SalesHeader.GET(SalesHeader."Document Type"::Invoice, "sDocument No.");
                SaleLine1.SETRANGE("Document Type", SalesHeader."Document Type"::Invoice);
                SaleLine1.SETRANGE("Document No.", "sDocument No.");
                IF SaleLine1.FIND('-') THEN
                    REPEAT
                        WFAmount := WFAmount + SaleLine1.Amount;
                    UNTIL SaleLine1.NEXT = 0;
                IF SalesHeader.Approved THEN
                    ERROR(Text13002);
                IF NOT SalesHeader."Sent for Approval" THEN
                    ERROR('This document has not been sent for approval.');
            END;
            DocTypeApprovalRec.RESET;
            DocTypeApprovalRec.SETRANGE("Document Type", "sDocument Type");
            DocTypeApprovalRec.SETRANGE("Sub Document Type", "sSub Document Type");
            DocTypeApprovalRec.SETRANGE("Document No", "sDocument No.");
            IF "sDocument Type" = "sDocument Type"::"Sale Order" THEN
                DocTypeApprovalRec.SETRANGE(Initiator, SalesHeader.Initiator);
            DocTypeApprovalRec.SETRANGE(DocTypeApprovalRec.Status, DocTypeApprovalRec.Status::" ");
            IF DocTypeApprovalRec.FIND('-') THEN BEGIN
                REPEAT
                    IF (DocTypeApprovalRec."Min Amount Limit" = 0) AND
                      (DocTypeApprovalRec."Max Amount Limit" = 0)
                    THEN
                        loopflag := 1;
                    IF NOT ((DocTypeApprovalRec."Min Amount Limit" = 0) AND
                      (DocTypeApprovalRec."Max Amount Limit" = 0))
                    THEN BEGIN
                        IF ((WFAmount >= DocTypeApprovalRec."Min Amount Limit") AND
                          (WFAmount <= DocTypeApprovalRec."Max Amount Limit")) OR
                          (WFAmount > DocTypeApprovalRec."Max Amount Limit")
                        THEN
                            loopflag := 1
                        ELSE BEGIN
                            DocTypeApprovalRec.Status := DocTypeApprovalRec.Status::"Not Required";
                            DocTypeApprovalRec.MODIFY;
                        END;
                    END;
                    IF loopflag = 1 THEN BEGIN
                        UserSetup.GET(DocTypeApprovalRec."Approvar ID");
                        UserTasks.LOCKTABLE;
                        UserTasks.SETCURRENTKEY("Entry No.");
                        IF UserTasks.FIND('+') THEN
                            EntryNo := UserTasks."Entry No." + 1
                        ELSE
                            EntryNo := 1;
                        UserTasks.INIT;
                        UserTasks."Entry No." := EntryNo;
                        UserTasks."Transaction Type" := "sTransaction Type";
                        UserTasks."Document Type" := "sDocument Type";
                        UserTasks."Sub Document Type" := "sSub Document Type";
                        UserTasks."Document No" := "sDocument No.";
                        UserTasks.Initiator := DocTypeApprovalRec.Initiator;
                        UserTasks."Document Approval Line No" := DocTypeApprovalRec."Line No";
                        UserTasks."Approvar ID" := DocTypeApprovalRec."Approvar ID";
                        UserTasks."Alternate Approvar ID" := DocTypeApprovalRec."Alternate Approvar ID";
                        UserTasks."Min Amount Limit" := DocTypeApprovalRec."Min Amount Limit";
                        UserTasks."Max Amount Limit" := DocTypeApprovalRec."Max Amount Limit";
                        UserTasks."Received From" := USERID;
                        UserTasks."Sent Date" := TODAY;
                        UserTasks."Sent Time" := TIME;
                        UserTasks.Activity := UserTasks.Activity;
                        UserTasks."Message Sent" := TRUE;
                        UserTasks.Description := 'Approve ' + FORMAT("sDocument Type") + ' ' + FORMAT("sSub Document Type") +
                          ' ' + FORMAT("sDocument No.");
                        UserTasks.Status := UserTasks.Status::" ";
                        UserTasks."Responsibility Centre" := SalesHeader."Responsibility Center";
                        IF ResCentreCode.GET(SalesHeader."Responsibility Center") THEN
                            UserTasks."Responsibility Centre Name" := ResCentreCode.Name;
                        UserTasks.INSERT;
                    END;
                UNTIL (DocTypeApprovalRec.NEXT = 0) OR (loopflag = 1);
            END;
            IF loopflag = 0 THEN BEGIN
                IF "sDocument Type" = "sDocument Type"::"Sale Order" THEN BEGIN
                    SalesHeader.VALIDATE(Approved, TRUE);
                    SalesHeader."Approved Date" := TODAY;
                    SalesHeader."Approved Time" := TIME;
                    SalesHeader.MODIFY;
                    UserSetup.GET(SalesHeader.Initiator);
                END;
                IF "sDocument Type" = "sDocument Type"::Invoice THEN BEGIN
                    SalesHeader.VALIDATE(Approved, TRUE);
                    SalesHeader."Approved Date" := TODAY;
                    SalesHeader."Approved Time" := TIME;
                    SalesHeader.MODIFY;
                    UserSetup.GET(SalesHeader.Initiator);
                END;
            END;
        END;
    end;


    procedure ApproveSO(var UserTask: Record "User Tasks New")
    begin
        IF NOT ((UserTask."Approvar ID" = UPPERCASE(USERID)) OR
         ((UserTask."Alternate Approvar ID" = UPPERCASE(USERID)) AND (UserTask."Alternate Approvar ID" <> ''))
       ) THEN
            ERROR('Un-Authorised User');

        IF UserTask.Status <> UserTask.Status::" " THEN
            ERROR('Cannot approve such line');

        Company.GET;
        IF CONFIRM(Text001, TRUE, UserTask."Document No") THEN BEGIN

            //for Purchase Transaction

            DocTypeApprovalRec.RESET;
            DocTypeApprovalRec.SETRANGE("Document Type", UserTask."Document Type");
            DocTypeApprovalRec.SETRANGE("Sub Document Type", UserTask."Sub Document Type");
            DocTypeApprovalRec.SETRANGE("Document No", UserTask."Document No");
            DocTypeApprovalRec.SETRANGE(Initiator, UserTask.Initiator);
            DocTypeApprovalRec.SETRANGE("Line No", UserTask."Document Approval Line No");
            DocTypeApprovalRec.SETRANGE("Approvar ID", UserTask."Approvar ID");
            DocTypeApprovalRec.SETRANGE(DocTypeApprovalRec.Status, DocTypeApprovalRec.Status::" ");
            IF NOT DocTypeApprovalRec.FIND('-') THEN
                ERROR('This request cannot be processed');

            DocTypeApprovalRec."Authorized Date" := TODAY;
            DocTypeApprovalRec."Authorized Time" := TIME;
            DocTypeApprovalRec.Status := DocTypeApprovalRec.Status::Approved;
            DocTypeApprovalRec.MODIFY;

            UserTask."Authorised Date" := TODAY;
            UserTask."Authorised Time" := TIME;
            UserTask.Status := UserTask.Status::Approved;
            UserTask.MODIFY;

            //Call SO Authorisation function
            DocTypeApprovalRec.RESET;
            DocTypeApprovalRec.SETRANGE("Document Type", UserTask."Document Type");
            DocTypeApprovalRec.SETRANGE("Sub Document Type", UserTask."Sub Document Type");
            DocTypeApprovalRec.SETRANGE("Document No", UserTask."Document No");
            DocTypeApprovalRec.SETRANGE(Initiator, UserTask.Initiator);
            DocTypeApprovalRec.SETRANGE(DocTypeApprovalRec.Status, DocTypeApprovalRec.Status::" ");
            IF DocTypeApprovalRec.FIND('-') THEN
                UserTask.AuthorizationSO(UserTask."Transaction Type", UserTask."Document Type", UserTask."Sub Document Type", UserTask."Document No")
            ELSE BEGIN
                //Approve SO
                IF ((UserTask."Document Type" = UserTask."Document Type"::"Sale Order") AND (UserTask."Sub Document Type" = UserTask."Sub Document Type"::Order)) THEN BEGIN
                    SalesHeader.GET(SalesHeader."Document Type"::Order, UserTask."Document No");
                    SalesHeader.VALIDATE(Approved, TRUE);
                    SalesHeader."Approved Date" := TODAY;
                    SalesHeader."Approved Time" := TIME;
                    SalesHeader.MODIFY;
                    UserSetup.GET(SalesHeader.Initiator);
                END;

                //Approve Invoice
                IF ((UserTask."Document Type" = UserTask."Document Type"::"Sale Order") AND (UserTask."Sub Document Type" = UserTask."Sub Document Type"::Invoice)) THEN BEGIN
                    SalesHeader.GET(SalesHeader."Document Type"::Invoice, UserTask."Document No");
                    SalesHeader.VALIDATE(Approved, TRUE);
                    SalesHeader."Approved Date" := TODAY;
                    SalesHeader."Approved Time" := TIME;
                    SalesHeader.MODIFY;
                    UserSetup.GET(SalesHeader.Initiator);
                END;

                //Approve Invoice
                IF ((UserTask."Document Type" = UserTask."Document Type"::"Credit Memo") AND (UserTask."Sub Document Type" = UserTask."Sub Document Type"::" ")) THEN BEGIN
                    SalesHeader.GET(SalesHeader."Document Type"::"Credit Memo", UserTask."Document No");
                    SalesHeader.VALIDATE(Approved, TRUE);
                    SalesHeader."Approved Date" := TODAY;
                    SalesHeader."Approved Time" := TIME;
                    SalesHeader.MODIFY;
                    UserSetup.GET(SalesHeader.Initiator);
                END;


                //=======================================
            END;

        END;
    end;


    procedure ReturnSO(var UserTask: Record "User Tasks New")
    begin
        loopflag := 0;
        IF NOT ((UserTask."Approvar ID" = UPPERCASE(USERID)) OR
                 ((UserTask."Alternate Approvar ID" = UPPERCASE(USERID)) AND (UserTask."Alternate Approvar ID" <> ''))
               ) THEN
            ERROR('Un-Authorised User');

        IF UserTask.Status <> UserTask.Status::" " THEN
            ERROR('Cannot return such line');

        Company.GET;
        IF CONFIRM(Text002, TRUE, UserTask."Document No") THEN BEGIN

            //for Purchase Transaction

            //check if any heirarchy to be skipped.
            DocTypeApprovalRec.RESET;
            DocTypeApprovalRec.SETRANGE("Document Type", UserTask."Document Type");
            DocTypeApprovalRec.SETRANGE("Sub Document Type", UserTask."Sub Document Type");
            DocTypeApprovalRec.SETRANGE("Document No", UserTask."Document No");
            DocTypeApprovalRec.SETRANGE(Initiator, UserTask.Initiator);
            //DocTypeApprovalRec.SETRANGE("Line No","Document Approval Line No");
            //DocTypeApprovalRec.SETRANGE("Approvar ID",UserTask."Approvar ID");
            DocTypeApprovalRec.SETFILTER(DocTypeApprovalRec.Status, '<>%1', DocTypeApprovalRec.Status::" ");
            IF DocTypeApprovalRec.FIND('+') THEN BEGIN
                REPEAT

                    IF DocTypeApprovalRec.Status = DocTypeApprovalRec.Status::"Not Required" THEN BEGIN
                        DocTypeApprovalRec.Status := DocTypeApprovalRec.Status::" ";
                        DocTypeApprovalRec.MODIFY;
                    END
                    ELSE
                        loopflag := 1;

                UNTIL (DocTypeApprovalRec.NEXT(-1) = 0) OR (loopflag = 1);
            END;


            DocTypeApprovalRec.RESET;
            DocTypeApprovalRec.SETRANGE("Document Type", UserTask."Document Type");
            DocTypeApprovalRec.SETRANGE("Sub Document Type", UserTask."Sub Document Type");
            DocTypeApprovalRec.SETRANGE("Document No", UserTask."Document No");
            DocTypeApprovalRec.SETRANGE(Initiator, UserTask.Initiator);
            //DocTypeApprovalRec.SETRANGE("Line No","Document Approval Line No");
            //DocTypeApprovalRec.SETRANGE("Approvar ID",UserTask."Approvar ID");
            DocTypeApprovalRec.SETFILTER(DocTypeApprovalRec.Status, '<>%1', DocTypeApprovalRec.Status::" ");
            IF DocTypeApprovalRec.FIND('+') THEN BEGIN

                //Not the Case of Modify Sent for Approval
                //ERROR('This request cannot be processed');

                DocTypeApprovalRec."Authorized Date" := 0D;
                DocTypeApprovalRec."Authorized Time" := 0T;
                DocTypeApprovalRec.Status := DocTypeApprovalRec.Status::" ";
                DocTypeApprovalRec.MODIFY;

                UserTask."Authorised Date" := TODAY;
                UserTask."Authorised Time" := TIME;
                UserTask.Status := UserTask.Status::Returned;
                UserTask.MODIFY;

                //Call SO Authorisation function
                DocTypeApprovalRec.RESET;
                DocTypeApprovalRec.SETRANGE("Document Type", UserTask."Document Type");
                DocTypeApprovalRec.SETRANGE("Sub Document Type", UserTask."Sub Document Type");
                DocTypeApprovalRec.SETRANGE("Document No", UserTask."Document No");
                DocTypeApprovalRec.SETRANGE(Initiator, UserTask.Initiator);
                DocTypeApprovalRec.SETRANGE(DocTypeApprovalRec.Status, DocTypeApprovalRec.Status::" ");
                IF DocTypeApprovalRec.FIND('-') THEN
                    //dds-start-10Sept2008 commented
                    //AuthorizationPO("Transaction Type","Document Type","Sub Document Type","Document No");
                    UserTask.AuthorizationSO(UserTask."Transaction Type", UserTask."Document Type", UserTask."Sub Document Type", UserTask."Document No");
                //dds-end-10Sept2008
            END
            ELSE BEGIN
                //case of sent for approval

                UserTask."Authorised Date" := TODAY;
                UserTask."Authorised Time" := TIME;
                UserTask.Status := UserTask.Status::Returned;
                UserTask.MODIFY;

                IF ((UserTask."Document Type" = UserTask."Document Type"::"Sale Order") AND (UserTask."Sub Document Type" = UserTask."Sub Document Type"::Order)) THEN BEGIN
                    SalesHeader.GET(SalesHeader."Document Type"::Order, UserTask."Document No");
                    SalesHeader.VALIDATE("Sent for Approval", FALSE);
                    SalesHeader."Sent for Approval Date" := 0D;
                    SalesHeader."Sent for Approval Time" := 0T;
                    SalesHeader.MODIFY;
                    UserSetup.GET(SalesHeader.Initiator);
                END;

                IF ((UserTask."Document Type" = UserTask."Document Type"::"Sale Order") AND (UserTask."Sub Document Type" = UserTask."Sub Document Type"::Invoice)) THEN BEGIN
                    SalesHeader.GET(SalesHeader."Document Type"::Invoice, UserTask."Document No");
                    SalesHeader.VALIDATE("Sent for Approval", FALSE);
                    SalesHeader."Sent for Approval Date" := 0D;
                    SalesHeader."Sent for Approval Time" := 0T;
                    SalesHeader.MODIFY;
                    UserSetup.GET(SalesHeader.Initiator);
                END;

                IF ((UserTask."Document Type" = UserTask."Document Type"::"Credit Memo") AND (UserTask."Sub Document Type" = UserTask."Sub Document Type"::" ")) THEN BEGIN
                    SalesHeader.GET(SalesHeader."Document Type"::"Credit Memo", UserTask."Document No");
                    SalesHeader.VALIDATE("Sent for Approval", FALSE);
                    SalesHeader."Sent for Approval Date" := 0D;
                    SalesHeader."Sent for Approval Time" := 0T;
                    SalesHeader.MODIFY;
                    UserSetup.GET(SalesHeader.Initiator);
                END;

                //NDALLE211205
            END;
        END;
    end;


    procedure RejectSO(var UserTask: Record "User Tasks New")
    begin
        IF NOT (UserTask."Document Type" IN [UserTask."Document Type"::Leave, UserTask."Document Type"::OD]) THEN
            ERROR(Err1);
        loopflag := 0;
        IF NOT ((UserTask."Approvar ID" = UPPERCASE(USERID)) OR
                 ((UserTask."Alternate Approvar ID" = UPPERCASE(USERID)) AND (UserTask."Alternate Approvar ID" <> ''))
               ) THEN
            ERROR('Un-Authorised User');

        IF UserTask.Status <> UserTask.Status::" " THEN
            ERROR('Cannot reject such line');

        Company.GET;
        IF CONFIRM(Text002, TRUE, UserTask."Document No") THEN BEGIN

            //for Sale Transaction

            DocTypeApprovalRec.RESET;
            DocTypeApprovalRec.SETRANGE("Document Type", UserTask."Document Type");
            DocTypeApprovalRec.SETRANGE("Sub Document Type", UserTask."Sub Document Type");
            DocTypeApprovalRec.SETRANGE("Document No", UserTask."Document No");
            DocTypeApprovalRec.SETRANGE(Initiator, UserTask.Initiator);
            //DocTypeApprovalRec.SETRANGE("Line No","Document Approval Line No");
            //DocTypeApprovalRec.SETRANGE("Approvar ID",UserTask."Approvar ID");
            DocTypeApprovalRec.SETFILTER(DocTypeApprovalRec.Status, '%1', DocTypeApprovalRec.Status::" ");
            IF DocTypeApprovalRec.FIND('-') THEN BEGIN
                DocTypeApprovalRec."Authorized Date" := TODAY;
                DocTypeApprovalRec."Authorized Time" := TIME;
                DocTypeApprovalRec.Status := DocTypeApprovalRec.Status::Rejected;
                DocTypeApprovalRec.MODIFY;

                UserTask."Authorised Date" := TODAY;
                UserTask."Authorised Time" := TIME;
                UserTask.Status := UserTask.Status::Rejected;
                UserTask.MODIFY;


            END;
        END;
    end;


    procedure ApproveTO(var UserTask: Record "User Tasks New")
    begin
        IF NOT ((UserTask."Approvar ID" = UPPERCASE(USERID)) OR
         ((UserTask."Alternate Approvar ID" = UPPERCASE(USERID)) AND (UserTask."Alternate Approvar ID" <> ''))
       ) THEN
            ERROR('Un-Authorised User');

        IF UserTask.Status <> UserTask.Status::" " THEN
            ERROR('Cannot approve such line');

        Company.GET;
        IF CONFIRM(Text001, TRUE, UserTask."Document No") THEN BEGIN

            //for Purchase Transaction
            TransHeader.GET(UserTask."Document No");
            DocTypeApprovalRec.RESET;
            DocTypeApprovalRec.SETRANGE("Document Type", UserTask."Document Type");
            DocTypeApprovalRec.SETRANGE("Sub Document Type", UserTask."Sub Document Type");
            DocTypeApprovalRec.SETRANGE("Document No", UserTask."Document No");
            DocTypeApprovalRec.SETRANGE(Initiator, UserTask.Initiator);
            DocTypeApprovalRec.SETRANGE("Line No", UserTask."Document Approval Line No");
            DocTypeApprovalRec.SETRANGE("Approvar ID", UserTask."Approvar ID");
            DocTypeApprovalRec.SETRANGE(DocTypeApprovalRec.Status, DocTypeApprovalRec.Status::" ");
            DocTypeApprovalRec.SETRANGE("Key Responsibility Center", TransHeader."Transfer-to Code");
            IF NOT DocTypeApprovalRec.FIND('-') THEN
                ERROR('This request cannot be processed');

            DocTypeApprovalRec."Authorized Date" := TODAY;
            DocTypeApprovalRec."Authorized Time" := TIME;
            DocTypeApprovalRec.Status := DocTypeApprovalRec.Status::Approved;
            DocTypeApprovalRec.MODIFY;

            UserTask."Authorised Date" := TODAY;
            UserTask."Authorised Time" := TIME;
            UserTask.Status := UserTask.Status::Approved;
            UserTask.MODIFY;

            //Call TO Authorisation function
            DocTypeApprovalRec.RESET;
            DocTypeApprovalRec.SETRANGE("Document Type", UserTask."Document Type");
            DocTypeApprovalRec.SETRANGE("Sub Document Type", UserTask."Sub Document Type");
            DocTypeApprovalRec.SETRANGE("Document No", UserTask."Document No");
            DocTypeApprovalRec.SETRANGE(Initiator, UserTask.Initiator);
            DocTypeApprovalRec.SETRANGE(DocTypeApprovalRec.Status, DocTypeApprovalRec.Status::" ");
            IF DocTypeApprovalRec.FIND('-') THEN
                UserTask.AuthorizationTO(UserTask."Transaction Type", UserTask."Document Type", UserTask."Sub Document Type", UserTask."Document No")
            ELSE BEGIN
                //Approve TO
                TransHeader.GET(UserTask."Document No");
                TransHeader.VALIDATE(Approved, TRUE);
                // TransHeader.Status:=TransHeader.Status::Released;
                TransHeader."Approved Date" := TODAY;
                TransHeader."Approved Time" := TIME;
                TransHeader.MODIFY;
                UserSetup.GET(TransHeader.Initiator);
            END;

            //=======================================
        END;
    end;


    procedure ReturnTO(var UserTask: Record "User Tasks New")
    begin
        loopflag := 0;
        IF NOT ((UserTask."Approvar ID" = UPPERCASE(USERID)) OR
                 ((UserTask."Alternate Approvar ID" = UPPERCASE(USERID)) AND (UserTask."Alternate Approvar ID" <> ''))
               ) THEN
            ERROR('Un-Authorised User');

        IF UserTask.Status <> UserTask.Status::" " THEN
            ERROR('Cannot return such line');

        Company.GET;
        IF CONFIRM(Text002, TRUE, UserTask."Document No") THEN BEGIN

            //for Purchase Transaction

            //check if any heirarchy to be skipped.
            DocTypeApprovalRec.RESET;
            DocTypeApprovalRec.SETRANGE("Document Type", UserTask."Document Type");
            DocTypeApprovalRec.SETRANGE("Sub Document Type", UserTask."Sub Document Type");
            DocTypeApprovalRec.SETRANGE("Document No", UserTask."Document No");
            DocTypeApprovalRec.SETRANGE(Initiator, UserTask.Initiator);
            //DocTypeApprovalRec.SETRANGE("Line No","Document Approval Line No");
            //DocTypeApprovalRec.SETRANGE("Approvar ID",UserTask."Approvar ID");
            DocTypeApprovalRec.SETFILTER(DocTypeApprovalRec.Status, '<>%1', DocTypeApprovalRec.Status::" ");
            IF DocTypeApprovalRec.FIND('+') THEN BEGIN
                REPEAT

                    IF DocTypeApprovalRec.Status = DocTypeApprovalRec.Status::"Not Required" THEN BEGIN
                        DocTypeApprovalRec.Status := DocTypeApprovalRec.Status::" ";
                        DocTypeApprovalRec.MODIFY;
                    END
                    ELSE
                        loopflag := 1;

                UNTIL (DocTypeApprovalRec.NEXT(-1) = 0) OR (loopflag = 1);
            END;


            DocTypeApprovalRec.RESET;
            DocTypeApprovalRec.SETRANGE("Document Type", UserTask."Document Type");
            DocTypeApprovalRec.SETRANGE("Sub Document Type", UserTask."Sub Document Type");
            DocTypeApprovalRec.SETRANGE("Document No", UserTask."Document No");
            DocTypeApprovalRec.SETRANGE(Initiator, UserTask.Initiator);
            //DocTypeApprovalRec.SETRANGE("Line No","Document Approval Line No");
            //DocTypeApprovalRec.SETRANGE("Approvar ID",UserTask."Approvar ID");
            DocTypeApprovalRec.SETFILTER(DocTypeApprovalRec.Status, '<>%1', DocTypeApprovalRec.Status::" ");
            IF DocTypeApprovalRec.FIND('+') THEN BEGIN

                //Not the Case of Modify Sent for Approval
                //ERROR('This request cannot be processed');

                DocTypeApprovalRec."Authorized Date" := 0D;
                DocTypeApprovalRec."Authorized Time" := 0T;
                DocTypeApprovalRec.Status := DocTypeApprovalRec.Status::" ";
                DocTypeApprovalRec.MODIFY;

                UserTask."Authorised Date" := TODAY;
                UserTask."Authorised Time" := TIME;
                UserTask.Status := UserTask.Status::Returned;
                UserTask.MODIFY;

                //Call TO Authorisation function
                DocTypeApprovalRec.RESET;
                DocTypeApprovalRec.SETRANGE("Document Type", UserTask."Document Type");
                DocTypeApprovalRec.SETRANGE("Sub Document Type", UserTask."Sub Document Type");
                DocTypeApprovalRec.SETRANGE("Document No", UserTask."Document No");
                DocTypeApprovalRec.SETRANGE(Initiator, UserTask.Initiator);
                DocTypeApprovalRec.SETRANGE(DocTypeApprovalRec.Status, DocTypeApprovalRec.Status::" ");
                IF DocTypeApprovalRec.FIND('-') THEN
                    UserTask.AuthorizationPO(UserTask."Transaction Type", UserTask."Document Type", UserTask."Sub Document Type", UserTask."Document No");

            END
            ELSE BEGIN
                //case of sent for approval

                UserTask."Authorised Date" := TODAY;
                UserTask."Authorised Time" := TIME;
                UserTask.Status := UserTask.Status::Returned;
                UserTask.MODIFY;

                TransHeader.GET(UserTask."Document No");
                TransHeader.VALIDATE("Sent for Approval", FALSE);
                TransHeader."Sent for Approval Date" := 0D;
                TransHeader."Sent for Approval Time" := 0T;
                TransHeader.MODIFY;
                UserSetup.GET(TransHeader.Initiator);
            END;
            //NDALLE211205
        END;
    end;


    procedure RejectTO(var UserTask: Record "User Tasks New")
    begin
        IF NOT (UserTask."Document Type" IN [UserTask."Document Type"::Leave, UserTask."Document Type"::OD]) THEN
            ERROR(Err1);
        loopflag := 0;
        IF NOT ((UserTask."Approvar ID" = UPPERCASE(USERID)) OR
                 ((UserTask."Alternate Approvar ID" = UPPERCASE(USERID)) AND (UserTask."Alternate Approvar ID" <> ''))
               ) THEN
            ERROR('Un-Authorised User');

        IF UserTask.Status <> UserTask.Status::" " THEN
            ERROR('Cannot reject such line');

        Company.GET;
        IF CONFIRM(Text002, TRUE, UserTask."Document No") THEN BEGIN

            //for Sale Transaction

            DocTypeApprovalRec.RESET;
            DocTypeApprovalRec.SETRANGE("Document Type", UserTask."Document Type");
            DocTypeApprovalRec.SETRANGE("Sub Document Type", UserTask."Sub Document Type");
            DocTypeApprovalRec.SETRANGE("Document No", UserTask."Document No");
            DocTypeApprovalRec.SETRANGE(Initiator, UserTask.Initiator);
            //DocTypeApprovalRec.SETRANGE("Line No","Document Approval Line No");
            //DocTypeApprovalRec.SETRANGE("Approvar ID",UserTask."Approvar ID");
            DocTypeApprovalRec.SETFILTER(DocTypeApprovalRec.Status, '%1', DocTypeApprovalRec.Status::" ");
            IF DocTypeApprovalRec.FIND('-') THEN BEGIN
                DocTypeApprovalRec."Authorized Date" := TODAY;
                DocTypeApprovalRec."Authorized Time" := TIME;
                DocTypeApprovalRec.Status := DocTypeApprovalRec.Status::Rejected;
                DocTypeApprovalRec.MODIFY;

                UserTask."Authorised Date" := TODAY;
                UserTask."Authorised Time" := TIME;
                UserTask.Status := UserTask.Status::Rejected;
                UserTask.MODIFY;


            END;
        END;
    end;


    procedure AuthorizationTO("sTransaction Type": Option Purchase,Sale; "sDocument Type": Option Indent,"Purchase Order","Purchase Order Amendment",GRN,Invoice,Leave,OD,"Sale Order","Debit Note","Transfer Order"; "sSub Document Type": Option " ","WO-ICB","WO-NICB","Regular PO","Repeat PO","Confirmatory PO","Direct PO","GRN for PO","GRN for JSPL","GRN for Packages","GRN for Fabricated Material for WO","JES for WO","GRN-Direct Purchase","Freight Advice","Order",Invoice,"Direct TO","Regular TO"; "sDocument No.": Code[20])
    begin
        Company.GET;
        //MESSAGE('%1 %2 %3 %4',"sTransaction Type","sDocument Type","sSub Document Type","sDocument No.");
        DocTypeSetupRec.GET("sDocument Type", "sSub Document Type");
        IF NOT DocTypeSetupRec."Approval Required" THEN
            EXIT;

        loopflag := 0;
        WFAmount := 0;
        IsValid := FALSE;
        //Transfer Order
        IF (("sDocument Type" = "sDocument Type"::"Transfer Order") AND (("sSub Document Type" = "sSub Document Type"::"Direct TO") OR
                        ("sSub Document Type" = "sSub Document Type"::"Regular TO"))) THEN BEGIN
            TransHeader.GET("sDocument No.");

            TransLine.SETRANGE("Document No.", "sDocument No.");
            IF TransLine.FIND('-') THEN
                REPEAT
                // WFAmount := WFAmount + WFSaleLine."Amount To Customer" + WFSaleLine."TDS/TCS Amount"+ WFSaleLine."Work Tax Amount";
                UNTIL TransLine.NEXT = 0;

            //IF NOT CONFIRM(Text13001) THEN
            //  EXIT;

            IF TransHeader.Approved THEN
                ERROR(Text13002);

            IF NOT TransHeader."Sent for Approval" THEN
                ERROR('This document has not been sent for approval.');

        END;


        DocTypeApprovalRec.RESET;
        DocTypeApprovalRec.SETRANGE("Document Type", "sDocument Type");
        DocTypeApprovalRec.SETRANGE("Sub Document Type", "sSub Document Type");
        DocTypeApprovalRec.SETRANGE("Document No", "sDocument No.");
        DocTypeApprovalRec.SETRANGE(DocTypeApprovalRec.Status, DocTypeApprovalRec.Status::" ");
        //ashish
        DocTypeApprovalRec.SETRANGE(DocTypeApprovalRec."Key Responsibility Center", TransHeader."Transfer-to Code");
        //MESSAGE('%1%2',TransHeader."No.",DocTypeApprovalRec."Key Responsibility Center");//PAWan
        IF DocTypeApprovalRec.FIND('-') THEN BEGIN
            REPEAT
                //write code to check for amount based approval
                IF (DocTypeApprovalRec."Min Amount Limit" = 0) AND
                   (DocTypeApprovalRec."Max Amount Limit" = 0) THEN
                    loopflag := 1;

                IF NOT ((DocTypeApprovalRec."Min Amount Limit" = 0) AND
                  (DocTypeApprovalRec."Max Amount Limit" = 0)) THEN BEGIN
                    IF ((WFAmount >= DocTypeApprovalRec."Min Amount Limit") AND
                      (WFAmount <= DocTypeApprovalRec."Max Amount Limit")) OR
                      (WFAmount > DocTypeApprovalRec."Max Amount Limit") THEN
                        loopflag := 1
                    ELSE BEGIN
                        DocTypeApprovalRec.Status := DocTypeApprovalRec.Status::"Not Required";
                        DocTypeApprovalRec.MODIFY;
                    END;
                END;
                //RAHEE1.00 040512
                IF TransHeader.GET("sDocument No.") THEN BEGIN
                    RescpCenter.RESET;
                    RescpCenter.SETRANGE("Subcon/Site Location", TransHeader."Transfer-from Code");
                    IF RescpCenter.FINDFIRST THEN BEGIN
                        IF TransHeader."Transfer-from Code" = RescpCenter."Subcon/Site Location" THEN
                            loopflag := 0;
                    END;
                END;
                //RAHEE1.00 040512

                IF loopflag = 1 THEN BEGIN
                    //IF USERID<> DocTypeApprovalRec."Approvar ID" THEN
                    // ERROR('UnAuthorised User');

                    UserSetup.GET(DocTypeApprovalRec."Approvar ID");

                    UserTasks.LOCKTABLE;
                    UserTasks.SETCURRENTKEY("Entry No.");
                    IF UserTasks.FIND('+') THEN
                        EntryNo := UserTasks."Entry No." + 1
                    ELSE
                        EntryNo := 1;
                    UserTasks.INIT;
                    UserTasks."Entry No." := EntryNo;
                    UserTasks."Transaction Type" := "sTransaction Type";
                    UserTasks."Document Type" := "sDocument Type";
                    UserTasks."Sub Document Type" := "sSub Document Type";
                    UserTasks."Document No" := "sDocument No.";
                    UserTasks.Initiator := DocTypeApprovalRec.Initiator;
                    UserTasks."Document Approval Line No" := DocTypeApprovalRec."Line No";
                    UserTasks."Approvar ID" := DocTypeApprovalRec."Approvar ID";
                    UserTasks."Alternate Approvar ID" := DocTypeApprovalRec."Alternate Approvar ID";
                    UserTasks."Min Amount Limit" := DocTypeApprovalRec."Min Amount Limit";
                    UserTasks."Max Amount Limit" := DocTypeApprovalRec."Max Amount Limit";
                    UserTasks."Received From" := USERID;
                    UserTasks."Sent Date" := TODAY;
                    UserTasks."Sent Time" := TIME;
                    UserTasks.Activity := UserTasks.Activity;
                    UserTasks."Message Sent" := TRUE;
                    UserTasks.Description := 'Approve ' + FORMAT("sDocument Type") + ' ' + FORMAT("sSub Document Type") +
                       ' ' + FORMAT("sDocument No.");
                    UserTasks.Status := UserTasks.Status::" ";
                    UserTasks.INSERT;

                END;//loopflag
            UNTIL (DocTypeApprovalRec.NEXT = 0) OR (loopflag = 1);
        END;

        IF loopflag = 0 THEN BEGIN
            TransHeader.VALIDATE(Approved, TRUE);
            TransHeader."Approved Date" := TODAY;
            TransHeader."Approved Time" := TIME;
            TransHeader.MODIFY;
            UserSetup.GET(TransHeader.Initiator);
        END;
    end;


    procedure ApproveJob(var UserTask: Record "User Tasks New")
    begin
        IF NOT ((UserTask."Approvar ID" = UPPERCASE(USERID)) OR
  ((UserTask."Alternate Approvar ID" = UPPERCASE(USERID)) AND (UserTask."Alternate Approvar ID" <> '')))
THEN
            ERROR('Un-Authorised User');
        IF UserTask.Status <> UserTask.Status::" " THEN
            ERROR('Cannot approve such line');
        Company.GET;
        IF CONFIRM(Text001, TRUE, UserTask."Document No") THEN BEGIN
            //for Purchase Transaction
            DocTypeApprovalRec.RESET;
            DocTypeApprovalRec.SETRANGE("Document Type", UserTask."Document Type");
            DocTypeApprovalRec.SETRANGE("Sub Document Type", UserTask."Sub Document Type");
            DocTypeApprovalRec.SETRANGE("Document No", UserTask."Document No");
            DocTypeApprovalRec.SETRANGE(Initiator, UserTask.Initiator);
            DocTypeApprovalRec.SETRANGE("Line No", UserTask."Document Approval Line No");
            DocTypeApprovalRec.SETRANGE("Approvar ID", UserTask."Approvar ID");
            DocTypeApprovalRec.SETRANGE(DocTypeApprovalRec.Status, DocTypeApprovalRec.Status::" ");
            IF NOT DocTypeApprovalRec.FIND('-') THEN
                ERROR('This request cannot be processed');
            DocTypeApprovalRec."Authorized Date" := TODAY;
            DocTypeApprovalRec."Authorized Time" := TIME;
            DocTypeApprovalRec."Authorized ID" := UPPERCASE(USERID);
            DocTypeApprovalRec.Status := DocTypeApprovalRec.Status::Approved;
            DocTypeApprovalRec.MODIFY;
            UserTask."Authorised Date" := TODAY;
            UserTask."Authorised Time" := TIME;
            UserTask.Status := UserTask.Status::Approved;
            UserTask.MODIFY;
            //Call PO Authorisation function
            DocTypeApprovalRec.RESET;
            DocTypeApprovalRec.SETRANGE("Document Type", UserTask."Document Type");
            DocTypeApprovalRec.SETRANGE("Sub Document Type", UserTask."Sub Document Type");
            DocTypeApprovalRec.SETRANGE("Document No", UserTask."Document No");
            DocTypeApprovalRec.SETRANGE(Initiator, UserTask.Initiator);
            DocTypeApprovalRec.SETRANGE(DocTypeApprovalRec.Status, DocTypeApprovalRec.Status::" ");
            IF DocTypeApprovalRec.FIND('-') THEN
                UserTask.AuthorizationPO(UserTask."Transaction Type", UserTask."Document Type", UserTask."Sub Document Type", UserTask."Document No")
            ELSE BEGIN
                //Approve Indent
                IF UserTask."Document Type" = UserTask."Document Type"::Indent THEN BEGIN
                    IndHeader.GET(IndHeader."Document Type"::Indent, UserTask."Document No");
                    IndHeader.VALIDATE(Approved, TRUE);
                    IndHeader."Approved Date" := TODAY;
                    IndHeader."Approved Time" := TIME;
                    IndHeader.MODIFY;
                    UserSetup.GET(IndHeader.Indentor);
                END;
                // ALLEAA
                /*
                IF "Document Type"="Document Type"::"Award Note" THEN BEGIN
                  AwardNote.GET("Document No");
                  AwardNote.VALIDATE(Approved,TRUE);
                  AwardNote."Approved Date":=TODAY;
                  AwardNote."Approved Time":=TIME;
                  AwardNote.MODIFY;
                  UserSetup.GET(AwardNote.Initiator);
                END;
                // ALLEAA
                 */
                //Approve PO
                IF UserTask."Document Type" = UserTask."Document Type"::"Purchase Order" THEN BEGIN
                    PurchHeader.GET(PurchHeader."Document Type"::Order, UserTask."Document No");
                    PurchHeader.VALIDATE(Approved, TRUE);
                    PurchHeader."Approved Date" := TODAY;
                    PurchHeader."Approved Time" := TIME;
                    PurchHeader.MODIFY;
                    UserSetup.GET(PurchHeader.Initiator);
                END;
                //Approve AmPO
                IF UserTask."Document Type" = UserTask."Document Type"::"Purchase Order Amendment" THEN BEGIN
                    PurchHeader.GET(PurchHeader."Document Type"::Order, UserTask."Document No");
                    PurchHeader.VALIDATE("Amendment Approved", TRUE);
                    PurchHeader."Amendment Approved Date" := TODAY;
                    PurchHeader."Amendment Approved Time" := TIME;
                    PurchHeader.MODIFY;
                    UserSetup.GET(PurchHeader."Amendment Initiator");
                END;
                //Approve Invoice
                IF UserTask."Document Type" = UserTask."Document Type"::Invoice THEN BEGIN
                    PurchHeader.GET(PurchHeader."Document Type"::Invoice, UserTask."Document No");
                    PurchHeader.VALIDATE(Approved, TRUE);
                    PurchHeader."Approved Date" := TODAY;
                    PurchHeader."Approved Time" := TIME;
                    PurchHeader.MODIFY;
                    UserSetup.GET(PurchHeader.Initiator);
                END;
                //Approve Debit Note
                IF UserTask."Document Type" = UserTask."Document Type"::"Debit Note" THEN BEGIN
                    PurchHeader.GET(PurchHeader."Document Type"::"Credit Memo", UserTask."Document No");
                    PurchHeader.VALIDATE(Approved, TRUE);
                    PurchHeader."Approved Date" := TODAY;
                    PurchHeader."Approved Time" := TIME;
                    PurchHeader.MODIFY;
                    UserSetup.GET(PurchHeader.Initiator);
                END;
                //Approve GRN
                IF UserTask."Document Type" = UserTask."Document Type"::GRN THEN BEGIN
                    GRNHeader.GET(GRNHeader."Document Type"::GRN, UserTask."Document No");
                    GRNHeader.VALIDATE(Approved, TRUE);
                    GRNHeader."Approved Date" := TODAY;
                    GRNHeader."Approved Time" := TIME;
                    GRNHeader.MODIFY;
                    UserSetup.GET(GRNHeader.Initiator);
                END;
                IF UserTask."Document Type" = UserTask."Document Type"::Job THEN BEGIN
                    job.GET(UserTask."Document No");
                    job.VALIDATE(Approved, TRUE);
                    job."Approved Date" := TODAY;
                    job."Approved Time" := TIME;
                    job.Blocked := job.Blocked::" ";  // ALLEPG 271211
                    job.MODIFY;
                    // ALLEPG 271211 Start
                    IF job.Approved THEN
                        ArchiveManagement.StoreJob2(job);
                    UserSetup.GET(job.Initiator);
                END;

                IF UserTask."Document Type" = UserTask."Document Type"::"Job Amendment" THEN BEGIN
                    job.GET(UserTask."Document No");
                    job.VALIDATE("Amendment Approved", TRUE);
                    job."Amendment Approved Date" := TODAY;
                    job."Amendment Approved Time" := TIME;
                    job.Blocked := job.Blocked::" ";  // ALLEPG 271211
                    job.MODIFY;
                    UserSetup.GET(job.Initiator);
                END;
                // ALLEPG 271211 End

                //Send mail to initiator
                UserSetup.GET(DocTypeApprovalRec.Initiator);
                //        IF Company."Mail Required" THEN BEGIN
                //          IF  "Document Type"="Document Type"::Indent THEN  BEGIN
                //            IndHdrForm.SETTABLEVIEW(IndHeader);
                //            Context := IndHdrForm.URL;
                //            FileName := IndHdrForm.CAPTION + '.URL';
                //          END;
                //          IF  "Document Type"="Document Type"::Invoice THEN BEGIN
                //            PurchaseInvoice.SETTABLEVIEW(PurchaseHeader);
                //            Context := PurchaseInvoice.URL;
                //            FileName := PurchaseInvoice.CAPTION + '.URL';
                //          END;
                //          IF  "Document Type"="Document Type"::"Purchase Order" THEN
                //          BEGIN
                //            PurchaseHeader.SETRANGE("Document Type",PurchHeader."Document Type");
                //            PurchaseHeader.SETRANGE("No.",PurchHeader."No.");
                //            IF PurchaseHeader.FIND('-') THEN BEGIN
                //              IF PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order THEN BEGIN
                //                PurchaseOrder.SETTABLEVIEW(PurchaseHeader);
                //                Context := PurchaseOrder.URL;
                //                FileName := PurchaseOrder.CAPTION + '.URL';
                //              END;
                //            END;
                //          END;
                //          IF  "Document Type"="Document Type"::"Purchase Order Amendment" THEN
                //          BEGIN
                //            PurchaseHeader.SETRANGE("Document Type",PurchHeader."Document Type");
                //            PurchaseHeader.SETRANGE("No.",PurchHeader."No.");
                //            IF PurchaseHeader.FIND('-') THEN BEGIN
                //              IF PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order THEN BEGIN
                //                PurchaseOrder.SETTABLEVIEW(PurchaseHeader);
                //                Context := PurchaseOrder.URL;
                //                FileName := PurchaseOrder.CAPTION + '.URL';
                //              END;
                //            END;
                //          END;
                //          REPEAT
                //            I := STRPOS(Context,' ');
                //            IF I <> 0 THEN BEGIN
                //              Context := DELSTR(Context,I,1);
                //              Context := INSSTR(Context,'%20',I);
                //            END;
                //          UNTIL (I=0);
                //          IF ISCLEAR(MAPIHandler) THEN
                //            CREATE(MAPIHandler);
                //          ErrorNo := 0;
                //          User.GET(UserSetup."User ID");
                //          MAPIHandler.ToName := UserSetup."E-Mail";
                //          MAPIHandler.CCName := '';
                //          DocInitiatorCC.GET(UserTask."Document Type",UserTask."Sub Document Type",UserSetup."User ID");
                //          IF DocInitiatorCC."CC Mail - User Code"<>'' THEN BEGIN
                //            UserSetupCC.GET(DocInitiatorCC."CC Mail - User Code");
                //            MAPIHandler.CCName := UserSetupCC."E-Mail";
                //          END;
                //          IF "Document Type"="Document Type"::Indent THEN  BEGIN
                //            MAPIHandler.Subject :=  IndHeader."Document No." + ' ' + Text13702;
                //            MAPIHandler.AddBodyText(Text13719 + User.Name);
                //            MAPIHandler.AddBodyText('');
                //            MAPIHandler.AddBodyText('The undermentioned document has been approved.');
                //            MAPIHandler.AddBodyText('');
                //        MAPIHandler.AddBodyText(Text13704 + FORMAT(IndHeader."Document Type"));
                //            MAPIHandler.AddBodyText(Text13705 + ' ' +  IndHeader."Document No.");
                //          MAPIHandler.AddBodyText('Indent Date:' + ' ' + FORMAT(IndHeader."Indent Date"));
                //            MAPIHandler.AddBodyText('');
                //          END;
                //          IF "Document Type"="Document Type"::"Purchase Order" THEN  BEGIN
                //            MAPIHandler.Subject :=  PurchHeader."No." + ' ' + Text13702;
                //            MAPIHandler.AddBodyText(Text13719 + User.Name);
                //            MAPIHandler.AddBodyText('');
                //            MAPIHandler.AddBodyText('The undermentioned document has been approved.');
                //            MAPIHandler.AddBodyText('');
                //            MAPIHandler.AddBodyText(Text13704 + FORMAT(PurchHeader."Document Type"));
                //            MAPIHandler.AddBodyText(Text13705 + ' ' +  PurchHeader."No.");
                //            MAPIHandler.AddBodyText(Text13706 + ' ' + FORMAT(PurchHeader."Document Date"));
                //            MAPIHandler.AddBodyText('');
                //            MAPIHandler.AddBodyText(Text13707 + PurchHeader."Buy-from Vendor Name");
                //          END;
                //
                //          IF "Document Type"="Document Type"::"Purchase Order Amendment" THEN  BEGIN
                //            MAPIHandler.Subject :=  PurchHeader."No." + ' ' + Text13702;
                //            MAPIHandler.AddBodyText(Text13719 + User.Name);
                //            MAPIHandler.AddBodyText('');
                //            MAPIHandler.AddBodyText('The undermentioned document has been approved.');
                //            MAPIHandler.AddBodyText('');
                //            MAPIHandler.AddBodyText(Text13704 + FORMAT(PurchHeader."Document Type"));
                //            MAPIHandler.AddBodyText(Text13705 + ' ' +  PurchHeader."No.");
                //            MAPIHandler.AddBodyText(Text13706 + ' ' + FORMAT(PurchHeader."Document Date"));
                //            MAPIHandler.AddBodyText('');
                //            MAPIHandler.AddBodyText(Text13707 + PurchHeader."Buy-from Vendor Name");
                //          END;
                //          IF "Document Type"="Document Type"::Invoice THEN  BEGIN
                //            MAPIHandler.Subject :=  PurchHeader."No." + ' ' + Text13702;
                //            MAPIHandler.AddBodyText(Text13719 + User.Name);
                //            MAPIHandler.AddBodyText('');
                //            MAPIHandler.AddBodyText('The undermentioned document has been approved.');
                //            MAPIHandler.AddBodyText('');
                //            MAPIHandler.AddBodyText(Text13704 + FORMAT(PurchHeader."Document Type"));
                //            MAPIHandler.AddBodyText(Text13705 + ' ' +  PurchHeader."No.");
                //            MAPIHandler.AddBodyText(Text13706 + ' ' + FORMAT(PurchHeader."Document Date"));
                //            MAPIHandler.AddBodyText('');
                //            MAPIHandler.AddBodyText(Text13707 + PurchHeader."Buy-from Vendor Name");
                //          END;
                //          IF "Document Type"="Document Type"::GRN THEN  BEGIN
                //            MAPIHandler.Subject :=  GRNHeader."GRN No." + ' ' + Text13702;
                //            MAPIHandler.AddBodyText(Text13719 + User.Name);
                //            MAPIHandler.AddBodyText('');
                //            MAPIHandler.AddBodyText('The undermentioned document has been approved.');
                //            MAPIHandler.AddBodyText('');
                //            MAPIHandler.AddBodyText(Text13704 + FORMAT(GRNHeader."Document Type"));
                //            MAPIHandler.AddBodyText(Text13705 + ' ' +  GRNHeader."GRN No.");
                //            MAPIHandler.AddBodyText(Text13706 + ' ' + FORMAT(GRNHeader."Posting Date"));
                //            MAPIHandler.AddBodyText('');
                //        END;
                //          MAPIHandler.AddBodyText('');
                //          User.GET(USERID);
                //          MAPIHandler.AddBodyText(Text13710 + User.Name);
                //          MAPIHandler.OpenDialog := FALSE;
                //          MAPIHandler.Send;
                //          ErrorNo := MAPIHandler.ErrorStatus;
                //        END;
            END;

        END;

    end;


    procedure AuthorizationJob("pTransaction Type": Option Purchase,Sale; "pDocument Type": Option Indent,"Purchase Order","Purchase Order Amendment",GRN,Invoice,Leave,OD,"Sale Order","Debit Note","Transfer Order","Credit Memo","Award Note",Job,"Job Amendment",Enquiry,"Service Invoice",Quote,"Contract Quote","Sale quote"; "pSub Document Type": Option " ","WO-ICB","WO-NICB","Regular PO","Repeat PO","Confirmatory PO","Direct PO","GRN for PO","GRN for JSPL","GRN for Packages","GRN for Fabricated Material for WO","JES for WO","GRN-Direct Purchase","Freight Advice","Order",Invoice,"Direct TO","Regular TO",Quote,FA,"Man Power",Leave,Travel,Others,"FA Sale",Hire; "pDocument No.": Code[20])
    begin
        RespName := '';
        RespCode := '';
        Company.GET;
        IF "pTransaction Type" = "pTransaction Type"::Purchase THEN BEGIN
            DocTypeSetupRec.GET("pDocument Type", "pSub Document Type");
            IF NOT DocTypeSetupRec."Approval Required" THEN
                EXIT;
            loopflag := 0;
            WFAmount := 0;
            IsValid := FALSE;
            IF "pDocument Type" = "pDocument Type"::Indent THEN BEGIN
                IndHeader.GET(IndHeader."Document Type"::Indent, "pDocument No.");
                RespCode := IndHeader."Responsibility Center";
                ResCentreCode.GET(IndHeader."Responsibility Center");
                RespName := ResCentreCode.Name;
                IndLine.SETRANGE("Document Type", IndHeader."Document Type"::Indent);
                IndLine.SETRANGE("Document No.", "pDocument No.");
                IF IndLine.FIND('-') THEN
                    REPEAT
                        WFAmount := WFAmount + IndLine.Amount;
                    UNTIL IndLine.NEXT = 0;
                IF IndHeader.Approved THEN
                    ERROR(Text13002);
                IF NOT IndHeader."Sent for Approval" THEN
                    ERROR('This document has not been sent for approval.');
            END;
            IF "pDocument Type" = "pDocument Type"::"Purchase Order" THEN BEGIN
                PurchHeader.GET(PurchHeader."Document Type"::Order, "pDocument No.");
                RespCode := PurchHeader."Responsibility Center";
                ResCentreCode.GET(PurchHeader."Responsibility Center");
                RespName := ResCentreCode.Name;
                WFPurchLine.SETRANGE("Document Type", PurchHeader."Document Type"::Order);
                WFPurchLine.SETRANGE("Document No.", "pDocument No.");
                IF WFPurchLine.FIND('-') THEN
                    REPEAT
                        //WFAmount := WFAmount + WFPurchLine."Amount To Vendor" + WFPurchLine."TDS Amount" + WFPurchLine."Work Tax Amount";
                        WFAmount := WFAmount + WFPurchLine.Amount;
                    UNTIL WFPurchLine.NEXT = 0;
                IF PurchHeader.Approved THEN
                    ERROR(Text13002);
                IF NOT PurchHeader."Sent for Approval" THEN
                    ERROR('This document has not been sent for approval.');
            END;
            //Purchase Order Amendment
            IF "pDocument Type" = "pDocument Type"::"Purchase Order Amendment" THEN BEGIN
                PurchHeader.GET(PurchHeader."Document Type"::Order, "pDocument No.");
                RespCode := PurchHeader."Responsibility Center";
                ResCentreCode.GET(PurchHeader."Responsibility Center");
                RespName := ResCentreCode.Name;
                WFPurchLine.SETRANGE("Document Type", PurchHeader."Document Type"::Order);
                WFPurchLine.SETRANGE("Document No.", "pDocument No.");
                IF WFPurchLine.FIND('-') THEN
                    REPEAT
                        //WFAmount := WFAmount + WFPurchLine."Amount To Vendor" + WFPurchLine."TDS Amount" + WFPurchLine."Work Tax Amount";
                        WFAmount := WFAmount + WFPurchLine.Amount;// + WFPurchLine."TDS Amount" + WFPurchLine."Work Tax Amount";
                    UNTIL WFPurchLine.NEXT = 0;
                IF PurchHeader."Amendment Approved" THEN
                    ERROR(Text13002);
            END;
            //Invoice
            IF "pDocument Type" = "pDocument Type"::Invoice THEN BEGIN
                PurchHeader.GET(PurchHeader."Document Type"::Invoice, "pDocument No.");
                RespCode := PurchHeader."Responsibility Center";
                ResCentreCode.GET(PurchHeader."Responsibility Center");
                RespName := ResCentreCode.Name;
                PurchLine1.SETRANGE("Document Type", PurchHeader."Document Type"::Invoice);
                PurchLine1.SETRANGE("Document No.", "pDocument No.");
                IF PurchLine1.FIND('-') THEN
                    REPEAT
                        WFAmount := WFAmount + PurchLine1.Amount;
                    UNTIL PurchLine1.NEXT = 0;
                IF PurchHeader.Approved THEN
                    ERROR(Text13002);
                IF NOT PurchHeader."Sent for Approval" THEN
                    ERROR('This document has not been sent for approval.');
            END;
            // Debit note
            IF "pDocument Type" = "pDocument Type"::"Debit Note" THEN BEGIN
                PurchHeader.GET(PurchHeader."Document Type"::"Credit Memo", "pDocument No.");
                RespCode := PurchHeader."Responsibility Center";
                ResCentreCode.GET(PurchHeader."Responsibility Center");
                RespName := ResCentreCode.Name;
                PurchLine1.SETRANGE("Document Type", PurchHeader."Document Type"::"Credit Memo");
                PurchLine1.SETRANGE("Document No.", "pDocument No.");
                IF PurchLine1.FIND('-') THEN
                    REPEAT
                        WFAmount := WFAmount + PurchLine1.Amount;
                    UNTIL PurchLine1.NEXT = 0;
                IF PurchHeader.Approved THEN
                    ERROR(Text13002);
                IF NOT PurchHeader."Sent for Approval" THEN
                    ERROR('This document has not been sent for approval.');
            END;
            //GRN
            IF "pDocument Type" = "pDocument Type"::GRN THEN BEGIN
                GRNHeader.GET(GRNHeader."Document Type"::GRN, "pDocument No.");
                RespCode := GRNHeader."Responsibility Center";
                ResCentreCode.GET(GRNHeader."Responsibility Center");
                RespName := ResCentreCode.Name;
                GRNLine.SETRANGE("Document Type", GRNHeader."Document Type"::GRN);
                GRNLine.SETRANGE("GRN No.", "pDocument No.");
                IF GRNHeader.Approved THEN
                    ERROR(Text13002);
                IF NOT GRNHeader."Sent for Approval" THEN
                    ERROR('This document has not been sent for approval.');
            END;
            //JOB
            IF "pDocument Type" = "pDocument Type"::Job THEN BEGIN
                job.GET("pDocument No.");
                RespCode := job."Responsibility Center";
                ResCentreCode.GET(job."Responsibility Center");
                //RespName:=JOB.Name;
                IF job.Approved THEN
                    ERROR(Text13002);
                IF NOT job."Sent for Approval" THEN
                    ERROR('This document has not been sent for approval.');
            END;
            DocTypeApprovalRec.RESET;
            DocTypeApprovalRec.SETRANGE("Document Type", "pDocument Type");
            DocTypeApprovalRec.SETRANGE("Sub Document Type", "pSub Document Type");
            DocTypeApprovalRec.SETRANGE("Document No", "pDocument No.");
            IF "pDocument Type" = "pDocument Type"::"Purchase Order" THEN
                DocTypeApprovalRec.SETRANGE(Initiator, PurchHeader.Initiator);
            IF "pDocument Type" = "pDocument Type"::"Purchase Order Amendment" THEN
                DocTypeApprovalRec.SETRANGE(Initiator, PurchHeader."Amendment Initiator");
            IF "pDocument Type" = "pDocument Type"::Indent THEN
                DocTypeApprovalRec.SETRANGE(Initiator, IndHeader.Indentor);
            IF "pDocument Type" = "pDocument Type"::Invoice THEN
                DocTypeApprovalRec.SETRANGE(Initiator, PurchHeader.Initiator);
            IF "pDocument Type" = "pDocument Type"::GRN THEN
                DocTypeApprovalRec.SETRANGE(Initiator, GRNHeader.Initiator);
            DocTypeApprovalRec.SETRANGE(DocTypeApprovalRec.Status, DocTypeApprovalRec.Status::" ");
            IF DocTypeApprovalRec.FIND('-') THEN BEGIN
                REPEAT
                    DocTypeApprovalRec."Document Responsibility Centre" := RespCode;
                    DocTypeApprovalRec."Document Resposibility Name" := RespName;
                    //write code to check for amount based approval
                    IF (DocTypeApprovalRec."Min Amount Limit" = 0) AND
                      (DocTypeApprovalRec."Max Amount Limit" = 0)
                    THEN
                        loopflag := 1;
                    IF NOT ((DocTypeApprovalRec."Min Amount Limit" = 0) AND
                      (DocTypeApprovalRec."Max Amount Limit" = 0))
                    THEN BEGIN
                        IF ((WFAmount >= DocTypeApprovalRec."Min Amount Limit") AND
                          (WFAmount <= DocTypeApprovalRec."Max Amount Limit"))  //OR
                                                                                // (WFAmount >DocTypeApprovalRec."Max Amount Limit")
                        THEN
                            loopflag := 1
                        ELSE BEGIN
                            DocTypeApprovalRec.Status := DocTypeApprovalRec.Status::"Not Required";
                            DocTypeApprovalRec.MODIFY;
                        END;
                    END;
                    IF loopflag = 1 THEN BEGIN
                        UserSetup.GET(DocTypeApprovalRec."Approvar ID");
                        UserTasks.LOCKTABLE;
                        UserTasks.SETCURRENTKEY("Entry No.");
                        IF UserTasks.FIND('+') THEN
                            EntryNo := UserTasks."Entry No." + 1
                        ELSE
                            EntryNo := 1;
                        UserTasks.INIT;
                        UserTasks."Entry No." := EntryNo;
                        UserTasks."Transaction Type" := "pTransaction Type";
                        UserTasks."Document Type" := "pDocument Type";
                        UserTasks."Sub Document Type" := "pSub Document Type";
                        UserTasks."Document No" := "pDocument No.";
                        UserTasks.Initiator := DocTypeApprovalRec.Initiator;
                        UserTasks."Document Approval Line No" := DocTypeApprovalRec."Line No";
                        UserTasks."Approvar ID" := DocTypeApprovalRec."Approvar ID";
                        UserTasks."Alternate Approvar ID" := DocTypeApprovalRec."Alternate Approvar ID";
                        UserTasks."Min Amount Limit" := DocTypeApprovalRec."Min Amount Limit";
                        UserTasks."Max Amount Limit" := DocTypeApprovalRec."Max Amount Limit";
                        UserTasks."Responsibility Centre" := DocTypeApprovalRec."Document Responsibility Centre";
                        UserTasks."Responsibility Centre Name" := DocTypeApprovalRec."Document Resposibility Name";
                        UserTasks."Received From" := USERID;
                        UserTasks."Sent Date" := TODAY;
                        UserTasks."Sent Time" := TIME;
                        UserTasks.Activity := UserTasks.Activity;
                        UserTasks."Message Sent" := TRUE;
                        UserTasks.Description := 'Approve ' + FORMAT("pDocument Type") + ' ' + FORMAT("pSub Document Type") +
                          ' ' + FORMAT("pDocument No.");
                        UserTasks.Status := UserTasks.Status::" ";
                        UserTasks."Initiator Remarks" := DocTypeApprovalRec."Initiator Remarks";
                        UserTasks."Approval Remarks" := DocTypeApprovalRec."Approval Remarks";
                        UserTasks.INSERT;
                    END;//loopflag
                UNTIL (DocTypeApprovalRec.NEXT = 0) OR (loopflag = 1);
            END;
            IF loopflag = 0 THEN BEGIN
                IF "pDocument Type" = "pDocument Type"::Indent THEN BEGIN
                    IndHeader.VALIDATE(Approved, TRUE);
                    IndHeader."Approved Date" := TODAY;
                    IndHeader."Approved Time" := TIME;
                    IndHeader.MODIFY;
                    UserSetup.GET(IndHeader.Indentor);
                END;
                IF "pDocument Type" = "pDocument Type"::"Purchase Order" THEN BEGIN
                    PurchHeader.VALIDATE(Approved, TRUE);
                    PurchHeader."Approved Date" := TODAY;
                    PurchHeader."Approved Time" := TIME;
                    PurchHeader.MODIFY;
                    UserSetup.GET(PurchHeader.Initiator);
                END;
                IF "pDocument Type" = "pDocument Type"::"Purchase Order Amendment" THEN BEGIN
                    PurchHeader.VALIDATE("Amendment Approved", TRUE);
                    PurchHeader."Amendment Approved Date" := TODAY;
                    PurchHeader."Amendment Approved Time" := TIME;
                    PurchHeader.MODIFY;
                    UserSetup.GET(PurchHeader."Amendment Initiator");
                END;
                IF "pDocument Type" = "pDocument Type"::Invoice THEN BEGIN
                    PurchHeader.VALIDATE(Approved, TRUE);
                    PurchHeader."Approved Date" := TODAY;
                    PurchHeader."Approved Time" := TIME;
                    PurchHeader.MODIFY;
                    UserSetup.GET(PurchHeader.Initiator);
                END;
                IF "pDocument Type" = "pDocument Type"::GRN THEN BEGIN
                    GRNHeader.VALIDATE(Approved, TRUE);
                    GRNHeader."Approved Date" := TODAY;
                    GRNHeader."Approved Time" := TIME;
                    GRNHeader.MODIFY;
                    UserSetup.GET(GRNHeader.Initiator);
                END;

                IF "pDocument Type" = "pDocument Type"::Job THEN BEGIN
                    job.VALIDATE(Approved, TRUE);
                    job.VALIDATE(Blocked, job.Blocked::" ");
                    job."Approved Date" := TODAY;
                    job."Approved Time" := TIME;
                    job.MODIFY;
                    UserSetup.GET(job.Initiator);
                END;
            END;
        END;
    end;
}

