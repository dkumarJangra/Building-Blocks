table 50072 "Team_Leader wise collection_"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Associat Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Collection Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Leader Code"; Code[20])
        {
        }
        field(5; "Qualify Associate"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Associate Rank Code"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Individual Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Comulative Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Team Head"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10; Remark1; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; REmark2; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "remark 3"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Leader Code_2"; Code[20])
        {
            CalcFormula = Lookup(Vendor."BBG Leader Code" WHERE("No." = FIELD("Associat Code")));
            FieldClass = FlowField;
        }
        field(16; "Allotment Extent"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Allotment Collection Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "No. of Records"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Sub Team Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'for Recuriment Process';
        }
        field(20; "Sub Team Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'for Recuriment Process';
        }
        field(21; "Team Top Head"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Associate Leader Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Allotment,Collection,Recruitment,Registration';
            OptionMembers = " ",Allotment,Collection,Recruitment,Registration;
        }
        field(24; "Team Head DOJ"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(26; "No. of Plot Booking"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Team Head Rank Code"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Associate DOJ"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Application No.", "Associat Code", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Allotment Extent", "Allotment Collection Amount", "Team Head DOJ")
        {
        }
        key(Key3; "Allotment Extent", "Allotment Collection Amount", "Associate DOJ")
        {
        }
        key(Key4; "Document Type", "Team Head")
        {
        }
        key(Key5; "Allotment Extent", "No. of Records", "Allotment Collection Amount")
        {
        }
    }

    fieldgroups
    {
    }
}

