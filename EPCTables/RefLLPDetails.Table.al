table 60755 "Ref. LLP Details"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Total Inventory"; Decimal)
        {
            CalcFormula = Sum("Ref. LLP Item Details"."Available Inventory" WHERE("Project Code" = FIELD("Project Code")));
            Editable = false;
            FieldClass = FlowField;
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

    trigger OnDelete()
    begin
        UnitMaster.RESET;
        UnitMaster.SETRANGE("Project Code", Rec."Project Code");
        IF UnitMaster.FINDFIRST THEN
            ERROR(Text0003, UnitMaster."Project Code", UnitMaster."No.");
    end;

    var
        UnitMaster: Record "Unit Master";
        Text0003: Label 'You cannot delete Ref. LLP Details, the lines are already exist.';
}

