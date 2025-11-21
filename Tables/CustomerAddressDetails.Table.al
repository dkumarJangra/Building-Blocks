table 60751 "Customer Address Details"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Creation Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Customer ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Customer Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Customer Address"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Customer Address 2"; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = ToBeClassified;
        }
        field(8; City; Text[30])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".City
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(9; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code"
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                v_PostCode: Record "Post Code";
            begin
            end;
        }
        field(10; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(11; "Date of Birth"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(12; Sex; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Male,Female;
        }
        field(13; "Father's/Husband's Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Mobile No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Aadhar No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(16; State; Code[10])
        {
            DataClassification = ToBeClassified;
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

