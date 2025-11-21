tableextension 97024 "EPC Purchase Line Ext" extends "Purchase Line"
{
    fields
    {
        // Add changes to table fields here
        field(70008; Blocked; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(50005; "Job Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
            TableRelation = "Job Master";

            trigger OnLookup()
            var
                JobMst: Record "Job Master";
            begin
                IF Type <> Type::"G/L Account" THEN
                    EXIT;

                JobMst.RESET;
                IF "Job Code" <> '' THEN
                    JobMst.GET("Job Code");

                IF PAGE.RUNMODAL(0, JobMst) = ACTION::LookupOK THEN BEGIN
                    IF JobMst."G/L Code" <> '' THEN
                        VALIDATE("No.", JobMst."G/L Code")  // ALLEAA
                    ELSE
                        UpdateDefaultGL;
                    VALIDATE("Job Code", JobMst.Code);
                END;
            end;

            trigger OnValidate()
            var
                JobMst: Record "Job Master";
                DimVal: Record "Dimension Value";
            begin
                TESTFIELD(Type, Type::"G/L Account");
                JobMst.RESET;
                JobMst.SETRANGE(Code, "Job Code");
                IF JobMst.FIND('-') THEN BEGIN
                    DimVal.RESET;
                    PurchHeader := GetPurchHeader;
                    PurchHeader.TESTFIELD("Buy-from Vendor No.");
                    IF JobMst."G/L Code" <> '' THEN
                        VALIDATE("No.", JobMst."G/L Code")  // ALLEAA
                    ELSE
                        UpdateDefaultGL;
                    VALIDATE("Shortcut Dimension 2 Code", JobMst."Default Cost Center Code");
                    Description := JobMst.Description;
                    "Description 2" := JobMst."Description 2";
                    //ALLEJS 271211 START
                    "Description 3" := JobMst."Description 3";
                    "Description 4" := JobMst."Description 4";
                    //ALLEJS 271211 END
                    VALIDATE("Unit of Measure Code", JobMst."Base UOM");
                    VALIDATE("Direct Unit Cost", JobMst.Rate);
                    "Job Code" := JobMst.Code;
                END ELSE BEGIN
                    UpdateDefaultGL;
                    "Job Code" := JobMst.Code;
                END
            end;
        }
        field(50003; "Description 3"; Text[60])
        {
            DataClassification = ToBeClassified;
            Description = 'dds';
        }
        field(50004; "Description 4"; Text[60])
        {
            DataClassification = ToBeClassified;
            Description = 'dds';
        }
        field(50006; "Indent No"; Code[20])
        {
            Caption = 'Purch. Req. No.';
            DataClassification = ToBeClassified;
            Description = 'JPL';
            TableRelation = "Purchase Request Header"."Document No." WHERE("Document Type" = FILTER(Indent),
                                                                            Approved = FILTER(true));
        }
        field(50007; "Indent Line No"; Integer)
        {
            Caption = 'Purch. Req. Line No';
            DataClassification = ToBeClassified;
            Description = 'JPL';
            TableRelation = "Purchase Request Line"."Line No." WHERE("Document Type" = FILTER(Indent),
                                                                      "Document No." = FIELD("Indent No"),
                                                                      Approved = FILTER(true));

            trigger OnLookup()
            var
                POLineRec: Record "Purchase Line";
            begin
            end;
        }
        field(70004; "GRN No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(70005; "GRN Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(70006; "PO No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(70007; "PO Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(70011; "Schedule Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETG RIL0011 22-06-2011';
        }
        field(70001; "Rejected Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Description = 'JPL';
        }
        field(70002; "Rejection Note No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'JPL';
        }
        field(50101; "Detect TDS Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 111212';
        }
        field(80002; "BOQ Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAA';
            Editable = false;
        }
        field(70010; "Invoiced Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLE-PKS 07 for the part rate functionality';
        }
        field(50064; Narration; Text[60])
        {
            DataClassification = ToBeClassified;
            Description = 'Incentive Narration';
        }
        field(50061; "Land Agreement No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50063; "Land Agreement Line No."; Integer)
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
        PurchHeader: Record "Purchase Header";

    PROCEDURE CheckIndentT()
    BEGIN
        //JPL09 START
        IF ("Indent Line No" = 0) AND ("Indent No" = '') THEN
            EXIT;

        IndentLine.RESET;
        IndentLine.SETRANGE("Document Type", IndentLine."Document Type"::Indent);
        IndentLine.SETRANGE("Document No.", "Indent No");
        IndentLine.SETRANGE("Line No.", "Indent Line No");
        IndentLine.SETRANGE(Approved, TRUE);
        IF "No." <> '' THEN
            IndentLine.SETRANGE("No.", "No.");
        IndentLine.CALCFIELDS("PO Qty");
        IF IndentLine.FIND('-') THEN BEGIN
            TESTFIELD("No.", IndentLine."No.");
            IndentLine.CALCFIELDS("PO Qty");
            IF ("Document Type" = xRec."Document Type") AND ("Document No." = xRec."Document No.")
              AND ("Line No." = xRec."Line No.") THEN BEGIN
                IF (IndentLine."Line No." = xRec."Indent Line No") AND (IndentLine."Document No." = xRec."Indent No") THEN BEGIN
                    IF (IndentLine."Quantity Base" - IndentLine."PO Qty" + xRec."Quantity (Base)" < "Quantity (Base)") THEN
                        ERROR('Original Available Indent Qty is less than PO Line Base Qty');
                END ELSE BEGIN
                    IF (IndentLine."Quantity Base" - IndentLine."PO Qty" < "Quantity (Base)") THEN
                        ERROR('Available Indent Qty is less than PO Line Base Qty');
                END;
            END ELSE BEGIN
                IF IndentLine.Type = IndentLine.Type::Item THEN BEGIN
                    ExcessQty := 0;
                    Itemrec.GET(IndentLine."No.");
                    IF Itemrec."Tolerance  Percentage" <> 0 THEN BEGIN
                        POLineRec1.RESET;
                        POLineRec1.SETCURRENTKEY("Document Type", "Indent No", "Indent Line No", Type, "No.");
                        POLineRec1.SETRANGE("Document Type", POLineRec1."Document Type"::Order);
                        POLineRec1.SETFILTER(POLineRec1."Indent No", IndentLine."Document No.");
                        POLineRec1.SETRANGE(POLineRec1."Indent Line No", IndentLine."Line No.");
                        IF POLineRec1.FINDFIRST THEN
                            REPEAT
                                GRNLRec.RESET;
                                GRNLRec.SETCURRENTKEY("Purchase Order No.", "Purchase Order Line No.", Status);
                                GRNLRec.SETFILTER(GRNLRec."Purchase Order No.", POLineRec1."Document No.");
                                GRNLRec.SETRANGE(GRNLRec."Purchase Order Line No.", POLineRec1."Line No.");
                                IF GRNLRec.FINDFIRST THEN
                                    REPEAT
                                        ExcessQty := ExcessQty + GRNLRec."Excess Qty";
                                    UNTIL GRNLRec.NEXT = 0;
                            UNTIL POLineRec1.NEXT = 0;
                    END;
                END;
                IF ExcessQty <> 0 THEN BEGIN
                    IF (IndentLine."Quantity Base" - (IndentLine."PO Qty" - ExcessQty) < 0) THEN
                        ERROR('Available Indent Qty is less than PO Line Base Qty');
                END ELSE BEGIN
                    IF (IndentLine."Quantity Base" - IndentLine."PO Qty" < 0) THEN
                        ERROR('Available Indent Qty is less than PO Line Base Qty');
                END;
            END;
        END;
        //JPL09 STOP
    END;

    PROCEDURE UpdateDefaultGL()
    BEGIN
        GetPurchHeader;
        DocSetup.GET(DocSetup."Document Type"::"Purchase Order", PurchHeader."Sub Document Type");
        IF DocSetup."Control GL Account" <> '' THEN
            VALIDATE("No.", DocSetup."Control GL Account");
        "Shortcut Dimension 1 Code" := PurchHeader."Shortcut Dimension 1 Code";
        "Shortcut Dimension 2 Code" := PurchHeader."Shortcut Dimension 2 Code";
        IF DocSetup."Def. Gen Prod Posting Group" <> '' THEN
            "Gen. Prod. Posting Group" := DocSetup."Def. Gen Prod Posting Group";
    END;

    PROCEDURE FillIndentLines(VAR pIndentLine: Record "Purchase Request Line"; pPurchHeader: Record "Purchase Header")
    VAR
        vLineNo: Integer;
    BEGIN
        //JPL09 START
        vLineNo := 0;
        POLineRec.RESET;
        POLineRec.SETRANGE("Document Type", pPurchHeader."Document Type");
        POLineRec.SETRANGE("Document No.", pPurchHeader."No.");
        IF POLineRec.FIND('+') THEN
            vLineNo := POLineRec."Line No.";
        IF pIndentLine.FIND('-') THEN BEGIN
            REPEAT
                vLineNo := vLineNo + 10000;
                POLineRec.INIT;
                POLineRec."Document Type" := pPurchHeader."Document Type";
                POLineRec."Document No." := pPurchHeader."No.";
                POLineRec."Line No." := vLineNo;
                POLineRec.INSERT;

                pIndentLine.CALCFIELDS("PO Qty");
                pIndentLine.CALCFIELDS("TO Qty"); //AllE-PKS
                POLineRec.VALIDATE(Type, pIndentLine.Type);
                POLineRec.VALIDATE("No.", pIndentLine."No.");
                IF pIndentLine."Job Master Code" <> '' THEN
                    POLineRec.VALIDATE("Job Code", pIndentLine."Job Master Code");
                POLineRec.VALIDATE("Location Code", pIndentLine."Location code");
                POLineRec.VALIDATE("Unit of Measure Code", pIndentLine."Purchase UOM");
                IF pIndentLine."Purch Qty Per Unit Of Measure" = 0 THEN
                    pIndentLine."Purch Qty Per Unit Of Measure" := 1;
                POLineRec.VALIDATE(Quantity, (pIndentLine."Quantity Base" - pIndentLine."PO Qty" - pIndentLine."TO Qty")
                / pIndentLine."Purch Qty Per Unit Of Measure");
                POLineRec."Job No." := pIndentLine."Job No.";
                POLineRec."Job Task No." := pIndentLine."Job Task No.";
                POLineRec."Indent No" := pIndentLine."Document No.";
                POLineRec."Indent Line No" := pIndentLine."Line No.";
                POLineRec.Description := pIndentLine.Description;
                POLineRec."Description 2" := pIndentLine."Description 2";
                POLineRec."Description 3" := pIndentLine."Description 3";
                POLineRec."Description 4" := pIndentLine."Description 4";
                POLineRec.VALIDATE("Expected Receipt Date", pIndentLine."Required By Date");
                POLineRec.VALIDATE("Shortcut Dimension 1 Code", pIndentLine."Shortcut Dimension 1 Code");
                IF pIndentLine."Shortcut Dimension 2 Code" <> '' THEN
                    POLineRec.VALIDATE("Shortcut Dimension 2 Code", pIndentLine."Shortcut Dimension 2 Code");
                POLineRec.MODIFY;

                //ALLETG RIL0011 22-06-2011: START>>
                InsertDlvrSchdLines(POLineRec);
            //ALLETG RIL0011 22-06-2011: END<<

            UNTIL pIndentLine.NEXT = 0;
        END;
        //JPL09 STOP
    END;

    PROCEDURE InsertDlvrSchdLines(pPurchLine: Record "Purchase Line")
    BEGIN
        //ALLETG RIL0011 22-06-2011: START>>
        PurchDeliverySchedule.RESET;
        PurchDeliverySchedule.SETRANGE("Document Type", pPurchLine."Document Type");
        PurchDeliverySchedule.SETRANGE("Document No.", pPurchLine."Document No.");
        PurchDeliverySchedule.SETRANGE("Document Line No.", pPurchLine."Line No.");
        PurchDeliverySchedule.DELETEALL;

        PurchDeliverySchedule.INIT;
        PurchDeliverySchedule."Document Type" := pPurchLine."Document Type".AsInteger();
        PurchDeliverySchedule."Document No." := pPurchLine."Document No.";
        PurchDeliverySchedule."Document Line No." := pPurchLine."Line No.";
        PurchDeliverySchedule.VALIDATE(Type, pPurchLine.Type);
        PurchDeliverySchedule.VALIDATE("No.", pPurchLine."No.");
        PurchDeliverySchedule."Line No." := 10000;
        PurchDeliverySchedule.Description := pPurchLine.Description;
        PurchDeliverySchedule."Description 2" := pPurchLine."Description 2";
        PurchDeliverySchedule."Description 3" := pPurchLine."Description 3";
        PurchDeliverySchedule."Schedule Quantity" := pPurchLine.Quantity;
        IF pPurchLine."Expected Receipt Date" = 0D THEN
            PurchDeliverySchedule."Expected Receipt Date" := WORKDATE
        ELSE
            PurchDeliverySchedule."Expected Receipt Date" := pPurchLine."Expected Receipt Date";
        PurchDeliverySchedule."Remaining Quantity" := PurchDeliverySchedule."Schedule Quantity";
        PurchDeliverySchedule.INSERT;
        //ALLETG RIL0011 22-06-2011: END<<
    END;

}