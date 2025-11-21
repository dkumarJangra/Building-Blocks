tableextension 50093 "BBG Employee Ext" extends Employee
{
    fields
    {
        // Add changes to table fields here
        field(50010; "Job Title/Grade"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            //TableRelation = "Pay  Grade"."Designation Code";
        }
        field(50011; "Department Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = true;
        }
        field(50012; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = true;
        }
        field(50013; "Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('AREA'));
        }
        field(50014; "Qualification Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = Qualification;
        }
        field(50015; "Sanctioning Incharge"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = Employee."No." WHERE("Leave Date" = CONST());
        }
        field(50016; "Skill Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            //TableRelation = "Pay  Skill".Code;
        }
        field(50017; "Branch Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50019; "Marital Status"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            OptionMembers = Single,Married,Divorced,Widowed;
        }
        field(50020; "Spouse Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50021; "Marriage Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50022; "No of Children"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            MinValue = 0;
        }
        field(50025; "Entitiled To Overtime"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50026; "Entitlement to ESI"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50027; "Entitlement to PF"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';

            trigger OnValidate()
            begin
                IF NOT "Entitlement to PF" THEN BEGIN
                    "PF Deduction on Actual Salary" := FALSE;
                    "EPF Deduction on Salary Amount" := FALSE;
                    "PF Contribution Limit" := 0;
                    "VPF %" := 0;
                    "VPF Amount" := 0;
                END;
            end;
        }
        field(50030; "Home Page"; Text[80])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50032; "Driving License No"; Text[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50033; "Valid Up To"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50034; Place; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50038; "PAN No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50039; "ESI No"; Text[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50040; "PF No"; Text[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50041; "ESI Dispensary"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50042; "Father/Husband"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50043; "Blood Group"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            OptionMembers = " ","A+","A-","B+","B-","AB+","AB-","O+","O-";
        }
        field(50045; "Salary Stopped"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50046; Remarks; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50050; "Payment Method"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            OptionMembers = Cash,Cheque,"Bank Transfer";
        }
        field(50051; "Bank Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50052; "Bank Name"; Text[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50053; "Bank Branch"; Text[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50054; "Account Type"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50055; "Account No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50060; "Department Filter"; Code[10])
        {
            Description = 'AlleBLK';
            FieldClass = FlowFilter;
        }
        field(50061; "Project Filter"; Code[10])
        {
            Description = 'AlleBLK';
            FieldClass = FlowFilter;
        }
        field(50062; "Location Filter"; Code[10])
        {
            Description = 'AlleBLK';
            FieldClass = FlowFilter;
        }
        field(50063; "Grade Filter"; Code[10])
        {
            Description = 'AlleBLK';
            FieldClass = FlowFilter;
            //TableRelation = Table33000010;
        }
        field(50064; "Pay Element Filter"; Code[10])
        {
            Description = 'AlleBLK';
            FieldClass = FlowFilter;
            //TableRelation = "Pay Elements";
        }
        field(50065; "Qualification Filter"; Code[10])
        {
            Description = 'AlleBLK';
            FieldClass = FlowFilter;
            //TableRelation = Table33000001;
        }
        field(50066; MonthFilter; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50067; YearFilter; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50068; TypeFilter; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            OptionMembers = Addition,Deduction,Reimbursement;
        }
        field(50070; "Resignation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50071; "Leave Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50072; "Confirmation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50075; "Increment Effective Date"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            OptionMembers = ,"Date of Joining","Date of Confirmation";
        }
        field(50076; "Increment Month Interval"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50077; "Latest Pay Revision Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50078; "Latest Pay Effective Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50079; "No Of Month For Confirmation"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50081; MonthlyEmolumentTotal; Decimal)
        {
            // CalcFormula = Sum("Pay Employee Pay Details"."Payable Amount" WHERE("Employee No" = FIELD("Employee No. Filter"),
            //                                                                      Year = FIELD(YearFilter),
            //                                                                      Month = FIELD(MonthFilter),
            //                                                                      Type = FIELD(TypeFilter)));
            // Description = 'AlleBLK';
            // FieldClass = FlowField;
        }
        field(50082; QualfiedForStatement217; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50083; QualfiedForStatement217AMT; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'THIS FIELD IS USED IN STATEMENT REPORT JUST TO HOLD THE TOTAL ADDITION VALUE';
        }
        field(50085; DaysDifference; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50086; "New Debit Amount (LCY)"; Decimal)
        {
            // CalcFormula = Sum("Detailed  Empl Ledger Entry"."Debit Amount (LCY)" WHERE("Employee No." = FIELD("No."),
            //                                                                             "Posting Date" = FIELD("Date Filter"),
            //                                                                             "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Code")));
            // Description = 'AlleDK 100408 for Employee Ledger Report';
            // FieldClass = FlowField;
        }
        field(50087; "New CREDIT Amount (LCY)"; Decimal)
        {
            // CalcFormula = Sum("Detailed  Empl Ledger Entry"."Credit Amount (LCY)" WHERE("Employee No." = FIELD("No."),
            //                                                                              "Posting Date" = FIELD("Date Filter"),
            //                                                                              "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Code")));
            // Description = 'AlleDK 100408 for Employee Ledger Report';
            // FieldClass = FlowField;
        }
        field(50089; "Status Tax"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            OptionMembers = "Ordinarily Resident","Not Ordinarily Resident","Non Resident";
        }
        field(50090; "Eligible Ded 80U"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50091; "TDS Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50092; "TDS Amount Actual"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50093; "TDS Ded US"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50095; Password; Text[10])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50096; "Recorded By"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50105; "Occupation Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            //TableRelation = Table33000056;
        }
        field(50111; "ECS Bank Code No."; Text[9])
        {
            Caption = 'ECS Bank Code No.';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50112; "ECS Bank Account Type"; Option)
        {
            Caption = 'ECS Bank Account Type';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            OptionMembers = Savings,Current,"Cash Credit";
        }
        field(50113; "ECS Bank Ledger No"; Text[30])
        {
            Caption = 'ECS Bank Ledger No';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50114; "Consent For Bulk Return"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50115; "Consent For ECS"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50116; "ECS Bank Account No."; Code[20])
        {
            Caption = 'ECS Bank Account No.';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50117; "ECS Bank Branch Name"; Text[30])
        {
            Caption = 'ECS Bank Branch Name';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50118; "ECS Bank Name"; Text[30])
        {
            Caption = 'ECS Bank Name';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50125; "Incentive %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50126; "Job Title Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            //TableRelation = "Job Titles"."Job Code";
        }
        field(50130; "PF Deduction on Actual Salary"; Boolean)
        {
            Caption = 'PF Deduction on Actual Salary';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50131; "EPF Deduction on Salary Amount"; Boolean)
        {
            Caption = 'Employee''s PF Deduction on Salary Amount';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50132; "VPF %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            MinValue = 0;

            trigger OnValidate()
            var
                Err001: Label 'Maximum limit defined in company policy is %1';
                Err002: Label 'Maximum limit for percentage value is 100';
            begin
            end;
        }
        field(50133; "VPF Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            MinValue = 0;

            trigger OnValidate()
            var
                Err003: Label 'Maximum limit defined in company policy is Rs %1';
                Err002: Label 'Negative values are not allowed';
            begin
            end;
        }
        field(50134; "PF Contribution Limit"; Decimal)
        {
            Caption = 'Employer''s PF Contribution Salary Limit';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            MinValue = 0;

            trigger OnValidate()
            var
                //PayComp2: Record "60020";
                Err001: Label 'Payroll Processing Month Date not defined';
                Err002: Label 'PF Policy not defined for current payroll processing month date : %1';
                Err003: Label 'PF Contribution Limit cannot be less than Rs %1';
            begin
            end;
        }
        field(50135; "PF %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            MinValue = 0;

            trigger OnValidate()
            var
                Err001: Label 'Mininmum value is %1';
            begin
            end;
        }
        field(50140; "Salary Processed"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Checking for Salary Processing for the Processing Month';
        }
        field(50145; "Salary Posted"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Checking for Salary Posting for the Processing Month';
        }
        field(50146; "Requested TDS Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50147; "BBG Employee Posting Group"; Code[10])
        {
            Caption = 'Employee Posting Group';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            //TableRelation = "Employee Posting Group";
        }
        field(50148; "Employee Bus. Posting Group"; Code[10])
        {
            Caption = 'Employee Bus. Posting Group';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            //TableRelation = "Pay  Business Posting Group";
        }
        field(50149; "BBG Balance"; Decimal)
        {
            // CalcFormula = Sum("Detailed  Empl Ledger Entry".Amount WHERE("Employee No." = FIELD("No.")));
            // Description = 'AlleBLK';
            // FieldClass = FlowField;
        }
        field(50150; "BBG Balance (LCY)"; Decimal)
        {
            // CalcFormula = Sum("Detailed  Empl Ledger Entry"."Amount (LCY)" WHERE("Employee No." = FIELD("No.")));
            // Caption = 'Balance (LCY)';
            // Description = 'AlleBLK';
            // FieldClass = FlowField;
        }
        field(50151; "Net Change"; Decimal)
        {
            // CalcFormula = - Sum("Detailed  Empl Ledger Entry".Amount WHERE("Employee No." = FIELD("No."),
            //                                                                "Posting Date" = FIELD("Date Filter")));
            // Caption = 'Net Change';
            // Description = 'AlleBLK';
            // FieldClass = FlowField;
        }
        field(50152; "Net Change (LCY)"; Decimal)
        {
            // CalcFormula = - Sum("Detailed  Empl Ledger Entry"."Amount (LCY)" WHERE("Employee No." = FIELD("No."),
            //                                                                        "Posting Date" = FIELD("Date Filter")));
            // Caption = 'Net Change (LCY)';
            // Description = 'AlleBLK';
            // FieldClass = FlowField;
        }
        field(50153; "Balance Due"; Decimal)
        {
            // CalcFormula = - Sum("Detailed  Empl Ledger Entry".Amount WHERE("Employee No." = FIELD("No."),
            //                                                                "Initial Entry Due Date" = FIELD("Date Filter"),
            //                                                                "Posting Date" = FIELD("Date Filter")));
            // Caption = 'Balance Due';
            // Description = 'AlleBLK';
            // FieldClass = FlowField;
        }
        field(50154; "Balance Due (LCY)"; Decimal)
        {
            // CalcFormula = - Sum("Detailed  Empl Ledger Entry"."Amount (LCY)" WHERE("Employee No." = FIELD("No."),
            //                                                                        "Initial Entry Due Date" = FIELD("Date Filter"),
            //                                                                        "Posting Date" = FIELD("Date Filter")));
            // Caption = 'Balance Due (LCY)';
            // Description = 'AlleBLK';
            // FieldClass = FlowField;
        }
        field(50155; Payments; Decimal)
        {
            // CalcFormula = Sum("Detailed  Empl Ledger Entry".Amount WHERE("Initial Document Type" = CONST(Payment),
            //                                                               "Entry Type" = CONST("Initial Entry"),
            //                                                               "Employee No." = FIELD("No."),
            //                                                               "Posting Date" = FIELD("Date Filter")));
            // Caption = 'Payments';
            // Description = 'AlleBLK';
            // FieldClass = FlowField;
        }
        field(50157; "Zone Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('ZONE'));
        }
        field(50158; "Cheque On Hold"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleDK 062008';
        }
        field(50165; "Shift Rotation Interval"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'SM_SKS001 Put the duration as no. of days';
            MinValue = 0;
        }
        field(50170; "Reason for Leaving"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleDK 150508 For report purpose';
        }
        field(50171; "Last Project"; Text[80])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleDK 150508 For report purpose';
        }
        field(50172; "Specialisation / Core Area"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleDK 160508 For report purpose';
        }
        field(50173; CTC; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleDK 280508 For report purpose';
        }
        field(55002; "Exp in years"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(55004; "Exp in mons"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }

        field(55010; "Block Salary Processing"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'MES-Seema - To Stop the processing of the salary of the employees';
        }
        field(55011; "Employee Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            OptionMembers = " ",Staff,Worker,Trainee,Casual;
        }
        field(55015; "Total exp in current org (Yrs)"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'MES-Seema-Field added for keeping track of information regarding experience of an employee';
            Editable = false;
        }
        field(55016; "Total exp in current org (Mnt)"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'MES-Seema-Field added for keeping track of information regarding experience of an employee';
            Editable = false;
        }
        field(55017; "Total exp in current org (Day)"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'MES-Seema-Field added for keeping track of information regarding experience of an employee';
            Editable = false;
        }
        field(55018; "Total Prev exp(Yrs)"; Decimal)
        {
            // CalcFormula = Sum("Employee Experience details"."Experience in yrs" WHERE("Emp Code" = FIELD("No.")));
            // DecimalPlaces = 0 : 0;
            // Description = 'MES-Seema-Field added for keeping track of information regarding experience of an employee';
            // Editable = false;
            // FieldClass = FlowField;
        }
        field(55019; "Total Prev exp(mths)"; Decimal)
        {
            // CalcFormula = Sum("Employee Experience details"."Experience in mths" WHERE("Emp Code" = FIELD("No.")));
            // DecimalPlaces = 0 : 0;
            // Description = 'MES-Seema-Field added for keeping track of information regarding experience of an employee';
            // Editable = false;
            // FieldClass = FlowField;
        }
        field(55020; "Total Prev Rel. exp(Yrs)"; Decimal)
        {
            // CalcFormula = Sum("Employee Experience details"."Experience in yrs" WHERE("Emp Code" = FIELD("No."),
            //                                                                            "Relevant Exp." = FILTER(true)));
            // Description = 'MES-Seema-Field added for keeping track of information regarding Prev. Relevant experience of an employee';
            // FieldClass = FlowField;
        }
        field(55021; "Total Prev Rel. exp(mths)"; Decimal)
        {
            // CalcFormula = Sum("Employee Experience details"."Experience in mths" WHERE("Emp Code" = FIELD("No."),
            //                                                                             "Relevant Exp." = FILTER(true)));
            // Description = 'MES-Seema-Field added for keeping track of information regarding  Prev. Relevant  experience of an employee';
            // FieldClass = FlowField;
        }
        field(55022; "Old No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'MES-Seema -Field added just to store old employee id''s to show them on report.';
        }
        field(55032; GrossEarning; Decimal)
        {
            // CalcFormula = Sum("Pay  Employee Pay Details"."Payable Amount" WHERE("Employee No" = FIELD("No."),
            //                                                                       Type = FILTER(Addition),
            //                                                                       Month = FIELD("Month Filter")));
            // Description = 'Mes-Seema - field added to calculate CTC';
            // Editable = false;
            // FieldClass = FlowField;
        }
        field(55033; EmployerContribution; Decimal)
        {
            // CalcFormula = Sum("Pay  Employee Pay Details"."Employer Contribition" WHERE("Employee No" = FIELD("No."),
            //                                                                              "Pay Element Code" = FILTER(PF | ESI | SUPERANN),
            //                                                                              Month = FIELD("Month Filter")));
            // Description = 'Mes-Seema -field added to calculate CTC';
            // Editable = false;
            // FieldClass = FlowField;
        }
        field(55034; EmployerContribution2; Decimal)
        {
            // CalcFormula = Sum("Pay  Employee Pay Details"."Employer Contribition2" WHERE("Employee No" = FIELD("No."),
            //                                                                               "Pay Element Code" = FILTER(PF | ESI),
            //                                                                               Month = FIELD("Month Filter")));
            // Description = 'Mes-Seema - field added to calculate CTC';
            // Editable = false;
            // FieldClass = FlowField;
        }
        field(55035; "Month Filter"; Integer)
        {
            Description = 'mes-Seema field added to calculate CTC';
            FieldClass = FlowFilter;
        }
        field(55036; "Current CTC"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'mes-Seema field added to calculate CTC';
        }
        field(55037; "GGB Loan A/C No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Mes-Arv- field added to show the a/c no. in the loan deduction report';
        }
        field(55038; "Canra Loan A/C No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Mes-Arv- field added to show the a/c no. in the loan deduction report';
        }
        field(55039; "Vehcle Loan A/C No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Mes-Arv- field added to show the a/c no. in the loan deduction report';
        }
        field(55041; PayDate; Date)
        {
            // CalcFormula = Lookup("Pay  Employee Elements"."Pay Structure Date" WHERE("Employee No" = FIELD("No.")));
            // Description = 'Mes-arv-temp added for information';
            // FieldClass = FlowField;
        }
        field(55042; "Department Name"; Text[30])
        {
            // CalcFormula = Lookup(Department.Description WHERE("Department Code" = FIELD("Department Code")));
            // Description = 'Mes-arv-temp added for information';
            // FieldClass = FlowField;
        }
        field(55043; "Indus Loan A/C No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Mes-Arv- field added to show the a/c no. in the loan deduction report';
        }
        field(55044; "ESI Calc for Rejoin Emp"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Mes-seema -To enable empoyees ESI deduction in case system hasn''t made Salary in previous months in ESI period due to any reason and want to calculate ESI afterwars when employee rejoins on the same existing Employee No.';
        }
        field(55045; "Full and Final indicator"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Mes-Swapnil-For delete the entries from PEPD after fill the leave date for those employee whose full and final is not done';
        }
        field(55046; ActualDateOfLeaving; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Mes-Sacp-Field added for keeping track of Actual Leaving date of employee';
        }
        field(55047; "Entitlement For Bonus"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Alle-Sacp-Field added to Restrict Bonus Calculation Process only those employee whose bonus flag is true';
        }
        field(55048; "Year Filter"; Integer)
        {
            Description = 'Alle-Sacp  field added to calculate CTC';
            FieldClass = FlowFilter;
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
        Text018: Label 'Employee Pay Elements get Revised by Changing the Grade';
        Text019: Label 'Enter the Confirmaton Date';
}