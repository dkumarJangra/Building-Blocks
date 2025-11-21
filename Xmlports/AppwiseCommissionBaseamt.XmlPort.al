xmlport 50020 "App wise Commission Base amt"
{
    Direction = Export;
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Confirmed Order"; "Confirmed Order")
            {
                XmlName = 'ConfirmedOrder';
                fieldelement(No; "Confirmed Order"."No.")
                {
                }
                fieldelement(CommissionApplicableBaseAmt; "Confirmed Order"."Commission applicable base amt")
                {
                }
                fieldelement(CommissionBaseAmt; "Confirmed Order"."Commission Base amt")
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
}

