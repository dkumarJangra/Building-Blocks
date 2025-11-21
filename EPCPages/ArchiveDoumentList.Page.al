page 97838 "Archive Doument List"
{
    PageType = List;
    SourceTable = "Archive Document Master";
    UsageCategory = Lists;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Project Code"; Rec."Project Code")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Archive Date"; Rec."Archive Date")
                {
                }
                field("Rate/Sq. Yd"; Rec."Rate/Sq. Yd")
                {
                }
                field("Fixed Price"; Rec."Fixed Price")
                {
                }
                field("Sale/Lease"; Rec."Sale/Lease")
                {
                }
                field(Sequence; Rec.Sequence)
                {
                }
                field("Unit Code"; Rec."Unit Code")
                {
                }
                field("App. Charge Code"; Rec."App. Charge Code")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Version; Rec.Version)
                {
                }
                field("App. Charge Name"; Rec."App. Charge Name")
                {
                }
                field("Direct Associate"; Rec."Direct Associate")
                {
                }
                field("Commision Applicable"; Rec."Commision Applicable")
                {
                }
                field("Rate Not Allowed"; Rec."Rate Not Allowed")
                {
                }
                field(Code; Rec.Code)
                {
                }
            }
        }
    }

    actions
    {
    }
}

