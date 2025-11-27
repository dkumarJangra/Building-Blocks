table 97761 "Responsibility Center 1"
{
    //   dds- code added to have dim name
    //  //ALLEAB005 Field Added Job Code with Table Relation to Job Table
    //  //ALLEAB014 Added New field for block
    // RAHEE1.00 Added new field

    Caption = 'Responsibility Center';
    DrillDownPageID = "Responsibility Center ListNew";
    LookupPageID = "Responsibility Center ListNew";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(3; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(4; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(5; City; Text[30])
        {
            Caption = 'City';

            trigger OnLookup()
            begin
                PostCode.LookUpCity(City, "Post Code", TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidateCity(City,"Post Code"); // ALLE MM
            end;
        }
        field(6; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookUpPostCode(City, "Post Code", TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidatePostCode(City,"Post Code"); // ALLE MM
            end;
        }
        field(7; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(8; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(9; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
        }
        field(10; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(11; Contact; Text[50])
        {
            Caption = 'Contact';
        }
        field(12; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
                //dds - added to have dim name
                GLSetup.GET;
                DimValue.RESET;
                DimValue.SETRANGE(DimValue."Dimension Code", GLSetup."Global Dimension 1 Code");
                DimValue.SETRANGE(DimValue.Code, "Global Dimension 1 Code");
                IF DimValue.FIND('-') THEN BEGIN
                    "Region Name" := DimValue.Name;
                END;
            end;
        }
        field(13; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(14; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));

            trigger OnValidate()
            begin
                //dds - added to have dim name
                LocValue.RESET;
                LocValue.SETRANGE(Code, "Location Code");
                IF LocValue.FIND('-') THEN BEGIN
                    "Location Name" := LocValue.Name;
                END;
            end;
        }
        field(15; County; Text[30])
        {
            Caption = 'County';
        }
        field(102; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(103; "Home Page"; Text[90])
        {
            Caption = 'Home Page';
            ExtendedDatatype = URL;
        }
        field(5900; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(5901; "Contract Gain/Loss Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Contract Gain/Loss Entry".Amount WHERE("Responsibility Center" = FIELD(Code),
                                                                       "Change Date" = FIELD("Date Filter")));
            Caption = 'Contract Gain/Loss Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50000; "Region Name"; Text[50])
        {
            Description = 'dds - region dim code name';
            Editable = false;
        }
        field(50001; "Location Name"; Text[50])
        {
            Description = 'dds - location code name';
            Editable = false;
        }
        field(50002; "Job Code"; Code[20])
        {
            Description = 'ALLEAB005';
            TableRelation = Job;
        }
        field(50003; Blocked; Boolean)
        {
            Description = 'ALLEAB014';
        }
        field(50005; "Subcon/Site Location"; Code[20])
        {
            Description = 'RAHEE1.00';
            TableRelation = Location.Code WHERE("BBG Use As Subcon/Site Location" = CONST(true));
        }
        field(50006; Division; Boolean)
        {
            Description = 'ALLEDK 231211';
            Editable = true;
        }
        field(50007; Branch; Code[20])
        {
            Description = 'ALLEAT 181012';
            TableRelation = Location.Code WHERE("BBG Branch" = FILTER(true));

            trigger OnValidate()
            begin
                IF BranchName.GET(Branch) THEN
                    "Branch Name" := BranchName.Name
                ELSE
                    "Branch Name" := '';
            end;
        }
        field(50008; "Incentive Code"; Code[20])
        {
            Description = 'ALLEPG 061112';
            TableRelation = "Incentive Header";
        }
        field(50009; "Branch Name"; Text[50])
        {
            Description = 'AlleAD:BBG01.00:191112';
        }
        field(50010; Published; Boolean)
        {
            Description = 'BBG1.00 26/03/13';
        }
        field(50011; "Sequence of Project"; Code[10])
        {
        }
        field(50012; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(50013; "Full Name"; Text[80])
        {
        }
        field(50014; "Active Projects"; Boolean)
        {

            trigger OnValidate()
            var
                RespCenter: Record "Responsibility Center 1";
            begin
                CompanyWise.RESET;
                CompanyWise.SETRANGE("MSC Company", TRUE);
                IF CompanyWise.FINDFIRST THEN BEGIN
                    IF CompanyWise."Company Code" <> COMPANYNAME THEN BEGIN
                        RespCenter.RESET;
                        RespCenter.CHANGECOMPANY(CompanyWise."Company Code");
                        RespCenter.SETRANGE(Code, Code);
                        IF RespCenter.FINDFIRST THEN BEGIN
                            RespCenter."Active Projects" := "Active Projects";
                            RespCenter.MODIFY;
                        END;
                    END;
                END;
            end;
        }
        field(50016; "Company Name"; Text[30])
        {
            TableRelation = Company;
        }
        field(50017; "Fields Not Show on Receipt"; Boolean)
        {
        }
        field(50018; "Publish Plot Cost"; Boolean)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Company Name");
                CompanyWise.RESET;
                CompanyWise.SETRANGE(CompanyWise."MSC Company", TRUE);
                IF CompanyWise.FINDFIRST THEN BEGIN
                    IF CompanyWise."Company Code" = COMPANYNAME THEN BEGIN
                        NewConfOrder.RESET;
                        NewConfOrder.CHANGECOMPANY("Company Name");
                        NewConfOrder.SETCURRENTKEY(NewConfOrder."Shortcut Dimension 1 Code");
                        NewConfOrder.SETRANGE("Shortcut Dimension 1 Code", Code);
                        NewConfOrder.SETFILTER("Unit Code", '<>%1', '');
                        IF NewConfOrder.FINDSET THEN
                            REPEAT
                                IF "Publish Plot Cost" THEN BEGIN
                                    UnitMaster.RESET;
                                    UnitMaster.SETRANGE("Project Code", Code);
                                    UnitMaster.SETRANGE("No.", NewConfOrder."Unit Code");
                                    IF UnitMaster.FINDFIRST THEN BEGIN
                                        UnitMaster."Plot Cost" := UnitMaster."Total Value";
                                        UnitMaster.MODIFY;
                                    END;
                                END ELSE BEGIN
                                    UnitMaster.RESET;
                                    UnitMaster.SETRANGE("Project Code", Code);
                                    UnitMaster.SETRANGE("No.", NewConfOrder."Unit Code");
                                    IF UnitMaster.FINDFIRST THEN BEGIN
                                        UnitMaster."Plot Cost" := 0;
                                        UnitMaster.MODIFY;
                                    END;
                                END;
                            UNTIL NewConfOrder.NEXT = 0;
                    END ELSE
                        ERROR('This process will be done from MScompany');
                END;
                MESSAGE('%1', 'Records Updated');
            end;
        }
        field(50019; "Publish CustomerName"; Boolean)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Company Name");
                CompanyWise.RESET;
                CompanyWise.SETRANGE(CompanyWise."MSC Company", TRUE);
                IF CompanyWise.FINDFIRST THEN BEGIN
                    IF CompanyWise."Company Code" = COMPANYNAME THEN BEGIN
                        NewConfOrder.RESET;
                        NewConfOrder.CHANGECOMPANY("Company Name");
                        NewConfOrder.SETCURRENTKEY(NewConfOrder."Shortcut Dimension 1 Code");
                        NewConfOrder.SETRANGE("Shortcut Dimension 1 Code", Code);
                        NewConfOrder.SETFILTER("Unit Code", '<>%1', '');
                        NewConfOrder.SETRANGE(Status, NewConfOrder.Status::Registered);
                        IF NewConfOrder.FINDSET THEN
                            REPEAT
                                IF "Publish CustomerName" THEN BEGIN
                                    IF NewConfOrder."Registration In Favour Of" <> '' THEN BEGIN
                                        UnitMaster.RESET;
                                        UnitMaster.SETRANGE("Project Code", Code);
                                        UnitMaster.SETRANGE("No.", NewConfOrder."Unit Code");
                                        IF UnitMaster.FINDFIRST THEN BEGIN
                                            UnitMaster."Customer Name" := NewConfOrder."Registration In Favour Of";
                                            UnitMaster."Customer Code" := NewConfOrder."Customer No.";
                                            UnitMaster."Unit Registered" := TRUE;
                                            UnitMaster.MODIFY;
                                        END;
                                    END;
                                END ELSE BEGIN
                                    UnitMaster.RESET;
                                    UnitMaster.SETRANGE("Project Code", Code);
                                    UnitMaster.SETRANGE("No.", NewConfOrder."Unit Code");
                                    IF UnitMaster.FINDFIRST THEN BEGIN
                                        UnitMaster."Customer Name" := '';
                                        UnitMaster."Unit Registered" := FALSE;
                                        UnitMaster.MODIFY;
                                    END;
                                END;
                            UNTIL NewConfOrder.NEXT = 0;
                    END ELSE
                        ERROR('This process will be done from MScompany');
                END;
                MESSAGE('%1', 'Records Updated');
            end;
        }
        field(50020; "Publish Registration No."; Boolean)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Company Name");
                CompanyWise.RESET;
                CompanyWise.SETRANGE(CompanyWise."MSC Company", TRUE);
                IF CompanyWise.FINDFIRST THEN BEGIN
                    IF CompanyWise."Company Code" = COMPANYNAME THEN BEGIN
                        NewConfOrder.RESET;
                        NewConfOrder.CHANGECOMPANY("Company Name");
                        NewConfOrder.SETCURRENTKEY(NewConfOrder."Shortcut Dimension 1 Code");
                        NewConfOrder.SETRANGE("Shortcut Dimension 1 Code", Code);
                        NewConfOrder.SETFILTER("Unit Code", '<>%1', '');
                        NewConfOrder.SETRANGE(Status, NewConfOrder.Status::Registered);
                        IF NewConfOrder.FINDSET THEN
                            REPEAT
                                IF "Publish Registration No." THEN BEGIN
                                    IF NewConfOrder."Registration No." <> '' THEN BEGIN
                                        UnitMaster.RESET;
                                        UnitMaster.SETRANGE("Project Code", Code);
                                        UnitMaster.SETRANGE("No.", NewConfOrder."Unit Code");
                                        IF UnitMaster.FINDFIRST THEN BEGIN
                                            UnitMaster."Registration No." := NewConfOrder."Registration No.";
                                            UnitMaster."Unit Registered" := TRUE;
                                            UnitMaster.MODIFY;
                                        END;
                                    END;
                                END ELSE BEGIN
                                    UnitMaster.RESET;
                                    UnitMaster.SETRANGE("Project Code", Code);
                                    UnitMaster.SETRANGE("No.", NewConfOrder."Unit Code");
                                    IF UnitMaster.FINDFIRST THEN BEGIN
                                        UnitMaster."Registration No." := '';
                                        UnitMaster."Unit Registered" := FALSE;
                                        UnitMaster.MODIFY;
                                    END;
                                END;
                            UNTIL NewConfOrder.NEXT = 0;
                    END ELSE
                        ERROR('This process will be done from MScompany');
                END;
                MESSAGE('%1', 'Records Updated');
            end;
        }
        field(50021; "Ref. Company Code"; Text[30])
        {
        }
        field(50022; Trading; Boolean)
        {
            CalcFormula = Lookup(Job.Trading WHERE("No." = FIELD(Code)));
            FieldClass = FlowField;
        }
        field(50023; "Non-Trading"; Boolean)
        {
            CalcFormula = Lookup(Job."Non-Trading" WHERE("No." = FIELD(Code)));
            FieldClass = FlowField;
        }
        field(50024; "Print Image on Reciept"; Boolean)
        {
        }
        field(50025; "Publish CustomerName on Rcpt"; Boolean)
        {
        }
        field(50026; "Project Bank Account No."; Text[30])
        {
        }
        field(50027; "Project Bank IFSC Code"; Code[30])
        {
        }
        field(50028; "Project Branch Name"; Text[100])
        {
        }
        field(50029; "Milestone Enabled"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin

                AccessControl.RESET;
                AccessControl.SETRANGE("User Name", USERID);
                AccessControl.SETRANGE("Role ID", 'SECONDMILESTONE');
                IF NOT AccessControl.FINDFIRST THEN
                    ERROR('You are not authorised to perform this task');
            end;
        }
        field(50030; "GRN Nos. Trading"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(50031; "GRN Nos. Direct Trading"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(50032; "Cluster Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "New Cluster Master"."Cluster Code";
        }
        field(50080; "Min. Amt. Single plot for Web"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Use this field for Plot popup';

            trigger OnValidate()
            begin
                CheckPermission
            end;
        }
        field(50081; "Min. Amt. Double plot for Web"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Use this field for Plot popup';

            trigger OnValidate()
            begin
                CheckPermission
            end;
        }
        field(50082; "Min. Amt. Days (First Day)"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'Use this field for Plot popup';

            trigger OnValidate()
            begin
                CheckPermission
            end;
        }
        field(50083; "Min. Amt. Option Change Day"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'Use this field for Plot popup';

            trigger OnValidate()
            begin
                CheckPermission
            end;
        }
        field(50084; "Option A Days (First Days)"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'Use this field for Plot popup';

            trigger OnValidate()
            begin
                CheckPermission
            end;
        }
        field(50085; "Option A Option Change Days"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'Use this field for Plot popup';

            trigger OnValidate()
            begin
                CheckPermission
            end;
        }
        field(50086; "Option B Days (First Days)"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'Use this field for Plot popup';

            trigger OnValidate()
            begin
                CheckPermission
            end;
        }
        field(50087; "Option B Option Change Days"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'Use this field for Plot popup';

            trigger OnValidate()
            begin
                CheckPermission
            end;
        }
        field(50088; "Option C Days (First Days)"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'Use this field for Plot popup';

            trigger OnValidate()
            begin
                CheckPermission
            end;
        }
        field(50089; "Option C Option Change Days"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'Use this field for Plot popup';

            trigger OnValidate()
            begin
                CheckPermission
            end;
        }
        field(50090; "Allotment Amt Days (First Day)"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'Use this field for Plot popup';

            trigger OnValidate()
            begin
                CheckPermission
            end;
        }
        field(50091; "Allotment Amt. Change Days"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'Use this field for Plot popup';

            trigger OnValidate()
            begin
                CheckPermission
            end;
        }
        field(60066; "Goods Receipt Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60068; "Material Issue Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60069; "Material Return Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60070; "Outward Gate Pass"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60071; "Inward Gate Pass Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60072; "Consumption FOC Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60073; "Consumption Chargable Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60074; "FG Recipt Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60075; "Transfer Order Regular Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60076; "Material Transfer to Site Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60077; "Posted Transfer Shpt. Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60078; "Posted Transfer Rcpt. Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60079; "Purchase Order Nos. Direct"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60080; "Work Order Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60081; "GRN No. Series Direct"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60082; "SRN Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60083; "Direct Transfer Order Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60088; "Released Prod. Order Nos."; Code[10])
        {
            Caption = 'Released Prod. Order Nos.';
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60089; "Subcontracting Order Nos."; Code[10])
        {
            Caption = 'Subcontracting Order Nos.';
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60090; "Delivery Challan Nos."; Code[10])
        {
            Caption = 'Delivery Challan Nos.';
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60091; "Posted Delivery Challan Nos."; Code[10])
        {
            Caption = 'Posted Delivery Challan Nos.';
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60092; "Posted SC Comp. Rcpt. Nos."; Code[10])
        {
            Caption = 'Posted SC Comp. Rcpt. Nos.';
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60093; "Multiple Subcon. Order Det Nos"; Code[10])
        {
            Caption = 'Multiple Subcon. Order Det Nos';
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60094; "Output Journal Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60095; "Consumption Journal Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60096; "GRN QC No. Series"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60097; "Posted GRN QC No. Series"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60098; "Purch Return Shpt. No."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60099; "Issues No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLE TS';
            TableRelation = "No. Series";
        }
        field(60100; "Receiving No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLE TS';
            TableRelation = "No. Series";
        }
        field(60101; "SRN Nos. Trading"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
            TableRelation = "No. Series";
        }
        field(60102; "Land No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'BBG2.0';
        }
        field(60103; "Min. Allotment %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(60104; "Loan Applicable"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '//121023 Loan EMI';
        }
        field(60105; "Project Consider on MIS Report"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; Branch, "Code")
        {
        }
        key(Key3; "Sequence of Project")
        {
        }
        key(Key4; "Company Name")
        {
        }
        key(Key5; "Cluster Code", "Sequence of Project")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        DimMgt.DeleteDefaultDim(DATABASE::"Responsibility Center", Code);
    end;

    var
        PostCode: Record "Post Code";
        DimMgt: Codeunit DimensionManagement;
        DimValue: Record "Dimension Value";
        LocValue: Record Location;
        BranchName: Record Location;
        GLSetup: Record "General Ledger Setup";
        CompanyWise: Record "Company wise G/L Account";
        UnitMaster: Record "Unit Master";
        NewConfOrder: Record "Confirmed Order";
        Cust: Record Customer;
        UnitMasterLLP: Record "Unit Master";
        AccessControl: Record "Access Control";


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::"Responsibility Center", Code, FieldNumber, ShortcutDimCode);
        MODIFY;
    end;

    local procedure CheckPermission()
    begin
        IF USERID <> 'NAVUSER4' THEN
            IF USERID <> 'BCUSER' THEN
                ERROR('Change will be do from NAVUSER4');
    end;
}

