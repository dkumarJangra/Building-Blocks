table 97803 "Commission Structure"
{
    // AD: BBG1.00_10012014:THE % FIELD DECIMAL FRACTION REPLACED FROM 2:3 TO 2:4

    DataPerCompany = false;
    DrillDownPageID = "Commission Structure";
    LookupPageID = "Commission Structure";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Commission Type"; Option)
        {
            OptionCaption = 'Commission,Bonus';
            OptionMembers = Commission,Bonus;
        }
        field(3; "Rank Code"; Decimal)
        {
            TableRelation = Rank;

            trigger OnValidate()
            begin
                IF "Rank Code" <> 0 THEN BEGIN
                    IF Rank.GET("Rank Code") THEN
                        "Rank Description" := Rank.Description
                    ELSE
                        "Rank Description" := '';
                END;
            end;
        }
        field(4; Period; Integer)
        {
        }
        field(5; "Commission %"; Decimal)
        {
            DecimalPlaces = 2 : 4;
            MaxValue = 99;
            MinValue = 0;
        }
        field(6; "Starting Date"; Date)
        {
        }
        field(7; "Investment Type"; Option)
        {
            Editable = false;
            OptionCaption = 'FD-MIS,RD';
            OptionMembers = "FD-MIS",RD;
        }
        field(8; "Project Type"; Code[10])
        {
            TableRelation = "Unit Type".Code;

            trigger OnValidate()
            begin
                IF "Project Type" <> '' THEN BEGIN
                    IF UnitType.GET("Project Type") THEN
                        "Company Name" := UnitType."Company Name";
                END;
            end;
        }
        field(9; "TDS Applicable"; Boolean)
        {
        }
        field(10; "Year Code"; Integer)
        {
        }
        field(11; "Rank Description"; Text[60])
        {
            Editable = false;
        }
        field(50000; "Old Entry No."; Integer)
        {
        }
        field(50001; Status; Option)
        {
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(50002; "Company Name"; Text[30])
        {
            Editable = false;
        }
        field(50003; "Unit Payment Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "App. Charge Code".Code WHERE("Sub Payment Plan" = FILTER(true));

            trigger OnValidate()
            begin
                AppChargeCode.RESET;
                AppChargeCode.SETRANGE(AppChargeCode.Code, "Unit Payment Plan");
                IF AppChargeCode.FINDFIRST THEN
                    "Unit Plan Name" := AppChargeCode.Description;
            end;
        }
        field(50004; "Unit Plan Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Rank Code", "Commission Type", Period, "Investment Type")
        {
        }
        key(Key3; "Commission Type")
        {
        }
        key(Key4; "Investment Type")
        {
        }
        key(Key5; "Rank Code", "Commission Type", Period, "Investment Type", "Starting Date")
        {
        }
        key(Key6; "Project Type", "Starting Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        //ALLECK 080313 START
        TESTFIELD(Status, Status::Open);
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETRANGE("Role ID", 'A_COMMISSIONSTRUCT');
        IF NOT MemberOf.FINDFIRST THEN
            ERROR('You do not have permission of role : A_COMMISSIONSTRUCT');
    end;

    var
        Rank: Record Rank;
        MemberOf: Record "Access Control";
        UnitType: Record "Unit Type";
        AppChargeCode: Record "App. Charge Code";
}

