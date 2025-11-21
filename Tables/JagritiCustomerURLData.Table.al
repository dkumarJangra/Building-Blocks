table 60707 "Jagriti Customer URL Data"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Ref. Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'Jagrati Customer Reference';
        }
        field(3; "Affidavit Url"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Orignal Receipt Url"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Booking Form Url"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "New Customer pan Url"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "New Customer Adhr Url"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Customer Adhr Url"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Form Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,CustomerForm,AssociateForm,SpecialRequest';
            OptionMembers = " ",CustomerForm,AssociateForm,SpecialRequest;
        }
        field(10; "Receipt Url"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Written Letter Url"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(12; AadharUrl; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Form 32 Url"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "PAN Url"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Requisition Url"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Customer Picture Url"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Cancellation Form Url"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Bank Passbook Url"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Uploded Doc Link"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "PAN Proof Link"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Bank Detail Proof Link"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Aadhaar Proof Link"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Yellow Form Url"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Blue Form Url"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Other Doc Urls"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = '//111023';
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

