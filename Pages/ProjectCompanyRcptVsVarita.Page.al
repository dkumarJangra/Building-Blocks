page 50152 "Project Company Rcpt Vs Varita"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "New Application DevelopmntLine";
    SourceTableView = WHERE("Bank Type" = CONST(ProjectCompany),
                            Posted = CONST(true));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("Payment Method"; Rec."Payment Method")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Cheque No./ Transaction No."; Rec."Cheque No./ Transaction No.")
                {
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                }
                field("Cheque Bank and Branch"; Rec."Cheque Bank and Branch")
                {
                }
                field("Cheque Status"; Rec."Cheque Status")
                {
                }
                field("Chq. Cl / Bounce Dt."; Rec."Chq. Cl / Bounce Dt.")
                {
                }
                field(Posted; Rec.Posted)
                {
                }
                field("Deposit/Paid Bank"; Rec."Deposit/Paid Bank")
                {
                }
                field("LLP Posted Document No."; Rec."LLP Posted Document No.")
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                }
                field("Bank Reco Done in LLP"; Rec."Bank Reco Done in LLP")
                {
                }
            }
        }
    }

    actions
    {
    }
}

