tableextension 97002 "EPC Job Ext" extends Job
{
    fields
    {
        // Add changes to table fields here

        field(50110; "Region Code for Rank Hierarcy"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Rank Code Master";

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Planning);
                IF "Region Code for Rank Hierarcy" <> '' THEN BEGIN
                    RankCode_1.RESET;
                    RankCode_1.SETRANGE("Rank Batch Code", "Region Code for Rank Hierarcy");
                    IF NOT RankCode_1.FINDFIRST THEN
                        ERROR('Please define Rank Code -' + '' + "Region Code for Rank Hierarcy");

                    RankCode_1.RESET;
                    RankCode_1.SETRANGE("Rank Batch Code", "Region Code for Rank Hierarcy");
                    IF RankCode_1.FINDSET THEN
                        REPEAT
                            CommissionStructure.RESET;
                            CommissionStructure.SETRANGE("Project Type", "Default Project Type");
                            CommissionStructure.SETRANGE(CommissionStructure."Rank Code", RankCode_1.Code);
                            IF NOT CommissionStructure.FINDFIRST THEN BEGIN
                                Message('Please create Commission structure with Rank Code=' + '' + FORMAT(RankCode_1.Code)); //Added comment 01072025
                                //ERROR('Please create Commission structure with Rank Code=' + '' + FORMAT(RankCode_1.Cod);  //Code comm01072025
                            END;
                        UNTIL RankCode_1.NEXT = 0;
                END;
                CompanywiseAccount.RESET;
                CompanywiseAccount.SETRANGE(CompanywiseAccount."MSC Company", TRUE);
                IF CompanywiseAccount.FINDFIRST THEN BEGIN
                    IF COMPANYNAME <> CompanywiseAccount."Company Code" THEN BEGIN
                        RecJob.RESET;
                        RecJob.CHANGECOMPANY(CompanywiseAccount."Company Code");
                        RecJob.SETRANGE("No.", "No.");
                        IF RecJob.FINDFIRST THEN BEGIN
                            RecJob."Region Code for Rank Hierarcy" := "Region Code for Rank Hierarcy";
                            RecJob.MODIFY;
                        END;
                    END;
                END;
            end;
        }
        field(50098; "Workflow Approval Status"; Option)
        {
            Caption = 'Workflow Approval Status';
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            Editable = true;
            OptionCaption = 'Open,Released,Pending Approval';
            OptionMembers = Open,Released,"Pending Approval";
        }
        field(50099; "Workflow Sub Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            Editable = false;
            OptionCaption = ' ,FA,Regular,Direct,WorkOrder,Inward,Outward';
            OptionMembers = " ",FA,Regular,Direct,WorkOrder,Inward,Outward;
        }
        field(90003; "Responsibility Center"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB for RE';
            TableRelation = "Responsibility Center 1";
        }
        field(50007; "Project Amount"; Decimal)
        {
            CalcFormula = Sum("Job Planning Line"."Total Price" WHERE("Job No." = FIELD("No.")));
            Description = 'ALLESP BCL0004 05-07-2007- use in sales header';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50044; "Mobilization Adj Starting %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0005 06-07-2007';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50045; "Mobilization Adj Ending %"; Decimal)
        {
            DataClassification = ToBeClassified;
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
        field(50046; "Equipment Adj Starting %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0005 06-07-2007';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50047; "Equipment Adj Ending %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0005 06-07-2007';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50053; "Equipment Adv Remained"; Decimal)
        {
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("Bill-to Customer No."),
                                                                                  "User Branch Code" = FIELD("No."),
                                                                                  "Posting Type" = CONST("Equipment Advance")));
            Description = 'ALLESP BCL0005 06-07-2007';
            FieldClass = FlowField;
        }
        field(50048; "Secured Adj Starting %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0005 06-07-2007';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50049; "Secured Adj Ending %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0005 06-07-2007';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50054; "Secured Adv Remained"; Decimal)
        {
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("Bill-to Customer No."),
                                                                                  "User Branch Code" = FIELD("No."),
                                                                                  "Posting Type" = CONST("Secured Advance")));
            Description = 'ALLESP BCL0005 06-07-2007';
            FieldClass = FlowField;
        }
        field(50050; "Adhoc Adj Starting %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0005 06-07-2007';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50051; "Adhoc Adj Ending %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0005 06-07-2007';
            MaxValue = 100;
            MinValue = 0;
        }



        field(50055; "Adhoc Adv Remained"; Decimal)
        {
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("Bill-to Customer No."),
                                                                                  "User Branch Code" = FIELD("No."),
                                                                                  "Posting Type" = CONST("Adhoc Advance")));
            Description = 'ALLESP BCL0005 06-07-2007';
            FieldClass = FlowField;
        }
        field(50132; "BSP4 Plan wise Applicable"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                CompanywiseGLAccount: Record "Company wise G/L Account";
                RecJob: Record Job;
            begin
                CompanywiseGLAccount.RESET;
                CompanywiseGLAccount.SETRANGE("MSC Company", TRUE);
                IF CompanywiseGLAccount.FINDFIRST THEN BEGIN
                    IF CompanywiseGLAccount."Company Code" = COMPANYNAME THEN
                        ERROR('Process will done from LLP Company');
                    UserSetup.RESET;
                    IF UserSetup.GET(USERID) THEN
                        UserSetup.TESTFIELD("BSP4 Update on Project Mster");

                    IF "BSP4 Plan wise Applicable" THEN BEGIN
                        TESTFIELD("BSP4 Plan wise St. Date");
                        DocumentMaster_1.RESET;
                        DocumentMaster_1.SETRANGE("Project Code", "No.");
                        DocumentMaster_1.SETRANGE(Code, 'PPLAN');
                        DocumentMaster_1.SETRANGE("Unit Code", '');
                        DocumentMaster_1.SETRANGE("Document Type", DocumentMaster_1."Document Type"::Charge);
                        IF DocumentMaster_1.FINDSET THEN
                            REPEAT
                                IF DocumentMaster_1."Rate/Sq. Yd" <> 0 THEN
                                    DocumentMaster_1.TESTFIELD("BSP4 Plan wise Rate / Sq. Yd");
                            UNTIL DocumentMaster_1.NEXT = 0
                    END;
                    /*
                     ELSE BEGIN
                      "BSP4 Plan wise St. Date" := 0D;
                      DocumentMaster_1.RESET;
                      DocumentMaster_1.SETRANGE("Project Code","No.");
                      DocumentMaster_1.SETRANGE(Code,'PPLAN');
                      DocumentMaster_1.SETRANGE("Unit Code",'');
                      DocumentMaster_1.SETRANGE("Document Type",DocumentMaster_1."Document Type"::Charge);
                      IF DocumentMaster_1.FINDSET THEN
                        REPEAT
                          IF DocumentMaster_1."Rate/Sq. Yd" <> 0 THEN
                            DocumentMaster_1."BSP4 Plan wise Rate / Sq. Yd" := 0;
                            DocumentMaster_1.MODIFY;
                        UNTIL DocumentMaster_1.NEXT = 0

                    END;
                    */

                    IF "BSP4 Plan wise St. Date" = 0D THEN BEGIN
                        "BSP4 Plan wise St. Date" := TODAY;
                        MODIFY;
                    END;
                    RecJob.RESET;
                    RecJob.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                    IF RecJob.GET("No.") THEN BEGIN
                        RecJob."BSP4 Plan wise Applicable" := "BSP4 Plan wise Applicable";
                        RecJob."BSP4 Plan wise St. Date" := "BSP4 Plan wise St. Date";
                        RecJob.MODIFY;
                    END;
                END;

            end;
        }
        field(50133; "BSP4 Plan wise St. Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                UserSetup.RESET;
                IF UserSetup.GET(USERID) THEN
                    UserSetup.TESTFIELD("BSP4 Update on Project Mster");
            end;
        }
        field(90051; "Min. Allotment Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90052; "Min. Allotment Area"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50106; "Project Launch"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50116; Trading; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Planning);
            end;
        }
        field(50058; CC1; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
        }
        field(50059; "CC1 Designation"; Text[50])
        {
            Caption = 'Designation';
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
        }
        field(50060; CC2; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
        }
        field(50061; "CC2 Designation"; Text[50])
        {
            Caption = 'Designation';
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
        }
        field(50062; CC3; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
        }
        field(50063; "CC3 Designation"; Text[50])
        {
            Caption = 'Designation';
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
        }
        field(50064; CC4; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
        }
        field(50065; "CC4 Designation"; Text[50])
        {
            Caption = 'Designation';
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
        }
        field(50066; "Client Contact"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
        }
        field(50067; "Client Contact Designation"; Text[50])
        {
            Caption = 'Designation';
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
        }
        field(50068; Subject; Text[80])
        {
            Caption = 'Transmittal Subject';
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
        }
        field(50069; "CC1 Only Transmittal"; Boolean)
        {
            Caption = 'Only Transmittal';
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
        }
        field(50070; "CC2 Only Transmittal"; Boolean)
        {
            Caption = 'Only Transmittal';
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
        }
        field(50071; "CC3 Only Transmittal"; Boolean)
        {
            Caption = 'Only Transmittal';
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
        }
        field(50072; "CC4 Only Transmittal"; Boolean)
        {
            Caption = 'Only Transmittal';
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
        }
        field(50057; "Transmittal No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
            TableRelation = "No. Series".Code;
        }
        field(50117; "Non-Trading"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Planning);
            end;
        }
        field(50131; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESSS';
            Editable = false;
            OptionCaption = 'Open,Pending For Approval,Approved,Rejected';
            OptionMembers = Open,"Pending For Approval",Approved,Rejected;
        }
        field(50105; "Project Min. Amt based on %"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'BBG1.00 270813';
        }
        field(90037; "Sent for Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';

            trigger OnValidate()
            begin
                // ALLEAA
                IF "Sent for Approval" THEN BEGIN
                    Initiator := USERID;
                    IF "Job Creation Date" = 0D THEN BEGIN
                        "Job Creation Date" := TODAY;
                        "Job Creation Time" := TIME;
                    END;

                    DocSetup.RESET;
                    DocSetup.SETRANGE("Document Type", DocSetup."Document Type"::Job);
                    DocSetup.SETRANGE("Sub Document Type", DocSetup."Sub Document Type"::" ");
                    DocSetup.SETRANGE("Approval Required", TRUE);
                    IF DocSetup.FINDFIRST THEN BEGIN
                        DocApproval.RESET;
                        DocApproval.SETRANGE("Document Type", DocSetup."Document Type"::Job);
                        DocApproval.SETRANGE("Sub Document Type", DocApproval."Sub Document Type"::" ");
                        DocApproval.SETFILTER("Document No", '%1', '');
                        DocApproval.SETRANGE(Initiator, Initiator);
                        IF DocApproval.FINDFIRST THEN
                            REPEAT
                                DocumentApproval.INIT;
                                DocumentApproval.COPY(DocApproval);
                                DocumentApproval."Document No" := "No.";
                                DocApproval1.RESET;
                                DocApproval1.SETRANGE("Document Type", DocSetup."Document Type"::Job);
                                DocApproval1.SETRANGE("Sub Document Type", DocApproval1."Sub Document Type"::" ");
                                DocApproval1.SETRANGE("Document No", "No.");
                                DocApproval1.SETRANGE(Initiator, Initiator);
                                IF NOT DocApproval1.FINDFIRST THEN
                                    DocumentApproval.INSERT;
                            UNTIL DocApproval.NEXT = 0;
                    END;
                    Blocked := Blocked::Posting;
                END;
                // ALLEAA
            end;
        }
        field(90040; "Sent for Approval Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90039; "Job Creation Time"; Time)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90041; "Sent for Approval Time"; Time)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90036; Initiator; Code[20])
        {
            Caption = 'Requestor';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = User."User Name";
        }
        field(90033; Approved; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90034; "Approved Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90035; "Approved Time"; Time)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90044; "Amendment Approved"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AIR0013';
        }
        field(90045; "Amendment Approved Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AIR0013';
        }
        field(90046; "Amendment Approved Time"; Time)
        {
            DataClassification = ToBeClassified;
            Description = 'AIR0013';
        }
        field(90038; "Job Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50127; "Land Item"; Code[20])
        {
            CalcFormula = Lookup(Item."No." WHERE("Global Dimension 1 Code" = FIELD("No.")));
            Description = 'ALLESSS';
            FieldClass = FlowField;
        }
        field(90043; Amended; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AIR0013';
        }
        field(90156; "Land No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'BBG2.0';
            TableRelation = "Land Agreement Header";
        }
        field(90152; "Last Job Archive Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90153; "Last Job Archive By"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90154; "Last Job Archive Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90010; "Total No. of Units"; Integer)
        {
            CalcFormula = Count("Unit Master" WHERE("Project Code" = FIELD("No."),
                                                     "Non Usable" = CONST(false),
                                                     "Unit Category" = CONST(Normal)));
            Description = 'AlleBLK';
            FieldClass = FlowField;
        }
        field(90011; "Sub Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = "Dimension Value".Code WHERE(Code = FILTER('PROJECT BLOCK'),
                                                          "LINK to Region Dim" = FIELD("No."));
        }
        field(90012; "Total No. of Sub Project Units"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90013; "Project Saleable Area"; Decimal)
        {
            CalcFormula = Sum("Unit Master"."Saleable Area" WHERE("Project Code" = FIELD("No."),
                                                                   "Unit Category" = CONST(Normal),
                                                                   "Non Usable" = CONST(false)));
            Description = 'AlleBLK';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90014; "SubProject Saleable Area"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(90015; "Project Sold Area"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(90016; "SubProject Sold Area"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(90017; "Cost/Sq. Ft."; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90018; "Project Leaseable Area"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB';
        }
        field(90019; "SubProject Leaseable Area"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB';
        }
        field(90020; "Project Leased Area"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB';
        }
        field(90021; "SubProject Leased Area"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB';
        }
        field(90022; "Total Unit Sold"; Integer)
        {
            CalcFormula = Count("Unit Master" WHERE("Project Code" = FIELD("No."),
                                                     Status = FILTER(Booked),
                                                     "Non Usable" = CONST(false),
                                                     Reserve = CONST(false),
                                                     "Unit Category" = CONST(Normal)));
            Description = 'ALLEAB';
            FieldClass = FlowField;
        }
        field(90023; "Total Unit Leased"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB';
        }
        field(90024; "SubProject Unit Sold"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB';
        }
        field(90025; "SubProject Unit Leased"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB';
        }
        field(90028; "BOQ Type"; Option)
        {
            Caption = 'BOQ Type';
            DataClassification = ToBeClassified;
            Description = 'ALLEAA';
            OptionCaption = ' ,Sale,Purchase';
            OptionMembers = " ",Sale,Purchase;
        }
        field(90029; "Principal Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(90030; "Agreement No."; Code[60])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETG';
        }
        field(90031; "Bill Paying Authority"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETG';
        }
        field(90032; "No. of Archive"; Integer)
        {
            CalcFormula = Max("Job Archive"."Version No." WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50112; "Last Total No. of Units"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50113; "Last Total Project Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50114; "Last Total Unit Sold"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB';
            Editable = false;
        }
        field(90002; "Total Super Area"; Decimal)
        {
            CalcFormula = Sum(Item."Super Area (sq ft)" WHERE("Property Unit" = FILTER(true),
                                                               "Job No." = FIELD("No.")));
            Description = 'ALLERE';
            Editable = false;
            FieldClass = FlowField;
        }

        field(90004; "USER ID"; Code[28])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB for RE';
        }
        field(90005; "Max. Retention Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB for RE';
        }
        field(90006; "Total Covered Car Parking"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB for RE';
        }
        field(90007; "Total Open Car Parking"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB for RE';
        }








        field(90042; "Type of Contract"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Variable,Fixed,Turnkey';
            OptionMembers = " ",Variable,"Fixed",Turnkey;
        }


        field(90047; "Amendment Initiator"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AIR0013';
        }
        field(90048; "Sold By"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(90049; "Doc. No. Occurrence"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEPG 271211';
        }
        field(90050; "Default Project Type"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Type" WHERE(Blocked = CONST(false));

            trigger OnValidate()
            var
                Job_1: Record Job;
            begin
                //ALLEDK 140213
                TESTFIELD(Status, Status::Planning);
                IF xRec."Default Project Type" <> '' THEN
                    IF "Default Project Type" <> '' THEN BEGIN
                        Application.RESET;
                        Application.SETRANGE("Project Type", "Default Project Type");
                        IF Application.FINDFIRST THEN
                            ERROR('Commission code can not be change due to many Entries Exists');

                        ConfOrder.RESET;
                        ConfOrder.SETRANGE("Project Type", "Default Project Type");
                        IF ConfOrder.FINDFIRST THEN
                            ERROR('Commission code can not be change due to many Entries Exists');
                    END;
                //ALLEDK 140213
                CompanywiseAccount.RESET;
                CompanywiseAccount.SETRANGE("MSC Company", TRUE);
                IF CompanywiseAccount.FINDFIRST THEN BEGIN
                    Job_1.RESET;
                    Job_1.CHANGECOMPANY(CompanywiseAccount."Company Code");
                    Job_1.SETRANGE("No.", "No.");
                    IF Job_1.FINDFIRST THEN BEGIN
                        Job_1."Default Project Type" := "Default Project Type";
                        Job_1.MODIFY;
                    END;
                END;

                IF "Default Project Type" <> '' THEN BEGIN
                    TESTFIELD("Region Code for Rank Hierarcy", '');
                    CommissionStructure.RESET;
                    CommissionStructure.SETRANGE("Project Type", "Default Project Type");
                    IF NOT CommissionStructure.FINDFIRST THEN
                        ERROR('Please create commission Structure for code.' + '' + "Default Project Type");
                END;
            end;
        }

        field(90053; "Total Project Cost"; Decimal)
        {
            CalcFormula = Sum("Unit Master"."Total Value" WHERE("Project Code" = FIELD("No."),
                                                                 "Non Usable" = CONST(false),
                                                                 "Unit Category" = CONST(Normal)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90054; "old Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(90055; "Launch Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Job_1: Record Job;
            begin
                TESTFIELD(Status, Status::Planning);
                CompanywiseAccount.RESET;
                CompanywiseAccount.SETRANGE("MSC Company", TRUE);
                IF CompanywiseAccount.FINDFIRST THEN BEGIN
                    Job_1.RESET;
                    Job_1.CHANGECOMPANY(CompanywiseAccount."Company Code");
                    Job_1.SETRANGE("No.", "No.");
                    IF Job_1.FINDFIRST THEN BEGIN
                        Job_1."Launch Date" := "Launch Date";
                        Job_1.MODIFY;
                    END;
                END;
            end;
        }
        field(90056; "Project Layout Area"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Planning);
            end;
        }
        field(90057; "Efficency %"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Planning);
            end;
        }
        field(90058; "Job Archive No."; Integer)
        {
            CalcFormula = Max("Job Archive"."Version No." WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90060; "Initiator User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            Editable = false;

            trigger OnLookup()
            begin
                //UserMgt.LookupUserID("Initiator User ID");
            end;

            trigger OnValidate()
            begin
                //UserMgt.ValidateUserID("Initiator User ID");
            end;
        }


        field(90155; "Project Development Charge"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'BBG2.0';
        }

        field(90157; "Verita Applicable"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50111; "Last Project Saleable Area"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50125; "New commission Str. Applicable"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                UserSetup.RESET;
                IF UserSetup.GET(USERID) THEN
                    UserSetup.TESTFIELD("New Comm Str on Job Allow");
            end;
        }
        field(50026; "Retention Amount %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0005 06-07-2007';
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                "Retention Amount" := "Project Amount" * "Retention Amount %" / 100; //ALLESP BCL0005 31-07-2007
            end;
        }
        field(50038; "Retention Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0005 31-07-2007';
        }
        field(50126; "New commission Str. StartDate"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50129; "Joint Venture"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESSS';
        }
        field(50128; "Test Report Run"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESSS';
        }
        field(50118; "Company Name"; Text[30])
        {
            CalcFormula = Lookup("Responsibility Center"."Company Name" WHERE(Code = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50130; "Pending From USER ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESSS';
            Editable = false;
        }

        field(50134; "Type Of Deed"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,AGPA,Sale Deed';
            OptionMembers = " ",AGPA,"Sale Deed";
            Editable = False;

        }
        field(50135; "Deed No"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = False;

        }
        field(50136; "Bank APF"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50137; "Bank Loan Project"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50138; "Draft LP No"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50139; "Extent of Layout (Acres)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50140; "Extent of Layout(Guntas/Cents)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Extent of Layout (Guntas/Cents)';
        }
        field(50141; "Approval Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,HMDA,MUNCIPAL,VILLAGE';
            OptionMembers = "",HMDA,MUNCIPAL,VILLAGE;
        }
        field(50142; "Project Type"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50143; "Village"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50144; "Rera No"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50145; "RERA Registration Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50146; "RERA Expire Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50147; "Project Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50148; "Deed LLp Name"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50149; "Final Layout (OC)"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50150; "Rera From"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(50151; "Rera To"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50152; "Cluster Name"; Code[20])
        {
            TableRelation = "New Cluster Master"."Cluster Code";
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
        Application: Record Application;
        ConfOrder: Record "Confirmed Order";
        CompanywiseAccount: Record "Company wise G/L Account";
        CommissionStructure: Record "Commission Structure";
        RankCode_1: Record "Rank Code";
        RecJob: Record Job;
        UserSetup: Record "User Setup";
        DocumentMaster_1: Record "Document Master";
        DocSetup: Record "Document Type Setup";
        DocApproval: Record "Document Type Approval";
        DocumentApproval: Record "Document Type Approval";
        DocApproval1: Record "Document Type Approval";

    PROCEDURE CheckBeforeRelease()
    BEGIN
        "Initiator User ID" := USERID;
        IF "Job Creation Date" = 0D THEN BEGIN
            "Job Creation Date" := WORKDATE;
            "Job Creation Time" := TIME;
        END;
        TESTFIELD("Global Dimension 1 Code");
    END;

    [IntegrationEvent(false, false)]
    PROCEDURE OnCheckJobPostRestrictions();
    BEGIN
    END;

    [IntegrationEvent(false, false)]
    PROCEDURE OnCheckJobReleaseRestrictions();
    BEGIN
    END;
}