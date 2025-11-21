pageextension 50093 "BBG Bank Receipt Vouchaer Ext" extends "Bank Receipt Voucher"
{
    layout
    {
        // Add changes to page layout here
        modify("Check Printed")
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
        modify("Amount Excl. GST")
        {
            Visible = false;
        }
        modify("GST TCS State Code")
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
        modify("GST Group Type")
        {
            Visible = false;
        }
        modify("Customer GST Reg. No.")
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
        modify("GST Place of Supply")
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
        modify("T.C.A.N. No.")
        {
            Visible = false;
        }
        modify("TCS On Recpt. Of Pmt. Amount")
        {
            Visible = false;
        }
        modify("Amount (LCY)")
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

        addafter("Document No.")
        {
            field("Posting Type"; Rec."Posting Type")
            {
                ApplicationArea = All;

            }
            field("Party Type"; Rec."Party Type")
            {
                ApplicationArea = all;
            }
            field("Party Code"; Rec."Party Code")
            {
                ApplicationArea = all;
            }
        }

        moveafter("Account No."; Description)
        moveafter(Description; "TCS Nature of Collection")
        moveafter("TCS Nature of Collection"; Amount)
        moveafter(Amount; "Debit Amount")
        moveafter("Debit Amount"; "Credit Amount")
        moveafter("Credit Amount"; "Bal. Account Type")
        moveafter("Bal. Account Type"; "Bal. Account No.")
        addafter("Bal. Account No.")
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
        moveafter("GST on Advance Payment"; "Ship-to Code")
        moveafter("Ship-to Code"; "Location Code")
        moveafter("Location Code"; "Applies-to Doc. Type")
        moveafter("Applies-to Doc. Type"; "Applies-to Doc. No.")
        addafter("Applies-to Doc. No.")
        {
            field("GST Reason Type"; Rec."GST Reason Type")
            {
                ApplicationArea = all;
            }

        }
        moveafter("GST Reason Type"; "Bank Charge")
        addafter("Bank Charge")
        {
            field("Order Address Code"; Rec."Order Address Code")
            {
                ApplicationArea = all;
            }
            field("Vendor GST Reg. No."; Rec."Vendor GST Reg. No.")
            {
                ApplicationArea = all;
            }
            field("Bill to-Location(POS)"; Rec."Bill to-Location(POS)")
            {
                ApplicationArea = all;
            }

        }
        moveafter("Bill to-Location(POS)"; "GST TDS/GST TCS")
        moveafter("GST TDS/GST TCS"; "GST TDS/TCS Base Amount")
        addafter("GST TDS/TCS Base Amount")
        {
            field("GST TDS/TCS Base Amount (LCY)"; Rec."GST TDS/TCS Base Amount (LCY)")
            {
                ApplicationArea = all;
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
            field("GST TDS/TCS Amount (LCY)"; Rec."GST TDS/TCS Amount (LCY)")
            {
                ApplicationArea = all;
            }
        }
        addafter("Cheque No.")
        {
            field("BBG Cheque No."; Rec."BBG Cheque No.")
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
        Memberof: Record "Access Control";




    trigger OnOpenPage()
    begin
        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETFILTER("Role ID", 'DDS-CRBRV');
        IF NOT Memberof.FIND('-') THEN
            ERROR('You dont have permission to Create JV');

    end;
}