table 60794 "Land Vendor Attachment Details"
{
    Caption = 'Land Vendor Attachment Details';

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Land Agreement No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Survey number"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Khata number"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "PPB number"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Land document"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Link document"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Revenue Records"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Others document"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Vendor No.", "Land Agreement No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

