tableextension 50013 "BBG Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        // Add changes to table fields here
        modify("Responsibility Center")
        {
            TableRelation = "Responsibility Center 1";
        }
        field(50011; "Indent No."; Code[20])
        {
            Caption = 'Purch. Req. No.';
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
            TableRelation = "Purchase Request Header"."Document No.";
        }
        field(50012; "Enquiry No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
            TableRelation = "Vendor Enquiry Details" WHERE("Vendor No." = FIELD("Buy-from Vendor No."),
                                                            "Indent No." = FIELD("Indent No."),
                                                            Status = CONST(Sent));

            trigger OnValidate()
            begin
                //Alle PS 14-10-2008 Added code for Entering Document No.
                TESTFIELD(Status, Status::Open);
                IF "Document Type" = "Document Type"::Quote THEN BEGIN
                    IF "Enquiry No." <> '' THEN BEGIN
                        PurchLine2.RESET;
                        PurchLine2.SETRANGE("Document Type", "Document Type");
                        PurchLine2.SETRANGE("Document No.", "No.");
                        IF PurchLine2.FIND('-') THEN BEGIN
                            PurchLine2.DELETEALL;
                        END;
                        LineNo := 10000;
                        EnquiryLine.RESET;
                        EnquiryLine.SETRANGE("Enquiry No.", "Enquiry No.");
                        IF EnquiryLine.FIND('-') THEN
                            REPEAT
                                PurchLine2.INIT;
                                PurchLine2."Document Type" := "Document Type";
                                PurchLine2."Document No." := "No.";
                                PurchLine2."Line No." := LineNo;
                                LineNo := LineNo + 10000;
                                PurchLine2.INSERT;
                                PurchLine2."Buy-from Vendor No." := "Buy-from Vendor No.";
                                PurchLine2.Type := EnquiryLine.Type;
                                PurchLine2.VALIDATE(PurchLine2."No.", EnquiryLine."No.");
                                PurchLine2.VALIDATE(PurchLine2."Location Code", EnquiryLine."Location Code");
                                PurchLine2.VALIDATE(PurchLine2.Quantity, EnquiryLine.Quantity);

                                PurchLine2.VALIDATE(PurchLine2."Direct Unit Cost", 0);
                                PurchLine2.VALIDATE(PurchLine2."Unit of Measure Code", EnquiryLine."Uint of Measure");
                                PurchLine2.VALIDATE(PurchLine2."Shortcut Dimension 1 Code", EnquiryLine."Global Dimension 1 Code");
                                PurchLine2.VALIDATE(PurchLine2."Shortcut Dimension 2 Code", EnquiryLine."Global Dimension 2 Code");
                                PurchLine2."Enquiry No." := EnquiryLine."Enquiry No.";
                                PurchLine2."Enquiry Line No." := EnquiryLine."Line No.";
                                //ALLERP Start:
                                PurchLine2."Indent No" := EnquiryLine."PR No.";
                                PurchLine2."Indent Line No" := EnquiryLine."PR Line No.";
                                PurchLine2."Job Code" := EnquiryLine."Job Master Code";
                                //ALLERP End:
                                PurchLine2.Description := EnquiryLine.Description;
                                PurchLine2."Description 2" := EnquiryLine.Description2;
                                //ALLEDK 090610 for Flow of Job no and Job Task no. From Enquiry Line
                                PurchLine2."Job No." := EnquiryLine."Job No.";
                                PurchLine2."Job Task No." := EnquiryLine."Job Task No.";
                                //ALLEDK 090610
                                PurchLine2.MODIFY;
                            UNTIL EnquiryLine.NEXT = 0;
                    END;
                END
                //Alle PS ENDS
            end;
        }

        field(50014; "Award Note No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
            TableRelation = "Print Approval" WHERE("Approver ID" = CONST('1'));//Field50035 = FIELD("Buy-from Vendor No."

        }

        field(50017; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(50018; "Creation Time"; Time)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }

        field(50041; "Tools and Tackles"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL,KLND1.00  change option captions';
            OptionCaption = ' ,Free,Chargeable,Contractor';
            OptionMembers = " ",Free,Chargeable,Contractor;
        }

        field(50043; "BBG Invoice Received Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'added by dds - 03Dec07';
        }
        field(50061; "IC Purchase Order"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50062; "Land Expense Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
        }


        field(50100; "Manufacturer Certificate Req."; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'KLND1.00 140311';
        }
        field(50101; "Third Party Certificate Req."; Boolean)
        {
            Caption = 'Third Party Certificate Req.';
            DataClassification = ToBeClassified;
            Description = 'KLND1.00 140311';
        }
        field(50102; "Manufacturer Certificate Recd"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'KLND1.00 140311';
        }
        field(50103; "Third Party Certificate Recd"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'KLND1.00 140311';
        }
        field(50104; "Internal Certificate Req."; Boolean)
        {
            Caption = 'Internal Certificate Req.';
            DataClassification = ToBeClassified;
            Description = 'KLND1.00 140311';
        }
        field(50105; "Internal Certificate Recd"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'KLND1.00 140311';
        }
        field(50106; "Weight Bill No"; Text[30])
        {
            DataClassification = ToBeClassified;
        }







        field(50115; "IC Land Purchase"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(50117; "Item Revaluation"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50215; "Show in AN"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
        }
        field(50216; "Land Agreement Doc. Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50217; "Quantity for PO"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESSS';
            Editable = false;
        }
        field(70023; "Form 59A No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(70024; "Challan Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
            Editable = false;
        }
        field(70025; "Mode of Transport"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
            OptionMembers = Road,Rail;
        }



        field(80000; "Quality Certificate No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB';
            Enabled = false;
        }

        field(98500; "Date Received"; Date)
        {
            Caption = 'Date Received';
            DataClassification = ToBeClassified;
        }
        field(98501; "Time Received"; Time)
        {
            Caption = 'Time Received';
            DataClassification = ToBeClassified;
        }
        field(98504; "BizTalk Purchase Quote"; Boolean)
        {
            Caption = 'BizTalk Purchase Quote';
            DataClassification = ToBeClassified;
        }
        field(98505; "BizTalk Purch. Order Cnfmn."; Boolean)
        {
            Caption = 'BizTalk Purch. Order Cnfmn.';
            DataClassification = ToBeClassified;
        }
        field(98506; "BizTalk Purchase Invoice"; Boolean)
        {
            Caption = 'BizTalk Purchase Invoice';
            DataClassification = ToBeClassified;
        }
        field(98507; "BizTalk Purchase Receipt"; Boolean)
        {
            Caption = 'BizTalk Purchase Receipt';
            DataClassification = ToBeClassified;
        }
        field(98508; "BizTalk Purchase Credit Memo"; Boolean)
        {
            Caption = 'BizTalk Purchase Credit Memo';
            DataClassification = ToBeClassified;
        }
        field(98509; "Date Sent"; Date)
        {
            Caption = 'Date Sent';
            DataClassification = ToBeClassified;
        }
        field(98510; "Time Sent"; Time)
        {
            Caption = 'Time Sent';
            DataClassification = ToBeClassified;
        }
        field(98511; "BizTalk Request for Purch. Qte"; Boolean)
        {
            Caption = 'BizTalk Request for Purch. Qte';
            DataClassification = ToBeClassified;
        }
        field(98512; "BizTalk Purchase Order"; Boolean)
        {
            Caption = 'BizTalk Purchase Order';
            DataClassification = ToBeClassified;
        }
        field(98520; "Vendor Quote No."; Code[20])
        {
            Caption = 'Vendor Quote No.';
            DataClassification = ToBeClassified;
        }
        field(98521; "BizTalk Document Sent"; Boolean)
        {
            Caption = 'BizTalk Document Sent';
            DataClassification = ToBeClassified;
        }
        Field(98522; "Ref. External Doc. No."; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = False;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
        Text500: Label 'ENU=Order once closed will be removed from pending PO list and appear as Closed Purchase Orders.\Do you want to %1 this Order ?';
        QtyZero: Boolean;
        CostZero: Boolean;
        GLBudgetName: Record "G/L Budget Name";
        RecUserSetup: Record "User Setup";
        RecRespCenter: Record "Responsibility Center 1";
        lno: Integer;
        STTEXTRec: Record "Standard Text";
        PurchLine2: Record "Purchase Line";
        TermsRec: Record Terms;
        UserTaskNew: Record "User Tasks New";
        LineNo: Integer;
        EnquiryLine: Record "Enquiry Line";
        AwardNote: Record "Print Approval";
        PurchaseLineRec: Record "Purchase Line";
        Job: Record Job;
        UserSetup: Record "User Setup";
        PaymentTermLine: Record "Payment Terms Line";
        DocTypSetup: Record "Document Type Setup";
        POTermsCon: Record "PO Terms & Conditions";
        JobAllocation: Record "Job Allocation";
        Text50001: Label 'ENU=Without Excise,With Excise';
        Text50000: Label 'ENU=Order once closed will be removed from pending PO list and appear as Closed Purchase Orders.\Do you want to %1 this Order ?';
        WorkFlowDocTypSetup: Record "Workflow Doc. Type Setup";
        FASetup: Record "FA Setup";
        GateEntryAttachment: Record "Gate Entry Attachment";


    trigger OnAfterInsert()
    var
        DocSetup: Record "Document Type Setup";
        DocInitiator: Record "Document Type Initiator";
        DocApproval: Record "Document Type Approval";
        DocumentApproval: Record "Document Type Approval";
        DimValue: Record "Dimension Value";
    begin
        IF WORKDATE < 20080221D THEN
            ERROR('You can not work on this workdate');

        "Initiator User ID" := "User ID";
        Initiator := "User ID";
        //JPL START
        "User ID" := USERID;
        Initiator := USERID;
        "Initiator User ID" := USERID;

        "Creation Date" := TODAY;
        "Creation Time" := TIME;
        //        {
        //        IF "Document Type" = "Document Type"::Order THEN BEGIN
        //     "Starting Date" := WORKDATE;
        //     DocSetup.RESET;
        //     DocSetup.SETRANGE("Document Type", DocSetup."Document Type"::"Purchase Order");
        //     DocSetup.SETRANGE("Sub Document Type", "Sub Document Type");
        //     IF DocSetup.FIND('-') THEN BEGIN
        //         IF DocSetup."Work Tax Applicable" THEN
        //             "Work Tax Applicable" := DocSetup."Work Tax Applicable";
        //     END;
        //     DocSetup.RESET;
        //     DocSetup.SETRANGE("Document Type", DocSetup."Document Type"::"Purchase Order");
        //     DocSetup.SETRANGE("Sub Document Type", "Sub Document Type");
        //     DocSetup.SETRANGE("Approval Required", TRUE);
        //     IF DocSetup.FIND('-') THEN BEGIN
        //         DocInitiator.GET(DocSetup."Document Type"::"Purchase Order", "Sub Document Type", Initiator);
        //         DocApproval.RESET;
        //         DocApproval.SETRANGE("Document Type", DocSetup."Document Type"::"Purchase Order");
        //         DocApproval.SETRANGE("Sub Document Type", "Sub Document Type");
        //         DocApproval.SETFILTER("Document No", '%1', '');
        //         DocApproval.SETRANGE(Initiator, Initiator);
        //         IF DocApproval.FIND('-') THEN
        //             REPEAT
        //                 DocumentApproval.INIT;
        //                 DocumentApproval.COPY(DocApproval);
        //                 DocumentApproval."Document No" := "No.";
        //                 DocumentApproval.INSERT;
        //             UNTIL DocApproval.NEXT = 0;
        //     END;
        //     DocSetup.SETRANGE("Approval Required");
        //     IF DocSetup.FIND('-') THEN BEGIN
        //         POTermsCon.INIT;
        //         POTermsCon."Document Type" := "Document Type";
        //         POTermsCon."No." := "No.";
        //         POTermsCon."Sales Tax Comments" := DocSetup."Sales Tax Comments";
        //         POTermsCon."Excise Duty Comments" := DocSetup."Excise Duty Comments";
        //         POTermsCon."Terms of Payments" := DocSetup."Terms of Payments";
        //         POTermsCon."Service Tax" := DocSetup."Service Tax";
        //         POTermsCon."Transit Insurance" := DocSetup."Transit Insurance";
        //         POTermsCon."Inspection Remarks" := DocSetup."Inspection Remarks";
        //         POTermsCon."Packaging & Forwarding" := DocSetup."Packaging & Forwarding";
        //         POTermsCon."Price Basis" := DocSetup."Price Basis";
        //         POTermsCon."Freight Terms" := DocSetup."Freight Terms";
        //         POTermsCon."DD Comm/Bank Charges" := DocSetup."DD Comm/Bank Charges";
        //         POTermsCon."Warranty/Guarantee Terms" := DocSetup."Warranty/Guarantee Terms";
        //         POTermsCon.INSERT;
        //     END;
        //     //write here for purchaser Code
        //     IF DocSetup."Indent Required" THEN
        //         "Purchaser Code" := USERID;
        // END;

        // IF "Document Type" = "Document Type"::Invoice THEN BEGIN
        //     DocSetup.RESET;
        //     DocSetup.SETRANGE("Document Type", DocSetup."Document Type"::Invoice);
        //     DocSetup.SETRANGE("Sub Document Type", "Sub Document Type");
        //     DocSetup.SETRANGE("Approval Required", TRUE);
        //     IF DocSetup.FIND('-') THEN BEGIN
        //         DocInitiator.GET(DocSetup."Document Type"::Invoice, "Sub Document Type", Initiator);
        //         DocApproval.RESET;
        //         DocApproval.SETRANGE("Document Type", DocSetup."Document Type"::Invoice);
        //         DocApproval.SETRANGE("Sub Document Type", "Sub Document Type");
        //         DocApproval.SETFILTER("Document No", '%1', '');
        //         DocApproval.SETRANGE(Initiator, Initiator);
        //         IF DocApproval.FIND('-') THEN
        //             REPEAT
        //                 DocumentApproval.INIT;
        //                 DocumentApproval.COPY(DocApproval);
        //                 DocumentApproval."Document No" := "No.";
        //                 DocumentApproval.INSERT;
        //             UNTIL DocApproval.NEXT = 0;
        //     END;
        // END;
        // //NDALLE 261107
        // IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
        //     DocSetup.RESET;
        //     DocSetup.SETRANGE("Document Type", DocSetup."Document Type"::"Debit Note");
        //     DocSetup.SETRANGE("Sub Document Type", "Sub Document Type");
        //     DocSetup.SETRANGE("Approval Required", TRUE);
        //     IF DocSetup.FIND('-') THEN BEGIN
        //         DocInitiator.GET(DocSetup."Document Type"::"Debit Note", "Sub Document Type", Initiator);
        //         DocApproval.RESET;
        //         DocApproval.SETRANGE("Document Type", DocSetup."Document Type"::"Debit Note");
        //         DocApproval.SETRANGE("Sub Document Type", "Sub Document Type");
        //         DocApproval.SETFILTER("Document No", '%1', '');
        //         DocApproval.SETRANGE(Initiator, Initiator);
        //         IF DocApproval.FIND('-') THEN
        //             REPEAT
        //                 DocumentApproval.INIT;
        //                 DocumentApproval.COPY(DocApproval);
        //                 DocumentApproval."Document No" := "No.";
        //                 DocumentApproval.INSERT;
        //             UNTIL DocApproval.NEXT = 0;
        //     END
        // END;
        // IF "Document Type" = "Document Type"::Quote THEN BEGIN
        //     DocSetup.RESET;
        //     DocSetup.SETRANGE("Document Type", DocSetup."Document Type"::"Purchase Order");
        //     DocSetup.SETRANGE("Sub Document Type", DocSetup."Sub Document Type"::Quote);
        //     DocSetup.SETRANGE("Approval Required", TRUE);
        //     IF DocSetup.FIND('-') THEN BEGIN
        //         DocInitiator.GET(DocSetup."Document Type"::"Purchase Order", DocSetup."Sub Document Type"::Quote, Initiator);
        //         DocApproval.RESET;
        //         DocApproval.SETRANGE("Document Type", DocSetup."Document Type"::"Purchase Order");
        //         DocApproval.SETRANGE("Sub Document Type", DocSetup."Sub Document Type"::Quote);
        //         DocApproval.SETFILTER("Document No", '%1', '');
        //         DocApproval.SETRANGE(Initiator, Initiator);
        //         IF DocApproval.FIND('-') THEN BEGIN
        //             REPEAT
        //                 DocumentApproval.INIT;
        //                 DocumentApproval.COPY(DocApproval);
        //                 DocumentApproval."Document No" := "No.";
        //                 DocumentApproval.INSERT;
        //             UNTIL DocApproval.NEXT = 0;
        //         END
        //     END
        // END;
        //        }
        IF "Document Type" = "Document Type"::Order THEN BEGIN
            "Order Ref. No." := "No.";
            GLBudgetName.RESET;
            GLBudgetName.SETRANGE("Project Budget", TRUE);
        END;
        IF RecUserSetup.GET("User ID") THEN
            IF RecRespCenter.GET(RecUserSetup."Purchase Resp. Ctr. Filter") THEN BEGIN
                "Shortcut Dimension 1 Code" := RecRespCenter."Global Dimension 1 Code";
                "Location Code" := RecRespCenter."Global Dimension 1 Code";
                //IF "Sub Document Type" = "Sub Document Type" :: "WO-NICB" THEN
                //VALIDATE("Job No.",RecRespCenter."Job Code");
                "Job No." := RecRespCenter."Global Dimension 1 Code";
            END;
        //          {
        //        //For Inserting Template in wo ALLEAB Dt 030308
        //        IF "Sub Document Type" = "Sub Document Type"::"WO-NICB" THEN BEGIN
        //     lno := 0;
        //     STTEXTRec.RESET;
        //     STTEXTRec.SETRANGE("Term Type", STTEXTRec."Term Type"::"Template-1");
        //     IF STTEXTRec.FINDFIRST THEN
        //         REPEAT
        //             lno := lno + 10000;
        //             TermsRec.RESET;
        //             TermsRec.INIT;
        //             TermsRec."Document Type" := TermsRec."Document Type"::Order;
        //             TermsRec."Document No." := "No.";
        //             TermsRec."Term Type" := TermsRec."Term Type"::"Template-1";
        //             TermsRec."Line No." := lno;
        //             TermsRec.Narration := STTEXTRec.Description;
        //             TermsRec.INSERT;
        //         UNTIL STTEXTRec.NEXT = 0;
        // END;
        //        }
    end;

    PROCEDURE CloseOrder(Selection: Integer);
    VAR
        PurchaseHeader: Record "Purchase Header";
        TEXT0001: Label '&Cancel, &Short Close, Com&plete';
        PurchLine: Record "Purchase Line";
        SelectionText: Option " ",Cancel,"Short Close",Complete;
        DisplayError: Boolean;
    BEGIN

        //Alle-AYN-250505: >>
        IF Selection = 3 THEN
            ERROR('You can only short close.');
        PurchLine.RESET;
        PurchLine.SETFILTER(PurchLine."Document Type", '%1', "Document Type");
        PurchLine.SETRANGE(PurchLine."Document No.", "No.");
        IF PurchLine.FIND('-') THEN BEGIN
            DisplayError := FALSE;
            REPEAT
                IF (Selection = 1) THEN BEGIN //Cancel
                    IF (PurchLine."Outstanding Quantity" <> PurchLine.Quantity) THEN
                        DisplayError := TRUE
                    ELSE BEGIN
                        PurchLine."Indent No" := '';
                        PurchLine."Indent Line No" := 0;
                        PurchLine.MODIFY;
                    END;

                END
                ELSE IF (Selection = 2) THEN BEGIN  //Short Close
                                                    //IF (PurchLine."Quantity Received" = 0) THEN
                                                    //  ERROR('Order cannot be Short Closed as no quantity has been posted.')
                                                    //ELSE IF (PurchLine."Quantity Received" = PurchLine.Quantity) THEN
                                                    //  ERROR('Order cannot be Short Closed as all quantity has been received.')
                                                    //ELSE IF (PurchLine."Quantity Invoiced" = PurchLine.Quantity) THEN
                                                    //  ERROR('Order cannot be Short Closed as all quantity has been invoiced.')

                    IF (PurchLine."Quantity Received" <> PurchLine."Quantity Invoiced") THEN
                        DisplayError := TRUE
                    ELSE BEGIN
                        PurchLine.SuspendStatusCheck(TRUE);
                        //PurchLine.VALIDATE(Quantity,PurchLine.Quantity-PurchLine."Quantity Received");
                        PurchLine.VALIDATE(Quantity, PurchLine."Quantity Received");
                        PurchLine.MODIFY;
                    END;

                END;
            // {
            // ELSE IF (Selection = 3) THEN BEGIN  //Close
            //             IF (PurchLine."Quantity Invoiced" <> PurchLine.Quantity) THEN
            //                 ERROR('Order cannot be Completed as some quantity is pending to be invoiced.');

            //         END;
            // }
            UNTIL PurchLine.NEXT = 0;

            IF (Selection = 1) AND (DisplayError) THEN
                ERROR('Order cannot be Cancelled as some quantity has already Recieved.');
            IF (Selection = 2) AND (DisplayError) THEN
                ERROR('Order cannot be Short Closed as quantity received has not been invoiced.');

            SelectionText := Selection;
            IF CONFIRM(Text500, FALSE, SelectionText) THEN BEGIN
                "Order Status" := Selection;
                MODIFY;
            END
            ELSE
                ERROR('');

        END;

        IF Rec."Buy-from Vendor No." = '' THEN BEGIN
            SelectionText := Selection;
            IF CONFIRM(Text500, FALSE, SelectionText) THEN BEGIN
                "Order Status" := Selection;
                MODIFY;
            END
            ELSE
                ERROR('');

        END;

        //Alle-AYN-250505: <<
    END;

    PROCEDURE FillJobBudgetLines(VAR JobTask: Record "Job Task"; PPOHeader: Record "Purchase Header");
    VAR
        VLineNo: Integer;
        PurchaseHdr: Record "Purchase Header";
        JobLedgEntry: Record "Job Ledger Entry";
        PresentQty: Decimal;
        POLineRec: Record "Purchase Line";
        JobSetup: Record "Jobs Setup";
        JobLedgerentry: Record "Job Ledger Entry";
        "JLE InvQty": Decimal;
        DocSetup: Record "Document Type Setup";
        CostCenter: Code[20];
        JobPlanningLine: Record "Job Planning Line";
    BEGIN
        //ALLEAA BCL0016 14-10-2008 Start:
        VLineNo := 0;
        POLineRec.RESET;
        POLineRec.SETRANGE("Document Type", PPOHeader."Document Type");
        POLineRec.SETRANGE("Document No.", PPOHeader."No.");
        IF POLineRec.FIND('+') THEN
            VLineNo := POLineRec."Line No.";

        IF JobTask.FIND('-') THEN
            REPEAT
                QtyZero := TRUE;
                CostZero := TRUE;
                VLineNo := VLineNo + 10000;
                PresentQty := 0;
                POLineRec.INIT;
                POLineRec."Document Type" := PPOHeader."Document Type";
                POLineRec."Document No." := PPOHeader."No.";
                POLineRec."Line No." := VLineNo;
                POLineRec.INSERT;

                JobPlanningLine.RESET;
                JobPlanningLine.SETRANGE(JobPlanningLine."Job No.", JobTask."Job No.");
                JobPlanningLine.SETRANGE(JobPlanningLine."Job Task No.", JobTask."Job Task No.");
                IF JobPlanningLine.FINDFIRST THEN BEGIN
                    IF JobTask."This Bill Qty." <> 0 THEN BEGIN
                        QtyZero := FALSE;
                        JobLedgEntry.RESET;
                        JobLedgEntry.SETCURRENTKEY("Job No.", "Job Task No.", Type, "No.", "Posting Date", "Variant Code", "Entry Type");
                        JobLedgEntry.SETRANGE("Job No.", JobPlanningLine."Job No.");
                        JobLedgEntry.SETRANGE("Job Task No.", JobPlanningLine."Job Task No.");
                        JobLedgEntry.SETRANGE("Job Contract Entry No.", JobPlanningLine."Job Contract Entry No.");
                        IF JobLedgEntry.FIND('-') THEN
                            REPEAT
                                PresentQty += JobLedgEntry.Quantity;
                            UNTIL JobLedgEntry.NEXT = 0;

                        IF (JobPlanningLine.Type = JobPlanningLine.Type::"G/L Account") OR
                          (JobPlanningLine.Type = JobPlanningLine.Type::"Group (Resource)") THEN
                            IF (JobPlanningLine.Type = JobPlanningLine.Type::"G/L Account") THEN
                                POLineRec.VALIDATE(Type, POLineRec.Type::"G/L Account")
                            ELSE
                                POLineRec.VALIDATE(Type, POLineRec.Type::" ")
                        ELSE
                            ERROR(Text50000);

                        POLineRec.VALIDATE("No.", JobPlanningLine."No.");
                        POLineRec.VALIDATE("Location Code", PPOHeader."Location Code");

                        IF NOT (POLineRec.Type = POLineRec.Type::" ") THEN BEGIN
                            IF POLineRec.Type = POLineRec.Type::"G/L Account" THEN BEGIN
                                PurchHeader.GET("Document Type"::Order, "No.");
                                IF PurchHeader."Buy-from Vendor No." <> '' THEN BEGIN
                                    POLineRec.VALIDATE("No.", JobPlanningLine."G/L Account");
                                    DocSetup.RESET;
                                    DocSetup.SETRANGE("Document Type", DocSetup."Document Type"::"Purchase Order");
                                    DocSetup.SETRANGE("Sub Document Type", "Sub Document Type");
                                    IF DocSetup.FIND('-') THEN
                                        IF DocSetup."Def. Gen Prod Posting Group" <> '' THEN
                                            POLineRec."Gen. Prod. Posting Group" := DocSetup."Def. Gen Prod Posting Group";
                                END;
                            END;

                            POLineRec."Qty Since Last Bill" := CalculatePreviousQty(PPOHeader."Last RA Bill No.", JobTask."Job No.",
                              JobTask."Entry No.");
                            JobTask.CALCFIELDS(Quantity);
                            JobTask.TESTFIELD(Quantity);

                            //          "JLE InvQty" := 0;
                            //          JobLedgerentry.RESET;
                            //          JobLedgerentry.SETCURRENTKEY("Job No.","Job Task No.",Type,"No.","Posting Date","Variant Code","Entry Type");
                            //          JobLedgerentry.SETFILTER("Job Task No.",JobPlanningLine."Job Task No.");
                            //          IF JobLedgerentry.FIND('-') THEN
                            //            REPEAT
                            //              "JLE InvQty" += ABS(JobLedgerentry.Quantity);
                            //            UNTIL JobLedgerentry.NEXT=0;
                            POLineRec.VALIDATE("Unit of Measure Code", JobPlanningLine."Unit of Measure Code");
                            POLineRec.VALIDATE(Quantity, JobTask."This Bill Qty.");
                            POLineRec.VALIDATE("Direct Unit Cost", JobPlanningLine."Direct Unit Cost (LCY)");
                            POLineRec."Job Contract Entry No." := JobPlanningLine."Job Contract Entry No.";
                            POLineRec."BOQ Quantity" := JobPlanningLine.Quantity;
                            POLineRec.VALIDATE("Job No.", JobTask."Job No.");
                            POLineRec.VALIDATE("Job Task No.", JobTask."Job Task No.");
                        END;
                    END;
                END;

                JobPlanningLine.RESET;
                JobPlanningLine.SETRANGE(JobPlanningLine."Job No.", JobTask."Job No.");
                JobPlanningLine.SETRANGE(JobPlanningLine."Job Task No.", JobTask."Job Task No.");
                IF JobPlanningLine.FINDFIRST THEN BEGIN
                    IF JobPlanningLine."Unit Cost" <> 0 THEN
                        CostZero := FALSE;
                END;

                IF QtyZero AND NOT CostZero AND (JobTask."Non Schedule" = FALSE) THEN
                    JobTask.TESTFIELD("Rate Only", TRUE);
                IF QtyZero AND CostZero THEN BEGIN
                    JobTask.TESTFIELD("Non Schedule", FALSE);
                    JobTask.TESTFIELD("This Bill Qty.", 0);
                END;

                POLineRec.VALIDATE("Entry No.", JobTask."Entry No.");
                POLineRec."Job No." := JobTask."Job No.";
                //    POLineRec."Project Code" := JobTask."Job No.";
                POLineRec."BOQ Code" := JobTask."BOQ Code";
                POLineRec.Description := JobTask.Description;
                //    POLineRec."Description 2" := JobTask."Phase Desc";
                POLineRec.VALIDATE("Shortcut Dimension 1 Code", PPOHeader."Shortcut Dimension 1 Code");
                POLineRec.VALIDATE("Shortcut Dimension 2 Code", JobPlanningLine."Shortcut Dimension 2 Code");
                POLineRec.VALIDATE(Amount, POLineRec."Line Amount");
                POLineRec.MODIFY;
                PPOHeader.MODIFY;
            UNTIL JobTask.NEXT = 0;

        //ALLEAA BCL0016 14-10-2008 End:
    END;

    PROCEDURE CalculatePreviousQty(pRABillNo: Code[20]; pProjectCode: Code[20]; pEntryNo: Integer) PreviousQty: Decimal;
    VAR
        PurchaseInvHdr: Record "Purch. Inv. Header";
        PurchaseInvLine: Record "Purch. Inv. Line";
    BEGIN
        IF PurchaseInvHdr.GET(pRABillNo) THEN BEGIN
            PurchaseInvLine.RESET;
            PurchaseInvLine.SETRANGE("Document No.", PurchaseInvHdr."No.");
            PurchaseInvLine.SETRANGE("Project Code", pProjectCode);
            PurchaseInvLine.SETRANGE("Entry No.", pEntryNo);
            IF PurchaseInvLine.FIND('-') THEN
                PreviousQty += PurchaseInvLine.Quantity;
            CalculatePreviousQty(PurchaseInvHdr."Last RA Bill No.", PurchaseInvLine."Job No.", PurchaseInvLine."Entry No.");
        END;
    END;


    PROCEDURE FillGateEntryLines(VAR PostedGateEntryLine2: Record "Posted Gate Entry Line"; PurchaseInvoiceNo: Code[20])// 16556;
    BEGIN
        IF PostedGateEntryLine2.FINDSET THEN
            REPEAT
                GateEntryAttachment.INIT;
                GateEntryAttachment."Source Type" := PostedGateEntryLine2."Source Type";
                GateEntryAttachment."Source No." := PostedGateEntryLine2."Source No.";
                GateEntryAttachment."Entry Type" := PostedGateEntryLine2."Entry Type";
                GateEntryAttachment."Gate Entry No." := PostedGateEntryLine2."Gate Entry No.";
                GateEntryAttachment."Line No." := PostedGateEntryLine2."Line No.";
                GateEntryAttachment."Purchase Invoice No." := PurchaseInvoiceNo;
                GateEntryAttachment.INSERT;
            UNTIL PostedGateEntryLine2.NEXT = 0;
    END;

    PROCEDURE GetJobBudgetLines();
    VAR
        Pldr: Record "Purchase Header";
        JobBudgetLine: Record "Job Task";
    BEGIN
        //ALLEAA BCL0016 14-10-2008 Start:
        TESTFIELD("Job No.");
        Pldr.GET("Document Type", "No.");

        JobBudgetLine.RESET;
        JobBudgetLine.FILTERGROUP := 2;
        JobBudgetLine.SETRANGE("Job No.", "Job No.");
        //JobBudgetLine.SETFILTER(Type,'%1|%2',JobBudgetLine.Type::"G/L Account",JobBudgetLine.Type::"Group (Resource)");
        //JobBudgetLine.SETRANGE("Line Type",JobBudgetLine."Line Type"::Schedule);
        //JobBudgetLine.SETRANGE("BOQ Type",JobBudgetLine."BOQ Type"::Purchase);//ALLERP Bugfix
        JobBudgetLine.FILTERGROUP := 0;

        // ALLE MM Code Commented as Page 216 is not existing in NAV
        //   {
        //   IF JobBudgetLine.FIND('-') THEN BEGIN
        //         CLEAR(JobBudgetLineForm);
        //         JobBudgetLineForm.SETTABLEVIEW(JobBudgetLine);
        //         JobBudgetLineForm.LOOKUPMODE := TRUE;
        //         JobBudgetLineForm.SetPOHeader(Pldr);
        //         JobBudgetLineForm.SetPOMode(TRUE);
        //         JobBudgetLineForm.RUNMODAL;
        //     END;
        //   }
        // ALLE MM Code Commented as Page 216 is not existing in NAV
        //ALLEAA BCL0016 14-10-2008 End:
    END;

    PROCEDURE ShowDeliveryShedule();
    VAR
        PurchaseLineRec: Record "Purchase Line";
        PurchLineForm: Page "Certificate Print";
    BEGIN
        TESTFIELD("No.");
        PurchaseLineRec.SETRANGE("Document Type", "Document Type");
        PurchaseLineRec.SETRANGE("Document No.", "No.");
        PurchLineForm.SETTABLEVIEW(PurchaseLineRec);
        PurchLineForm.RUNMODAL;
    END;

    PROCEDURE CreateDocument(pDocumentType: Option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order"; pSubDocumentType: Option " ",FA,Regular,Direct,WorkOrder,Inward,Outward);
    VAR
        Selection: Integer;
        DocumentMgmt: Codeunit "Document Managment";
    BEGIN
        CASE pDocumentType OF
            pDocumentType::Quote:
                BEGIN
                    IF pSubDocumentType = pSubDocumentType::Regular THEN
                        DocumentMgmt.CreatePurchaseQuote(TRUE, Rec)
                    ELSE IF pSubDocumentType = pSubDocumentType::WorkOrder THEN
                        DocumentMgmt.CreatePurchaseQuoteService(TRUE, Rec);
                END;

            pDocumentType::Order:
                BEGIN
                    IF pSubDocumentType = pSubDocumentType::Direct THEN
                        DocumentMgmt.CreatePurchaseOrderDirect(TRUE, Rec)
                    ELSE IF pSubDocumentType = pSubDocumentType::WorkOrder THEN
                        DocumentMgmt.CreatePurchaseOrderService(TRUE, Rec);
                END;

            pDocumentType::Invoice:
                BEGIN
                    IF pSubDocumentType = pSubDocumentType::" " THEN
                        DocumentMgmt.CreatePurchaseInvoice(TRUE, Rec)
                    ELSE IF pSubDocumentType = pSubDocumentType::WorkOrder THEN
                        DocumentMgmt.CreatePurchaseInvoiceService(TRUE, Rec);
                END;

            pDocumentType::"Credit Memo":
                BEGIN
                    IF pSubDocumentType = pSubDocumentType::" " THEN BEGIN
                        Selection := STRMENU(Text50001);
                        IF Selection = 0 THEN
                            EXIT;
                        IF Selection = 1 THEN
                            DocumentMgmt.CreatePurchaseCreditMemo(TRUE, Rec)
                        ELSE
                            DocumentMgmt.CreatePurchaseCrMemoWithExcise(TRUE, Rec)
                    END ELSE IF pSubDocumentType = pSubDocumentType::WorkOrder THEN
                            DocumentMgmt.CreatePurchaseCreditMemoService(TRUE, Rec);
                END;
        END;
    END;

    PROCEDURE CheckBeforeRelease()
    VAR
        PaymentTermLine: Record "Payment Terms Line";
        PurchHeaderQtChck: Record "Purchase Header";
    BEGIN
        CheckDimension;

        TESTFIELD("Buy-from Vendor No.");
        TESTFIELD("Pay-to Vendor No.");
        IF NOT ("Document Type" IN ["Document Type"::"Blanket Order", "Document Type"::Quote]) THEN
            TESTFIELD("Posting Date");
        TESTFIELD("Document Date");
        CheckDimension;

        IF ("Document Type" IN ["Document Type"::Order, "Document Type"::Invoice]) THEN BEGIN
            WorkFlowDocTypSetup.GET(4, "Document Type", "Workflow Sub Document Type");
            IF WorkFlowDocTypSetup."Milestone Mandatory" THEN BEGIN
                PaymentTermLine.RESET;
                PaymentTermLine.SETRANGE("Document Type", "Document Type");
                PaymentTermLine.SETRANGE("Document No.", "No.");
                IF PaymentTermLine.FINDSET THEN BEGIN
                    REPEAT
                        PaymentTermLine.TESTFIELD("Calculation Value");
                    UNTIL PaymentTermLine.NEXT = 0;
                    IF PaymentTermLine.FINDSET THEN
                        IF PaymentTermLine."Payment Type" = PaymentTermLine."Payment Type"::Advance THEN
                            PaymentTermLine.FIELDERROR("Payment Type");
                END ELSE
                    ERROR('Payment Milestones not defined !');
            END;
        END;

        //ALLE ANSH NTPC Start
        IF "Document Type" = "Document Type"::Quote THEN BEGIN
            //EPC2016Upgrade
            //TESTFIELD("Assigned User ID",USERID);
            TESTFIELD("Document Type", "Document Type"::Quote);
            //EPC2016Upgrade
            TESTFIELD("Order Date");
            TESTFIELD("Expected Receipt Date");
            //  TESTFIELD("Quote Converted to Order",FALSE);
            // ALLE ANSH NTPC Start

            PurchHeaderQtChck.RESET;
            PurchHeaderQtChck.SETRANGE("Document Type", "Document Type");
            PurchHeaderQtChck.SETFILTER("No.", '<>%1', "No.");
            PurchHeaderQtChck.SETRANGE("Buy-from Vendor No.", "Buy-from Vendor No.");
            PurchHeaderQtChck.SETRANGE("Indent No.", "Indent No.");
            IF PurchHeaderQtChck.FINDFIRST THEN
                ERROR('Same Quotation has already been creted for order no %1 Vendor no %2 and Indent no %3', PurchHeaderQtChck."No.", PurchHeaderQtChck."Buy-from Vendor No.", PurchHeaderQtChck."Indent No.");


            //ALLE TS 02032017
            IF "No." <> '' THEN BEGIN
                PurchLine.RESET;
                PurchLine.SETRANGE("Document Type", "Document Type");
                PurchLine.SETRANGE("Document No.", "No.");
                IF PurchLine.FINDSET THEN
                    REPEAT
                        IF PurchLine."Currency Code" <> "Currency Code" THEN
                            ERROR('Currency Code must be same as %1 in Purchase Line', "Currency Code");
                    UNTIL PurchLine.NEXT = 0;
            END;
            //ALLE TS 02032017
        END;
        //ALLE ANSH NTPC End

        PurchSetup.GET;
        FASetup.GET;
        PurchLine.RESET;
        PurchLine.SETFILTER("Document Type", '%1|%2', "Document Type"::"Return Order", "Document Type"::"Credit Memo");
        PurchLine.SETRANGE("Document No.", "No.");
        PurchLine.SETRANGE(Type, PurchLine.Type::Item);
        IF PurchLine.FIND('-') THEN
            REPEAT
                //IF RecRespCenter."Job No. Mandatory" THEN BEGIN
                // PurchLine.TESTFIELD("Job No.");
                //PurchLine.TESTFIELD("Job Task No.");
                //END;
                IF PurchSetup."Exact Cost Reversing Mandatory" THEN
                    PurchLine.TESTFIELD("Appl.-to Item Entry")
UNTIL PurchLine.NEXT = 0;

        IF "Document Type" = "Document Type"::Order THEN BEGIN
            //  TESTFIELD("Starting Date");
            //TESTFIELD("Billing Location");
            IF "Workflow Sub Document Type" = "Workflow Sub Document Type"::Regular THEN BEGIN
                PurchLine.RESET;
                PurchLine.SETRANGE("Document Type", "Document Type");
                PurchLine.SETRANGE("Document No.", "No.");
                PurchLine.SETFILTER(Type, '%1|%2|%3', PurchLine.Type::Item, PurchLine.Type::"G/L Account", PurchLine.Type::"Fixed Asset");
                PurchLine.SETFILTER("Line Amount", '>0');
                IF PurchLine.FIND('-') THEN
                    REPEAT
                        PurchLine.TESTFIELD("Indent Line No");
                        PurchLine.TESTFIELD("Indent No");
                        //PurchLine.CheckIndentQuanity;
                        IF PurchLine."Quantity Received" = 0 THEN
                            PurchLine.TESTFIELD("Outstanding Quantity");
                    UNTIL PurchLine.NEXT = 0;
            END;
            //CheckLineWiseCost;//ALLE TS
        END;

        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type", "Document Type");
        PurchLine.SETRANGE("Document No.", "No.");
        PurchLine.SETFILTER(Type, '%1|%2|%3|%4', PurchLine.Type::Item, PurchLine.Type::"G/L Account", PurchLine.Type::"Charge (Item)", PurchLine.Type::"Fixed Asset");
        IF PurchLine.FIND('-') THEN
            REPEAT
                //PurchLine.CheckIndentQuanity;
                PurchLine.TESTFIELD("Gen. Prod. Posting Group");
                PurchLine.TESTFIELD("Gen. Bus. Posting Group");
                //IF  PurchLine."Parallel Unit of Measure Code" <> '' THEN
                //PurchLine.TESTFIELD("Per PUOM Direct Unit Cost")
                //ELSE
                PurchLine.TESTFIELD("Direct Unit Cost");

                PurchLine.TESTFIELD("Shortcut Dimension 1 Code");
                PurchLine.TESTFIELD("Shortcut Dimension 2 Code");
                IF PurchLine.Type = PurchLine.Type::Item THEN
                    PurchLine.TESTFIELD("Unit of Measure Code");

                IF NOT (PurchLine.Type IN [PurchLine.Type::"Charge (Item)", PurchLine.Type::"Fixed Asset"]) THEN BEGIN
                    PurchLine.TESTFIELD("Unit of Measure Code");
                    PurchLine.TESTFIELD("Location Code");
                    //PurchLine.TESTFIELD("Job No.");
                    //PurchLine.TESTFIELD("Job Task No.");
                END;
                IF PurchLine.Type = PurchLine.Type::"Fixed Asset" THEN BEGIN
                    PurchLine.TESTFIELD("Job No.", '');
                    PurchLine.TESTFIELD("Job Task No.", '');
                    PurchLine.TESTFIELD("Depreciation Book Code");
                    PurchLine.TESTFIELD("Duplicate in Depreciation Book");
                    IF PurchLine."Duplicate in Depreciation Book" = PurchLine."Depreciation Book Code" THEN
                        ERROR('%1 and %2 should not be same', PurchLine.FIELDCAPTION("Depreciation Book Code"), PurchLine.FIELDCAPTION("Duplicate in Depreciation Book"));
                    //IF FASetup."Salvage Value Mandatory" THEN BEGIN
                    //PurchLine.TESTFIELD("Salvage Value");
                    //IF PurchLine."Salvage Value" >= 0 THEN
                    // ERROR('%1 must have a valid value in %2 %3',PurchLine.FIELDCAPTION("Salvage Value"),PurchLine.FIELDCAPTION("Document No."),PurchLine.FIELDCAPTION("Line No."));
                    //  END;
                END;
            UNTIL PurchLine.NEXT = 0;

        IF "Document Type" = "Document Type"::Invoice THEN BEGIN
            PurchSetup.GET;
            IF PurchSetup."Ext. Doc. No. Mandatory" THEN
                TESTFIELD("Vendor Invoice No.");
            TESTFIELD("Received Invoice Amount");
            //IF "Order No."<>'' THEN BEGIN
            // IF PurchaseHeader2.GET("Document Type"::Order,"Order No.") THEN
            // PurchaseHeader2.TESTFIELD(Status,Status::Released);
            //END;



            WorkFlowDocTypSetup.GET(4, "Document Type", "Workflow Sub Document Type");
            // {
            // IF WorkFlowDocTypSetup."Milestone Mandatory" THEN BEGIN
            //         PaymentTermsLine.RESET;
            //         PaymentTermsLine.SETRANGE("Table ID", DATABASE::"Purchase Header");
            //         PaymentTermsLine.SETRANGE("Document Type", "Document Type");
            //         PaymentTermsLine.SETRANGE("Document No.", "No.");
            //         PaymentTermsLine.SETRANGE("Doc. No. Occurrence", "Doc. No. Occurrence");
            //         PaymentTermsLine.SETRANGE("Version No.", 0);
            //         IF PaymentTermsLine.FIND('-') THEN
            //             REPEAT
            //                 PaymentTermsLine.TESTFIELD(Amount);
            //             UNTIL PaymentTermsLine.NEXT = 0
            //         ELSE
            //             ERROR('Payment Milestones not defined !');

            //         IF ("Applies-to Doc. No." <> '') AND ("Applies-to ID" <> '') THEN
            //             ERROR('Applies-to Doc. No. and Applies-to ID cannot be filled together.');
            //         OldVendLedgEntry.RESET;
            //         OldVendLedgEntry.SETCURRENTKEY("External Document No.", "Document Type", "Vendor No.");
            //         OldVendLedgEntry.SETRANGE("External Document No.", "Vendor Invoice No.");
            //         OldVendLedgEntry.SETRANGE("Document Type", OldVendLedgEntry."Document Type"::Invoice);
            //         OldVendLedgEntry.SETRANGE("Vendor No.", "Pay-to Vendor No.");
            //         IF OldVendLedgEntry.FIND('-') THEN
            //             ERROR('Vendor Invoice No. %1 already exists.', "Vendor Invoice No.");

            //         WorkFlowDocTypSetup.GET(4, "Document Type", "Workflow Sub Document Type");
            //         IF WorkFlowDocTypSetup."Job Allocation Required" THEN BEGIN
            //             JobAllocationReq := FALSE;
            //             IF "Document Type" = "Document Type"::Invoice THEN BEGIN
            //                 JobAllocation.RESET;
            //                 JobAllocation.SETRANGE("Document Type", "Document Type");
            //                 JobAllocation.SETRANGE("Document No.", "No.");
            //                 IF JobAllocation.FIND('-') THEN BEGIN
            //                     JobAllocationReq := TRUE;
            //                     PurchLine.RESET;
            //                     PurchLine.SETRANGE("Document Type", "Document Type");
            //                     PurchLine.SETRANGE("Document No.", "No.");
            //                     PurchLine.SETRANGE(Type, PurchLine.Type::"G/L Account");
            //                     PurchLine.SETFILTER(Amount, '<>0');
            //                     IF PurchLine.FIND('-') THEN
            //                         REPEAT
            //                             JobAmt := 0;
            //                             JobAllocation.RESET;
            //                             JobAllocation.SETRANGE("Document Type", "Document Type");
            //                             JobAllocation.SETRANGE("Document No.", "No.");
            //                             JobAllocation.SETRANGE("Line No.", PurchLine."Line No.");
            //                             IF JobAllocation.FIND('-') THEN
            //                                 REPEAT
            //                                     JobAllocation.TESTFIELD("GL Account No.");
            //                                     JobAllocation.TESTFIELD("Shortcut Dimension 1 Code");
            //                                     IF ClientMgmt.Dimension2CodeMandatory THEN
            //                                         JobAllocation.TESTFIELD("Shortcut Dimension 2 Code");

            //                                     JobAmt := JobAmt + JobAllocation.Amount;
            //                                 UNTIL JobAllocation.NEXT = 0;
            //                             IF JobAmt <> PurchLine."Line Amount" THEN
            //                                 ERROR('Job Allocation Amount and Line Amount does not match,' +
            //                                     'Job Allocation Amount = %1 and Line amount = %2', JobAmt, PurchLine."Line Amount");
            //                         UNTIL PurchLine.NEXT = 0;
            //                 END ELSE
            //                     ERROR('Job Allocation is missing.');
            //             END;
            //         END;
            //     END;
            // }
        END;
    END;

    PROCEDURE CheckDimension();
    VAR
        DimSetEntry: Record "Dimension Set Entry";
    BEGIN
        TESTFIELD("Shortcut Dimension 1 Code");
        //IF ClientMgmt.Dimension2CodeMandatory THEN
        // TESTFIELD("Shortcut Dimension 2 Code");
    END;

}