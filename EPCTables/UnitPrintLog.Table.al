table 97796 "Unit Print Log"
{

    fields
    {
        field(1; "Unit No."; Code[20])
        {
            Caption = 'Unit No.';
            TableRelation = "Confirmed Order";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(2; "Report Type"; Option)
        {
            Caption = 'Report Name';
            OptionCaption = 'Acknowledgement,Certificate,Commission,Debit Voucher Printed,Discharge Form';
            OptionMembers = Acknowledgement,Certificate,Commission,"Debit Voucher Printed","Discharge Form";
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "User ID"; Code[20])
        {
            Caption = 'User ID';
            NotBlank = true;
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(6; Date; Date)
        {
            Caption = 'Date';
        }
        field(7; Description; Text[250])
        {
        }
        field(8; "Printing Status"; Option)
        {
            OptionCaption = 'Printed,Reprinted,Duplicate,Assigned,Reassigned';
            OptionMembers = Printed,Reprinted,Duplicate,Assigned,Reassigned;
        }
        field(9; Time; Time)
        {
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

