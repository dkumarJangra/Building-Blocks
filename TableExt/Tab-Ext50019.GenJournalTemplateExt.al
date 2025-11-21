tableextension 50019 "BBG Gen. Journal Template Ext" extends "Gen. Journal Template"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "ARM System Entry"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'BBG 1.00 AD150313';
        }
        field(50030; "Responsibility Center"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = "Responsibility Center 1";
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