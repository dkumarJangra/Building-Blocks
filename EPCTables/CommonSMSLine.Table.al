table 50007 "Common SMS Line"
{
    DrillDownPageID = "Sales Project wise Setup Line";
    LookupPageID = "Sales Project wise Setup Line";

    fields
    {
        field(1; "Document No."; Integer)
        {
            AutoIncrement = false;
            TableRelation = "Common SMS Header";
        }
        field(2; "Vendor Name"; Text[50])
        {
            Editable = false;
        }
        field(3; "SMS Text"; Text[250])
        {
        }
        field(4; Vendor; Code[20])
        {
            TableRelation = Vendor;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                IF Vend.GET(Vendor) THEN
                    "Vendor Name" := Vend.Name;
            end;
        }
        field(5; Customer; Code[20])
        {
            TableRelation = Customer;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                IF Cust.GET(Customer) THEN
                    "Customer Name" := Cust.Name;
            end;
        }
        field(6; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Sent';
            OptionMembers = Open,Sent;
        }
        field(7; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(8; "Customer Name"; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        User: Record User;
        Vend: Record Vendor;
        Cust: Record Customer;
}

