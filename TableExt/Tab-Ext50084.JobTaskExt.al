tableextension 50084 "BBG Job Task Ext" extends "Job Task"
{
    fields
    {
        // Add changes to table fields here


        field(50007; "Type Filter"; Option)
        {
            Caption = 'Type Filter';
            Description = 'ALLESP BCL0011 10-07-2007';
            FieldClass = FlowFilter;
            OptionCaption = 'Resource,Item,G/L Account,Group (Resource)';
            OptionMembers = Resource,Item,"G/L Account","Group (Resource)";
        }
        field(50008; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Description = 'ALLESP BCL0011 10-07-2007';
            FieldClass = FlowFilter;
        }
        field(50009; "Task Filter"; Code[10])
        {
            Caption = 'Task Filter';
            Description = 'ALLESP BCL0011 10-07-2007';
            FieldClass = FlowFilter;
        }
        field(50010; "Step Filter"; Code[10])
        {
            Caption = 'Step Filter';
            Description = 'ALLESP BCL0011 10-07-2007';
            FieldClass = FlowFilter;
        }

        field(50012; "Budget Allocated"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0011 10-07-2007';
            Editable = false;
        }








        field(50025; "G/L Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50026; "Shortcut Dimension 2 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(50028; "Invoiced Qty."; Decimal)
        {
            CalcFormula = - Sum("Job Ledger Entry".Quantity WHERE("Job No." = FIELD("Job No."),
                                                                  "Job Task No." = FIELD("Job Task No."),
                                                                  "Entry Type" = CONST(Sale)));
            Description = 'ALLEPG 121011';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50050; "BOQ Unit Of Measure"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETG RIL0100 16-06-2011';
            TableRelation = "Unit of Measure";
        }
        field(50051; "Initial BOQ Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETG RIL0100 16-06-2011';
        }
        field(50052; "Initial BOQ Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETG RIL0100 16-06-2011';
        }
        field(50053; "Initial BOQ Total Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETG RIL0100 16-06-2011';
        }
        field(50054; "BOQ Job Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Service,Supply,Supply & Service';
            OptionMembers = Service,Supply,"Supply & Service";
        }
        field(50056; "Progress Quantity"; Decimal)
        {
            CalcFormula = Sum("Job Ledger Entry".Quantity WHERE("Job No." = FIELD("Job No."),
                                                                 "Job Task No." = FIELD("Job Task No."),
                                                                 "Job Task No." = FIELD(FILTER(Totaling)),
                                                                 "Entry Type" = CONST(Progress),
                                                                 "Posting Date" = FIELD("Posting Date Filter")));
            Description = 'ALLETG RIL0100 16-06-2011';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50057; "Total Progress Quantity"; Decimal)
        {
            CalcFormula = Sum("Job Ledger Entry".Quantity WHERE("Job No." = FIELD("Job No."),
                                                                 "Job Task No." = FIELD("Job Task No."),
                                                                 "Job Task No." = FIELD(FILTER(Totaling)),
                                                                 "Entry Type" = CONST(Progress)));
            DecimalPlaces = 0 : 5;
            Description = 'ALLETG RIL0100 16-06-2011';
            Editable = false;
            FieldClass = FlowField;
        }


        field(90017; Selected; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Alleab';

            trigger OnValidate()
            begin
                IF xRec.Selected = TRUE THEN
                    IF CONFIRM('Do you want to remove selection?', FALSE) THEN
                        Selected := FALSE
                    ELSE
                        Selected := TRUE;
            end;
        }
        field(90018; "This Bill Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 1 : 3;
            Description = 'Alleab';

            trigger OnValidate()
            begin
                // RIL1.09 121011 Start
                RemainingQty := Quantity - "Invoiced Qty.";
                IF "This Bill Qty." > RemainingQty THEN
                    ERROR('Qty. Exceeded');
                // RIL1.09 121011 End
            end;
        }
        field(90019; "BOQ Rate Inclusive Tax"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB20-03';
        }
        field(90020; Quantity; Decimal)
        {
            CalcFormula = Sum("Job Planning Line".Quantity WHERE("Job No." = FIELD("Job No."),
                                                                  "Job Task No." = FIELD("Job Task No."),
                                                                  "Explode Lines" = CONST(false)));
            Description = 'RAHEE1.00';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90021; "Unit Cost"; Decimal)
        {
            CalcFormula = Lookup("Job Planning Line"."Direct Unit Cost (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                                     "Job Task No." = FIELD("Job Task No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90022; "Rate Only"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB25-03';
        }
        field(90023; "Non Schedule"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB25-03';
        }

        field(90027; "Total Premium/Disc. Amount"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."BOQ Tender Amount" WHERE("Job No." = FIELD("Job No."),
                                                                             "Job Task No." = FIELD("Job Task No.")));
            Caption = 'Total Premium/Disc. Amount';
            Description = 'ALLERP KRN0008 18-08-2010:';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90028; Weightage; Decimal)
        {
            DataClassification = ToBeClassified;
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

        RemainingQty: Decimal;
        PhaseRec: Record "Job Task";
        JobBudgetLineRec: Record "Job Planning Line";
        ProBudgetLineRec: Record "Project Budget Line Buffer";
        ExtendedTextHdr: Record "Extended Text Header";
        BOQItem: Record "BOQ Item";
        ShiptoAddress: Record "Ship-to Address";
        ShipJob: Record Job;

    trigger OnAfterDelete()
    begin
        //RAHEE1.00 040512
        IF CONFIRM('Do you want to Delete the existing record') THEN BEGIN
            JobBudgetLineRec.RESET;
            JobBudgetLineRec.SETFILTER(JobBudgetLineRec."Job No.", "Job No.");
            JobBudgetLineRec.SETFILTER(JobBudgetLineRec."Job Task No.", "Job Task No.");
            IF JobBudgetLineRec.FINDFIRST THEN BEGIN
                JobBudgetLineRec.DELETE(TRUE);
            END;

            ProBudgetLineRec.RESET;
            ProBudgetLineRec.SETRANGE("Job No.", "Job No.");
            ProBudgetLineRec.SETFILTER(ProBudgetLineRec."Phase Code", "Job Task No.");
            IF ProBudgetLineRec.FINDFIRST THEN BEGIN
                ProBudgetLineRec.DELETE(TRUE);
            END;

            ExtendedTextHdr.RESET;
            ExtendedTextHdr.SETRANGE("No.", "Job No.");
            ExtendedTextHdr.SETRANGE("Text No.", "Entry No.");
            IF ExtendedTextHdr.FINDSET THEN BEGIN
                ExtendedTextHdr.DELETE(TRUE);
            END;

            BOQItem.RESET;
            BOQItem.SETRANGE("Project Code", "Job No.");
            BOQItem.SETRANGE("Entry No.", "Entry No.");
            IF BOQItem.FINDSET THEN BEGIN
                BOQItem.DELETE(TRUE);
            END;

            MESSAGE('Task Successfully performed');
        END;
        //RAHEE1.00 040512
    end;

    PROCEDURE JobLedgerDrillDown();
    VAR
        JobLedgEntry: Record "Job Ledger Entry";
    BEGIN
        //ALLETG RIL0100 15-06-2011: START>>
        JobLedgEntry.RESET;
        JobLedgEntry.SETRANGE("Job No.", "Job No.");
        IF "Job Task Type" = "Job Task Type"::"End-Total" THEN
            JobLedgEntry.SETFILTER("Job Task No.", Totaling)
        ELSE
            JobLedgEntry.SETRANGE("Job Task No.", "Job Task No.");
        JobLedgEntry.SETRANGE("Entry Type", JobLedgEntry."Entry Type"::Progress);
        IF GETFILTER("Posting Date Filter") <> '' THEN
            JobLedgEntry.SETFILTER("Posting Date", GETFILTER("Posting Date Filter"));
        PAGE.RUNMODAL(0, JobLedgEntry);
        //ALLETG RIL0100 15-06-2011: END<<
    END;
}