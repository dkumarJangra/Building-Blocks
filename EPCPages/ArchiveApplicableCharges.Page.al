page 50069 "Archive Applicable Charges"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Archive Document Master";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Archive Date"; Rec."Archive Date")
                {
                }
                field(Version; Rec.Version)
                {
                }
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
                field("User ID"; Rec."User ID")
                {
                }
                field("Archive Time"; Rec."Archive Time")
                {
                }
            }
        }
    }

    actions
    {
    }
}

