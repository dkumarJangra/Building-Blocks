tableextension 50047 "BBG Res. Ledger Entry Ext" extends "Res. Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50001; Remark; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleDK 160708';
        }
        field(50002; Verified; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleDK 160708';
        }
        field(50003; "Verified By"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleDK 160708';
        }
        field(50008; "Work Type Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleDK 160708';
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
}