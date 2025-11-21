table 60694 "Customer Intraction Details"
{

    fields
    {
        field(1; "Contact No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Customer Prospect Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Call,Office Meeting,Site Visit';
            OptionMembers = " ",Call,"Office Meeting","Site Visit";
        }
        field(5; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; Duration; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Followup Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Call,Office Meeting,Site Visit';
            OptionMembers = " ",Call,"Office Meeting","Site Visit";
        }
        field(8; "Followup Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Followup Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Contact No.", "Customer Prospect Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

