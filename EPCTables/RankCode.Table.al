table 50014 "Rank Code"
{
    DataPerCompany = false;
    DrillDownPageID = "Rank Code";
    LookupPageID = "Rank Code";

    fields
    {
        field(1; "Rank Batch Code"; Code[10])
        {
            TableRelation = "Rank Code Master";

            trigger OnValidate()
            begin
                IF RankCode.GET("Rank Batch Code") THEN
                    "Rank Batch Description" := RankCode.Description
                ELSE
                    "Rank Batch Description" := '';
            end;
        }
        field(2; "Code"; Decimal)
        {

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(3; Description; Text[30])
        {

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(4; "Direct Entry"; Boolean)
        {

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(5; "Min. Direct Join"; Integer)
        {

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(6; "Rank Batch Description"; Text[50])
        {
            Editable = false;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(7; Status; Option)
        {
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(50001; "Show on Mobile App"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; Category; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "RECRUITMENTS Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,SANKALAP,MAHA SANKALAP';
            OptionMembers = " ",SANKALAP,"MAHA SANKALAP";
        }
        field(50004; "Display Rank Code"; Boolean)
        {

        }
    }

    keys
    {
        key(Key1; "Rank Batch Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Allow User Setup Modify", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');
    end;

    trigger OnInsert()
    begin
        "Direct Entry" := TRUE;
    end;

    trigger OnModify()
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Allow User Setup Modify", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');
    end;

    var
        RankCode: Record "Rank Code Master";
        UserSetup: Record "User Setup";
}

