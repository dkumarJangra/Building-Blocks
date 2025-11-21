table 97789 "Unit Type"
{
    Caption = 'Bond Type';
    DataPerCompany = false;
    DrillDownPageID = "Project Type List";
    LookupPageID = "Project Type List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(3; "Bond Nos."; Code[20])
        {
            Caption = 'Bond Nos.';
            TableRelation = "No. Series";
        }
        field(5; "Threshold Amount"; Decimal)
        {
            Caption = 'Threshold Amount';
        }
        field(6; Blocked; Boolean)
        {
        }
        field(7; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(50000; "Company Name"; Text[30])
        {
            TableRelation = Company;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF Code <> '' THEN BEGIN

            Job.RESET;
            Job.SETRANGE(Job."Default Project Type", Code);
            IF Job.FINDFIRST THEN
                ERROR('This Code is used on Project. So you do not Delete it.');

            Application.RESET;
            Application.SETRANGE(Application."Project Type", Code);
            IF Application.FINDFIRST THEN
                ERROR('This Code is used on Application.So you do not Delete it.');

            ConfOrder.RESET;
            ConfOrder.SETRANGE(ConfOrder."Project Type", Code);
            IF ConfOrder.FINDFIRST THEN
                ERROR('This Code is used on Confirmed Order.So you do not Delete it.');
        END;
    end;

    trigger OnModify()
    begin
        TESTFIELD(Status, Status::Open);
    end;

    var
        Job: Record Job;
        Application: Record Application;
        ConfOrder: Record "Confirmed Order";
}

