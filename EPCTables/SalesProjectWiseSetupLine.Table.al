table 50028 "Sales Project Wise Setup Line"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Project Code"; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Effective From Date"; Date)
        {

            trigger OnValidate()
            begin
                CheckStatus;

                IF "Effective To Date" <> 0D THEN
                    IF "Effective From Date" > "Effective To Date" THEN
                        ERROR('Effective to date must be grater than Effective from date');
            end;
        }
        field(4; "Effective To Date"; Date)
        {

            trigger OnValidate()
            begin
                CheckStatus;

                IF "Effective From Date" > "Effective To Date" THEN
                    ERROR('Effective to date must be grater than Effective from date');
            end;
        }
        field(5; "Sales %"; Decimal)
        {

            trigger OnValidate()
            begin
                CheckStatus;
                IF "Sales %" > 100 THEN
                    ERROR('The Value should not be greater than 100');

                SalesProjectWiseSetupLine.RESET;
                SalesProjectWiseSetupLine.SETRANGE("Project Code", "Project Code");
                SalesProjectWiseSetupLine.SETRANGE("Effective From Date", "Effective From Date");
                SalesProjectWiseSetupLine.SETRANGE("Effective To Date", "Effective To Date");
                SalesProjectWiseSetupLine.SETRANGE("Sales %", "Sales %");
                IF SalesProjectWiseSetupLine.FINDFIRST THEN
                    ERROR('Entry already exists with Line No.-' + FORMAT(SalesProjectWiseSetupLine."Line No."));

                SPWSLine.RESET;
                SPWSLine.SETRANGE("Project Code", "Project Code");
                SPWSLine.SETRANGE("Effective From Date", "Effective From Date");
                SPWSLine.SETRANGE("Effective To Date", "Effective To Date");
                SPWSLine.SETRANGE(Status, SPWSLine.Status::Open);
                SPWSLine.SETFILTER("Line No.", '<>%1', "Line No.");
                IF SPWSLine.FINDFIRST THEN
                    ERROR('Open Entry already exists with Line No.-' + FORMAT(SPWSLine."Line No."));
            end;
        }
        field(6; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Released,Closed';
            OptionMembers = Open,Released,Closed;

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(7; "Creation Date"; Date)
        {
            Editable = false;
        }
        field(8; "User ID"; Code[20])
        {
            Editable = false;
        }
        field(9; "Creation Time"; Time)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Project Code", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Project Code", Status, "Effective From Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD(Status, Status::Open);
    end;

    trigger OnInsert()
    begin
        "Creation Date" := TODAY;
        "User ID" := USERID;
        "Creation Time" := TIME;
    end;

    trigger OnModify()
    begin
        "Creation Date" := TODAY;
        "User ID" := USERID;
        "Creation Time" := TIME;

        TESTFIELD(Status, Status::Open);
    end;

    var
        SalesProjectWiseSetupLine: Record "Sales Project Wise Setup Line";
        SPWSLine: Record "Sales Project Wise Setup Line";
        CheckEntry: Boolean;


    procedure CheckStatus()
    var
        SalesProjectWiseSetupHdr: Record "Sales Project Wise Setup Hdr";
    begin
        SalesProjectWiseSetupHdr.RESET;
        IF SalesProjectWiseSetupHdr.GET("Project Code") THEN
            SalesProjectWiseSetupHdr.TESTFIELD(Status, SalesProjectWiseSetupHdr.Status::Open);
    end;
}

