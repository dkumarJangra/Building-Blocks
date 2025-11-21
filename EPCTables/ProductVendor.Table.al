table 97750 "Product Vendor"
{
    // ALLERP KRN0014 17-08-2010: New Table created


    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,,Fixed Asset,Resource,Job Master';
            OptionMembers = " ","G/L Account",Item,,"Fixed Asset",Resource,"Job Master";
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            NotBlank = true;
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                IF Vendor.GET("Vendor No.") THEN BEGIN
                    "Lead Time Calculation" := Vendor."Lead Time Calculation";
                    "Expiry Date" := Vendor."BBG Validity till date";
                END;
            end;
        }
        field(6; "Lead Time Calculation"; DateFormula)
        {
            Caption = 'Lead Time Calculation';
        }
        field(7; "Vendor Item No."; Text[20])
        {
            Caption = 'Vendor Item No.';
        }
        field(8; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type = FILTER(Item)) "Item Variant".Code WHERE("Item No." = FIELD("No."));
        }
        field(9; Category; Option)
        {
            Caption = 'Category';
            OptionCaption = 'NON RDSO,RDSO PART 1,RDSO PART 2';
            OptionMembers = "NON RDSO","RDSO PART 1","RDSO PART 2";
        }
        field(10; Selected; Boolean)
        {
            Caption = 'Selected';
        }
        field(11; Append; Boolean)
        {
        }
        field(12; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
        }
    }

    keys
    {
        key(Key1; "Vendor No.", Type, "No.", "Variant Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Vendor: Record Vendor;
}

