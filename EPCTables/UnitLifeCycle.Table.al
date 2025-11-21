table 97874 "Unit Life Cycle"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Unit Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Unit Allocation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Unit Vacate Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Unit Registration Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Unit Creation Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Unit Allocation Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Unit Vacate Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Application Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Unit Registration Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Unit Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Blocked,Booked,Registered,Transfered';
            OptionMembers = Open,Blocked,Booked,Registered,Transfered;
        }
        field(14; "Project Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Unit Created By"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Unit Re-Allot Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Unit Re-Allot Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Unit Payment Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Type of Transaction"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Unit Creation,Unit modify,Unit Assigned,Unit Vacate,Unit Re-Assigned,Unit Registered,Unit Approved,Unit Un-approve';
            OptionMembers = " ","Unit Creation","Unit modify","Unit Assigned","Unit Vacate","Unit Re-Assigned","Unit Registered","Unit Approved","Unit Un-approve";
        }
        field(21; "Unit Approved"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Unit Approved Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Unit Un-Approved Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Unit Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

