table 97866 "Applicable Charges new"
{
    // ALLECK 220612 : Changed the name of "Rate SOFT" field to "Rate/UOM "

    DataCaptionFields = "Document Type", "Code", Description;
    DrillDownPageID = "Responsibility Center";
    LookupPageID = "Responsibility Center";

    fields
    {
        field(1; "Code"; Code[20])
        {
            TableRelation = "Unit Charge & Payment Pl. Code";
        }
        field(2; "Document Type"; Option)
        {
            OptionCaption = ',Unit,Zone,Charge,Brand,Payment Plan,Co-Applicants,Project Price Groups';
            OptionMembers = ,Unit,Zone,Charge,Brand,"Payment Plan","Co-Applicants","Project Price Groups";
        }
        field(3; Description; Text[30])
        {
        }
        field(4; "Project Code"; Code[20])
        {
            TableRelation = Job."No.";
        }
        field(5; "Rate/UOM"; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(6; "Fixed Price"; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(7; "BP Dependency"; Boolean)
        {
        }
        field(8; "Rate Not Allowed"; Boolean)
        {
        }
        field(9; "Project Price Dependency Code"; Code[20])
        {
            TableRelation = "Document Master".Code WHERE("Document Type" = FILTER("Project Price Groups"),
                                                          "Project Code" = FIELD("Project Code"));
        }
        field(10; "Document No."; Code[20])
        {
        }
        field(11; "Item No."; Code[20])
        {
            TableRelation = "Unit Master";
        }
        field(12; "Discount %"; Decimal)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Fixed Discount Amount", 0);
                IF CONFIRM('Do you want to continue', TRUE) THEN BEGIN

                    IF "Fixed Price" <> 0 THEN BEGIN
                        "Net Amount" := "Fixed Price" - ("Fixed Price" * "Discount %") / 100;
                    END
                    ELSE IF "Rate/UOM" <> 0 THEN BEGIN
                        Itemrec.RESET;
                        Itemrec.GET("Item No.");
                        "Net Amount" := ("Rate/UOM" - (("Rate/UOM" * "Discount %") / 100)) * Itemrec."Saleable Area";
                        "Discount Amount" := (("Rate/UOM" * Itemrec."Saleable Area") * "Discount %") / 100;  // ALLEPG 040712
                    END;
                END;
            end;
        }
        field(13; Applicable; Boolean)
        {
        }
        field(14; "Net Amount"; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(15; "Fixed Discount Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Discount %", 0);
                //"Net Amount":="Net Amount"-"Fixed Discount Amount";
                IF CONFIRM('Do you want to continue', TRUE) THEN BEGIN
                    IF "Fixed Price" <> 0 THEN BEGIN
                        "Net Amount" := "Fixed Price" - "Fixed Discount Amount";
                    END
                    ELSE IF "Rate/UOM" <> 0 THEN BEGIN
                        Itemrec.RESET;
                        Itemrec.GET("Item No.");
                        "Net Amount" := ("Rate/UOM" - "Fixed Discount Amount") * Itemrec."Saleable Area";
                    END;
                END;
            end;
        }
        field(16; "Commision Applicable"; Boolean)
        {
        }
        field(17; "Direct Associate"; Boolean)
        {
        }
        field(18; Sequence; Integer)
        {
        }
        field(19; "Discount Amount"; Decimal)
        {
            Description = 'ALLEPG 040712';
        }
        field(20; "Membership Fee"; Boolean)
        {
        }
        field(50000; "App. Charge Code"; Code[20])
        {
            Editable = false;
            TableRelation = "App. Charge Code".Code;

            trigger OnValidate()
            begin
                IF "App. Charge Code" <> '' THEN
                    IF APPCharge.GET("App. Charge Code") THEN
                        "App. Charge Name" := APPCharge.Description;
                MODIFY;
            end;
        }
        field(50001; "App. Charge Name"; Text[60])
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "Project Code", "Code", "Document No.", "Item No.")
        {
            Clustered = true;
        }
        key(Key2; "Document Type", "Code")
        {
        }
        key(Key3; "Document No.", Sequence)
        {
        }
        key(Key4; "Document No.", Applicable, "Membership Fee")
        {
            SumIndexFields = "Net Amount";
        }
        key(Key5; "Project Code", "Document No.", "Item No.", "Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Itemrec: Record "Unit Master";
        APPCharge: Record "App. Charge Code";
}

