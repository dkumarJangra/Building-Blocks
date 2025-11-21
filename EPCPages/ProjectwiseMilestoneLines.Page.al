page 50060 "Project wise Milestone Lines"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Project Milestone Line";
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
                field("First Milestone %"; Rec."First Milestone %")
                {
                }
                field("Second Milestone %"; Rec."Second Milestone %")
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
                field("Effective From Date"; Rec."Effective From Date")
                {
                }
                field("Effective To Date"; Rec."Effective To Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

