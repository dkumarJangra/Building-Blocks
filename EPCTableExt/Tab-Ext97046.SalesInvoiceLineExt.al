tableextension 97046 "EPC Sales Invoice Line Ext" extends "Sales Invoice Line"
{
    fields
    {
        // Add changes to table fields here
        field(50004; "Invoice Type1"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0006 27-07-2007';
            OptionCaption = 'Normal,RA,Escalation';
            OptionMembers = Normal,RA,Escalation;
        }
        field(50000; "BOQ Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0016 16-07-2007';
            TableRelation = "BOQ Item";

            trigger OnValidate()
            var
                JobMst: Record "BOQ Item";
                DimVal: Record "Dimension Value";
            begin
            end;
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