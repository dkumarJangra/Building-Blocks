table 60712 "Project Gold/Silver Voucher"
{
    DataPerCompany = false;
    Caption = 'Project wise Gold/Silver Voucher Setup';

    fields
    {
        field(1; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center 1";


        }
        field(2; "Project Name"; Text[100])
        {
            CalcFormula = Lookup("Responsibility Center 1".Name WHERE(Code = FIELD("Project Code")));
            FieldClass = FlowField;
        }

        field(10; "Gold/Silver Voucher Pmt Plan"; Text[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "App. Charge Code" where("Sub Payment Plan" = const(true));
        }
        field(11; "Gold/Silver Voucher Elg. Amt"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Gold/Silver Voucher Elegibility Amount';
        }

        field(12; "Effective Start Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(13; "Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Release,Close';
            OptionMembers = Open,Release,Close;
            Editable = False;

        }
        Field(14; "No. of Vouchers"; Decimal)
        {
            DataClassification = ToBeClassified;
        }



    }

    keys
    {
        key(Key1; "Project Code", "Effective Start Date", "Gold/Silver Voucher Pmt Plan")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        GoldCoinLine: Record "Gold Coin Line";
}

