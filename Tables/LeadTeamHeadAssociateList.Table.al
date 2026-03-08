table 60820 "Lead Team HeadAssociate list"
{
    Caption = 'Lead Team Head Assoicate list';
    DataPerCompany = false;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }


}

