tableextension 97022 "EPC Gate Entry Header Ext" extends "Gate Entry Header"
{
    fields
    {
        // Add changes to table fields here
        field(50013; "RR No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'added by dds--JPL';
        }
        field(50014; "RR Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50016; Remarks; Text[200])
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