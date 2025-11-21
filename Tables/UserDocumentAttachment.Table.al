table 50047 "User Document Attachment"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; USER_ID; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'PAN Card,Aadhar Card,Profile Image,Address Proof';
            OptionMembers = "PAN Card","Aadhar Card","Profile Image","Address Proof";
        }
        field(4; "Document Attachment Path"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Associate ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor WHERE("BBG Vendor Category" = FILTER("IBA(Associates)"));
        }
        field(6; "Document Attachment Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Document Attachment Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Document Verified"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Document Verified By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Document Verified Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Document Verified Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Aadhar Card No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Old Document Attach Path"; Text[150])
        {
            DataClassification = ToBeClassified;
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

