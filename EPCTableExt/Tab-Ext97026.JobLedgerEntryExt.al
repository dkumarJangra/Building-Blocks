tableextension 97026 "EPC Job Ledger Entry Ext" extends "Job Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50005; "Job Contract Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAA';
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