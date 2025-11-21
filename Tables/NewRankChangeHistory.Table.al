table 50052 "New Rank Change History"
{
    DataPerCompany = true;

    fields
    {
        field(1; "Entry No"; Integer)
        {
        }
        field(2; MMCode; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                MM.RESET;
                IF MM.GET(MMCode) THEN
                    "Global Dimension 1 Code" := MM."Global Dimension 1 Code";
            end;
        }
        field(3; "Authorised Person"; Text[50])
        {
        }
        field(4; "Authorisation Date"; Date)
        {
        }
        field(5; "Previous Rank"; Decimal)
        {
        }
        field(6; "New Rank"; Decimal)
        {
        }
        field(7; Remarks; Text[250])
        {
        }
        field(8; Inactive; Boolean)
        {
        }
        field(9; "Old Parent Code"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(10; "Parent Rank Old"; Decimal)
        {
        }
        field(11; "New Parent Code"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(12; "Parent Rank New"; Decimal)
        {
        }
        field(13; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                /*
                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
                MODIFY;
                
                RecDimVal.RESET;
                RecDimVal.SETRANGE(RecDimVal.Code,"Global Dimension 1 Code");
                IF RecDimVal.FIND('-') THEN
                  "Global Dimension 1 Name" := RecDimVal.Name;
                */

            end;
        }
        field(14; Suspended; Boolean)
        {
        }
        field(15; "Suspended From Date"; Date)
        {
        }
        field(16; "Suspend Removal Date"; Date)
        {
        }
        field(17; "Suspend Removed"; Boolean)
        {
        }
        field(18; "Hold Payables"; Boolean)
        {
        }
        field(19; "Payables Hold From Date"; Date)
        {
        }
        field(20; "Payables Unhold Date"; Date)
        {
        }
        field(21; "Unhold Payables"; Boolean)
        {
        }
        field(22; "New Joinee"; Boolean)
        {
            Editable = false;
        }
        field(23; test; Decimal)
        {
        }
        field(50000; "Region Code"; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
            Clustered = true;
        }
        key(Key2; MMCode, "Authorisation Date")
        {
        }
        key(Key3; "Authorisation Date", MMCode)
        {
        }
    }

    fieldgroups
    {
    }

    var
        MM: Record Vendor;
}

