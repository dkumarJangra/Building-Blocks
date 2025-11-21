page 97865 "Company Information List Part"
{
    Caption = 'Company Information';
    PageType = ListPart;
    SourceTable = "Company Information";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Company Information")
            {
                Caption = 'Company Information';
                field(Name; Rec.Name)
                {
                    ShowCaption = false;
                }
                field(Picture; Rec.Picture)
                {
                    ShowCaption = false;
                }
            }
        }
    }

    actions
    {
    }
}

