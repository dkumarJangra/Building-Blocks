table 50044 "Associate Payment Data"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Payment Request No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Payment Request Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; Type; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Commission,Incentive';
            OptionMembers = Commission,Incentive;
        }
        field(5; "Associate Payable Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Payment Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Under Process,Sent for Approval,Approved,Reject';
            OptionMembers = "Under Process","Sent for Approval",Approved,Reject;

            trigger OnValidate()
            begin
                UserSetup.RESET;
                UserSetup.SETRANGE("User ID", USERID);
                UserSetup.SETRANGE("Mobile Payment Status modify", TRUE);
                IF NOT UserSetup.FINDFIRST THEN
                    ERROR('Please contacct Admin');


                IF "Payment Status" = "Payment Status"::Approved THEN BEGIN
                    "Payment Approved Date" := TODAY;
                    "Payment Approved By" := USERID;
                    "Payment Approved Time" := TIME;
                END ELSE BEGIN
                    "Payment Approved Date" := 0D;
                    "Payment Approved By" := '';
                    "Payment Approved Time" := 0T;
                END;

                "Status update By" := USERID;
                "Status Update Date" := TODAY;
                "Status Update Time" := TIME;
            end;
        }
        field(7; "Associate ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; User_ID; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "Payment Approved Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; "Payment Approved By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "Payment Approved Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; "Pmt. Requested Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Vendor Bank Account No."; Text[30])
        {
            CalcFormula = Lookup("Vendor Bank Account"."Bank Account No." WHERE("Vendor No." = FIELD("Associate ID")));
            FieldClass = FlowField;
        }
        field(14; "Status update By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Batch Only';
            Editable = false;
        }
        field(15; "Status Update Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Batch Only';
            Editable = false;
        }
        field(16; "Status Update Time"; Time)
        {
            DataClassification = ToBeClassified;
            Description = 'Use for Batch Only';
            Editable = false;
        }
        field(17; "Comment for Rejection"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
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

    var
        UserSetup: Record "User Setup";
}

