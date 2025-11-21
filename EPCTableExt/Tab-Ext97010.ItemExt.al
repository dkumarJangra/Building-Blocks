tableextension 97010 "EPC Item Ext" extends Item
{
    fields
    {
        // Add changes to table fields here
        field(90001; "Super Area (sq ft)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            Editable = false;
        }
        field(90002; "Saleable Area (sq ft)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
        }
        field(90003; "Carpet Area (sq ft)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';

            trigger OnValidate()
            begin
                IF ("Super Area (sq ft)" <> 0) AND ("Saleable Area (sq ft)" <> 0) THEN
                    "Efficiency (%)" := (("Saleable Area (sq ft)" / "Super Area (sq ft)") * 100);
            end;
        }
        field(90004; "Efficiency (%)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            Editable = true;

            trigger OnValidate()
            begin
                "Carpet Area (sq ft)" := (("Saleable Area (sq ft)" / "Efficiency (%)") * 100);
            end;
        }
        field(90005; "Sales Rate (per sq ft)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
        }
        field(90006; "PLC (%)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            Editable = true;
        }
        field(90007; "Lease Zone Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            Editable = true;
            TableRelation = "Document Master".Code WHERE("Document Type" = FILTER(Zone),
                                                          "Project Code" = FIELD("Job No."));
        }
        field(90010; "Unit Type"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            TableRelation = "Document Master".Code WHERE("Document Type" = FILTER(Unit),
                                                          "Project Code" = FIELD("Project Code"));
        }
        field(90011; "Lease Rate (per sq ft)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
        }
        field(60000; "FA Item"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }

        field(90013; "Lease Blocked"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
        }
        field(90014; "Project Price Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = "Document Master".Code WHERE("Document Type" = FILTER("Project Price Groups"),
                                                          "Project Code" = FIELD("Job No."));
        }
        field(90016; "Sales Order Count"; Integer)
        {
            CalcFormula = Count("Sales Header" WHERE("Order Status" = FILTER(Booked),
                                                      "Sub Document Type" = FILTER(Sales | "Sale Property"),
                                                      "Item Code" = FIELD("No."),
                                                      "Document Type" = FILTER(Order)));
            Description = 'ALLERE';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90017; "Lease Order Count"; Integer)
        {
            CalcFormula = Count("Sales Header" WHERE("Order Status" = FILTER(Booked),
                                                      "Sub Document Type" = FILTER(Lease | "Lease Property"),
                                                      "Item Code" = FIELD("No."),
                                                      "Document Type" = FILTER(Order)));
            Description = 'ALLERE';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90018; "Purchase Order Count"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Property Code" = FIELD("No."),
                                                         "Document Type" = FILTER(Order)));
            Description = 'ALLERE';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90019; "Constructed Property"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            Editable = false;
        }
        field(90050; Type1; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB For Real Estate Property Type';
            OptionCaption = ' ,Flat,Plot,Commercial Space,Villa,Shop,Row House';
            OptionMembers = " ",Flat,Plot,"Commercial Space",Villa,Shop,"Row House";
        }
        field(90051; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB For Real Estate Property Type';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(90052; "Sub Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB For Real Estate Property Type';
            TableRelation = "Dimension Value".Code WHERE(Code = FILTER('PROJECT BLOCK'),
                                                          "LINK to Region Dim" = FIELD("Project Code"));
        }
        field(90053; "Sell to Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = Customer;
        }
        field(90054; "Broker No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = Vendor WHERE("BBG Vendor Category" = FILTER(Transporter));
        }
        field(90055; "Floor No."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90056; "No. of Documents"; Integer)
        {
            CalcFormula = Count(Document WHERE("Table No." = CONST(27),
                                                "Reference No. 1" = FIELD("No.")));
            Description = 'ALLERP KRN0012 31-08-2010:';
            FieldClass = FlowField;
        }
        field(90057; "Land Item"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90058; "Land FG Item"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50002; "Description 3"; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Description 4"; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(50110; "Silver / Gold in Grams"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50100; "Type of Item"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Gold,Silver,Gold_SilverVoucher';
            OptionMembers = " ",Gold,Silver,Gold_SilverVoucher;
        }
        field(50000; "Tolerance  Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ND 261205--JPL';
        }
        field(50010; "Property Unit"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
        }
        field(50011; "Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            TableRelation = Job."No.";
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

    PROCEDURE HistoryFunction(FunctionNo: Integer; Comment: Text[30]);
    BEGIN
        //HistoryRec.HistoryFunction(Rec, FunctionNo, Comment);
    END;
}