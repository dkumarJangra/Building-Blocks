table 60704 "Jagriti Assoc Approval Details"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Reporing Leader ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Reporing Leader Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Reporing Leader E-mail ID"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Team Head ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Team Head Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Team Head E-Mail ID"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Reporing Leader ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Vendor: Record Vendor;
}

