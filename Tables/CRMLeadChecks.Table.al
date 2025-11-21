table 60727 "CRM Lead Checks"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; Name; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; Applicable; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        CustomersLead_2: Record "Customers Lead_2";
    begin
        CustomersLead_2.RESET;
        IF CustomersLead_2.GET("No.") THEN
            CustomersLead_2.TESTFIELD(Status, CustomersLead_2.Status::Open);
    end;
}

