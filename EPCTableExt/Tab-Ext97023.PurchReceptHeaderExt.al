tableextension 97023 "EPC Purch. Recept Header Ext" extends "Purch. Rcpt. Header"
{
    fields
    {
        // Add changes to table fields here
        field(70027; "UnPosted GRN No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
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