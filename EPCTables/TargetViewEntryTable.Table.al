table 60760 "Target View Entry Table"
{

    fields
    {
        field(1; "Associate Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Associate Name"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Team Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Associate Exclude"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Field Type"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Target field master";
        }
        field(6; "Field Type Value"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(8; Monthly; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9; Month; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Jan,Feb,March,April,May,June,July,Aug,Sept,Oct,Nov,Dec';
            OptionMembers = " ",Jan,Feb,March,April,May,June,July,Aug,Sept,Oct,Nov,Dec;
        }
        field(10; Year; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "From Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "To Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "No. of Days"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Request Closing Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(15; Designation; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Leader Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Request Creation Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(53; "Request Closing Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(56; TargetSubmittedDateTime; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
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

