page 97818 "Milestone Completed"
{
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Payment Plan Details";
    SourceTableView = SORTING("Milestone Code", "Payment Plan Code", "Charge Code")
                      ORDER(Ascending);
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Project Code"; Rec."Project Code")
                {
                    Visible = false;
                }
                field("Payment Plan Code"; Rec."Payment Plan Code")
                {
                    Editable = false;
                }
                field("Group Code"; Rec."Group Code")
                {
                    Visible = false;
                }
                field("Milestone Code"; Rec."Milestone Code")
                {
                    Editable = false;
                }
                field("Milestone Description"; Rec."Milestone Description")
                {
                    Editable = false;
                }
                field(Completed; Rec.Completed)
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
        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETFILTER("Role ID", 'ENGGUPDATE');
        IF NOT Memberof.FINDFIRST THEN
            CurrPage.EDITABLE(FALSE)
        ELSE
            CurrPage.EDITABLE(TRUE)
    end;

    var
        PaymentPlanDetails: Record "Payment Plan Details";
        PaymentPlanDetails1: Record "Payment Plan Details";
        PayTermLine: Record "Payment Terms Line Sale";
        a: Integer;
        ppdrec: Record "Payment Plan Details";
        ChargeTotal: Integer;
        Memberof: Record "Access Control";
}

