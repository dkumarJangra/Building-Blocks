table 50010 "application entry"
{

    fields
    {
        field(1; application; Code[20])
        {
            Editable = false;
        }
        field(2; Amount; Decimal)
        {
            Editable = false;
        }
        field(3; "full amount"; Boolean)
        {
            Editable = false;
        }
        field(4; "Posting date filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(5; "unit payment amount"; Decimal)
        {
            CalcFormula = Sum("Unit Payment Entry".Amount WHERE("Document No." = FIELD(application),
                                                                 "Posting date" = FIELD("Posting date filter")));
            FieldClass = FlowField;
        }
        field(6; "Posting Date"; Date)
        {
            CalcFormula = Lookup("Confirmed Order"."Posting Date" WHERE("No." = FIELD(application)));
            FieldClass = FlowField;
        }
        field(7; "Project Code"; Code[20])
        {
        }
        field(8; "Paid base amount"; Decimal)
        {
            CalcFormula = Sum("Commission Entry"."Base Amount" WHERE("Application No." = FIELD(application),
                                                                      "Business Type" = FILTER(SELF),
                                                                      "Opening Entries" = FILTER(false)));
            FieldClass = FlowField;
        }
        field(9; "BSP1 amount"; Decimal)
        {
            CalcFormula = Sum("Applicable Charges"."Net Amount" WHERE("Document No." = FIELD(application),
                                                                       Code = FILTER('BSP1')));
            FieldClass = FlowField;
        }
        field(10; "BSP3 Amount"; Decimal)
        {
            CalcFormula = Sum("Applicable Charges"."Net Amount" WHERE("Document No." = FIELD(application),
                                                                       Code = FILTER('BSP3')));
            FieldClass = FlowField;
        }
        field(11; "For New application"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; application)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

