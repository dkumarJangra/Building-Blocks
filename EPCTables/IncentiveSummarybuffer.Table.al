table 97854 "Incentive Summary  buffer"
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
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; Month; Integer)
        {
        }
        field(5; Year; Integer)
        {
        }
        field(6; "Plot Incentive Amount"; Decimal)
        {
        }
        field(7; "TDS %"; Decimal)
        {
        }
        field(8; "TDS Amount"; Decimal)
        {
        }
        field(9; "Plot Eligible Amount"; Decimal)
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
        field(15; "Saleable Area"; Decimal)
        {
        }
        field(16; "Extent Incentive Amount"; Decimal)
        {
        }
        field(17; "Extent Eligible Amount"; Decimal)
        {
        }
        field(18; Status; Option)
        {
            OptionCaption = 'Open,Posted,Deleted';
            OptionMembers = Open,Posted,Deleted;
        }
        field(19; Type; Option)
        {
            OptionMembers = " ",Direct,Team;
        }
        field(50000; Level; Integer)
        {
        }
        field(50001; Sequence; Text[30])
        {
        }
        field(50002; "No. of plot"; Integer)
        {
        }
        field(50003; "Parent Code"; Code[20])
        {
        }
        field(50004; "Including Team No. of Plot"; Integer)
        {
        }
        field(50005; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center 1";
        }
        field(50006; "Payable Incentive Amount"; Decimal)
        {
        }
        field(50007; "Ready for Payment"; Boolean)
        {
        }
        field(50008; "Calculation Type"; Option)
        {
            OptionCaption = 'Number Wise,Extent Wise';
            OptionMembers = "Number Wise","Extent Wise";
        }
        field(50009; "Including Team No. of Extent"; Decimal)
        {
        }
        field(50010; "Incentive Scheme"; Code[20])
        {
            TableRelation = "Incentive Header";
        }
        field(50011; "Voucher No."; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Incentive Application No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; Sequence, Month, Year, Type)
        {
        }
        key(Key3; "Associate Code", Month, Year, "Calculation Type", Type)
        {
        }
        key(Key4; "Parent Code")
        {
        }
        key(Key5; "Incentive Scheme", "Associate Code", "Calculation Type", Month, Year, Type)
        {
        }
        key(Key6; "Incentive Scheme", Sequence, Month, Year, Type)
        {
        }
        key(Key7; "Voucher No.")
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
            UnitSetup.TESTFIELD("Incentive Summary No.");
            NoSeriesMgt.InitSeries(UnitSetup."Incentive Summary No.", xRec."Incentive No. Series", WORKDATE, "Incentive Application No.",
             "Incentive No. Series");
        END;
    end;

    var
        UnitSetup: Record "Unit Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

