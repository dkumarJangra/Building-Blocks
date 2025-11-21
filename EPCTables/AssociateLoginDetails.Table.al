table 50041 "Associate Login Details"
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
            Editable = true;

            trigger OnValidate()
            begin
                TESTFIELD("NAV-Associate Created", FALSE);
            end;
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

            trigger OnValidate()
            begin
                TESTFIELD("NAV-Associate Created", FALSE);
            end;
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
        field(50001; "Send Data to Pathsala"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50002; "Address Proof Type"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50003; "Data Come From"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,CRM';
            OptionMembers = " ",CRM;
        }
        field(50004; "Reporting Office"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50005; "New Cluster Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(70100; "Vendor Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,CP(Channel Partner)';
            OptionMembers = " ","CP(Channel Partner)";
        }
        field(90116; "Communication Address"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90117; "Communication Address 2"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90118; "CP Designation"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
            OptionCaption = ' ,Firm,Platinum,Gold,Silver';
            OptionMembers = " ",Firm,Platinum,Gold,Silver;
        }
        field(90124; "Membership of association"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
            OptionCaption = ' ,CREDAI,TREDA,RERA,Other';
            OptionMembers = " ",CREDAI,TREDA,RERA,Other;
        }
        field(90125; "Membership Number"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90126; "Registration No"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90127; "Expiry date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90128; "ESI NO"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90129; "PF No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90130; "Communication City"; Text[30])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(90131; "Communication State Code"; Code[10])
        {
            Caption = 'State Code';
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
            TableRelation = State;
        }
        field(90132; "Communication Post Code"; Code[20])
        {
            Caption = 'Communication Post Code';
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnValidate()
            var
                v_PostCode: Record "Post Code";
            begin
            end;
        }
        field(90133; "GST Registration No."; Code[15])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90134; "Bank Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90135; "Bank Address"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90136; "Bank Address 2"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90137; "Benificiary Name as per Bank"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90138; "IFSC Code"; Code[20])
        {
            Caption = 'SWIFT Code';
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90139; "MICR Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90140; "Account Type"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90141; "Aadhaar URL OtherSide"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
            Editable = false;
        }
        field(90142; "GST URL"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90143; "GST URL -2"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90144; "Bank Account URL"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90145; "ESI No URL"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90146; "PF No URL"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90147; "RERA Reg. No URL"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90148; "RERA Reg. No URL - 2"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90149; "RERA Reg. No URL - 3"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90150; "RERA Reg. No URL - 4"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90151; "RERA Reg. No URL - 5"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90152; "Entity Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
            OptionCaption = ' ,individual,sales propritorship,partenership firm,LLP,public limited,private Limited,other any';
            OptionMembers = " ",individual,"sales propritorship","partenership firm",LLP,"public limited","private Limited","other any";
        }
        field(90153; "CP Team Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
            TableRelation = "CP Team Master"."Team Code";
        }
        field(90154; "CP Leader Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
            TableRelation = "CP Leader Master"."Leader Code";
        }
        field(90155; "Bank Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90156; "Firm Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Channel Partner';
        }
        field(90157; "Region/Districts Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Region/Districts Code';
        }
        field(90158; "District Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'District Code';
            DataClassification = ToBeClassified;
            TableRelation = "District Details".Code where("State Code" = field("State Code"));
            Editable = false;
        }
        field(90159; "Mandal Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'Mandal Code';
            DataClassification = ToBeClassified;
            TableRelation = "Mandal Details".Code where("State Code" = field("State Code"), "District Code" = field("District Code"));
            Editable = false;
        }
        field(90160; "Village Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'Village Code';
            DataClassification = ToBeClassified;
            TableRelation = "Village Details".Code where("State Code" = field("State Code"), "District Code" = field("District Code"), "Mandal Code" = field("Mandal Code"));
            Editable = false;
        }

        field(90161; "Aadhaar Number"; Text[30])
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

