table 60739 "LOAN EMI Document Details"
{
    Caption = 'LOAN EMI Document Details';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Reference No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Creation Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Field Name"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Field Type"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Field Heading"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(12; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Active,In-Active';
            OptionMembers = " ",Active,"In-Active";
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
        LOANEMIDocumentDetails.RESET;
        IF LOANEMIDocumentDetails.FINDLAST THEN
            "Entry No." := LOANEMIDocumentDetails."Entry No." + 1
        ELSE
            "Entry No." := 1;
    end;

    var
        LOANEMIDocumentDetails: Record "LOAN EMI Document Details";
}

