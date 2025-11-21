table 60790 "Unit Master Log"
{
    // version BBG1.00

    DataPerCompany = false;
    //DrillDownPageID = 60780;
    //LookupPageID = 60780;

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
        field(50005; Reserve; Boolean)
        {
            Description = 'ALLECK_071112';
        }
        field(50007; "User ID"; Code[20])
        {
            Editable = false;
        }
        field(60016; "Creation Date"; Date)
        {
            Editable = false;
        }
        field(90002; "Saleable Area"; Decimal)
        {
            Description = 'ALLERE';
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
        field(90053; "Sell to Customer No."; Code[20])
        {
            Description = 'AlleBLK';
            TableRelation = Customer;
        }
        field(90057; "Base Unit of Measure"; Code[20])
        {
            TableRelation = "Unit of Measure".Code;
        }
        field(90058; "Payment Plan"; Code[20])
        {
            TableRelation = "Document Master".Code WHERE("Document Type" = CONST(5),
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
        }
        field(90066; "60 feet Road"; Boolean)
        {
        }
        field(90067; Freeze; Boolean)
        {
            Description = 'ALLEPG 310812';
            Editable = true;
        }
        field(90069; "Project Name"; Text[60])
        {
        }
        field(90070; "Customer Code"; Code[20])
        {
        }
        field(90073; Corner; Boolean)
        {
            Description = '240113';
        }
        field(90075; Version; Integer)
        {
            Description = 'ALLECK 200313';
            TableRelation = "Archive Unit Master"."No." WHERE("No." = FIELD("No."));
        }
        field(90188; "Creation Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.", Version)
        {
        }
        key(Key2; "Project Code", Status)
        {
            SumIndexFields = "Saleable Area";
        }
        key(Key3; "Project Code", "No.", Version)
        {
        }
    }

    fieldgroups
    {
    }

    var
        DocMaster: Record "Document Master";
        Vend: Record Vendor;
        UMaster: Record "Unit Master";
    // UMasterForm: Page 97826;

    procedure ShowUnitCard()
    begin
        // CLEAR(UMasterForm);
        // UMaster.RESET;
        // UMaster.SETRANGE("No.","No.");
        // UMasterForm.SETTABLEVIEW(UMaster);
        // UMasterForm.RUNMODAL;
        //ALLEDK 180213
    end;
}

