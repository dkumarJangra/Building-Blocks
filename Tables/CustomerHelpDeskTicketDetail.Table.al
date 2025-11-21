table 60750 "Customer HelpDesk TicketDetail"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Customer ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Request Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Request Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Request Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Request Description 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Request Description 3"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Request Description 4"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Customer Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,In-progress,Closed';
            OptionMembers = Open,"In-progress",Closed;
        }
        field(11; Comment; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(12; Subject; Text[250])
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

    trigger OnInsert()
    begin
        CustomerHelpDeskTicketDetail.RESET;
        IF CustomerHelpDeskTicketDetail.FINDLAST THEN
            "Entry No." := CustomerHelpDeskTicketDetail."Entry No." + 1
        ELSE
            "Entry No." := 1;
    end;

    var
        CustomerHelpDeskTicketDetail: Record "Customer HelpDesk TicketDetail";
}

