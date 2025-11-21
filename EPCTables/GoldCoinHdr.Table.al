table 97842 "Gold Coin Hdr"
{
    DataPerCompany = false;
    LookupPageID = "Gold Coin SetupList";

    fields
    {
        field(1; "Plot Size"; Decimal)
        {
        }
        field(2; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,In-Active,Released';
            OptionMembers = Open,"In-Active",Released;
        }
    }

    keys
    {
        key(Key1; "Plot Size")
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
        GolCoinLine.RESET;
        GolCoinLine.SETRANGE(GolCoinLine."Plot Size", "Plot Size");
        IF GolCoinLine.FINDFIRST THEN
            GolCoinLine.DELETEALL;
    end;

    trigger OnInsert()
    begin
        TESTFIELD(Status, Status::Open);
    end;

    trigger OnModify()
    begin
        TESTFIELD(Status, Status::Open);
    end;

    var
        GolCoinLine: Record "Gold Coin Line";
}

