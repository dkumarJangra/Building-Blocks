table 50003 "Project Milestone Header"
{
    DataPerCompany = false;
    DrillDownPageID = "Project wise Milestone Details";
    LookupPageID = "Project wise Milestone Details";

    fields
    {
        field(1; "Document No."; Integer)
        {
        }
        field(2; "Project Code"; Code[20])
        {
            TableRelation = "Responsibility Center 1";

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
                IF "Project Code" <> '' THEN
                    IF ResponsibilityCenter.GET("Project Code") THEN
                        "Project Name" := ResponsibilityCenter.Name
                    ELSE
                        "Project Name" := '';
            end;
        }
        field(3; "Project Name"; Text[50])
        {
            Editable = false;
        }
        field(4; "Effective From Date"; Date)
        {

            trigger OnValidate()
            begin

                TESTFIELD(Status, Status::Open);
                TESTFIELD("Project Code");

                IF "Effective To Date" <> 0D THEN
                    IF "Effective From Date" > "Effective To Date" THEN
                        ERROR('Effective From Date can not be greater than Effective To Date');

                ProjectMilestoneHeader.RESET;
                ProjectMilestoneHeader.SETCURRENTKEY("Project Code", "Effective From Date", "Effective To Date");
                ProjectMilestoneHeader.SETRANGE("Project Code", "Project Code");
                ProjectMilestoneHeader.SETFILTER("Document No.", '<>%1', "Document No.");
                IF ProjectMilestoneHeader.FINDSET THEN
                    REPEAT
                        IF ProjectMilestoneHeader."Effective To Date" <> 0D THEN BEGIN
                            IF ("Effective From Date" <= ProjectMilestoneHeader."Effective To Date") THEN
                                ERROR('You have already define the setup against Document No.-' + FORMAT(ProjectMilestoneHeader."Document No."));
                        END ELSE BEGIN
                            IF ProjectMilestoneHeader."Effective To Date" = 0D THEN BEGIN
                                IF ("Effective From Date" <= ProjectMilestoneHeader."Effective From Date") THEN
                                    ERROR('You have already define the setup against Document No.-' + FORMAT(ProjectMilestoneHeader."Document No."));
                            END;
                        END;
                    UNTIL ProjectMilestoneHeader.NEXT = 0;

                Projectmilestoneline.RESET;
                Projectmilestoneline.SETRANGE("Document No.", "Document No.");
                IF Projectmilestoneline.FINDSET THEN
                    REPEAT
                        Projectmilestoneline."Effective From Date" := "Effective From Date";
                        Projectmilestoneline.MODIFY;
                    UNTIL Projectmilestoneline.NEXT = 0;
            end;
        }
        field(5; "Effective To Date"; Date)
        {

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
                TESTFIELD("Project Code");

                IF "Effective To Date" < "Effective From Date" THEN
                    ERROR('Effective To Date can not be less than Effective From Date');

                Projectmilestoneline.RESET;
                Projectmilestoneline.SETRANGE("Document No.", "Document No.");
                IF Projectmilestoneline.FINDSET THEN
                    REPEAT
                        Projectmilestoneline."Effective To Date" := "Effective To Date";
                        Projectmilestoneline.MODIFY;
                    UNTIL Projectmilestoneline.NEXT = 0;
            end;
        }
        field(6; "Created By"; Code[50])
        {
            Editable = false;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(7; "Creator Name"; Text[50])
        {
            Editable = false;
        }
        field(8; "Creation Date"; Date)
        {
            Editable = false;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(9; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;

            trigger OnValidate()
            begin
                Projectmilestoneline.RESET;
                Projectmilestoneline.SETRANGE("Document No.", "Document No.");
                IF Projectmilestoneline.FINDSET THEN
                    REPEAT
                        Projectmilestoneline.Status := Status;
                        Projectmilestoneline.MODIFY;
                    UNTIL Projectmilestoneline.NEXT = 0;
            end;
        }
    }

    keys
    {
        key(Key1; "Document No.")
        {
            Clustered = true;
        }
        key(Key2; "Project Code", "Effective From Date", "Effective To Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD(Status, Status::Open);
        Projectmilestoneline.RESET;
        Projectmilestoneline.SETRANGE("Document No.", "Document No.");
        IF Projectmilestoneline.FINDSET THEN
            Projectmilestoneline.DELETEALL;
    end;

    trigger OnInsert()
    begin
        TESTFIELD(Status, Status::Open);
        IF ProjectMilestoneHeader.FINDLAST THEN
            "Document No." := ProjectMilestoneHeader."Document No." + 1
        ELSE
            "Document No." := 1;

        "Created By" := USERID;
        //IF User.GET(USERID) THEN
        "Creator Name" := User."User Name";
        "Creation Date" := TODAY;
    end;

    var
        ProjectMilestoneHeader: Record "Project Milestone Header";
        ResponsibilityCenter: Record "Responsibility Center 1";
        User: Record User;
        Projectmilestoneline: Record "Project Milestone Line";
}

