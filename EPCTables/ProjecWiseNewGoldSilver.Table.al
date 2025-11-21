table 60711 "Projec Wise New Gold/Silver"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center 1";

            trigger OnValidate()
            begin
                /*
                IF "Project Code" <> '' THEN BEGIN
                  GoldCoinLine.RESET;
                  GoldCoinLine.SETRANGE(GoldCoinLine."Project Code","Project Code");
                  IF GoldCoinLine.FINDFIRST THEN
                    ERROR('Gold Coin Exists against this Project Code');
                END;
                */

            end;
        }
        field(2; "Project Name"; Text[100])
        {
            CalcFormula = Lookup("Responsibility Center 1".Name WHERE(Code = FIELD("Project Code")));
            FieldClass = FlowField;
        }
        field(3; Extent; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Gold Payment Plan"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Gold Coin"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "G_Valid Days for full payment"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Silver Payment Plan"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Silver Grams"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "S_Valid Days for full payment"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }


    }

    keys
    {
        key(Key1; "Project Code")
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

