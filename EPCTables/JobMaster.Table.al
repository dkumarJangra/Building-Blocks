table 97724 "Job Master"
{
    // //ALLEAB001: For Job Master No. Series
    // //ALLEAB001: Field Added No. Series
    // //AlleBLk : New fields added

    DrillDownPageID = "Job Master List";
    LookupPageID = "Job Master List";

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[50])
        {

            trigger OnValidate()
            begin
                "Seach Name" := Description;
            end;
        }
        field(3; "Description 2"; Text[50])
        {
        }
        field(4; Rate; Decimal)
        {
        }
        field(5; "Base UOM"; Code[20])
        {
            TableRelation = "Unit of Measure";
        }
        field(6; "Seach Name"; Text[50])
        {
        }
        field(7; "Sub Category"; Code[50])
        {
            TableRelation = "Sub Category";

            trigger OnValidate()
            begin
                IF RecSubCategory.GET("Sub Category") THEN
                    "Sub Category Name" := RecSubCategory.Name;
            end;
        }
        field(8; "Sub Sub Category"; Code[50])
        {
            TableRelation = "Sub Sub Category";

            trigger OnValidate()
            begin
                IF RecSSCategory.GET("Sub Sub Category") THEN
                    "Sub Sub Category Name" := RecSSCategory.Name;
            end;
        }
        field(9; "Description 3"; Text[50])
        {
        }
        field(10; "Description 4"; Text[50])
        {
        }
        field(11; "Special Conditions"; Text[250])
        {
        }
        field(12; Category; Code[20])
        {
            TableRelation = Category;

            trigger OnValidate()
            begin
                IF RecCategory.GET(Category) THEN
                    "Category Name" := RecCategory.Name;
            end;
        }
        field(13; "Category Name"; Text[50])
        {
        }
        field(14; "Sub Category Name"; Text[50])
        {
        }
        field(15; "Sub Sub Category Name"; Text[50])
        {
        }
        field(16; "No. Series"; Code[10])
        {
            Description = 'ALLEAB001';
            TableRelation = "No. Series";
        }
        field(50001; "Default Cost Center Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Description = 'ALLEAB';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                DimValue.RESET;
                DimValue.SETRANGE(Code, "Default Cost Center Code");
                IF DimValue.FIND('-') THEN
                    "Default Cost Center Name" := DimValue.Name;
            end;
        }
        field(50002; "Default Cost Center Name"; Text[30])
        {
            Description = 'AlleBLk';
        }
        field(50003; "Qty. on Work Order"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST(Order),
                                                                               Type = CONST("G/L Account"),
                                                                               "Job Code" = FIELD(Code)));
            Caption = 'Qty. on Work Order';
            DecimalPlaces = 0 : 5;
            Description = 'AlleBLk';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "G/L Code"; Code[10])
        {
            Caption = 'Default G/L Code';
            Description = 'ALLEAA';
            TableRelation = "G/L Account"."No." WHERE("Direct Posting" = FILTER(true));
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; Category)
        {
        }
        key(Key3; "Sub Category")
        {
        }
        key(Key4; Description, "Description 2", "Description 3", "Description 4")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //ALLEAB001
        IF Code = '' THEN BEGIN
            PurAndPay.GET;
            PurAndPay.TESTFIELD("Job No");
            NoSeriesMgt.InitSeries(PurAndPay."Job No", xRec."No. Series", WORKDATE, Code, "No. Series");
        END;
        //ALLEAB001
    end;

    var
        RecCategory: Record Category;
        RecSubCategory: Record "Sub Category";
        RecSSCategory: Record "Sub Sub Category";
        PurAndPay: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimValue: Record "Dimension Value";
}

