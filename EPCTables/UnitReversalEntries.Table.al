table 97802 "Unit Reversal Entries"
{
    Caption = 'Bond Reversal Entries';

    fields
    {
        field(1; "Document Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Application,RD,FD,MIS,BOND';
            OptionMembers = Application,RD,FD,MIS,BOND,Commission,Bonus;
        }
        field(2; "Document No."; Code[20])
        {
            Editable = false;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Application No."; Code[20])
        {
            Caption = 'Application No.';
        }
        field(5; "Unit No."; Code[20])
        {
            Caption = 'Unit No.';
            TableRelation = "Confirmed Order";
        }
        field(6; "Posted. Doc. No."; Code[20])
        {
        }
        field(7; "Posting date"; Date)
        {
        }
        field(8; "Document Date"; Date)
        {
        }
        field(9; "User ID"; Code[20])
        {
        }
        field(10; "Reverse Date"; Date)
        {
        }
        field(11; "Reverse Time"; Time)
        {
        }
        field(12; "Installment No."; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        UserSetup: Record "User Setup";
    begin
    end;
}

