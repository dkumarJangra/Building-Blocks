table 97826 "Gold Coin Line"
{
    DataPerCompany = false;
    LookupPageID = "Gold Coin List";

    fields
    {
        field(1; "Project Code"; Code[20])
        {
            TableRelation = "Responsibility Center 1";

            trigger OnValidate()
            begin
                CheckStatus;

                LedgerSsetup.GET;
                IF "Project Code" <> '' THEN BEGIN
                    IF DimValue.GET(LedgerSsetup."Global Dimension 1 Code", "Project Code") THEN
                        "Project Name" := DimValue.Name
                    ELSE
                        "Project Name" := '';

                    IF Resp.GET("Project Code") THEN BEGIN
                        "Branch Code" := Resp.Branch;
                        IF Loc.GET("Branch Code") THEN
                            "Branch Name" := Loc.Name
                        ELSE
                            "Branch Name" := '';
                    END;
                    "User ID" := USERID;
                    "Creation Date" := TODAY;


                END;
            end;
        }
        field(2; "Effective Date"; Date)
        {

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(3; "Due Days"; DateFormula)
        {

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(4; "Min. No. of Gold Coins"; Integer)
        {

            trigger OnValidate()
            begin
                CheckStatus;
                TESTFIELD("Effective Date");
            end;
        }
        field(5; "Item Code"; Code[20])
        {
            TableRelation = Item;

            trigger OnValidate()
            begin
                CheckStatus;
                IF "Item Code" <> '' THEN
                    IF Item.GET("Item Code") THEN
                        "Item Description" := Item.Description;
            end;
        }
        field(6; "Item Description"; Text[60])
        {
        }
        field(7; "No. of Gold Coins on Full Pmt."; Integer)
        {

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(8; "No. of Extra Coins"; Integer)
        {

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(9; "Plot Size"; Decimal)
        {
            Editable = false;
            TableRelation = "Gold Coin Hdr"."Plot Size";

            trigger OnValidate()
            begin
                //CheckStatus;
            end;
        }
        field(50000; "Due Days for Min. Gold Coin"; DateFormula)
        {
            Description = 'BBG 161012';

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(50006; "Branch Code"; Code[20])
        {

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(50007; "Project Name"; Text[60])
        {
            Editable = false;
        }
        field(50008; "Branch Name"; Text[60])
        {
            Editable = false;
        }
        field(50009; "Creation Date"; Date)
        {
            Editable = false;
        }
        field(50010; "User ID"; Code[20])
        {
            Editable = false;
        }
        field(50011; "No. of Silver Coins on Reg."; Integer)
        {

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
    }

    keys
    {
        key(Key1; "Plot Size", "Project Code", "Effective Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Item: Record Item;
        Vend: Record Vendor;
        GoldHdr: Record "Gold Coin Hdr";
        DimValue: Record "Dimension Value";
        LedgerSsetup: Record "General Ledger Setup";
        Loc: Record Location;
        Resp: Record "Responsibility Center 1";


    procedure CheckStatus()
    var
        GoldHdr: Record "Gold Coin Hdr";
    begin
        IF GoldHdr.GET("Plot Size") THEN
            GoldHdr.TESTFIELD(Status, GoldHdr.Status::Open);
    end;
}

