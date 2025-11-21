table 97780 "Purch. Delivery Schd Archive"
{
    // ALLETG RIL0011 22-06-2011:

    DrillDownPageID = "Purch Delivery Schd. Archive";
    LookupPageID = "Purch Delivery Schd. Archive";

    fields
    {
        field(1; "Document Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(2; "Document No."; Code[20])
        {
            Editable = false;
        }
        field(3; "Document Line No."; Integer)
        {
            Editable = false;
        }
        field(4; Type; Option)
        {
            Editable = false;
            OptionCaption = ' ,G/L Account,Item,,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,,"Fixed Asset","Charge (Item)";
        }
        field(5; "No."; Code[20])
        {
            Editable = false;
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE IF (Type = CONST(Item)) Item
            ELSE IF (Type = CONST(3)) Resource
            ELSE IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE IF (Type = CONST("Charge (Item)")) "Item Charge";
        }
        field(6; "Line No."; Integer)
        {
            Editable = false;
        }
        field(7; Description; Text[50])
        {
            Editable = false;
        }
        field(8; "Description 2"; Text[50])
        {
            Editable = false;
        }
        field(11; "Schedule Quantity"; Decimal)
        {

            trigger OnValidate()
            begin
                //IF "Schedule Quantity" > "Document Quantity" THEN
                //  TESTFIELD("Schedule Quantity","Document Quantity");
                CheckQuantity;
                "Remaining Quantity" := "Schedule Quantity" - "Remaining Quantity";
                IF "Remaining Quantity" < 0 THEN
                    ERROR(Text50001);
            end;
        }
        field(12; "Remaining Quantity"; Decimal)
        {
        }
        field(13; "Received Quantity"; Decimal)
        {
            CalcFormula = Sum("GRN Line"."Accepted Qty" WHERE("Purchase Order No." = FIELD("Document No."),
                                                               "Purchase Order Line No." = FIELD("Document Line No."),
                                                               "Schedule Line No." = FIELD("Line No."),
                                                               Status = CONST(Close)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Expected Receipt Date"; Date)
        {
        }
        field(15; "Description 3"; Text[50])
        {
            Editable = false;
        }
        field(16; "Alternate Unit of Measure Code"; Code[10])
        {
            Caption = 'Alternate Unit of Measure Code';
            Description = 'ALLEPG 100611';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));
        }
        field(17; "Alternate UOM Qty."; Decimal)
        {
            Description = 'ALLEPG 100611';
        }
        field(18; "Doc. No. Occurrence"; Integer)
        {
            Caption = 'Doc. No. Occurrence';
        }
        field(19; "Version No."; Integer)
        {
            Caption = 'Version No.';
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Doc. No. Occurrence", "Version No.", "Document Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD("Schedule Quantity", 0);
    end;

    trigger OnInsert()
    begin
        CheckQuantity();

        PurchaseLine.GET("Document Type", "Document No.", "Document Line No.");
        Type := PurchaseLine.Type;
        "No." := PurchaseLine."No.";
        Description := PurchaseLine.Description;
        "Description 2" := PurchaseLine."Description 2";
        "Description 3" := PurchaseLine."Description 3";
    end;

    trigger OnModify()
    begin
        //TESTFIELD("Application Nos.");
        CheckQuantity();
    end;

    var
        PurchaseLine: Record "Purchase Line";
        PurchaseDeliverySchedule: Record "Purch. Delivery Schedule";
        ScheduleQuantity1: Decimal;
        DocQty: Decimal;
        Text50000: Label 'Schedule Quantity can not be more than Purchase Line Quantity %1';
        Text50001: Label 'Remaining Quantity cannot be less than 0';


    procedure CheckQuantity()
    begin

        PurchaseLine.GET("Document Type", "Document No.", "Document Line No.");

        PurchaseDeliverySchedule.RESET;
        PurchaseDeliverySchedule.SETRANGE("Document Type", "Document Type");
        PurchaseDeliverySchedule.SETRANGE("Document No.", "Document No.");
        PurchaseDeliverySchedule.SETRANGE("Document Line No.", "Document Line No.");
        PurchaseDeliverySchedule.SETFILTER("Line No.", '<>%1', "Line No.");
        IF PurchaseDeliverySchedule.FINDSET THEN
            ScheduleQuantity1 := 0;
        REPEAT
            ScheduleQuantity1 := ScheduleQuantity1 + PurchaseDeliverySchedule."Schedule Quantity";
        UNTIL PurchaseDeliverySchedule.NEXT = 0;
        ScheduleQuantity1 := ScheduleQuantity1 + "Schedule Quantity";
        IF ScheduleQuantity1 > PurchaseLine.Quantity THEN
            ERROR(Text50000, PurchaseLine.Quantity);
    end;
}

