tableextension 50011 "BBG Sales Header Ext" extends "Sales Header"
{
    fields
    {
        // Add changes to table fields here
        modify("Responsibility Center")
        {
            TableRelation = "Responsibility Center 1";
        }




        field(50005; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0024 06-09-2007';
            OptionCaption = ' ,Sent for Approval,Approved,Returned,Rejected';
            OptionMembers = " ","Sent for Approval",Approved,Returned,Rejected;

            trigger OnValidate()
            begin
                //ALLESP BCL0024 06-09-2007 Start:
                SalesLine.RESET;
                SalesLine.SETRANGE("Document Type", "Document Type");
                SalesLine.SETRANGE("Document No.", "No.");
                IF SalesLine.FIND('-') THEN
                    REPEAT
                        SalesLine."Approval Status" := "Approval Status";
                        SalesLine.MODIFY;
                    UNTIL SalesLine.NEXT = 0;
                //ALLESP BCL0024 06-09-2007 End:
            end;
        }













        field(50019; Insurance; Text[1])
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00 240212';
        }
        field(50020; "Possession Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
        }
        field(50021; "Operation Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
        }



        field(50028; "Old Sales Order"; Boolean)
        {
            DataClassification = ToBeClassified;
        }










        field(60011; "Related Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            TableRelation = Vendor."No.";// WHERE("Vendor Type" = CONST("Customer(ROI)"));

            trigger OnValidate()
            begin
                //dds
                PaymentTermLine.SETRANGE("Project Code", "Job No.");
                PaymentTermLine.SETRANGE("Document Type", "Document Type");
                PaymentTermLine.SETRANGE("Document No.", "No.");

                IF PaymentTermLine.FIND('-') THEN
                    REPEAT
                        PaymentTermLine."Related Vendor No." := "Related Vendor No.";
                        PaymentTermLine.MODIFY;
                    UNTIL PaymentTermLine.NEXT = 0;
                //dds
            end;
        }


        field(90011; "Sub Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = "Dimension Value".Code WHERE(Code = FILTER('PROJECT BLOCK'),
                                                          "LINK to Region Dim" = FIELD("Project Code"));
        }


        field(90052; "Completed All Stages"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 to link PO with Payment Stages--JPL';
            Editable = false;
        }
        field(90053; "Blanket Order Ref No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 to link PO with Payment Stages--JPL';
        }

        field(90057; "Order Value"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Line Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                "Document No." = FIELD("No.")));
            Description = 'ALLERE';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90058; "Sales Booked Amt"; Decimal)
        {
            CalcFormula = Sum("Payment Terms Line Sale"."Due Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                            "Document No." = FIELD("No."),
                                                                            "Payment Type" = FILTER(<> ROI),
                                                                            "Due Date" = FIELD("Due Date Filter")));
            Description = 'ALLERE';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90059; "Received Amt"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Entry Type" = FILTER("Initial Entry" | "Unrealized Loss" | "Unrealized Gain" | "Realized Loss" | "Realized Gain" | "Payment Discount" | "Payment Discount (VAT Excl.)" | "Payment Discount (VAT Adjustment)" | "Payment Tolerance" | "Payment Discount Tolerance" | "Payment Tolerance (VAT Excl.)" | "Payment Tolerance (VAT Adjustment)" | "Payment Discount Tolerance (VAT Excl.)" | "Payment Discount Tolerance (VAT Adjustment)"),
                                                                         "Order Ref No." = FIELD("No."),
                                                                         "Ref Document Type" = FIELD("Document Type"),
                                                                         "Document Type" = FILTER(Payment | Refund)));
            Description = 'ALLERE';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90060; "Brokerage Amt"; Decimal)
        {
            CalcFormula = Sum("Payment Terms Line Sale"."Brokerage Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                                  "Document No." = FIELD("No."),
                                                                                  "Payment Type" = FILTER(<> ROI)));
            Description = 'ALLERE';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90061; "Brokerage Paid Amt"; Decimal)
        {
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Posting Type" = FILTER(Running),
                                                                                  "Order Ref No." = FIELD("No."),
                                                                                  "Ref Document Type" = FILTER(Order),
                                                                                  "Document Type" = FILTER(Payment | Refund),
                                                                                  "Vendor No." = FIELD("Broker Code")));
            Description = 'ALLERE';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90065; "Due Date Filter"; Date)
        {
            Caption = 'Due Date Filter';
            Description = 'ALLERE';
            FieldClass = FlowFilter;
        }
        field(90066; "CO-Applicant Code 1"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                IF Customer.GET("CO-Applicant Code 1") THEN
                    "CO-Applicant Name 1" := Customer.Name
                ELSE
                    "CO-Applicant Name 1" := '';
            end;
        }
        field(90067; "CO-Applicant Name 1"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(90068; "CO-Applicant Code 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                IF Customer.GET("CO-Applicant Code 2") THEN
                    "CO-Applicant Name 2" := Customer.Name
                ELSE
                    "CO-Applicant Name 2" := '';
            end;
        }
        field(90069; "CO-Applicant Name 2"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(90070; "CO-Applicant Code 3"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                IF Customer.GET("CO-Applicant Code 3") THEN
                    "CO-Applicant Name 3" := Customer.Name
                ELSE
                    "CO-Applicant Name 3" := '';
            end;
        }
        field(90071; "CO-Applicant Name 3"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }



        field(90080; "Update Tax Base"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(90082; "User ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(90083; "New Customer"; Code[20])
        {
            Caption = 'New Customer';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(90084; "Transfered Order No."; Code[20])
        {
            Caption = 'Transfered Order No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90086; "Project Unit Code"; Code[20])
        {
            CalcFormula = Lookup("Sales Line"."No." WHERE("Document Type" = FIELD("Document Type"),
                                                         "Sell-to Customer No." = FIELD("Sell-to Customer No."),
                                                         "Document No." = FIELD("No."),
                                                         "Line No." = FILTER(10000)));
            Description = 'ALLEAA';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90087; "Transporter Address"; Text[40])
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00  030512';
        }
        field(90088; "Project Type"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            Editable = false;
        }
        field(90089; Duration; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            Editable = false;
        }
        field(90090; "Investment Frequency"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            Editable = false;
            OptionCaption = ' ,Monthly,Quarterly,Half Yearly,Annually';
            OptionMembers = " ",Monthly,Quarterly,"Half Yearly",Annually;
        }
        field(90091; "Bond Category"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            Editable = false;
            OptionMembers = "A Type","B Type";
        }
        field(90092; "With Cheque"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            Editable = false;
        }
        field(90093; "Scheme Code"; Code[5])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            Editable = false;
        }
        field(98500; "Date Received"; Date)
        {
            Caption = 'Date Received';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(98501; "Time Received"; Time)
        {
            Caption = 'Time Received';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(98502; "BizTalk Request for Sales Qte."; Boolean)
        {
            Caption = 'BizTalk Request for Sales Qte.';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(98503; "BizTalk Sales Order"; Boolean)
        {
            Caption = 'BizTalk Sales Order';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(98509; "Date Sent"; Date)
        {
            Caption = 'Date Sent';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(98510; "Time Sent"; Time)
        {
            Caption = 'Time Sent';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(98513; "BizTalk Sales Quote"; Boolean)
        {
            Caption = 'BizTalk Sales Quote';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(98514; "BizTalk Sales Order Cnfmn."; Boolean)
        {
            Caption = 'BizTalk Sales Order Cnfmn.';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(98518; "Customer Quote No."; Code[20])
        {
            Caption = 'Customer Quote No.';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(98519; "Customer Order No."; Code[20])
        {
            Caption = 'Customer Order No.';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(98521; "BizTalk Document Sent"; Boolean)
        {
            Caption = 'BizTalk Document Sent';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
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
        SLdr: Record "Sales Header";
        QtyZero: Boolean;
        CostZero: Boolean;
        JobplanningLine1: Record "Job Planning Line";
        FromBOMComp: Record "BOM Component";
        UOMMgt: Codeunit "Unit of Measure Management";
        Item: Record Item;
        RecUserSetup: Record "User Setup";
        RecRespCenter: Record "Responsibility Center 1";
        SHeadRec: Record "Sales Header";
        JobBudgetLine: Record "Job Task";
        SOLineRec: Record "Sales Line";
        Text50000: Label 'ENU=Only Type GL Account to be selected';
        JobSetup: Record "Jobs Setup";
        "JLE InvQty": Decimal;
        "Job Ledger entry": Record "Job Ledger Entry";
        PaymentTermLine: Record "Payment Terms Line Sale";
        ItemL: Record Item;
        Customer: Record Customer;
        GateEntryAttachment: Record "Gate Entry Attachment";// 16557;


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
        SalesSetup.GET;
        //JPL START
        Initiator := USERID;
        "Creation Date" := TODAY;
        "Creation Time" := TIME;
        //alleab

        //ALLEND 191107
        IF RecUserSetup.GET(USERID) THEN
            IF RecRespCenter.GET(RecUserSetup."Purchase Resp. Ctr. Filter") THEN BEGIN
                "Shortcut Dimension 1 Code" := RecRespCenter."Global Dimension 1 Code";
                "Location Code" := RecRespCenter."Location Code";
                "Job No." := RecRespCenter."Job Code";
                IF ("Invoice Type1" = "Invoice Type1"::RA) AND ("Client Bill Type" = "Client Bill Type"::Certified) THEN BEGIN
                    SHeadRec.RESET;
                    SHeadRec.SETRANGE("Document Type", SHeadRec."Document Type"::Invoice);
                    SHeadRec.SETRANGE("Invoice Type1", SHeadRec."Invoice Type1"::RA);
                    SHeadRec.SETRANGE("Client Bill Type", SHeadRec."Client Bill Type"::Certified);
                    SHeadRec.SETFILTER("Job No.", "Job No.");
                    IF SHeadRec.FINDFIRST THEN
                        ERROR('Please check there is already a unposted invoice with No. %1', SHeadRec."No.");
                END;
                "Responsibility Center" := RecRespCenter."Global Dimension 1 Code";
                "Project Code" := RecRespCenter."Global Dimension 1 Code";
            END;
        //ALLEND 191107
    end;


    PROCEDURE FillJobBudgetLines(VAR pJobBudgetLine: Record "Job Planning Line"; pSOHeader: Record "Sales Header");
    VAR
        vLineNo: Integer;
        SalesHdr: Record "Sales Header";
        JobLedgEntry: Record "Job Ledger Entry";
        PresentQty: Decimal;
    BEGIN
        //ALLESP BCL0016 16-07-2007 Start:
        vLineNo := 0;
        SOLineRec.RESET;
        SOLineRec.SETRANGE("Document Type", pSOHeader."Document Type");
        SOLineRec.SETRANGE("Document No.", pSOHeader."No.");
        IF SOLineRec.FIND('+') THEN
            vLineNo := SOLineRec."Line No.";

        IF pJobBudgetLine.FIND('-') THEN
            REPEAT
                vLineNo := vLineNo + 10000;
                PresentQty := 0;
                SOLineRec.INIT;
                SOLineRec."Document Type" := pSOHeader."Document Type";
                SOLineRec."Document No." := pSOHeader."No.";
                SOLineRec."Line No." := vLineNo;
                SOLineRec.INSERT;

                //pJobBudgetLine.CALCFIELDS("Total Quantity");

                JobLedgEntry.RESET;
                JobLedgEntry.SETCURRENTKEY("Job No.", "Job Task No.",
                Type, "No.", "Posting Date", "Variant Code", "Entry Type");
                JobLedgEntry.SETRANGE("Job No.", pJobBudgetLine."Job No.");
                JobLedgEntry.SETRANGE("Job Task No.", pJobBudgetLine."Job Task No.");
                // JobLedgEntry.SETRANGE("Step Code",pJobBudgetLine."Step Code");
                // JobLedgEntry.SETRANGE("Task Code",pJobBudgetLine."Task Code");
                JobLedgEntry.SETRANGE("No.", pJobBudgetLine.Usage);
                // JobLedgEntry.SETRANGE("Variant Code",pJobBudgetLine."Variant Code");
                JobLedgEntry.SETRANGE(Type, pJobBudgetLine.Type);
                JobLedgEntry.SETFILTER("Posting Date", '%1..%2', pSOHeader."Bill Start Date", pSOHeader."Bill End Date");
                IF JobLedgEntry.FIND('-') THEN
                    REPEAT
                        PresentQty += JobLedgEntry.Quantity;
                    UNTIL JobLedgEntry.NEXT = 0;

                IF (pJobBudgetLine.Type = pJobBudgetLine.Type::"G/L Account") OR
                (pJobBudgetLine.Type = pJobBudgetLine.Type::Item) OR    //RAHEE1.00
                   (pJobBudgetLine.Type = pJobBudgetLine.Type::"Group (Resource)") THEN
                    IF (pJobBudgetLine.Type = pJobBudgetLine.Type::"G/L Account") THEN
                        SOLineRec.VALIDATE(Type, SOLineRec.Type::"G/L Account")
                    ELSE IF (pJobBudgetLine.Type = pJobBudgetLine.Type::Item) THEN
                        SOLineRec.VALIDATE(Type, SOLineRec.Type::Item)
                    ELSE
                        SOLineRec.VALIDATE(Type, SOLineRec.Type::" ")
                ELSE
                    ERROR(Text50000);

                SOLineRec.VALIDATE("No.", pJobBudgetLine."No.");
                SOLineRec.VALIDATE("Location Code", pSOHeader."Location Code");
                IF NOT (SOLineRec.Type = SOLineRec.Type::" ") THEN BEGIN

                    JobSetup.GET();
                    JobSetup.TESTFIELD("Job G/L Account");
                    SOLineRec.VALIDATE("No.", JobSetup."Job G/L Account");
                    SOLineRec.VALIDATE("Unit of Measure Code", pJobBudgetLine."Unit of Measure");
                    SOLineRec."IPA Qty" := PresentQty;
                    SOLineRec."Qty Since Last Bill" := CalculatePreviousQty(pSOHeader."Last RA Bill No.",
                                                       pJobBudgetLine."Job No.", pJobBudgetLine."Entry No.");
                    //SOLineRec."Upto Date Qty" := pJobBudgetLine."Total Quantity";

                    //ALLE-PKS08
                    IF pJobBudgetLine."Non Schedule" = FALSE THEN
                        pJobBudgetLine.TESTFIELD("This Bill Qty.");
                    pJobBudgetLine.CALCFIELDS(Quantity);
                    "JLE InvQty" := 0;
                    "Job Ledger entry".RESET;
                    "Job Ledger entry".SETCURRENTKEY("Job No.", "Job Task No.",
                    Type, "No.", "Posting Date", "Variant Code", "Entry Type");

                    "Job Ledger entry".SETFILTER("Job Ledger entry"."Job Task No.", pJobBudgetLine."Job Task No.");
                    IF "Job Ledger entry".FIND('-') THEN
                        REPEAT
                            "JLE InvQty" += ABS("Job Ledger entry".Quantity);
                        UNTIL "Job Ledger entry".NEXT = 0;
                    //pJobBudgetLine.Quantity:=pJobBudgetLine."This Bill Qty.";
                    //    commented for this bill qty
                    //    IF ("JLE InvQty" > pJobBudgetLine.Quantity) OR ("JLE InvQty" = pJobBudgetLine.Quantity) THEN
                    //                     ERROR('You have Already posted the Quantity')
                    //                 ELSE
                    //                     SOLineRec.VALIDATE(Quantity, pJobBudgetLine.Quantity - "JLE InvQty");

                    //  IF ("JLE InvQty" > pJobBudgetLine."This Bill Qty.") OR ("JLE InvQty" = pJobBudgetLine."This Bill Qty.")THEN
                    //   ERROR ('You have Already posted the Quantity')
                    //s
                    //ELSE
                    SOLineRec.VALIDATE(Quantity, pJobBudgetLine."This Bill Qty.");

                    //ALLE-PKS08

                    pJobBudgetLine.VALIDATE(Quantity);

                    SOLineRec.VALIDATE("Unit Price", pJobBudgetLine."Unit Price");

                    SOLineRec.VALIDATE("Job No.", pJobBudgetLine."Job No.");
                    SOLineRec.VALIDATE("Job Task No.", pJobBudgetLine."Job Task No.");
                    SOLineRec.VALIDATE("Project Code", pJobBudgetLine."Job No.");
                END;
                //ALLERP KRN0008 Start:
                SOLineRec."Tender Rate" := pJobBudgetLine."Tender Rate";
                SOLineRec."Premium/Discount Amount" := pJobBudgetLine."BOQ Tender Amount";
                //ALLERP KRN0008 End:
                SOLineRec.VALIDATE("Entry No.", pJobBudgetLine."Entry No.");
                SOLineRec."BOQ Code" := pJobBudgetLine."BOQ Code";
                SOLineRec.Description := pJobBudgetLine.Description;
                SOLineRec."Description 2" := pJobBudgetLine."Description 2";
                SOLineRec."Invoice Type1" := SOLineRec."Invoice Type1"::RA;
                SOLineRec."BOQ Quantity" := pJobBudgetLine."This Bill Qty.";
                SOLineRec."BOQ Rate Inclusive Tax" := pJobBudgetLine."BOQ Rate Inclusive Tax";
                SOLineRec.VALIDATE("Shortcut Dimension 1 Code", pSOHeader."Shortcut Dimension 1 Code");
                SOLineRec.VALIDATE("Shortcut Dimension 2 Code", pSOHeader."Shortcut Dimension 2 Code");
                SOLineRec.VALIDATE(Amount, SOLineRec."Line Amount");
                SOLineRec.MODIFY;

                pSOHeader."Invoice Type1" := pSOHeader."Invoice Type1"::RA;
                pSOHeader.MODIFY;
            UNTIL pJobBudgetLine.NEXT = 0;
        //ALLESP BCL0016 16-07-2007 End:
    END;

    PROCEDURE GetEscalationLines();
    VAR
        vLineNo: Integer;
    BEGIN
        //TESTFIELD("Job No.");
        //   SalesSetup.GET;
        //   SalesSetup.TESTFIELD("Escalation Account");

        //   vLineNo:=0;
        //   SOLineRec.RESET;
        //   SOLineRec.SETRANGE("Document Type","Document Type");
        //   SOLineRec.SETRANGE("Document No.","No.");
        //   IF SOLineRec.FIND('+') THEN
        //     vLineNo:=SOLineRec."Line No.";

        //   Escalation.RESET;
        //   Escalation.SETRANGE("Deposit Type",Escalation."Deposit Type"::"3");
        //   Escalation.SETRANGE("Project Code","Job No.");
        //   IF Escalation.FIND('-') THEN
        //     REPEAT
        //       vLineNo:=vLineNo+10000;
        //       SOLineRec.INIT;
        //       SOLineRec."Document Type":= "Document Type";
        //       SOLineRec."Document No.":= "No.";
        //       SOLineRec."Line No.":= vLineNo;
        //       SOLineRec.INSERT;
        //       SOLineRec.VALIDATE(Type,SOLineRec.Type::"G/L Account");
        //       SOLineRec.VALIDATE("No.",SalesSetup."Escalation Account");
        //       SOLineRec.VALIDATE("Location Code","Location Code");
        //       SOLineRec.VALIDATE(Quantity,1);
        //       SOLineRec.VALIDATE("Job No.",Escalation."Project Code");
        //       SOLineRec."Invoice Type" := SOLineRec."Invoice Type"::Escalation;
        //       SOLineRec."Escalation Type" := Escalation."Escalation Type";
        //       SOLineRec."Base Index" := Escalation.Value;
        //       SOLineRec."Escalation Line No." := Escalation."Line No.";
        //       SOLineRec.VALIDATE("Shortcut Dimension 1 Code","Shortcut Dimension 1 Code");
        //       SOLineRec.VALIDATE("Shortcut Dimension 2 Code","Shortcut Dimension 2 Code");
        //       SOLineRec.MODIFY;
        //     UNTIL Escalation.NEXT=0;

    END;

    PROCEDURE CalculateEscalation();
    VAR
        Project: Record Job;
        SalesInvoiceLine: Record "Sales Invoice Line";
        RaBillAmount: Decimal;
    BEGIN

        //   TESTFIELD("Last RA Bill No.");
        //     Project.GET("Job No.");
        //     Project.CALCFIELDS("Total Escalation %");

        //     SOLineRec.RESET;
        //     SOLineRec.SETRANGE("Document Type", "Document Type");
        //     SOLineRec.SETRANGE("Document No.", "No.");
        //     IF SOLineRec.FIND('-') THEN
        //         REPEAT
        //             SOLineRec.TESTFIELD("Present Index");
        //         UNTIL SOLineRec.NEXT = 0;

        //     SalesInvoiceLine.RESET;
        //     SalesInvoiceLine.SETRANGE("Document No.", "Last RA Bill No.");
        //     IF SalesInvoiceLine.FIND('-') THEN
        //         REPEAT
        //             RaBillAmount += SalesInvoiceLine."Amount To Customer";
        //         UNTIL SalesInvoiceLine.NEXT = 0;

        //     SOLineRec.RESET;
        //     SOLineRec.SETRANGE("Document Type", "Document Type");
        //     SOLineRec.SETRANGE("Document No.", "No.");
        //     IF SOLineRec.FIND('-') THEN
        //         REPEAT
        //             IF Escalation.GET(Escalation."Deposit Type"::"3", "Job No.", SOLineRec."Escalation Line No.") THEN BEGIN
        //                 SOLineRec.VALIDATE("Unit Price", (Project."Total Escalation %" * RaBillAmount * (SOLineRec."Present Index"
        //                                    - SOLineRec."Base Index") * Escalation.Percentage) / SOLineRec."Base Index");
        //                 SOLineRec.MODIFY;
        //             END;
        //         UNTIL SOLineRec.NEXT = 0;

    END;

    PROCEDURE FillGateEntryLines(VAR PostedGateEntryLine2: Record "Posted Gate Entry Line"; SalesCreditNo: Code[20]);
    BEGIN
        IF PostedGateEntryLine2.FINDSET THEN
            REPEAT
                GateEntryAttachment.INIT;
                GateEntryAttachment."Source Type" := PostedGateEntryLine2."Source Type";
                GateEntryAttachment."Source No." := PostedGateEntryLine2."Source No.";
                GateEntryAttachment."Entry Type" := PostedGateEntryLine2."Entry Type";
                GateEntryAttachment."Gate Entry No." := PostedGateEntryLine2."Gate Entry No.";
                GateEntryAttachment."Line No." := PostedGateEntryLine2."Line No.";
                GateEntryAttachment."Sales Credit Memo No." := SalesCreditNo;
                GateEntryAttachment.INSERT;
            UNTIL PostedGateEntryLine2.NEXT = 0;
    END;

    PROCEDURE CalculatePreviousQty(pRABillNo: Code[20]; pProjectCode: Code[20]; pEntryNo: Integer) PreviousQty: Decimal;
    VAR
        SalesInvHdr: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
    BEGIN
        IF SalesInvHdr.GET(pRABillNo) THEN BEGIN
            SalesInvLine.RESET;
            SalesInvLine.SETRANGE("Document No.", SalesInvHdr."No.");
            SalesInvLine.SETRANGE("Project Code", pProjectCode);
            SalesInvLine.SETRANGE("Entry No.", pEntryNo);
            IF SalesInvLine.FIND('-') THEN
                PreviousQty += SalesInvLine.Quantity;
            CalculatePreviousQty(SalesInvHdr."Last RA Bill No.", SalesInvLine."Job No.", SalesInvLine."Entry No.");
        END;
    END;






    PROCEDURE CalculateRIT();
    VAR
        SalesHeader2: Record "Sales Header";
        SalesLine2: Record "Sales Line";
    BEGIN
        SalesHeader2.GET("Document Type", "No.");
        SalesLine2.SETRANGE("Document Type", "Document Type");
        SalesLine2.SETRANGE("Document No.", "No.");
        SalesLine2.SETFILTER(SalesLine2.Type, '>%1', 0);
        SalesLine2.SETRANGE(SalesLine2."RIT Done", FALSE);
        IF SalesLine2.FINDFIRST THEN
            REPEAT

            UNTIL SalesLine2.NEXT = 0;
    END;

    PROCEDURE FillJobBudgetLines2(VAR JobTask: Record "Job Task"; SOHeader: Record "Sales Header");
    VAR
        VLineNo: Integer;
        SalesHdr: Record "Purchase Header";
        JobLedgEntry: Record "Job Ledger Entry";
        PresentQty: Decimal;
        SOLineRec: Record "Sales Line";
        JobSetup: Record "Jobs Setup";
        JobLedgerentry: Record "Job Ledger Entry";
        "JLE InvQty": Decimal;
        DocSetup: Record "Document Type Setup";
        CostCenter: Code[20];
        JobPlanningLine: Record "Job Planning Line";
    BEGIN
        //ALLEAA BCL0016 14-10-2008 Start:
        VLineNo := 0;
        SOLineRec.RESET;
        SOLineRec.SETRANGE("Document Type", SOHeader."Document Type");
        SOLineRec.SETRANGE("Document No.", SOHeader."No.");
        IF SOLineRec.FIND('+') THEN
            VLineNo := SOLineRec."Line No.";


        IF JobTask.FIND('-') THEN
            REPEAT
                QtyZero := TRUE;
                CostZero := TRUE;
                VLineNo := VLineNo + 10000;
                PresentQty := 0;

                JobplanningLine1.RESET;
                JobplanningLine1.SETRANGE("Job No.", JobTask."Job No.");
                JobplanningLine1.SETRANGE("Job Task No.", JobTask."Job Task No.");
                JobplanningLine1.SETRANGE("Line Type", JobplanningLine1."Line Type"::Contract);
                IF SOHeader."Invoice Type1" = SOHeader."Invoice Type1"::Normal THEN
                    JobplanningLine1.SETRANGE(Type, JobplanningLine1.Type::Item)
                ELSE
                    JobplanningLine1.SETRANGE(Type, JobplanningLine1.Type::"G/L Account");
                JobplanningLine1.SETFILTER("No.", '<>%1', '');
                IF JobplanningLine1.FINDSET THEN
                    REPEAT
                        VLineNo := VLineNo + 10000;

                        SOLineRec.INIT;
                        SOLineRec."Document Type" := SOHeader."Document Type";
                        SOLineRec."Document No." := SOHeader."No.";
                        SOLineRec."Line No." := VLineNo;
                        SOLineRec.INSERT;

                        JobPlanningLine.RESET;
                        JobPlanningLine.SETRANGE(JobPlanningLine."Job No.", JobTask."Job No.");
                        JobPlanningLine.SETRANGE(JobPlanningLine."Job Task No.", JobTask."Job Task No.");
                        JobPlanningLine.SETRANGE("Line Type", JobplanningLine1."Line Type");
                        JobPlanningLine.SETRANGE("Line No.", JobplanningLine1."Line No.");
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
                                  (JobPlanningLine.Type = JobPlanningLine.Type::Item) OR  //RAHEE1.00
                                  (JobPlanningLine.Type = JobPlanningLine.Type::"Group (Resource)") THEN
                                    IF (JobPlanningLine.Type = JobPlanningLine.Type::"G/L Account") THEN
                                        SOLineRec.VALIDATE(Type, SOLineRec.Type::"G/L Account")
                                    ELSE IF (JobPlanningLine.Type = JobPlanningLine.Type::Item) THEN
                                        SOLineRec.VALIDATE(Type, SOLineRec.Type::Item)
                                    ELSE
                                        SOLineRec.VALIDATE(Type, SOLineRec.Type::" ")
                                ELSE
                                    ERROR(Text50000);

                                SOLineRec.VALIDATE("No.", JobPlanningLine."No.");
                                SOLineRec.VALIDATE("Location Code", SOHeader."Location Code");
                                IF SOHeader."Client Bill Type" = SOHeader."Client Bill Type"::Raised THEN
                                    SOLineRec."Invoice Type1" := SOLineRec."Invoice Type1"::RA;
                                IF SOHeader."Client Bill Type" = SOHeader."Client Bill Type"::Certified THEN
                                    SOLineRec."Invoice Type1" := SOLineRec."Invoice Type1"::RA;

                                IF NOT (SOLineRec.Type = SOLineRec.Type::" ") THEN BEGIN
                                    IF SOLineRec.Type = SOLineRec.Type::"G/L Account" THEN BEGIN
                                        SalesHeader.GET("Document Type", "No.");
                                        IF SalesHeader."Sell-to Customer No." <> '' THEN BEGIN
                                            SOLineRec.VALIDATE("No.", JobPlanningLine."No.");
                                            DocSetup.RESET;
                                            DocSetup.SETRANGE("Document Type", DocSetup."Document Type"::"Purchase Order");
                                            DocSetup.SETRANGE("Sub Document Type", "Sub Document Type");
                                            IF DocSetup.FIND('-') THEN
                                                IF DocSetup."Def. Gen Prod Posting Group" <> '' THEN
                                                    SOLineRec."Gen. Prod. Posting Group" := DocSetup."Def. Gen Prod Posting Group";
                                        END;
                                    END;

                                    SOLineRec."Qty Since Last Bill" := CalculatePreviousQty(SOHeader."Last RA Bill No.", JobTask."Job No.",
                                      JobTask."Entry No.");
                                    JobTask.CALCFIELDS(Quantity);
                                    //JobTask.TESTFIELD(Quantity); commented by dds on 08May09 - as this was stopping RATE ONLY lines to be fetched on sales
                                    //lines

                                    //          "JLE InvQty" := 0;
                                    //          JobLedgerentry.RESET;
                                    //          JobLedgerentry.SETCURRENTKEY("Job No.","Job Task No.",Type,"No.","Posting Date","Variant Code","Entry Type");
                                    //          JobLedgerentry.SETFILTER("Job Task No.",JobPlanningLine."Job Task No.");
                                    //          IF JobLedgerentry.FIND('-') THEN
                                    //            REPEAT
                                    //              "JLE InvQty" += ABS(JobLedgerentry.Quantity);
                                    //            UNTIL JobLedgerentry.NEXT=0;

                                    IF SOLineRec.Type = SOLineRec.Type::"G/L Account" THEN
                                        SOLineRec.VALIDATE(Quantity, JobTask."This Bill Qty.")
                                    ELSE IF SOLineRec.Type = SOLineRec.Type::Item THEN BEGIN
                                        IF Item.GET(JobPlanningLine."No.") THEN;
                                        FromBOMComp.RESET;
                                        FromBOMComp.SETRANGE("Parent Item No.", JobPlanningLine."BOM Item No.");
                                        FromBOMComp.SETRANGE("No.", JobPlanningLine."No.");
                                        IF FromBOMComp.FINDFIRST THEN BEGIN
                                            IF JobPlanningLine."Explode Lines" = FALSE THEN
                                                SOLineRec.VALIDATE(Quantity, JobTask."This Bill Qty.")
                                            ELSE
                                                SOLineRec.VALIDATE("Explode Bom Qty",
                                                 ROUND(JobTask."This Bill Qty." * FromBOMComp."Quantity per" *
                                                       UOMMgt.GetQtyPerUnitOfMeasure(Item, SOLineRec."Unit of Measure Code") /
                                                       SOLineRec."Qty. per Unit of Measure", 0.00001))

                                        END ELSE
                                            SOLineRec.VALIDATE(Quantity, JobTask."This Bill Qty.");
                                    END;
                                    SOLineRec.VALIDATE("Entry No.", JobTask."Entry No.");
                                    SOLineRec.VALIDATE("Unit of Measure Code", JobPlanningLine."Unit of Measure Code");
                                    SOLineRec.VALIDATE("Unit Price", JobPlanningLine."Unit Price");
                                    //ALLERP KRN0008 Start:
                                    SOLineRec."Tender Rate" := JobPlanningLine."Tender Rate";
                                    SOLineRec."Premium/Discount Amount" := JobPlanningLine."BOQ Tender Amount";
                                    //ALLERP KRN0008 End:
                                    SOLineRec."Job Contract Entry No." := JobPlanningLine."Job Contract Entry No.";
                                    SOLineRec."BOQ Quantity" := JobPlanningLine.Quantity;
                                    SOLineRec.VALIDATE("Job No.", JobTask."Job No.");
                                    SOLineRec.VALIDATE("Job Task No.", JobTask."Job Task No.");
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


                        SOLineRec."Project Code" := JobTask."Job No.";
                        SOLineRec."BOQ Code" := JobTask."BOQ Code";
                        SOLineRec.Description := JobTask.Description;
                        //    SOLineRec."Description 2" := JobTask."Phase Desc";
                        SOLineRec.VALIDATE("Shortcut Dimension 1 Code", SOHeader."Shortcut Dimension 1 Code");
                        SOLineRec.VALIDATE("Shortcut Dimension 2 Code", JobPlanningLine."Shortcut Dimension 2 Code");
                        SOLineRec.VALIDATE(Amount, SOLineRec."Line Amount");
                        SOLineRec."Invoice Type1" := SOLineRec."Invoice Type1"::RA;
                        SOLineRec.MODIFY;
                    UNTIL JobplanningLine1.NEXT = 0;
                SOHeader.MODIFY;

            UNTIL JobTask.NEXT = 0;

        //ALLEAA BCL0016 14-10-2008 End:
    END;

    PROCEDURE CreateResaleOrder(LoadSales: Code[20]; NewCustomer: Code[20]);
    VAR
        SalesHdr: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesLine1: Record "Sales Line";
        SalesHdr1: Record "Sales Header";
        PaymentMilestone: Record "Payment Terms Line Sale";
        PaymentMilestone1: Record "Payment Terms Line Sale";
    BEGIN
        SalesHdr.INIT;
        SalesHdr."Document Type" := SalesHdr."Document Type"::Order;
        SalesHdr."Sub Document Type" := SalesHdr."Sub Document Type"::Sales;
        SalesHdr."No." := '';
        SalesHdr.INSERT(TRUE);
        SalesHdr.VALIDATE("Sell-to Customer No.", NewCustomer);
        SalesHdr1.GET(SalesHdr1."Document Type"::Order, LoadSales);
        SalesHdr."Sub Project Code" := SalesHdr1."Sub Project Code";
        SalesHdr."Item Code" := SalesHdr1."Item Code";
        SalesHdr."CO-Applicant Code 1" := SalesHdr1."CO-Applicant Code 1";
        SalesHdr."CO-Applicant Name 1" := SalesHdr1."CO-Applicant Name 1";
        SalesHdr."CO-Applicant Code 2" := SalesHdr1."CO-Applicant Code 2";
        SalesHdr."CO-Applicant Name 2" := SalesHdr1."CO-Applicant Name 2";
        SalesHdr."CO-Applicant Code 3" := SalesHdr1."CO-Applicant Code 3";
        SalesHdr."CO-Applicant Name 3" := SalesHdr1."CO-Applicant Name 3";
        SalesHdr."Broker Code" := SalesHdr1."Broker Code";
        //SalesHdr."Payment Plan" := SalesHdr1."Payment Plan";
        SalesHdr."Transfered Order No." := LoadSales;
        SalesHdr.MODIFY;

        SalesLine.RESET;
        SalesLine.SETRANGE(SalesLine."Document Type", SalesLine1."Document Type"::Order);
        SalesLine.SETRANGE(SalesLine."Document No.", LoadSales);
        IF SalesLine.FINDFIRST THEN
            REPEAT
                SalesLine1.INIT;
                SalesLine1.TRANSFERFIELDS(SalesLine);
                SalesLine1."Document No." := SalesHdr."No.";
                SalesLine1."Sell-to Customer No." := SalesHdr."Sell-to Customer No.";
                SalesLine1.INSERT;
            UNTIL SalesLine.NEXT = 0;

        PaymentMilestone.RESET;
        PaymentMilestone.SETRANGE("Document Type", "Document Type");
        PaymentMilestone.SETRANGE("Document No.", LoadSales);
        IF PaymentMilestone.FINDFIRST THEN
            REPEAT
                //   PaymentMilestone1.INIT;
                //         PaymentMilestone1.TRANSFERFIELDS(PaymentMilestone);
                //         PaymentMilestone1."Document No." := SalesHdr."No.";
                //         PaymentMilestone1.INSERT;
                PaymentMilestone.CALCFIELDS(PaymentMilestone."Received Amt");
                IF (PaymentMilestone."Due Amount" + PaymentMilestone."Received Amt") > 0 THEN BEGIN
                    PaymentMilestone1.INIT;
                    PaymentMilestone1.TRANSFERFIELDS(PaymentMilestone);
                    PaymentMilestone1."Document No." := SalesHdr."No.";
                    PaymentMilestone1."Due Amount" := (PaymentMilestone."Due Amount" + PaymentMilestone."Received Amt");
                    PaymentMilestone1.INSERT;
                END;

            UNTIL PaymentMilestone.NEXT = 0;
    END;
}