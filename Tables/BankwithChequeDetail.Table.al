table 50002 "Bank with Cheque Detail"
{

    fields
    {
        field(1; "Bank Account Code"; Code[20])
        {
            TableRelation = "Bank Account"."No.";

            trigger OnValidate()
            begin
                IF BankAccount.GET("Bank Account Code") THEN
                    Name := BankAccount.Name;
            end;
        }
        field(2; Name; Text[50])
        {
            Editable = false;
        }
        field(3; "Cheque No. From"; Integer)
        {
        }
        field(4; "Cheque No. To"; Integer)
        {
        }
        field(5; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1; "Bank Account Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        BankAccount: Record "Bank Account";
}

