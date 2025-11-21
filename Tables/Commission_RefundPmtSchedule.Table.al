table 50120 "Commision/Refund Pmt Schedule"
{
    Caption = 'Commission / Refund Payment Schedule';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Editable = false;
        }
        field(2; Type; Option)
        {

            Editable = false;
            OptionCaption = 'Commission/Incentive,Refund';
            OptionMembers = "Commission/Incentive","Refund";
        }
        field(3; "Creation Date"; Date)
        {
            Editable = false;
        }
        field(4; "Created By"; Code[50])
        {
            Editable = false;
        }
        field(5; "Application No."; Code[20])
        {

            Editable = false;
        }
        field(6; "Associate ID"; Code[20])
        {
            Editable = false;
            TableRelation = Vendor."No.";

        }
        field(7; "Associate Name"; TExt[100])
        {
            Editable = false;
        }
        field(8; "Team Name"; Code[50])
        {
            Editable = false;

        }
        field(9; "Team Head ID"; Code[20])
        {
            Editable = false;
            TableRelation = Vendor."No.";


        }
        field(10; "Team Head Name"; TExt[100])
        {
            Editable = false;

        }
        field(11; "Total Amount"; Decimal)
        {
            Editable = false;
        }
        field(12; "Scheduled Amount"; Decimal)
        {
            Editable = false;
        }
        field(13; "Scheduled Date"; Date)
        {

        }
        field(14; "Completed Date"; Date)
        {
            Editable = false;
        }
        field(15; "Status"; Option)
        {
            OptionCaption = 'Pending,Completed,Rejected';
            OptionMembers = "Pending","Completed","Rejected";
            Editable = false;
        }
        field(16; "Comment"; Text[500])
        {
        }
        field(17; "Last modify By"; Code[50])
        {
            Editable = False;
        }
        field(18; "Last modify DateTime"; DateTime)
        {
            Editable = False;
        }

    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Scheduled Date")
        {

        }
    }

    fieldgroups
    {
    }
}

