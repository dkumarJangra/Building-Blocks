tableextension 97016 "EPC Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        // Add changes to table fields here
        field(90050; "Active Stage"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 to link PO with Payment Stages--JPL';
            TableRelation = "Payment Terms Line"."Milestone Code" WHERE("Document Type" = FIELD("Document Type"),
                                                                         "Document No." = FIELD("No."));
            ValidateTableRelation = false;
        }
        field(50098; "Initiator User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(90051; "Last Stage Completed"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 to link PO with Payment Stages--JPL';
            TableRelation = "Payment Terms Line"."Milestone Code" WHERE("Document Type" = FIELD("Document Type"),
                                                                         "Document No." = FIELD("No."));
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                //JPL03

                IF "Document Type" = "Document Type"::Order THEN BEGIN
                    IF "Last Stage Completed" <> '' THEN BEGIN
                        PaymentTermLine.RESET;
                        PaymentTermLine.SETRANGE("Document Type", "Document Type");
                        PaymentTermLine.SETRANGE("Document No.", "No.");
                        PaymentTermLine.SETRANGE("Milestone Code", "Last Stage Completed");
                        IF PaymentTermLine.FIND('-') THEN BEGIN
                            VALIDATE("Payment Terms Code", PaymentTermLine."Payment Term Code");
                        END
                        ELSE
                            ERROR('Milestone Code does not exist.');
                    END;
                END;

                IF "Document Type" = "Document Type"::Invoice THEN BEGIN
                    IF "Last Stage Completed" <> '' THEN BEGIN
                        PaymentTermLine.RESET;
                        PaymentTermLine.SETRANGE("Document Type", "Document Type");
                        PaymentTermLine.SETRANGE("Document No.", "No.");
                        PaymentTermLine.SETRANGE("Milestone Code", "Last Stage Completed");
                        IF PaymentTermLine.FIND('-') THEN BEGIN
                            VALIDATE("Payment Terms Code", PaymentTermLine."Payment Term Code");
                        END
                        ELSE
                            ERROR('Milestone Code does not exist.');
                    END;
                END;

                //JPL03
            end;
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
        field(90055; "Received Invoice Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(90056; "Vendor Quotation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
            Enabled = false;
        }
        field(90057; "Default GL Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
            TableRelation = "G/L Account";
        }
        field(90058; "Work Tax Applicable"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
            Enabled = false;
        }
        field(90059; "Adjust Freight SrvTax Agst Adv"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
            Enabled = false;
        }
        field(90060; "Adjust Install SrvTax Agst Adv"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
            Enabled = false;
        }
        field(90062; "Advance Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Posting Type" = FILTER(Advance),
                                                                                  "Order Ref No." = FIELD("No.")));
            Description = 'JPL';
            Editable = false;
            Enabled = false;
            FieldClass = FlowField;
        }
        field(90063; "Running Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Posting Type" = FILTER(Running),
                                                                                  "Order Ref No." = FIELD("No.")));
            Description = 'JPL';
            Editable = false;
            Enabled = false;
            FieldClass = FlowField;
        }
        field(90064; "Retention Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Posting Type" = FILTER(Retention),
                                                                                  "Order Ref No." = FIELD("No.")));
            Description = 'JPL';
            Editable = false;
            Enabled = false;
            FieldClass = FlowField;
        }
        field(90065; "O/S Order Value"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Outstanding Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                          "Document No." = FIELD("No."),
                                                                          Blocked = FILTER(false)));
            Description = 'JPL';
            Editable = false;
            Enabled = false;
            FieldClass = FlowField;
        }
        field(90066; "SubCont Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90067; "SubCont End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90068; "Block Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90069; "R.A. Bill No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90070; "Property Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            TableRelation = Item."No." WHERE("Property Unit" = FILTER(true),
                                            "Job No." = FILTER(''));
        }
        field(90080; "Sent for Approval AWO"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEABAWO';
        }
        field(90081; "Sent for Approval AWO Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEABAWO';
        }
        field(90082; "Sent for Approval AWO Time"; Time)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEABAWO';
        }
        field(90083; "Last RA Bill No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLAA';
        }
        field(90084; "User ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(90085; "Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Job;

            trigger OnValidate()
            begin
                Job.GET("Job No.");
                Job.TestBlocked;
            end;
        }
        field(90086; "Store PO/WO No."; Code[30])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETG';
        }
        field(90087; "Billing Location"; Code[10])
        {
            Caption = 'Billing Location';
            DataClassification = ToBeClassified;
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(50009; "Sub Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
            OptionCaption = ' ,WO-ICB,WO-NICB,Regular PO,Repeat PO,Confirmatory PO,Direct PO';
            OptionMembers = " ","WO-ICB","WO-NICB","Regular PO","Repeat PO","Confirmatory PO","Direct PO","GRN for PO","GRN for JSPL","GRN for Packages","GRN for Fabricated Material for WO","JES for WO","GRN-Direct Purchase","Freight Advice",Quote;
        }
        field(50002; "Order Status"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Field Added to show Order Status as Cancelled, short closed or Completed--JPL';
            Editable = false;
            OptionMembers = " ",Cancelled,"Short Closed",Completed;
        }
        field(50099; "Workflow Sub Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            Editable = true;
            OptionCaption = ' ,FA,Regular,Direct,WorkOrder,Inward,Outward';
            OptionMembers = " ",FA,Regular,Direct,WorkOrder,Inward,Outward;

            trigger OnValidate()
            begin
                IF "Workflow Sub Document Type" = "Workflow Sub Document Type"::WorkOrder THEN
                    "Order Type" := "Order Type"::"Service Order"
            end;
        }
        field(50001; "Order Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0012 11-07-2007';
            OptionCaption = 'Normal Order,Work Order,Service Order';
            OptionMembers = "Normal Order","Work Order","Service Order";
        }
        field(50021; Amended; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(50022; "Amendment Approved"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';

            trigger OnValidate()
            begin
                CheckRequired; //JPL03 START
            end;
        }
        field(50003; Approved; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';

            trigger OnValidate()
            var
                PurchLineRec: Record "Purchase Line";
                DocSetup: Record "Document Type Setup";
            begin
                //IF Approved THEN  //051219 comment
                //  CheckRequired; //JPL03 START  051219
            end;
        }
        field(50007; "Ending Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(50016; "Sent for Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
            Editable = true;

            trigger OnValidate()
            begin
                CheckRequired; //JPL03 START
            end;
        }
        field(50019; "Sent for Approval Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(50020; "Sent for Approval Time"; Time)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(50004; "Approved Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(50005; "Approved Time"; Time)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(50112; "Approved Return"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLECK 070613';
        }
        field(50010; Initiator; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
            TableRelation = User;
        }
        field(50025; "Amendment Initiator"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(50023; "Amendment Approved Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(50024; "Amendment Approved Time"; Time)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(50116; "Land Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'BBG2.0';
            Editable = false;
        }
        field(50042; "Order Ref. No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FILTER(Order),
                                                         Status = FILTER(Released),
                                                         "Order Status" = FILTER(' '),
                                                         "Buy-from Vendor No." = FIELD("Buy-from Vendor No."),
                                                         "Responsibility Center" = FIELD("Responsibility Center"));

            trigger OnValidate()
            var
                RecPH: Record "Purchase Header";
                PaymentTermsLine1: Record "Payment Terms Line";
                PaymentTermsLine: Record "Payment Terms Line";
            begin
                RecPH.RESET;
                RecPH.SETRANGE(RecPH."No.", "Order Ref. No.");
                IF RecPH.FIND('-') THEN BEGIN
                    //MESSAGE('%1..%2',RecPH."No.","Order Ref. No.");
                    "Shortcut Dimension 2 Code" := RecPH."Shortcut Dimension 2 Code";
                    //MODIFY;
                END;

                //JPL03
                IF "Document Type" = "Document Type"::Invoice THEN BEGIN
                    PurchHeader.GET(PurchHeader."Document Type"::Order, "Order Ref. No.");
                    //dds-s to copy the payment terms code to invoice
                    VALIDATE("Payment Terms Code", PurchHeader."Payment Terms Code");
                    VALIDATE("Payment Method Code", PurchHeader."Payment Method Code");
                    IF PurchHeader."Land Document No." <> '' THEN
                        ValidateShortcutDimCode(5, PurchHeader."Land Document No.");
                    //AlleDK 250808
                    // VALIDATE("C Form", PurchHeader."C Form");
                    // VALIDATE("Form Code", PurchHeader."Form Code");
                    // VALIDATE("Form No.", PurchHeader."Form No.");
                    // //AlleDK 250808
                    // //ALLERP 30-11-2010:Start:
                    // VALIDATE(Structure, PurchHeader.Structure);
                    //ALLERP 30-11-2010:End:
                    ///VALIDATE("Sales Tax Extra",PurchHeader."Sales Tax Extra");
                    //VALIDATE("Excise Extra",PurchHeader."Excise Extra");
                    //VALIDATE("Service Tax- Freight Extra",PurchHeader."Service Tax- Freight Extra");
                    //VALIDATE("Service Tax- Intall Comm Extra",PurchHeader."Service Tax- Intall Comm Extra");
                    //VALIDATE("Octroi /Entry Tax Extra",PurchHeader."Octroi /Entry Tax Extra");
                    //VALIDATE("Freight Extra",PurchHeader."Freight Extra");
                    //VALIDATE("Installation Extra",PurchHeader."Installation Extra");
                    //dds-e
                    //===============================================================
                    //Copy Paymnet Term Line
                    PaymentTermsLine.RESET;
                    PaymentTermsLine.SETRANGE("Document Type", "Document Type");
                    PaymentTermsLine.SETRANGE("Document No.", "No.");
                    IF NOT PaymentTermsLine.FIND('-') THEN BEGIN

                        PaymentTermsLine.RESET;
                        PaymentTermsLine.SETRANGE("Document Type", PurchHeader."Document Type");
                        PaymentTermsLine.SETRANGE("Document No.", "Order Ref. No.");
                        IF PaymentTermsLine.FIND('-') THEN BEGIN
                            REPEAT
                                PaymentTermsLine1.INIT;
                                PaymentTermsLine1.TRANSFERFIELDS(PaymentTermsLine);
                                PaymentTermsLine1."Document Type" := "Document Type";
                                PaymentTermsLine1."Document No." := "No.";
                                PaymentTermsLine1."Payment Made" := FALSE;
                                PaymentTermsLine1.Adjust := FALSE;
                                PaymentTermsLine1."Transaction Type" := PaymentTermsLine1."Transaction Type"::Purchase;
                                //PaymentTermsLine1.VALIDATE("Criteria Value / Base Amount");
                                PaymentTermsLine1.INSERT(TRUE);
                                PaymentTermsLine1.VALIDATE("Criteria Value / Base Amount");
                                PaymentTermsLine1.MODIFY(TRUE);
                            UNTIL PaymentTermsLine.NEXT = 0;
                        END;
                    END;
                    //===============================================================
                    VALIDATE("Last Stage Completed", PurchHeader."Last Stage Completed");
                    VALIDATE("Shortcut Dimension 1 Code", PurchHeader."Shortcut Dimension 1 Code");
                    VALIDATE("Shortcut Dimension 2 Code", PurchHeader."Shortcut Dimension 2 Code");

                END;
                //JPL03 STOP
            end;
        }
        field(50006; "Starting Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(50039; Material; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL,KLND1.00  change option captions';
            OptionCaption = ' ,Free,Chargeable,Contractor';
            OptionMembers = " ",Free,Chargeable,Contractor;
        }
        field(50040; Consumables; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL,KLND1.00  change option captions';
            OptionCaption = ' ,Free,Chargeable,Contractor';
            OptionMembers = " ",Free,Chargeable,Contractor;
        }
        field(50013; "Vendor Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Alle VK VSID are added for Report Booking Voucher (ID 50025)--JPL';
        }
        field(70028; "Challan No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
            Editable = false;
        }
        field(70026; "Vehicle No.1"; Text[5])
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(70027; "UnPosted GRN No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(50109; "User Branch"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'BBG ALLEDK 180113';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('COLLCENTERS'));
        }
        field(50110; CommissionVoucher; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 180113';
            Editable = true;
        }
        field(50111; "Associate Posting Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Advance,Running,Retention,Secured Advance,Adhoc Advance,Provisional,LD,Mobilization Advance,Equipment Advance,,,,Commission,Travel Allowance,Bonanza,Incentive,CommAndTA';
            OptionMembers = " ",Advance,Running,Retention,"Secured Advance","Adhoc Advance",Provisional,LD,"Mobilization Advance","Equipment Advance",,,,Commission,"Travel Allowance",Bonanza,Incentive,CommAndTA;
        }
        field(50113; "From MS Company"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'BBG2.01 110115';
            Editable = false;
        }
        field(50107; "Cheque No."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 081212';
        }
        field(50108; "Cheque Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 081212';
        }
        field(50114; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70029; "Special Incentive Bonanza"; Boolean)
        {
            DataClassification = ToBeClassified;
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

    PROCEDURE CheckRequired()
    VAR
        PurchLineRec: Record "Purchase Line";
        DocSetup: Record "Document Type Setup";
        vJobAllocationReq: Boolean;
        vJobAllocation: Record "Job Allocation";
        vPurchLine: Record "Purchase Line";
        vJobAmt: Decimal;
        POHdrL: Record "Purchase Header";
        OldVendLedgEntry: Record "Vendor Ledger Entry";
    BEGIN
        //JPL03
        IF "Document Type" = "Document Type"::Order THEN BEGIN
            PurchSetup.GET;

            TESTFIELD("Buy-from Vendor No.");
            TESTFIELD("Pay-to Vendor No.");
            TESTFIELD("Posting Date");
            TESTFIELD("Document Date");
            //TESTFIELD("Shortcut Dimension 1 Code");
            //TESTFIELD("Shortcut Dimension 2 Code");
            TESTFIELD("Order Ref. No.");
            TESTFIELD("Starting Date");
            IF "Sub Document Type" = "Sub Document Type"::"WO-NICB" THEN
                TESTFIELD("Ending Date");
            //GKG
            //GKG

            IF "Sub Document Type" = "Sub Document Type"::"WO-NICB" THEN BEGIN
                TESTFIELD(Material);
                TESTFIELD(Consumables);
            END;

            PurchLineRec.RESET;
            PurchLineRec.SETRANGE("Document Type", "Document Type");
            PurchLineRec.SETRANGE("Document No.", "No.");
            PurchLineRec.FIND('-');

            DocSetup.GET(DocSetup."Document Type"::"Purchase Order", "Workflow Sub Document Type");
            IF DocSetup."Milestone Compulsory" THEN BEGIN
                PaymentTermLine.RESET;
                PaymentTermLine.SETRANGE("Document Type", "Document Type");
                PaymentTermLine.SETRANGE("Document No.", "No.");
                IF NOT PaymentTermLine.FIND('-') THEN
                    ERROR('Payment Milestones not defined !');
            END;
            PurchLineRec.RESET;
            PurchLineRec.SETRANGE("Document Type", "Document Type");
            PurchLineRec.SETRANGE("Document No.", "No.");
            PurchLineRec.SETFILTER(Type, '%1|%2|%3', PurchLineRec.Type::Item, PurchLineRec.Type::"G/L Account",
                                    PurchLineRec.Type::"Charge (Item)");
            IF PurchLineRec.FIND('-') THEN BEGIN
                REPEAT
                    PurchLineRec.TESTFIELD("Gen. Prod. Posting Group");
                    PurchLineRec.TESTFIELD("Gen. Bus. Posting Group");
                    //may 1.0
                    //PurchLineRec.TESTFIELD(Quantity);
                    PurchLineRec.TESTFIELD("Direct Unit Cost");
                    PurchLineRec.TESTFIELD("Shortcut Dimension 1 Code");
                    //PurchLineRec.TESTFIELD("Shortcut Dimension 2 Code");
                    IF PurchLineRec.Type = PurchLineRec.Type::Item THEN BEGIN
                        PurchLineRec.TESTFIELD("Unit of Measure Code");
                        PurchLineRec.TESTFIELD("Location Code");
                    END;
                UNTIL PurchLineRec.NEXT = 0;
            END;

            PurchLineRec.RESET;
            PurchLineRec.SETRANGE("Document Type", "Document Type");
            PurchLineRec.SETRANGE("Document No.", "No.");
            PurchLineRec.SETFILTER(Type, '%1|%2', PurchLineRec.Type::Item, PurchLineRec.Type::"G/L Account");
            PurchLineRec.SETFILTER("Line Amount", '>0');
            IF PurchLineRec.FIND('-') THEN BEGIN
                REPEAT
                    IF PurchSetup."Budget Check For PO Required" THEN BEGIN
                    END;
                    IF DocSetup."Indent Required" THEN BEGIN
                        PurchLineRec.TESTFIELD("Indent Line No");
                        PurchLineRec.TESTFIELD("Indent No");
                        PurchLineRec.CheckIndentT;
                    END;
                    // may 1.0 added condition
                    IF PurchLineRec."Quantity Received" = 0 THEN
                        PurchLineRec.TESTFIELD("Outstanding Quantity");
                UNTIL PurchLineRec.NEXT = 0;
            END;
        END;
        IF "Document Type" = "Document Type"::Invoice THEN BEGIN
            TESTFIELD("Buy-from Vendor No.");
            TESTFIELD("Pay-to Vendor No.");
            TESTFIELD("Posting Date");
            TESTFIELD("Document Date");
            TESTFIELD("Vendor Invoice No.");
            TESTFIELD("Vendor Invoice Date");

            //TESTFIELD("Shortcut Dimension 1 Code");
            //TESTFIELD("Shortcut Dimension 2 Code");
            //TESTFIELD("Order Ref. No.");

            PurchSetup.GET;
            //Check Applies to doc and applies to id both are not specified
            IF ("Applies-to Doc. No." <> '') AND ("Applies-to ID" <> '') THEN
                ERROR('Applies-to Doc. No. and Applies-to ID cannot be filled together.');

            //Check Vendor Invoice No is not Duplicate
            OldVendLedgEntry.RESET;
            OldVendLedgEntry.SETCURRENTKEY("External Document No.", "Document Type", "Vendor No.");
            OldVendLedgEntry.SETRANGE("External Document No.", "Vendor Invoice No.");
            OldVendLedgEntry.SETRANGE("Document Type", OldVendLedgEntry."Document Type"::Invoice);
            OldVendLedgEntry.SETRANGE("Vendor No.", "Pay-to Vendor No.");
            IF OldVendLedgEntry.FIND('-') THEN
                ERROR('Vendor Invoice No. %1 already exists.', "Vendor Invoice No.");


            PurchLineRec.RESET;
            PurchLineRec.SETRANGE("Document Type", "Document Type");
            PurchLineRec.SETRANGE("Document No.", "No.");
            PurchLineRec.FIND('-');

            PurchLineRec.RESET;
            PurchLineRec.SETRANGE("Document Type", "Document Type");
            PurchLineRec.SETRANGE("Document No.", "No.");
            PurchLineRec.SETFILTER(Type, '%1|%2|%3', PurchLineRec.Type::Item, PurchLineRec.Type::"G/L Account",
                                    PurchLineRec.Type::"Charge (Item)");
            IF PurchLineRec.FIND('-') THEN BEGIN
                REPEAT
                    PurchLineRec.TESTFIELD("Gen. Prod. Posting Group");
                    PurchLineRec.TESTFIELD("Gen. Bus. Posting Group");
                    //may 1.1
                    //PurchLineRec.TESTFIELD(Quantity);
                    PurchLineRec.TESTFIELD("Direct Unit Cost");
                    PurchLineRec.TESTFIELD("Shortcut Dimension 1 Code");
                    //PurchLineRec.TESTFIELD("Shortcut Dimension 2 Code");
                    IF PurchLineRec.Type = PurchLineRec.Type::Item THEN BEGIN
                        PurchLineRec.TESTFIELD("Unit of Measure Code");
                        PurchLineRec.TESTFIELD("Location Code");
                    END;
                    PurchLineRec.TESTFIELD("Qty. to Invoice");

                UNTIL PurchLineRec.NEXT = 0;
            END;

            //Check TDS Nature of Deduction
            PurchLineRec.RESET;
            PurchLineRec.SETRANGE("Document Type", "Document Type"::Order);
            PurchLineRec.SETRANGE("Document No.", "Order Ref. No.");
            PurchLineRec.SETFILTER(Type, '%1|%2|%3', PurchLineRec.Type::Item, PurchLineRec.Type::"G/L Account",
                                    PurchLineRec.Type::"Charge (Item)");
            PurchLineRec.SETFILTER("TDS Section Code", '<>%1', '');
            IF PurchLineRec.FIND('-') THEN BEGIN
                IF CONFIRM('IF you have not applied payments, do you want to apply?', FALSE) THEN
                    ERROR('');

            END;

            //JPL44 START
            IF POHdrL.GET(POHdrL."Document Type"::Order, "Order Ref. No.") THEN BEGIN
                DocTypSetup.GET(DocTypSetup."Document Type"::"Purchase Order", POHdrL."Sub Document Type");
                IF DocTypSetup."Job Allocation" THEN BEGIN
                    vJobAllocationReq := FALSE;
                    IF "Document Type" = "Document Type"::Invoice THEN BEGIN
                        vJobAllocation.RESET;
                        vJobAllocation.SETRANGE("Document Type", "Document Type");
                        vJobAllocation.SETRANGE("Document No.", "No.");
                        IF vJobAllocation.FIND('-') THEN BEGIN
                            vJobAllocationReq := TRUE;
                            vPurchLine.RESET;
                            vPurchLine.SETRANGE("Document Type", "Document Type");
                            vPurchLine.SETRANGE("Document No.", "No.");
                            vPurchLine.SETRANGE(Type, vPurchLine.Type::"G/L Account");
                            vPurchLine.SETFILTER(Amount, '<>0');
                            IF vPurchLine.FIND('-') THEN BEGIN
                                REPEAT
                                    vJobAmt := 0;
                                    vJobAllocation.RESET;
                                    vJobAllocation.SETRANGE("Document Type", "Document Type");
                                    vJobAllocation.SETRANGE("Document No.", "No.");
                                    vJobAllocation.SETRANGE("Line No.", vPurchLine."Line No.");
                                    IF vJobAllocation.FIND('-') THEN
                                        REPEAT

                                            vJobAllocation.TESTFIELD(vJobAllocation."GL Account No.");
                                            vJobAllocation.TESTFIELD("Shortcut Dimension 1 Code");
                                            vJobAllocation.TESTFIELD("Shortcut Dimension 2 Code");

                                            vJobAmt := vJobAmt + vJobAllocation.Amount;
                                        UNTIL vJobAllocation.NEXT = 0;
                                    IF vJobAmt <> vPurchLine."Line Amount" THEN
                                        ERROR('Job Allocation Amount and Line Amount does not match,' +
                                            'Job Allocation Amount = %1 and Line amount = %2', vJobAmt, vPurchLine."Line Amount");
                                //vPurchLine.TESTFIELD("Line Amount",vJobAmt);
                                UNTIL vPurchLine.NEXT = 0;
                            END;
                        END
                        ELSE
                            ERROR('Job Allocation is missing.');
                    END;

                END;
            END;
            //JPL44 stop

        END;
    END;

}