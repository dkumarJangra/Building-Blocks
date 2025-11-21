table 50080 "SMS Log Details"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "SMS Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "SMS Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Message; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Message 1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Party Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Customer,Vendor';
            OptionMembers = " ",Customer,Vendor;
        }
        field(8; "Party Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Party Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Function/activity name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "User Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Project ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Project Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "LLP Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
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

