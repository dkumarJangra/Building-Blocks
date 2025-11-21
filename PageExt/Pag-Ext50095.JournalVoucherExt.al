pageextension 50095 "BBG Journal Voucher Ext" extends "Journal Voucher"
{
    layout
    {
        // Add changes to page layout here
        modify("Party Type")
        {
            Visible = false;
        }
        modify("Party Code")
        {
            Visible = false;
        }
        modify("Provisional Entry")
        {
            Visible = false;
        }
        modify("Applied Provisional Entry")
        {
            Visible = false;
        }
        modify("TDS Section Code")
        {
            Visible = false;
        }
        modify("Include GST in TDS Base")
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
        modify("Account Name")
        {
            Visible = false;
        }
        modify("Check Printed")
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
        modify("GST Group Code")
        {
            Visible = false;
        }
        modify("HSN/SAC Code")
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
        modify("Cheque No.")
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
        modify("Shortcut Dimension 1 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = false;
        }
        modify(ShortcutDimCode3)
        {
            Visible = true;
        }
        modify(ShortcutDimCode4)
        {
            Visible = false;
        }
        modify(ShortcutDimCode5)
        {
            Visible = false;
        }
        modify(ShortcutDimCode6)
        {
            Visible = false;
        }
        addafter("Document No.")
        {
            field("Tax Type"; Rec."Tax Type")
            {
                ApplicationArea = All;

            }
            field("GST Component Code"; Rec."GST Component Code")
            {
                ApplicationArea = All;

            }
            field("Project Unit No."; Rec."Project Unit No.")
            {
                ApplicationArea = All;

            }

        }
        moveafter("Project Unit No."; "Location Code")
        addafter("Location Code")
        {
            field(Reason; Rec.Reason)
            {
                ApplicationArea = All;

            }
        }
        moveafter(Reason; "Account Type")
        moveafter("Account Type"; "Account No.")
        moveafter("Account No."; Description)
        moveafter(Description; "Debit Amount")
        moveafter("Debit Amount"; "Credit Amount")
        moveafter("Credit Amount"; "Gen. Posting Type")
        moveafter("Gen. Posting Type"; "Gen. Bus. Posting Group")
        moveafter("Gen. Bus. Posting Group"; "Gen. Prod. Posting Group")
        moveafter("Gen. Prod. Posting Group"; Amount)
        addafter(Amount)
        {
            field("Amount Excl. GST"; Rec."Amount Excl. GST")
            {
                ApplicationArea = All;

            }
        }
        moveafter("Amount Excl. GST"; "Bal. Account Type")
        moveafter("Bal. Account Type"; "Bal. Account No.")
        moveafter("Bal. Account No."; "Bal. Gen. Posting Type")
        moveafter("Bal. Gen. Posting Type"; "Bal. Gen. Bus. Posting Group")
        moveafter("Bal. Gen. Bus. Posting Group"; "Bal. Gen. Prod. Posting Group")
        addafter("Bal. Gen. Prod. Posting Group")
        {
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
            field("Location State Code"; Rec."Location State Code")
            {
                ApplicationArea = All;

            }
            field("GST on Advance Payment"; Rec."GST on Advance Payment")
            {
                ApplicationArea = All;

            }
            field("Ship-to Code"; Rec."Ship-to Code")
            {
                ApplicationArea = All;

            }

        }
        moveafter("Ship-to Code"; "GST Credit")
        addafter("GST Credit")
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
            field("GST Reason Type"; Rec."GST Reason Type")
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
        Memberof: Record "Access Control";


    trigger OnOpenPage()
    begin
        memberof.RESET;
        memberof.SETRANGE("User Name", USERID);
        memberof.SETFILTER("Role ID", 'DDS-CRJV');
        IF NOT memberof.FIND('-') THEN
            ERROR('You dont have permission to Create JV');

    end;
}