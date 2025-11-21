table 97743 "Report Signature Selections"
{
    DrillDownPageID = "Report Sign. Selection List";
    LookupPageID = "Report Sign. Selection List";

    fields
    {
        field(1; "Report ID"; Integer)
        {
            Caption = 'Report ID';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Report));

            trigger OnValidate()
            begin
                CALCFIELDS("Report Name");
            end;
        }
        field(2; "Report Name"; Text[249])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Report),
                                                                           "Object ID" = FIELD("Report ID")));
            Caption = 'Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; Signature; BLOB)
        {
        }
    }

    keys
    {
        key(Key1; "Report ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

