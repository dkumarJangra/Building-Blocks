tableextension 97021 "EPC Gate Entry Line Ext" extends "Gate Entry Line"
{
    fields
    {
        // Add changes to table fields here
        field(50000; Used; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50001; "PO No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50002; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                "Vendor Name" := '';
                Vendor.RESET;
                IF Vendor.GET("Vendor No.") THEN;
                "Vendor Name" := Vendor.Name;
            end;
        }
        field(50003; "Vendor Name"; Text[30])
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
        Vendor: Record Vendor;
        GateEntry: Record "Gate Entry Header";
        CalledFromHeader: Boolean;
        MemberOf: Record "Access Control";
}