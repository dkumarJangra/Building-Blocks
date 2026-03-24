table 50575 "Whatsup Integration Setup"
{

    fields
    {
        field(1; "Primary Key"; Guid)
        {
        }
        field(2; "User Name"; Text[250])
        {
        }
        field(3; Password; Text[250])
        {
        }
        field(4; Mobile; Text[30])
        {
        }
        field(5; "API Key"; Text[250])
        {
        }
        field(6; Header; Text[100])
        {
        }
        field(7; "Header 2"; Text[100])
        {
        }
        field(8; "Header Value"; Text[100])
        {
        }
        field(9; "Header Value 2"; Text[100])
        {
        }
        field(10; "API URL"; Text[250])
        {
        }
        field(11; "API URL Mobile Number"; Text[100])
        {
        }
        field(12; Method; Text[50])
        {
        }
        field(13; "File Path"; Text[100])
        {
        }
        field(14; "API URL2"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

