table 50082 "BBG Tax Rate Buffer"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "TDS Section"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Assessee Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Effective Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "TDS %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "NON PAN TDS %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "PAN/NON PAN"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Entry ID"; Guid)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry ID")
        {
            Clustered = true;
        }
        Key(Key2; "TDS Section", "Effective Date", "Assessee Code")
        {

        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;



    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}