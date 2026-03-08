table 60821 "Lead Team HeadAssHierarchy"
{
    Caption = 'Lead Team Head Assoicate Hierarchy Data';
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
        Field(3; "Region Code"; Code[10])
        {

        }
        Field(4; "Team Head ID"; code[20])
        {

        }
    }

    keys
    {
        key(Key1; "No.", "Region Code")
        {
        }
    }


}

