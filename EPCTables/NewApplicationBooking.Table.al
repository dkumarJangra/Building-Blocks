table 50016 "New Application Booking"
{
    // ALLEPG 310812 : Code added for freezing Unit Code.
    // ALLETDK081112--Changed "FlowField" of "Total Receivec Amount" field
    //     ALLETDK221112--Added code to update due date
    // 
    // //ALLEDK 210921 -21.09 Min allotment amount modify
    // 291221 Calculate Min. allotment amount new function and code
    // ALLESSS 26/02/24 : Added code to check Project Approval Status as Approved

    Caption = 'Application Booking';
    DataPerCompany = false;
    DrillDownPageID = "Application List (POC)";
    LookupPageID = "Application List (POC)";

    fields
    {
        field(1; "Application No."; Code[20])
        {
            Caption = 'Application No.';

            trigger OnValidate()
            begin
                IF "Application No." <> xRec."Application No." THEN BEGIN
                    BondSetup.GET;
                    NoSeriesMgt.TestManual(BondSetup."Application Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Project Type"; Code[20])
        {
            Caption = 'Project Type';
            Editable = false;
        }
        field(3; "Scheme Code"; Code[20])
        {
            Caption = 'Scheme Code';
            Editable = false;
        }
        field(4; "Scheme Version No."; Integer)
        {
            BlankZero = true;
            Caption = 'Scheme Version No.';
            Editable = false;
        }
        field(5; "Scheme Sub Version No."; Integer)
        {
            BlankZero = true;
            Caption = 'Scheme Sub Version No.';
            Editable = false;
        }
        field(6; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            Editable = true;

            trigger OnValidate()
            begin
                IF ("Associate Code" <> '') AND (USERID <> '1003') THEN BEGIN
                    CLEAR(Vend);
                    IF Vend.GET("Associate Code") THEN
                        IF "Posting Date" < Vend."BBG Date of Joining" THEN
                            ERROR('Application DOJ greater than Associate DOJ');
                END;
            end;
        }
        field(7; "Document Date"; Date)
        {
            Caption = 'Document Date';
            Editable = false;
        }
        field(8; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Responsibility Center 1".Code WHERE("Active Projects" = FILTER(true));

            trigger OnValidate()
            var
                CompanyWise_1: Record "Company wise G/L Account";
                ResponsibilityCenter_1: Record "Responsibility Center 1";
                FindCompany: Boolean;
                RecJob_1: Record Job;
                Project_RankWisesetup: record "Project wise Appl. Setup";
                ProjectwiseCommSetup: Record "Commission Structr Amount Base";
            begin

                //160816
                UserSetup.RESET;
                UserSetup.SETRANGE("User ID", USERID);
                IF UserSetup.FINDFIRST THEN BEGIN
                    IF (NOT UserSetup."Allow for Non Trading Project") AND (UserSetup."Allow for Trading Project") THEN BEGIN
                        IF "Application Type" <> "Application Type"::Trading THEN
                            ERROR('You are authorised for Trading Application');
                    END ELSE IF (UserSetup."Allow for Non Trading Project") AND (NOT UserSetup."Allow for Trading Project") THEN BEGIN
                        IF "Application Type" <> "Application Type"::"Non Trading" THEN
                            ERROR('You are authorised for Non Trading Application');
                    END ELSE IF (UserSetup."Allow for Non Trading Project") AND (UserSetup."Allow for Trading Project") THEN BEGIN
                    END ELSE
                        ERROR('You are not authorised for New Booking');
                END;



                //160816
                GLSetup.GET;
                IF "Shortcut Dimension 1 Code" <> '' THEN BEGIN
                    IF Respcenter.GET("Shortcut Dimension 1 Code") THEN BEGIN
                        IF Respcenter."Company Name" <> 'BBG India Developers LLP' THEN
                            UserSetup.TESTFIELD(UserSetup."Allow Receipt on LLP Project");

                        //Respcenter.TESTFIELD("Company Name");
                        IF "Application Type" = "Application Type"::"Non Trading" THEN BEGIN
                            ResponsibilityCenter_1.RESET;
                            IF ResponsibilityCenter_1.GET("Shortcut Dimension 1 Code") THEN
                                "Company Name" := ResponsibilityCenter_1."Company Name";

                            RecJob_1.RESET;
                            RecJob_1.SETRANGE("No.", "Shortcut Dimension 1 Code");
                            IF RecJob_1.FINDFIRST THEN BEGIN
                                IF (NOT RecJob_1."Non-Trading") AND (NOT RecJob_1.Trading) THEN
                                    ERROR('Project should be trading or Non-Trading');
                                IF RecJob_1."Non-Trading" THEN BEGIN
                                END ELSE IF RecJob_1.Trading THEN
                                        ERROR('Application Type should be Trading');
                            END;
                        END ELSE BEGIN
                            "Company Name" := COMPANYNAME;
                            GLSetup.GET;
                            CompanyWise_1.RESET;
                            CompanyWise_1.SETRANGE("MSC Company", TRUE);
                            IF CompanyWise_1.FINDFIRST THEN BEGIN
                                IF CompanyWise_1."Company Code" = COMPANYNAME THEN BEGIN
                                    RecJob_1.RESET;
                                    RecJob_1.SETRANGE("No.", "Shortcut Dimension 1 Code");
                                    IF RecJob_1.FINDFIRST THEN BEGIN
                                        IF (NOT RecJob_1."Non-Trading") AND (NOT RecJob_1.Trading) THEN
                                            ERROR('Project should be trading or Non-Trading');
                                        IF RecJob_1.Trading THEN BEGIN
                                            IF "Application Type" <> "Application Type"::Trading THEN
                                                ERROR('Application Type should be Trading');
                                        END ELSE IF RecJob_1."Non-Trading" THEN BEGIN
                                            IF "Application Type" <> "Application Type"::"Non Trading" THEN
                                                ERROR('Application Type should be Non Trading');
                                        END;
                                    END;
                                END;
                            END;
                        END;
                    END;
                END ELSE
                    "Project Type" := '';
                IF "Shortcut Dimension 1 Code" <> '' THEN BEGIN
                    Job.RESET;
                    Job.CHANGECOMPANY("Company Name");
                    Job.SETRANGE("No.", "Shortcut Dimension 1 Code");
                    IF Job.FINDFIRST THEN BEGIN
                        Job.TESTFIELD("Approval Status", Job."Approval Status"::Approved);  //ALLESSS 26/02/24
                        Job.TESTFIELD("Default Project Type");
                        Job.TESTFIELD("Region Code for Rank Hierarcy");
                        IF Job.Status = Job.Status::Planning THEN
                            ERROR('Project should be Approved/Release');

                        //Code Added Start 01072025
                        "Travel applicable" := true;
                        "Registration Bouns (BSP2)" := True;
                        "Project Type" := Job."Default Project Type";
                        "Rank Code" := job."Region Code for Rank Hierarcy";
                        Project_RankWisesetup.RESET;
                        Project_RankWisesetup.SetRange("Project Code", "Shortcut Dimension 1 Code");
                        Project_RankWisesetup.SetFilter("Effective From Date", '<=%1', "Posting Date");
                        Project_RankWisesetup.SetFilter("Effective To Date", '>=%1', "Posting Date");
                        Project_RankWisesetup.SetRange("Project Rank Code", Rec."Rank Code");
                        //Project_RankWisesetup.SetFilter("Commission Structure Code", '<>%1', '');
                        IF Project_RankWisesetup.FindFirst() then begin
                            "Rank Code" := Project_RankWisesetup."Project Rank Code";
                            "Project Type" := Project_RankWisesetup."Commission Structure Code";
                            "Travel applicable" := Project_RankWisesetup."Travel Applicable";
                            "Registration Bouns (BSP2)" := Project_RankWisesetup."Registration Bonus (BSP2)";
                        end;



                        //Code Added End 01072025
                        //"Rank Code" := Job."Region Code for Rank Hierarcy";   //Code Commented 01072025
                    END;

                    ProjectMilestoneHdr.RESET;
                    ProjectMilestoneHdr.CHANGECOMPANY("Company Name");
                    ProjectMilestoneHdr.SETCURRENTKEY("Project Code");
                    ProjectMilestoneHdr.SETRANGE("Project Code", "Shortcut Dimension 1 Code");
                    IF ProjectMilestoneHdr.FINDSET THEN BEGIN
                        REPEAT
                            ProjectMilestoneHdr.TESTFIELD(Status, ProjectMilestoneHdr.Status::Release);
                        UNTIL ProjectMilestoneHdr.NEXT = 0;
                    END ELSE
                        ERROR('Please define Project milestone for Project Code' + ' ' + "Shortcut Dimension 1 Code");

                END;
            end;
        }
        field(9; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(10; "Customer Name"; Text[50])
        {
            Caption = 'Customer Name';

            trigger OnValidate()
            begin
                "Customer Name" := UPPERCASE("Customer Name");
            end;
        }
        field(12; "Associate Code"; Code[20])
        {
            Caption = 'Associate Code';
            TableRelation = Vendor."No." WHERE("BBG Status" = FILTER(Provisional | Active),
                                              "BBG Vendor Category" = FILTER("IBA(Associates)" | "CP(Channel Partner)"));
            trigger OnValidate()
            begin
                IF "Shortcut Dimension 1 Code" <> '' THEN BEGIN
                    Job.RESET;
                    Job.CHANGECOMPANY("Company Name");
                    Job.SETRANGE("No.", "Shortcut Dimension 1 Code");
                    IF Job.FINDFIRST THEN BEGIN
                        // "Rank Code" := Job."Region Code for Rank Hierarcy";  //Code commented 01072025
                    END;
                END;

                IF "Associate Code" <> xRec."Associate Code" THEN
                    "Received From Code" := '';
                VALIDATE("Received From Code", "Associate Code");

                IF "Associate Code" = '' THEN
                    EXIT;

                CLEAR(Vend);
                IF (Vend.GET("Associate Code")) AND (USERID <> '1003') THEN BEGIN
                    Vend.TESTFIELD("BBG Black List", FALSE);
                    Vend.TESTFIELD("BBG Status", Vend."BBG Status"::Active);  //220121
                    IF "Posting Date" < Vend."BBG Date of Joining" THEN
                        ERROR('Application DOJ greater than Associate DOJ');
                    IF Vend."BBG Vendor Category" = Vend."BBG Vendor Category"::"CP(Channel Partner)" THEN  //050924 Added new code
                        "Rank Code" := Vend."Sub Vendor Category";  //02062025 Code Added
                    //"Rank Code" := 'R0003';    //050924 Added new code  //02062025 Code commented
                END;

                IF ("Associate Code" <> '') THEN BEGIN
                    ReleaseUnitApp.CheckVendStatus("Associate Code"); //BBG 090816

                    RegionwiseVendor.RESET;
                    RegionwiseVendor.SETRANGE("No.", "Associate Code");
                    RegionwiseVendor.SETRANGE("Region Code", "Rank Code");
                    IF NOT RegionwiseVendor.FINDFIRST THEN
                        ERROR('Please define the Rank Relation')
                    ELSE BEGIN
                        RegionwiseVendor.TESTFIELD(RegionwiseVendor."Rank Code");
                        IF ("Associate Code" <> 'IBA9999999') AND ("Associate Code" <> 'CP99999999') THEN
                            RegionwiseVendor.TESTFIELD(RegionwiseVendor."Parent Rank");
                    END;
                END;

                VendBuspost.RESET;
                VendBuspost.CHANGECOMPANY("Company Name");
                VendBuspost.SETRANGE("No.", "Associate Code");
                IF VendBuspost.FINDFIRST THEN BEGIN
                    VendBuspost.TESTFIELD("Gen. Bus. Posting Group");
                END ELSE
                    ERROR('Please create this associate in =' + "Company Name");
                /*
                NODLine.RESET;
                NODLine.CHANGECOMPANY("Company Name");
                NODLine.SETRANGE(NODLine.Type, NODLine.Type::Vendor);
                NODLine.SETRANGE("No.", "Associate Code");
                IF NOT NODLine.FINDFIRST THEN BEGIN
                    ERROR('Create NOD/NOC lines with Associate Code ' + "Associate Code" + 'in company -' + "Company Name");
                END;
                *///Need to check the code in UAT

                AllowedSection.RESET;
                AllowedSection.CHANGECOMPANY("Company Name");
                AllowedSection.SETRANGE("Vendor No", "Associate Code");
                IF NOT AllowedSection.FINDFIRST THEN BEGIN
                    ERROR('Create Allowed Section with Associate Code ' + "Associate Code" + 'in company -' + "Company Name");
                END;
            end;
        }
        field(13; "User Id"; Code[50])
        {
            Editable = false;
            TableRelation = User;
        }
        field(14; "Received From Code"; Code[20])
        {
            Caption = 'Received From Code';
            TableRelation = Vendor."No." WHERE("BBG Status" = FILTER(Provisional | Active),
                                              "BBG Vendor Category" = FILTER("IBA(Associates)" | "CP(Channel Partner)"));

            trigger OnValidate()
            var
                Vendor2: Record Vendor;
                Vendor3: Record Vendor;
            begin
                CLEAR(BondPost);
                IF ("Associate Code" <> '') AND ("Received From Code" <> '') AND ("Associate Code" <> "Received From Code") THEN BEGIN
                    IF NOT BondPost.CheckChain("Associate Code", "Received From Code", "Posting Date") THEN
                        ERROR(Text007, "Received From Code", "Associate Code");
                END;
                //IF ("MM Code" <> '') AND ("Received From Code" <> '') THEN BEGIN
                //  Vendor2.GET("MM Code");
                //  Vendor3.GET("Received From Code");
                //  IF Vendor3."Rank Code" > Vendor2."Rank Code" THEN BEGIN
                //    IF NOT BondPost.CheckChain("MM Code","Received From Code","Posting Date") THEN
                //      ERROR(Text007,"Received From Code","MM Code");
                //  END ELSE BEGIN
                //    IF NOT BondPost.CheckChain("Received From Code","MM Code","Posting Date") THEN
                //      ERROR(Text007,"Received From Code","MM Code");
                //  END;
                //END;
            end;
        }
        field(15; "Investment Type"; Option)
        {
            Caption = 'Investment Type';
            OptionCaption = ' ,RD,FD,MIS';
            OptionMembers = " ",RD,FD,MIS;

            trigger OnValidate()
            begin
                /*IF "Investment Type" <> xRec."Investment Type" THEN BEGIN
                  Duration := 0;
                  VALIDATE("Investment Amount",0);
                  "Associate Code" := '';
                  "Received From Code" := '';
                END;
                SelectScheme;
                 */

            end;
        }
        field(17; "Investment Frequency"; Option)
        {
            Caption = 'Investment Frequency';
            OptionCaption = ' ,Monthly,Quarterly,Half Yearly,Annually';
            OptionMembers = " ",Monthly,Quarterly,"Half Yearly",Annually;

            trigger OnValidate()
            begin
                VALIDATE("Investment Amount", 0);
                "Maturity Amount" := 0;
                "Discount Amount" := 0;
            end;
        }
        field(18; "Investment Amount"; Decimal)
        {
            Caption = 'Investment Amount';
            Editable = true;
            MinValue = 0;

            trigger OnValidate()
            var
                DiscountPercent: Decimal;
                InvestmentMultiple: Decimal;
                DiscountAmount: Decimal;
                Division: Decimal;
                InvInclDisc: Decimal;
                Amt: Decimal;
            begin
            end;
        }
        field(19; "Discount Amount"; Decimal)
        {
            Caption = 'Discount Amount';
            Editable = false;
        }
        field(21; "Return Payment Mode"; Option)
        {
            Caption = 'Return Payment Mode';
            OptionCaption = ' ,Cash,Cheque,D.D.,Banker''s Cheque,P.O.,Cheque by Post,NEFT';
            OptionMembers = " ",Cash,Cheque,"D.D.","Banker's Cheque","P.O.","Cheque by Post",NEFT;
        }
        field(22; "Return Frequency"; Option)
        {
            OptionCaption = ' ,Monthly,Quarterly,Half Yearly,Annually';
            OptionMembers = " ",Monthly,Quarterly,"Half Yearly",Annually;

            trigger OnValidate()
            var
                InterestAmt: Decimal;
            begin
                /*IF "Investment Type" = "Investment Type"::MIS THEN BEGIN
                  SchemeHeader.RESET;
                  SchemeHeader.SETCURRENTKEY("Posting User Code","TO Receive USER Name","TO Receive USER Code","User Responsibility Center");
                  SchemeHeader.SETRANGE("Posting User Code","Bond Type");
                  SchemeHeader.SETRANGE("TO Receive USER Name","Investment Type");
                  SchemeHeader.SETRANGE("TO Receive USER Code",Duration);
                  IF SchemeHeader.FINDLAST THEN BEGIN
                    InterestAmt := "Investment Amount" * SchemeHeader."Interest %" * 0.01 * (Duration / 12);
                    "Return Amount" := ROUND((InterestAmt / (Duration/PostPayment.CalcForInvestmentFreq("Return Frequency"))),1,'<');
                  END ELSE
                    ERROR(Text005);
                END;
                 */

            end;
        }
        field(23; "Return Amount"; Decimal)
        {
            BlankZero = true;
            Caption = 'Return Amount';
        }
        field(26; "Maturity Date"; Date)
        {
            Caption = 'Maturity Date';
            Editable = false;
        }
        field(27; "Maturity Amount"; Decimal)
        {
            Caption = 'Maturity Amount';
            Editable = false;
        }
        field(28; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Released,Printed,Converted,Cancelled';
            OptionMembers = Open,Released,Printed,Converted,Cancelled;
        }
        field(30; "Service Charge Amount"; Decimal)
        {
            Caption = 'Service Charge Amount';
            Editable = false;
        }
        field(31; Duration; Integer)
        {
            BlankZero = true;
            Caption = 'Duration';
        }
        field(32; "Unit No."; Code[20])
        {
            Caption = 'Order No.';
            TableRelation = "Confirmed Order";
        }
        field(34; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                IF Customer.GET("Customer No.") THEN BEGIN
                    "Customer Name" := Customer.Name;
                    //ALLETDK >>
                    Customer.TESTFIELD("Customer Posting Group");
                    Customer.TESTFIELD("Gen. Bus. Posting Group");
                    Customer.TESTFIELD("BBG Date of Birth");
                    Customer.TESTFIELD("BBG Mobile No.");
                    "Member's D.O.B" := Customer."BBG Date of Birth";
                    "Mobile No." := Customer."BBG Mobile No.";
                    "Father / Husband Name" := Customer."BBG Father's/Husband's Name";
                    //ALLETDK <<
                    //Code Added Start 23072025
                    "District Code" := Customer."District Code";
                    "Mandal Code" := Customer."Mandal Code";
                    "Village Code" := Customer."Village Code";
                    //Code Added End 23072025
                    "Bond Posting Group" := Customer."Customer Posting Group";
                END;
            end;
        }
        field(37; "Amount Received"; Decimal)
        {
            CalcFormula = Sum("Unit Payment Entry".Amount WHERE("Document Type" = FILTER(Application),
                                                                 "Document No." = FIELD("Application No.")));
            Caption = 'Amount Received';
            Editable = false;
            FieldClass = FlowField;
        }
        field(38; "Posted Doc No."; Code[20])
        {
            Editable = false;
        }
        field(39; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(40; Category; Option)
        {
            Caption = 'Category';
            OptionCaption = 'A,B';
            OptionMembers = A,B;
        }
        field(41; "Maturity Bonus Amount"; Decimal)
        {
            Editable = false;
        }
        field(42; "Bond Posting Group"; Code[20])
        {
            Editable = false;
            TableRelation = "ID 2 Group"."Item Category Code";
        }
        field(43; "Cheque Cleared"; Boolean)
        {
        }
        field(44; "With Cheque"; Boolean)
        {
        }
        field(45; "Bank Account No."; Text[30])
        {
            Description = 'Bank Account No  in Customer Bank Account';

            trigger OnValidate()
            begin
                "Bank Account No." := UPPERCASE("Bank Account No.");
            end;
        }
        field(46; "Branch Name"; Text[50])
        {
            Description = 'Name 2 in Customer Bank Account';

            trigger OnValidate()
            begin
                "Branch Name" := UPPERCASE("Branch Name");
            end;
        }
        field(50000; "Sub Document Type"; Option)
        {
            Description = 'DDS added to sales and lease documents ALLRE';
            Editable = false;
            OptionCaption = ' ,,,,,,,,,,,,,,Sales,Lease,,,Sale Property,Sale Normal,Lease Property';
            OptionMembers = " ","WO-Project","WO-Normal","Regular PO-Project","Regular PO Normal","Property PO","Direct PO-Normal","GRN for PO","GRN for Aerens","GRN for Packages","GRN for Fabricated Material for WO","JES for WO","GRN-Direct Purchase","Freight Advice",Sales,Lease,"Project Indent","Non-Project Indent","Sale Property","Sale Normal","Lease Property";
        }
        field(50001; "Unit Code"; Code[20])
        {
            TableRelation = "Unit Master"."No." WHERE("Project Code" = FIELD("Shortcut Dimension 1 Code"),
                                                     Status = CONST(Open),
                                                     Freeze = CONST(false),
                                                     "Unit Category" = FIELD(Type),
                                                     "No." = FILTER(<> 'UV*'));

            trigger OnValidate()
            var
                AppCharge: Record "App. Charge Code";
                CompanywiseGLAccount: Record "Company wise G/L Account";
                ProjectwiseDevelopmentCharg: Record "Project wise Development Charg";
                EndDate: Date;
                UnitSetup: Record "Unit Setup";
            begin
                IF "Unit Code" <> '' THEN
                    CheckUnit; //011118
                TESTFIELD(Status, Status::Open);
                TESTFIELD("Shortcut Dimension 1 Code");
                TESTFIELD(Type);
                TESTFIELD("Posting Date");
                TESTFIELD("Document Date");
                IF ItemRec.GET("Unit Code") THEN BEGIN
                    IF NOT ItemRec."Special Units" THEN
                        IF ItemRec."Company Name" <> 'BBG India Developers LLP' THEN
                            ERROR('Unit code should belong to BBG India Developers LLP');

                    ItemRec.TESTFIELD(ItemRec.Status, ItemRec.Status::Open);
                    ItemRec.TESTFIELD(ItemRec."Min. Allotment Amount");
                    ItemRec.TESTFIELD(Approve);
                    "Min. Allotment Amount" := ItemRec."Min. Allotment Amount";
                    "60 feet road" := ItemRec."60 feet Road";
                    "100 feet road" := ItemRec."100 feet Road";


                    //"Investment Amount" := ItemRec."Total Value";
                    "Investment Amount" := CalculateAllotAmt;

                    //ALLEDK 210921 Start
                    v_ResponsibilityCenter.RESET;
                    v_ResponsibilityCenter.GET("Shortcut Dimension 1 Code");
                    IF v_ResponsibilityCenter."Min. Allotment %" <> 0 THEN
                        "Min. Allotment Amount" := ROUND((("Investment Amount" + "Development Charges") * v_ResponsibilityCenter."Min. Allotment %" / 100), 1, '=')
                    ELSE
                        "Min. Allotment Amount" := ItemRec."Min. Allotment Amount";
                    //ALLEDK 210921 END

                    "Payment Plan" := ItemRec."Payment Plan";
                    IF Type <> ItemRec."Unit Category" THEN
                        ERROR('Please check the Unit is Priority OR Normal');

                END ELSE
                    "Min. Allotment Amount" := 0;

                IF UnitMaster.GET("Unit Code") THEN BEGIN
                    //BBG2.0
                    ProjectwiseDevelopmentCharg.RESET;
                    ProjectwiseDevelopmentCharg.SETRANGE("Project Code", "Shortcut Dimension 1 Code");
                    IF ProjectwiseDevelopmentCharg.FINDSET THEN BEGIN
                        REPEAT
                            IF ProjectwiseDevelopmentCharg."End Date" = 0D THEN
                                EndDate := TODAY
                            ELSE
                                EndDate := ProjectwiseDevelopmentCharg."End Date";
                            IF ("Posting Date" > ProjectwiseDevelopmentCharg."Start Date") AND ("Posting Date" <= EndDate) THEN
                                "Development Charges" := ProjectwiseDevelopmentCharg.Amount * UnitMaster."Saleable Area";
                        UNTIL ProjectwiseDevelopmentCharg.NEXT = 0;
                    END;
                    // ELSE
                    // ERROR('Project wise Development charge setup not define for Project-'+"Shortcut Dimension 1 Code");
                    //BBG2.0

                    UnitMaster.TESTFIELD(Status, UnitMaster.Status::Open);
                    UnitMaster.TESTFIELD("Min. Allotment Amount");
                    IF UnitMaster."PLC Applicable" THEN BEGIN
                        "Unit Payment Plan" := '1006';
                        AppCharge.RESET;
                        AppCharge.SETRANGE(Code, "Unit Payment Plan");
                        IF AppCharge.FINDFIRST THEN
                            "Unit Plan Name" := AppCharge.Description;
                    END;
                    "Min. Allotment Amount" := UnitMaster."Min. Allotment Amount";

                    //ALLEDK 210921 Start
                    v_ResponsibilityCenter.RESET;
                    v_ResponsibilityCenter.GET("Shortcut Dimension 1 Code");
                    v_ResponsibilityCenter.TESTFIELD("Min. Allotment %");

                    "Min. Allotment Amount" := ROUND((("Investment Amount" + "Development Charges") * v_ResponsibilityCenter."Min. Allotment %" / 100), 1, '=');
                    //ALLEDK 210921 END

                    "60 feet road" := UnitMaster."60 feet Road";
                    "100 feet road" := UnitMaster."100 feet Road";
                    "Unit Non Usable" := UnitMaster."Non Usable";
                END ELSE BEGIN
                    "Min. Allotment Amount" := 0;
                    "Unit Non Usable" := FALSE;
                END;

                IF "Application Type" = "Application Type"::"Non Trading" THEN BEGIN
                    IF "Unit Code" <> '' THEN BEGIN
                        UnitMasterLLP.RESET;
                        UnitMasterLLP.CHANGECOMPANY("Company Name");
                        UnitMasterLLP.SETRANGE("No.", "Unit Code");
                        UnitMasterLLP.SETRANGE("Project Code", "Shortcut Dimension 1 Code");
                        IF NOT UnitMasterLLP.FINDFIRST THEN
                            ERROR('Unit master missmatch in ' + ' ' + "Company Name");
                    END;
                END;
                // ALLEPG 310812 Start
                IF UnitMaster.GET("Unit Code") THEN BEGIN
                    UnitMaster.Freeze := TRUE;
                    UnitMaster.MODIFY;
                    "Saleable Area" := UnitMaster."Saleable Area";
                END;

                IF "Unit Code" <> xRec."Unit Code" THEN
                    IF UnitMaster.GET(xRec."Unit Code") THEN BEGIN
                        UnitMaster.Freeze := FALSE;
                        UnitMaster.MODIFY;
                    END;
                // ALLEPG 310812 End
                //ALLETDK >>
                IF "Unit Code" = '' THEN BEGIN
                    "Shortcut Dimension 1 Code" := '';
                    VALIDATE("Investment Amount", 0);
                END;
                //ALLETDK <<

                IF UnitMaster.GET("Unit Code") THEN //291221
                    "Min. Allotment Amount" := CalculateMinAllotAmt(UnitMaster, "Posting Date"); //291221
                //IF ItemRec.GET("Unit Code") THEN
                //  VALIDATE("Payment Plan",ItemRec."Payment Plan");

                PaymentPlanDetails.RESET;
                PaymentPlanDetails.SETRANGE("Project Code", "Shortcut Dimension 1 Code");
                PaymentPlanDetails.SETRANGE(PaymentPlanDetails."Payment Plan Code", xRec."Payment Plan");
                PaymentPlanDetails.SETRANGE(PaymentPlanDetails."Document No.", "Application No.");
                IF PaymentPlanDetails.FINDFIRST THEN
                    PaymentPlanDetails.DELETEALL;


                PaymentPlanDetails.RESET;
                PaymentPlanDetails.CHANGECOMPANY("Company Name");
                PaymentPlanDetails.SETRANGE("Project Code", "Shortcut Dimension 1 Code");
                PaymentPlanDetails.SETRANGE(PaymentPlanDetails."Payment Plan Code", "Payment Plan");
                PaymentPlanDetails.SETRANGE(PaymentPlanDetails."Document No.", '');
                PaymentPlanDetails.SETRANGE("Sub Payment Plan", "Unit Payment Plan");
                IF PaymentPlanDetails.FINDSET THEN
                    REPEAT
                        PaymentPlanDetails1.INIT;
                        PaymentPlanDetails1.COPY(PaymentPlanDetails);
                        PaymentPlanDetails1."Document No." := "Application No.";
                        PaymentPlanDetails1."Project Milestone Due Date" :=
                        CALCDATE(PaymentPlanDetails1."Due Date Calculation", "Posting Date"); //ALLETDK221112
                        IF FORMAT(PaymentPlanDetails1."Buffer Days for AutoPlot Vacat") <> '' THEN //ALLEDK 040821
                            PaymentPlanDetails1."Auto Plot Vacate Due Date" := CALCDATE(PaymentPlanDetails1."Buffer Days for AutoPlot Vacat", PaymentPlanDetails1."Project Milestone Due Date")
                        ELSE
                            PaymentPlanDetails1."Auto Plot Vacate Due Date" := PaymentPlanDetails1."Project Milestone Due Date";
                        //ALLEDK 040821
                        PaymentPlanDetails1.INSERT;
                    UNTIL PaymentPlanDetails.NEXT = 0;

                RefreshMilestoneAmount;
            end;
        }
        field(50002; "Total Received Amount"; Decimal)
        {
            CalcFormula = Sum("NewApplication Payment Entry".Amount WHERE("Document Type" = CONST(Application),
                                                                           "Document No." = FIELD("Application No."),
                                                                           Posted = CONST(true),
                                                                           "Cheque Status" = FILTER(<> Bounced)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Father / Husband Name"; Text[50])
        {
        }
        field(50004; "Member's D.O.B"; Date)
        {
        }
        field(50005; "Mobile No."; Text[10])
        {
        }
        field(50008; "E-mail"; Text[80])
        {
        }
        field(50010; "Company Name"; Text[50])
        {
            TableRelation = Company;
        }
        field(50011; "Rank Code"; Code[10])
        {
            TableRelation = "Rank Code Master".Code;
        }
        field(50112; "Application Type"; Option)
        {
            Editable = true;
            OptionCaption = 'Trading,Non Trading';
            OptionMembers = Trading,"Non Trading";

            trigger OnValidate()
            var
                FindCompany: Boolean;
                CompanyWise_1: Record "Company wise G/L Account";
                ResponsibilityCenter_1: Record "Responsibility Center 1";
                RecJob_1: Record Job;
            begin
                TESTFIELD("Shortcut Dimension 1 Code", '');
                TESTFIELD("Unit Code", '');
                TESTFIELD("Application Type", "Application Type"::"Non Trading");
            end;
        }
        field(50201; "Unit Payment Plan"; Code[20])
        {
            TableRelation = "App. Charge Code".Code WHERE("Sub Payment Plan" = const(true));

            trigger OnValidate()
            var
                AppCharge: Record "App. Charge Code";
                Project_RankWisesetup: record "Project wise Appl. Setup";
                ProjectwiseCommSetup: Record "Commission Structr Amount Base";
                RankCodeMaster: Record "Rank Code Master";
                CommStrAmtBase: Record "Commission Structr Amount Base";

            begin
                IF "Unit Payment Plan" <> '' THEN BEGIN

                    RankCodeMaster.RESET;
                    IF RankCodeMaster.GET(Rec."Rank code") then begin
                        IF RankCodeMaster."Applicable New commission Str." then begin
                            CommStrAmtBase.Reset;
                            CommStrAmtBase.SetRange("Project Code", Rec."Shortcut Dimension 1 Code");
                            CommStrAmtBase.SetFilter("Start Date", '<=%1', Rec."Posting Date");
                            CommStrAmtBase.SetFilter("End Date", '>=%1', Rec."Posting Date");
                            CommStrAmtBase.SetRange("Rank Code", Rec."Rank code");
                            IF NOT CommStrAmtBase.FindFirst() then
                                Error('Project wise commission structure not define');
                        end;
                    end;

                    //Code Added Start 01072025
                    Project_RankWisesetup.RESET;
                    Project_RankWisesetup.SetRange("Project Code", "Shortcut Dimension 1 Code");
                    Project_RankWisesetup.SetFilter("Effective From Date", '<=%1', "Posting Date");
                    Project_RankWisesetup.SetFilter("Effective To Date", '>=%1', "Posting Date");
                    Project_RankWisesetup.SetRange("Project Rank Code", "Rank Code");
                    //Project_RankWisesetup.SetFilter("Commission Structure Code", '<>%1', '');
                    IF Project_RankWisesetup.FindFirst() then begin
                        "Rank Code" := Project_RankWisesetup."Project Rank Code";
                        "Project Type" := Project_RankWisesetup."Commission Structure Code";
                        "Travel applicable" := Project_RankWisesetup."Travel Applicable";
                        "Registration Bouns (BSP2)" := Project_RankWisesetup."Registration Bonus (BSP2)";

                        ProjectwiseCommSetup.RESET;
                        ProjectwiseCommSetup.SetRange("Project Code", "Shortcut Dimension 1 Code");
                        ProjectwiseCommSetup.SetFilter("Start Date", '<=%1', "Posting Date");
                        ProjectwiseCommSetup.SetFilter("End Date", '>=%1', "Posting Date");
                        ProjectwiseCommSetup.SetRange("Payment Plan Code", "Unit Payment Plan");
                        ProjectwiseCommSetup.SetFilter("% Per Square", '<>%1', 0);
                        ProjectwiseCommSetup.SetRange("Rank Code", "Rank Code");   //Code added 01072025
                        IF Not ProjectwiseCommSetup.FindFirst() then
                            Error('Project wise commission structure not define.');
                    END;
                    //Code added END 01072025 

                    IF "Unit Code" <> '' THEN
                        IF UnitMaster.GET("Unit Code") THEN BEGIN
                            UnitMaster.TESTFIELD(Status, UnitMaster.Status::Open);
                            UnitMaster.TESTFIELD("Min. Allotment Amount");
                            IF UnitMaster."PLC Applicable" THEN
                                IF "Unit Payment Plan" <> '1006' THEN
                                    ERROR('Please select Unit Payment Plan - 1006');
                        END;
                    AppCharge.RESET;
                    AppCharge.SETRANGE(Code, "Unit Payment Plan");
                    IF AppCharge.FINDFIRST THEN
                        "Unit Plan Name" := AppCharge.Description;
                END ELSE
                    "Unit Plan Name" := '';
            end;
        }
        field(50202; "Unit Plan Name"; Text[50])
        {
            Editable = false;
        }
        field(50203; Address; Text[50])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(50204; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = ToBeClassified;
        }
        field(50205; City; Text[30])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(50236; "Development Charges"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50245; "60 feet road"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50246; "100 feet road"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60010; "Payment Plan"; Code[20])
        {
            TableRelation = "Document Master".Code WHERE("Document Type" = FILTER("Payment Plan"),
                                                          "Project Code" = FIELD("Shortcut Dimension 1 Code"));
        }
        field(60011; "Amount Refunded"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(60012; "Min. Allotment Amount"; Decimal)
        {
            Editable = false;
        }
        field(60013; "Saleable Area"; Decimal)
        {
        }
        field(60014; "Unit Non Usable"; Boolean)
        {
        }
        field(60015; Type; Option)
        {
            OptionCaption = ' ,Normal,Priority';
            OptionMembers = " ",Normal,Priority;
        }
        field(60016; "Branch Code"; Code[10])
        {
            TableRelation = Location.Code WHERE("BBG Branch" = CONST(true));
        }
        field(60017; "Creation Date"; Date)
        {
            Description = 'ALLETDK';
        }
        field(60018; "Creation Time"; Time)
        {
            Description = 'ALLETDK';
        }
        field(60019; "Pass Book No."; Code[20])
        {
            Description = 'ALLETDK';
        }
        field(90035; "Expexted Discount by BBG"; Decimal)
        {
            Description = 'ALLEDK  150313';
        }
        field(90036; "Bill-to Customer Name"; Text[50])
        {
            Description = 'BBG1.00 300313';

            trigger OnValidate()
            begin
                IF "Bill-to Customer Name" <> '' THEN
                    "Customer Name" := "Bill-to Customer Name";
            end;
        }
        field(90037; "Registration Bonus Hold(BSP2)"; Boolean)
        {
            Description = 'BBG1.00 010413';
        }
        field(90059; "Unit Facing"; Option)
        {
            CalcFormula = Lookup("Unit Master".Facing WHERE("No." = FIELD("Unit Code")));
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'NA,East,West,North,South,NorthWest,SouthEast,NorthEast,SouthWest';
            OptionMembers = NA,East,West,North,South,NorthWest,SouthEast,NorthEast,SouthWest;
        }
        field(90060; "Customer State Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = State;
        }
        field(90120; "Loan File"; Boolean)   //251124 New field
        {
            DataClassification = ToBeClassified;

        }
        field(60045; "New Loan File"; Option)     //251124 New field
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Yes,No;
            OptionCaption = ' ,Yes,No';
        }

        field(90121; "Travel applicable"; Boolean)  //New field added 01072025
        {
            Editable = False;

        }
        field(90122; "Registration Bouns (BSP2)"; Boolean)  //New field added 01072025
        {
            Editable = False;

        }
        field(60040; "District Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'District Code';
            DataClassification = ToBeClassified;
            TableRelation = "District Details".Code where("State Code" = field("Customer State Code"));
        }
        field(60041; "Mandal Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'Mandal Code';
            DataClassification = ToBeClassified;
            TableRelation = "Mandal Details".Code where("State Code" = field("Customer State Code"), "District Code" = field("District Code"));
        }
        field(60042; "Village Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'Village Code';
            DataClassification = ToBeClassified;
            TableRelation = "Village Details".Code where("State Code" = field("Customer State Code"), "District Code" = field("District Code"), "Mandal Code" = field("Mandal Code"));
        }
        field(60044; "Aadhar No."; Code[15])  //19082025 Added new field
        {
            Caption = 'Aadhar No.';
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "Application No.")
        {
            Clustered = true;
        }
        key(Key2; Status, "Shortcut Dimension 2 Code", "Application No.", "With Cheque", "Cheque Cleared")
        {
        }
        key(Key3; Status, "Shortcut Dimension 2 Code", "Posting Date", "Received From Code")
        {
        }
        key(Key4; Status, "Shortcut Dimension 2 Code", "Received From Code")
        {
        }
        key(Key5; "Unit No.")
        {
        }
        key(Key6; "Project Type", "Posting Date", Duration, Category, "Unit No.", Status)
        {
        }
        key(Key7; "Unit Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        BondPaymentEntry: Record "Unit Payment Entry";
        PaymentMethod: Record "Payment Method";
        GetDescription: Codeunit GetDescription;
    begin
        //ALLECK 080313 START
        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETRANGE("Role ID", 'A_APPCREATION');
        IF NOT Memberof.FINDFIRST THEN
            ERROR('You do not have permission of role  :A_APPCREATION');
        //ALLECK 080313 End
        CompanywiseGl.RESET;
        CompanywiseGl.SETRANGE(CompanywiseGl."MSC Company", TRUE);
        IF CompanywiseGl.FINDFIRST THEN BEGIN
            IF COMPANYNAME <> CompanywiseGl."Company Code" THEN
                ERROR('Receipt create from Master Company');
        END;

        "Application Type" := "Application Type"::"Non Trading";  //23072017


        IF "Application No." = '' THEN BEGIN
            BondSetup.GET;
            BondSetup.TESTFIELD("Application Nos.");
            //ALLEDK 301112 For Check empty Application
            RecordNotFound := FALSE;
            RecApp.RESET;
            RecApp.SETRANGE("User Id", USERID);
            RecApp.SETFILTER(Status, '<>%1', RecApp.Status::Cancelled);
            IF RecApp.FINDSET THEN BEGIN
                REPEAT
                    IF RecApp."Unit Code" = '' THEN
                        RecordNotFound := TRUE;
                    IF RecApp."Associate Code" = '' THEN
                        RecordNotFound := TRUE;
                    IF RecApp."Customer No." = '' THEN
                        RecordNotFound := TRUE;
                UNTIL RecApp.NEXT = 0;

                IF RecordNotFound THEN
                    ERROR('You have already created Application No.-' + RecApp."Application No." + ' ' + 'kindly use it');
            END;
            IF NOT RecordNotFound THEN BEGIN
                NoSeriesMgt.InitSeries(BondSetup."Application Nos.", xRec."No. Series", 0D, "Application No.", "No. Series");
                "Posting Date" := WORKDATE;
                "Document Date" := WORKDATE;
                // "Document Date" := GetDescription.GetDocomentDate;
                "User Id" := USERID;
                "Creation Date" := TODAY; //ALLETDK
                "Creation Time" := TIME; //ALLETDK

                UserSetup.GET(USERID);
                UserSetup.TESTFIELD("Responsibility Center");
                "Branch Code" := UserSetup."User Branch";
                BondSetup.GET;
                "Investment Type" := "Investment Type"::FD;
            END;
            "Registration Bonus Hold(BSP2)" := TRUE;  //BBG1.00 180413
            "Travel applicable" := True;  //Code added 010725
            "Registration Bouns (BSP2)" := True;  //Code added 010725

        END;

        "Posting Date" := WORKDATE;
        "Document Date" := WORKDATE;
    end;

    trigger OnModify()
    begin
        TESTFIELD(Status, Status::Open);
    end;

    var
        Text001: Label '%1 already exists.';
        Text002: Label 'You cannot rename a %1.';
        NoSeriesMgt: Codeunit NoSeriesManagement;
        BondSetup: Record "Unit Setup";
        UserSetup: Record "User Setup";
        Customer: Record Customer;
        Text003: Label 'Please select correct Investment Amount.';
        BondPost: Codeunit "Unit Post";
        Text004: Label 'Invalid setup for Commission and Bonus for %1 %2, %3 %4, %5 %6.';
        Text005: Label 'No return amount found in the scheme.';
        Text006: Label 'No scheme exist for bond type %1, Investment type %2, and Duration %3.';
        PostPayment: Codeunit PostPayment;
        Text007: Label 'RECEIVED FROM CODE %1 and ASSOCIATE CODE %2 are not from the same chain or RECEIVED FROM CODE is junior than ASSOCIATE CODE!';
        Text008: Label '%1 must be %2 for %3 %4, %5 %6, %7 %8, %9 %10.';
        GetDescription: Codeunit GetDescription;
        OldMileStone: Code[10];
        RemainingAmt: Decimal;
        RemainingBrokerageAmt: Decimal;
        Sno: Code[20];
        RecApp: Record "New Application Booking";
        CNT: Integer;
        MilestoneCodeG: Code[10];
        InLoop: Boolean;
        ApplicationPayEntry: Record "NewApplication Payment Entry";
        Vendor: Record Vendor;
        Text50000: Label 'Associate %1  PAN No. not verified';
        Application: Record "New Application Booking";
        ItemRec: Record "Unit Master";
        RecordNotFound: Boolean;
        ApplicationPaymentEntry: Record "NewApplication Payment Entry";
        OldCust: Record Customer;
        Job: Record Job;
        Vend: Record Vendor;
        UnitMaster: Record "Unit Master";
        Respcenter: Record "Responsibility Center 1";
        PaymentPlanDetails: Record "Payment Plan Details";
        PaymentPlanDetails1: Record "Payment Plan Details";
        CompanywiseGl: Record "Company wise G/L Account";
        //NODLine: Record 13785;//Need to check the code in UAT
        AllowedSection: Record "Allowed Sections";
        RegionwiseVendor: Record "Region wise Vendor";
        VendBuspost: Record Vendor;
        ProjectMilestoneHdr: Record "Project Milestone Header";
        UnitMasterLLP: Record "Unit Master";
        GLSetup: Record "General Ledger Setup";
        TotalValue: Decimal;
        TotalFixed: Decimal;
        ReleaseUnitApp: Codeunit "Release Unit Application";
        Memberof: Record "Access Control";
        v_ResponsibilityCenter: Record "Responsibility Center 1";


    procedure AssistEdit(OldAppl: Record "New Application Booking"): Boolean
    var
        Appl: Record "New Application Booking";
    begin
        Appl := Rec;
        BondSetup.GET;
        BondSetup.TESTFIELD("Application Nos.");
        IF NoSeriesMgt.SelectSeries(BondSetup."Application Nos.", OldAppl."No. Series", Appl."No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries(Appl."Application No.");
            Rec := Appl;
            EXIT(TRUE);
        END;
    end;


    procedure CreateCustomer(BondHolderName: Text[50]): Code[20]
    var
        Customer: Record Customer;
        Template: Record "Config. Template Header";
        TemplateMgt: Codeunit "Config. Template Management";
        RecRef: RecordRef;
        UnitSetup: Record "Unit Setup";
    begin
        BondSetup.GET;
        BondSetup.TESTFIELD("Customer Template Code");

        Template.GET(BondSetup."Customer Template Code");

        Customer.INIT;
        Customer.VALIDATE(Name, BondHolderName);
        Customer."Customer Posting Group" := BondSetup."Customer Posting Group";
        Customer."No. Series" := BondSetup."Customer No Series";
        Customer."BBG Father's/Husband's Name" := "Father / Husband Name";
        Customer."BBG Mobile No." := "Mobile No.";
        Customer."BBG Date of Birth" := "Member's D.O.B";
        Customer."E-Mail" := "E-mail";
        Customer.Address := Address;
        Customer."Address 2" := "Address 2";
        Customer.City := City;
        Customer."GST Customer Type" := Customer."GST Customer Type"::Unregistered;
        UnitSetup.GET;
        IF "Customer No." = '' THEN
            IF "Customer State Code" = '' THEN
                "Customer State Code" := 'TS';
        Customer."State Code" := "Customer State Code";
        //Customer."State Code" := UnitSetup."Default Customer State Code";
        //Code Added Start 23072025
        Customer."District Code" := "District Code";
        Customer."Mandal Code" := "Mandal Code";
        Customer."Village Code" := "Village Code";
        Customer."Country/Region Code" := 'IN'; //Code added 23072025
        //Code Added END 23072025
        Customer.INSERT(TRUE);

        RecRef.GETTABLE(Customer);
        TemplateMgt.UpdateRecord(Template, RecRef);

        EXIT(Customer."No.");
    end;


    procedure CalculateMatuirityAmt(): Decimal
    var
        PmtPerPeriod: Decimal;
        Result: Decimal;
        BonusAmt: Decimal;
        NoOfYear: Integer;
        PaymentPerYear: Decimal;
        Interest: Decimal;
        MatuirityDate: Date;
        IntAmt: Decimal;
        SchemeLine: Record "Document Type Approval";
    begin
        //Ayan
        "Maturity Bonus Amount" := 0;
        IF "Investment Frequency" = "Investment Frequency"::" " THEN
            PaymentPerYear := "Investment Amount" + "Discount Amount"
        ELSE IF "Investment Frequency" = "Investment Frequency"::Monthly THEN
            PaymentPerYear := ("Investment Amount" + "Discount Amount") * 12
        ELSE IF "Investment Frequency" = "Investment Frequency"::Quarterly THEN
            PaymentPerYear := ("Investment Amount" + "Discount Amount") * 4
        ELSE IF "Investment Frequency" = "Investment Frequency"::"Half Yearly" THEN
            PaymentPerYear := ("Investment Amount" + "Discount Amount") * 2
        ELSE IF "Investment Frequency" = "Investment Frequency"::Annually THEN
            PaymentPerYear := ("Investment Amount" + "Discount Amount");

        NoOfYear := Duration DIV 12;
        //IF NOT SchemeHeader.GET("Scheme Code","Scheme Version No.") THEN
        //EXIT(0);
        //Interest := SchemeHeader."Interest %";

        IF ((PaymentPerYear > 0) OR ("Investment Amount" > 0)) AND (NoOfYear > 0) AND (Interest > 0) THEN BEGIN
            IF "Investment Type" = "Investment Type"::RD THEN
                Result := PaymentPerYear * (1 + Interest * 0.01) * ((POWER((1 + (Interest * 0.01)), NoOfYear)) - 1) / (Interest * 0.01);


            IF ("Investment Type" = "Investment Type"::FD) //AND (SchemeHeader."Interest Type"=SchemeHeader."Interest Type"::"1")
            THEN BEGIN
                Result := (("Investment Amount" + "Discount Amount") * POWER(1 + (Interest * 0.01), NoOfYear));
                IF ("Project Type" = 'ORCHARD') AND (Duration = 75) THEN
                    IF ("Scheme Version No." = 10) OR ("Scheme Version No." = 12) THEN
                        Result := (("Investment Amount" + "Discount Amount") * 2);
            END;

            IF ("Investment Type" = "Investment Type"::MIS)
            //AND (SchemeHeader."Interest Type"=SchemeHeader."Interest Type"::"0")
            THEN BEGIN
                Result := "Investment Amount" + "Discount Amount";
                IntAmt := 0;
                IntAmt := (("Investment Amount" + "Discount Amount") * (Interest * 0.01) * NoOfYear);
                //IF SchemeHeader."Bonus Per" > 0 THEN
                //"Maturity Bonus Amount" := ROUND(((SchemeHeader."Bonus Amount"/SchemeHeader."Bonus Per") * Result),1);
            END;

            IF ("Investment Type" = "Investment Type"::FD)
            // AND (SchemeHeader."Interest Type"=SchemeHeader."Interest Type"::"0")
            THEN BEGIN
                "Maturity Date" := CALCDATE('-1D', "Maturity Date");
                Result := (("Investment Amount" + "Discount Amount") + (("Investment Amount" + "Discount Amount") * Interest * 0.01 * NoOfYear)
            );
                /*
                SchemeLine.SETRANGE("Document Type","Scheme Code");
                SchemeLine.SETRANGE("Sub Document Type","Scheme Version No.");
                SchemeLine.SETRANGE("Line No","Investment Amount" + "Discount Amount");
                IF SchemeLine.FINDFIRST THEN
                  IF SchemeLine."Authorized Time" > 0 THEN BEGIN
                    "Maturity Bonus Amount" := SchemeLine."Authorized Time";
                    Result := Result;
                END;
                */
            END;
            Result := ROUND(Result, 1);

        END;
        /*
        IF ((PaymentPerYear> 0) OR (("Investment Amount" + "Discount Amount") > 0 )) AND (NoOfYear > 0)  AND (Interest = 0) THEN BEGIN
          IF ("Investment Type" = "Investment Type"::RD) THEN BEGIN
            SchemeLine.RESET;
            SchemeLine.SETRANGE(SchemeLine."Document Type","Scheme Code");
            SchemeLine.SETRANGE(SchemeLine."Sub Document Type","Scheme Version No.");
            IF "Investment Frequency" = "Investment Frequency"::Monthly THEN
              SchemeLine.SETRANGE(SchemeLine."Alternate Approvar ID","Investment Amount" + "Discount Amount");
            IF "Investment Frequency" = "Investment Frequency"::Quarterly THEN
              SchemeLine.SETRANGE(SchemeLine."Min Amount Limit","Investment Amount" + "Discount Amount");
            IF "Investment Frequency" = "Investment Frequency"::"Half Yearly" THEN
              SchemeLine.SETRANGE(SchemeLine."Max Amount Limit","Investment Amount" + "Discount Amount");
            IF "Investment Frequency" = "Investment Frequency"::Annually THEN
              SchemeLine.SETRANGE(SchemeLine."Document No","Investment Amount" + "Discount Amount");
            IF SchemeLine.FINDFIRST THEN BEGIN
              "Return Amount" := SchemeLine."Authorized Date";
              "Maturity Bonus Amount" := SchemeLine."Authorized Time";
              Result:="Return Amount" + "Maturity Bonus Amount";
            END ELSE
              ERROR('Maturity Amount Not Available');
          END;
        
          IF "Investment Type" = "Investment Type"::MIS THEN BEGIN
            IntAmt := 0;
            SchemeLine.RESET;
            SchemeLine.SETRANGE(SchemeLine."Document Type","Scheme Code");
            SchemeLine.SETRANGE(SchemeLine."Sub Document Type","Scheme Version No.");
            SchemeLine.SETRANGE(SchemeLine."Line No","Investment Amount" + "Discount Amount");
            IF SchemeLine.FINDFIRST THEN BEGIN
              IF "Return Frequency" = "Investment Frequency"::Monthly THEN
                IntAmt := SchemeLine."Alternate Approvar ID";
              IF "Return Frequency" = "Investment Frequency"::Quarterly THEN
                IntAmt := SchemeLine."Min Amount Limit";
              IF "Return Frequency" = "Investment Frequency"::"Half Yearly" THEN
                IntAmt := SchemeLine."Max Amount Limit";
              IF "Return Frequency" = "Investment Frequency"::Annually THEN
                IntAmt := SchemeLine."Document No";
              "Return Amount" := SchemeLine."Authorized Date";
              "Maturity Bonus Amount" := SchemeLine."Authorized Time";
               Result:="Return Amount";
            END ELSE
              ERROR('Maturity Amount Not Available');
          END;
        
          IF "Investment Type" = "Investment Type"::FD THEN BEGIN
            SchemeLine.RESET;
            SchemeLine.SETRANGE(SchemeLine."Document Type","Scheme Code");
            SchemeLine.SETRANGE(SchemeLine."Sub Document Type","Scheme Version No.");
            SchemeLine.SETRANGE(SchemeLine."Line No","Investment Amount" + "Discount Amount");
            IF SchemeLine.FINDFIRST THEN BEGIN
              "Return Amount" := SchemeLine."Authorized Date";
              "Maturity Bonus Amount" := SchemeLine."Authorized Time";
              Result:="Return Amount";
            END ELSE
              ERROR('Maturity Amount Not Available');
            IF ("Bond Type" = 'TEAK')THEN BEGIN
              SchemeLine.RESET;
              SchemeLine.SETRANGE(SchemeLine."Document Type","Scheme Code");
              SchemeLine.SETRANGE(SchemeLine."Sub Document Type","Scheme Version No.");
              SchemeLine.SETRANGE(SchemeLine."Line No","Investment Amount" + "Discount Amount");
              SchemeLine.SETRANGE(SchemeLine.Status,(Duration DIV 12));
              IF SchemeLine.FINDFIRST THEN BEGIN
                "Return Amount" := 0;
                "Maturity Bonus Amount" := SchemeLine."Authorized Time";
                Result := SchemeLine."Authorized Date";
              END ELSE
                ERROR('Bonus Amount and Return Amount not available');
            END;
          END;
          Result:=ROUND(Result,1);
        END;
        EXIT(Result);
         */

    end;


    procedure CreateCustomerBankAccount(ApplicationNo: Code[20]; CustomerNo: Code[20]; BankAccountNo: Text[30]; BranchName: Text[50])
    var
        CustomerBankAccount: Record "Customer Bank Account";
    begin
        CustomerBankAccount.INIT;
        IF NOT CustomerBankAccount.GET(CustomerNo, ApplicationNo) THEN BEGIN
            CustomerBankAccount."Customer No." := CustomerNo;
            CustomerBankAccount.Code := ApplicationNo;
            CustomerBankAccount.INSERT;
        END;
        CustomerBankAccount."Name 2" := BranchName;
        CustomerBankAccount."Bank Account No." := BankAccountNo;
        CustomerBankAccount.MODIFY;
    end;


    procedure RefreshMilestoneAmount()
    var
        totalamount: Decimal;
        PaymentDetails: Record "Payment Plan Details";
    begin
        totalamount := 0;
        PaymentDetails.RESET;
        PaymentDetails.SETFILTER("Project Code", "Shortcut Dimension 1 Code");
        PaymentDetails.SETFILTER("Document No.", "Application No.");
        IF PaymentDetails.FINDFIRST THEN
            REPEAT
                IF PaymentDetails."Percentage Cum" > 0 THEN BEGIN
                    IF PaymentDetails."Percentage Cum" = 100 THEN
                        PaymentDetails."Total Charge Amount" := ("Investment Amount" - totalamount)
                    ELSE
                        PaymentDetails."Total Charge Amount" := ("Investment Amount" * PaymentDetails."Percentage Cum" / 100) - totalamount;
                END;
                IF PaymentDetails."Fixed Amount" <> 0 THEN BEGIN
                    PaymentDetails."Total Charge Amount" := PaymentDetails."Fixed Amount";
                END;

                totalamount := PaymentDetails."Total Charge Amount" + totalamount;
                //"Total Charge Amount" := AppCharRec."Net Amount";
                PaymentDetails.VALIDATE("Total Charge Amount");
                PaymentDetails.MODIFY;
            UNTIL PaymentDetails.NEXT = 0;
    end;


    procedure CalculateMinAllotAmt(UnitMstr: Record "Unit Master"; PostDate: Date): Decimal
    var
        MembershipFee: Decimal;
        CalDocMaster: Record "Document Master";
        AppCharge: Record "App. Charge Code";
        UnitMaster_1: Record "Unit Master";
        MinAllotmentsAmount: Integer;
        ProjectwiseDevelopmentCharg: Record "Project wise Development Charg";
        EndDate: Date;
        vUnitSetup: Record "Unit Setup";
        vNewApplicationBooking: Record "New Application Booking";
        vNewConfirmedOrder: Record "New Confirmed Order";
        Docmaster: Record "Document Master";
    begin

        IF PostDate >= vUnitSetup."Start Process Date for A-B-C" THEN BEGIN
            TotalValue := TotalPlotCostCalculation(UnitMstr, '1006');
            //Code commented 040424

            IF UnitMaster.GET("Unit Code") THEN BEGIN
                EndDate := 0D;
                ProjectwiseDevelopmentCharg.RESET;
                ProjectwiseDevelopmentCharg.SETRANGE("Project Code", "Shortcut Dimension 1 Code");
                IF ProjectwiseDevelopmentCharg.FINDSET THEN BEGIN
                    REPEAT
                        IF ProjectwiseDevelopmentCharg."End Date" = 0D THEN
                            EndDate := TODAY
                        ELSE
                            EndDate := ProjectwiseDevelopmentCharg."End Date";
                        IF ("Posting Date" > ProjectwiseDevelopmentCharg."Start Date") AND ("Posting Date" <= EndDate) THEN
                            "Development Charges" := ProjectwiseDevelopmentCharg.Amount * UnitMaster."Saleable Area";
                    UNTIL ProjectwiseDevelopmentCharg.NEXT = 0;
                END;

                MinAllotmentsAmount := 0;
                v_ResponsibilityCenter.RESET;
                v_ResponsibilityCenter.GET("Shortcut Dimension 1 Code");
                IF v_ResponsibilityCenter."Min. Allotment %" <> 0 THEN
                    MinAllotmentsAmount := ROUND(((TotalValue + "Development Charges") * v_ResponsibilityCenter."Min. Allotment %" / 100), 1, '=')
                ELSE
                    MinAllotmentsAmount := UnitMaster."Min. Allotment Amount";
            END;
        END ELSE BEGIN
            MinAllotmentsAmount := UnitMstr."Min. Allotment Amount";
        END;

        MinAllotmentsAmount := ROUND(MinAllotmentsAmount, 1, '=');
        EXIT(MinAllotmentsAmount);
    end;


    procedure CalculateAllotAmt(): Decimal
    var
        CalDocMaster: Record "Document Master";
        AppCharge: Record "App. Charge Code";
        UnitMaster_1: Record "Unit Master";
        Docmaster: Record "Document Master";
    begin
        TotalValue := 0;

        UnitMaster_1.RESET;
        UnitMaster_1.CHANGECOMPANY("Company Name");
        UnitMaster_1.SETRANGE("No.", "Unit Code");
        UnitMaster_1.SETRANGE("Project Code", "Shortcut Dimension 1 Code");
        IF UnitMaster_1.FINDFIRST THEN BEGIN
            TotalValue := TotalPlotCostCalculation(UnitMaster_1, "Unit Payment Plan");
        END;

        EXIT(TotalValue);

        /*
        TotalFixed := 0;
        Job.RESET;
        IF Job.GET("Shortcut Dimension 1 Code") THEN;
        
        CalDocMaster.RESET;
        CalDocMaster.CHANGECOMPANY("Company Name");
        CalDocMaster.SETCURRENTKEY("Document Type","Project Code",Code,"Sale/Lease","Unit Code","App. Charge Code");
        CalDocMaster.SETRANGE("Project Code","Shortcut Dimension 1 Code");
        CalDocMaster.SETRANGE("Unit Code","Unit Code");
        IF CalDocMaster.FINDFIRST THEN
          REPEAT
            AppCharge.RESET;
            AppCharge.SETRANGE(Code,CalDocMaster."App. Charge Code");
            AppCharge.SETRANGE("Sub Payment Plan",TRUE);
            IF NOT AppCharge.FINDFIRST THEN BEGIN
              //040424
                IF CalDocMaster.Code <> 'BSP4' THEN BEGIN
                  TotalValue := TotalValue + CalDocMaster."Rate/Sq. Yd";
                  TotalFixed := TotalFixed + CalDocMaster."Fixed Price";
                END ELSE BEGIN
                  IF (Job."BSP4 Plan wise Applicable") AND ("Posting Date" < Job."BSP4 Plan wise St. Date") THEN BEGIN
                    Docmaster.RESET;
                    Docmaster.SETRANGE(Docmaster."Document Type",Docmaster."Document Type"::Charge);
                    Docmaster.SETFILTER(Docmaster."Project Code","Shortcut Dimension 1 Code");
                    IF "Sub Document Type"="Sub Document Type"::Lease THEN
                      Docmaster.SETRANGE(Docmaster."Sale/Lease",Docmaster."Sale/Lease"::Lease);
                    IF "Sub Document Type"="Sub Document Type"::Sales THEN
                      Docmaster.SETRANGE(Docmaster."Sale/Lease",Docmaster."Sale/Lease"::Sale);
                    Docmaster.SETRANGE(Docmaster."Unit Code",'');
                    Docmaster.SETRANGE(Code,'BSP4');
                    Docmaster.SETFILTER("Rate/Sq. Yd",'<>%1',0);
                    IF Docmaster.FINDFIRST THEN BEGIN
                      TotalValue := TotalValue + Docmaster."Rate/Sq. Yd";
                      TotalFixed := TotalFixed + Docmaster."Fixed Price";
                    END;
                  END;
                  END;
            END;
          UNTIL CalDocMaster.NEXT = 0;
        
        CalDocMaster.RESET;
        CalDocMaster.CHANGECOMPANY("Company Name");
        CalDocMaster.SETCURRENTKEY("Document Type","Project Code",Code,"Sale/Lease","Unit Code","App. Charge Code");
        CalDocMaster.SETRANGE("Project Code","Shortcut Dimension 1 Code");
        CalDocMaster.SETRANGE("Unit Code",'');
        CalDocMaster.SETRANGE("App. Charge Code","Unit Payment Plan");
        IF CalDocMaster.FINDFIRST THEN BEGIN
          IF (Job."BSP4 Plan wise Applicable") AND ("Posting Date" >= Job."BSP4 Plan wise St. Date") THEN
            TotalValue := TotalValue + CalDocMaster."Rate/Sq. Yd" + CalDocMaster."BSP4 Plan wise Rate / Sq. Yd"  //040424 added this code CalDocMaster."BSP4 Plan wise Rate / Sq. Yd"
          ELSE
            TotalValue := TotalValue + CalDocMaster."Rate/Sq. Yd";
        END;
        
        
        //040424 Code not required
        {
        CalDocMaster.RESET;
        CalDocMaster.CHANGECOMPANY("Company Name");
        CalDocMaster.SETCURRENTKEY("Document Type","Project Code",Code,"Sale/Lease","Unit Code","App. Charge Code");
        CalDocMaster.SETRANGE("Project Code","Shortcut Dimension 1 Code");
        CalDocMaster.SETRANGE("Unit Code",'');
        CalDocMaster.SETRANGE("Sub Sub Payment Plan Code","Unit Payment Plan");
        IF CalDocMaster.FINDFIRST THEN
          REPEAT
            TotalValue := TotalValue + CalDocMaster."Rate/Sq. Yd";
          UNTIL CalDocMaster.NEXT = 0;
          }
        //040424 Code not required
        
        
        UnitMaster_1.RESET;
        UnitMaster_1.CHANGECOMPANY("Company Name");
        UnitMaster_1.SETRANGE("No.","Unit Code");
        UnitMaster_1.SETRANGE("Project Code","Shortcut Dimension 1 Code");
        IF UnitMaster_1.FINDFIRST THEN BEGIN
          TotalValue := TotalFixed + (TotalValue * UnitMaster_1."Saleable Area");
        END;
        
        TotalValue := ROUND(TotalValue,1,'=');
        
        
        EXIT(TotalValue);
        */

    end;


    procedure CheckUnit()
    var
        NABooking: Record "New Application Booking";
        NCOrder: Record "New Confirmed Order";
    begin
        NABooking.RESET;
        NABooking.SETCURRENTKEY("Unit Code");
        NABooking.SETRANGE("Unit Code", "Unit Code");
        NABooking.SETFILTER("Application No.", '<>%1', "Application No.");
        IF NABooking.FINDFIRST THEN
            ERROR('Unit code already exists on this application No.-' + FORMAT(NABooking."Application No."));


        NCOrder.RESET;
        NCOrder.SETCURRENTKEY("Unit Code");
        NCOrder.SETRANGE("Unit Code", "Unit Code");
        IF NCOrder.FINDFIRST THEN
            ERROR('Unit code already exists on this application No.-' + FORMAT(NCOrder."No."));
    end;

    local procedure "---------------------060424-------------"()
    begin
    end;

    local procedure TotalPlotCostCalculation(U_msters: Record "Unit Master"; PmtPlanCode: Code[10]): Decimal
    var
        MembershipFee: Decimal;
        CalDocMaster: Record "Document Master";
        AppCharge: Record "App. Charge Code";
        UnitMaster_1: Record "Unit Master";
        MinAllotmentsAmount: Integer;
        ProjectwiseDevelopmentCharg: Record "Project wise Development Charg";
        EndDate: Date;
        vUnitSetup: Record "Unit Setup";
        vNewApplicationBooking: Record "New Application Booking";
        vNewConfirmedOrder: Record "New Confirmed Order";
        Docmaster: Record "Document Master";

    begin
        vUnitSetup.RESET;
        vUnitSetup.GET;
        Job.RESET;
        IF Job.GET("Shortcut Dimension 1 Code") THEN;
        TotalValue := 0;
        TotalFixed := 0;
        CalDocMaster.RESET;
        CalDocMaster.CHANGECOMPANY("Company Name");
        CalDocMaster.SETCURRENTKEY("Document Type", "Project Code", Code, "Sale/Lease", "Unit Code", "App. Charge Code");
        CalDocMaster.SETRANGE("Project Code", "Shortcut Dimension 1 Code");
        CalDocMaster.SETRANGE("Unit Code", "Unit Code");
        //Code Added Start 01072025
        //IF NOT Rec."Registration Bouns (BSP2)" THEN  Code comemnted 10072025
        //  CalDocMaster.SetFilter(Code, '<>%1', 'BSP2');  Code comemnted 10072025
        //Code Added End 01072025


        IF CalDocMaster.FINDFIRST THEN
            REPEAT
                AppCharge.RESET;
                AppCharge.SETRANGE(Code, CalDocMaster."App. Charge Code");
                AppCharge.SETRANGE("Sub Payment Plan", TRUE);
                IF NOT AppCharge.FINDFIRST THEN BEGIN
                    IF CalDocMaster.Code <> 'BSP4' THEN BEGIN
                        TotalValue := TotalValue + CalDocMaster."Rate/Sq. Yd";
                        TotalFixed := TotalFixed + CalDocMaster."Fixed Price";
                    END ELSE BEGIN
                        IF (Job."BSP4 Plan wise Applicable") AND ("Posting Date" < Job."BSP4 Plan wise St. Date") THEN BEGIN
                            Docmaster.RESET;
                            Docmaster.SETRANGE(Docmaster."Document Type", Docmaster."Document Type"::Charge);
                            Docmaster.SETFILTER(Docmaster."Project Code", "Shortcut Dimension 1 Code");
                            IF "Sub Document Type" = "Sub Document Type"::Lease THEN
                                Docmaster.SETRANGE(Docmaster."Sale/Lease", Docmaster."Sale/Lease"::Lease);
                            IF "Sub Document Type" = "Sub Document Type"::Sales THEN
                                Docmaster.SETRANGE(Docmaster."Sale/Lease", Docmaster."Sale/Lease"::Sale);
                            Docmaster.SETRANGE(Docmaster."Unit Code", '');
                            Docmaster.SETRANGE(Code, 'BSP4');
                            Docmaster.SETFILTER("Rate/Sq. Yd", '<>%1', 0);
                            IF Docmaster.FINDFIRST THEN BEGIN
                                TotalValue := TotalValue + Docmaster."Rate/Sq. Yd";
                                TotalFixed := TotalFixed + Docmaster."Fixed Price";
                            END;

                        END ELSE BEGIN
                            IF NOT Job."BSP4 Plan wise Applicable" THEN BEGIN
                                Docmaster.RESET;
                                Docmaster.SETRANGE(Docmaster."Document Type", Docmaster."Document Type"::Charge);
                                Docmaster.SETFILTER(Docmaster."Project Code", "Shortcut Dimension 1 Code");
                                IF "Sub Document Type" = "Sub Document Type"::Lease THEN
                                    Docmaster.SETRANGE(Docmaster."Sale/Lease", Docmaster."Sale/Lease"::Lease);
                                IF "Sub Document Type" = "Sub Document Type"::Sales THEN
                                    Docmaster.SETRANGE(Docmaster."Sale/Lease", Docmaster."Sale/Lease"::Sale);
                                Docmaster.SETRANGE(Docmaster."Unit Code", '');
                                Docmaster.SETRANGE(Code, 'BSP4');
                                Docmaster.SETFILTER("Rate/Sq. Yd", '<>%1', 0);
                                IF Docmaster.FINDFIRST THEN BEGIN
                                    TotalValue := TotalValue + Docmaster."Rate/Sq. Yd";
                                    TotalFixed := TotalFixed + Docmaster."Fixed Price";
                                END;
                            END;
                        END;
                    END;
                    //040424
                END;
            UNTIL CalDocMaster.NEXT = 0;

        CalDocMaster.RESET;
        CalDocMaster.CHANGECOMPANY("Company Name");
        CalDocMaster.SETCURRENTKEY("Document Type", "Project Code", Code, "Sale/Lease", "Unit Code", "App. Charge Code");
        CalDocMaster.SETRANGE("Project Code", "Shortcut Dimension 1 Code");
        CalDocMaster.SETRANGE("Unit Code", '');
        CalDocMaster.SETRANGE("App. Charge Code", PmtPlanCode);

        IF CalDocMaster.FINDFIRST THEN BEGIN
            IF (Job."BSP4 Plan wise Applicable") AND ("Posting Date" >= Job."BSP4 Plan wise St. Date") THEN
                TotalValue := TotalValue + CalDocMaster."Rate/Sq. Yd" + CalDocMaster."BSP4 Plan wise Rate / Sq. Yd"
            ELSE
                TotalValue := TotalValue + CalDocMaster."Rate/Sq. Yd";
        END;

        //040424 code not required
        /*
          CalDocMaster.RESET;
          CalDocMaster.CHANGECOMPANY("Company Name");
          CalDocMaster.SETCURRENTKEY("Document Type","Project Code",Code,"Sale/Lease","Unit Code","App. Charge Code");
          CalDocMaster.SETRANGE("Project Code","Shortcut Dimension 1 Code");
          CalDocMaster.SETRANGE("Unit Code",'');
          CalDocMaster.SETRANGE("Sub Sub Payment Plan Code",'1006');
          IF CalDocMaster.FINDFIRST THEN
            REPEAT
              TotalValue := TotalValue + CalDocMaster."Rate/Sq. Yd";
            UNTIL CalDocMaster.NEXT = 0;
            */
        //040424 code not required


        UnitMaster_1.RESET;
        UnitMaster_1.CHANGECOMPANY("Company Name");
        UnitMaster_1.SETRANGE("No.", "Unit Code");
        UnitMaster_1.SETRANGE("Project Code", "Shortcut Dimension 1 Code");
        IF UnitMaster_1.FINDFIRST THEN BEGIN
            TotalValue := TotalFixed + (TotalValue * UnitMaster_1."Saleable Area");
        END;

        TotalValue := ROUND(TotalValue, 1, '=');
        EXIT(TotalValue);

    end;
}

