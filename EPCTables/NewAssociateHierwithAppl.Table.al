table 50019 "New Associate Hier with Appl."
{
    // BBG2.01 190114 This is used in LLP company only. Here its used in case of transferfields function used.

    DataPerCompany = false;

    fields
    {
        field(1; "Application Code"; Code[20])
        {
            TableRelation = "Confirmed Order";
        }
        field(2; "Introducer Code"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(3; "Associate Code"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(4; "Posting Date"; Date)
        {
        }
        field(5; "Line No."; Integer)
        {
        }
        field(6; "Rank Change"; Boolean)
        {
        }
        field(7; "Rank Change Date"; Date)
        {
        }
        field(8; "Parent Code"; Code[20])
        {
        }
        field(9; "Project Code"; Code[20])
        {
            TableRelation = "Responsibility Center 1";
        }
        field(50000; "Travel Generated"; Boolean)
        {
        }
        field(50001; "Rank Code"; Decimal)
        {
            Description = 'BBG1.00 050613';
        }
        field(50002; "Rank Description"; Text[60])
        {
            Description = 'BBG1.00 050613';
            Editable = false;
        }
        field(50003; "Associate Name"; Text[60])
        {
            Description = 'BBG1.00 050613';
            Editable = false;
        }
        field(50004; "Commission %"; Decimal)
        {
            Description = 'BBG1.00 050613';
            Editable = true;
        }
        field(50005; Status; Option)
        {
            Description = 'BBG1.00 050613';
            OptionCaption = 'Active,In-Active';
            OptionMembers = Active,"In-Active";
        }
        field(50006; "Correction By"; Code[20])
        {
            Description = 'BBG1.00 050613';
            Editable = false;
            TableRelation = User;
        }
        field(50007; "Correction Date"; Date)
        {
            Description = 'BBG1.00 050613';
            Editable = false;
        }
        field(50008; "Correction Time"; Time)
        {
            Description = 'BBG1.00 050613';
            Editable = false;
        }
        field(50009; Remark; Text[30])
        {
            Description = 'BBG1.00 050613';
        }
        field(50010; "Region/Rank Code"; Code[10])
        {
            TableRelation = "Rank Code Master";
        }
        field(50011; "Company Name"; Text[30])
        {
        }
        field(50013; "RunTeam Positive for Associate"; Boolean)
        {
            Editable = false;
        }
        field(50100; "Not Update in MSCompany"; Boolean)
        {
            Description = 'BBG2.01 190114';
            Editable = false;
        }
        field(50101; "Check Posting date"; Date)
        {
            CalcFormula = Lookup("New Confirmed Order"."Posting Date" WHERE("No." = FIELD("Application Code")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Application Code", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Introducer Code", "Associate Code")
        {
        }
        key(Key3; "Associate Code", "Introducer Code", "Application Code")
        {
        }
        key(Key4; "Parent Code", "Posting Date", "Project Code")
        {
        }
        key(Key5; "Introducer Code", "Associate Code", "Posting Date", "Project Code")
        {
        }
        key(Key6; "Introducer Code", "Parent Code", "Posting Date", "Project Code")
        {
        }
        key(Key7; "Project Code", "Associate Code", "Introducer Code")
        {
        }
        key(Key8; "Rank Code", "Application Code")
        {
        }
        key(Key9; "Application Code", "Introducer Code")
        {
        }
        key(Key10; "Application Code", "Associate Code")
        {
        }
        key(Key11; "Introducer Code", "Application Code")
        {
        }
        key(Key12; "Associate Code", "Rank Code")
        {
        }
        key(Key13; "Associate Code", "Parent Code")
        {
        }
        key(Key14; "Associate Code", "Application Code")
        {
        }
        key(Key15; "Project Code", "Associate Code", "Application Code")
        {
        }
        key(Key16; "RunTeam Positive for Associate")
        {
        }
        key(Key17; "Rank Code", "Associate Code", "RunTeam Positive for Associate")
        {
        }
        key(Key18; "Associate Code", "Rank Code", "RunTeam Positive for Associate")
        {
        }
        key(Key19; "Associate Code", Status)
        {
        }
        key(Key20; "Application Code", Status)
        {
        }
    }

    fieldgroups
    {
    }

    var
        Rank: Record Rank;
        Vend: Record Vendor;
}

