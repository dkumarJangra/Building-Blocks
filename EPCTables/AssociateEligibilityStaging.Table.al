table 50026 "Associate Eligibility Staging"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Editable = false;
        }
        field(2; "Batch Code"; Code[20])
        {
            Editable = false;
        }
        field(3; "Batch Date"; Date)
        {
            Editable = false;
        }
        field(4; "Associate Code"; Code[20])
        {
            Editable = false;
        }
        field(5; "Associate Name"; Text[60])
        {
            Editable = false;
        }
        field(6; Amount; Decimal)
        {
            Editable = true;
        }
        field(7; "Associate P.A.N No."; Code[20])
        {
            Editable = false;
        }
        field(8; "Publish Data"; Boolean)
        {
            Editable = true;

            trigger OnValidate()
            begin
                /*
                Memberof.RESET;
                Memberof.SETRANGE("User Name",USERID);
                Memberof.SETRANGE(Memberof."Role ID",'WebAssElig');
                IF NOT Memberof.FINDFIRST THEN
                  ERROR('Contact to Admin Department');
                IF NOT "Publish Data" THEN BEGIN
                  AssociateEliglog.RESET;
                  AssociateEliglog.GET("Entry No.");
                  AssociateEliglog.DELETE;
                END;
                */

            end;
        }
        field(9; "E-Mail"; Text[100])
        {
            Caption = 'E-Mail';
            Editable = false;
            ExtendedDatatype = EMail;
        }
        field(10; "Mob. No."; Text[30])
        {
            Editable = false;
        }
        field(11; "Error Message"; Text[200])
        {
            Editable = true;
        }
        field(12; Address; Text[100])
        {
            CalcFormula = Lookup(Vendor.Address WHERE("No." = FIELD("Associate Code")));
            Caption = 'Address';
            FieldClass = FlowField;
        }
        field(13; "Address 2"; Text[50])
        {
            CalcFormula = Lookup(Vendor."Address 2" WHERE("No." = FIELD("Associate Code")));
            Caption = 'Address 2';
            FieldClass = FlowField;
        }
        field(14; "Date of Joining"; Date)
        {
            CalcFormula = Lookup(Vendor."BBG Date of Joining" WHERE("No." = FIELD("Associate Code")));
            FieldClass = FlowField;
        }
        field(15; "Date of Birth"; Date)
        {
            CalcFormula = Lookup(Vendor."BBG Date of Birth" WHERE("No." = FIELD("Associate Code")));
            FieldClass = FlowField;
        }
        field(50001; "Last Record"; Boolean)
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
        key(Key2; "Batch Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        //AssociateEliglog: Record 50025;
        Memberof: Record "Access Control";
}

