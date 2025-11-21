tableextension 50051 "BBG Job Journal Line Ext" extends "Job Journal Line"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "BOQ Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0020 13-09-2007';
        }
        field(50001; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0020 13-09-2007';
            TableRelation = "BOQ Item"."Entry No." WHERE("Project Code" = FIELD("Job No."));

            trigger OnValidate()
            var
                JobMst: Record "BOQ Item";
                DimVal: Record "Dimension Value";
            begin
                //ALLESP BCL0020 13-09-2007 Start:
                JobMst.RESET;
                IF JobMst.GET("Job No.", "Entry No.") THEN BEGIN
                    Description := JobMst.Description;
                    VALIDATE("Unit of Measure Code", JobMst."Base UOM");
                END;
                //ALLESP BCL0020 13-09-2007 End:
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
        field(50015; Verified; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEPG 201211';

            trigger OnValidate()
            begin
                IF Verified = TRUE THEN
                    "Verified By" := USERID
                ELSE
                    "Verified By" := '';
            end;
        }
        field(50016; "Verified By"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEPG 201211';
        }

        field(60006; "Indent No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            TableRelation = "Purchase Request Header"."Document No." WHERE("Document Type" = FILTER(Indent),
                                                                            Approved = FILTER(true));
        }
        field(60007; "Indent Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            TableRelation = "Purchase Request Line"."Line No." WHERE("Document Type" = FILTER(Indent),
                                                                      "Document No." = FIELD("Indent No"),
                                                                      Approved = FILTER(true));

            trigger OnLookup()
            var
                POLineRec: Record "Purchase Line";
            begin
            end;
        }

        field(60017; "check FA Item"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ashish';
        }
        field(60018; "Job Contract Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAA';
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