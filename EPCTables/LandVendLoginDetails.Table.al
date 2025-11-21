table 60791 "Land vendor Login Details"
{
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Name; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Search Name"; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Name 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Address; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Address 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; City; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Contact; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Phone No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Father Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Country/Region Code"; code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(84; "Fax No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(89; Picture; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(91; "Post Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";
        }
        field(92; County; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(102; "E-Mail"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(13712; "P.A.N. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(13717; "State Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = State;
        }
        field(16500; "P.A.N. Reference No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(16501; "P.A.N. Status"; enum "P.A.N.Status")
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Address 3"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Mob. No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50081; "Land Master"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70000; "Is Verified"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70001; "Company Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(70002; Profile_ImageUrl; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(70003; PAN_ImageUrl; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(70004; Aadhar_ImageUrl; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(70005; "Aadhar Back_ImageUrl"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(90030; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Provisional,Active,Inactive';
            OptionMembers = "",Provisional,Active,Inactive;
        }
        field(90032; "Date of Birth"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(90034; Sex; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Male,Female';
            OptionMembers = "",Male,Female;
        }
        field(90035; "Maritial Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Unmarried,Married,Divorced,Widow,Widower,Unknown';
            OptionMembers = "",Unmarried,Married,Divorced,Widow,Widower,Unknown;
        }
        field(90036; "Present Occupation"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(90037; Nationality; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(90100; "Associate Password"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(90126; "Registration No"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(90134; "Bank Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(90135; "Bank Address"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(90136; "Bank Address 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(90137; "Benificiary Name as per Bank"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(90138; "IFSC Code"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(90139; "MICR Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(90140; "Account Type"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(90155; "Bank Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(90158; "Aadhar No."; code[15])
        {
            DataClassification = ToBeClassified;
        }

        field(60040; "District Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'District Code';
            DataClassification = ToBeClassified;
            TableRelation = "District Details".Code where("State Code" = field("State Code"));
        }
        field(60041; "Mandal Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'Mandal Code';
            DataClassification = ToBeClassified;
            TableRelation = "Mandal Details".Code where("State Code" = field("State Code"), "District Code" = field("District Code"));
        }
        field(60042; "Village Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'Village Code';
            DataClassification = ToBeClassified;
            TableRelation = "Village Details".Code where("State Code" = field("State Code"), "District Code" = field("District Code"), "Mandal Code" = field("Mandal Code"));
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}