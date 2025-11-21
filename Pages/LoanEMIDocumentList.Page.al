page 50282 "Loan EMI Document List"
{
    CardPageID = "Loan EMI Document Card";
    PageType = List;
    SourceTable = "LOAN EMI Document";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Creation Time"; Rec."Creation Time")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Customer Mobile No."; Rec."Customer Mobile No.")
                {
                }
                field("Monthly Income"; Rec."Monthly Income")
                {
                }
                field(Tenure; Rec.Tenure)
                {
                }
                field(Obligation; Rec.Obligation)
                {
                }
                field("Associate ID"; Rec."Associate ID")
                {
                }
            }
        }
    }

    actions
    {
    }
}

