table 97763 "PLC Details"
{

    fields
    {
        field(1; "Job Code"; Code[20])
        {
            TableRelation = Job."No.";
        }
        field(2; "Code"; Code[20])
        {
            TableRelation = PLC.Code WHERE("Job Code" = FIELD("Job Code"));

            trigger OnValidate()
            begin
                IF PLCMaster.GET("Job Code", Code) THEN BEGIN
                    IF PLCMaster."Rate (sq ft)" <> 0 THEN BEGIN
                        Description := PLCMaster.Description;
                        "Rate (sq ft)" := PLCMaster."Rate (sq ft)";
                        Item.GET("Item Code");
                        "Super Area (sq ft)" := Item."Saleable Area (sq ft)";
                        Amount := "Rate (sq ft)" * "Super Area (sq ft)";
                        VALIDATE("Net Amount");
                    END
                    ELSE IF PLCMaster."Fixed Amount" <> 0 THEN BEGIN
                        Description := PLCMaster.Description;
                        Amount := PLCMaster."Fixed Amount";
                    END
                    ELSE IF PLCMaster."PLC % Amount" <> 0 THEN BEGIN
                        Item.GET("Item Code");
                        Description := PLCMaster.Description;
                        Amount := Item."Saleable Area (sq ft)" * PLCMaster."PLC % Amount";
                    END;
                END;
            end;
        }
        field(3; "Line No."; Integer)
        {
        }
        field(4; Description; Text[60])
        {
        }
        field(5; "Rate (sq ft)"; Decimal)
        {
        }
        field(6; "Super Area (sq ft)"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                VALIDATE(Amount, "Rate (sq ft)" * "Super Area (sq ft)");
            end;
        }
        field(7; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                VALIDATE("Net Amount");
            end;
        }
        field(8; "Discount %"; Decimal)
        {

            trigger OnValidate()
            begin
                IF PLCMaster.GET("Job Code", Code) THEN
                    IF NOT PLCMaster."Discount Applicable" THEN
                        ERROR(Text0001);

                VALIDATE("Net Amount");
            end;
        }
        field(9; "Net Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                IF "Discount %" <> 0 THEN
                    "Net Amount" := Amount - Amount * "Discount %" / 100
                ELSE
                    "Net Amount" := Amount;
            end;
        }
        field(10; "Item Code"; Code[20])
        {
            TableRelation = Item."No." WHERE("Property Unit" = FILTER(true));
        }
    }

    keys
    {
        key(Key1; "Job Code", "Code", "Item Code", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Net Amount";
        }
    }

    fieldgroups
    {
    }

    var
        PLCMaster: Record PLC;
        Item: Record Item;
        Text0001: Label 'Discount Applicable Must be True ';
}

