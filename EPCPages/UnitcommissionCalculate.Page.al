page 50280 "Unit & commission Calculate"
{
    //DeleteAllowed = false;
    //Editable = false;
    //InsertAllowed = false;
    //ModifyAllowed = false;
    PageType = List;
    SourceTable = "Unit & Comm. Creation Buffer";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Unit No."; Rec."Unit No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field("Base Amount"; Rec."Base Amount")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Commission Created"; Rec."Commission Created")
                {
                }
                field("Milestone Code"; Rec."Milestone Code")
                {
                }
                field("Direct Associate"; Rec."Direct Associate")
                {
                }
                field("Min. Allotment Amount Not Paid"; Rec."Min. Allotment Amount Not Paid")
                {
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                }
                field("Cheque not Cleared"; Rec."Cheque not Cleared")
                {
                }
                field("Cheque Cleared Date"; Rec."Cheque Cleared Date")
                {
                }
                field("Branch Code"; Rec."Branch Code")
                {
                }
                field("Comm Not Release after FullPmt"; Rec."Comm Not Release after FullPmt")
                {
                }
                field("Charge Code"; Rec."Charge Code")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Application DOJ"; Rec."Application DOJ")
                {
                }
                field("Commission Not Generate"; Rec."Commission Not Generate")
                {
                }
            }
        }
    }

    actions
    {
    }
    trigger OnOpenPage()
    begin
        If UserId <> 'BCUSER' then   //010325
            Error('Contact Admin');   //010325

    end;
}

