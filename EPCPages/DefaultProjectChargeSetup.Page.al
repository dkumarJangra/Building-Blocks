page 98008 "Default Project Charge Setup"
{
    PageType = Card;
    SourceTable = "Document Master";
    SourceTableView = WHERE("Default Setup" = CONST(true));
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Project Code"; Rec."Project Code")
                {
                }
                field(Code; Rec.Code)
                {
                }
                field("Rate/Sq. Yd"; Rec."Rate/Sq. Yd")
                {
                }
                field("Fixed Price"; Rec."Fixed Price")
                {
                }
                field(Description; Rec.Description)
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
                field("App. Charge Code"; Rec."App. Charge Code")
                {
                }
                field("App. Charge Name"; Rec."App. Charge Name")
                {
                }
                field("Default Setup"; Rec."Default Setup")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Rec."Default Setup" := TRUE;
    end;

    trigger OnOpenPage()
    begin
        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
        /*
        MemberOf.RESET;
        MemberOf.SETRANGE(MemberOf."User ID",USERID);
        MemberOf.SETRANGE(MemberOf."Role ID",'DEFCHARGETYPE');
        IF NOT MemberOf.FINDFIRST THEN
          ERROR('You are not aurthorised to open this form');
        */
        // ALLE MM Code Commented as Member of table has been remove in NAV 2016

    end;
}

