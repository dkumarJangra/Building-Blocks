table 50065 "Event Datails"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
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

            trigger OnValidate()
            var
                EventDatails: Record "Event Datails";
            begin
                TESTFIELD("Event Status", "Event Status"::Active);
                EventDatails.RESET;
                EventDatails.SETFILTER("Entry No.", '<>%1', "Entry No.");
                EventDatails.SETRANGE("Event ID", "Event ID");
                IF EventDatails.FINDFIRST THEN
                    ERROR('Event ID already Exists');
            end;
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
        field(7; "Event Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Active,In-Active';
            OptionMembers = " ",Active,"In-Active";
        }
        field(8; "Event Interval"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Event Radius"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

