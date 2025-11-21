table 97852 "Incentive Detail Entry"
{

    fields
    {
        field(1; "Incentive Application No."; Code[20])
        {
        }
        field(2; "Entry No."; Integer)
        {
        }
        field(3; Year; Integer)
        {
        }
        field(4; Month; Integer)
        {
        }
        field(5; "Associate Code"; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                IF "Associate Code" <> '' THEN BEGIN
                    IF Vend.GET("Associate Code") THEN
                        "Associate Name" := Vend.Name;
                END ELSE
                    "Associate Name" := '';
            end;
        }
        field(6; "Associate Name"; Text[60])
        {
            Editable = false;
        }
        field(7; "Application Date"; Date)
        {
        }
        field(8; "Min. Allotment Amount"; Decimal)
        {
        }
        field(9; "Amount Received"; Decimal)
        {
        }
        field(10; "Application No."; Code[20])
        {
        }
        field(11; Status; Option)
        {
            OptionCaption = 'Open,Partial Posted,Full Payment';
            OptionMembers = Open,"Partial Posted","Full Payment";
        }
        field(12; "BSP1 Amount"; Decimal)
        {
        }
        field(13; "Unit No."; Code[20])
        {
            TableRelation = "Unit Master";
        }
        field(14; "Plot Value"; Decimal)
        {
        }
        field(15; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(16; "No. of Units"; Decimal)
        {
        }
        field(17; "Line No."; Integer)
        {
        }
        field(18; "Incentive No. Series"; Code[20])
        {
            Caption = 'Incentive No. Series';
            TableRelation = "No. Series";
        }
        field(19; "Saleable Area"; Decimal)
        {
        }
        field(20; "Valid Application"; Boolean)
        {
        }
        field(21; "Calculation Type"; Option)
        {
            OptionCaption = 'Number Wise,Extent Wise';
            OptionMembers = "Number Wise","Extent Wise";
        }
        field(22; "Incentive Scheme"; Code[20])
        {
        }
        field(23; "Team Incentive Calculate"; Boolean)
        {
        }
        field(24; "Team Incentive Scheme"; Code[20])
        {
            Editable = false;
        }
        field(25; "Team Calculation Type"; Option)
        {
            OptionCaption = 'Number Wise,Extent Wise';
            OptionMembers = "Number Wise","Extent Wise";
        }
        field(26; "Parent Code"; Code[20])
        {
        }
        field(27; "BSP1_BSP3 Amount"; Decimal)
        {
            Editable = false;
        }
        field(28; "Start Date"; Date)
        {
            Description = 'BBG1.4 271213';
            Editable = false;
        }
        field(29; "End Date"; Date)
        {
            Description = 'BBG1.4 271213';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Incentive Application No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "BSP1 Amount", "Associate Code", Month, Year, "Shortcut Dimension 1 Code")
        {
        }
        key(Key3; "Associate Code", Month, Year)
        {
        }
        key(Key4; "Application No.")
        {
        }
        key(Key5; "Associate Code", "Calculation Type", Month, Year)
        {
        }
        key(Key6; "Incentive Scheme", "Associate Code", "Calculation Type", Month, Year)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Incentive Application No." = '' THEN BEGIN
            UnitSetup.GET;
            UnitSetup.TESTFIELD("Post Incentive No.");
            NoSeriesMgt.InitSeries(UnitSetup."Post Incentive No.", xRec."Incentive No. Series", WORKDATE, "Incentive Application No.",
             "Incentive No. Series");
        END;
    end;

    var
        UnitSetup: Record "Unit Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Vend: Record Vendor;
}

