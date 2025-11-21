table 60703 "Jagriti Document Email setup"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Request Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,GOLD / SILVER,CHANGE OF PAYMENT OPTION,RE-ALLOT / CHANGE OF PLOT,FUND TRANSFER,PLOT CANCELLATION / REFUND,CUSTOMER CORRECTIONS / RECTIFICATIONS,PLOT REGISTRATION,SITE DEVELOPMENT,IBA Enquiry,Associate ID Activation,Sales ID Change,Associate Bank Update,Enquiry,Bonanza,OTHER,LINK DOCUMENTS REQUEST';
            OptionMembers = " ","GOLD / SILVER","CHANGE OF PAYMENT OPTION","RE-ALLOT / CHANGE OF PLOT","FUND TRANSFER","PLOT CANCELLATION / REFUND","CUSTOMER CORRECTIONS / RECTIFICATIONS","PLOT REGISTRATION","SITE DEVELOPMENT","IBA Enquiry","Associate ID Activation","Sales ID Change","Associate Bank Update",Enquiry,Bonanza,OTHER,"LINK DOCUMENTS REQUEST";
        }
        field(2; "E-mail ID 1"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "E-mail ID 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "E-mail ID 3"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "E-mail ID 4"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "E-mail ID 5"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "E-mail ID 6"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

