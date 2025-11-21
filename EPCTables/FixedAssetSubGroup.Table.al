table 97737 "Fixed Asset Sub Group"
{
    DrillDownPageID = "FA Sub Group";
    LookupPageID = "FA Sub Group";

    fields
    {
        field(1; "FA Sub Group"; Text[50])
        {
            Description = 'added by dds for FA group - new field';
        }
        field(2; "FA Code"; Code[10])
        {
        }
        field(3; Item; Text[30])
        {
            Description = 'ashish done back from 50 to 30';
        }
        field(4; Capacity; Text[30])
        {
        }
        field(5; Work; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "FA Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

