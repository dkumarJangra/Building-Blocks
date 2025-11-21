table 50013 "Rank Code Master"
{
    DataPerCompany = false;
    DrillDownPageID = "Region/Rank Master";
    LookupPageID = "Region/Rank  List";

    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(2; Description; Text[50])
        {

            trigger OnValidate()
            begin
                RankCode.RESET;
                RankCode.SETRANGE(RankCode."Rank Batch Code", Code);
                IF RankCode.FINDFIRST THEN
                    ERROR('Many entries already exist against this code. You can not Delete this record');
            end;
        }
        field(3; "Min Days"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Max Days"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Min. Amount"; Decimal)
        {
            Caption = 'Min. Amount For Single Plot';
            DataClassification = ToBeClassified;
        }
        field(6; Extent; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Max Amount"; Decimal)
        {
            Caption = 'Max Amount For Double Plot';
            DataClassification = ToBeClassified;
            Description = 'For 2 Plots';
        }
        field(8; "No of Days"; DateFormula)
        {
            Caption = 'No of Days For PLC Applicable';
            DataClassification = ToBeClassified;
            Description = 'For PLC Applicable';
        }
        field(9; "Other Min Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Other Max Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Other Days"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Use for CP only"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Applicable New commission Str."; Boolean)
        {
            Caption = 'Applicable New comm. Str. Amount Base';
            DataClassification = ToBeClassified;
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
        RankCode.RESET;
        RankCode.SETRANGE(RankCode."Rank Batch Code", Code);
        IF RankCode.FINDFIRST THEN
            ERROR('Many entries already exist against this code. You can not Delete this record');
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
        RankCode: Record "Rank Code";
        UserSetup: Record "User Setup";
}

