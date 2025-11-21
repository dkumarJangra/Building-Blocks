tableextension 97033 "EPC Wf. User Group Member Ext" extends "Workflow User Group Member"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Approval Amount Limit"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
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