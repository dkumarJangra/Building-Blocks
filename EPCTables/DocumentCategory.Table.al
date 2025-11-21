table 97772 "Document Category"
{
    // *** Matriks Doc Version 3 ***
    // By Tim Ahrentl¢v for Matriks A/S.
    // Visit www.matriks.com for news and updates.

    Caption = 'Document Category';
    DrillDownPageID = "Job Allocation";
    LookupPageID = "Job Allocation";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

