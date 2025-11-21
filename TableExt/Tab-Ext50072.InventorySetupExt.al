tableextension 50072 "BBG Inventory Setup Ext" extends "Inventory Setup"
{
    fields
    {
        // Add changes to table fields here

        field(50001; "FBW Transfer Order Nos."; Code[10])
        {
            Caption = 'Transfer Order Nos.';
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 231211';
            TableRelation = "No. Series";
        }
        field(50002; "FBW Transfer Order No(Captive)"; Code[10])
        {
            Caption = 'Transfer Order Nos. (Captive)';
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 231211';
            TableRelation = "No. Series";
        }
        field(50003; "FBW Posted Transfer Shpt. Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 231211';
            TableRelation = "No. Series";
        }
        field(50004; "FBW Posted Shpt. No. (Captive)"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 231211';
            TableRelation = "No. Series";
        }
        field(50005; "FBW Posted Transfer Rcpt. Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 231211';
            TableRelation = "No. Series";
        }
        field(50006; "Material Transfer to Site Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 010512';
            TableRelation = "No. Series";
        }
        field(50007; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50008; "Gen. Prod. Posting Group"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(50009; "Inventory Posting Group"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Inventory Posting Group";
        }
        field(50010; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                UnitOfMeasure: Record "Unit of Measure";
            begin
            end;
        }

        field(50012; "Item Revaluation Gen.Bus Group"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Int. Post. Group Finished Item"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Inventory Posting Group";
        }

        field(50015; "Item Lot No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESSS';
            TableRelation = "No. Series";
        }
        field(50016; "FG Item No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50017; "FG Item Gen.Prod. Posting Gr."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(50019; "FG Item Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                UnitOfMeasure: Record "Unit of Measure";
            begin
            end;
        }
        field(50020; "FG Item Global Dim. 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50021; "FG Item Global Dim. 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
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