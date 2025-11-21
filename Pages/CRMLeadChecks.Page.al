page 60716 "CRM Lead Checks"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "CRM Lead Checks";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Applicable; Rec.Applicable)
                {
                }
            }
            part("Customer Family Details"; "Customer Family Details_1")
            {
                SubPageLink = "Customer Lead ID" = FIELD("No.");
            }
            part("Approved Visit Details"; "Done Visit Details")
            {
                Caption = 'Approved Visit Details';
                SubPageLink = "Customer Lead ID" = FIELD("No.");
            }
        }
    }

    actions
    {
    }
}

