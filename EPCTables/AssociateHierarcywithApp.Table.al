table 97867 "Associate Hierarcy with App."
{
    // Application wise Team hierarchy for commission

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

            trigger OnValidate()
            begin
                IF Vend.GET("Associate Code") THEN
                    "Associate Name" := Vend.Name
                ELSE
                    "Associate Name" := '';
            end;
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

            trigger OnValidate()
            begin
                IF "Rank Code" <> 0 THEN
                    IF Rank.GET("Rank Code") THEN
                        "Rank Description" := Rank.Description
                    ELSE
                        "Rank Description" := '';
            end;
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
            Editable = true;
            TableRelation = Company;
        }
        field(50100; "Not Update in MSCompany"; Boolean)
        {
        }
        field(50101; "Commission Amount"; Decimal)
        {
            CalcFormula = Sum("Commission Entry"."Commission Amount" WHERE("Application No." = FIELD("Application Code"),
                                                                            "Direct to Associate" = FILTER(false),
                                                                            "Associate Code" = FIELD("Associate Code")));
            FieldClass = FlowField;
        }
        field(50102; "Commission Amount BSP2"; Decimal)
        {
            CalcFormula = Sum("Commission Entry"."Commission Amount" WHERE("Application No." = FIELD("Application Code"),
                                                                            "Direct to Associate" = FILTER(true),
                                                                            "Associate Code" = FIELD("Associate Code")));
            FieldClass = FlowField;
        }
        field(50103; "Commission Base Amount"; Decimal)
        {
            CalcFormula = Sum("Unit Payment Entry".Amount WHERE("Document No." = FIELD("Application Code"),
                                                                 "Charge Code" = FILTER('BSP1' | 'BSP3')));
            Caption = 'Commission Base Amount BSP1_BSP3';
            FieldClass = FlowField;
        }
        field(50104; "Commission Base Amount BSP2"; Decimal)
        {
            CalcFormula = Sum("Unit Payment Entry".Amount WHERE("Document No." = FIELD("Application Code"),
                                                                 "Charge Code" = FILTER('BSP2')));
            FieldClass = FlowField;
        }
        field(50105; "Entry Mark"; Boolean)
        {
        }
        field(50106; "Application DOJ"; Date)
        {
            Editable = false;
        }
        field(50107; "Running Associates"; Boolean)
        {
            Description = 'For Inactive Data Report';
            Editable = false;
        }
        field(50108; "TA Exists"; Code[20])
        {
            CalcFormula = Lookup("Travel Payment Details"."Application No." WHERE("Application No." = FIELD("Application Code")));
            FieldClass = FlowField;
        }
        field(50109; "P.A.N. No."; Code[20])
        {
            CalcFormula = Lookup(Vendor."P.A.N. No." WHERE("No." = FIELD("Associate Code")));
            Caption = 'P.A.N. No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50110; "Team Code"; Code[50])
        {
            CalcFormula = Lookup(Vendor."BBG Team Code" WHERE("No." = FIELD("Associate Code")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Team Master";
        }
        field(50111; "Commission Base Amt"; Decimal)
        {
            CalcFormula = Sum("Commission Entry"."Base Amount" WHERE("Application No." = FIELD("Application Code"),
                                                                      "Associate Code" = FIELD("Associate Code"),
                                                                      "Direct to Associate" = CONST(false)));
            Caption = 'Commission Base Amount';
            Description = 'ALLEDK 090113';
            Editable = false;
            FieldClass = FlowField;
        }

        field(50201; "Commission Rate/SQD"; Decimal)
        {

            Editable = false;
            FieldClass = Normal;

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
        key(Key7; "Project Code", "Associate Code", "Introducer Code", Status, "Company Name")
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
        key(Key16; "Not Update in MSCompany")
        {
        }
        key(Key17; "Associate Code", Status)
        {
        }
        key(Key18; "Application DOJ")
        {
        }
        key(Key19; "Application Code", Status)
        {
        }
        key(Key20; Status)
        {
        }
        key(Key21; "Introducer Code", Status)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Company Name" := COMPANYNAME;
    end;

    trigger OnModify()
    begin
        "Correction By" := USERID;
        "Correction Date" := TODAY;
        "Correction Time" := TIME;
    end;

    var
        Rank: Record Rank;
        Vend: Record Vendor;
}

