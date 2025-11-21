page 50281 "Loan EMI Document Card"
{
    PageType = Document;
    SourceTable = "LOAN EMI Document";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(General)
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
                field("Customer Name 2"; Rec."Customer Name 2")
                {
                }
                field("Customer Mobile No."; Rec."Customer Mobile No.")
                {
                }
            }
            group(Salaried)
            {
                field("Monthly Income"; Rec."Monthly Income")
                {
                }
                field(Tenure; Rec.Tenure)
                {
                }
                field(Obligation; Rec.Obligation)
                {
                }
                field("Project Name"; Rec."Project Name")
                {
                }
                field(Extent; Rec.Extent)
                {
                }
                field("Loan Amount"; Rec."Loan Amount")
                {
                }
                field("EMI Amount"; Rec."EMI Amount")
                {
                }
                field("Rate of Interest"; Rec."Rate of Interest")
                {
                }
            }
            part(""; "Loan EMI Sub Form")
            {
                SubPageLink = "Reference No." = FIELD("Document No.");
            }
        }
    }

    actions
    {
    }
}

