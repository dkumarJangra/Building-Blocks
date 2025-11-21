table 97846 "Common SMS Header"
{
    DrillDownPageID = "Sales Project wise Setup Line";
    LookupPageID = "Sales Project wise Setup Line";

    fields
    {
        field(1; "Document No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Creation Date"; Date)
        {

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(3; "Creation Time"; Time)
        {

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(4; "Created By"; Code[20])
        {

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(5; Name; Text[50])
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
            OptionCaption = 'Open,Sent';
            OptionMembers = Open,Sent;
        }
        field(10; "Send SMS Date"; Date)
        {
        }
        field(11; "Send SMS Time"; Time)
        {
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

    trigger OnInsert()
    begin
        "Creation Date" := TODAY;
        "Creation Time" := TIME;
        "Created By" := USERID;
        IF User.GET(USERID) THEN
            Name := User."User Name"
        ELSE
            Name := '';
    end;

    var
        User: Record User;
}

