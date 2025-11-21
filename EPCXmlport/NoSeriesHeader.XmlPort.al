xmlport 50014 "No. Series Header upload"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("No. Series"; "No. Series")
            {
                XmlName = 'NoSeries';
                fieldelement(Code; "No. Series".Code)
                {
                }
                fieldelement(Description; "No. Series".Description)
                {
                }
                fieldelement(DefaultNo; "No. Series"."Default Nos.")
                {
                }
                fieldelement(ManualNo; "No. Series"."Manual Nos.")
                {
                }
                fieldelement(DateOrder; "No. Series"."Date Order")
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

