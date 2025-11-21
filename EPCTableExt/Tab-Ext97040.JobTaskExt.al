tableextension 97040 "EPC Job Task Ext" extends "Job Task"
{
    fields
    {
        // Add changes to table fields here

        field(50002; Bold; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0011 10-07-2007';
        }
        field(50059; Remark; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00 170412';
        }
        field(50006; "Phase Desc"; Text[150])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0011 10-07-2007';
        }
        field(50003; "Starting Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0011 10-07-2007';
        }
        field(50004; "Ending Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0011 10-07-2007';
        }
        field(50000; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0011 10-07-2007';
        }
        field(50001; "Parent Phase Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0011 10-07-2007';
        }


        field(50005; "Parent Phase Description"; Text[150])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0011 10-07-2007';
        }
        field(50011; Item; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0011 10-07-2007';
        }
        field(50024; "BOQ Type"; Option)
        {
            Caption = 'BOQ Type';
            DataClassification = ToBeClassified;
            Description = 'ALLEAA';
            Editable = true;
            OptionCaption = ' ,Sale,Purchase';
            OptionMembers = " ",Sale,Purchase;
        }
        field(50021; "Total Sales BOQ Amount"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Total Price" WHERE("Job No." = FIELD("Job No."),
                                                                       "Job Task No." = FIELD("Job Task No.")));
            Description = 'AlleBLK';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50027; "Total Purchase BOQ Amount"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Total Cost" WHERE("Job No." = FIELD("Job No."),
                                                                      "Job Task No." = FIELD("Job Task No.")));
            Description = 'ALLEAA';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90026; "Total Tender Rate"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Tender Rate" WHERE("Job No." = FIELD("Job No."),
                                                                       "Job Task No." = FIELD("Job Task No.")));
            Caption = 'Total Tender Rate';
            Description = 'ALLERP KRN0008 18-08-2010:';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50017; "Completed Qty."; Decimal)
        {
            CalcFormula = Sum("Sales Invoice Line".Quantity WHERE("Job Task No." = FIELD("Job Task No."),
                                                                   "Job No." = FIELD("Job No.")));
            Description = 'Alleab';
            FieldClass = FlowField;
        }
        field(50018; "Completed Amt."; Decimal)
        {
            CalcFormula = Sum("Sales Invoice Line"."Line Amount" WHERE("Job Task No." = FIELD("Job Task No."),
                                                                        "Job No." = FIELD("Job No.")));
            Description = 'Alleab';
            FieldClass = FlowField;
        }
        field(50022; "Rejected Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESC';
        }
        field(50023; "Rejected Amt."; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESC';
        }
        field(50019; "Pending Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Alleab';
        }

        field(50014; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0011 10-07-2007';
            TableRelation = "BOQ Item"."Entry No." WHERE("Project Code" = FIELD("Job No."));
        }
        field(50013; "BOQ Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0011 10-07-2007';

            trigger OnValidate()
            begin
                IF BItem.GET("BOQ Code") THEN
                    "Phase Desc" := BItem.Description + BItem."Description 2"
                ELSE
                    "Phase Desc" := '';
            end;
        }
        field(50020; "Pending Amt."; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Alleab';
        }

        field(50015; "BOQ Qty."; Decimal)
        {
            CalcFormula = Sum("Job Planning Line".Quantity WHERE("Job No." = FIELD("Job No."),
                                                                  "Job Task No." = FIELD("Job Task No."),
                                                                  "Job Task No." = FIELD(FILTER(Totaling)),
                                                                  "Contract Line" = CONST(true),
                                                                  "Planning Date" = FIELD("Planning Date Filter")));
            Description = 'ALLETG RIL0100 16-06-2011';
            FieldClass = FlowField;
        }
        field(50016; "BOQ Amt."; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Line Amount (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                             "Job Task No." = FIELD("Job Task No."),
                                                                             "Job Task No." = FIELD(FILTER(Totaling)),
                                                                             "Contract Line" = CONST(true),
                                                                             "Planning Date" = FIELD("Planning Date Filter")));
            Description = 'ALLETG RIL0100 16-06-2011: Same as field Contract (Total Price)';
            FieldClass = FlowField;
        }
        field(90050; "Consinee Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00  150512';

            trigger OnLookup()
            begin
                //RAHEE1.00 150512

                IF ShipJob.GET("Job No.") THEN BEGIN
                    ShiptoAddress.RESET;
                    ShiptoAddress.SETRANGE(ShiptoAddress."Customer No.", ShipJob."Bill-to Customer No.");
                    IF ShiptoAddress.FINDFIRST THEN;
                    IF PAGE.RUNMODAL(Page::"Ship-to Address List", ShiptoAddress, ShiptoAddress.Code) = ACTION::LookupOK THEN
                        "Consinee Code" := ShiptoAddress.Code;
                END;
                //RAHEE1.00 150512
            end;
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
        BItem: Record Item;
        ShiptoAddress: Record "Ship-to Address";
        ShipJob: Record Job;

}