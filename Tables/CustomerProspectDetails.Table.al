table 60693 "Customer Prospect Details"
{

    fields
    {
        field(1; "Contact No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Project ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center 1";

            trigger OnValidate()
            begin
                IF "Project ID" <> '' THEN BEGIN
                    ResponsibilityCenter.RESET;
                    IF ResponsibilityCenter.GET("Project ID") THEN
                        "Project Name" := ResponsibilityCenter.Name;
                END ELSE
                    "Project Name" := '';
            end;
        }
        field(4; "Project Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Unit ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Master"."No." WHERE("Project Code" = FIELD("Project ID"));

            trigger OnValidate()
            begin
                IF "Unit ID" <> '' THEN BEGIN
                    UnitMaster.RESET;
                    UnitMaster.GET("Unit ID");
                    Area := UnitMaster."Saleable Area";
                    UOM := UnitMaster."Base Unit of Measure";
                END ELSE BEGIN
                    UOM := '';
                    Area := 0;
                END;
            end;
        }
        field(6; "Area"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; UOM; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "PPLan Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "App. Charge Code".Code WHERE("Sub Payment Plan" = CONST(true));

            trigger OnValidate()
            var
                TotalCost: Decimal;
            begin
                IF "PPLan Code" <> '' THEN BEGIN
                    AppChargeCode.GET("PPLan Code");
                    "PPLan Name" := AppChargeCode.Description;
                END ELSE
                    "PPLan Name" := '';

                TotalCost := 0;
                DocumentMasters.RESET;
                DocumentMasters.SETRANGE("Project Code", "Project ID");
                DocumentMasters.SETRANGE("Unit Code", "Unit ID");
                //DocumentMasters.SETRANGE("Document Type",DocumentMasters."Document Type"::"Payment Plan");
                DocumentMasters.SETFILTER(Code, '<>%1&<>%2&<>%3', 'OTH', 'PPLAN', 'PPLAN1');
                DocumentMasters.SETFILTER("Total Charge Amount", '<>%1', 0);
                IF DocumentMasters.FINDSET THEN
                    REPEAT
                        TotalCost := TotalCost + DocumentMasters."Total Charge Amount";
                    UNTIL DocumentMasters.NEXT = 0;

                DocumentMasters.RESET;
                DocumentMasters.SETRANGE("Project Code", "Project ID");
                DocumentMasters.SETRANGE("Unit Code", "Unit ID");
                DocumentMasters.SETRANGE("Document Type", DocumentMasters."Document Type"::"Payment Plan");
                DocumentMasters.SETRANGE(Code, "PPLan Code");
                IF DocumentMasters.FINDFIRST THEN
                    TotalCost := TotalCost + DocumentMasters."Total Charge Amount";

                "Plot Cost" := ROUND(TotalCost, 1, '=');
            end;
        }
        field(9; "Plot Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; "PPLan Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "Application Created"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; "Application Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Application Creation Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Contact No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        BBGSetups: Record "BBG Setups";
        ResponsibilityCenter: Record "Responsibility Center 1";
        UnitMaster: Record "Unit Master";
        AppChargeCode: Record "App. Charge Code";
        DocumentMasters: Record "Document Master";
}

