tableextension 50014 "BBG Purchase Line Ext" extends "Purchase Line"
{
    fields
    {
        // Add changes to table fields here
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                //JPL03 Start
                IF Type = Type::"G/L Account" THEN BEGIN
                    IF (xRec."No." <> '') AND (xRec."No." <> Rec."No.")
                       AND ("Line No." = xRec."Line No.") THEN BEGIN     // Alle SP COde added to retain certain parameters
                        VALIDATE(Description, xRec.Description);
                        VALIDATE("Description 2", xRec."Description 2");
                        VALIDATE("Shortcut Dimension 1 Code", xRec."Shortcut Dimension 1 Code");
                        VALIDATE("Shortcut Dimension 2 Code", xRec."Shortcut Dimension 2 Code");
                        VALIDATE("Unit of Measure Code", xRec."Unit of Measure Code");
                        VALIDATE(Quantity, xRec.Quantity);
                        VALIDATE("Direct Unit Cost", xRec."Direct Unit Cost");
                        "Gen. Prod. Posting Group" := xRec."Gen. Prod. Posting Group";
                        "Job Code" := xRec."Job Code";
                    END;
                END;
                //JPL03 STOP
            end;
        }
        modify("Location Code")
        {
            trigger OnBeforeValidate()
            Begin
                TestStatusOpen; // GKG
            End;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin

                //JPL05 Start
                CalculateDirectUnitCost;//JPL04
                IF "Document Type" = "Document Type"::Order THEN BEGIN
                    VALIDATE("Qty. to Receive", 0);
                    VALIDATE("Return Qty. to Ship", 0);
                    InitQtyToInvoice;
                END;
                //JPL05 STOP

                //ALLETG RIL0011 22-06-2011: START>>
                PurchDeliverySchedule2.RESET;
                PurchDeliverySchedule2.SETRANGE("Document Type", "Document Type");
                PurchDeliverySchedule2.SETRANGE("Document No.", "Document No.");
                PurchDeliverySchedule2.SETRANGE("Document Line No.", "Line No.");
                IF PurchDeliverySchedule2.COUNT = 1 THEN BEGIN
                    IF PurchDeliverySchedule2.FINDLAST THEN BEGIN
                        PurchDeliverySchedule2."Schedule Quantity" := Quantity;
                        PurchDeliverySchedule2.CALCFIELDS("Received Quantity");
                        PurchDeliverySchedule2."Remaining Quantity" := PurchDeliverySchedule2."Schedule Quantity" -
                          PurchDeliverySchedule2."Received Quantity";
                        PurchDeliverySchedule2.MODIFY;
                    END ELSE
                        InsertDlvrSchdLines(Rec);
                END;
                //ALLETG RIL0011 22-06-2011: END<<
            end;
        }
        modify("Shortcut Dimension 2 Code")
        {
            trigger OnBeforeValidate()
            var
                GeneralLedgerSetup: Record "General Ledger Setup";
            begin
                //ALLE-PKS19
                GeneralLedgerSetup.GET;
                GeneralLedgerSetup.TESTFIELD("Shortcut Dimension 2 Code");
                IF Type = Type::Item THEN BEGIN
                    IF "Document Type" = "Document Type"::Order THEN BEGIN
                        DefDimRec.RESET;
                        DefDimRec.GET(27, "No.", GeneralLedgerSetup."Shortcut Dimension 2 Code");//'COST Code');
                        "Shortcut Dimension 2 Code" := DefDimRec."Dimension Value Code";
                    END;
                END;
                //ALLE-PKS19
            end;

        }
        modify("Responsibility Center")
        {
            TableRelation = "Responsibility Center 1";
        }
        field(50000; "FA Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEPG 270911';
            TableRelation = "Fixed Asset Sub Group"."FA Code";
        }
        field(50001; "Enquiry No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
        }
        field(50002; "Enquiry Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
        }




        field(50010; "SL No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0012 10-07-2007';
        }
        field(50041; "Tollerence Used"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ND 261205--JPL';
        }

        field(50062; "Land Expense Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
        }


        field(50065; "Sale Deed No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50066; "Date of Registration"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(60000; "Check FA item"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLk';
        }
        field(70000; "Order Status"; Option)
        {
            CalcFormula = Lookup("Purchase Header"."Order Status" WHERE("Document Type" = FIELD("Document Type"),
                                                                         "No." = FIELD("Document No.")));
            Description = 'Field Added as a lookup to the Sales Header Order Status as Cancelled, Short Closed or Completed - ALLE SP 3/08/05--JPL';
            Editable = false;
            FieldClass = FlowField;
            OptionMembers = " ",Cancelled,"Short Closed",Completed;
        }


        field(70003; "Approved Date"; Date)
        {
            CalcFormula = Lookup("Purchase Header"."Approved Date" WHERE("Document Type" = FIELD("Document Type"),
                                                                          "No." = FIELD("Document No.")));
            Description = 'SC JPL';
            FieldClass = FlowField;
        }




        field(80000; "Manufacturer Code"; Code[10])
        {
            Caption = 'Manufacturer Code';
            DataClassification = ToBeClassified;
            Description = 'ALLE-PKS 28';
            TableRelation = Manufacturer;
        }
        field(80001; "Qty Since Last Bill"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAA';
        }

        field(80003; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAA';
        }
        field(80005; "BOQ Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAA';
        }
        field(80006; "Manual Work Tax"; Boolean)
        {
            Caption = 'Manual Work Tax';
            DataClassification = ToBeClassified;
            Description = 'ALLEAA';
        }
        field(80007; "Job Contract Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAA';
        }
        field(80008; "Part Rate"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEPG 190509';
        }

        field(80020; "Ref. Gift Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEPG 190509';
            TableRelation = Item;
            trigger OnValidate()
            var
                myInt: Integer;
                Unitsetup: Record "Unit Setup";
                PurchLines: Record "Purchase Line";
            begin
                IF Rec."Document Type" = Rec."Document Type"::Invoice THEN begin
                    Unitsetup.GET;
                    If Unitsetup."Gift Control A/c" <> '' THEN BEGIN
                        TestField(rec.Type, rec.Type::"G/L Account");
                        IF Rec."No." <> Unitsetup."Gift Control A/c" then
                            Error('This field is use for Gift control A/C only');

                    END;
                end;
            end;
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
        PurchHeader: Record "Purchase Header";
        PurchDeliverySchedule: Record "Purch. Delivery Schedule";
        IndentLine: Record "Purchase Request Line";
        ExcessQty: Decimal;
        Itemrec: Record Item;
        POLineRec1: Record "Purchase Line";
        GRNLRec: Record "GRN Line";
        POLineRec: Record "Purchase Line";
        PurLineRec: Record "Purchase Line";
        PurchDeliverySchedule2: Record "Purch. Delivery Schedule";
        DefDimRec2: Record "Default Dimension";
        DefDimRec: Record "Default Dimension";
        DocSetup: Record "Document Type Setup";
        IndentLineForm: Page "Purchase Request Lines List";
        PANErr: Label 'ENU=PAN No. must be entered.';
        TotalPurchaseLine: Record "Purchase Line";

    trigger OnAfterInsert()
    Begin
        //ALLETG RIL0011 22-06-2011: START>>
        InsertDlvrSchdLines(Rec);
        //ALLETG RIL0011 22-06-2011: END<<
    End;

    trigger OnAfterModify()
    begin

        //ALLETG RIL0011 22-06-2011: START>>
        IF ((Type <> xRec.Type) OR ("No." <> xRec."No.")) THEN BEGIN
            PurchDeliverySchedule.RESET;
            PurchDeliverySchedule.SETRANGE("Document Type", "Document Type");
            PurchDeliverySchedule.SETRANGE("Document No.", "Document No.");
            PurchDeliverySchedule.SETRANGE("Document Line No.", "Line No.");
            IF PurchDeliverySchedule.FINDSET THEN BEGIN
                REPEAT
                    PurchDeliverySchedule.Type := Type;
                    PurchDeliverySchedule."No." := "No.";
                    PurchDeliverySchedule.Description := Description;
                    PurchDeliverySchedule."Description 2" := "Description 2";
                    PurchDeliverySchedule."Description 3" := "Description 3";
                    PurchDeliverySchedule.MODIFY;
                UNTIL PurchDeliverySchedule.NEXT = 0;
            END;
        END;
        //ALLETG RIL0011 22-06-2011: END<<
    end;

    trigger OnAfterDelete()
    begin

        //ALLETG RIL0011 22-06-2011: START>>
        PurchDeliverySchedule.RESET;
        PurchDeliverySchedule.SETRANGE("Document Type", "Document Type");
        PurchDeliverySchedule.SETRANGE("Document No.", "Document No.");
        PurchDeliverySchedule.SETRANGE("Document Line No.", "Line No.");
        PurchDeliverySchedule.DELETEALL(TRUE);
        //ALLETG RIL0011 22-06-2011: END<<
    end;

    PROCEDURE CheckPOSendForApprovalFields(RecPurchHeader: Record "Purchase Header")
    VAR
        PurchLine: Record "Purchase Line";
        Loc: Record Location;
    BEGIN
        // ALLEPG 100409 Start
        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type", "Document Type"::Order);
        PurchLine.SETRANGE("Document No.", RecPurchHeader."No.");
        IF PurchLine.FINDFIRST THEN
            REPEAT
                IF Loc.GET(RecPurchHeader."Location Code") THEN BEGIN
                    IF (Loc."Bin Mandatory") AND (PurchLine.Type <> PurchLine.Type::"G/L Account") THEN
                        PurchLine.TESTFIELD("Bin Code");
                END;
                // ALLEAA
                IF (PurchLine."Buy-from Vendor No." = '') AND (PurchLine."No." = '') AND (PurchLine.Description = '')
                  AND (PurchLine."Description 2" = '')
                THEN
                    PurchLine.TESTFIELD("No.");
            // ALLEAA
            UNTIL PurchLine.NEXT = 0;
        // ALLEPG 100409 End
    END;

    PROCEDURE CheckWOSendForApprovalFields(RecPurchHeader: Record "Purchase Header")
    VAR
        PurchLine: Record "Purchase Line";
        Loc: Record Location;
    BEGIN
        // ALLEPG 100409 Start
        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type", "Document Type"::Order);
        PurchLine.SETRANGE("Document No.", RecPurchHeader."No.");
        IF PurchLine.FINDFIRST THEN
            REPEAT
                IF Loc.GET(RecPurchHeader."Location Code") THEN BEGIN
                    IF PurchLine.Quantity <> 0 THEN
                        PurchLine.TESTFIELD("Job Task No.");
                    //    PurchLine.TESTFIELD("Work Center No.");
                END
            UNTIL PurchLine.NEXT = 0;
        // ALLEPG 100409 End
    END;

    PROCEDURE ShowDeliveryScheduleLines()
    VAR
        PurchaseDeliverySchedule: Record "Purch. Delivery Schedule";
        FrmPurchaseDeliverySchedule: Page "Purchase Delivery Schedules";
    BEGIN
        //ALLETG RIL0011 22-06-2011
        PurchaseDeliverySchedule.RESET;
        PurchaseDeliverySchedule.SETRANGE("Document Type", "Document Type");
        PurchaseDeliverySchedule.SETRANGE("Document No.", "Document No.");
        PurchaseDeliverySchedule.SETRANGE("Document Line No.", "Line No.");
        FrmPurchaseDeliverySchedule.SETTABLEVIEW(PurchaseDeliverySchedule);
        FrmPurchaseDeliverySchedule.SETRECORD(PurchaseDeliverySchedule);
        IF FrmPurchaseDeliverySchedule.RUNMODAL = ACTION::LookupOK THEN
            FrmPurchaseDeliverySchedule.GETRECORD(PurchaseDeliverySchedule);
    END;






    PROCEDURE CalculateDirectUnitCost()
    BEGIN
        //JPL04 START
        VALIDATE("Direct Unit Cost");
        IF "Document Type" = "Document Type"::Order THEN;
        //JPL04 STOP
    END;



    PROCEDURE GetIndentLines()
    BEGIN
        //JPL09 START
        PurchHeader.GET("Document Type", "Document No.");
        IndentLine.RESET;
        IndentLine.FILTERGROUP := 2;
        IndentLine.SETRANGE("Document Type", IndentLine."Document Type"::Indent);
        IndentLine.SETRANGE(Approved, TRUE);
        IndentLine.SETRANGE("Indent Status", IndentLine."Indent Status"::Open);
        IndentLine.SETRANGE("Responsibility Center", PurchHeader."Responsibility Center");
        IndentLine.FILTERGROUP := 0;
        IndentLine.CALCFIELDS("PO Qty");
        IF IndentLine.FIND('-') THEN
            REPEAT
                IndentLine.CALCFIELDS("PO Qty");
                IndentLine.CALCFIELDS("TO Qty");
                IF (IndentLine."PO Qty" + IndentLine."TO Qty" < IndentLine."Quantity Base") THEN
                    IndentLine.MARK(TRUE);
            UNTIL IndentLine.NEXT = 0;
        IndentLine.MARKEDONLY(TRUE);
        IF IndentLine.FIND('-') THEN BEGIN
            CLEAR(IndentLineForm);
            IndentLineForm.SETTABLEVIEW(IndentLine);
            IndentLineForm.LOOKUPMODE := TRUE;
            IndentLineForm.SetPurchHeader(PurchHeader);
            IndentLineForm.SetPOMode(TRUE);
            IndentLineForm.RUNMODAL;
        END;
        //JPL09 STOP
    END;

    PROCEDURE GetIndentForQuots()
    BEGIN
        //ALLESP BCL0001 04-07-2007 Start: This function is used on Purchase Quotation for getting the Indented Items
        PurchHeader.RESET;
        PurchHeader.GET("Document Type", "Document No.");
        IndentLine.RESET;
        IndentLine.FILTERGROUP := 2;
        IndentLine.SETRANGE("Document Type", IndentLine."Document Type"::Indent);
        IndentLine.SETRANGE("Indent Status", IndentLine."Indent Status"::Open);
        IndentLine.SETRANGE("Location code", PurchHeader."Location Code");
        IndentLine.SETRANGE("Approval Status", IndentLine."Approval Status"::Approved);
        IndentLine.FILTERGROUP := 0;
        IndentLine.CALCFIELDS("PO Qty");
        IF IndentLine.FIND('-') THEN
            REPEAT
                IndentLine.MARK(TRUE);
            UNTIL IndentLine.NEXT = 0;
        IndentLine.MARKEDONLY(TRUE);
        IF IndentLine.FIND('-') THEN BEGIN
            CLEAR(IndentLineForm);
            IndentLineForm.SETTABLEVIEW(IndentLine);
            IndentLineForm.LOOKUPMODE := TRUE;
            IndentLineForm.SetPurchHeader(PurchHeader);
            IndentLineForm.SetPOMode(TRUE);
            IndentLineForm.RUNMODAL;
        END;
        //ALLESP BCL0001 04-07-2007 End:
    END;

    PROCEDURE OpenMaterialForm()
    VAR
        FMaterialProp: Page "Material Properties";
        MaterialProp: Record "Quote Properties";
    BEGIN
        MaterialProp.RESET;
        MaterialProp.SETRANGE("Document Type", "Document Type");
        MaterialProp.SETRANGE("Document No.", "Document No.");
        MaterialProp.SETRANGE("Line No.", "Line No.");
        FMaterialProp.SETTABLEVIEW(MaterialProp);
        FMaterialProp.RUNMODAL;
    END;

    LOCAL PROCEDURE UpdateTDSAdjustmentEntry(PurchaseLine: Record "Purchase Line"; VAR PreviousAmount1: Decimal; VAR InvoiceAmt1: Decimal; VAR PaymentAmt1: Decimal; VAR PreviousTDSAmt1: Decimal; AccountingPeriodFilter: Text[30])
    VAR
        TDSEntry: Record "TDS Entry";// 13729;
        Vendor: Record Vendor;
    BEGIN
        Vendor.GET(PurchaseLine."Pay-to Vendor No.");
        TDSEntry.RESET;
        TDSEntry.SETCURRENTKEY("Party Type", "Party Code", "Posting Date", "Assessee Code", Applied);//"TDS Group", 
        TDSEntry.SETRANGE("Party Type", TDSEntry."Party Type"::Vendor);
        IF (Vendor."P.A.N. No." = '') OR (Vendor."P.A.N. Status" <> Vendor."P.A.N. Status"::" ") THEN // >>ALLE.TDS-REGEF
            TDSEntry.SETRANGE("Party Code", PurchaseLine."Pay-to Vendor No.");
        // ELSE
        //     TDSEntry.SETRANGE("Deductee P.A.N. No.", Vendor."P.A.N. No.");
        TDSEntry.SETFILTER("Posting Date", AccountingPeriodFilter);
        // TDSEntry.SETRANGE("TDS Group", "TDS Group");
        //TDSEntry.SETRANGE("Assessee Code", "Assessee Code");
        TDSEntry.SETRANGE(Applied, FALSE);
        TDSEntry.SETRANGE("TDS Adjustment", FALSE);
        TDSEntry.SETRANGE(Adjusted, FALSE);
        IF TDSEntry.FINDFIRST THEN BEGIN
            //  TDSEntry.CALCSUMS("Invoice Amount", "Service Tax Including eCess");
            PreviousAmount1 := ABS(TDSEntry."Invoice Amount");//+ ABS(TDSEntry."Service Tax Including eCess")
        END;

        TDSEntry.RESET;
        TDSEntry.SETCURRENTKEY("Party Type", "Party Code", "Posting Date", "Assessee Code", "Document Type");//"TDS Group", 
        TDSEntry.SETRANGE("Party Type", TDSEntry."Party Type"::Vendor);
        IF (Vendor."P.A.N. No." = '') OR (Vendor."P.A.N. Status" <> Vendor."P.A.N. Status"::" ") THEN // >>ALLE.TDS-REGEF
            TDSEntry.SETRANGE("Party Code", PurchaseLine."Pay-to Vendor No.");
        // ELSE
        //     TDSEntry.SETRANGE("Deductee P.A.N. No.", Vendor."P.A.N. No.");
        TDSEntry.SETFILTER("Posting Date", AccountingPeriodFilter);
        //TDSEntry.SETRANGE("TDS Group", "TDS Group");
        //TDSEntry.SETRANGE("Assessee Code", "Assessee Code");
        TDSEntry.SETRANGE("Document Type", TDSEntry."Document Type"::Invoice);
        TDSEntry.SETRANGE("TDS Adjustment", FALSE);
        TDSEntry.SETRANGE(Adjusted, FALSE);
        IF TDSEntry.FINDFIRST THEN BEGIN
            //TDSEntry.CALCSUMS("Invoice Amount", "Service Tax Including eCess");
            InvoiceAmt1 := ABS(TDSEntry."Invoice Amount");//+ ABS(TDSEntry."Service Tax Including eCess")
        END;

        TDSEntry.RESET;
        TDSEntry.SETCURRENTKEY("Party Type", "Party Code", "Posting Date", "Assessee Code", "Document Type");//"TDS Group", 
        TDSEntry.SETRANGE("Party Type", TDSEntry."Party Type"::Vendor);
        IF (Vendor."P.A.N. No." = '') OR (Vendor."P.A.N. Status" <> Vendor."P.A.N. Status"::" ") THEN // >>ALLE.TDS-REGEF
            TDSEntry.SETRANGE("Party Code", PurchaseLine."Pay-to Vendor No.");
        // ELSE
        //     TDSEntry.SETRANGE("Deductee P.A.N. No.", Vendor."P.A.N. No.");
        TDSEntry.SETFILTER("Posting Date", AccountingPeriodFilter);
        //TDSEntry.SETRANGE("TDS Group", "TDS Group");
        //TDSEntry.SETRANGE("Assessee Code", "Assessee Code");
        TDSEntry.SETRANGE("Document Type", TDSEntry."Document Type"::Payment);
        TDSEntry.SETRANGE("TDS Adjustment", FALSE);
        TDSEntry.SETRANGE(Adjusted, FALSE);
        IF TDSEntry.FINDFIRST THEN BEGIN
            //TDSEntry.CALCSUMS("Invoice Amount", "Service Tax Including eCess");
            PaymentAmt1 := ABS(TDSEntry."Invoice Amount");// + ABS(TDSEntry."Service Tax Including eCess")
        END;

        PreviousAmount1 := PaymentAmt1 + InvoiceAmt1;

        TDSEntry.RESET;
        TDSEntry.SETCURRENTKEY("Party Type", "Party Code", "Posting Date", "Assessee Code");//, "TDS Group"
        TDSEntry.SETRANGE("Party Type", TDSEntry."Party Type"::Vendor);
        IF (Vendor."P.A.N. No." = '') OR (Vendor."P.A.N. Status" <> Vendor."P.A.N. Status"::" ") THEN // >>ALLE.TDS-REGEF
            TDSEntry.SETRANGE("Party Code", PurchaseLine."Pay-to Vendor No.");
        // ELSE
        //     TDSEntry.SETRANGE("Deductee P.A.N. No.", Vendor."P.A.N. No.");
        TDSEntry.SETFILTER("Posting Date", AccountingPeriodFilter);
        // TDSEntry.SETRANGE("TDS Group", "TDS Group");
        // TDSEntry.SETRANGE("Assessee Code", Rec."Assessee Code");
        TDSEntry.SETRANGE(Adjusted, TRUE);
        IF TDSEntry.FINDFIRST THEN BEGIN
            TDSEntry.CALCSUMS("TDS Amount", "Surcharge Amount");
            PreviousTDSAmt1 := ABS(TDSEntry."TDS Amount");
        END;
    END;

    LOCAL PROCEDURE FilterTDSEntry(PurchaseLine: Record "Purchase Line"; VAR TDSEntry: Record "TDS Entry"; AccountingPeriodFilter: Text[30]) // 13729;
    VAR
        Vendor: Record Vendor;
    BEGIN
        Vendor.GET(PurchaseLine."Pay-to Vendor No.");
        TDSEntry.RESET;
        TDSEntry.SETCURRENTKEY(
          "Party Type", "Party Code", "Posting Date", "Assessee Code", Applied);//"TDS Group",
        TDSEntry.SETRANGE("Party Type", TDSEntry."Party Type"::Vendor);
        IF (Vendor."P.A.N. No." = '') OR (Vendor."P.A.N. Status" <> Vendor."P.A.N. Status"::" ") THEN // >>ALLE.TDS-REGEF
            TDSEntry.SETRANGE("Party Code", PurchaseLine."Pay-to Vendor No.");
        // ELSE
        //     TDSEntry.SETRANGE("Deductee P.A.N. No.", Vendor."P.A.N. No.");
        TDSEntry.SETFILTER("Posting Date", AccountingPeriodFilter);
        // TDSEntry.SETRANGE("TDS Group", "TDS Group");
        // TDSEntry.SETRANGE("Assessee Code", "Assessee Code");
        TDSEntry.SETRANGE("TDS Adjustment", FALSE);
        TDSEntry.SETRANGE(Adjusted, FALSE);
    END;

    LOCAL PROCEDURE FilterTDSEntry1(VAR TDSEntry: Record "TDS Entry"; PurchaseLine: Record "Purchase Line"; AccountingPeriodFilter: Text[30])
    VAR
        Vendor: Record Vendor;
    BEGIN
        Vendor.GET(PurchaseLine."Pay-to Vendor No.");
        TDSEntry.RESET;
        TDSEntry.SETCURRENTKEY("Party Type", "Party Code", "Posting Date", "Assessee Code", Applied); // "TDS Group",
        TDSEntry.SETRANGE("Party Type", TDSEntry."Party Type"::Vendor);
        IF (Vendor."P.A.N. No." = '') OR (Vendor."P.A.N. Status" <> Vendor."P.A.N. Status"::" ") THEN // >>ALLE.TDS-REGEF
            TDSEntry.SETRANGE("Party Code", PurchaseLine."Pay-to Vendor No.");
        // ELSE
        //     TDSEntry.SETRANGE("Deductee P.A.N. No.", Vendor."P.A.N. No.");
        TDSEntry.SETFILTER("Posting Date", AccountingPeriodFilter);
        // TDSEntry.SETRANGE("TDS Group", "TDS Group");
        // TDSEntry.SETRANGE("Assessee Code", "Assessee Code");
        TDSEntry.SETRANGE(Applied, FALSE);
        TDSEntry.SETFILTER("Bal. TDS Including SHE CESS", '<>%1', 0);
    END;

    LOCAL PROCEDURE FilterTDSEntry2(VAR TDSEntry: Record "TDS Entry"; PurchaseLine: Record "Purchase Line"; AccountingPeriodFilter: Text[30])
    VAR
        Vendor: Record Vendor;
    BEGIN
        Vendor.GET(PurchaseLine."Pay-to Vendor No.");
        TDSEntry.RESET;
        TDSEntry.SETCURRENTKEY(
          "Party Type", "Party Code", "Posting Date", "Assessee Code", Applied);// "TDS Group",
        TDSEntry.SETRANGE("Party Type", TDSEntry."Party Type"::Vendor);
        IF (Vendor."P.A.N. No." = '') OR (Vendor."P.A.N. Status" <> Vendor."P.A.N. Status"::" ") THEN // >>ALLE.TDS-REGEF
            TDSEntry.SETRANGE("Party Code", PurchaseLine."Pay-to Vendor No.");
        // ELSE
        //     TDSEntry.SETRANGE("Deductee P.A.N. No.", Vendor."P.A.N. No.");
        TDSEntry.SETFILTER("Posting Date", AccountingPeriodFilter);
        // TDSEntry.SETRANGE("TDS Group", "TDS Group");
        // TDSEntry.SETRANGE("Assessee Code", "Assessee Code");
        TDSEntry.SETRANGE("Bal. TDS Including SHE CESS", 0);
        TDSEntry.SETFILTER("TDS Line Amount", '>%1', 0);
        TDSEntry.SETRANGE(Applied, FALSE);
        TDSEntry.SETRANGE("TDS Adjustment", FALSE);
        TDSEntry.SETRANGE(Adjusted, FALSE);
    END;

    LOCAL PROCEDURE CalcTDSBaseAmt(PreviousAmount: Decimal; TDSBaseLCY: Decimal; AppliedAmount: Decimal; CurrentPOAmount: Decimal; VAR TDSBaseAmount: Decimal)
    BEGIN
        TDSBaseAmount := PreviousAmount + TDSBaseLCY - ABS(AppliedAmount) + CurrentPOAmount;
        IF CurrentPOAmount >= ABS(AppliedAmount) THEN
            TDSBaseAmount := TDSBaseLCY;
    END;

    LOCAL PROCEDURE ExchangeTDSAmtLCYToFCY(VAR PurchaseLine: Record "Purchase Line"; PurchaseHeader: Record "Purchase Header"; CurrFactor: Decimal);
    BEGIN
        // WITH PurchaseLine DO BEGIN
        //     "TDS Amount" :=
        //       ROUND(
        //         CurrExchRate.ExchangeAmtLCYToFCY(PurchaseHeader."Posting Date", "Currency Code",
        //           "TDS Amount", CurrFactor));
        //     "Surcharge Amount" :=
        //       ROUND(
        //         CurrExchRate.ExchangeAmtLCYToFCY(PurchaseHeader."Posting Date", "Currency Code",
        //           "Surcharge Amount", CurrFactor));
        //     "TDS Amount Including Surcharge" :=
        //       ROUND(
        //         CurrExchRate.ExchangeAmtLCYToFCY(PurchaseHeader."Posting Date", "Currency Code",
        //           "TDS Amount Including Surcharge", CurrFactor));
        //     "eCESS on TDS Amount" :=
        //       ROUND(
        //         CurrExchRate.ExchangeAmtLCYToFCY(PurchaseHeader."Posting Date", "Currency Code",
        //           "eCESS on TDS Amount", CurrFactor));
        //     "SHE Cess on TDS Amount" :=
        //       ROUND(
        //         CurrExchRate.ExchangeAmtLCYToFCY(
        //           PurchaseHeader."Posting Date", "Currency Code",
        //           "SHE Cess on TDS Amount", CurrFactor));
        //     "Total TDS Including SHE CESS" :=
        //       ROUND(
        //         CurrExchRate.ExchangeAmtLCYToFCY(PurchaseHeader."Posting Date", "Currency Code",
        //           "Total TDS Including SHE CESS", CurrFactor));
        // END;
    END;

    LOCAL PROCEDURE CalcAppliedAmtDocIncGST(VAR AppliedAmountDocIncGST: Decimal; PurchaseHeader: Record "Purchase Header"; PurchaseLine: Record "Purchase Line");
    BEGIN
        /*
        IF GSTManagement.IsGSTApplicable(PurchaseHeader.Structure) THEN BEGIN
            AppliedAmountDocIncGST := 0;
            CheckTDSValidation(PurchaseHeader);
            AppliedAmountDocIncGST := GetAppliedDocAmount(PurchaseHeader, PurchaseLine);
            IF PurchaseHeader."Currency Code" <> '' THEN
                AppliedAmountDocIncGST := ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      PurchaseHeader."Posting Date", PurchaseHeader."Currency Code",
                      AppliedAmountDocIncGST, PurchaseHeader."Currency Factor"));
        END;
        */
    END;
    /*
    LOCAL PROCEDURE CalcBlankTDSAppliedAmt(VAR PurchLine: Record 39; NodNocLines1: Record 13785; AccountingPeriodFilter: Text[30]; TDSBaseLCY: Decimal; CurrentPOAmount: Decimal; CurrentPOContractAmt: Decimal)
    VAR
        PurchaseHeader: Record 38;
        //TDSGroup: Record 13731;
        TDSEntry: Record 13729;
        TDSPercentage: Decimal;
        SurchargePercentage: Decimal;
        CalculateSurcharge: Boolean;
        SurchargeBaseLCY: Decimal;
        TotalTDSBaseLCY: Decimal;
        PreviousAmount: Decimal;
        PreviousBaseAMTWithTDS: Decimal;
        PreviousAmount1: Decimal;
        PreviousTDSAmt: Decimal;
        PreviousTDSAmt1: Decimal;
        PreviousSurchargeAmt: Decimal;
        PreviousContractAmount: Decimal;
        DummyTempTDSBase: Decimal;
        OverAndAboveThresholdAmount: Decimal;
    BEGIN
        WITH PurchLine DO BEGIN
            PurchaseHeader.GET("Document Type", "Document No.");
            CalcPrevTDSAmounts(PurchLine, AccountingPeriodFilter, PreviousAmount, PreviousBaseAMTWithTDS, PreviousAmount1,
              PreviousTDSAmt1, PreviousTDSAmt, PreviousSurchargeAmt, PreviousContractAmount);
            IF NodNocLines1."Threshold Overlook" THEN BEGIN
                "TDS Base Amount" := TDSBaseLCY;
                UpdTDSPercnt(PurchLine, PurchaseHeader, TDSSetup);
                CheckSurchargeOverlook(PurchLine, PurchaseHeader, TDSSetup, NodNocLines1."Threshold Overlook",
                  TDSBaseLCY, PreviousAmount, CurrentPOAmount, PreviousSurchargeAmt, TDSPercentage, SurchargePercentage,
                  CalculateSurcharge, AccountingPeriodFilter);
            END ELSE BEGIN
                TDSGroup.FindOnDate("TDS Group", PurchaseHeader."Posting Date");
                // >>ALLE.TDS-REGEF START
                IF TDSSetup."Calc. Over & Above Threshold" THEN
                    OverAndAboveThresholdAmount := TDSGroup."TDS Threshold Amount";
                // <<ALLE.TDS-REGEF STOP
                IF (PreviousAmount + CurrentPOAmount) > TDSGroup."TDS Threshold Amount" THEN BEGIN
                    "TDS Base Amount" := TDSBaseLCY - CurrentPOContractAmt - OverAndAboveThresholdAmount;
                    UpdTDSPercnt(PurchLine, PurchaseHeader, TDSSetup);
                    CheckSurchargeOverlook2(PurchLine, PurchaseHeader, TDSSetup, NodNocLines1."Threshold Overlook",
                      TDSBaseLCY, PreviousAmount, CurrentPOAmount, PreviousSurchargeAmt, TDSPercentage, SurchargePercentage,
                      CalculateSurcharge, AccountingPeriodFilter);
                END ELSE
                    IF TDSGroup."Per Contract Value" <> 0 THEN
                        IF (PreviousAmount + CurrentPOAmount + TDSBaseLCY) > TDSGroup."TDS Threshold Amount" THEN BEGIN
                            IF PreviousContractAmount <> 0 THEN
                                "TDS Base Amount" := (PreviousAmount1 + TDSBaseLCY) - PreviousContractAmount + CurrentPOAmount -
                                  CurrentPOContractAmt - OverAndAboveThresholdAmount
                            ELSE
                                "TDS Base Amount" := (PreviousAmount1 + TDSBaseLCY) - PreviousBaseAMTWithTDS + CurrentPOAmount;

                            UpdTDSPercnt(PurchLine, PurchaseHeader, TDSSetup);
                            IF NodNocLines1."Surcharge Overlook" THEN BEGIN
                                "Surcharge Base Amount" := ((PreviousAmount + TDSBaseLCY) - PreviousContractAmount +
                                                            CurrentPOAmount - CurrentPOContractAmt);
                                "Surcharge %" := TDSSetup."Surcharge %";
                            END ELSE BEGIN
                                TDSGroup.FindOnDate("TDS Group", PurchaseHeader."Posting Date");
                                IF (PreviousAmount + CurrentPOAmount) > TDSGroup."Surcharge Threshold Amount" THEN BEGIN
                                    "Surcharge Base Amount" := TDSBaseLCY;
                                    "Surcharge %" := TDSSetup."Surcharge %";
                                END ELSE BEGIN
                                    IF (PreviousAmount + CurrentPOAmount + TDSBaseLCY) > TDSGroup."Surcharge Threshold Amount" THEN BEGIN
                                        "Surcharge Base Amount" := PreviousAmount + TDSBaseLCY - PreviousContractAmount + CurrentPOAmount;
                                        "Surcharge %" := TDSSetup."Surcharge %";
                                    END ELSE
                                        "Surcharge %" := 0;
                                END;
                            END;
                            TDSPercentage := "TDS %";
                            SurchargePercentage := "Surcharge %";
                            IF "Surcharge %" <> 0 THEN
                                CalculateSurcharge := TRUE;
                            FilterTDSEntry(PurchLine, TDSEntry, AccountingPeriodFilter);
                            TDSEntry.SETFILTER("TDS Amount Including Surcharge", '0');
                            IF TDSEntry.FIND('-') THEN
                                REPEAT
                                    InsertTDSBuf(TDSEntry, PurchaseHeader."Posting Date", CalculateSurcharge, TRUE);
                                UNTIL TDSEntry.NEXT = 0;
                            IF TDSEntry.FIND('-') THEN BEGIN
                                SurchargeBaseLCY := TDSBaseLCY + CurrentPOAmount;
                                TotalTDSBaseLCY := TDSBaseLCY + CurrentPOAmount;
                                InsertGenTDSBuf(TotalTDSBaseLCY, DummyTempTDSBase, SurchargeBaseLCY, TDSPercentage, SurchargePercentage, FALSE);
                            END ELSE BEGIN
                                TDSBaseLCY := "TDS Base Amount";
                                SurchargeBaseLCY := "Surcharge Base Amount";
                                InsertGenTDSBuf(TDSBaseLCY, DummyTempTDSBase, SurchargeBaseLCY, TDSPercentage, SurchargePercentage, FALSE);
                            END;
                        END ELSE
                            IF (TDSBaseLCY + CurrentPOAmount) > TDSGroup."Per Contract Value" THEN BEGIN
                                "Per Contract" := TRUE;
                                "TDS Base Amount" := TDSBaseLCY + CurrentPOAmount - CurrentPOContractAmt;
                                UpdTDSPercnt(PurchLine, PurchaseHeader, TDSSetup);
                                IF NodNocLines1."Surcharge Overlook" THEN BEGIN
                                    "Surcharge Base Amount" := ABS(TDSBaseLCY + CurrentPOAmount - CurrentPOContractAmt);
                                    "Surcharge %" := TDSSetup."Surcharge %";
                                END ELSE BEGIN
                                    TDSGroup.FindOnDate("TDS Group", PurchaseHeader."Posting Date");
                                    IF TDSBaseLCY > TDSGroup."Surcharge Threshold Amount" THEN BEGIN
                                        "Surcharge Base Amount" := TDSBaseLCY;
                                        "Surcharge %" := TDSSetup."Surcharge %";
                                    END ELSE
                                        "Surcharge %" := 0;
                                END;
                            END ELSE BEGIN
                                "TDS Base Amount" := TDSBaseLCY;
                                UpdTDSPercntZero(PurchLine);
                            END
                    ELSE // New Code Ends here
                        IF (PreviousAmount + CurrentPOAmount + TDSBaseLCY) > TDSGroup."TDS Threshold Amount" THEN BEGIN
                            IF PreviousTDSAmt = 0 THEN
                                "TDS Base Amount" := PreviousAmount1 + TDSBaseLCY + CurrentPOAmount - PreviousBaseAMTWithTDS - OverAndAboveThresholdAmount
                            ELSE
                                "TDS Base Amount" := TDSBaseLCY - OverAndAboveThresholdAmount;
                            IF PreviousTDSAmt1 <> 0 THEN
                                "TDS Base Amount" := PreviousAmount1 + TDSBaseLCY + CurrentPOAmount - OverAndAboveThresholdAmount;
                            UpdTDSPercnt(PurchLine, PurchaseHeader, TDSSetup);
                            IF NodNocLines1."Surcharge Overlook" THEN BEGIN
                                "Surcharge Base Amount" := ABS(PreviousAmount + CurrentPOAmount +
                                    TDSBaseLCY);
                                "Surcharge %" := TDSSetup."Surcharge %";
                            END ELSE BEGIN
                                TDSGroup.FindOnDate("TDS Group", PurchaseHeader."Posting Date");
                                IF (PreviousAmount + CurrentPOAmount) > TDSGroup."Surcharge Threshold Amount" THEN BEGIN
                                    "Surcharge Base Amount" := TDSBaseLCY;
                                    "Surcharge %" := TDSSetup."Surcharge %";
                                    PreviousSurchargeAmt := 0;
                                END ELSE BEGIN
                                    IF (PreviousAmount + CurrentPOAmount + TDSBaseLCY) > TDSGroup."Surcharge Threshold Amount" THEN BEGIN
                                        "Surcharge Base Amount" := PreviousAmount + CurrentPOAmount + TDSBaseLCY;
                                        "Surcharge %" := TDSSetup."Surcharge %";
                                    END ELSE
                                        "Surcharge %" := 0;
                                END;
                            END;
                            TDSPercentage := "TDS %";
                            SurchargePercentage := "Surcharge %";
                            IF "Surcharge %" <> 0 THEN
                                CalculateSurcharge := TRUE;
                            FilterTDSEntry2(TDSEntry, PurchLine, AccountingPeriodFilter);
                            IF TDSEntry.FIND('-') THEN
                                REPEAT
                                    InsertTDSBuf(TDSEntry, PurchaseHeader."Posting Date", CalculateSurcharge, TRUE);
                                UNTIL TDSEntry.NEXT = 0;
                            IF TDSEntry.FIND('-') THEN BEGIN
                                TDSBaseLCY := TDSBaseLCY + CurrentPOAmount;
                                SurchargeBaseLCY := TDSBaseLCY;
                                InsertGenTDSBuf(TDSBaseLCY, DummyTempTDSBase, SurchargeBaseLCY, TDSPercentage, SurchargePercentage, FALSE);
                            END ELSE BEGIN
                                TDSBaseLCY := "TDS Base Amount";
                                SurchargeBaseLCY := "Surcharge Base Amount";
                                InsertGenTDSBuf(TDSBaseLCY, DummyTempTDSBase, SurchargeBaseLCY, TDSPercentage, SurchargePercentage, FALSE);
                            END;
                        END ELSE BEGIN // something to be added here..
                            "TDS Base Amount" := TDSBaseLCY;
                            UpdTDSPercntZero(PurchLine);
                            "Surcharge %" := 0;
                            "Surcharge Amount" := 0;
                            "TDS Amount" := 0;
                            "TDS Amount Including Surcharge" := 0;
                        END;
            END;
        END;
    END;
    *///Need to check the code in UAT

    LOCAL PROCEDURE CalcPrevTDSAmounts(PurchaseLine: Record "Purchase Line"; AccountingPeriodFilter: Text[30]; VAR PreviousAmount: Decimal; VAR PreviousBaseAMTWithTDS: Decimal; VAR PreviousAmount1: Decimal; VAR PreviousTDSAmt1: Decimal; VAR PreviousTDSAmt: Decimal; VAR PreviousSurchargeAmt: Decimal; VAR PreviousContractAmount: Decimal);
    VAR
        Vendor: Record Vendor;
        TDSEntry: Record "TDS Entry";// 13729;
        InvoiceAmount: Decimal;
        PaymentAmount: Decimal;
        InvoiceAmt1: Decimal;
        PaymentAmt1: Decimal;
    BEGIN
        /*
        WITH PurchaseLine DO BEGIN
            Vendor.GET("Pay-to Vendor No.");
            IF (Vendor."P.A.N. No." = '') AND (Vendor."P.A.N. Status" = Vendor."P.A.N. Status"::" ") THEN
                ERROR(PANErr, Vendor."No.");
            TDSEntry.RESET;
            TDSEntry.SETCURRENTKEY("Party Type", "Party Code", "Posting Date", "TDS Group", "Assessee Code", Applied);
            TDSEntry.SETRANGE("Party Type", TDSEntry."Party Type"::Vendor);
            IF Vendor."P.A.N. Status" <> Vendor."P.A.N. Status"::" " THEN
                TDSEntry.SETRANGE("Party Code", "Pay-to Vendor No.")
            ELSE
                TDSEntry.SETRANGE("Deductee P.A.N. No.", Vendor."P.A.N. No.");
            TDSEntry.SETFILTER("Posting Date", AccountingPeriodFilter);
            TDSEntry.SETRANGE("TDS Group", "TDS Group");
            TDSEntry.SETRANGE("Assessee Code", "Assessee Code");
            TDSEntry.SETRANGE(Applied, FALSE);
            IF TDSEntry.FINDFIRST THEN BEGIN
                TDSEntry.CALCSUMS("Invoice Amount", "Service Tax Including eCess");
                PreviousAmount := ABS(TDSEntry."Invoice Amount") + ABS(TDSEntry."Service Tax Including eCess");
            END;
            FilterTDSEntry1(TDSEntry, PurchaseLine, AccountingPeriodFilter);
            TDSEntry.CALCSUMS("Invoice Amount", "Service Tax Including eCess");
            PreviousBaseAMTWithTDS := ABS(TDSEntry."Invoice Amount") + ABS(TDSEntry."Service Tax Including eCess");

            TDSEntry.RESET;
            TDSEntry.SETCURRENTKEY("Party Type", "Party Code", "Posting Date", "TDS Group", "Assessee Code", "Document Type");
            TDSEntry.SETRANGE("Party Type", TDSEntry."Party Type"::Vendor);
            IF Vendor."P.A.N. Status" <> Vendor."P.A.N. Status"::" " THEN
                TDSEntry.SETRANGE("Party Code", "Pay-to Vendor No.")
            ELSE
                TDSEntry.SETRANGE("Deductee P.A.N. No.", Vendor."P.A.N. No.");
            TDSEntry.SETFILTER("Posting Date", AccountingPeriodFilter);
            TDSEntry.SETRANGE("TDS Group", "TDS Group");
            TDSEntry.SETRANGE("Assessee Code", "Assessee Code");
            TDSEntry.SETRANGE("Document Type", TDSEntry."Document Type"::Invoice);
            IF TDSEntry.FINDFIRST THEN BEGIN
                TDSEntry.CALCSUMS("Invoice Amount", "Service Tax Including eCess");
                InvoiceAmount := ABS(TDSEntry."Invoice Amount") + ABS(TDSEntry."Service Tax Including eCess");
            END;

            TDSEntry.RESET;
            TDSEntry.SETCURRENTKEY("Party Type", "Party Code", "Posting Date", "TDS Group", "Assessee Code", "Document Type");
            TDSEntry.SETRANGE("Party Type", TDSEntry."Party Type"::Vendor);
            IF Vendor."P.A.N. Status" <> Vendor."P.A.N. Status"::" " THEN
                TDSEntry.SETRANGE("Party Code", "Pay-to Vendor No.")
            ELSE
                TDSEntry.SETRANGE("Deductee P.A.N. No.", Vendor."P.A.N. No.");
            TDSEntry.SETFILTER("Posting Date", AccountingPeriodFilter);
            TDSEntry.SETRANGE("TDS Group", "TDS Group");
            TDSEntry.SETRANGE("Assessee Code", "Assessee Code");
            TDSEntry.SETRANGE("Document Type", TDSEntry."Document Type"::Payment);
            IF TDSEntry.FINDFIRST THEN BEGIN
                TDSEntry.CALCSUMS("Invoice Amount", "Service Tax Including eCess");
                PaymentAmount := ABS(TDSEntry."Invoice Amount") + ABS(TDSEntry."Service Tax Including eCess");
            END;

            PreviousAmount := InvoiceAmount + PaymentAmount;
            UpdateTDSAdjustmentEntry(PurchaseLine, PreviousAmount1, InvoiceAmt1, PaymentAmt1, PreviousTDSAmt1, AccountingPeriodFilter);
            TDSEntry.RESET;
            TDSEntry.SETCURRENTKEY("Party Type", "Party Code", "Posting Date", "TDS Group", "Assessee Code");
            TDSEntry.SETRANGE("Party Type", TDSEntry."Party Type"::Vendor);
            IF Vendor."P.A.N. Status" <> Vendor."P.A.N. Status"::" " THEN
                TDSEntry.SETRANGE("Party Code", "Pay-to Vendor No.")
            ELSE
                TDSEntry.SETRANGE("Deductee P.A.N. No.", Vendor."P.A.N. No.");
            TDSEntry.SETFILTER("Posting Date", AccountingPeriodFilter);
            TDSEntry.SETRANGE("TDS Group", "TDS Group");
            TDSEntry.SETRANGE("Assessee Code", "Assessee Code");
            IF TDSEntry.FINDFIRST THEN BEGIN
                TDSEntry.CALCSUMS("TDS Amount", "Surcharge Amount");
                PreviousTDSAmt := ABS(TDSEntry."TDS Amount");
                PreviousSurchargeAmt := ABS(TDSEntry."Surcharge Amount");
            END;
            TDSEntry.RESET;
            TDSEntry.SETCURRENTKEY("Party Type", "Party Code", "Posting Date", "TDS Group", "Assessee Code", Applied);
            TDSEntry.SETRANGE("Party Type", TDSEntry."Party Type"::Vendor);
            IF Vendor."P.A.N. Status" <> Vendor."P.A.N. Status"::" " THEN
                TDSEntry.SETRANGE("Party Code", "Pay-to Vendor No.")
            ELSE
                TDSEntry.SETRANGE("Deductee P.A.N. No.", Vendor."P.A.N. No.");
            TDSEntry.SETFILTER("Posting Date", AccountingPeriodFilter);
            TDSEntry.SETRANGE("TDS Group", "TDS Group");
            TDSEntry.SETRANGE("Assessee Code", "Assessee Code");
            TDSEntry.SETRANGE(Applied, FALSE);
            TDSEntry.SETRANGE("Per Contract", TRUE);
            IF TDSEntry.FINDFIRST THEN BEGIN
                TDSEntry.CALCSUMS("Invoice Amount", "Service Tax Including eCess");
                PreviousContractAmount := ABS(TDSEntry."Invoice Amount") + ABS(TDSEntry."Service Tax Including eCess");
            END;
        END;
        *///Need to check the code in UAT

    END;

    LOCAL PROCEDURE UpdTDSPercnt(VAR PurchaseLine: Record "Purchase Line"; PurchaseHeader: Record "Purchase Header"; TDSSetup: Record "TDS Setup")
    VAR
        Vendor: Record Vendor;
        TDSSetupPercentage: Decimal;
    BEGIN
        Vendor.GET(PurchaseHeader."Pay-to Vendor No.");
        IF (Vendor."P.A.N. Status" = Vendor."P.A.N. Status"::" ") AND (Vendor."P.A.N. No." <> '') THEN BEGIN
            IF Vendor."BBG 206AB" THEN   //ALLEDK 020721
                TDSSetupPercentage := TDSSetup."206AB %";  //ALLEDK 020721
                                                           // ELSE
                                                           //     TDSSetupPercentage := TDSSetup."TDS %"
        END;// ELSE
        //     TDSSetupPercentage := TDSSetup."Non PAN TDS %";
        /*
        "TDS %" := TDSSetupPercentage;
        "eCESS % on TDS" := TDSSetup."eCESS %";
        "SHE Cess % On TDS" := TDSSetup."SHE Cess %";
        *///Need to check the code in UAT
    END;

    LOCAL PROCEDURE UpdTDSPercntZero(VAR PurchaseLine: Record "Purchase Line");
    BEGIN
        /*
        WITH PurchaseLine DO BEGIN
            "TDS %" := 0;
            "eCESS % on TDS" := 0;
            "SHE Cess % On TDS" := 0;
        END;
        *///Need to check the code in UAT

    END;

    LOCAL PROCEDURE CheckSurchargeOverlook(VAR PurchaseLine: Record "Purchase Line"; PurchaseHeader: Record "Purchase Header"; TDSSetup: Record "TDS Setup"; SurchargeOverlook: Boolean; TDSBaseLCY: Decimal; PreviousAmount: Decimal; CurrentPOAmount: Decimal; VAR PreviousSurchargeAmt: Decimal; VAR TDSPercentage: Decimal; VAR SurchargePercentage: Decimal; VAR CalculateSurcharge: Boolean; AccountingPeriodFilter: Text[30])
    VAR
        //TDSGroup: Record 13731;//Need to check the code in UAT

        TDSEntry: Record "TDS Entry";// 13729;
        SurchargeBaseLCY: Decimal;
        DummyTempTDSBase: Decimal;
    BEGIN
        /*
            WITH PurchaseLine DO
                IF SurchargeOverlook THEN BEGIN
                    "Surcharge Base Amount" := TDSBaseLCY;
                    "Surcharge %" := TDSSetup."Surcharge %";
                END ELSE BEGIN
                    TDSGroup.FindOnDate("TDS Group", PurchaseHeader."Posting Date");
                    IF (PreviousAmount + CurrentPOAmount) > TDSGroup."Surcharge Threshold Amount" THEN BEGIN
                        "Surcharge Base Amount" := TDSBaseLCY;
                        "Surcharge %" := TDSSetup."Surcharge %";
                        PreviousSurchargeAmt := 0;
                    END ELSE BEGIN
                        IF (PreviousAmount + CurrentPOAmount + TDSBaseLCY) > TDSGroup."Surcharge Threshold Amount" THEN BEGIN
                            "Surcharge Base Amount" := PreviousAmount + CurrentPOAmount + TDSBaseLCY;
                            "Surcharge %" := TDSSetup."Surcharge %";
                            TDSPercentage := "TDS %";
                            SurchargePercentage := "Surcharge %";
                            IF "Surcharge %" <> 0 THEN
                                CalculateSurcharge := TRUE;
                            FilterTDSEntry(PurchaseLine, TDSEntry, AccountingPeriodFilter);
                            IF TDSEntry.FIND('-') THEN
                                REPEAT
                                    InsertTDSBuf(TDSEntry, PurchaseHeader."Posting Date", CalculateSurcharge, FALSE);
                                UNTIL TDSEntry.NEXT = 0;
                            IF TDSEntry.FINDFIRST THEN BEGIN
                                SurchargeBaseLCY := TDSBaseLCY + CurrentPOAmount;
                                InsertGenTDSBuf(TDSBaseLCY, DummyTempTDSBase, SurchargeBaseLCY, TDSPercentage, SurchargePercentage, FALSE);
                            END ELSE BEGIN
                                SurchargeBaseLCY := "Surcharge Base Amount";
                                InsertGenTDSBuf(TDSBaseLCY, DummyTempTDSBase, SurchargeBaseLCY, TDSPercentage, SurchargePercentage, FALSE);
                            END;
                        END ELSE
                            "Surcharge %" := 0;
                    END;
                END;
                *///Need to check the code in UAT

    END;

    LOCAL PROCEDURE CheckSurchargeOverlook2(VAR PurchaseLine: Record "Purchase Line"; PurchaseHeader: Record "Purchase Header"; TDSSetup: Record "TDS Setup"; SurchargeOverlook: Boolean; TDSBaseLCY: Decimal; PreviousAmount: Decimal; CurrentPOAmount: Decimal; VAR PreviousSurchargeAmt: Decimal; VAR TDSPercentage: Decimal; VAR SurchargePercentage: Decimal; VAR CalculateSurcharge: Boolean; AccountingPeriodFilter: Text[30])
    VAR
        //DummyTDSGroup: Record 13731;//Need to check the code in UAT

        TDSEntry: Record "TDS Entry";// 13729;
        SurchargeBaseLCY: Decimal;
        DummyTempTDSBase: Decimal;
    BEGIN
        /*
            WITH PurchaseLine DO
                IF SurchargeOverlook THEN BEGIN
                    "Surcharge Base Amount" := TDSBaseLCY;
                    "Surcharge %" := TDSSetup."Surcharge %";
                END ELSE
                    IF (PreviousAmount + CurrentPOAmount) > DummyTDSGroup."Surcharge Threshold Amount" THEN BEGIN
                        "Surcharge Base Amount" := TDSBaseLCY;
                        "Surcharge %" := TDSSetup."Surcharge %";
                        PreviousSurchargeAmt := 0;
                    END ELSE BEGIN
                        IF (PreviousAmount + CurrentPOAmount + TDSBaseLCY) > DummyTDSGroup."Surcharge Threshold Amount" THEN BEGIN
                            "Surcharge Base Amount" := PreviousAmount + CurrentPOAmount + TDSBaseLCY;
                            "Surcharge %" := TDSSetup."Surcharge %";
                            TDSPercentage := "TDS %";
                            SurchargePercentage := "Surcharge %";
                            IF "Surcharge %" <> 0 THEN
                                CalculateSurcharge := TRUE;
                            FilterTDSEntry(PurchaseLine, TDSEntry, AccountingPeriodFilter);
                            IF TDSEntry.FIND('-') THEN
                                REPEAT
                                    InsertTDSBuf(TDSEntry, PurchaseHeader."Posting Date", CalculateSurcharge, FALSE);
                                UNTIL TDSEntry.NEXT = 0;
                            IF TDSEntry.FIND('-') THEN BEGIN
                                SurchargeBaseLCY := TDSBaseLCY + CurrentPOAmount;
                                InsertGenTDSBuf(TDSBaseLCY, DummyTempTDSBase, SurchargeBaseLCY, TDSPercentage, SurchargePercentage, FALSE);
                            END ELSE BEGIN
                                SurchargeBaseLCY := "Surcharge Base Amount";
                                InsertGenTDSBuf(TDSBaseLCY, DummyTempTDSBase, SurchargeBaseLCY, TDSPercentage, SurchargePercentage, FALSE);
                            END;
                        END ELSE
                            "Surcharge %" := 0;
                    END;
                    *///Need to check the code in UAT

    END;
}