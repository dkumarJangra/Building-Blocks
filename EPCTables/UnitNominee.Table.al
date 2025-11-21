table 97799 "Unit Nominee"
{

    fields
    {
        field(1; "Unit No."; Code[20])
        {
            Caption = 'Unit No.';
        }
        field(2; "No."; Integer)
        {
            Caption = 'No.';
        }
        field(3; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(4; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(5; Address; Text[100])
        {
            Caption = 'Address';
        }
        field(6; "Address 2"; Text[100])
        {
            Caption = 'Address 2';
        }
        field(7; City; Text[100])
        {
            Caption = 'City';
        }
        field(8; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
        }
        field(9; Title; Option)
        {
            Caption = 'Title';
            OptionCaption = 'Mr,Mrs,Miss';
            OptionMembers = Mr,Mrs,Miss;
        }
        field(10; Age; Decimal)
        {
            Caption = 'Age';
        }
        field(11; Relation; Text[50])
        {
            Caption = 'Relationship with First/Sole Applicant';
        }
        field(12; Gender; Option)
        {
            Caption = 'Gender';
            OptionCaption = 'Male,Female';
            OptionMembers = Male,Female;
        }
        field(13; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Active,Inactive';
            OptionMembers = Active,Inactive;
        }
    }

    keys
    {
        key(Key1; "Unit No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

