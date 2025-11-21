tableextension 50021 "BBG Item Journal Line Ext" extends "Item Journal Line"
{
    fields
    {
        // Add changes to table fields here
        modify("Item No.")
        {
            trigger OnAfterValidate()
            var
                RecUserSetup: Record "User Setup";
                RecRespCenter: Record "Responsibility Center 1";
            begin
                //ALLEAA
                IF RecUserSetup.GET(USERID) THEN
                    IF RecRespCenter.GET(RecUserSetup."Purchase Resp. Ctr. Filter") THEN BEGIN
                        VALIDATE("Shortcut Dimension 1 Code", RecRespCenter."Global Dimension 1 Code");
                        "Location Code" := RecRespCenter."Location Code";
                    END;
                //ALLEAA
            end;
        }

        field(50006; "Indent No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            TableRelation = "Purchase Request Header"."Document No." WHERE("Document Type" = FILTER(Indent),
                                                                            Approved = FILTER(true));
        }
        field(50007; "Indent Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            TableRelation = "Purchase Request Line"."Line No." WHERE("Document Type" = FILTER(Indent),
                                                                      "Document No." = FIELD("Indent No"),
                                                                      Approved = FILTER(true));

            trigger OnLookup()
            var
                POLineRec: Record "Purchase Line";
            begin
            end;
        }


        field(50017; "Transfered Qty. Changed"; Boolean)
        {
            Caption = 'Transfered Qty. Changed';
            DataClassification = ToBeClassified;
            Description = 'ALLEAA 17.04.09';
            Editable = false;
        }
        field(50018; "Available Qty."; Decimal)
        {
            CalcFormula = Sum("Warehouse Entry".Quantity WHERE("Location Code" = FIELD("Location Code"),
                                                                "Item No." = FIELD("Item No."),
                                                                "Bin Code" = FIELD("Bin Code"),
                                                                "Unit of Measure Code" = FIELD("Unit of Measure Code"),
                                                                "Variant Code" = FIELD("Variant Code"),
                                                                "Lot No." = FIELD("Lot No."),
                                                                "Serial No." = FIELD("Serial No.")));
            Caption = 'Available Qty.';
            Description = 'ALLEAA 17.04.09';
            Editable = false;
            FieldClass = FlowField;
        }


        field(50022; "Entry Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'INS1.0';
            Editable = false;
        }
        field(50030; "Transfer FG"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00';
        }

        field(50032; "Current Stock"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                  "Location Code" = FIELD("Location Code")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(60000; "check FA Item"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ashish';
        }
        field(80013; "Fixed Asset No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Asset";
        }
        field(80031; "Land Agreement No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(80032; "Land Agreement Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(80033; "R194_Application No."; Text[500])
        {
            DataClassification = ToBeClassified;
            Editable = false;

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
        ItemJnlLineReserve: Codeunit "Item Jnl. Line-Reserve";


    //--11-042025 Code added Start
    procedure NewCreateItemTrackingLines(UpdateTracking: Boolean)
    var
        ItemJournalLine: Record "Item Journal Line";
    begin
        ItemJournalLine.Copy(Rec);
        ItemJnlLineReserve.CreateItemTracking(ItemJournalLine);
        if UpdateTracking then
            NewUpdateItemTracking(ItemJournalLine);
    end;

    procedure NewUpdateItemTracking(var ItemJournalLine: Record "Item Journal Line")
    var
        TempItemJournalLine: Record "Item Journal Line" temporary;
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        SingleItemTrackingExists: Boolean;
    begin
        ItemJournalLine.Find();
        TempItemJournalLine := ItemJournalLine;

        if ItemJournalLine.NewGetItemTracking(TempTrackingSpecification) then
            if TempTrackingSpecification.Count() = 1 then begin
                SingleItemTrackingExists := true;
                ItemJournalLine.CopyTrackingFromSpec(TempTrackingSpecification);
                ItemJournalLine."Expiration Date" := TempTrackingSpecification."Expiration Date";
                ItemJournalLine."Warranty Date" := TempTrackingSpecification."Warranty Date";
            end;

        if not SingleItemTrackingExists then begin
            ItemJournalLine.ClearTracking();
            ItemJournalLine.ClearDates();
        end;

        if not ItemJournalLine.HasSameTracking(TempItemJournalLine) then
            ItemJournalLine.Modify();
    end;

    procedure NewGetItemTracking(var TempTrackingSpecification: Record "Tracking Specification" temporary): Boolean
    var
        ReservationEntry: Record "Reservation Entry";
        ItemTrackingManagement: Codeunit "Item Tracking Management";
    begin
        SetReservationFilters(ReservationEntry);
        ReservationEntry.ClearTrackingFilter();
        exit(ItemTrackingManagement.SumUpItemTracking(ReservationEntry, TempTrackingSpecification, false, true));
    end;
    //--11-042025 Code added END

}