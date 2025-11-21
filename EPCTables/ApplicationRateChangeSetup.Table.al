table 50060 "Application Rate Change Setup"
{

    fields
    {
        field(1; "Project Code"; Code[20])
        {
            TableRelation = "Responsibility Center 1".Code;
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Payment Option"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,A,B,C';
            OptionMembers = " ",A,B,C;
        }
        field(4; "No. of Days"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Active,In-Active';
            OptionMembers = Active,"In-Active";
        }
    }

    keys
    {
        key(Key1; "Project Code", "Payment Option")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE(UserSetup."User ID", USERID);
        UserSetup.SETRANGE("Aplication Option Setup Create", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');
    end;

    trigger OnModify()
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE(UserSetup."User ID", USERID);
        UserSetup.SETRANGE("Aplication Option Setup Create", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');
    end;

    var
        UserSetup: Record "User Setup";
}

