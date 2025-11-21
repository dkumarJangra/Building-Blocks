tableextension 50086 "BBG Workflow User Group Ext" extends "Workflow User Group"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Approval Limit Exists"; Decimal)
        {
            CalcFormula = Max("Workflow User Group Member"."Approval Amount Limit" WHERE("Workflow User Group Code" = FIELD(Code)));
            Description = 'EPC2016';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}