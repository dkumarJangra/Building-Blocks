table 60736 "Customer Campiagn"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Submitted At"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(4; Name; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "E-Mail"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Phone No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Type of Property"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Medium; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Source; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(10; Campiagn; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Ad group"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(12; Term; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Landing Page"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Lead Relevance"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Appointment Status"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Lead Converted"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Picked By"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Picked On"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Converted to Lead"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(20; Remarks; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(21; "Remarks 2"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(22; "Remarks 3"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(23; "Picked Update Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Use for data filter';
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

    trigger OnDelete()
    begin
        TESTFIELD("Picked By", '');
    end;

    trigger OnInsert()
    begin
        CustomerCampiagn.RESET;
        IF CustomerCampiagn.FINDLAST THEN
            "Entry No." := CustomerCampiagn."Entry No." + 1
        ELSE
            "Entry No." := 1;
    end;

    var
        CustomerCampiagn: Record "Customer Campiagn";
}

