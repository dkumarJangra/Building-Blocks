table 60729 "Lead Inducation Details"
{

    fields
    {
        field(1; "Lead ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Comments; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Inducation Kit"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Associate ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Lead ID")
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
        IF CustomersLead_2.GET("Lead ID") THEN
            CustomersLead_2.TESTFIELD(Status, CustomersLead_2.Status::Open);
    end;
}

