table 97755 "Applicable Charges"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Charge & Payment Pl. Code";
        }
        field(2; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Unit,Zone,Charge,Brand,Payment Plan,Co-Applicants,Project Price Groups';
            OptionMembers = ,Unit,Zone,Charge,Brand,"Payment Plan","Co-Applicants","Project Price Groups";
        }
        field(3; Description; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Job."No.";
        }
        field(5; "Rate/UOM"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(6; "Fixed Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(7; "BP Dependency"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Rate Not Allowed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Project Price Dependency Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Document Master".Code WHERE("Document Type" = FILTER("Project Price Groups"),
                                                          "Project Code" = FIELD("Project Code"));
        }
        field(10; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Master";
        }
        field(12; "Discount %"; Decimal)
        {
            DataClassification = ToBeClassified;

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
            DataClassification = ToBeClassified;
        }
        field(14; "Net Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 4;
        }
        field(15; "Fixed Discount Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

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
            DataClassification = ToBeClassified;
        }
        field(17; "Direct Associate"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(18; Sequence; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Discount Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEPG 040712';
        }
        field(20; "Membership Fee"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50000; "App. Charge Code"; Code[20])
        {
            DataClassification = ToBeClassified;
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
            DataClassification = ToBeClassified;
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
        key(Key6; "Document No.", "Commision Applicable")
        {
            SumIndexFields = "Net Amount";
        }
        key(Key7; "Document No.", "Direct Associate")
        {
            SumIndexFields = "Net Amount";
        }
    }

    fieldgroups
    {
    }

    var
        Itemrec: Record "Unit Master";
        APPCharge: Record "App. Charge Code";
}

