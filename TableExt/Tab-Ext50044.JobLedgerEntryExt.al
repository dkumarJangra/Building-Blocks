tableextension 50044 "BBG Job Ledger Entry Ext" extends "Job Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "BOQ Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0020 13-09-2007';
        }
        field(50001; "Entry No. (BOQ)"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0020 13-09-2007';
            TableRelation = "BOQ Item"."Entry No." WHERE("Project Code" = FIELD("Job No."));

            trigger OnValidate()
            var
                JobMst: Record "BOQ Item";
                DimVal: Record "Dimension Value";
            begin
            end;
        }
        field(50002; Remarks; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0020 13-09-2007';
        }
        field(50003; "Cost Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0020 13-09-2007';
            TableRelation = IF (Type = CONST(Resource)) Resource
            ELSE IF (Type = CONST(Item)) Item
            ELSE IF (Type = CONST("G/L Account")) "G/L Account";
        }
        field(50004; "Invoice Type"; Option)
        {
            Caption = 'Invoice Type';
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0006 19-09-2007';
            OptionCaption = 'Normal,RA,Escalation';
            OptionMembers = Normal,RA,Escalation;
        }

        field(50006; "Tax Group Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Tax Area Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Tax %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Service Tax Base Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Tax Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "Service Tax Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Service Tax Ecess Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Service Tax She cess Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Tax Base Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "Verified By"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEPG 201211';
        }
        field(80013; "Fixed Asset No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Asset";
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