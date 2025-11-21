table 97875 "Online Associate Login Details"
{
    DataPerCompany = false;

    fields
    {
        field(1; USER_ID; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Mobile_ No"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; Password; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; Associate_ID; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Vendor;
        }
        field(5; "Device ID"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; Rank_Code; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; Status; Option)
        {
            DataClassification = ToBeClassified;
            Editable = true;
            OptionCaption = 'Under Process,Sent for Approval,Approved,Reject';
            OptionMembers = "Under Process","Sent for Approval",Approved,Reject;
        }
        field(8; Date_OF_Birth; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; Address; Text[200])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; City; Text[30])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
            Editable = false;
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(14; Post_Code; Code[20])
        {
            Caption = 'Post Code';
            DataClassification = ToBeClassified;
            Editable = false;
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(15; PAN_No; Code[20])
        {
            Caption = 'P.A.N. No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(16; Introducer_Code; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(17; Date_OF_Joining; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(18; Of_User_ID; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(19; Parent_ID; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(20; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(21; "NAV-Associate Created"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(22; "NAV-Associate Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(23; "Is Active"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(24; "Send for Associate Create"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Vendor Profile Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Open,Close';
            OptionMembers = " ",Open,Close;
        }
        field(26; "Send for Profile Update"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(27; "Identity No."; Code[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(28; Designation; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(29; "Father Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(30; Age; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(31; Occupation; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(32; "Wedding Anniversary"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(33; "Email-Id"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(34; "Nominee Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(35; RelationShip; Text[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(36; "Nominee Age"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(37; "Telephone No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(38; "Mobile No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(39; "Sponsor Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(40; "Sponsor Id"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(41; Date; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(42; Place; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(43; "Region Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(44; "Mode of Prospect Meet"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(45; "Income Level"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(46; "Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(47; "State Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(48; "Whats App No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(49; "Intersted on Participating"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50; "Preffered Day/ Time"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(51; Education; Text[60])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52; "What vehicle do you own"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(53; Gender; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(54; "Marital Status"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(55; "Presence on Social Media"; Text[60])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(56; "No of Plots you own"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(57; "Associate Creation Error"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; USER_ID)
        {
            Clustered = true;
        }
        key(Key2; "Mobile_ No")
        {
        }
    }

    fieldgroups
    {
    }
}

