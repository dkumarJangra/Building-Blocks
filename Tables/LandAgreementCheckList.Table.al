table 50057 "Land Agreement Check List"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Description 2"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Table No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Master Setup"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Document Uploaded"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Submission Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Approval Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Assigned To"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(11; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Hold,WIP,Complete';
            OptionMembers = Open,Hold,WIP,Complete;
        }
        field(12; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Begin,End';
            OptionMembers = " ","Begin","End";
        }
        field(13; "From Land Master"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

