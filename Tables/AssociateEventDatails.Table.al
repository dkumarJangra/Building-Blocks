table 50066 "Associate Event Datails"
{
    DataPerCompany = false;

    fields
    {
        field(1; "User ID"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Event Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Event Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Event ID"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Event Long"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 8;
        }
        field(6; "Event Latitude"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 8;
        }
        field(7; "Associate ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Event Time In"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Event Time Out"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "No. of Customers"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Team Code"; Code[50])
        {
            CalcFormula = Lookup(Vendor."BBG Team Code" WHERE("No." = FIELD("Associate ID")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Leader Code"; Code[20])
        {
            CalcFormula = Lookup(Vendor."BBG Leader Code" WHERE("No." = FIELD("Associate ID")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Leader Master";
        }
        field(13; "Sub Team Code"; Code[20])
        {
            CalcFormula = Lookup(Vendor."BBG Sub Team Code" WHERE("No." = FIELD("Associate ID")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Sub Team Master";
        }
        field(14; "Associate Name"; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Associate ID")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Sub Team Name"; Text[50])
        {
            CalcFormula = Lookup("Sub Team Master".Description WHERE("Sub Team Code" = FIELD("Sub Team Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Check In Image Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(17; "Check Out Image Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "User ID", "Event ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

