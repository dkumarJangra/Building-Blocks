table 97855 "Team Incentive Summary"
{

    fields
    {
        field(1; "Incentive Application No."; Code[20])
        {
        }
        field(2; "Associate Code"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(3; "Associate Name"; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Associate Code")));
            FieldClass = FlowField;
        }
        field(4; Month; Integer)
        {
        }
        field(5; Year; Integer)
        {
        }
        field(6; "Eligible Incentive Amount"; Decimal)
        {
        }
        field(7; "TDS %"; Decimal)
        {
        }
        field(8; "TDS Amount"; Decimal)
        {
        }
        field(9; "Eligible Amount"; Decimal)
        {
        }
        field(10; "Amount Paid"; Decimal)
        {
        }
        field(11; "Remaining Amount"; Decimal)
        {
        }
        field(12; "Line No."; Integer)
        {
        }
        field(13; "Incentive No. Series"; Code[20])
        {
            Caption = 'Incentive No. Series';
            TableRelation = "No. Series";
        }
        field(14; "Detail Entry No."; Integer)
        {
        }
        field(15; Level; Integer)
        {
        }
        field(16; Sequence; Text[30])
        {
        }
        field(17; "No. of plot"; Integer)
        {
        }
        field(18; "Parent Code"; Code[20])
        {
        }
        field(20; "Including Team No. of Plot"; Integer)
        {
        }
        field(21; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center 1";
        }
        field(22; "Payable Incentive Amount"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Incentive Application No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Associate Code")
        {
        }
        key(Key3; Level)
        {
        }
        key(Key4; "Parent Code")
        {
        }
        key(Key5; Sequence, Month, Year)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Incentive Application No." = '' THEN BEGIN
            UnitSetup.GET;
            UnitSetup.TESTFIELD("Incentive No.");
            NoSeriesMgt.InitSeries(UnitSetup."Incentive Summary No.", xRec."Incentive No. Series", WORKDATE, "Incentive Application No.",
            "Incentive No. Series");
        END;
    end;

    var
        UnitSetup: Record "Unit Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

