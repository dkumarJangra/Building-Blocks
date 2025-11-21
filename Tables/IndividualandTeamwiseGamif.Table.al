table 60731 "Individual and Team wise Gamif"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Allotment,Collection,Recruitment,Registration';
            OptionMembers = " ",Allotment,Collection,Recruitment,Registration;
        }
        field(2; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Associat Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Collection Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Leader Code"; Code[20])
        {
        }
        field(6; "Rank Code"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Team Head"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(9; Extent; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "No. of Records"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Date of Joining"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Individual,Team';
            OptionMembers = Individual,Team;
        }
        field(15; Batch; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "No. of Plot Booking"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Sequence of Data"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document Type", Type, "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Extent, "Collection Amount", "Date of Joining")
        {
        }
        key(Key3; Extent, "No. of Records", "Collection Amount", "Date of Joining")
        {
        }
        key(Key4; "No. of Records", "No. of Plot Booking", "Collection Amount")
        {
        }
    }

    fieldgroups
    {
    }
}

