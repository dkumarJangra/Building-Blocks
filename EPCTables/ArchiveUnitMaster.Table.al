table 97861 "Archive Unit Master"
{
    // BBG1.00/AD 150712:Added NA caption under Facing.
    // ALLEPG 310812 : Added Field.
    // BBG1.00 AD 130113: WebPortal Status changed from Open to Available.

    DataPerCompany = false;
    DrillDownPageID = "Archive Unit List";
    LookupPageID = "Archive Unit List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
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
        }
        field(50007; "User ID"; Code[20])
        {
            Editable = false;
        }
        field(50008; "Archive Date"; Date)
        {
            Editable = false;
        }
        field(60015; "Unit Category"; Option)
        {
            OptionCaption = ' ,Normal,Priority';
            OptionMembers = " ",Normal,Priority;

            trigger OnValidate()
            begin
                IF "Unit Category" <> "Unit Category"::Normal THEN
                    "Non Usable" := TRUE;
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
        }
        field(90003; "Carpet Area"; Decimal)
        {
            Description = 'ALLERE';

            trigger OnValidate()
            begin
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
                // "Carpet Area":=(("Saleable Area"/"Efficiency (%)")*100);//ALLECK 180313
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
            TableRelation = "Document Master".Code WHERE("Document Type" = FILTER(Zone),
                                                          "Project Code" = FIELD("Project Code"));
        }
        field(90010; "Unit Type"; Code[20])
        {
            Description = 'ALLERE';
            TableRelation = "Document Master".Code WHERE("Document Type" = FILTER(Unit),
                                                          "Project Code" = FIELD("Project Code"));
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
        }
        field(90065; Status; Option)
        {
            Editable = true;
            OptionCaption = 'Open,Blocked,Booked,Registered';
            OptionMembers = Open,Blocked,Booked,Registered;

            trigger OnValidate()
            begin
                IF Status = Status::Open THEN
                    "Web Portal Status" := "Web Portal Status"::Available
                ELSE
                    "Web Portal Status" := "Web Portal Status"::Booked;
            end;
        }
        field(90066; "60 feet Road"; Boolean)
        {
        }
        field(90067; Freeze; Boolean)
        {
            Description = 'ALLEPG 310812';
            Editable = true;
        }
        field(90068; "Total Value"; Decimal)
        {
            Editable = false;
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
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(90075; Version; Integer)
        {
            Description = 'ALLECK 200313';
            TableRelation = "Archive Unit Master"."No." WHERE("No." = FIELD("No."));
        }
        field(90076; Archived; Option)
        {
            Description = 'ALLECK 200313';
            OptionMembers = No,Yes;
        }
        field(90077; "Archive Time"; Time)
        {
            Description = 'ALLECK 220313';
        }
        field(90078; "Not find"; Boolean)
        {
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
    }

    keys
    {
        key(Key1; "No.", Version)
        {
            Clustered = true;
        }
        key(Key2; "Project Code", Status)
        {
            SumIndexFields = "Total Value", "Saleable Area";
        }
        key(Key3; "Project Code", "No.", Version)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //TESTFIELD(Status,Status ::Open);
    end;

    trigger OnModify()
    begin
        //TESTFIELD(Status,Status ::Open)  //??

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

