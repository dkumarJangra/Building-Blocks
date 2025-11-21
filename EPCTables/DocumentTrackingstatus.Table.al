table 97726 "Document Tracking status"
{
    Caption = 'Document Tracking status';
    DrillDownPageID = "Tracking Status List";
    LookupPageID = "Tracking Status List";

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "Update Versions"; Boolean)
        {
        }
        field(4; "Generate Transmittal Nos"; Boolean)
        {
        }
        field(5; "Table ID"; Integer)
        {
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Table));
        }
    }

    keys
    {
        key(Key1; "Table ID", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

