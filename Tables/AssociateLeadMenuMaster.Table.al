table 60722 "Associate Lead Menu Master"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; Name; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Is for Customer"; Boolean)
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
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        AssociateLeadMenuMaster.RESET;
        IF AssociateLeadMenuMaster.FINDLAST THEN
            "Entry No." := AssociateLeadMenuMaster."Entry No." + 1
        ELSE
            "Entry No." := 1;
    end;

    var
        AssociateLeadMenuMaster: Record "Associate Lead Menu Master";
}

