table 50029 "Application Date change data_1"
{
    DataPerCompany = false;
    Permissions = TableData "Gle Data update" = rimd;

    fields
    {
        field(1; "Entry no."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "POsting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "New posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Cheque No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "New cheque no."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Cheque Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "New Cheque Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Company Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Company;
        }
    }

    keys
    {
        key(Key1; "Entry no.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
    //1

}

