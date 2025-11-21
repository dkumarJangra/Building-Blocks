table 97815 Rank
{
    DataPerCompany = false;
    DrillDownPageID = "Rank List";
    LookupPageID = "Rank List";

    fields
    {
        field(1; "Code"; Decimal)
        {
        }
        field(2; Description; Text[30])
        {
        }
        field(3; "Direct Entry"; Boolean)
        {
        }
        field(4; "Min. Direct Join"; Integer)
        {
        }
        field(5; Status; Option)
        {
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
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
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Allow User Setup Modify", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');
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
        UserSetup: Record "User Setup";
}

