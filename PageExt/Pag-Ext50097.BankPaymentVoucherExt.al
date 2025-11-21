pageextension 50097 "BBG Bank Payment Voucher Ext" extends "Bank Payment Voucher"
{
    layout
    {
        // Add changes to page layout here
        modify("GST Group Code")
        {
            Visible = false;
        }
        modify("HSN/SAC Code")
        {
            Visible = false;
        }
        modify("GST Group Type")
        {
            Visible = false;
        }
        modify("Location GST Reg. No.")
        {
            Visible = false;
        }
        modify("GST Vendor Type")
        {
            Visible = false;
        }
        modify("Account Name")
        {
            Visible = false;
        }
        modify("Check Printed")
        {
            Visible = false;
        }
        modify("EU 3-Party Trade")
        {
            Visible = false;
        }
        modify("Gen. Posting Type")
        {
            Visible = false;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = false;
        }
        modify("TCS Nature of Collection")
        {
            Visible = false;
        }
        modify("T.C.A.N. No.")
        {
            Visible = false;
        }
        modify("Amount (LCY)")
        {
            Visible = false;
        }
        modify("Bal. Gen. Posting Type")
        {
            Visible = false;
        }
        modify("Bal. Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Bal. Gen. Prod. Posting Group")
        {
            Visible = false;
        }
        modify("Deferral Code")
        {
            Visible = false;
        }
        modify(Correction)
        {
            Visible = false;
        }
        modify(Comment)
        {
            Visible = false;
        }
        modify("Applies-to Doc. Type")
        {
            Visible = true;
        }
        modify("Applies-to Doc. No.")
        {
            Visible = true;
        }
        addafter("External Document No.")
        {
            field("Tran Type"; Rec."Tran Type")
            {
                ApplicationArea = All;
            }
            field("Posting Type"; Rec."Posting Type")
            {
                ApplicationArea = All;
            }
            field("Ref Document Type"; Rec."Ref Document Type")
            {
                ApplicationArea = All;
            }
            field("Order Ref No."; Rec."Order Ref No.")
            {
                ApplicationArea = All;
            }
            field("Milestone Code"; Rec."Milestone Code")
            {
                ApplicationArea = All;
            }
            field(RegDimName; Rec.RegDimName)
            {
                ApplicationArea = All;
            }
            field(Verified; Rec.Verified)
            {
                ApplicationArea = All;
            }
            field("Verified By"; Rec."Verified By")
            {
                ApplicationArea = All;
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = All;
            }
            field("Introducer Code"; Rec."Introducer Code")
            {
                ApplicationArea = All;
            }
            field("Cheque clear Date"; Rec."Cheque clear Date")
            {
                ApplicationArea = All;
            }
            field("Branch Code"; Rec."Branch Code")
            {
                ApplicationArea = All;
            }
            field("Associate Code"; Rec."Associate Code")
            {
                ApplicationArea = All;
            }
            field("Unit Code"; Rec."Unit Code")
            {
                ApplicationArea = All;
            }
            field(Extent; Rec.Extent)
            {
                ApplicationArea = All;
            }
            field("Associate Name"; Rec."Associate Name")
            {
                ApplicationArea = All;
            }
            field("GST Transaction Type"; Rec."GST Transaction Type")
            {
                ApplicationArea = All;

            }
            field("LC/BG No."; Rec."LC/BG No.")
            {
                ApplicationArea = All;

            }
            field("BG Charges Type"; Rec."BG Charges Type")
            {
                ApplicationArea = All;

            }
        }
        //ALLEDG
        addafter("Document No.")
        {
            field("Party Type"; Rec."Party Type")
            {
                ApplicationArea = all;
            }
            field("Party Code"; Rec."Party Code")
            {
                ApplicationArea = all;
            }

        }
        addafter("Cheque No.")
        {
            field("BBG Cheque No."; Rec."BBG Cheque No.")
            {
                ApplicationArea = all;
                Caption = 'BBG Cheque No.';
            }
        }
        moveafter("Party Code"; "Account Type")
        moveafter("Account Type"; "Account No.")
        moveafter("Account No."; Description)
        moveafter("Created By"; "Cheque Date")
        moveafter("Cheque Date"; "Cheque No.")
        moveafter("Unit Code"; "T.A.N. No.")
        moveafter("T.A.N. No."; "TDS Section Code")
        moveafter("TDS Section Code"; "Nature of Remittance")
        moveafter("Nature of Remittance"; "Act Applicable")
        moveafter("Act Applicable"; "Currency Code")
        moveafter("Currency Code"; Amount)
        moveafter(Amount; "Debit Amount")
        moveafter("Debit Amount"; "Credit Amount")
        moveafter("Credit Amount"; "Amount Excl. GST")
        moveafter("Amount Excl. GST"; "Bal. Account Type")
        moveafter("Bal. Account Type"; "Bal. Account No.")
        addafter("GST Transaction Type")
        {
            field("GST Bill-to/BuyFrom State Code"; Rec."GST Bill-to/BuyFrom State Code")
            {
                ApplicationArea = all;
            }
            field("GST Ship-to State Code"; Rec."GST Ship-to State Code")
            {
                ApplicationArea = all;
            }

        }
        moveafter("GST Ship-to State Code"; "Location State Code")
        moveafter("Location State Code"; "GST on Advance Payment")
        addafter("GST on Advance Payment")
        {
            field("Ship-to Code"; Rec."Ship-to Code")
            {
                ApplicationArea = all;
            }
            field("Tax Type"; Rec."Tax Type")
            {
                ApplicationArea = all;
            }

        }
        moveafter("Tax Type"; "Location Code")
        moveafter("Location Code"; "Applies-to Doc. Type")
        moveafter("Applies-to Doc. Type"; "Applies-to Doc. No.")
        moveafter("Applies-to Doc. No."; "Bank Payment Type")
        addafter("Bank Payment Type")
        {
            field("GST Reason Type"; Rec."GST Reason Type")
            {
                ApplicationArea = all;
            }
        }
        addafter("BG Charges Type")
        {
            field("Inc. GST in TDS Base"; Rec."Inc. GST in TDS Base")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Inc. GST in TDS Base"; "Bank Charge")
        addafter("Bank Charge")
        {
            field("Order Address Code"; Rec."Order Address Code")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Order Address Code"; "Vendor GST Reg. No.")
        addafter("Vendor GST Reg. No.")
        {
            field("Bill to-Location(POS)"; Rec."Bill to-Location(POS)")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Bill to-Location(POS)"; "GST TDS/GST TCS")
        moveafter("GST TDS/GST TCS"; "GST TCS State Code")
        moveafter("GST TCS State Code"; "GST TDS/TCS Base Amount")
        addafter("GST TDS/TCS Base Amount")
        {
            field("GST TDS/TCS Base Amount (LCY)"; Rec."GST TDS/TCS Base Amount (LCY)")
            {
                ApplicationArea = all;
            }
            field("GST TDS/TCS Amount (LCY)"; Rec."GST TDS/TCS Amount (LCY)")
            {
                ApplicationArea = all;
            }
        }


    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}