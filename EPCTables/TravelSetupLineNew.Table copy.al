table 50440 "Travel Setup Line New"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Associate Code"; Code[20])
        {
            Editable = false;
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                //CheckStatus;
            end;
        }
        field(2; "Effective Date"; Date)
        {
            Editable = false;

            trigger OnValidate()
            begin
                //CheckStatus;
            end;
        }
        field(3; "Project Code"; Code[20])
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
                        VALIDATE("Branch Code");
                    END;
                    "User ID" := USERID;
                    "Creation Date" := TODAY;
                END ELSE
                    "Project Name" := '';
            end;
        }
        field(4; Rate; Decimal)
        {

            trigger OnValidate()
            begin
                CheckStatus;

                IF "TA Code" <> '' THEN BEGIN
                    TravelHeader.RESET;
                    TravelHeader.SETRANGE("Top Person", "Associate Code");
                    TravelHeader.SETRANGE("ARM TA Code", "TA Code");
                    IF TravelHeader.FINDFIRST THEN
                        ERROR('You have already created many Entries');
                END;

                TravelSetupline.RESET;
                TravelSetupline.SETRANGE("Associate Code", "Associate Code");
                TravelSetupline.SETRANGE("Effective Date", "Effective Date");
                TravelSetupline.SETFILTER("TA Code", '<>%1', '');
                TravelSetupline.SETRANGE(Rate, Rate);
                IF TravelSetupline.FINDFIRST THEN
                    "TA Code" := TravelSetupline."TA Code"
                ELSE
                    "TA Code" := '';


                Vendor.RESET;
                IF Vendor.GET("Associate Code") THEN BEGIN
                    IF Vendor."BBG Vendor Category" = Vendor."BBG Vendor Category"::"CP(Channel Partner)" THEN
                        "New Region / Rank Code" := Vendor."Sub Vendor Category";  //02062025 Code Added
                    //"New Region / Rank Code" := 'R0003';  //02062025 Code commented
                END;
            end;
        }
        field(5; "Branch Code"; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin
                CheckStatus;
                IF "Branch Code" <> '' THEN BEGIN
                    IF Loc.GET("Branch Code") THEN
                        "Branch Name" := Loc.Name
                    ELSE
                        "Branch Name" := '';
                END ELSE
                    "Branch Name" := '';
            end;
        }
        field(6; "Project Name"; Text[60])
        {
            Editable = false;
        }
        field(7; "Branch Name"; Text[60])
        {
            Editable = false;
        }
        field(8; "Creation Date"; Date)
        {
            Editable = false;
        }
        field(9; "User ID"; Code[20])
        {
            Editable = false;
        }
        field(10; "TA Code"; Code[20])
        {
            Description = 'BBG1.2 191213';
            Editable = false;
        }
        field(11; "End Date"; Date)
        {
            Description = 'BBG1.2 191213';
            Editable = false;
        }
        field(12; TempEnd; Date)
        {
        }

        field(14; "New Region / Rank Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Rank Code Master";
        }
    }

    keys
    {
        key(Key1; "Associate Code", "Effective Date", "Project Code", "New Region / Rank Code")
        {
            Clustered = true;
        }
        key(Key2; "Project Code")
        {
        }
        key(Key3; "Associate Code", "Effective Date", Rate)
        {
        }
        key(Key4; "TA Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        CheckStatus;
    end;

    trigger OnModify()
    begin
        CheckStatus;
    end;

    var
        DimValue: Record "Dimension Value";
        LedgerSsetup: Record "General Ledger Setup";
        Loc: Record Location;
        Resp: Record "Responsibility Center 1";
        TravelSetuHdr: Record "Travel Setup Header";
        TravelPaymentDetails: Record "Travel Payment Details";
        TravelHeader: Record "Travel Header";
        TravelSetupline: Record "Travel Setup Line New";
        Vendor: Record Vendor;


    procedure CheckStatus()
    begin
        IF TravelSetuHdr.GET("Associate Code", "Effective Date") THEN
            TravelSetuHdr.TESTFIELD(Status, TravelSetuHdr.Status::Open);
        "End Date" := TravelSetuHdr."End Date";
    end;
}

