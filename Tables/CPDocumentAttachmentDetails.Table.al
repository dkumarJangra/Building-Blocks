table 60797 "CP Document Attachment Details"
{

    fields
    {
        field(1; "Lead Id"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "PAN URL"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Aadhar URL"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Profile URL"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "PF URL"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "Bank URL"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; "GST URL"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "RERA URL"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; "ESI URL"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "MOU URL"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Cheque URL"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(16; "Membership Number"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(17; "membership Image Url"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(18; "Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; "Membership of association"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,CREDAI,TREDA,RERA,Other';
            OptionMembers = "",CREDAI,TREDA,RERA,Other;
        }

    }

    keys
    {
        key(Key1; "Lead Id", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


}

