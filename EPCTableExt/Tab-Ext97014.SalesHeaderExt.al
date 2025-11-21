tableextension 97014 "EPC Sales Header Ext" extends "Sales Header"
{
    fields
    {
        // Add changes to table fields here
        field(60010; "Payment Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Sub Document Type" = FILTER(Sales)) "Document Master".Code WHERE("Document Type" = FILTER("Payment Plan"),
                                                                                               "Project Code" = FIELD("Job No."),
                                                                                               "Sale/Lease" = FILTER(Sale))
            ELSE IF ("Sub Document Type" = FILTER(Lease)) "Document Master".Code WHERE("Document Type" = FILTER("Payment Plan"),
                                                                                                                                                                       "Project Code" = FIELD("Job No."),
                                                                                                                                                                       "Sale/Lease" = FILTER(Lease));
        }
        field(50006; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0016 17-07-2007';
            TableRelation = Job;
        }
        field(90055; "Item Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            TableRelation = Item."No." WHERE("Property Unit" = FILTER(true),
                                            "Project Code" = FIELD("Shortcut Dimension 1 Code"));

            trigger OnLookup()
            begin

                MakeProjectUnitRec(0);
                IF "Sub Document Type" = "Sub Document Type"::Sales THEN BEGIN
                    IF PAGE.RUNMODAL(Page::"Resposibility center form", ItemL) = ACTION::LookupOK THEN
                        VALIDATE("Item Code", ItemL."No.");
                END;
                IF "Sub Document Type" = "Sub Document Type"::Lease THEN BEGIN
                    IF PAGE.RUNMODAL(Page::"Unit List - Lease", ItemL) = ACTION::LookupOK THEN
                        VALIDATE("Item Code", ItemL."No.");
                END;
                IF "Sub Document Type" = "Sub Document Type"::"Sale Property" THEN BEGIN
                    IF PAGE.RUNMODAL(Page::"Resposibility center form", ItemL) = ACTION::LookupOK THEN
                        VALIDATE("Item Code", ItemL."No.");
                END;
                IF "Sub Document Type" = "Sub Document Type"::"Lease Property" THEN BEGIN
                    IF PAGE.RUNMODAL(Page::"Unit List - Lease", ItemL) = ACTION::LookupOK THEN
                        VALIDATE("Item Code", ItemL."No.");
                END;
            end;

            trigger OnValidate()
            begin

                IF "Item Code" = '' THEN EXIT;
                IF "Item Code" = xRec."Item Code" THEN
                    EXIT;
                MakeProjectUnitRec(1);
                //ItemL.CALCFIELDS("Sales Order Count","Purchase Order Count","Lease Order Count");
                //IF NOT ItemL.FIND('-') THEN
                //ERROR('Property Unit is Not Available.');

                //ItemL.CALCFIELDS("Sales Order Count","Purchase Order Count","Lease Order Count");
                ItemL.GET("Item Code");
                IF "Document Type" = "Document Type"::Order THEN BEGIN
                    IF "Sub Document Type" = "Sub Document Type"::Sales THEN BEGIN
                        IF ItemL."Sales Blocked" THEN
                            ERROR('Sales is Blocked.');
                        // IF (ItemL."Constructed Property"+ItemL."Purchase Order Count"-ItemL."Sales Order Count")<=0 THEN
                        // ERROR('Property Unit is Not Available for Sale.');
                    END;
                    IF "Sub Document Type" = "Sub Document Type"::Lease THEN BEGIN
                        IF ItemL."Lease Blocked" THEN
                            ERROR('Lease is Blocked.');
                        //IF (ItemL."Lease Order Count")>0 THEN
                        //ERROR('Property Unit is not Available for Lease.');
                    END;
                    IF "Sub Document Type" = "Sub Document Type"::"Sale Property" THEN BEGIN
                        IF ItemL."Sales Blocked" THEN
                            ERROR('Sales is Blocked.');
                        //IF (ItemL."Constructed Property"+ItemL."Purchase Order Count"-ItemL."Sales Order Count")<=0 THEN
                        //ERROR('Property Unit is Not Available for Sale.');
                    END;
                    IF "Sub Document Type" = "Sub Document Type"::"Lease Property" THEN BEGIN
                        IF ItemL."Lease Blocked" THEN
                            ERROR('Lease is Blocked.');
                        //IF (ItemL."Lease Order Count")>0 THEN
                        //ERROR('Property Unit is not Available for Lease.');
                    END;

                END;

                IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
                    /*//AlleBLK
                    IF "Sub Document Type"="Sub Document Type"::Sales THEN BEGIN
                      IF (ItemL."Constructed Property"+ItemL."Purchase Order Count"-ItemL."Sales Order Count")<=0 THEN
                        ERROR('Property Unit is Not Available for Sale.');
                    END;
                    IF "Sub Document Type"="Sub Document Type"::Lease THEN BEGIN
                      IF (ItemL."Lease Order Count")>0 THEN
                        ERROR('Property Unit is not Available for Lease.');
                    END;
                    */   //AlleBLK
                END;


                //ValidateShortcutDimCode(5,"Item Code");
                MODIFY;

            end;
        }
        field(60012; "Order Status"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE Field Added to show Order Status as Cancelled, short closed or Completed';
            Editable = false;
            OptionCaption = 'Booked,Transfered,Forfeited,Cancelled,Closed';
            OptionMembers = Booked,Transfered,Forfeited,Cancelled,Closed;

            trigger OnValidate()
            begin
                //dds
                PaymentTermLine.SETRANGE("Project Code", "Job No.");
                PaymentTermLine.SETRANGE("Document Type", "Document Type");
                PaymentTermLine.SETRANGE("Document No.", "No.");

                IF PaymentTermLine.FIND('-') THEN
                    REPEAT
                        PaymentTermLine."Order Status" := "Order Status";
                        PaymentTermLine.MODIFY;
                    UNTIL PaymentTermLine.NEXT = 0;
                //dds
            end;
        }
        field(60009; "Broker Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            TableRelation = Vendor."No." WHERE("BBG Vendor Category" = FILTER(Transporter));

            trigger OnValidate()
            begin
                //CheckBrand;//AEREN01

                PaymentTermLine.SETRANGE("Project Code", "Job No.");
                PaymentTermLine.SETRANGE("Document Type", "Document Type");
                PaymentTermLine.SETRANGE("Document No.", "No.");

                IF PaymentTermLine.FIND('-') THEN
                    REPEAT
                        PaymentTermLine."Broker No." := "Broker Code";
                        PaymentTermLine.MODIFY;
                    UNTIL PaymentTermLine.NEXT = 0;
            end;
        }
        field(50002; "Invoice Type1"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0006 27-07-2007-BCL';
            OptionCaption = 'Normal,RA,Escalation';
            OptionMembers = Normal,RA,Escalation;
        }
        field(50003; "Bill Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0016 27-08-2007';
        }
        field(50004; "Bill End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0016 27-08-2007';
        }
        field(50007; "Total Order Value"; Decimal)
        {
            CalcFormula = Sum("Sales Line".Amount WHERE("Document Type" = FIELD("Document Type"),
                                                                       "Document No." = FIELD("No."),
                                                                       "Charge Type" = CONST(" ")));
            Description = 'ALLESP BCL0016 27-08-2007';
            FieldClass = FlowField;
        }
        field(50016; "Retention Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0005 19-09-2007';
        }
        field(50017; "Retention Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0005 19-09-2007';
        }
        field(50008; "Calc Mobilization Adv"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0005 19-09-2007';

            trigger OnValidate()
            begin
                IF NOT "Calc Mobilization Adv" THEN
                    "Mobilization Adv Amt" := 0;
            end;
        }
        field(50012; "Mobilization Adv Amt"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0005 19-09-2007';
        }
        field(50009; "Calc Equipment Adv"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0005 19-09-2007';

            trigger OnValidate()
            begin
                IF NOT "Calc Equipment Adv" THEN
                    "Equipment Adv Amt" := 0;
            end;
        }
        field(50013; "Equipment Adv Amt"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0005 19-09-2007';
        }
        field(50010; "Calc Secured Adv"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0005 19-09-2007';

            trigger OnValidate()
            begin
                IF NOT "Calc Secured Adv" THEN
                    "Secured Adv Amt" := 0;
            end;
        }
        field(50014; "Secured Adv Amt"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0005 19-09-2007';
        }
        field(50011; "Calc Adhoc Adv"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0005 19-09-2007';

            trigger OnValidate()
            begin
                IF NOT "Calc Adhoc Adv" THEN
                    "Adhoc Adv Amt" := 0;
            end;
        }
        field(50015; "Adhoc Adv Amt"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0005 19-09-2007';
        }
        field(60007; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(60008; "Creation Time"; Time)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50000; "Sub Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'DDS added to sales and lease documents ALLRE';
            Editable = false;
            OptionCaption = ' ,,,,,,,,,,,,,,Sales,Lease,,,Sale Property,Sale Normal,Lease Property';
            OptionMembers = " ","WO-Project","WO-Normal","Regular PO-Project","Regular PO Normal","Property PO","Direct PO-Normal","GRN for PO","GRN for Aerens","GRN for Packages","GRN for Fabricated Material for WO","JES for WO","GRN-Direct Purchase","Freight Advice",Sales,Lease,"Project Indent","Non-Project Indent","Sale Property","Sale Normal","Lease Property";
        }
        field(60000; Approved; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';

            trigger OnValidate()
            var
                PurchLineRec: Record "Purchase Line";
                DocSetup: Record "Document Type Setup";
            begin
                IF Approved THEN
                    CheckRequired; //JPL03 START
            end;
        }
        field(60006; "Sent for Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';

            trigger OnValidate()
            begin
                CheckRequired; //JPL03 START
            end;
        }
        field(60003; Initiator; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(60001; "Approved Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(60002; "Approved Time"; Time)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90081; "Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Job;
        }
        field(60004; "Sent for Approval Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(60005; "Sent for Approval Time"; Time)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90072; "Client Bill Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Opened,Closed';
            OptionMembers = Opened,Closed;
        }
        field(90073; "Client Bill Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Raised,Certified';
            OptionMembers = " ",Raised,Certified;
        }
        field(90074; "Raised Client Bill Ref. No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Client Bill Type" = FILTER(Certified),
                                "Sell-to Customer No." = FILTER(<> '')) "Sales Header"."No." WHERE("Sell-to Customer No." = FIELD("Sell-to Customer No."),
                                                                                             Approved = FILTER(true),
                                                                                             "Client Bill Status" = FILTER(Opened));
        }
        field(50022; "Sales Tax Base %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLE PS Added field for Sales tax Base Amount';
            MaxValue = 100;
        }
        field(50023; "North Zone"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLE PS Added field for Client Billing';
        }
        field(50024; "South Zone"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLE PS Added field for Client Billing';
        }
        field(50025; "Percent of Steel"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLE PS Added field for Client Billing';
        }
        field(50026; "Percent for Rest"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLE PS Added field for Client Billing';
        }
        field(50027; "Labour Percent"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLE PS Added field for Client Billing';
        }
        field(50018; "Transporter Name"; Text[1])
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00 240212';
        }
        field(60013; Amended; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEPG 300409';
        }
        field(60014; "Amendment Approved"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEPG 300409';
        }
        field(90051; "Last Stage Completed"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 to link PO with Payment Stages--JPL';
            Editable = false;
            TableRelation = "Payment Terms Line"."Milestone Code" WHERE("Document Type" = FIELD("Document Type"),
                                                                         "Document No." = FIELD("No."));
            ValidateTableRelation = false;
        }
        field(90050; "Active Stage"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 to link PO with Payment Stages--JPL';
            Editable = false;
            TableRelation = "Payment Terms Line"."Milestone Code" WHERE("Document Type" = FIELD("Document Type"),
                                                                         "Document No." = FIELD("No."));
        }
        field(50031; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50032; "Unit Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50099; "Workflow Sub Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            OptionCaption = ' ,FA,Regular,Direct,WorkOrder,Inward,Outward';
            OptionMembers = " ",FA,Regular,Direct,WorkOrder,Inward,Outward;
        }
        field(50100; "Initiator User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
        }
        field(50001; "Last RA Bill No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0006 27-07-2007-BCL';
            TableRelation = "Sales Header" WHERE("Invoice Type1" = CONST(RA),
                                                  "Job No." = FIELD("Job No."));
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

    PROCEDURE MakeProjectUnitRec(Mode: Integer);
    BEGIN
        //   ItemL.RESET;
        //     ItemL.SETRANGE("Property Unit", TRUE);
        //     //IF "Job No."<>'' THEN
        //     ItemL.SETFILTER("Project Code", '%1', "Project Code");
        //     ItemL.SETFILTER("Sub Project Code", "Sub Project Code");
        //     //IF Mode=1 THEN
        //     //  ItemL.SETRANGE("No.","Item Code");

        //     IF ItemL.FIND('-') THEN
        //         REPEAT
        //             ItemL.CALCFIELDS("Sales Order Count", "Purchase Order Count", "Lease Order Count");
        //             IF "Document Type" = "Document Type"::Order THEN BEGIN
        //                 IF ("Sub Document Type" = "Sub Document Type"::Sales) OR ("Sub Document Type" = "Sub Document Type"::"Sale Property") THEN BEGIN
        //                     IF (ItemL."Sales Blocked" = FALSE) AND
        //                        ((ItemL."Constructed Property" + ItemL."Purchase Order Count" - ItemL."Sales Order Count") > 0) THEN
        //                         ItemL.MARK(TRUE);

        //                 END;
        //                 IF ("Sub Document Type" = "Sub Document Type"::Lease) OR ("Sub Document Type" = "Sub Document Type"::"Lease Property") THEN BEGIN
        //                     IF ((ItemL."Lease Order Count") <= 0) THEN
        //                         ItemL.MARK(TRUE);
        //                 END;
        //             END;

        //             IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
        //                 ItemL.MARK(TRUE);
        //         //AlleBLK
        //       IF "Sub Document Type" = "Sub Document Type"::Sales THEN BEGIN

        //                     //ItemL.SETRANGE("Sales Booked",TRUE);
        //                     //ItemL.SETRANGE("Sales Blocked",FALSE);
        //                 END;
        //                 IF "Sub Document Type" = "Sub Document Type"::Lease THEN BEGIN
        //                     //ItemL.SETRANGE("Lease Booked",TRUE);
        //                     //ItemL.SETRANGE("Lease Blocked",FALSE);
        //                 END;
        //        //AlleBLK
        //     END;
        //   UNTIL ItemL.NEXT=0;
        //   ItemL.MARKEDONLY(TRUE);

    END;

    PROCEDURE CheckRequired();
    VAR
        SaleLineRec: Record "Sales Line";
        DocSetup: Record "Document Type Setup";
        vJobAllocationReq: Boolean;
        vJobAllocation: Record "Job Allocation";
        vSaleLine: Record "Sales Line";
        vJobAmt: Decimal;
        SOHdrL: Record "Sales Header";
        OldCustLedgEntry: Record "Cust. Ledger Entry";
        Location: Record Location;
    BEGIN
        IF "Document Type" = "Document Type"::Order THEN BEGIN
            TESTFIELD("Sell-to Customer No.");
            TESTFIELD("Bill-to Customer No.");
            TESTFIELD("Posting Date");
            TESTFIELD("Document Date");
            IF "Location Code" <> '' THEN
                Location.GET("Location Code");

            SaleLineRec.RESET;
            SaleLineRec.SETRANGE("Document Type", "Document Type");
            SaleLineRec.SETRANGE("Document No.", "No.");
            SaleLineRec.FINDFIRST;

            DocSetup.GET(DocSetup."Document Type"::"Sale Order", DocSetup."Sub Document Type"::Order);
            SaleLineRec.RESET;
            SaleLineRec.SETRANGE("Document Type", "Document Type");
            SaleLineRec.SETRANGE("Document No.", "No.");
            SaleLineRec.SETFILTER(Type, '%1|%2|%3', SaleLineRec.Type::Item, SaleLineRec.Type::"G/L Account",
                                    SaleLineRec.Type::"Charge (Item)");
            IF SaleLineRec.FINDSET THEN BEGIN
                REPEAT
                    SaleLineRec.TESTFIELD("Gen. Prod. Posting Group");
                    SaleLineRec.TESTFIELD("Gen. Bus. Posting Group");
                    SaleLineRec.TESTFIELD("Shortcut Dimension 1 Code");
                    IF SaleLineRec.Type = SaleLineRec.Type::Item THEN BEGIN
                        SaleLineRec.TESTFIELD("Unit of Measure Code");
                        SaleLineRec.TESTFIELD("Location Code");
                        IF SaleLineRec."Location Code" <> '' THEN
                            Location.GET(SaleLineRec."Location Code");
                    END;
                UNTIL SaleLineRec.NEXT = 0;
            END;
        END;

        IF "Document Type" = "Document Type"::Invoice THEN BEGIN
            TESTFIELD("Sell-to Customer No.");
            TESTFIELD("Bill-to Customer No.");
            TESTFIELD("Posting Date");
            TESTFIELD("Document Date");
            IF ("Applies-to Doc. No." <> '') AND ("Applies-to ID" <> '') THEN
                ERROR('Applies-to Doc. No. and Applies-to ID cannot be filled together.');

            SaleLineRec.RESET;
            SaleLineRec.SETRANGE("Document Type", "Document Type");
            SaleLineRec.SETRANGE("Document No.", "No.");
            SaleLineRec.FINDFIRST;

            SaleLineRec.RESET;
            SaleLineRec.SETRANGE("Document Type", "Document Type");
            SaleLineRec.SETRANGE("Document No.", "No.");
            SaleLineRec.SETFILTER(Type, '%1|%2|%3', SaleLineRec.Type::Item, SaleLineRec.Type::"G/L Account",
                                    SaleLineRec.Type::"Charge (Item)");
            IF SaleLineRec.FINDSET THEN BEGIN
                REPEAT
                    IF SaleLineRec."Job Contract Entry No." = 0 THEN
                        SaleLineRec.TESTFIELD("Gen. Prod. Posting Group");
                    SaleLineRec.TESTFIELD("Gen. Bus. Posting Group");
                    SaleLineRec.TESTFIELD("Shortcut Dimension 1 Code");
                    IF SaleLineRec.Type = SaleLineRec.Type::Item THEN BEGIN
                        SaleLineRec.TESTFIELD("Unit of Measure Code");
                        SaleLineRec.TESTFIELD("Location Code");
                        IF SaleLineRec."Location Code" <> '' THEN
                            Location.GET(SaleLineRec."Location Code");
                    END;
                    SaleLineRec.TESTFIELD("Qty. to Invoice");
                UNTIL SaleLineRec.NEXT = 0;
            END;
        END;
    END;

    PROCEDURE GetJobBudgetLines();
    VAR
        Sldr: Record "Sales Header";
    BEGIN
        TESTFIELD("Job No.");
        Sldr.GET("Document Type", "No.");

        JobBudgetLine.RESET;
        JobBudgetLine.FILTERGROUP := 2;
        JobBudgetLine.SETRANGE("Job No.", "Job No.");
        IF Sldr."Ship-to Code" <> '' THEN                              //RAHEE1.00 150512
            JobBudgetLine.SETRANGE("Consinee Code", Sldr."Ship-to Code");  //RAHEE1.00 150512
                                                                           //JobBudgetLine.SETFILTER(Type,'%1|%2',JobBudgetLine.Type::"G/L Account",JobBudgetLine.Type::"Group (Resource)");
                                                                           //JobBudgetLine.SETRANGE("Line Type",JobBudgetLine."Line Type"::Schedule);
                                                                           //JobBudgetLine.SETRANGE("BOQ Type",JobBudgetLine."BOQ Type"::Sale);
                                                                           //ALLETG RIL0100 16-06-2011: START>>
        JobBudgetLine.SETFILTER("Posting Date Filter", '%1..%2', "Bill Start Date", "Bill End Date");
        //ALLETG RIL0100 16-06-2011: END<<
        JobBudgetLine.FILTERGROUP := 0;
        // PAGE 216 is not exixting in nav 2016

        //   IF JobBudgetLine.FIND('-') THEN BEGIN
        //         CLEAR(JobBudgetLineForm);
        //         JobBudgetLineForm.SETTABLEVIEW(JobBudgetLine);
        //         JobBudgetLineForm.LOOKUPMODE := TRUE;
        //         JobBudgetLineForm.SetSOHeader(Sldr);
        //         JobBudgetLineForm.SetSOMode(TRUE);
        //         JobBudgetLineForm.RUNMODAL;
        //     END;

        // PAGE 216 is not exixting in nav 2016

        //ALLEAA BCL0016 14-10-2008 End:
    END;

    PROCEDURE CalculateAdvance();
    VAR
        MoblizationStart: Decimal;
        MoblizationEnd: Decimal;
        EquipmentStart: Decimal;
        EquipmentEnd: Decimal;
        SecuredStart: Decimal;
        SecuredEnd: Decimal;
        AdhocStart: Decimal;
        AdhocEnd: Decimal;
        TotalRaAmount: Decimal;
        Project: Record Job;
        X: Decimal;
    BEGIN
        //ALLESP BCL0005 19-09-2007 Start:
        CALCFIELDS("Total Order Value");

        TotalRaAmount := CalculateTotalRAAmt("Last RA Bill No.") + "Total Order Value";
        IF Project.GET("Job No.") THEN;
        Project.CALCFIELDS("Project Amount");

        IF "Calc Mobilization Adv" THEN BEGIN
            MoblizationStart := Project."Mobilization Adj Starting %" * Project."Project Amount" / 100;
            MoblizationEnd := Project."Mobilization Adj Ending %" * Project."Project Amount" / 100;
            Project.CALCFIELDS("Mobilization Adv Remained");
            IF (TotalRaAmount > MoblizationStart) AND (TotalRaAmount <= MoblizationEnd) THEN
                X := TotalRaAmount - MoblizationStart
            ELSE IF (TotalRaAmount > MoblizationEnd) THEN
                X := TotalRaAmount + "Total Order Value" - MoblizationEnd;

            IF MoblizationEnd <> 0 THEN
                "Mobilization Adv Amt" := X * Project."Mobilization Adv Remained" / MoblizationEnd;
        END;

        IF "Calc Equipment Adv" THEN BEGIN
            EquipmentStart := Project."Equipment Adj Starting %" * Project."Project Amount" / 100;
            EquipmentEnd := Project."Equipment Adj Ending %" * Project."Project Amount" / 100;
            Project.CALCFIELDS("Equipment Adv Remained");
            IF (TotalRaAmount > EquipmentStart) AND (TotalRaAmount <= EquipmentEnd) THEN
                X := TotalRaAmount - EquipmentStart
            ELSE IF (TotalRaAmount > EquipmentEnd) THEN
                X := TotalRaAmount + "Total Order Value" - EquipmentEnd;
            IF EquipmentEnd <> 0 THEN
                "Equipment Adv Amt" := X * Project."Equipment Adv Remained" / EquipmentEnd;
        END;

        IF "Calc Secured Adv" THEN BEGIN
            SecuredStart := Project."Secured Adj Starting %" * Project."Project Amount" / 100;
            SecuredEnd := Project."Secured Adj Ending %" * Project."Project Amount" / 100;
            Project.CALCFIELDS("Secured Adv Remained");
            IF (TotalRaAmount > SecuredStart) AND (TotalRaAmount <= SecuredEnd) THEN
                X := TotalRaAmount - SecuredStart
            ELSE IF (TotalRaAmount > SecuredEnd) THEN
                X := TotalRaAmount + "Total Order Value" - SecuredEnd;
            IF SecuredEnd <> 0 THEN
                "Secured Adv Amt" := X * Project."Secured Adv Remained" / SecuredEnd;
        END;

        IF "Calc Adhoc Adv" THEN BEGIN
            AdhocStart := Project."Adhoc Adj Starting %" * Project."Project Amount" / 100;
            AdhocEnd := Project."Adhoc Adj Ending %" * Project."Project Amount" / 100;
            Project.CALCFIELDS("Adhoc Adv Remained");
            IF (TotalRaAmount > AdhocStart) AND (TotalRaAmount <= AdhocEnd) THEN
                X := TotalRaAmount - AdhocStart
            ELSE IF (TotalRaAmount > AdhocEnd) THEN
                X := TotalRaAmount + "Total Order Value" - AdhocEnd;
            IF AdhocEnd <> 0 THEN
                "Adhoc Adv Amt" := X * Project."Adhoc Adv Remained" / AdhocEnd;
        END;

        MODIFY;
        //ALLESP BCL0005 19-09-2007 End:
    END;

    PROCEDURE CalculateTotalRAAmt(pRABillNo: Code[20]) Amt: Decimal;
    VAR
        CustLedEntry: Record "Cust. Ledger Entry";
        SalesInvHdr: Record "Sales Invoice Header";
    BEGIN
        //ALLESP BCL0005 19-09-2007 Start:
        SalesInvHdr.RESET;
        IF SalesInvHdr.GET(pRABillNo) THEN BEGIN
            CustLedEntry.RESET;
            CustLedEntry.SETRANGE("Document No.", pRABillNo);
            CustLedEntry.SETRANGE("Posting Date", SalesInvHdr."Posting Date");
            CustLedEntry.CALCFIELDS(CustLedEntry."Remaining Amt. (LCY)");
            IF CustLedEntry.FIND('-') THEN
                Amt += CustLedEntry."Remaining Amt. (LCY)";
            CalculateTotalRAAmt(SalesInvHdr."Last RA Bill No.");
        END;
        //ALLESP BCL0005 19-09-2007 End:
    END;


}