table 50046 "Payment transaction Details"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "New Confirmed Order";
        }
        field(3; "Member Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Associate Id"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Payment Server Status"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Transaction Status"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Payment Server Status Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Payment Server Status Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "Transaction Status Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; "Transaction Status Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "Payment Transaction No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Unique Payment Order ID"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Plot ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Master";
        }
        field(14; "Project ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center 1";
        }
        field(15; "Unit Payment Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Payment Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Mobile No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Member Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Member Name 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Date of Birth"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(21; User_ID; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Receipt Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Document Create In NAV"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(24; "Send Payment Link"; Text[10])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Member Father Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Address 1"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Address 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Address 3"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Pin Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Allotment Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Booking Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Unit Sink"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Application Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,New,Old';
            OptionMembers = " ",New,Old;
        }
        field(34; "Payment Server Error"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(35; "Payment Signature"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(36; "Payment ID"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(37; "Is Active for Payment"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(38; "Payment Duration Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(39; "Error Log"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(44; "Mode of Prospect Meet"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(45; "Income Level"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(46; "Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(47; "State Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(48; "Whats App No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(49; "Do you own your own house"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Preffered Day/ Time"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(51; Education; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(52; "What vehicle do you own"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(53; Gender; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(54; "Marital Status"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(55; "Presence on Social Media"; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(56; "No of Plots you own"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(57; "Area"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(58; "Member E-mail"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(59; "Site Visit"; Text[10])
        {
            DataClassification = ToBeClassified;
        }
        field(60; "How do you know BBG"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(61; "Have you transacted with BBG"; Text[10])
        {
            DataClassification = ToBeClassified;
        }
        field(62; Occupation; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Update By Batch"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50002; "Receipt Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50037; "Payment From"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Benepay';
            OptionMembers = " ",Benepay;
        }
        field(50038; "Loan File"; Text[5])   //251124 New field
        {
            DataClassification = ToBeClassified;
        }


        field(50039; "BENPAY Payment Response"; Text[1000])   //251124 New field
        {
            DataClassification = ToBeClassified;
        }

        field(50040; "District Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'District Code';
            DataClassification = ToBeClassified;
            TableRelation = "District Details".Code where("State Code" = field("State Code"));
            Editable = False;
        }
        field(50041; "Mandal Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'Mandal Code';
            DataClassification = ToBeClassified;
            TableRelation = "Mandal Details".Code where("State Code" = field("State Code"), "District Code" = field("District Code"));
            Editable = False;
        }
        field(50042; "Village Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'Village Code';
            DataClassification = ToBeClassified;
            TableRelation = "Village Details".Code where("State Code" = field("State Code"), "District Code" = field("District Code"), "Mandal Code" = field("Mandal Code"));
            Editable = False;
        }
        field(50044; "Aadhaar No."; Code[15])
        {
            Caption = 'Aadhaar No.';
            DataClassification = ToBeClassified;
            Editable = False;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Receipt Posting Date")
        {
        }
        key(Key3; "Unique Payment Order ID")
        {
        }
    }

    fieldgroups
    {
    }
}

