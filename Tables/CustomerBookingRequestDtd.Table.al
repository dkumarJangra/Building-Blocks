table 60752 "Customer Booking Request Dtd."
{

    fields
    {
        field(1; "Request No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; Time; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Customer ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Customer Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Associate Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Associate Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Plot Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Project Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Project Nam"; Text[50])
        {
            FieldClass = Normal;
        }
        field(11; "USER ID"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(12; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Pending,booked,rejected';
            OptionMembers = Pending,booked,rejected;
        }
        field(13; Comments; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Request No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

