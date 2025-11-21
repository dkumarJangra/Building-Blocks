tableextension 97028 "EPC Sales & Receiva. Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50005; "Default Brokerage %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
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