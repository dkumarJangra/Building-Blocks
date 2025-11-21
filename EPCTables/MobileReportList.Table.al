table 60699 "Mobile Report List"
{

    fields
    {
        field(1; "Report ID"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Report Name"; Text[30])
        {
            FieldClass = Normal;
        }
        field(3; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Allow Report on Mobile"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Date Filters Required"; Boolean)
        {
            DataClassification = ToBeClassified;
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

    trigger OnInsert()
    begin
        "Document Date" := TODAY;
        "Allow Report on Mobile" := TRUE;
    end;

    var
    //Objects: Record 2000000001;
}

