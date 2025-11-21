table 50062 "Customer Gifts Setup"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center 1";

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(2; "Eligible Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(3; Grams; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(4; "Project Name"; Text[100])
        {
            CalcFormula = Lookup("Responsibility Center".Name WHERE(Code = FIELD("Project Code")));
            FieldClass = FlowField;
        }
        field(5; Status; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(6; "Effective Date"; Date)
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
        key(Key1; "Project Code", "Eligible Amount", Grams)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

