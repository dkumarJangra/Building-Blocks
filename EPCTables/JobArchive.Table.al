table 97765 "EPC Job Archive"
{
    // ALLEPG 271211 : Field added & lookup PAGE changed

    DataCaptionFields = "No.", Description, "Version No.";
    DrillDownPageID = "Job List Archive";
    LookupPageID = "Job List Archive";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Search Description"; Code[50])
        {
            Caption = 'Search Description';
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(4; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(5; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(12; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(13; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(14; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(19; Status; Option)
        {
            Caption = 'Status';
            InitValue = "Order";
            OptionCaption = 'Planning,Quote,Order,Completed';
            OptionMembers = Planning,Quote,"Order",Completed;

            trigger OnValidate()
            var
                JobPlanningLine: Record "Job Planning Line";
            begin
            end;
        }
        field(20; "Person Responsible"; Code[20])
        {
            Caption = 'Person Responsible';
            TableRelation = Resource;
        }
        field(21; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(22; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(23; "Job Posting Group"; Code[10])
        {
            Caption = 'Job Posting Group';
            TableRelation = "Job Posting Group";
        }
        field(24; Blocked; Option)
        {
            Caption = 'Blocked';
            OptionCaption = ' ,Posting,All';
            OptionMembers = " ",Posting,All;
        }
        field(29; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(30; Comment; Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST("Activity Master"),
                                                      "No." = FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "Customer Disc. Group"; Code[10])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";
        }
        field(32; "Customer Price Group"; Code[10])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(41; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(49; "Scheduled Res. Qty."; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Quantity (Base)" WHERE("Job No." = FIELD("No."),
                                                                           "Schedule Line" = CONST(true),
                                                                           Type = CONST(Resource),
                                                                           "No." = FIELD("Resource Filter"),
                                                                           "Planning Date" = FIELD("Planning Date Filter")));
            Caption = 'Scheduled Res. Qty.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; "Resource Filter"; Code[20])
        {
            Caption = 'Resource Filter';
            FieldClass = FlowFilter;
            TableRelation = Resource;
        }
        field(51; "Posting Date Filter"; Date)
        {
            Caption = 'Posting Date Filter';
            FieldClass = FlowFilter;
        }
        field(55; "Resource Gr. Filter"; Code[20])
        {
            Caption = 'Resource Gr. Filter';
            FieldClass = FlowFilter;
            TableRelation = "Resource Group";
        }
        field(56; "Scheduled Res. Gr. Qty."; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Quantity (Base)" WHERE("Job No." = FIELD("No."),
                                                                           "Schedule Line" = CONST(true),
                                                                           Type = CONST(Resource),
                                                                           "Resource Group No." = FIELD("Resource Gr. Filter"),
                                                                           "Planning Date" = FIELD("Planning Date Filter")));
            Caption = 'Scheduled Res. Gr. Qty.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(57; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(58; "Bill-to Name"; Text[50])
        {
            Caption = 'Bill-to Name';
        }
        field(59; "Bill-to Address"; Text[50])
        {
            Caption = 'Bill-to Address';
        }
        field(60; "Bill-to Address 2"; Text[50])
        {
            Caption = 'Bill-to Address 2';
        }
        field(61; "Bill-to City"; Text[50])
        {
            Caption = 'Bill-to City';
        }
        field(63; County; Text[30])
        {
            CalcFormula = Lookup(Customer.County WHERE("No." = FIELD("Bill-to Customer No.")));
            Caption = 'County';
            Editable = false;
            FieldClass = FlowField;
        }
        field(64; "Bill-to Post Code"; Code[20])
        {
            Caption = 'Bill-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookUpPostCode("Bill-to City", "Bill-to Post Code", TRUE);
            end;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode("Bill-to City", "Bill-to Post Code", County, "Country Code", TRUE);
            end;
        }
        field(66; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(67; "Bill-to Country/Region Code"; Code[10])
        {
            Caption = 'Bill-to Country/Region Code';
            Editable = true;
            TableRelation = "Country/Region";
        }
        field(68; "Bill-to Name 2"; Text[50])
        {
            CalcFormula = Lookup(Customer."Name 2" WHERE("No." = FIELD("Bill-to Customer No.")));
            Caption = 'Bill-to Name 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1000; "WIP Method"; Code[20])
        {
            Caption = 'WIP Method';

            trigger OnValidate()
            begin
                //IF ("WIP Method" <> "WIP Method"::"4") AND ("Job Type" = "Job Type"::"Capital WIP") THEN
                // ERROR(Text16500,"No.","Job Type");
            end;
        }
        field(1001; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                IF "Currency Code" <> xRec."Currency Code" THEN
                    IF NOT JobLedgEntryExist THEN
                        CurrencyUpdatePlanningLines
                    ELSE
                        ERROR(Text000, FIELDCAPTION("Currency Code"), TABLECAPTION);
            end;
        }
        field(1002; "Bill-to Contact No."; Code[20])
        {
            Caption = 'Bill-to Contact No.';

            trigger OnLookup()
            begin
                IF ("Bill-to Customer No." <> '') AND Cont.GET("Bill-to Contact No.") THEN
                    Cont.SETRANGE("Company No.", Cont."Company No.")
                ELSE
                    IF Cust.GET("Bill-to Customer No.") THEN BEGIN
                        ContBusinessRelation.RESET;
                        ContBusinessRelation.SETCURRENTKEY("Link to Table", "No.");
                        ContBusinessRelation.SETRANGE("Link to Table", ContBusinessRelation."Link to Table"::Customer);
                        ContBusinessRelation.SETRANGE("No.", "Bill-to Customer No.");
                        IF ContBusinessRelation.FIND('-') THEN
                            Cont.SETRANGE("Company No.", ContBusinessRelation."Contact No.");
                    END ELSE
                        Cont.SETFILTER("Company No.", '<>''''');

                IF "Bill-to Contact No." <> '' THEN
                    IF Cont.GET("Bill-to Contact No.") THEN;
                IF PAGE.RUNMODAL(0, Cont) = ACTION::LookupOK THEN BEGIN
                    xRec := Rec;
                    VALIDATE("Bill-to Contact No.", Cont."No.");
                END;
            end;

            trigger OnValidate()
            begin
                IF Blocked >= Blocked::Posting THEN
                    ERROR(Text000, FIELDCAPTION("Bill-to Contact No."), TABLECAPTION);

                IF ("Bill-to Contact No." <> xRec."Bill-to Contact No.") AND
                   (xRec."Bill-to Contact No." <> '')
                THEN BEGIN
                    IF ("Bill-to Contact No." = '') AND ("Bill-to Customer No." = '') THEN BEGIN
                        INIT;
                        "No. Series" := xRec."No. Series";
                        VALIDATE(Description, xRec.Description);
                    END;
                END;

                IF ("Bill-to Customer No." <> '') AND ("Bill-to Contact No." <> '') THEN BEGIN
                    Cont.GET("Bill-to Contact No.");
                    ContBusinessRelation.RESET;
                    ContBusinessRelation.SETCURRENTKEY("Link to Table", "No.");
                    ContBusinessRelation.SETRANGE("Link to Table", ContBusinessRelation."Link to Table"::Customer);
                    ContBusinessRelation.SETRANGE("No.", "Bill-to Customer No.");
                    IF ContBusinessRelation.FIND('-') THEN
                        IF ContBusinessRelation."Contact No." <> Cont."Company No." THEN
                            ERROR(Text005, Cont."No.", Cont.Name, "Bill-to Customer No.");
                END;
                UpdateBillToCust("Bill-to Contact No.");
            end;
        }
        field(1003; "Bill-to Contact"; Text[50])
        {
            Caption = 'Bill-to Contact';
        }
        field(1004; "Planning Date Filter"; Date)
        {
            Caption = 'Planning Date Filter';
            FieldClass = FlowFilter;
        }
        field(1005; "Total WIP Cost Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Job WIP Entry"."WIP Entry Amount" WHERE("Job No." = FIELD("No."),
                                                                        "Job Complete" = CONST(false),
                                                                        Type = FILTER("Applied Costs" | "Recognized Costs" | "Accrued Costs")));
            Caption = 'Total WIP Cost Amount';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(1006; "Total WIP Cost G/L Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Job WIP G/L Entry"."WIP Entry Amount" WHERE("Job No." = FIELD("No."),
                                                                            Reversed = CONST(false),
                                                                            "Job Complete" = CONST(false),
                                                                            Type = FILTER("Applied Costs" | "Recognized Costs" | "Accrued Costs")));
            Caption = 'Total WIP Cost G/L Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1007; "WIP Posted To G/L"; Boolean)
        {
            Caption = 'WIP Posted To G/L';
            Editable = false;
        }
        field(1008; "WIP Posting Date"; Date)
        {
            Caption = 'WIP Posting Date';
            Editable = false;
        }
        field(1009; "WIP G/L Posting Date"; Date)
        {
            CalcFormula = Min("Job WIP G/L Entry"."WIP Posting Date" WHERE(Reversed = CONST(false),
                                                                            "Job No." = FIELD("No.")));
            Caption = 'WIP G/L Posting Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1010; "Posted WIP Method Used"; Option)
        {
            Caption = 'Posted WIP Method Used';
            Editable = false;
            OptionCaption = ' ,Cost Value,Sales Value,Cost of Sales,Percentage of Completion,Completed Contract';
            OptionMembers = " ","Cost Value","Sales Value","Cost of Sales","Percentage of Completion","Completed Contract";
        }
        field(1011; "Invoice Currency Code"; Code[10])
        {
            Caption = 'Invoice Currency Code';
            TableRelation = Currency;
        }
        field(1012; "Exch. Calculation (Cost)"; Option)
        {
            Caption = 'Exch. Calculation (Cost)';
            OptionCaption = 'Fixed LCY,Fixed FCY';
            OptionMembers = "Fixed LCY","Fixed FCY";
        }
        field(1013; "Exch. Calculation (Price)"; Option)
        {
            Caption = 'Exch. Calculation (Price)';
            OptionCaption = 'Fixed FCY,Fixed LCY';
            OptionMembers = "Fixed FCY","Fixed LCY";
        }
        field(1014; "Allow Schedule/Contract Lines"; Boolean)
        {
            Caption = 'Allow Schedule/Contract Lines';
        }
        field(1015; Complete; Boolean)
        {
            Caption = 'Complete';

            trigger OnValidate()
            begin
                IF Complete <> xRec.Complete THEN
                    ChangeJobCompletionStatus;
            end;
        }
        field(1016; "Calc. WIP Method Used"; Option)
        {
            Caption = 'Calc. WIP Method Used';
            Editable = false;
            OptionCaption = ' ,Cost Value,Sales Value,Cost of Sales,Percentage of Completion,Completed Contract';
            OptionMembers = " ","Cost Value","Sales Value","Cost of Sales","Percentage of Completion","Completed Contract";
        }
        field(1017; "Recog. Sales Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Job WIP Entry"."WIP Entry Amount" WHERE("Job No." = FIELD("No."),
                                                                        Type = FILTER("Recognized Sales")));
            Caption = 'Recog. Sales Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1018; "Recog. Sales G/L Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Job WIP G/L Entry"."WIP Entry Amount" WHERE("Job No." = FIELD("No."),
                                                                            Type = FILTER("Recognized Sales"),
                                                                            Reversed = CONST(false)));
            Caption = 'Recog. Sales G/L Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1019; "Recog. Costs Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Job WIP Entry"."WIP Entry Amount" WHERE("Job No." = FIELD("No."),
                                                                         Type = FILTER("Recognized Costs")));
            Caption = 'Recog. Costs Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1020; "Recog. Costs G/L Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Job WIP G/L Entry"."WIP Entry Amount" WHERE("Job No." = FIELD("No."),
                                                                             Type = FILTER("Recognized Costs"),
                                                                             Reversed = CONST(false)));
            Caption = 'Recog. Costs G/L Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1021; "Total WIP Sales Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Job WIP Entry"."WIP Entry Amount" WHERE("Job No." = FIELD("No."),
                                                                        "Job Complete" = CONST(false),
                                                                        Type = FILTER("Accrued Sales" | "Applied Sales" | "Recognized Sales")));
            Caption = 'Total WIP Sales Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1022; "Total WIP Sales G/L Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Job WIP G/L Entry"."WIP Entry Amount" WHERE("Job No." = FIELD("No."),
                                                                            Reversed = CONST(false),
                                                                            "Job Complete" = CONST(false),
                                                                            Type = FILTER("Accrued Sales" | "Applied Sales" | "Recognized Sales")));
            Caption = 'Total WIP Sales G/L Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1023; "Completion Calculated"; Boolean)
        {
            CalcFormula = Exist("Job WIP Entry" WHERE("Job No." = FIELD("No."),
                                                       "Job Complete" = FILTER(= true)));
            Caption = 'Completion Calculated';
            FieldClass = FlowField;
        }
        field(1024; "Next Invoice Date"; Date)
        {
            CalcFormula = Min("Job Planning Line"."Planning Date" WHERE("Job No." = FIELD("No."),
                                                                         "Contract Line" = FILTER(true)));
            Caption = 'Next Invoice Date';
            FieldClass = FlowField;
        }
        field(16500; "Job Type"; Option)
        {
            Caption = 'Job Type';
            OptionCaption = ' ,Capital WIP';
            OptionMembers = " ","Capital WIP";

            trigger OnValidate()
            begin
                IF "Job Type" = "Job Type"::"Capital WIP" THEN BEGIN
                    TESTFIELD("Bill-to Customer No.", '');
                    IF "Job Type" <> xRec."Job Type" THEN BEGIN
                        IF JobLedgEntryExist OR JobPlanningLineExist THEN
                            ERROR(Text000, FIELDCAPTION("Job Type"), TABLECAPTION);
                        //"WIP Method" := "WIP Method"::"4";
                        IF (Status <> Status::Planning) THEN
                            Status := Status::Planning;
                    END;
                END ELSE IF "Job Type" <> xRec."Job Type" THEN BEGIN
                    IF JobLedgEntryExist OR JobPlanningLineExist THEN
                        ERROR(Text000, FIELDCAPTION("Job Type"), TABLECAPTION);
                END;
            end;
        }
        field(50001; "Extension Given From"; Date)
        {
            Description = 'ALLESP BCL0004 05-07-2007';
        }
        field(50002; "Extension Given To"; Date)
        {
            Description = 'ALLESP BCL0004 05-07-2007';
        }
        field(50003; "Defect Liability (Year)"; Decimal)
        {
            DecimalPlaces = 0 : 0;
            Description = 'ALLESP BCL0004 05-07-2007';
        }
        field(50004; "Defect Liability (Month)"; Decimal)
        {
            DecimalPlaces = 0 : 0;
            Description = 'ALLESP BCL0004 05-07-2007';
            MaxValue = 12;
            MinValue = 0;
        }
        field(50005; "Concession Period (Year)"; Decimal)
        {
            DecimalPlaces = 0 : 0;
            Description = 'ALLESP BCL0004 05-07-2007';
        }
        field(50006; "Concession Period (Month)"; Decimal)
        {
            DecimalPlaces = 0 : 0;
            Description = 'ALLESP BCL0004 05-07-2007';
            MaxValue = 12;
            MinValue = 0;
        }
        field(50007; "Project Amount"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Total Price" WHERE("Job No." = FIELD("No.")));
            Description = 'ALLESP BCL0004 05-07-2007- use in sales header';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50008; "LOI Date"; Date)
        {
            Description = 'ALLESP BCL0004 05-07-2007';
        }
        field(50009; "Contract Type"; Option)
        {
            Description = 'ALLESP BCL0004 05-07-2007';
            OptionCaption = 'EPC-Item BOQ,EPC-LumpSum,BOT,BOT Annuity,Others';
            OptionMembers = "EPC-Item BOQ","EPC-LumpSum",BOT,"BOT Annuity",Others;
        }
        field(50018; "Explosives Required"; Boolean)
        {
            Description = 'ALLESP BCL0004 05-07-2007';

            trigger OnValidate()
            begin
                //ALLESP BCL0004 06-07-2007 Start:
                IF Rec."Explosives Required" <> xRec."Explosives Required" THEN
                    "Explosives Supplied By" := 0;
                //ALLESP BCL0004 06-07-2007 End:
            end;
        }
        field(50019; "Explosives Supplied By"; Option)
        {
            Description = 'ALLESP BCL0004 05-07-2007';
            OptionCaption = ' ,Client,Contractor';
            OptionMembers = " ",Client,Contractor;
        }
        field(50020; "Mobilization Advance"; Decimal)
        {
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("Bill-to Customer No."),
                                                                                  "User Branch Code" = FIELD("No."),
                                                                                  "Entry Type" = CONST("Initial Entry"),
                                                                                  "Posting Type" = CONST("Mobilization Advance"),
                                                                                  "Document Type" = CONST(Payment)));
            Description = 'ALLESP BCL0005 06-07-2007';
            FieldClass = FlowField;
        }
        field(50021; "Equipment Advance"; Decimal)
        {
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("Bill-to Customer No."),
                                                                                  "User Branch Code" = FIELD("No."),
                                                                                  "Entry Type" = CONST("Initial Entry"),
                                                                                  "Posting Type" = CONST("Equipment Advance"),
                                                                                  "Document Type" = CONST(Payment)));
            Description = 'ALLESP BCL0005 06-07-2007';
            FieldClass = FlowField;
        }
        field(50022; "Secured Advance"; Decimal)
        {
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("Bill-to Customer No."),
                                                                                  "User Branch Code" = FIELD("No."),
                                                                                  "Entry Type" = CONST("Initial Entry"),
                                                                                  "Posting Type" = CONST("Secured Advance"),
                                                                                  "Document Type" = CONST(Payment)));
            Description = 'ALLESP BCL0005 06-07-2007';
            FieldClass = FlowField;
        }
        field(50023; "Adhoc Advance"; Decimal)
        {
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("Bill-to Customer No."),
                                                                                  "User Branch Code" = FIELD("No."),
                                                                                  "Entry Type" = CONST("Initial Entry"),
                                                                                  "Posting Type" = CONST("Adhoc Advance"),
                                                                                  "Document Type" = CONST(Payment)));
            Description = 'ALLESP BCL0005 06-07-2007';
            FieldClass = FlowField;
        }
        field(50024; "Initial Security Deposit Amt."; Decimal)
        {
            // CalcFormula = Sum("LC Detail"."LC Value" WHERE(Type = CONST(ABG),
            //                                                 "Project Code" = FIELD("No.")));
            // Description = 'ALLESP BCL0005 06-07-2007';
            // FieldClass = FlowField;
        }
        field(50025; "Earnest Money Deposit Amt."; Decimal)
        {
            // CalcFormula = Sum("LC Detail"."LC Value" WHERE(Type = CONST(PBG),
            //                                                 "Project Code" = FIELD("No.")));
            // Description = 'ALLESP BCL0005 06-07-2007';
            // FieldClass = FlowField;
        }
        field(50026; "Retention Amount %"; Decimal)
        {
            Description = 'ALLESP BCL0005 06-07-2007';
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                "Retention Amount" := "Project Amount" * "Retention Amount %" / 100; //ALLESP BCL0005 31-07-2007
            end;
        }
        field(50027; "Project Site Location"; Code[10])
        {
            Description = 'ALLESP BCL0004 11-07-2007';
            TableRelation = Location;
        }
        field(50029; "Project Status"; Option)
        {
            Description = 'ALLESP BCL0004 05-07-2007';
            OptionCaption = 'Yet to Take Off,In Progress,Completed';
            OptionMembers = "Yet to Take Off","In Progress",Completed;

            trigger OnValidate()
            begin
                //ALLESP BCL0004 12-07-2007 Start:
                IF "Project Status" = xRec."Project Status" THEN
                    EXIT;
                //ALLESP BCL0004 12-07-2007 End:
                //SC 280907 --
                IF "Project Status" < xRec."Project Status" THEN
                    ERROR(Text005);
                //SC ++
            end;
        }
        field(50032; "Performance Gurantee Amt."; Decimal)
        {
            // CalcFormula = Sum("LC Detail"."LC Value" WHERE(Type = CONST(Earnest),
            //                                                 "Project Code" = FIELD("No.")));
            // Description = 'ALLESP BCL0005 06-07-2007';
            // FieldClass = FlowField;
        }
        field(50037; "Agreement Signing Date"; Date)
        {
            Description = 'ALLESP BCL0004 31-07-2007';
        }
        field(50038; "Retention Amount"; Decimal)
        {
            Description = 'ALLESP BCL0005 31-07-2007';
        }
        field(50039; "Deposit Against Advance"; Decimal)
        {
            // CalcFormula = Sum("LC Detail"."LC Value" WHERE(Type = CONST(Others),
            //                                                 "Project Code" = FIELD("No.")));
            // Description = 'ALLESP BCL0005 06-07-2007';
            // FieldClass = FlowField;
        }
        field(50040; "Security Deposit Amt."; Decimal)
        {
            // CalcFormula = Sum("LC Detail"."LC Value" WHERE(Type = CONST(Bond),
            //                                                 "Project Code" = FIELD("No.")));
            // Description = 'ALLESP BCL0005 06-07-2007';
            // FieldClass = FlowField;
        }
        field(50041; LC; Decimal)
        {
            // CalcFormula = Sum("LC Detail"."LC Value" WHERE(Type = CONST(LC),
            //                                                 "Project Code" = FIELD("No.")));
            // Description = 'ALLESP BCL0005 06-07-2007';
            // FieldClass = FlowField;
        }
        field(50042; "Other Material Requried"; Boolean)
        {
            Description = 'ALLESP BCL0004 05-07-2007';
        }
        field(50043; "Material Supplied By"; Option)
        {
            Description = 'ALLESP BCL0004 05-07-2007';
            OptionCaption = ' ,Client,Contractor';
            OptionMembers = " ",Client,Contractor;
        }
        field(50044; "Mobilization Adj Starting %"; Decimal)
        {
            Description = 'ALLESP BCL0005 06-07-2007';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50045; "Mobilization Adj Ending %"; Decimal)
        {
            Description = 'ALLESP BCL0005 06-07-2007';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50046; "Equipment Adj Starting %"; Decimal)
        {
            Description = 'ALLESP BCL0005 06-07-2007';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50047; "Equipment Adj Ending %"; Decimal)
        {
            Description = 'ALLESP BCL0005 06-07-2007';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50048; "Secured Adj Starting %"; Decimal)
        {
            Description = 'ALLESP BCL0005 06-07-2007';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50049; "Secured Adj Ending %"; Decimal)
        {
            Description = 'ALLESP BCL0005 06-07-2007';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50050; "Adhoc Adj Starting %"; Decimal)
        {
            Description = 'ALLESP BCL0005 06-07-2007';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50051; "Adhoc Adj Ending %"; Decimal)
        {
            Description = 'ALLESP BCL0005 06-07-2007';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50052; "Mobilization Adv Remained"; Decimal)
        {
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("Bill-to Customer No."),
                                                                                  "User Branch Code" = FIELD("No."),
                                                                                  "Posting Type" = CONST("Mobilization Advance")));
            Description = 'ALLESP BCL0005 06-07-2007';
            FieldClass = FlowField;
        }
        field(50053; "Equipment Adv Remained"; Decimal)
        {
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("Bill-to Customer No."),
                                                                                  "User Branch Code" = FIELD("No."),
                                                                                  "Posting Type" = CONST("Equipment Advance")));
            Description = 'ALLESP BCL0005 06-07-2007';
            FieldClass = FlowField;
        }
        field(50054; "Secured Adv Remained"; Decimal)
        {
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("Bill-to Customer No."),
                                                                                  "User Branch Code" = FIELD("No."),
                                                                                  "Posting Type" = CONST("Secured Advance")));
            Description = 'ALLESP BCL0005 06-07-2007';
            FieldClass = FlowField;
        }
        field(50055; "Adhoc Adv Remained"; Decimal)
        {
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("Bill-to Customer No."),
                                                                                  "User Branch Code" = FIELD("No."),
                                                                                  "Posting Type" = CONST("Adhoc Advance")));
            Description = 'ALLESP BCL0005 06-07-2007';
            FieldClass = FlowField;
        }
        field(50056; "LOI No."; Text[60])
        {
            Description = 'ALLESP BCL0004 25-09-2007';
        }
        field(50057; "Transmittal No. Series"; Code[20])
        {
            Description = 'KLND1.00';
            TableRelation = "No. Series".Code;
        }
        field(50058; CC1; Text[50])
        {
            Description = 'KLND1.00';
        }
        field(50059; "CC1 Designation"; Text[50])
        {
            Caption = 'Designation';
            Description = 'KLND1.00';
        }
        field(50060; CC2; Text[50])
        {
            Description = 'KLND1.00';
        }
        field(50061; "CC2 Designation"; Text[50])
        {
            Caption = 'Designation';
            Description = 'KLND1.00';
        }
        field(50062; CC3; Text[50])
        {
            Description = 'KLND1.00';
        }
        field(50063; "CC3 Designation"; Text[50])
        {
            Caption = 'Designation';
            Description = 'KLND1.00';
        }
        field(50064; CC4; Text[50])
        {
            Description = 'KLND1.00';
        }
        field(50065; "CC4 Designation"; Text[50])
        {
            Caption = 'Designation';
            Description = 'KLND1.00';
        }
        field(50066; "Client Contact"; Text[50])
        {
            Description = 'KLND1.00';
        }
        field(50067; "Client Contact Designation"; Text[50])
        {
            Caption = 'Designation';
            Description = 'KLND1.00';
        }
        field(50068; Subject; Text[80])
        {
            Caption = 'Transmittal Subject';
            Description = 'KLND1.00';
        }
        field(50069; "CC1 Only Transmittal"; Boolean)
        {
            Caption = 'Only Transmittal';
            Description = 'KLND1.00';
        }
        field(50070; "CC2 Only Transmittal"; Boolean)
        {
            Caption = 'Only Transmittal';
            Description = 'KLND1.00';
        }
        field(50071; "CC3 Only Transmittal"; Boolean)
        {
            Caption = 'Only Transmittal';
            Description = 'KLND1.00';
        }
        field(50072; "CC4 Only Transmittal"; Boolean)
        {
            Caption = 'Only Transmittal';
            Description = 'KLND1.00';
        }
        field(50073; "Transmittal Name"; Text[50])
        {
            Caption = 'Transmittal Name';
            Description = 'KLND1.00';
        }
        field(50074; "Transmittal Address"; Text[50])
        {
            Caption = 'Transmittal Address';
            Description = 'KLND1.00';
        }
        field(50075; "Transmittal Address 2"; Text[50])
        {
            Caption = 'Transmittal Address 2';
            Description = 'KLND1.00';
        }
        field(50076; "Transmittal City"; Text[50])
        {
            Caption = 'Transmittal City';
            Description = 'KLND1.00';

            trigger OnLookup()
            begin
                PostCode.LookUpCity("Transmittal City", "Transmittal Post Code", TRUE);
            end;

            trigger OnValidate()
            begin
                PostCode.ValidateCity("Transmittal City", "Transmittal Post Code", County, "Country Code", TRUE);
            end;
        }
        field(50077; "Transmittal Post Code"; Code[20])
        {
            Caption = 'Transmittal Post Code';
            Description = 'KLND1.00';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookUpPostCode("Transmittal City", "Transmittal Post Code", TRUE);
            end;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode("Transmittal City", "Transmittal Post Code", County, "Country Code", TRUE);
            end;
        }
        field(50078; "Transmittal Country/Region"; Code[10])
        {
            Caption = 'Transmittal Country/Region';
            Description = 'KLND1.00';
            Editable = true;
            TableRelation = "Country/Region";
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
        field(50100; "Estimated Value"; Decimal)
        {
            Description = 'RAHEE1.0';
            Editable = false;
            FieldClass = Normal;
        }
        field(50101; Composite; Boolean)
        {
            Description = 'RAHEE1.0 170412';
        }
        field(50102; "Sent for Approval Amend Date"; Date)
        {
            Description = 'RAHEE1.0 040412';
        }
        field(50103; "Sent for Approval Amend Time"; Time)
        {
            Description = 'RAHEE1.0 040412';
        }
        field(50104; "Sent for Approval Amend Job"; Boolean)
        {
            Description = 'RAHEE1.0 040412';
        }
        field(50105; "Project Min. Amt based on %"; Boolean)
        {
            Description = 'BBG1.00 270813';
        }
        field(50106; "Project Launch"; Boolean)
        {
        }
        field(50110; "Region Code for Rank Hierarcy"; Code[10])
        {
            TableRelation = "Rank Code Master";
        }
        field(50125; "New commission Str. Applicable"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50126; "New commission Str. StartDate"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50132; "BSP4 Plan wise Applicable"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                CompanywiseGLAccount: Record "Company wise G/L Account";
                RecJob: Record Job;
            begin
            end;
        }
        field(50133; "BSP4 Plan wise St. Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(90002; "Total Super Area"; Decimal)
        {
            CalcFormula = Sum(Item."Super Area (sq ft)" WHERE("Property Unit" = FILTER(true),
                                                               "Job No." = FIELD("No.")));
            Description = 'ALLERE';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90003; "Responsibility Center"; Code[10])
        {
            Description = 'ALLEAB for RE';
            TableRelation = "Responsibility Center 1";
        }
        field(90004; "USER ID"; Code[28])
        {
            Description = 'ALLEAB for RE';
        }
        field(90005; "Max. Retention Amount"; Decimal)
        {
            Description = 'ALLEAB for RE';
        }
        field(90006; "Total Covered Car Parking"; Integer)
        {
            Description = 'ALLEAB for RE';
        }
        field(90007; "Total Open Car Parking"; Integer)
        {
            Description = 'ALLEAB for RE';
        }
        field(90010; "Total No. of Units"; Integer)
        {
            Description = 'AlleBLK';
        }
        field(90011; "Sub Project Code"; Code[20])
        {
            Description = 'AlleBLK';
            TableRelation = "Dimension Value".Code WHERE(Code = FILTER('PROJECT BLOCK'),
                                                          "LINK to Region Dim" = FIELD("No."));
        }
        field(90012; "Total No. of Sub Project Units"; Integer)
        {
            Description = 'AlleBLK';
        }
        field(90013; "Project Saleable Area"; Decimal)
        {
            Description = 'AlleBLK';
            Editable = false;
        }
        field(90014; "SubProject Saleable Area"; Decimal)
        {
            Description = 'AlleBLK';
            Editable = false;
        }
        field(90015; "Project Sold Area"; Decimal)
        {
            Description = 'AlleBLK';
            Editable = false;
        }
        field(90016; "SubProject Sold Area"; Decimal)
        {
            Description = 'AlleBLK';
            Editable = false;
        }
        field(90017; "Cost/Sq. Ft."; Decimal)
        {
            Description = 'AlleBLK';
        }
        field(90018; "Project Leaseable Area"; Decimal)
        {
            Description = 'ALLEAB';
        }
        field(90019; "SubProject Leaseable Area"; Decimal)
        {
            Description = 'ALLEAB';
        }
        field(90020; "Project Leased Area"; Decimal)
        {
            Description = 'ALLEAB';
        }
        field(90021; "SubProject Leased Area"; Decimal)
        {
            Description = 'ALLEAB';
        }
        field(90022; "Total Unit Sold"; Integer)
        {
            Description = 'ALLEAB';
        }
        field(90023; "Total Unit Leased"; Integer)
        {
            Description = 'ALLEAB';
        }
        field(90024; "SubProject Unit Sold"; Integer)
        {
            Description = 'ALLEAB';
        }
        field(90025; "SubProject Unit Leased"; Integer)
        {
            Description = 'ALLEAB';
        }
        field(90028; "BOQ Type"; Option)
        {
            Caption = 'BOQ Type';
            Description = 'ALLEAA';
            OptionCaption = ' ,Sale,Purchase';
            OptionMembers = " ",Sale,Purchase;
        }
        field(90029; "Principal Customer No."; Code[20])
        {
            TableRelation = Customer;
        }
        field(90030; "Agreement No."; Code[20])
        {
            Description = 'ALLETG';
        }
        field(90031; "Bill Paying Authority"; Text[50])
        {
            Description = 'ALLETG';
        }
        field(90032; "No. of Archive"; Integer)
        {
            CalcFormula = Max("Job Archive"."Version No." WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90033; Approved; Boolean)
        {
            Description = 'AlleBLK';
        }
        field(90034; "Approved Date"; Date)
        {
            Description = 'AlleBLK';
        }
        field(90035; "Approved Time"; Time)
        {
            Description = 'AlleBLK';
        }
        field(90036; Initiator; Code[20])
        {
            Caption = 'Requestor';
            Description = 'AlleBLK';
            TableRelation = User."User Name";
        }
        field(90037; "Sent for Approval"; Boolean)
        {
            Description = 'AlleBLK';
        }
        field(90038; "Job Creation Date"; Date)
        {
            Description = 'AlleBLK';
        }
        field(90039; "Job Creation Time"; Time)
        {
            Description = 'AlleBLK';
        }
        field(90040; "Sent for Approval Date"; Date)
        {
            Description = 'AlleBLK';
        }
        field(90041; "Sent for Approval Time"; Time)
        {
            Description = 'AlleBLK';
        }
        field(90042; "Type of Contract"; Option)
        {
            OptionCaption = ' ,Variable,Fixed,Turnkey';
            OptionMembers = " ",Variable,"Fixed",Turnkey;
        }
        field(90043; Amended; Boolean)
        {
            Description = 'AIR0013';
        }
        field(90044; "Amendment Approved"; Boolean)
        {
            Description = 'AIR0013';
        }
        field(90045; "Amendment Approved Date"; Date)
        {
            Description = 'AIR0013';
        }
        field(90046; "Amendment Approved Time"; Time)
        {
            Description = 'AIR0013';
        }
        field(90047; "Amendment Initiator"; Code[20])
        {
            Description = 'AIR0013';
        }
        field(90048; "Sold By"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(90049; "Doc. No. Occurrence"; Integer)
        {
            Description = 'ALLEPG 271211';
        }
        field(90051; "Min. Allotment Amount"; Decimal)
        {
        }
        field(90052; "Min. Allotment Area"; Decimal)
        {
        }
        field(90053; "Total Project Cost"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(90054; "old Code"; Code[20])
        {
        }
        field(90055; "Launch Date"; Date)
        {
        }
        field(90056; "Project Layout Area"; Decimal)
        {
        }
        field(90057; "Efficency %"; Decimal)
        {
        }
        field(90151; "Interaction Exist"; Boolean)
        {
            Description = 'ALLEPG 271211';
        }
    }

    keys
    {
        key(Key1; "No.", "Version No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        JobSetup: Record "Jobs Setup";
        PostCode: Record "Post Code";
        Job: Record Job;
        Cust: Record Customer;
        Cont: Record Contact;
        ContBusinessRelation: Record "Contact Business Relation";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        MoveEntries: Codeunit MoveEntries;
        RecUserSetup: Record "User Setup";
        Memberof: Record "Access Control";
        Text000: Label 'You cannot change %1 because one or more entries are associated with this %2.';
        Text003: Label 'You must run the %1 and %2 functions to create and post the completion entries for this job.';
        Text004: Label 'This will delete any unposted WIP entries for this job and allow you to reverse the completion postings for this job.\\Do you wish to continue?';
        Text005: Label 'Contact %1 %2 is related to a different company than customer %3.';
        Text006: Label 'Contact %1 %2 is not related to customer %3.';
        Text007: Label 'Contact %1 %2 is not related to a customer.';
        Text008: Label '%1 %2 must not be blocked with type %3.';
        Text009: Label 'You must run the %1 function to reverse the completion entries that have already been posted for this job.';
        Text010: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        Text011: Label '%1 must be equal to or earlier than %2.';
        Text16500: Label 'WIP Method must only be Completed Contract in Job No.=%1 with Job Type=%2.';
        Text16502: Label 'You cannot delete %1 because one or more entries are associated with this %2.';
        "Country Code": Code[10];


    procedure ValidateShortcutDimCode(FieldNumber: Integer; ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Job, "No.", FieldNumber, ShortcutDimCode);
        MODIFY;
    end;


    procedure UpdateBillToCont(CustomerNo: Code[20])
    var
        ContBusRel: Record "Contact Business Relation";
        Cust: Record Customer;
    begin
        IF Cust.GET(CustomerNo) THEN BEGIN
            IF Cust."Primary Contact No." <> '' THEN
                "Bill-to Contact No." := Cust."Primary Contact No."
            ELSE BEGIN
                ContBusRel.RESET;
                ContBusRel.SETCURRENTKEY("Link to Table", "No.");
                ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Customer);
                ContBusRel.SETRANGE("No.", "Bill-to Customer No.");
                IF ContBusRel.FIND('-') THEN
                    "Bill-to Contact No." := ContBusRel."Contact No.";
            END;
            "Bill-to Contact" := Cust.Contact;
        END;
    end;

    local procedure JobLedgEntryExist(): Boolean
    var
        JobLedgEntry: Record "Job Ledger Entry";
    begin
        CLEAR(JobLedgEntry);
        JobLedgEntry.SETCURRENTKEY("Job No.");
        JobLedgEntry.SETRANGE("Job No.", "No.");
        EXIT(JobLedgEntry.FIND('-'));
    end;

    local procedure JobPlanningLineExist(): Boolean
    var
        JobPlanningLine: Record "Job Planning Line";
    begin
        JobPlanningLine.INIT;
        JobPlanningLine.SETRANGE("Job No.", "No.");
        EXIT(JobPlanningLine.FIND('-'));
    end;


    procedure UpdateBillToCust(ContactNo: Code[20])
    var
        ContBusinessRelation: Record "Contact Business Relation";
        Cust: Record Customer;
        Cont: Record Contact;
    begin
        IF Cont.GET(ContactNo) THEN BEGIN
            "Bill-to Contact No." := Cont."No.";
            IF Cont.Type = Cont.Type::Person THEN
                "Bill-to Contact" := Cont.Name
            ELSE
                IF Cust.GET("Bill-to Customer No.") THEN
                    "Bill-to Contact" := Cust.Contact
                ELSE
                    "Bill-to Contact" := '';
        END ELSE BEGIN
            "Bill-to Contact" := '';
            EXIT;
        END;

        ContBusinessRelation.RESET;
        ContBusinessRelation.SETCURRENTKEY("Link to Table", "Contact No.");
        ContBusinessRelation.SETRANGE("Link to Table", ContBusinessRelation."Link to Table"::Customer);
        ContBusinessRelation.SETRANGE("Contact No.", Cont."Company No.");
        IF ContBusinessRelation.FIND('-') THEN BEGIN
            IF "Bill-to Customer No." = '' THEN
                VALIDATE("Bill-to Customer No.", ContBusinessRelation."No.")
            ELSE
                IF "Bill-to Customer No." <> ContBusinessRelation."No." THEN
                    ERROR(Text006, Cont."No.", Cont.Name, "Bill-to Customer No.");
        END ELSE
            ERROR(Text007, Cont."No.", Cont.Name);
    end;


    procedure UpdateCust()
    begin
        IF "Bill-to Customer No." <> '' THEN BEGIN
            Cust.GET("Bill-to Customer No.");
            Cust.TESTFIELD("Customer Posting Group");
            Cust.TESTFIELD("Bill-to Customer No.", '');
            "Bill-to Name" := Cust.Name;
            "Bill-to Name 2" := Cust."Name 2";
            "Bill-to Address" := Cust.Address;
            "Bill-to Address 2" := Cust."Address 2";
            "Bill-to City" := Cust.City;
            "Bill-to Post Code" := Cust."Post Code";
            "Bill-to Country/Region Code" := Cust."Country/Region Code";
            "Currency Code" := Cust."Currency Code";
            "Customer Disc. Group" := Cust."Customer Disc. Group";
            "Customer Price Group" := Cust."Customer Price Group";
            "Language Code" := Cust."Language Code";
            County := Cust.County;
            UpdateBillToCont("Bill-to Customer No.");
        END ELSE BEGIN
            "Bill-to Name" := '';
            "Bill-to Name 2" := '';
            "Bill-to Address" := '';
            "Bill-to Address 2" := '';
            "Bill-to City" := '';
            "Bill-to Post Code" := '';
            "Bill-to Country/Region Code" := '';
            "Currency Code" := '';
            "Customer Disc. Group" := '';
            "Customer Price Group" := '';
            "Language Code" := '';
            County := '';
            VALIDATE("Bill-to Contact No.", '');
        END;
    end;


    procedure InitWIPFields()
    begin
        "WIP Posted To G/L" := FALSE;
        "WIP Posting Date" := 0D;
        "WIP G/L Posting Date" := 0D;
        "Posted WIP Method Used" := 0;
    end;


    procedure TestBlocked()
    begin
        IF Blocked = Blocked::" " THEN
            EXIT;
        ERROR(Text008, TABLECAPTION, "No.", Blocked);
    end;


    procedure CurrencyUpdatePlanningLines()
    var
        PlaningLine: Record "Job Planning Line";
    begin
        PlaningLine.SETRANGE("Job No.", "No.");
        IF PlaningLine.FIND('-') THEN
            REPEAT
                // ALLE MM Code Commented
                //    IF PlaningLine.Transferred THEN
                //      ERROR(Text000,FIELDCAPTION("Currency Code"),TABLECAPTION);
                // ALLE MM Code Commented
                PlaningLine.VALIDATE("Currency Code", "Currency Code");
                PlaningLine.VALIDATE("Currency Date");
                PlaningLine.MODIFY;
            UNTIL PlaningLine.NEXT = 0;
    end;


    procedure ChangeJobCompletionStatus()
    var
        AllObjwithCaption: Record AllObjWithCaption;
        JobWIPGLEntry: Record "Job WIP G/L Entry";
        JobCalcWIP: Codeunit "Job Calculate WIP";
        ReportCaption1: Text[250];
        ReportCaption2: Text[250];
    begin
        AllObjwithCaption.GET(AllObjwithCaption."Object Type"::Report, REPORT::"Job Calculate WIP");
        ReportCaption1 := AllObjwithCaption."Object Caption";
        AllObjwithCaption.GET(AllObjwithCaption."Object Type"::Report, REPORT::"Job Post WIP to G/L");
        ReportCaption2 := AllObjwithCaption."Object Caption";

        IF Complete = TRUE THEN
            MESSAGE(Text003, ReportCaption1, ReportCaption2)
        ELSE BEGIN
            JobCalcWIP.ReOpenJob("No.");
            "WIP Posting Date" := 0D;
            "Calc. WIP Method Used" := 0;
            MESSAGE(Text009, ReportCaption2);
        END;
    end;


    procedure DisplayMap()
    var
        MapPoint: Record "Online Map Setup";
        MapMgt: Codeunit "Online Map Management";
    begin
        IF MapPoint.FIND('-') THEN
            MapMgt.MakeSelection(DATABASE::Job, GETPOSITION)
        ELSE
            MESSAGE(Text010);
    end;


    procedure GetQuantityAvailable(ItemNo: Code[20]; LocationCode: Code[10]; VariantCode: Code[10]; InEntryType: Option Usage,Sale,Both; Direction: Option Possitive,Negative,Both) QtyBase: Decimal
    var
        JobLedgEntry: Record "Job Ledger Entry";
    begin
        CLEAR(JobLedgEntry);
        JobLedgEntry.SETCURRENTKEY("Job No.", "Entry Type", Type, "No.");
        JobLedgEntry.SETRANGE("Job No.", Rec."No.");
        IF NOT (InEntryType = InEntryType::Both) THEN
            JobLedgEntry.SETRANGE("Entry Type", InEntryType);
        JobLedgEntry.SETRANGE(Type, JobLedgEntry.Type::Item);
        JobLedgEntry.SETRANGE("No.", ItemNo);
        IF JobLedgEntry.FINDSET THEN
            REPEAT
                IF (JobLedgEntry."Location Code" = LocationCode) AND
                   (JobLedgEntry."Variant Code" = VariantCode) AND
                   ((Direction = Direction::Both) OR
                    ((Direction = Direction::Possitive) AND (JobLedgEntry."Quantity (Base)" > 0)) OR
                    ((Direction = Direction::Negative) AND (JobLedgEntry."Quantity (Base)" < 0)))
                THEN
                    QtyBase := QtyBase + JobLedgEntry."Quantity (Base)";
            UNTIL JobLedgEntry.NEXT = 0;
    end;

    local procedure CheckDate()
    begin
        IF ("Starting Date" > "Ending Date") AND ("Ending Date" <> 0D) THEN
            ERROR(Text011, FIELDCAPTION("Starting Date"), FIELDCAPTION("Ending Date"));
    end;


    procedure "---Alle----"()
    begin
    end;


    procedure ShowDocument()
    var
        NewDocTrack: Record "New Document Tracking";
        NewDocTrackFrm: Page "New Document Trackings";
    begin
        NewDocTrack.SETRANGE("Table ID", DATABASE::Job);
        NewDocTrack.SETRANGE("Document Type", 0);
        NewDocTrack.SETRANGE("Document No.", "No.");
        NewDocTrack.SETRANGE("Line No.", 0);
        NewDocTrackFrm.SETTABLEVIEW(NewDocTrack);
        NewDocTrackFrm.RUNMODAL;
        GET("No.");
    end;
}

