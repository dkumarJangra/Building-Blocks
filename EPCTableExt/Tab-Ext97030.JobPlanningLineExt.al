tableextension 97030 "EPC Job Planning Line Ext" extends "Job Planning Line"
{
    fields
    {
        // Add changes to table fields here
        field(90013; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0011 10-07-2007';
            TableRelation = "BOQ Item"."Entry No." WHERE("Project Code" = FIELD("Job No."));

            trigger OnValidate()
            var
                BOQMst: Record "BOQ Item";
            begin
                //ALLESP BCL0011 11-07-2007 Start:
                IF BOQMst.GET("Job No.", "Entry No.") THEN;
                //ALLESP BCL0011 11-07-2007 End:
            end;
        }
        field(90035; "Explode Lines"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00';
        }
        field(50098; "Workflow Approval Status"; Option)
        {
            Caption = 'Workflow Approval Status';
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval';
            OptionMembers = Open,Released,"Pending Approval";
        }
        field(90026; "Tender Rate"; Decimal)
        {
            Caption = 'Tender Rate';
            DataClassification = ToBeClassified;
            Description = 'ALLERP KRN0008 18-08-2010:';
        }
        field(90027; "BOQ Tender Amount"; Decimal)
        {
            Caption = 'Premium/Discount Amount';
            DataClassification = ToBeClassified;
            Description = 'ALLERP KRN0008 18-08-2010:';
        }
        field(50058; "Contract Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00 170412';
        }
        field(50059; Remark; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00 170412';
        }
        field(90032; "BOQ Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0019 23-07-2007';
        }
        field(90024; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(90031; "Job Master Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Job Master".Code;

            trigger OnValidate()
            begin
                // ALLEAA
                IF JobMaster.GET("Job Master Code") THEN BEGIN
                    VALIDATE(Type, Type::"G/L Account");
                    VALIDATE("No.", JobMaster."G/L Code");
                    VALIDATE("Shortcut Dimension 2 Code", JobMaster."Default Cost Center Code");
                END ELSE BEGIN
                    VALIDATE(Type);
                    VALIDATE("No.");
                    VALIDATE("Shortcut Dimension 2 Code");
                END

                // ALLEAA
            end;
        }
        field(90028; "Delivery Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(90029; "Inspection by"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(90030; Source; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(50100; "Indent Quantity"; Decimal)
        {
            CalcFormula = Sum("Purchase Request Line"."Approved Qty" WHERE("Job No." = FIELD("Job No."),
                                                                            "Job Task No." = FIELD("Job Task No."),
                                                                            "Job Planning Line No." = FIELD("Line No.")));
            Description = 'KLND1.00 150311';
            FieldClass = FlowField;
        }
        field(90003; "Ending Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0011 10-07-2007';
        }
        field(90022; "BOQ Type"; Option)
        {
            Caption = 'BOQ Type';
            DataClassification = ToBeClassified;
            Description = 'ALLEAA';
            Editable = true;
            OptionCaption = ' ,Sale,Purchase';
            OptionMembers = " ",Sale,Purchase;
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
        JobMaster: Record "Job Master";
        GLBudgetEntry: Record "G/L Budget Entry";
        RecUserSetup: Record "User Setup";
        RecRespCenter: Record "Responsibility Center 1";
}