table 50054 "Land Agreement Line"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Vendor Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor WHERE("BBG Land Master" = CONST(true));

            trigger OnValidate()
            var
                Vendor: Record Vendor;
            begin
                "Creation Date" := TODAY;
                IF "Vendor Code" <> '' THEN BEGIN
                    IF Vendor.GET("Vendor Code") THEN
                        "Vendor Name" := Vendor.Name
                    ELSE
                        "Vendor Name" := '';

                    "Shortcut Dimension 1 Code" := '110700';
                    CreateDimensions;
                END;
            end;
        }
        field(4; "Vendor Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "PO No."; Code[20])
        {
            CalcFormula = Lookup("Purchase Header"."No." WHERE("Buy-from Vendor No." = FIELD("Vendor Code"),
                                                              "Land Document No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Order),
                                                         "No." = FIELD("PO No."));
        }
        field(6; "PO Date"; Date)
        {
            CalcFormula = Lookup("Purchase Header"."Posting Date" WHERE("Document Type" = CONST(Order),
                                                                         "No." = FIELD("PO No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "PO Value"; Decimal)
        {
            CalcFormula = Sum("Purchase Line".Amount WHERE("Document Type" = CONST(Order),
                                                            "Buy-from Vendor No." = FIELD("Vendor Code"),
                                                            "Land Agreement No." = FIELD("Document No."),
                                                            "Land Agreement Line No." = FIELD("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "Payment Amount"; Decimal)
        {
            CalcFormula = Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor No." = FIELD("Vendor Code"),
                                                                          "Order Ref No." = FIELD("PO No.")));
            FieldClass = FlowField;
        }
        field(10; "Unit of Measure Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure".Code;

            trigger OnValidate()
            begin
                UpdateValues;
            end;
        }
        field(11; "Land Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Agriculture,Non-Agriculture';
            OptionMembers = " ",Agriculture,"Non-Agriculture";
        }
        field(12; "Co-Ordinates"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Area"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                UpdateValues;
            end;
        }
        field(14; "Nature of Deed"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Transaction Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Outright Purchase';
            OptionMembers = " ","Outright Purchase";
        }
        field(16; "Sale Deed No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Inspected By"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Inspected Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Assigned To"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Considration Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Stamp Duty Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Registration Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Other Charges"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Amount Alloted to Agent"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Land Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(27; Note; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Lease Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(33; "Opportunity Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(34; "Opportunity Document Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Lease Document Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Quantity to PO"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CALCFIELDS("Quantity on PO");
                IF "Quantity to PO" > (Area - "Quantity on PO") THEN
                    ERROR('Quantity to PO can not be greater than =' + FORMAT(Area - "Quantity on PO"));
            end;
        }
        field(37; "Quantity on PO"; Decimal)
        {
            CalcFormula = Sum("Purchase Line".Quantity WHERE("Land Agreement No." = FIELD("Document No."),
                                                              "Land Agreement Line No." = FIELD("Line No."),
                                                              "Buy-from Vendor No." = FIELD("Vendor Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(38; "Quantity in SQYD"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50005; "Area in Acres"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50006; "Area in Guntas"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50007; "Area in Ankanan"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50008; "Area in Cents"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50009; "Area in Sq. Yard"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50012; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Land Value" := "Quantity in SQYD" * "Unit Price";
            end;
        }
        field(50013; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50014; "Land Document Dimension"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50015; "Total Expense to Vendor"; Decimal)
        {
            CalcFormula = Sum("Land Agreement Expense".Amount WHERE("Document No." = FIELD("Document No."),
                                                                     "Document Line No." = FIELD("Line No."),
                                                                     "JV Posted" = CONST(true),
                                                                     "JV Reversed" = CONST(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50018; "Date of Registration"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "Pending From USER ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50040; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Pending For Approval,Approved,Rejected';
            OptionMembers = Open,"Pending For Approval",Approved,Rejected;
        }
        field(50041; "Land Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item;

            trigger OnValidate()
            var
                ItemLedgerEntry: Record "Item Ledger Entry";
                PurchaseLine: Record "Purchase Line";
            begin
            end;
        }
        field(50045; "Total Payment to Vendor"; Decimal)
        {
            CalcFormula = Sum("Land Vendor Receipt Payment".Amount WHERE("Document No." = FIELD("Document No."),
                                                                          "Document Line No." = FIELD("Line No."),
                                                                          Posted = CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Land Value";
        }
        key(Key2; "Document No.", "Vendor Code", "Line No.")
        {
            SumIndexFields = "Land Value";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        LandMasterHeader.RESET;
        LandMasterHeader.GET("Document No.");
        LandMasterHeader.TESTFIELD(Status, LandMasterHeader.Status::Open);
        TESTFIELD("Approval Status", "Approval Status"::Open);
    end;

    trigger OnModify()
    begin
        LandMasterHeader.RESET;
        LandMasterHeader.GET("Document No.");
        LandMasterHeader.TESTFIELD(Status, LandMasterHeader.Status::Open);
    end;

    var
        LandMasterHeader: Record "Land Agreement Header";
        BBGSetups: Record "BBG Setups";
        DivAcres: Decimal;
        DivGunta: Decimal;
        DivCent: Decimal;
        DivAnakanan: Decimal;
        ModAcres: Decimal;
        ModGunta: Decimal;
        ModCent: Decimal;
        ModAnakanan: Decimal;

    local procedure UpdateValues()
    var
        LandAgreementHeader: Record "Land Agreement Header";
        StatewiseMeasurement: Record "State wise Measurement";
    begin

        BBGSetups.GET;

        BBGSetups.GET;
        LandAgreementHeader.RESET;
        IF LandAgreementHeader.GET("Document No.") THEN BEGIN
            StatewiseMeasurement.RESET;
            IF StatewiseMeasurement.GET(LandAgreementHeader."State Code") THEN;
        END;

        IF "Unit of Measure Code" = 'ACRES' THEN BEGIN
            "Area in Acres" := Area;
            "Area in Guntas" := 0;
            "Area in Ankanan" := 0;
            "Area in Cents" := 0;
            "Area in Sq. Yard" := 0;
            "Quantity in SQYD" := Area * StatewiseMeasurement.Acres;
        END ELSE IF "Unit of Measure Code" = 'GUNTAS' THEN BEGIN
            "Area in Acres" := Area DIV BBGSetups.Guntas;
            ModGunta := Area MOD BBGSetups.Guntas;
            "Area in Guntas" := ModGunta;
            "Area in Ankanan" := 0;
            "Area in Cents" := 0;
            "Area in Sq. Yard" := 0;
            "Quantity in SQYD" := Area * StatewiseMeasurement.Acres;
            "Quantity in SQYD" := "Quantity in SQYD" + "Area in Guntas" * StatewiseMeasurement.Guntas;
        END ELSE IF "Unit of Measure Code" = 'CENTS' THEN BEGIN
            "Area in Acres" := Area DIV BBGSetups.Cents;
            ModGunta := Area MOD BBGSetups.Cents;
            "Area in Guntas" := ModGunta DIV BBGSetups.Guntas;
            ModCent := ModGunta MOD BBGSetups.Guntas;
            "Area in Cents" := ModCent;
            "Area in Ankanan" := 0;
            "Area in Sq. Yard" := 0;
            "Quantity in SQYD" := Area * StatewiseMeasurement.Acres;
            "Quantity in SQYD" := "Quantity in SQYD" + "Area in Guntas" * StatewiseMeasurement.Guntas;
            "Quantity in SQYD" := "Quantity in SQYD" + "Area in Cents" * StatewiseMeasurement.Cents;
        END ELSE IF "Unit of Measure Code" = 'ANKANAN' THEN BEGIN
            "Area in Acres" := Area DIV BBGSetups.Ankanan;
            ModGunta := Area DIV BBGSetups.Ankanan;
            "Area in Guntas" := ModGunta DIV BBGSetups.Guntas;
            ModCent := ModGunta MOD BBGSetups.Guntas;
            "Area in Ankanan" := 0;
            "Area in Cents" := ModCent;
            "Area in Sq. Yard" := 0;
        END ELSE IF "Unit of Measure Code" = 'SQYD' THEN BEGIN
            "Area in Acres" := 0;//Area DIV BBGSetups."Sq. Yard";
                                 //ModGunta := Area MOD BBGSetups."Sq. Yard";
            IF Area <> 0 THEN
                "Area in Guntas" := (Area / 121);
            "Area in Ankanan" := 0;
            "Area in Cents" := 0;
            "Area in Sq. Yard" := 0;
            "Quantity in SQYD" := Area;
        END;
    end;

    local procedure CreateDimensions()
    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        DimensionValue: Record "Dimension Value";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        BBGSetups.GET;
        GeneralLedgerSetup.GET;

        BBGSetups.TESTFIELD("Land Expense Dim. No.Series");
        IF "Land Document Dimension" = '' THEN
            "Land Document Dimension" := NoSeriesManagement.GetNextNo(BBGSetups."Land Expense Dim. No.Series", TODAY, TRUE);

        GeneralLedgerSetup.TESTFIELD("Shortcut Dimension 5 Code");

        DimensionValue.RESET;
        IF DimensionValue.GET(GeneralLedgerSetup."Shortcut Dimension 5 Code", "Land Document Dimension") THEN BEGIN
            DimensionValue.Name := FORMAT("Document No.") + ' ' + FORMAT("Line No.") + ' ' + "Vendor Code";
            DimensionValue.MODIFY;
        END ELSE BEGIN
            DimensionValue.RESET;
            DimensionValue.INIT;
            DimensionValue."Dimension Code" := GeneralLedgerSetup."Shortcut Dimension 5 Code";
            DimensionValue.Code := "Land Document Dimension";
            DimensionValue.Name := FORMAT("Document No.") + ' ' + FORMAT("Line No.") + ' ' + "Vendor Code";
            DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::Standard;
            DimensionValue."Global Dimension No." := 5;
            DimensionValue.INSERT;
        END;
    end;
}

