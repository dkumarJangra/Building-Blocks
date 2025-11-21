table 60746 "Request to Approve Documents"
{

    fields
    {
        field(1; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Receipt,Gold/Silver,Plot Registration,Unit Vacate,Unit Allocation,Member to Member Transfer,Member Allocation,Vendor,Customer,Vendor Black List';
            OptionMembers = " ",Receipt,"Gold/Silver","Plot Registration","Unit Vacate","Unit Allocation","Member to Member Transfer","Member Allocation",Vendor,Customer,"Vendor Black List";
        }
        field(2; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Requester ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Approver ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; Status; Option)
        {
            DataClassification = ToBeClassified;
            Editable = true;
            OptionCaption = ' ,Approved,Reject';
            OptionMembers = " ",Approved,Reject;
        }
        field(10; "Requester DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(11; "Status Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; Sequence; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Document Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Reject Comment"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Cheque No."; Code[20])
        {
            CalcFormula = Lookup("NewApplication Payment Entry"."Cheque No./ Transaction No." WHERE("Document No." = FIELD("Document No."),
                                                                                                     "Line No." = FIELD("Document Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Reference No."; Code[20])
        {
            CalcFormula = Lookup("NewApplication Payment Entry"."Provisional Rcpt. No." WHERE("Document No." = FIELD("Document No."),
                                                                                               "Line No." = FIELD("Document Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Actual Approved By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Document Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

