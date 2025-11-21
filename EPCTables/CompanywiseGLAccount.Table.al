table 50020 "Company wise G/L Account"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Company Code"; Text[30])
        {
            TableRelation = Company;
        }
        field(2; "Receivable Account"; Code[20])
        {
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                IF GLAccount.GET("Receivable Account") THEN
                    "Receivable Account Name" := GLAccount.Name;
            end;
        }
        field(4; "Receivable Account Name"; Text[50])
        {
            Editable = false;
        }
        field(5; "Payable Account"; Code[20])
        {
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                IF GLAccount.GET("Payable Account") THEN
                    "Payable Account Name" := GLAccount.Name;
            end;
        }
        field(6; "Payable Account Name"; Text[50])
        {
            Editable = false;
        }
        field(7; "MSC Company"; Boolean)
        {
            Editable = false;
        }
        field(8; "Active for Reports"; Boolean)
        {
        }
        field(9; "Other LLPS"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Development Company"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CompanywiseGLAccount.RESET;
                CompanywiseGLAccount.SETFILTER("Company Code", '<>%1', "Company Code");
                CompanywiseGLAccount.SETRANGE("Development Company", TRUE);
                IF CompanywiseGLAccount.FINDFIRST THEN
                    ERROR('Development company already define');
            end;
        }
    }

    keys
    {
        key(Key1; "Company Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        GLAccount: Record "G/L Account";
        CompanywiseGLAccount: Record "Company wise G/L Account";
}

