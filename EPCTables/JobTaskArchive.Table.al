table 97766 "EPC Job Task Archive"
{
    // ALLERP KRN0008 18-08-2010: Field 90026 and 90027 added

    Caption = 'Job Task Archive';
    DrillDownPageID = "EPC Job Task Archive Lines";
    LookupPageID = "EPC Job Task Archive Lines";

    fields
    {
        field(1; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            Editable = false;
            NotBlank = true;
            TableRelation = Job;
        }
        field(2; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            NotBlank = true;

            trigger OnValidate()
            var
                Job: Record Job;
                Cust: Record Customer;
            begin
                IF "Job Task No." = '' THEN
                    EXIT;
                Job.GET("Job No.");
                //IF Job."Job Type" <> Job."Job Type"::"Capital WIP" THEN BEGIN
                Job.TESTFIELD("Bill-to Customer No.");
                Cust.GET(Job."Bill-to Customer No.");
                //END;
                "Job Posting Group" := Job."Job Posting Group";
            end;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(4; "Job Task Type"; Option)
        {
            Caption = 'Job Task Type';
            OptionCaption = 'Posting,Heading,Total,Begin-Total,End-Total';
            OptionMembers = Posting,Heading,Total,"Begin-Total","End-Total";

            trigger OnValidate()
            begin
                IF (xRec."Job Task Type" = "Job Task Type"::Posting) AND
                   ("Job Task Type" <> "Job Task Type"::Posting)
                THEN
                    IF JobLedgEntriesExist OR JobPlanningLinesExist THEN
                        ERROR(Text001, FIELDCAPTION("Job Task Type"), TABLECAPTION);

                IF "Job Task Type" <> "Job Task Type"::Posting THEN
                    "Job Posting Group" := '';

                Totaling := '';
            end;
        }
        field(6; "WIP-Total"; Option)
        {
            Caption = 'WIP-Total';
            OptionCaption = ' ,Total,Closed';
            OptionMembers = " ",Total,Closed;
        }
        field(7; "Job Posting Group"; Code[10])
        {
            Caption = 'Job Posting Group';
            TableRelation = "Job Posting Group";

            trigger OnValidate()
            begin
                IF "Job Posting Group" <> '' THEN
                    TESTFIELD("Job Task Type", "Job Task Type"::Posting);
                IF "Job Posting Group" <> xRec."Job Posting Group" THEN BEGIN
                    Job.GET("Job No.");
                    //IF Job."Job Type" = Job."Job Type"::"Capital WIP" THEN BEGIN
                    JobWIPGLEntry.SETRANGE("Job No.", "Job No.");
                    // IF JobWIPGLEntry.FINDFIRST AND "WIP Calculated" THEN
                    //     ERROR(Text16500, FIELDCAPTION("Job Posting Group"), "Job No.", Job."Job Type");
                    // //END;
                END;
            end;
        }
        field(8; "WIP Method Used"; Option)
        {
            Caption = 'WIP Method Used';
            Editable = false;
            OptionCaption = ' ,Cost Value,Sales Value,Cost of Sales,Percentage of Completion,Completed Contract';
            OptionMembers = " ","Cost Value","Sales Value","Cost of Sales","Percentage of Completion","Completed Contract";
        }
        field(10; "Schedule (Total Cost)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("EPC Job Planning Line Archive"."Total Cost (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                                    "Job Task No." = FIELD("Job Task No."),
                                                                                    "Job Task No." = FIELD(FILTER(Totaling)),
                                                                                    "Schedule Line" = CONST(true),
                                                                                    "Planning Date" = FIELD("Planning Date Filter"),
                                                                                    "Version No." = FIELD("Version No.")));
            Caption = 'Schedule (Total Cost)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Schedule (Total Price)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Job Planning Line Archive"."Line Amount (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                                     "Job Task No." = FIELD("Job Task No."),
                                                                                     "Job Task No." = FIELD(FILTER(Totaling)),
                                                                                     "Schedule Line" = CONST(true),
                                                                                     "Planning Date" = FIELD("Planning Date Filter"),
                                                                                     "Version No." = FIELD("Version No.")));
            Caption = 'Schedule (Total Price)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Usage (Total Cost)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Job Ledger Entry"."Total Cost (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                           "Job Task No." = FIELD("Job Task No."),
                                                                           "Job Task No." = FIELD(FILTER(Totaling)),
                                                                           "Entry Type" = CONST(Usage),
                                                                           "Posting Date" = FIELD("Posting Date Filter")));
            Caption = 'Usage (Total Cost)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Usage (Total Price)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Job Ledger Entry"."Line Amount (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                            "Job Task No." = FIELD("Job Task No."),
                                                                            "Job Task No." = FIELD(FILTER(Totaling)),
                                                                            "Entry Type" = CONST(Usage),
                                                                            "Posting Date" = FIELD("Posting Date Filter")));
            Caption = 'Usage (Total Price)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Contract (Total Cost)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Job Planning Line Archive"."Total Cost (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                                    "Job Task No." = FIELD("Job Task No."),
                                                                                    "Job Task No." = FIELD(FILTER(Totaling)),
                                                                                    "Contract Line" = CONST(true),
                                                                                    "Planning Date" = FIELD("Planning Date Filter"),
                                                                                    "Version No." = FIELD("Version No.")));
            Caption = 'Contract (Total Cost)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Contract (Total Price)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Job Planning Line Archive"."Line Amount (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                                     "Job Task No." = FIELD("Job Task No."),
                                                                                     "Job Task No." = FIELD(FILTER(Totaling)),
                                                                                     "Contract Line" = CONST(true),
                                                                                     "Planning Date" = FIELD("Planning Date Filter"),
                                                                                     "Version No." = FIELD("Version No.")));
            Caption = 'Contract (Total Price)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Contract (Invoiced Price)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = - Sum("Job Ledger Entry"."Line Amount (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                             "Job Task No." = FIELD("Job Task No."),
                                                                             "Job Task No." = FIELD(FILTER(Totaling)),
                                                                             "Entry Type" = CONST(Sale),
                                                                             "Posting Date" = FIELD("Posting Date Filter")));
            Caption = 'Contract (Invoiced Price)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Contract (Invoiced Cost)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = - Sum("Job Ledger Entry"."Total Cost (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                            "Job Task No." = FIELD("Job Task No."),
                                                                            "Job Task No." = FIELD(FILTER(Totaling)),
                                                                            "Entry Type" = CONST(Sale),
                                                                            "Posting Date" = FIELD("Posting Date Filter")));
            Caption = 'Contract (Invoiced Cost)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Posting Date Filter"; Date)
        {
            Caption = 'Posting Date Filter';
            FieldClass = FlowFilter;
        }
        field(20; "Planning Date Filter"; Date)
        {
            Caption = 'Planning Date Filter';
            FieldClass = FlowFilter;
        }
        field(21; Totaling; Text[250])
        {
            Caption = 'Totaling';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                IF NOT ("Job Task Type" IN ["Job Task Type"::Total, "Job Task Type"::"End-Total"]) THEN
                    FIELDERROR("Job Task Type");
                CALCFIELDS(
                  "Schedule (Total Cost)",
                  "Schedule (Total Price)",
                  "Usage (Total Cost)",
                  "Usage (Total Price)",
                  "Contract (Total Cost)",
                  "Contract (Total Price)",
                  "Contract (Invoiced Price)",
                  "Contract (Invoiced Cost)");
            end;
        }
        field(22; "New Page"; Boolean)
        {
            Caption = 'New Page';
        }
        field(23; "No. of Blank Lines"; Integer)
        {
            BlankZero = true;
            Caption = 'No. of Blank Lines';
            MinValue = 0;
        }
        field(24; Indentation; Integer)
        {
            Caption = 'Indentation';
            MinValue = 0;
        }
        field(25; "WIP Posting Date"; Date)
        {
            Caption = 'WIP Posting Date';
            Editable = false;
        }
        field(26; "WIP %"; Decimal)
        {
            AutoFormatType = 2;
            BlankZero = true;
            Caption = 'WIP %';
            Editable = false;
        }
        field(27; "WIP Account"; Code[20])
        {
            Caption = 'WIP Account';
            Editable = false;
            TableRelation = "G/L Account";
        }
        field(28; "WIP Balance Account"; Code[20])
        {
            Caption = 'WIP Balance Account';
            Editable = false;
            TableRelation = "G/L Account";
        }
        field(29; "WIP Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'WIP Amount';
            Editable = false;
        }
        field(31; "Invoiced Sales Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Invoiced Sales Amount';
            Editable = false;
        }
        field(32; "Invoiced Sales Account"; Code[20])
        {
            Caption = 'Invoiced Sales Account';
            Editable = false;
            TableRelation = "G/L Account";
        }
        field(33; "Invoiced Sales Bal. Account"; Code[20])
        {
            Caption = 'Invoiced Sales Bal. Account';
            Editable = false;
            TableRelation = "G/L Account";
        }
        field(34; "Recognized Sales Amount"; Decimal)
        {
            BlankZero = true;
            Caption = 'Recognized Sales Amount';
            Editable = false;
        }
        field(35; "Recognized Sales Account"; Code[20])
        {
            Caption = 'Recognized Sales Account';
            Editable = false;
            TableRelation = "G/L Account";
        }
        field(36; "Recognized Sales Bal. Account"; Code[20])
        {
            Caption = 'Recognized Sales Bal. Account';
            Editable = false;
            TableRelation = "G/L Account";
        }
        field(37; "Recognized Costs Amount"; Decimal)
        {
            BlankZero = true;
            Caption = 'Recognized Costs Amount';
            Editable = false;
        }
        field(38; "Recognized Costs Account"; Code[20])
        {
            Caption = 'Recognized Costs Account';
            Editable = false;
            TableRelation = "G/L Account";
        }
        field(39; "Recognized Costs Bal. Account"; Code[20])
        {
            Caption = 'Recognized Costs Bal. Account';
            Editable = false;
            TableRelation = "G/L Account";
        }
        field(40; "WIP Schedule (Total Cost)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'WIP Schedule (Total Cost)';
            Editable = false;
        }
        field(41; "WIP Schedule (Total Price)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'WIP Schedule (Total Price)';
            Editable = false;
        }
        field(42; "WIP Usage (Total Cost)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'WIP Usage (Total Cost)';
            Editable = false;
        }
        field(43; "WIP Usage (Total Price)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'WIP Usage (Total Price)';
            Editable = false;
        }
        field(44; "WIP Contract (Total Cost)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'WIP Contract (Total Cost)';
            Editable = false;
        }
        field(45; "WIP Contract (Total Price)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'WIP Contract (Total Price)';
            Editable = false;
        }
        field(46; "WIP (Invoiced Price)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'WIP (Invoiced Price)';
            Editable = false;
        }
        field(47; "WIP (Invoiced Cost)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'WIP (Invoiced Cost)';
            Editable = false;
        }
        field(48; "WIP Posting Date Filter"; Text[250])
        {
            Caption = 'WIP Posting Date Filter';
            Editable = false;
        }
        field(49; "WIP Planning Date Filter"; Text[250])
        {
            Caption = 'WIP Planning Date Filter';
            Editable = false;
        }
        field(50; "WIP Sales Account"; Code[20])
        {
            Caption = 'WIP Sales Account';
            Editable = false;
            TableRelation = "G/L Account";
        }
        field(51; "WIP Sales Balance Account"; Code[20])
        {
            Caption = 'WIP Sales Balance Account';
            Editable = false;
            TableRelation = "G/L Account";
        }
        field(52; "WIP Costs Account"; Code[20])
        {
            Caption = 'WIP Costs Account';
            Editable = false;
            TableRelation = "G/L Account";
        }
        field(53; "WIP Costs Balance Account"; Code[20])
        {
            Caption = 'WIP Costs Balance Account';
            Editable = false;
            TableRelation = "G/L Account";
        }
        field(54; "Cost Completion %"; Decimal)
        {
            AutoFormatType = 2;
            BlankZero = true;
            Caption = 'Cost Completion %';
            Editable = false;
        }
        field(55; "Invoiced %"; Decimal)
        {
            AutoFormatType = 2;
            BlankZero = true;
            Caption = 'Invoiced %';
            Editable = false;
        }
        field(60; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(61; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(62; "Outstanding Orders"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Outstanding Amount (LCY)" WHERE("Document Type" = CONST(Order),
                                                                                "Job No." = FIELD("Job No."),
                                                                                "Job Task No." = FIELD("Job Task No."),
                                                                                "Job Task No." = FIELD(FILTER(Totaling))));
            Caption = 'Outstanding Orders';
            FieldClass = FlowField;
        }
        field(63; "Amt. Rcd. Not Invoiced"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Amt. Rcd. Not Invoiced (LCY)" WHERE("Document Type" = CONST(Order),
                                                                                    "Job No." = FIELD("Job No."),
                                                                                    "Job Task No." = FIELD("Job Task No."),
                                                                                    "Job Task No." = FIELD(FILTER(Totaling))));
            Caption = 'Amt. Rcd. Not Invoiced';
            FieldClass = FlowField;
        }
        field(16500; "WIP Calculated"; Boolean)
        {
            Caption = 'WIP Calculated';
            Editable = false;
        }
        field(50000; Blocked; Boolean)
        {
            Caption = 'Blocked';
            Description = 'ALLESP BCL0011 10-07-2007';
        }
        field(50001; "Parent Phase Code"; Code[10])
        {
            Description = 'ALLESP BCL0011 10-07-2007';
        }
        field(50002; Bold; Boolean)
        {
            Description = 'ALLESP BCL0011 10-07-2007';
        }
        field(50003; "Starting Date"; Date)
        {
            Description = 'ALLESP BCL0011 10-07-2007';
        }
        field(50004; "Ending Date"; Date)
        {
            Description = 'ALLESP BCL0011 10-07-2007';
        }
        field(50005; "Parent Phase Description"; Text[150])
        {
            Description = 'ALLESP BCL0011 10-07-2007';
        }
        field(50006; "Phase Desc"; Text[150])
        {
            Description = 'ALLESP BCL0011 10-07-2007';
        }
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
        field(50011; Item; Boolean)
        {
            Description = 'ALLESP BCL0011 10-07-2007';
        }
        field(50012; "Budget Allocated"; Decimal)
        {
            Description = 'ALLESP BCL0011 10-07-2007';
            Editable = false;
        }
        field(50013; "BOQ Code"; Code[20])
        {
            Description = 'ALLESP BCL0011 10-07-2007';

            trigger OnValidate()
            begin
                IF BItem.GET("BOQ Code") THEN
                    "Phase Desc" := BItem.Description + BItem."Description 2"
                ELSE
                    "Phase Desc" := '';
            end;
        }
        field(50014; "Entry No."; Integer)
        {
            Description = 'ALLESP BCL0011 10-07-2007';
            TableRelation = "BOQ Item"."Entry No." WHERE("Project Code" = FIELD("Job No."));
        }
        field(50015; "BOQ Qty."; Decimal)
        {
            CalcFormula = Sum("Job Planning Line Archive".Quantity WHERE("Job No." = FIELD("Job No."),
                                                                          "Job Task No." = FIELD("Job Task No."),
                                                                          "Version No." = FIELD("Version No.")));
            Description = 'Alleab';
            FieldClass = FlowField;
        }
        field(50016; "BOQ Amt."; Decimal)
        {
            CalcFormula = Sum("Job Planning Line Archive"."Line Amount (LCY)" WHERE("Job No." = FIELD("Job No."),
                                                                                     "Job Task No." = FIELD("Job Task No."),
                                                                                     "Version No." = FIELD("Version No.")));
            Description = 'Alleab';
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
        field(50019; "Pending Qty."; Decimal)
        {
            Description = 'Alleab';
        }
        field(50020; "Pending Amt."; Decimal)
        {
            Description = 'Alleab';
        }
        field(50021; "Total Sales BOQ Amount"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Total Price" WHERE("Job No." = FIELD("Job No."),
                                                                       "Job Task No." = FIELD("Job Task No.")));
            Description = 'AlleBLK';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50022; "Rejected Qty."; Decimal)
        {
            Description = 'ALLESC';
        }
        field(50023; "Rejected Amt."; Decimal)
        {
            Description = 'ALLESC';
        }
        field(50024; "BOQ Type"; Option)
        {
            Caption = 'BOQ Type';
            Description = 'ALLEAA';
            Editable = false;
            OptionCaption = ' ,Sale,Purchase';
            OptionMembers = " ",Sale,Purchase;
        }
        field(50025; "G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50026; "Shortcut Dimension 2 Code"; Code[20])
        {
        }
        field(50027; "Total Purchase BOQ Amount"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Total Cost" WHERE("Job No." = FIELD("Job No."),
                                                                      "Job Task No." = FIELD("Job Task No.")));
            Description = 'ALLEAA';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50050; "BOQ Unit Of Measure"; Code[10])
        {
            TableRelation = "Unit of Measure";
        }
        field(50051; "BOQ Quantity"; Decimal)
        {
        }
        field(50052; "BOQ Unit Price"; Decimal)
        {
        }
        field(50053; "BOQ Total Price"; Decimal)
        {
        }
        field(50054; "BOQ Job Type"; Option)
        {
            OptionCaption = 'Service,Supply,Supply & Service';
            OptionMembers = Service,Supply,"Supply & Service";
        }
        field(50085; "Version No."; Integer)
        {
        }
        field(50086; "Archived By"; Code[20])
        {
        }
        field(50087; "Date Archived"; Date)
        {
        }
        field(50088; "Time Archived"; Time)
        {
        }
        field(90017; Selected; Boolean)
        {
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
            DecimalPlaces = 1 : 3;
            Description = 'Alleab';
        }
        field(90019; "BOQ Rate Inclusive Tax"; Boolean)
        {
            Description = 'ALLEAB20-03';
        }
        field(90020; Quantity; Decimal)
        {
            CalcFormula = Lookup("Job Planning Line".Quantity WHERE("Job No." = FIELD("Job No."),
                                                                     "Job Task No." = FIELD("Job Task No.")));
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
            Description = 'ALLEAB25-03';
        }
        field(90023; "Non Schedule"; Boolean)
        {
            Description = 'ALLEAB25-03';
        }
        field(90026; "Total Tender Rate"; Decimal)
        {
            CalcFormula = Sum("EPC Job Planning Line Archive"."Tender Rate" WHERE("Job No." = FIELD("Job No."),
                                                                               "Job Task No." = FIELD("Job Task No."),
                                                                               "Version No." = FIELD("Version No.")));
            Caption = 'Total Tender Rate';
            Description = 'ALLERP KRN0008 18-08-2010:';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90027; "Total Premium/Disc. Amount"; Decimal)
        {
            CalcFormula = Sum("EPC Job Planning Line Archive"."Premium/Discount Amount" WHERE("Job No." = FIELD("Job No."),
                                                                                           "Job Task No." = FIELD("Job Task No."),
                                                                                           "Version No." = FIELD("Version No.")));
            Caption = 'Total Premium/Disc. Amount';
            Description = 'ALLERP KRN0008 18-08-2010:';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90029; "Internal Milestone"; Boolean)
        {
        }
        field(90030; "Ship to Address Code"; Code[10])
        {

            trigger OnLookup()
            begin
                // ALLEAA 110711
            end;
        }
    }

    keys
    {
        key(Key1; "Job No.", "Job Task No.", "Version No.")
        {
            Clustered = true;
        }
        key(Key2; "Job Task No.")
        {
        }
        key(Key3; "Entry No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Job Task No.", Description, "Job Task Type")
        {
        }
    }

    trigger OnDelete()
    var
        JobPlanningLine: Record "Job Planning Line";
        JobTaskDim: Record "Job Task Dimension";
    begin
    end;

    trigger OnInsert()
    var
        Job: Record Job;
        Cust: Record Customer;
    begin
    end;

    var
        Text000: Label 'You cannot delete %1 because one or more entries are associated.';
        Text001: Label 'You cannot change %1 because one or more entries are associated with this %2.';
        DimMgt: Codeunit DimensionManagement;
        Job: Record Job;
        JobWIPGLEntry: Record "Job WIP G/L Entry";
        Text16500: Label 'You cannot change %1 for Job No.=%2 for Job Type=%3 because one or more entries are associated.';
        BItem: Record Item;

    local procedure JobLedgEntriesExist(): Boolean
    var
        JobLedgEntry: Record "Job Ledger Entry";
    begin
        JobLedgEntry.SETCURRENTKEY("Job No.", "Job Task No.");
        JobLedgEntry.SETRANGE("Job No.", "Job No.");
        JobLedgEntry.SETRANGE("Job Task No.", "Job Task No.");
        EXIT(JobLedgEntry.FIND('-'))
    end;


    procedure JobPlanningLinesExist(): Boolean
    var
        JobPlanningLine: Record "Job Planning Line";
    begin
        JobPlanningLine.SETCURRENTKEY("Job No.", "Job Task No.");
        JobPlanningLine.SETRANGE("Job No.", "Job No.");
        JobPlanningLine.SETRANGE("Job Task No.", "Job Task No.");
        EXIT(JobPlanningLine.FIND('-'))
    end;


    procedure Caption(): Text[250]
    var
        Job: Record Job;
    begin
        IF NOT Job.GET("Job No.") THEN
            EXIT('');
        EXIT(STRSUBSTNO('%1 %2 %3 %4',
            Job."No.",
            Job.Description,
            "Job Task No.",
            Description));
    end;


    procedure Caption2(): Text[250]
    var
        Job: Record Job;
    begin
        IF NOT Job.GET("Job No.") THEN
            EXIT('');
        EXIT(STRSUBSTNO('%1 %2',
            Job."No.",
            Job.Description))
    end;


    procedure InitWIPFields()
    begin
        "WIP Posting Date" := 0D;
        "WIP %" := 0;
        "WIP Account" := '';
        "WIP Balance Account" := '';
        "Invoiced Sales Account" := '';
        "Invoiced Sales Bal. Account" := '';
        "WIP Amount" := 0;
        "Invoiced Sales Amount" := 0;
        "WIP Method Used" := 0;
        "WIP Schedule (Total Cost)" := 0;
        "WIP Schedule (Total Price)" := 0;
        "WIP Usage (Total Cost)" := 0;
        "WIP Usage (Total Price)" := 0;
        "WIP Contract (Total Cost)" := 0;
        "WIP Contract (Total Price)" := 0;
        "WIP (Invoiced Price)" := 0;
        "WIP (Invoiced Cost)" := 0;
        "WIP Posting Date Filter" := '';
        "WIP Planning Date Filter" := '';
        "Recognized Sales Amount" := 0;
        "Recognized Sales Account" := '';
        "Recognized Sales Bal. Account" := '';
        "Recognized Costs Amount" := 0;
        "Recognized Costs Account" := '';
        "Recognized Costs Bal. Account" := '';
        "WIP Sales Account" := '';
        "WIP Sales Balance Account" := '';
        "WIP Costs Account" := '';
        "WIP Costs Balance Account" := '';
        "Cost Completion %" := 0;
        "Invoiced %" := 0;
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; ShortcutDimCode: Code[20])
    var
        JobTask2: Record "Job Task";
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        IF JobTask2.GET("Job No.", "Job Task No.") THEN BEGIN
            DimMgt.SaveJobTaskDim("Job No.", "Job Task No.", FieldNumber, ShortcutDimCode);
            MODIFY;
        END ELSE
            DimMgt.SaveJobTaskTempDim(FieldNumber, ShortcutDimCode);
    end;


    procedure ClearTempDim()
    begin
        DimMgt.DeleteJobTaskTempDim;
    end;
}

