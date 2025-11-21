tableextension 97056 "EPC Employee Ext" extends Employee
{
    fields
    {
        // Add changes to table fields here
        field(55008; "Full Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'MES-Seema- for Quick Search';
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