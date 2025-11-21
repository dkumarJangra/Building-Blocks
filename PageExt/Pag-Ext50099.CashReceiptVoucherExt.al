pageextension 50099 "BBG Cash Receipt Voucher Ext" extends "Cash Receipt Voucher"
{
    layout
    {
        // Add changes to page layout here
        modify("TDS Section Code")
        {
            Visible = false;
        }
        modify("Nature of Remittance")
        {
            Visible = false;
        }
        modify("Act Applicable")
        {
            Visible = false;
        }
        modify("T.A.N. No.")
        {
            Visible = false;
        }
        modify("TDS Certificate Receivable")
        {
            Visible = false;
        }
        modify("GST Group Code")
        {
            Visible = false;
        }
        modify("HSN/SAC Code")
        {
            Visible = false;
        }
        modify("GST TCS State Code")
        {
            Visible = false;
        }
        modify("Account Name")
        {
            Visible = false;
        }
        modify("Currency Code")
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
        modify("TCS On Recpt. Of Pmt. Amount")
        {
            Visible = false;
        }
        modify("Check Printed")
        {
            Visible = false;
        }
        modify("Amount (LCY)")
        {
            Visible = false;
        }
        modify("Cheque No.")
        {
            Visible = false;
        }
        modify("Cheque Date")
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

        moveafter("Account No."; Description)
        moveafter(Description; Amount)
        moveafter(Amount; "Debit Amount")
        moveafter("Debit Amount"; "Credit Amount")
        moveafter("Credit Amount"; "Bal. Account Type")
        addafter("Bal. Account Type")
        {
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
            field("Project Code"; Rec."Project Code")
            {
                ApplicationArea = All;

            }
        }

        moveafter("Project Code"; "Bal. Account No.")

        addafter("Bal. Account No.")
        {
            field("Tran Type"; Rec."Tran Type")
            {
                ApplicationArea = All;

            }
            field("Order Ref No."; Rec."Order Ref No.")
            {
                ApplicationArea = All;

            }
            field("Ref Document Type"; Rec."Ref Document Type")
            {
                ApplicationArea = All;

            }
            field("Milestone Code"; Rec."Milestone Code")
            {
                ApplicationArea = All;

            }
            field("Posting Type"; Rec."Posting Type")
            {
                ApplicationArea = All;

            }
            field("GST Bill-to/BuyFrom State Code"; Rec."GST Bill-to/BuyFrom State Code")
            {
                ApplicationArea = All;

            }
            field("GST Ship-to State Code"; Rec."GST Ship-to State Code")
            {
                ApplicationArea = All;

            }

        }

        moveafter("GST Ship-to State Code"; "Location Code")

        addafter("Location Code")
        {
            field("Location State Code"; Rec."Location State Code")
            {
                ApplicationArea = All;

            }
        }

        moveafter("Location State Code"; "GST on Advance Payment")
        addafter("GST on Advance Payment")
        {
            field("Ship-to Code"; Rec."Ship-to Code")
            {
                ApplicationArea = All;

            }
        }
        moveafter("Ship-to Code"; "Applies-to Doc. Type")
        moveafter("Applies-to Doc. Type"; "Applies-to Doc. No.")
        addafter("Applies-to Doc. No.")
        {
            field("GST Reason Type"; Rec."GST Reason Type")
            {
                ApplicationArea = All;

            }
            field("Order Address Code"; Rec."Order Address Code")
            {
                ApplicationArea = All;

            }
            field("Vendor GST Reg. No."; Rec."Vendor GST Reg. No.")
            {
                ApplicationArea = All;

            }
            field("Bill to-Location(POS)"; Rec."Bill to-Location(POS)")
            {
                ApplicationArea = All;

            }
        }
        moveafter("Bill to-Location(POS)"; "GST TDS/GST TCS")
        moveafter("GST TDS/GST TCS"; "GST TDS/TCS Base Amount")
        addafter("GST TDS/TCS Base Amount")
        {
            field("GST TDS/TCS Base Amount (LCY)"; Rec."GST TDS/TCS Base Amount (LCY)")
            {
                ApplicationArea = All;

            }
            field("GST TDS/TCS Amount (LCY)"; Rec."GST TDS/TCS Amount (LCY)")
            {
                ApplicationArea = All;

            }
        }

    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        memberof: Record "Access Control";

    trigger OnOpenPage()
    begin
        memberof.RESET;
        memberof.SETRANGE("User Name", USERID);
        memberof.SETFILTER("Role ID", 'DDS-CRCRV');
        IF NOT memberof.FIND('-') THEN
            ERROR('You dont have permission to Create JV');
    end;
}