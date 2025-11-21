table 97873 "Vendor Tree"
{
    // Application wise Team hierarchy for commission


    fields
    {
        field(1; "Introducer Code"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(2; "Effective Date"; Date)
        {
        }
        field(3; "Line No."; Integer)
        {
        }
        field(4; "Associate Code"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(5; "Parent Code"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(6; "Rank Code"; Decimal)
        {
            TableRelation = Rank;

            trigger OnValidate()
            begin
                /*
                IF "Parent Code" <> 0 THEN
                  IF Rank.GET("Parent Code") THEN
                    "Rank Code" := Rank.Description
                  ELSE
                    "Rank Code" := '';
                 */

            end;
        }
        field(7; "Rank Description"; Text[60])
        {
            Editable = false;
        }
        field(8; "Associate Name"; Text[60])
        {
            Editable = false;
        }
        field(9; Status; Option)
        {
            OptionCaption = 'Active,In-Active';
            OptionMembers = Active,"In-Active";
        }
        field(10; "Correction By"; Code[20])
        {
            Editable = false;
            TableRelation = User;
        }
        field(11; "Correction Date"; Date)
        {
            Editable = false;
        }
        field(12; "Correction Time"; Time)
        {
            Editable = false;
        }
        field(13; Remark; Text[30])
        {
        }
        field(14; "Region/Rank Code"; Code[10])
        {
            TableRelation = "Rank Code Master";
        }
    }

    keys
    {
        key(Key1; "Introducer Code", "Effective Date", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

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

