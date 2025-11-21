table 97828 "Unit Charge & Payment Pl. Code"
{
    // //ALLETDK081112--Added new field "ExcessGroup"

    DataPerCompany = false;
    LookupPageID = "BSP Charge List";

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[60])
        {
        }
        field(3; Type; Option)
        {
            OptionMembers = "Charge Type","Payment Plan",Unit;
        }
        field(4; ExcessCode; Boolean)
        {
        }
        field(5; "Priority Booking Code"; Boolean)
        {
            Description = 'BBG1.00 120413';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; Type)
        {
        }
    }

    fieldgroups
    {
    }
}

