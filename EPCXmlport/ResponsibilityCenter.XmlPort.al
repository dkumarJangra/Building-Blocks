xmlport 50011 "Responsibility Center"
{
    Direction = Export;
    UseDefaultNamespace = true;

    schema
    {
        textelement(WSRequest)
        {
            MaxOccurs = Once;
            tableelement("Responsibility Center"; "Responsibility Center")
            {
                XmlName = 'ProjectInformation';
                fieldelement(BranchCode; "Responsibility Center".Branch)
                {
                }
                fieldelement(BranchName; "Responsibility Center"."Branch Name")
                {
                }
                fieldelement(ProjectCode; "Responsibility Center".Code)
                {
                }
                fieldelement(ProjectName; "Responsibility Center".Name)
                {
                }
                fieldelement(CompanyName; "Responsibility Center"."Company Name")
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

