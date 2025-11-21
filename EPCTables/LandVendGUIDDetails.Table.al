table 60793 "Land Vendor_GUID Details"
{
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; Token_ID; Guid)
        {
            DataClassification = ToBeClassified;
        }
        field(2; User_ID; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Is Active"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Token_ID)
        {
            Clustered = true;
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