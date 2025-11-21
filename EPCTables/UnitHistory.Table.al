table 97795 "Unit History"
{
    Caption = 'Bond History';

    fields
    {
        field(1; "Unit No."; Code[20])
        {
            Caption = 'Unit No.';
            Editable = false;
            TableRelation = "Confirmed Order";
            ValidateTableRelation = false;
        }
        field(2; "Line No."; Integer)
        {
            Editable = false;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(4; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(5; "Date(Today)"; Date)
        {
            Caption = 'Date';
            Editable = false;
        }
        field(6; Time; Time)
        {
            Caption = 'Time';
            Editable = false;
        }
        field(7; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            Editable = false;
            OptionCaption = 'Application,Bond';
            OptionMembers = Application,Bond;
        }
        field(8; "Entry No."; Code[20])
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(9; "Date(Workdate)"; Date)
        {
            Editable = true;
        }
    }

    keys
    {
        key(Key1; "Unit No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

