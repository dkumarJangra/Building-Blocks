tableextension 97058 "EPC Bank Account Ext" extends "Bank Account"
{
    fields
    {
        // Add changes to table fields here
        field(50003; "Branch Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "RTGS/IFSC"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleRoyal';
        }
        Field(50021; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(50022; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    var
        myInt: Integer;
    begin
        "Creation Date" := Today;
        "Created By" := USERID;
    end;
}