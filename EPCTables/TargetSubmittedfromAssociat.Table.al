table 60762 "Target Submitted from Associat"
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
            Editable = false;
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
        field(50; "Request Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(51; "Request No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52; "Target Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(53; "Request Closing Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(54; "Target Submitted Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(55; "Target Submitted Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(56; TargetSubmittedDateTime; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(57; "Last Modify By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(58; "Last Modify DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(59; "Month Number"; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Request No.", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        "Last Modify By" := USERID;
        "Last Modify DateTime" := CURRENTDATETIME;
    end;
}

