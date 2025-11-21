table 50027 "Sales Project Wise Setup Hdr"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Project Code"; Code[20])
        {
            TableRelation = "Responsibility Center 1";
        }
        field(2; "User ID"; Code[20])
        {
            Editable = false;
        }
        field(3; "Creation Date"; Date)
        {
            Editable = false;
        }
        field(4; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
    }

    keys
    {
        key(Key1; "Project Code")
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
        "User ID" := USERID;
        "Creation Date" := TODAY;
    end;
}

