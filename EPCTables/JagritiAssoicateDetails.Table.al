table 60701 "Jagriti Assoicate Details"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Request No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Requester ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Mobile No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "P.A.N. No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Month; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Associate Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Direct/Team Bonanza Selection"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "if Direct Applications"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Customer Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Selection Type"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "From Associate ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "To Associate ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Upload Document"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Aadhar Card No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Bank Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Bank Account No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Bank IFSC Code"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Request Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,,,,,,,,,IBA Enquiry,Associate ID Activation,Sales ID Change,Associate Bank Update,Enquiry,Bonanza,OTHER,LINK DOCUMENTS REQUEST';
            OptionMembers = " ","GOLD / SILVER","CHANGE OF PAYMENT OPTION","RE-ALLOT / CHANGE OF PLOT","FUND TRANSFER","PLOT CANCELLATION / REFUND","CUSTOMER CORRECTIONS / RECTIFICATIONS","PLOT REGISTRATION","SITE DEVELOPMENT","IBA Enquiry","Associate ID Activation","Sales ID Change","Associate Bank Update",Enquiry,Bonanza,OTHER,"LINK DOCUMENTS REQUEST","Special Plot Change","Special Option Change","Special Gold/Silver","Special Loan Files Price Update";
        }
        field(19; "Reporting Leader"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Site Code"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,South-HYD,East-HYD,West-HYD,VIZAG,Amaravati,Warangal,Khammam,Karimnagar,Kurnool,Nellore,Mahabub Nagar';
            OptionMembers = " ","South-HYD","East-HYD","West-HYD",VIZAG,Amaravati,Warangal,Khammam,Karimnagar,Kurnool,Nellore,"Mahabub Nagar";
        }
        field(21; "Request Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Request Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "IBA ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "IBA Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Associate Id to Activate"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Associate Id to Activate Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "No. of Team Bonanza"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Extent Value"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Request 1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Request 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(34; "Request 3"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Request 4"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Request in blob"; BLOB)
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Request 5"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(38; "Request 6"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(39; "Request 7"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Team Code"; Code[50])
        {
            FieldClass = Normal;
        }
        field(41; "Leader Code"; Code[20])
        {
            CalcFormula = Lookup(Vendor."BBG Leader Code" WHERE("No." = FIELD("Requester ID")));
            FieldClass = FlowField;
        }
        field(42; "Sub Team Code"; Code[20])
        {
            CalcFormula = Lookup(Vendor."BBG Sub Team Code" WHERE("No." = FIELD("Requester ID")));
            FieldClass = FlowField;
        }
        field(43; "Request Status"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(44; "Request Pending From"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Help desk Id"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(51; "First Approval / Reject Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(52; "First Approval / Reject Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(53; "Last Approval / Reject Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(54; "Last Approval / Reject Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(55; "Other Associate Id"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '111023';
        }
        field(92; Remarks; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(94; "Remarks 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(95; "Special Request Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = '//111023';
            Editable = false;
            OptionCaption = ' ,Plot Change,Option Change,Gold/Silver,Loan Files Price Update';
            OptionMembers = " ","Plot Change","Option Change","Gold/Silver","Loan Files Price Update";
        }
        field(96; "Special Request"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Request No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

