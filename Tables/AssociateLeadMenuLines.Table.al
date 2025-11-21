table 60723 "Associate Lead Menu Lines"
{

    fields
    {
        field(1; "Entry Ref. No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Menu Name"; Text[100])
        {
            CalcFormula = Lookup("Associate Lead Menu Master".Name WHERE("Entry No." = FIELD("Entry Ref. No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; Value; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Link; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Is for customer"; Boolean)
        {
            CalcFormula = lookup("Associate Lead Menu Master"."Is for Customer" WHERE("Entry No." = FIELD("Entry Ref. No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Entry Ref. No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        AssociateLeadMenuMaster: Record "Associate Lead Menu Master";
    begin
    end;
}

