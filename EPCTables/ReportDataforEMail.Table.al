table 50023 "Report Data for E-Mail"
{

    fields
    {
        field(1; "Report ID"; Integer)
        {
        }
        field(2; "Associate Code"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(3; "Report Name"; Text[50])
        {
        }
        field(4; "E-Mail Send"; Boolean)
        {
            Editable = true;
        }
        field(5; "Error Message"; Text[250])
        {
        }
        field(6; "Report Run Date"; Date)
        {
        }
        field(7; "Report Run Time"; Time)
        {
        }
        field(8; "E_Mail Send Error Message"; Text[250])
        {
        }
        field(9; "E_Mail Send Error"; Boolean)
        {
        }
        field(10; "Report Batch No."; Code[20])
        {
        }
        field(11; "Entry No."; Integer)
        {
        }
        field(12; "Report Type"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for mobile report request';
            Editable = false;
        }
        field(13; "Request from Mobile"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Use for mobile report request';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

