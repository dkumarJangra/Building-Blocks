table 50049 "Project wise Development Charg"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Document No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false),
                                                          "IS Project" = CONST(true));

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
                GeneralLedgerSetup.GET;
                GeneralLedgerSetup.TESTFIELD("Shortcut Dimension 1 Code");
                DimensionValue.RESET;
                DimensionValue.SETRANGE("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 1 Code");
                DimensionValue.SETRANGE(Code, "Project Code");
                IF DimensionValue.FINDFIRST THEN
                    "Project Name" := DimensionValue.Name
                ELSE
                    "Project Name" := '';
            end;
        }
        field(3; "Project Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
                IF "End Date" <> 0D THEN
                    IF "Start Date" > "End Date" THEN
                        ERROR('Start Date can not be greater than End Date');
                ProjectwiseDevelopmentCharg.RESET;
                ProjectwiseDevelopmentCharg.SETRANGE("Project Code", "Project Code");
                ProjectwiseDevelopmentCharg.SETFILTER("Document No.", '<>%1', "Document No.");
                ProjectwiseDevelopmentCharg.SETRANGE("End Date", 0D);
                IF ProjectwiseDevelopmentCharg.FINDFIRST THEN
                    ERROR('Please fill the End Date for Document No.' + FORMAT(ProjectwiseDevelopmentCharg."Document No."));

                ProjectwiseDevelopmentCharg.RESET;
                ProjectwiseDevelopmentCharg.SETRANGE("Project Code", "Project Code");
                ProjectwiseDevelopmentCharg.SETFILTER("Document No.", '<>%1', "Document No.");
                IF ProjectwiseDevelopmentCharg.FINDSET THEN
                    REPEAT
                        IF (ProjectwiseDevelopmentCharg."Start Date" <> 0D) AND (ProjectwiseDevelopmentCharg."End Date" <> 0D) THEN
                            ProjectwiseDevelopmentCharg.TESTFIELD(Status, ProjectwiseDevelopmentCharg.Status::Release);
                        IF ("Start Date" > ProjectwiseDevelopmentCharg."Start Date") AND ("Start Date" < ProjectwiseDevelopmentCharg."End Date") THEN
                            ERROR('Current setup is belong between ' + FORMAT(ProjectwiseDevelopmentCharg."Start Date") + '....' + FORMAT(ProjectwiseDevelopmentCharg."End Date"));

                    UNTIL ProjectwiseDevelopmentCharg.NEXT = 0;
            end;
        }
        field(5; "End Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
                IF "Start Date" > "End Date" THEN
                    ERROR('End Date can not be less than Start Date');
            end;
        }
        field(6; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;

            trigger OnValidate()
            begin
                //IF Status = Status::Release THEN
                // TESTFIELD(Amount);
            end;
        }
        field(7; Amount; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
    }

    keys
    {
        key(Key1; "Document No.")
        {
            Clustered = true;
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
        OldProjWiseDevCharges.RESET;
        IF OldProjWiseDevCharges.FINDLAST THEN
            "Document No." := OldProjWiseDevCharges."Document No." + 1
        ELSE
            "Document No." := 1;
    end;

    var
        DimensionValue: Record "Dimension Value";
        GeneralLedgerSetup: Record "General Ledger Setup";
        ProjectwiseDevelopmentCharg: Record "Project wise Development Charg";
        OldProjWiseDevCharges: Record "Project wise Development Charg";
}

