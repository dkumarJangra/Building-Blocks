table 60690 "Top Head Details A1"
{

    fields
    {
        field(1; "Associate Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Name; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Associate Code")));
            FieldClass = FlowField;
        }
        field(3; "Team Head"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Team Head Name"; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Team Head")));
            FieldClass = FlowField;
        }
        field(5; "Rank Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Team Code"; Code[50])
        {
            CalcFormula = Lookup(Vendor."BBG Team Code" WHERE("No." = FIELD("Team Head")));
            FieldClass = FlowField;
        }
        field(7; "Team Name"; Text[50])
        {
            CalcFormula = Lookup("Team Master"."Team Name" WHERE("Team Code" = FIELD("Team Code")));
            FieldClass = FlowField;
        }
        field(8; Msg; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "New Team Head"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Associate Code", "Rank Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

