pageextension 50020 "BBG Purchase Quote Ext" extends "Purchase Quote"
{
    layout
    {
        // Add changes to page layout here
        addafter(General)
        {
            group("BBG Fields")
            {
                field("Purch. Req. No."; Rec."Indent No.")
                {
                    ApplicationArea = All;
                }
                field("Enquiry No."; Rec."Enquiry No.")
                {
                    ApplicationArea = All;
                }

            }
        }
        addafter("BBG Fields")
        {
            group("Terms & Condition")
            {
                part("Sales Tax"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                  "Term Type" = CONST("Sales Tax"),
                                  "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Excise Duty"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                  "Term Type" = CONST("Excise Duty"),
                                  "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Temrs of Payment"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                  "Term Type" = CONST(Payment),
                                  "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Service Tax"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                  "Term Type" = CONST("Service Tax"),
                                  "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Transit Insurance"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                  "Term Type" = CONST(Insurance),
                                  "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Inspection Remarks"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                  "Term Type" = CONST("Inspection Authority"),
                                  "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Packaging && Forwarding"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                  "Term Type" = CONST("Packaging & Forwarding"),
                                  "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("F.O.R"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                  "Term Type" = CONST("F.O.R"),
                                  "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part(Delivery; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                  "Term Type" = CONST(Delivery),
                                  "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Price Basis"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                  "Term Type" = CONST("Price Basis"),
                                  "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Freight Terms"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                  "Term Type" = CONST(Freight),
                                  "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("DD Comm/Bank Charges"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                  "Term Type" = CONST("DD Comm/Bank Charges"),
                                  "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Warranty/Guarantee Terms"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                  "Term Type" = CONST("Warranty/Guarantee Certificate"),
                                  "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Entry Tax/Octroi Terms"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                  "Term Type" = CONST("Entry Tax/Octroi Tax"),
                                  "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Installation Terms"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                  "Term Type" = CONST("Installation Terms"),
                                  "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Service Tax-Installation"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                  "Term Type" = CONST("Service Tax-Installation"),
                                  "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part(Instructions; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                  "Term Type" = CONST(Instructions),
                                  "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(Approvals)
        {
            action("Material Properties")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CurrPage.PurchLines.PAGE.OpenMaterialFrm; //ALLESP BCL0003 14-08-2007
                end;
            }
        }
    }

    var
        myInt: Integer;
}