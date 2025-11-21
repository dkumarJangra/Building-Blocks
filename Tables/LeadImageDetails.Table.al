table 60728 "Lead Image Details"
{

    fields
    {
        field(1; "Lead ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Ref. Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Image Path"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Type; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Lead ID", "Line No.")
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

