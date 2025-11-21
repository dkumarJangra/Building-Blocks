page 97721 "Document Type Setup"
{
    PageType = Card;
    SourceTable = "Document Type Setup";
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
                field("Sub Document Type"; Rec."Sub Document Type")
                {
                }
                field("Approval Required"; Rec."Approval Required")
                {
                }
                field("Indent Required"; Rec."Indent Required")
                {
                }
                field("Job Allocation"; Rec."Job Allocation")
                {
                }
                field("Milestone Compulsory"; Rec."Milestone Compulsory")
                {
                }
                field("Gate Entry Inward Type"; Rec."Gate Entry Inward Type")
                {
                }
                field("Gate Entry Required"; Rec."Gate Entry Required")
                {
                    Visible = false;
                }
                field("PO No. Series"; Rec."PO No. Series")
                {
                }
                field("GRN No. Series"; Rec."GRN No. Series")
                {
                }
                field("Posted GRN No Series"; Rec."Posted GRN No Series")
                {
                }
                field("Invoice No. Series"; Rec."Invoice No. Series")
                {
                }
                field("Posted Invoice No. Series"; Rec."Posted Invoice No. Series")
                {
                    Visible = false;
                }
                field("FBW PO No. Series"; Rec."FBW PO No. Series")
                {
                }
                field("FBW GRN No. Series"; Rec."FBW GRN No. Series")
                {
                }
                field("FBW Posted GRN No Series"; Rec."FBW Posted GRN No Series")
                {
                }
                field("FBW Invoice No. Series"; Rec."FBW Invoice No. Series")
                {
                }
                field("FBW Posted Invoice No. Series"; Rec."FBW Posted Invoice No. Series")
                {
                }
                field("Control GL Account"; Rec."Control GL Account")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Copy Employee Dept-CC"; Rec."Copy Employee Dept-CC")
                {
                }
                field("Def. Gen Prod Posting Group"; Rec."Def. Gen Prod Posting Group")
                {
                }
                field("Work Tax Applicable"; Rec."Work Tax Applicable")
                {
                }
                field("Sales Tax Comments"; Rec."Sales Tax Comments")
                {
                }
                field("Excise Duty Comments"; Rec."Excise Duty Comments")
                {
                }
                field("Terms of Payments"; Rec."Terms of Payments")
                {
                    Visible = false;
                }
                field("Service Tax"; Rec."Service Tax")
                {
                }
                field("Transit Insurance"; Rec."Transit Insurance")
                {
                }
                field("Inspection Remarks"; Rec."Inspection Remarks")
                {
                }
                field("Packaging & Forwarding"; Rec."Packaging & Forwarding")
                {
                }
                field("Price Basis"; Rec."Price Basis")
                {
                }
                field("Freight Terms"; Rec."Freight Terms")
                {
                }
                field("DD Comm/Bank Charges"; Rec."DD Comm/Bank Charges")
                {
                }
                field("Warranty/Guarantee Terms"; Rec."Warranty/Guarantee Terms")
                {
                }
                field("Entry Tax/Octroi Terms"; Rec."Entry Tax/Octroi Terms")
                {
                }
                field("Installation Terms"; Rec."Installation Terms")
                {
                }
                field("Service Tax-Installation"; Rec."Service Tax-Installation")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action(Initiator)
                {
                    Caption = 'Initiator';
                    RunObject = Page "Document Type Initiator";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "Sub Document Type" = FIELD("Sub Document Type");
                    RunPageView = SORTING("Document Type", "Sub Document Type", "User Code", "Key Responsibility Center")
                                  ORDER(Ascending);
                }
            }
        }
    }
}

