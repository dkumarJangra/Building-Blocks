tableextension 50094 "BBG Prod. Order Component Ext" extends "Prod. Order Component"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Remaining Transfered Qty."; Decimal)
        {
            Caption = 'Remaining Transfered Qty.';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Description = 'ALLEAA 17.04.09';
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
}