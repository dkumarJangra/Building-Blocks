tableextension 97001 "EPC Dimension Value Ext" extends "Dimension Value"
{
    fields
    {
        // Add changes to table fields here
        field(55005; "IS Project"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'BBG2.1 310114';
        }
        field(55002; "LINK to Region Dim"; Code[20])
        {
            CaptionClass = '1,2,1';
            DataClassification = ToBeClassified;
            Description = 'ALLEAB';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50002; "Gen. Business Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = "Gen. Business Posting Group";
        }
        field(55003; "Leave Approver"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleDK';
            TableRelation = Employee;
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