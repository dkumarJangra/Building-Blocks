tableextension 50114 "BBG Gate Entry Line Ext" extends "Gate Entry Line"
{
    fields
    {
        // Add changes to table fields here



        field(50004; "Gate Entry Date"; Date)
        {
            CalcFormula = Lookup("Gate Entry Header"."Posting Date" WHERE("Entry Type" = FIELD("Entry Type"),
                                                                           "No." = FIELD("Gate Entry No.")));
            Description = 'AlleBLk';
            FieldClass = FlowField;
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
        Vendor: Record Vendor;
        GateEntry: Record "Gate Entry Header";
        CalledFromHeader: Boolean;
        MemberOf: Record "Access Control";
}