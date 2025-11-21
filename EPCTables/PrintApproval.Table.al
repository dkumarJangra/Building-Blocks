table 97791 "Print Approval"
{

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = 'Application(Ack.),Bond(Cert.),Commission(Vch),Bonus(Token)';
            OptionMembers = "Application(Ack.)","Bond(Cert.)","Commission(Vch)","Bonus(Token)";

            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
            begin
                UserSetup.GET(USERID);
                IF (UserSetup."Shortcut Dimension 2 Code" <> '') AND ("Document Type" <> "Document Type"::"Application(Ack.)") THEN
                    ERROR('Not allowed');
            end;
        }
        field(2; "Document No."; Code[20])
        {
            TableRelation = IF ("Document Type" = FILTER('Bond(Cert.)')) "Confirmed Order"."No." WHERE(Status = FILTER(>= Active))
            ELSE IF ("Document Type" = FILTER('Commission(Vch)')) "Commission Voucher"."Voucher No.";

            trigger OnValidate()
            var
                Application: Record Application;
                Bond: Record "Confirmed Order";
            begin
                IF "Document Type" = "Document Type"::"Application(Ack.)" THEN BEGIN
                    Application.SETCURRENTKEY("Unit No.");
                    Application.SETRANGE("Unit No.", "Document No.");
                    IF Application.ISEMPTY THEN
                        IF NOT Bond.GET("Document No.") THEN
                            ERROR(Text001, "Document No.");
                END;
            end;
        }
        field(3; "Line No."; Integer)
        {
        }
        field(4; "Request Type"; Option)
        {
            OptionCaption = 'Duplicate,Reprint,Assigned,Reassigned,Bonus Token';
            OptionMembers = Duplicate,Reprint,Assigned,Reassigned,"Bonus Token";
        }
        field(5; "Requester ID"; Code[20])
        {
            Editable = true;
            TableRelation = User;
        }
        field(6; Status; Option)
        {
            OptionCaption = 'Open,Approved,Rejected,Printed,Closed';
            OptionMembers = Open,Approved,Rejected,Printed,Closed;
        }
        field(7; "Approver ID"; Code[20])
        {
            TableRelation = User;
        }
        field(8; "Requested Date"; Date)
        {
            Editable = true;
        }
        field(9; "Request Time"; Time)
        {
            Editable = true;
        }
        field(10; "Action Date"; Date)
        {
            Editable = true;
        }
        field(11; "Action Time"; Time)
        {
            Editable = true;
        }
        field(12; Remarks; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; Status, "Requester ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Requester ID" := USERID;
        "Requested Date" := GetDescription.GetDocomentDate;
        "Request Time" := TIME;
        IF "Document No." = '' THEN
            ERROR('Document No. should not be blank');
    end;

    trigger OnModify()
    begin
        IF Status <> Status::Open THEN
            "Approver ID" := USERID;
    end;

    var
        Text001: Label 'Bond No. %1 not found.';
        GetDescription: Codeunit GetDescription;
}

