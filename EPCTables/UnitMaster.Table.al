table 97821 "Unit Master"
{
    // BBG1.00/AD 150712:Added NA caption under Facing.
    // ALLEPG 310812 : Added Field.
    // BBG1.00 AD 130113: WebPortal Status changed from Open to Available.
    // BBG1.1 181213 Added field of Block Sub Type

    DataPerCompany = false;
    DrillDownPageID = "Unit Master List";
    LookupPageID = "Unit Master List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = true;
            NotBlank = true;
        }
        field(50001; "Web Portal Status"; Option)
        {
            Description = 'ALLERM_WEB_191012';
            Editable = false;
            OptionMembers = Available,Booked;
        }
        field(50002; "Non Usable"; Boolean)
        {
            Description = 'ALLERM_WEB_191012';
            Editable = false;

            trigger OnValidate()
            begin
                IF Reserve THEN
                    TESTFIELD("Non Usable", FALSE);
            end;
        }
        field(50003; "Associate Code"; Code[20])
        {
            Description = 'ALLECK_071112';
            TableRelation = Vendor."No." WHERE("BBG Vendor Category" = CONST("IBA(Associates)"));

            trigger OnValidate()
            begin
                IF Vend.GET("Associate Code") THEN
                    "Associate Name" := Vend.Name
                ELSE
                    "Associate Name" := '';
            end;
        }
        field(50004; "Associate Name"; Text[50])
        {
            Description = 'ALLECK_071112';
        }
        field(50005; Reserve; Boolean)
        {
            Description = 'ALLECK_071112';

            trigger OnValidate()
            begin
                //ALLETDK190713>>>
                TESTFIELD(Status, Status::Open);
                IF Reserve THEN BEGIN
                    Status := Status::Blocked;
                    "Web Portal Status" := "Web Portal Status"::Booked;
                END ELSE BEGIN
                    Status := Status::Open;
                    "Web Portal Status" := "Web Portal Status"::Available;
                END;
                //ALLETDK190713<<<
            end;
        }
        field(50010; "No. of Plots for Incentive Cal"; Decimal)
        {
            Description = 'BBG1.00 160713';
        }
        field(50011; "Block SubType"; Option)
        {
            Description = 'BBG1.1 181213';
            OptionCaption = ' ,Layout Change,Other';
            OptionMembers = " ","Layout Change",Other;

            trigger OnValidate()
            begin
                VALIDATE("Non Usable", FALSE);
            end;
        }
        field(50012; "Unit for Company"; Option)
        {
            OptionCaption = 'Trading,LLP';
            OptionMembers = Trading,LLP;
        }
        field(50021; "PLC Applicable"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50022; "East Boundary"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50023; "West Boundary"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50024; "North Boundary"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50025; "South Boundary"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50026; Mortgage; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50031; "100 feet Road"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '090921 new field';
        }
        field(50100; Approve; Boolean)
        {
        }
        field(50101; "App. Payment Plan"; Code[20])
        {
            CalcFormula = Lookup("Document Master"."App. Charge Code" WHERE(Code = FILTER('PPLAN'),
                                                                             "Unit Code" = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(50119; "Regd Numbers"; Text[30])
        {
            Editable = false;
        }
        field(50120; "Regd date"; Date)
        {
            Editable = false;
        }
        field(50121; "Payment plan Code"; Text[30])
        {
            Editable = false;
        }
        field(50122; Doj; Date)
        {
            Editable = false;
        }
        field(50124; Ldp; Date)
        {
            Editable = false;
        }
        field(50131; "Minimum Booking Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Web';
        }
        field(50132; "Vacate by Job Queue"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50133; "Vacate by Job Queue DAtetime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50134; "Old Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Blocked,Booked,Registered,Transfered';
            OptionMembers = Open,Blocked,Booked,Registered,Transfered;
        }
        field(50135; "Plot hold for Mobile App"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50136; "Plot hold USER ID _Mobile App"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60015; "Unit Category"; Option)
        {
            OptionCaption = ' ,Normal,Priority';
            OptionMembers = " ",Normal,Priority;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
                IF "Unit Category" <> "Unit Category"::Normal THEN
                    "Non Usable" := TRUE;

                UCPCode.RESET;
                IF UCPCode.GET("Payment Plan") THEN BEGIN
                    IF UCPCode."Priority Booking Code" THEN
                        TESTFIELD("Unit Category", "Unit Category"::Priority)
                    ELSE
                        TESTFIELD("Unit Category", "Unit Category"::Normal);
                END;
            end;
        }
        field(60016; "Creation Date"; Date)
        {
            Editable = false;
        }
        field(60017; "Modify Date"; Date)
        {
            Editable = false;
        }
        field(60018; "Modify Time"; Time)
        {
            Editable = false;
        }
        field(60019; "Modified By"; Code[50])
        {
            Editable = false;
        }
        field(90001; "Super Area"; Decimal)
        {
            Description = 'ALLERE';
            Editable = false;
        }
        field(90002; "Saleable Area"; Decimal)
        {
            Description = 'ALLERE';

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(90003; "Carpet Area"; Decimal)
        {
            Description = 'ALLERE';

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
                IF ("Super Area" <> 0) AND ("Saleable Area" <> 0) THEN
                    "Efficiency (%)" := (("Saleable Area" / "Super Area") * 100);
            end;
        }
        field(90004; "Efficiency (%)"; Decimal)
        {
            Description = 'ALLERE';
            Editable = true;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
                "Carpet Area" := (("Saleable Area" / "Efficiency (%)") * 100);
            end;
        }
        field(90005; "Sales Rate"; Decimal)
        {
            Description = 'ALLERE';
        }
        field(90006; "PLC (%)"; Decimal)
        {
            Description = 'ALLERE';
            Editable = true;
        }
        field(90007; "Lease Zone Code"; Code[20])
        {
            Description = 'ALLERE';
            Editable = true;
            TableRelation = "Document Master".Code WHERE("Document Type" = FILTER('Zone'),
                                                          "Project Code" = FIELD("Project Code"));
        }
        field(90010; "Unit Type"; Code[20])
        {
            Description = 'ALLERE';
        }
        field(90011; "Lease Rate"; Decimal)
        {
            Description = 'ALLERE';
        }
        field(90012; "Sales Blocked"; Boolean)
        {
            Description = 'AlleBLK';
        }
        field(90013; "Lease Blocked"; Boolean)
        {
            Description = 'ALLERE';
        }
        field(90014; "Project Price Group"; Code[20])
        {
            Description = 'AlleBLK';
            TableRelation = "Document Master".Code WHERE("Document Type" = FILTER("Project Price Groups"),
                                                          "Project Code" = FIELD("Project Code"));
        }
        field(90016; "Sales Order Count"; Integer)
        {
            CalcFormula = Count("Sales Header" WHERE("Order Status" = FILTER(Booked),
                                                      "Sub Document Type" = FILTER(Sales | "Sale Property"),
                                                      "Item Code" = FIELD("No."),
                                                      "Document Type" = FILTER(Order)));
            Description = 'ALLERE';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90017; "Lease Order Count"; Integer)
        {
            CalcFormula = Count("Sales Header" WHERE("Order Status" = FILTER(Booked),
                                                      "Sub Document Type" = FILTER(Lease | "Lease Property"),
                                                      "Item Code" = FIELD("No."),
                                                      "Document Type" = FILTER(Order)));
            Description = 'ALLERE';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90019; "Constructed Property"; Integer)
        {
            Description = 'ALLERE';
            Editable = false;
        }
        field(90050; Type; Option)
        {
            Description = 'ALLEAB For Real Estate Property Type';
            OptionCaption = ' ,Flat,Plot,Commercial Space,Villa,Shop,Row House';
            OptionMembers = " ",Flat,Plot,"Commercial Space",Villa,Shop,"Row House";
        }
        field(90051; "Project Code"; Code[20])
        {
            Description = 'ALLEAB For Real Estate Property Type';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(90052; "Sub Project Code"; Code[20])
        {
            Description = 'ALLEAB For Real Estate Property Type';
            TableRelation = "Dimension Value".Code WHERE(Code = FILTER('PROJECT BLOCK'),
                                                          "LINK to Region Dim" = FIELD("Project Code"));
        }
        field(90053; "Sell to Customer No."; Code[20])
        {
            Description = 'AlleBLK';
            TableRelation = Customer;
        }
        field(90054; "Broker No."; Code[20])
        {
            Description = 'AlleBLK';
            TableRelation = Vendor WHERE("BBG Vendor Category" = FILTER(Transporter));
        }
        field(90055; "Floor No."; Code[10])
        {
            Description = 'AlleBLK';
        }
        field(90056; Description; Text[60])
        {
            Description = 'AlleBLK';
        }
        field(90057; "Base Unit of Measure"; Code[20])
        {
            TableRelation = "Unit of Measure".Code;
        }
        field(90058; "Payment Plan"; Code[20])
        {
            TableRelation = "Document Master".Code WHERE("Document Type" = CONST("Payment Plan"),
                                                          "Project Code" = FIELD("Project Code"));

            trigger OnValidate()
            begin
                TESTFIELD("Min. Allotment Amount", 0);
            end;
        }
        field(90059; Facing; Option)
        {
            Description = 'AD030712_BBG1.00';
            OptionCaption = 'NA,East,West,North,South,NorthWest,SouthEast,NorthEast,SouthWest';
            OptionMembers = NA,East,West,North,South,NorthWest,SouthEast,NorthEast,SouthWest;
        }
        field(90060; "Size-East"; Decimal)
        {
            Description = 'AD030712_BBG1.00';
        }
        field(90061; "Size-West"; Decimal)
        {
            Description = 'AD030712_BBG1.00';
        }
        field(90062; "Size-North"; Decimal)
        {
            Description = 'AD030712_BBG1.00';
        }
        field(90063; "Size-South"; Decimal)
        {
            Description = 'AD030712_BBG1.00';
        }
        field(90064; "Min. Allotment Amount"; Decimal)
        {

            trigger OnValidate()
            begin

                TESTFIELD(Status, Status::Open);
                IF Job.GET("Project Code") THEN
                    IF Job."Project Min. Amt based on %" = FALSE THEN BEGIN
                        TotalFixedAmt := 0;
                        PLDetails.RESET;
                        PLDetails.SETRANGE("Project Code", "Project Code");
                        PLDetails.SETRANGE(PLDetails."Payment Plan Code", "Payment Plan");
                        PLDetails.SETFILTER(PLDetails."Document No.", '%1', '');
                        IF PLDetails.FINDSET THEN BEGIN
                            REPEAT
                                TotalFixedAmt := TotalFixedAmt + PLDetails."Fixed Amount";
                            UNTIL PLDetails.NEXT = 0;
                            IF "Min. Allotment Amount" <> 0 THEN BEGIN
                                IF TotalFixedAmt <> "Min. Allotment Amount" THEN
                                    ERROR('Please check the Payment Plan OR Min. Allotment Amount');
                            END;
                        END;
                    END;
            end;
        }
        field(90065; Status; Option)
        {
            Editable = true;
            OptionCaption = 'Open,Blocked,Booked,Registered,Transfered';
            OptionMembers = Open,Blocked,Booked,Registered,Transfered;

            trigger OnValidate()
            begin
                IF Status = Status::Open THEN
                    "Web Portal Status" := "Web Portal Status"::Available
                ELSE
                    "Web Portal Status" := "Web Portal Status"::Booked;
                //ALLETDK190713>>>
                IF Status = Status::Blocked THEN
                    TESTFIELD("Comment for Unit Block");
                //ALLETDK190713<<<
            end;
        }
        field(90066; "60 feet Road"; Boolean)
        {

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(90067; Freeze; Boolean)
        {
            Description = 'ALLEPG 310812';
            Editable = true;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(90068; "Total Value"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(90069; "Project Name"; Text[60])
        {
        }
        field(90070; "Customer Code"; Code[20])
        {
        }
        field(90071; "No. of Plots"; Integer)
        {
            Description = 'ALLEPG 061112';

            trigger OnValidate()
            begin
                IF Status = Status::Booked THEN
                    ERROR('Unit already booked');
            end;
        }
        field(90072; "Old No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Old No." <> '' THEN BEGIN
                    UMaster.RESET;
                    UMaster.SETRANGE("Old No.", "Old No.");
                    UMaster.SETRANGE("Project Code", "Project Code");
                    IF UMaster.FINDFIRST THEN
                        ERROR('Unit already exists');
                END;
            end;
        }
        field(90073; Corner; Boolean)
        {
            Description = '240113';
        }
        field(90074; "Comment for Unit Block"; Text[50])
        {

            trigger OnValidate()
            begin
                //TESTFIELD(Status,Status::Open);
                //TESTFIELD(Archived,Archived::No);
            end;
        }
        field(90075; Version; Integer)
        {
            CalcFormula = Max("Archive Unit Master".Version WHERE("No." = FIELD("No."),
                                                                   "Project Code" = FIELD("Project Code")));
            Description = 'ALLECK 200313';
            FieldClass = FlowField;
        }
        field(90076; Archived; Option)
        {
            Description = 'ALLECK 200313';
            OptionMembers = No,Yes;
        }
        field(90078; Blocked; Boolean)
        {
            Description = 'ALLETDK';

            trigger OnValidate()
            begin
                IF Blocked THEN BEGIN
                    TESTFIELD(Status, Status::Open);
                    TESTFIELD("Comment for Unit Block");
                    TESTFIELD("Block SubType");
                    Status := Status::Blocked;
                    "Web Portal Status" := "Web Portal Status"::Booked;
                    "Non Usable" := TRUE;
                END ELSE BEGIN
                    Status := Status::Open;
                    "Web Portal Status" := "Web Portal Status"::Available;
                    "Non Usable" := FALSE;
                    "Comment for Unit Block" := '';
                    "Block SubType" := "Block SubType"::" ";
                END;
            end;
        }
        field(90079; "Company Name"; Text[30])
        {
            Editable = true;
            TableRelation = Company;

            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
            begin
                UserSetup.RESET;
                UserSetup.SETRANGE("User ID", USERID);
                UserSetup.SETRANGE("Change Unit Company Name", TRUE);
                IF NOT UserSetup.FINDFIRST THEN
                    ERROR('Contact Admin');
            end;
        }
        field(90080; "Plot Cost"; Decimal)
        {
        }
        field(90081; "Customer Name"; Text[60])
        {
        }
        field(90082; "Registration No."; Code[20])
        {
        }
        field(90083; "Unit Registered"; Boolean)
        {
        }
        field(90084; "Special Units"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = true;

            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
            begin
                UserSetup.RESET;
                UserSetup.SETRANGE("User ID", USERID);
                UserSetup.SETRANGE("Change Unit Company Name", TRUE);
                IF NOT UserSetup.FINDFIRST THEN
                    ERROR('Contact Admin');
            end;
        }
        field(90085; "Check unit Alloted"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90086; "Ref. LLP Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Company;
        }
        field(90087; "Ref. LLP Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(90088; "IC Partner Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(90089; "Last Unit Blocked DT"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90090; "Last Unit Blocked By"; Code[40])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(90091; "Type Of Deed"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,AGPA,Sale Deed,AOS';
            OptionMembers = " ",AGPA,"Sale Deed",AOS;

        }
        field(90092; "Deed No"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Project Code", Status)
        {
            SumIndexFields = "Total Value", "Saleable Area";
        }
        key(Key3; "Project Code", Status, "Non Usable", "Unit Category", Reserve)
        {
            SumIndexFields = "Total Value", "Saleable Area";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD(Status, Status::Open);
        RecDocMaster.RESET;
        RecDocMaster.SETRANGE("Project Code", "Project Code");
        RecDocMaster.SETRANGE("Unit Code", "No.");
        IF RecDocMaster.FINDSET THEN
            REPEAT
                RecDocMaster.DELETE;
            UNTIL RecDocMaster.NEXT = 0;
    end;

    trigger OnModify()
    begin
        //TESTFIELD(Status,Status ::Open);

        //IF Rec <> xRec THEN BEGIN
        "Modify Date" := TODAY;
        "Modify Time" := TIME;
        "Modified By" := USERID;
        //END;
    end;

    var
        DocMaster: Record "Document Master";
        Vend: Record Vendor;
        UMaster: Record "Unit Master";
        UMasterForm: Page "Project Unit Card";
        PLDetails: Record "Payment Plan Details";
        TotalFixedAmt: Decimal;
        RecDocMaster: Record "Document Master";
        UCPCode: Record "Unit Charge & Payment Pl. Code";
        Job: Record Job;


    procedure ShowUnitCard()
    begin
        //ALLEDK 180213
        TESTFIELD("No.");
        CLEAR(UMasterForm);
        UMaster.RESET;
        UMaster.SETRANGE("No.", "No.");
        UMasterForm.SETTABLEVIEW(UMaster);
        UMasterForm.RUNMODAL;
        //ALLEDK 180213
    end;
}

