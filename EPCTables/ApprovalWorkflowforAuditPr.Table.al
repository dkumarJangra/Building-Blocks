table 60745 "Approval Workflow for Audit Pr"
{

    fields
    {
        field(1; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Receipt,Gold/Silver,Plot Registration,Unit Vacate,Unit Allocation,Member to Member Transfer,Member Allocation,Vendor,Customer,Vendor Black List';
            OptionMembers = " ",Receipt,"Gold/Silver","Plot Registration","Unit Vacate","Unit Allocation","Member to Member Transfer","Member Allocation",Vendor,Customer,"Vendor Black List";
        }
        field(2; "Requester ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";

            trigger OnValidate()
            begin
                User.RESET;
                User.SETRANGE("User Name", "Requester ID");
                IF User.FINDFIRST THEN
                    "Requester Name" := User."Full Name";
            end;
        }
        field(3; "Approver ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";

            trigger OnValidate()
            begin
                User.RESET;
                User.SETRANGE("User Name", "Approver ID");
                IF User.FINDFIRST THEN
                    "Approver Name" := User."Full Name";
            end;
        }
        field(5; "Requester Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; "Approver Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; Sequence; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Parallel Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "Document Type", "Requester ID", "Approver ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        User: Record User;
}

