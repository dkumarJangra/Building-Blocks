page 50114 "Charge type Update"
{
    Editable = false;
    PageType = List;
    SourceTable = "Document Master";
    SourceTableView = WHERE(Code = CONST('ADMIN|ADMIN2|BSP1|BSP2|BSP3|BSP4|BSP5|BSP6|PPLAN'),
                            "Document Type" = CONST(Charge),
                            "Unit Code" = CONST(''));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Project Code"; Rec."Project Code")
                {
                }
                field("Rate/Sq. Yd"; Rec."Rate/Sq. Yd")
                {
                }
                field("Fixed Price"; Rec."Fixed Price")
                {
                }
                field("BP Dependency"; Rec."BP Dependency")
                {
                }
                field("Rate Not Allowed"; Rec."Rate Not Allowed")
                {
                }
                field("Project Price Dependency Code"; Rec."Project Price Dependency Code")
                {
                }
                field("Payment Plan Type"; Rec."Payment Plan Type")
                {
                }
                field("Sale/Lease"; Rec."Sale/Lease")
                {
                }
                field("Commision Applicable"; Rec."Commision Applicable")
                {
                }
                field("Direct Associate"; Rec."Direct Associate")
                {
                }
                field(Sequence; Rec.Sequence)
                {
                }
                field("Unit Code"; Rec."Unit Code")
                {
                }
                field("Membership Fee"; Rec."Membership Fee")
                {
                }
                field("App. Charge Code"; Rec."App. Charge Code")
                {
                }
                field("App. Charge Name"; Rec."App. Charge Name")
                {
                }
                field("Default Setup"; Rec."Default Setup")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Version; Rec.Version)
                {
                }
                field("Total Charge Amount"; Rec."Total Charge Amount")
                {
                }
                field("Sub Payment Plan"; Rec."Sub Payment Plan")
                {
                }
                field("Sub Sub Payment Plan Code"; Rec."Sub Sub Payment Plan Code")
                {
                }
                field("New Sequence 1"; Rec."New Sequence 1")
                {
                }
                field("Old Sequence"; Rec."Old Sequence")
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

