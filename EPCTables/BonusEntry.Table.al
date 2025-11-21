table 97809 "Bonus Entry"
{
    // Base Amount,Bonus Amount


    fields
    {
        field(1; "Entry No."; Integer)
        {
            Editable = true;
        }
        field(2; "Unit No."; Code[20])
        {
            TableRelation = "Confirmed Order";

            trigger OnValidate()
            begin
                Bond.RESET;
                Bond.SETCURRENTKEY("No.");
                Bond.SETRANGE(Bond."No.", "Unit No.");
                //IF Bond.FIND('-') THEN
                IF Bond.FINDFIRST THEN
                    IF "Business Type" = "Business Type"::CHAIN THEN
                        "Introducer Code" := Bond."Introducer Code";
                "Scheme Code" := Bond."Scheme Code";
                "Project Type" := Bond."Project Type";
                Duration := Bond.Duration;
            end;
        }
        field(3; "Posting Date"; Date)
        {
        }
        field(4; "Associate Code"; Code[20])
        {
            Caption = 'Associate Code';
            TableRelation = Vendor;
        }
        field(5; "Base Amount"; Decimal)
        {
        }
        field(6; "Bonus %"; Decimal)
        {
        }
        field(7; "Bonus Amount"; Decimal)
        {
        }
        field(10; Stopped; Boolean)
        {
            Editable = true;
        }
        field(11; "Installment No."; Integer)
        {
        }
        field(68; "Bond Category"; Option)
        {
            Editable = false;
            OptionMembers = "A Type","B Type";
        }
        field(50015; "Business Type"; Option)
        {
            OptionCaption = 'SELF,CHAIN';
            OptionMembers = SELF,CHAIN;
        }
        field(50016; "Introducer Code"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(50019; "Scheme Code"; Code[20])
        {
        }
        field(50020; "Project Type"; Code[20])
        {
            TableRelation = "Unit Type".Code;
        }
        field(50021; Duration; Integer)
        {
        }
        field(50035; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Description = 'Payable';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50036; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'Payable';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50040; "Associate Rank"; Decimal)
        {
            Description = 'BBG1.00 ALLEDK 090313 change data type integer to decimal';
        }
        field(50042; "Pmt Received From Code"; Code[20])
        {
            Editable = true;
            TableRelation = Vendor;
        }
        field(50054; "Document Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Associate Code", "Posting Date")
        {
        }
        key(Key3; "Unit No.", "Installment No.")
        {
        }
        key(Key4; "Associate Code", "Business Type", "Introducer Code", "Project Type", "Scheme Code", Duration, "Unit No.", "Posting Date")
        {
        }
        key(Key5; "Associate Code", "Business Type", "Bond Category", "Posting Date", Stopped, Duration)
        {
            SumIndexFields = "Base Amount", "Bonus Amount";
        }
        key(Key6; "Pmt Received From Code", "Posting Date", "Shortcut Dimension 2 Code", Stopped)
        {
        }
    }

    fieldgroups
    {
    }

    var
        Bond: Record "Confirmed Order";
}

