table 60674 "Gamification Details"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(2; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Individual,Team';
            OptionMembers = " ",Individual,Team;
        }
        field(3; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Recruitment,Collection,Registration,Allotment,Booking';
            OptionMembers = " ",Recruitment,Collection,Registration,Allotment,Booking;
        }
        field(4; "Associate Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "No. of Records"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(6; Sankalp; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(7; Mahasankalp; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Total Values"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Show Records"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(10; Rank; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(11; Batch; Text[30])
        {
        }
        field(12; Points; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Rate per Point"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Date of Joining"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; "Latest DOJ of Application"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(16; "Allotment Extent"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(17; "Allotment Collection"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(18; "Registration Extent"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(19; "Registration Collection"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(20; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(21; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(22; "Booking Allotment"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Booking Collection"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Booking Extent"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Batch Run Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(26; "Associate Name"; Text[50])
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(27; "Team Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document Date", Type, "Document Type", "Associate Code")
        {
            Clustered = true;
        }
        key(Key2; "Document Date", Type, "Document Type", "No. of Records")
        {
        }
        key(Key3; "Document Date", Type, "Document Type", "Total Values")
        {
        }
        key(Key4; "Document Date", Type, "Document Type", Rank)
        {
        }
        key(Key5; "Document Date", Type, "Document Type", "No. of Records", Sankalp, Mahasankalp, "Date of Joining")
        {
        }
        key(Key6; "Document Date", Type, "Document Type", "Total Values", "Latest DOJ of Application")
        {
        }
        key(Key7; "Document Date", Type, "Document Type", "No. of Records", "Allotment Extent", "Allotment Collection")
        {
        }
        key(Key8; "Document Date", Type, "Document Type", "No. of Records", "Registration Extent", "Registration Collection")
        {
        }
        key(Key9; "Document Date", Type, "Document Type", "No. of Records", "Booking Extent", "Booking Allotment", "Booking Collection")
        {
        }
    }

    fieldgroups
    {
    }
}

