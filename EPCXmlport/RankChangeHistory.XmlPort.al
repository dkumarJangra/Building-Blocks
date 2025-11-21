xmlport 50018 "Rank Change History"
{
    Direction = Export;
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Rank Change History"; "Rank Change History")
            {
                XmlName = 'Tables';
                fieldelement(a; "Rank Change History"."Entry No")
                {
                }
                fieldelement(s; "Rank Change History".MMCode)
                {
                }
                fieldelement(d; "Rank Change History"."Authorised Person")
                {
                }
                fieldelement(f; "Rank Change History"."Authorisation Date")
                {
                }
                fieldelement(g; "Rank Change History"."Previous Rank")
                {
                }
                fieldelement(h; "Rank Change History"."New Rank")
                {
                }
                fieldelement(j; "Rank Change History".Remarks)
                {
                }
                fieldelement(k; "Rank Change History".Inactive)
                {
                }
                fieldelement(l; "Rank Change History"."Old Parent Code")
                {
                }
                fieldelement(q; "Rank Change History"."New Parent Code")
                {
                }
                fieldelement(w; "Rank Change History"."Rank Code")
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

