pageextension 50094 "BBG Contra Voucher Ext" extends "Contra Voucher"
{
    layout
    {
        // Add changes to page layout here
        modify("Account Name")
        {
            Visible = false;
        }
        modify("Location Code")
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
            Visible = false;
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
        modify("Applies-to Doc. Type")
        {
            Visible = true;
        }
        modify("Applies-to Doc. No.")
        {
            Visible = true;
        }
        modify("Bank Payment Type")
        {
            Visible = true;
        }

        addafter("Campaign No.")
        {
            field("Posting Type"; Rec."Posting Type")
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
            field("Ref Document Type"; Rec."Ref Document Type")
            {
                ApplicationArea = All;

            }
            field("Tran Type"; Rec."Tran Type")
            {
                ApplicationArea = All;

            }
        }
        moveafter("Tran Type"; "Currency Code")
        moveafter("Currency Code"; Amount)
        moveafter(Amount; "Debit Amount")
        moveafter("Debit Amount"; "Credit Amount")
        moveafter("Credit Amount"; "Bal. Account Type")
        moveafter("Bal. Account Type"; "Bal. Account No.")
        addafter("Bal. Account No.")
        {
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
        moveafter("Ship-to Code"; "Applies-to Doc. Type")
        moveafter("Applies-to Doc. Type"; "Applies-to Doc. No.")
        moveafter("Applies-to Doc. No."; "Bank Payment Type")
        addafter("Bank Payment Type")
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
        LastNo: Code[20];
        Memberof: Record "Access Control";

    trigger OnOpenPage()
    begin
        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETFILTER("Role ID", 'DDS-CRCONV');
        IF NOT Memberof.FIND('-') THEN
            ERROR('You dont have permission to Create JV');
    end;
}