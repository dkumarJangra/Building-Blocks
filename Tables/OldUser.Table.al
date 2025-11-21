table 80000 "Old User"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "User Id"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Full Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "User Id")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var

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