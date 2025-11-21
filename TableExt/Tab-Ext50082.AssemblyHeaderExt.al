tableextension 50082 "BBG Assembly Header Ext" extends "Assembly Header"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "Total Area (in Sqyd)"; Decimal)
        {
            CalcFormula = Sum("Assembly Line"."Area (in Sqyd)" WHERE("Document Type" = FIELD("Document Type"),
                                                                      "Document No." = FIELD("No.")));
            Description = 'ALLE_110823';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "Saleable Area %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLE_110823';

            trigger OnValidate()
            begin
                //ALLE_110823
                CALCFIELDS("Total Area (in Sqyd)");
                IF "Saleable Area %" <> 0 THEN BEGIN
                    Quantity := "Total Area (in Sqyd)" * "Saleable Area %" / 100;
                    "Quantity (Base)" := Quantity;
                END ELSE BEGIN
                    Quantity := 0;
                END;
                "Quantity to Assemble" := Quantity;
                "Quantity to Assemble (Base)" := Quantity;
                //ALLE_110823
            end;
        }
        field(50003; "Agreement Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Land Agreement Header"."Document No.";

            trigger OnValidate()
            begin
                //IF "Agreement Document No." <> '' THEN
                //  InsertAgreementLines("Agreement Document No.");
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
}