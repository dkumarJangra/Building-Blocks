table 97797 "FOC/PO TABLE"
{
    // //ALLEAB 1.0 For Closing Date Updation
    // //RAHEE1.00 Added new fields
    // //RAHEE1.00 080512 Added new fields and Code update for Explode BOM FOC Item.
    // //RAHEE1.00 110512 Code Comment in case of Finished Goods.

    Caption = 'FOC/ITEM SHEET';
    DrillDownPageID = "FOC LIST";
    LookupPageID = "FOC LIST";

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Quality';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Quality;
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Date; Date)
        {
            Caption = 'Date';
        }
        field(5; "Job Code"; Code[20])
        {
        }
        field(6; "Item Code"; Code[20])
        {
            TableRelation = Item;

            trigger OnValidate()
            begin
                PHREC.SETRANGE(PHREC."Document Type", "Document Type");
                PHREC.SETRANGE(PHREC."No.", "No.");
                IF PHREC.FIND('-') THEN BEGIN
                    "Job Code" := PHREC."Job No.";
                    "Vendor Code" := PHREC."Buy-from Vendor No.";
                    Date := WORKDATE;
                    RespCenter.RESET;
                    IF RespCenter.GET(PHREC."Responsibility Center") THEN BEGIN
                        RespCenter.TESTFIELD("Subcon/Site Location");
                        "Contractor Location Code" := RespCenter."Subcon/Site Location";
                    END;
                END;

                GetItem;
                BEGIN
                    "Item Description" := Item.Description;
                    "Description 2" := Item."Description 2";
                    UOM := Item."Base Unit of Measure";
                END;

                IF "No." <> '' THEN BEGIN
                    IF "Item Code" <> '' THEN BEGIN
                        IF "Parent Item Code" <> '' THEN
                            ERROR('Parent Item Code must be blank');
                    END;
                END;
            end;
        }
        field(7; Type; Option)
        {
            OptionCaption = 'FOC,Recovery,Security,Finished';
            OptionMembers = FOC,Recovery,Security,Finished;

            trigger OnValidate()
            begin
                /*  //RAHEE1.00 110512
                //RAHEE1.00
                
                IF Type = Type::Finished THEN BEGIN
                  PHRec1.RESET;
                  PHRec1.SETRANGE(PHRec1."Document Type","Document Type");
                  PHRec1.SETRANGE(PHRec1."No.","No.");
                   IF PHRec1.FIND('-') THEN BEGIN
                       "Contractor Location Code" := PHRec1."Responsibility Center";
                    END;
                END;
                //RAHEE1.00
                
                */ //RAHEE1.00 110512

            end;
        }
        field(8; "Issue From Date"; Date)
        {
        }
        field(9; "Issue To Date"; Date)
        {
        }
        field(10; Quantity; Decimal)
        {

            trigger OnValidate()
            begin
                //IF "No." <> '' THEN BEGIN
                Amount := Quantity * "Unit Price"; //RAHEE1.00 080512
                //END;
            end;
        }
        field(11; "Rate (%)"; Option)
        {
            OptionCaption = '% Base,Value';
            OptionMembers = "% Base",Value;
        }
        field(12; Amount; Decimal)
        {
        }
        field(13; "Absolute Amount"; Decimal)
        {
        }
        field(14; "Vendor Code"; Code[20])
        {
        }
        field(15; Close; Boolean)
        {
        }
        field(16; "Quantity Issued"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Location Code" = FIELD("Contractor Location Code"),
                                                                  Quantity = FILTER(> 0),
                                                                  "PO No." = FIELD("No."),
                                                                  "Entry Type" = CONST(Transfer),
                                                                  "Item No." = FIELD("Item Code"),
                                                                  "Transfer FG" = CONST(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Quantity Returned"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Location Code" = FIELD("Contractor Location Code"),
                                                                  Quantity = FILTER(< 0),
                                                                  "PO No." = FIELD("No."),
                                                                  "Entry Type" = CONST(Transfer),
                                                                  "Item No." = FIELD("Item Code"),
                                                                  "Transfer FG" = CONST(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Quantity Consumed"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Location Code" = FIELD("Contractor Location Code"),
                                                                  "PO No." = FIELD("No."),
                                                                  "Entry Type" = FILTER("Negative Adjmt." | "Positive Adjmt."),
                                                                  "Item No." = FIELD("Item Code"),
                                                                  "Transfer FG" = CONST(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Item Description"; Text[50])
        {
        }
        field(20; UOM; Code[20])
        {
        }
        field(21; Issued; Decimal)
        {
            Editable = false;
        }
        field(22; Returned; Decimal)
        {
            Editable = false;
        }
        field(23; Consumed; Decimal)
        {
            Editable = false;
        }
        field(24; "Provisional Consumption"; Decimal)
        {
            Editable = false;
        }
        field(25; "Vendor Name"; Text[50])
        {
        }
        field(26; closed; Boolean)
        {

            trigger OnValidate()
            begin
                //ALLEAB 1.0 For Closing Date Updation
                IF closed = TRUE THEN BEGIN
                    IF "Closing Date" = 0D THEN
                        "Closing Date" := TODAY;
                END
                ELSE
                    "Closing Date" := 0D;
                //ALLEAB 1.0 For Closing Date Updation
            end;
        }
        field(27; "Budgeted Quantity"; Decimal)
        {
        }
        field(28; "Issue Status"; Option)
        {
            NotBlank = false;
            OptionCaption = ' ,Start,Closed';
            OptionMembers = " ",Start,Closed;

            trigger OnValidate()
            begin
                //ALLEAB 1.0 For Closing Date Updation
                IF "Issue Status" = "Issue Status"::Closed THEN BEGIN
                    IF "Closing Date" = 0D THEN
                        "Closing Date" := TODAY;
                END
                ELSE
                    "Closing Date" := 0D;
                //ALLEAB 1.0 For Closing Date Updation
            end;
        }
        field(29; "Closing Date"; Date)
        {
            Description = 'AlleAA As per talk with Mr. Rana';
        }
        field(30; "Quantity Received"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Location Code" = FIELD("Contractor Location Code"),
                                                                  "PO No." = FIELD("No."),
                                                                  "Entry Type" = FILTER(Transfer),
                                                                  "Item No." = FIELD("Item Code"),
                                                                  "Transfer FG" = CONST(true),
                                                                  Quantity = FILTER(> 0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "Contractor Location Code"; Code[20])
        {
            TableRelation = Location;
        }
        field(32; "Parent Item Code"; Code[20])
        {
            Description = 'RAHEE1.00 080512';
            TableRelation = Item;

            trigger OnValidate()
            begin
                IF "No." <> '' THEN
                    IF "Item Code" <> '' THEN
                        ERROR('You can not define Item Code with Parent Item Code');
            end;
        }
        field(33; "Unit Price"; Decimal)
        {
            Description = 'RAHEE1.00 080512';

            trigger OnValidate()
            begin
                //IF "No." <> '' THEN BEGIN
                Amount := Quantity * "Unit Price"; //RAHEE1.00 080512
                //END;
            end;
        }
        field(34; "Description 2"; Text[50])
        {
            Description = 'RAHEE1.00 100512';
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.", "Parent Item Code", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Job Code", "Vendor Code")
        {
        }
        key(Key3; "No.", "Line No.")
        {
        }
        key(Key4; "Document Type", "No.", "Item Code", "Parent Item Code", "Line No.")
        {
        }
        key(Key5; "Document Type", "No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        /*
        PHREC.SETRANGE(PHREC."Document Type",PHREC."Document Type"::Order);
        PHREC.SETRANGE(PHREC."No.","No.");
        IF PHREC.FIND('-') THEN
        BEGIN
         IF (PHREC.Authorized=TRUE) THEN
         ERROR('You Can Not Modify Authorized Document');
        END;
        */

    end;

    var
        PHREC: Record "Purchase Header";
        Item: Record Item;
        RespCenter: Record "Responsibility Center 1";
        PHRec1: Record "Purchase Header";


    procedure SetUpNewLine()
    var
        PurchHeader: Record "FOC/PO TABLE";
    begin
        PurchHeader.SETRANGE("Document Type", "Document Type");
        PurchHeader.SETRANGE("No.", "No.");
        PurchHeader.SETRANGE(Date, WORKDATE);
        IF NOT PurchHeader.FIND('-') THEN
            Date := WORKDATE;
    end;

    local procedure GetItem()
    begin
        TESTFIELD("Item Code");
        IF Item."No." <> "Item Code" THEN
            Item.GET("Item Code");
    end;
}

