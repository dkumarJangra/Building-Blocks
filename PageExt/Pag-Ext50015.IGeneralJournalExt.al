pageextension 50015 "BBG General Journal Ext" extends "General Journal"
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
        modify("TCS Nature of Collection")
        {
            Visible = false;
        }
        modify("Excl. GST in TCS Base")
        {
            Visible = false;
        }
        modify("T.C.A.N. No.")
        {
            Visible = false;
        }
        modify("Tax Type")
        {
            Visible = false;
        }
        modify("GST Component Code")
        {
            Visible = false;
        }
        modify("GST TDS/GST TCS")
        {
            Visible = false;
        }
        modify("GST TCS State Code")
        {
            Visible = false;
        }
        modify("GST TDS/TCS Base Amount")
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
        modify("Vendor GST Reg. No.")
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
        modify("Nature of Remittance")
        {
            Visible = false;
        }
        modify("Act Applicable")
        {
            Visible = false;
        }
        modify("TDS Certificate Receivable")
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
        modify("T.A.N. No.")
        {
            Visible = false;
        }
        modify("Amount (LCY)")
        {
            Visible = false;
        }
        modify("Debit Amount")
        {
            Visible = false;
        }
        modify("Credit Amount")
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
        modify("Check Printed")
        {
            Visible = false;
        }
        modify(Correction)
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
        modify("Include GST in TDS Base")
        {
            Visible = false;
        }
        addafter("Posting Date")
        {
            field("Ref Document Type"; Rec."Ref Document Type")
            {
                ApplicationArea = All;
            }
            field("Order Ref No."; Rec."Order Ref No.")
            {
                ApplicationArea = all;
            }

            field("Unit No."; Rec."Unit No.")
            {
                ApplicationArea = all;
            }
            field("Receipt Line No."; Rec."Receipt Line No.")
            {
                ApplicationArea = all;
            }
            field("Payment Mode"; Rec."Payment Mode")
            {
                ApplicationArea = all;
            }
        }

        // addafter(AccName)
        // {
        //     field("Account Balance"; AcBal)
        //     {
        //         ApplicationArea = all;
        //     }
        // }
        // addafter("Bal. Account Name")
        // {
        //     field("Bal. Account Balance"; BAcBal)
        //     {
        //         ApplicationArea = all;
        //     }
        //     field(Region; Rec."Shortcut Dimension 1 Code" + ' ' + CostCenterName)
        //     {
        //         ApplicationArea = all;
        //     }
        //     field("Cost Center"; Rec."Shortcut Dimension 2 Code" + ' ' + DeptName)
        //     {
        //         ApplicationArea = all;
        //     }
        //     field("To Region"; ShortcutDimCode[3] + ' ' + CFDesc)
        //     {
        //         ApplicationArea = all;
        //     }
        //     field(FA; Rec."Employee No." + ' ' + EmpName)
        //     {
        //         ApplicationArea = all;
        //     }
        //     field(Narration; Rec.Narration)
        //     {
        //         ApplicationArea = all;
        //     }
        // }

        moveafter("Payment Mode"; "Document Type")
        moveafter("Document Type"; "Document No.")
        addafter("Document No.")
        {
            field("Posting Type"; Rec."Posting Type")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Posting Type"; "Account Type")
        moveafter("Account Type"; "Account No.")
        addafter("Account No.")
        {
            field(Verified; Rec.Verified)
            {
                ApplicationArea = all;
            }
            field("Verified By"; Rec."Verified By")
            {
                ApplicationArea = all;
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Created By"; "GST on Advance Payment")
        moveafter("GST on Advance Payment"; Description)
        moveafter(Description; "Gen. Posting Type")
        moveafter("Gen. Posting Type"; "Gen. Bus. Posting Group")
        moveafter("Gen. Bus. Posting Group"; "Gen. Prod. Posting Group")
        moveafter("Gen. Prod. Posting Group"; Amount)
        moveafter(Amount; "Amount Excl. GST")
        moveafter("Amount Excl. GST"; "Bal. Account Type")
        moveafter("Bal. Account Type"; "Bal. Account No.")
        moveafter("Bal. Account No."; "Bal. Gen. Posting Type")
        moveafter("Bal. Gen. Posting Type"; "Bal. Gen. Bus. Posting Group")
        moveafter("Bal. Gen. Bus. Posting Group"; "Bal. Gen. Prod. Posting Group")
        moveafter("Bal. Gen. Prod. Posting Group"; "Deferral Code")
        moveafter("Deferral Code"; "GST Assessable Value")
        moveafter("GST Assessable Value"; "Custom Duty Amount")
        moveafter("Custom Duty Amount"; "Bill of Entry No.")
        moveafter("Bill of Entry No."; "Bill of Entry Date")
        moveafter("Bill of Entry Date"; "Without Bill Of Entry")
        addafter("Without Bill Of Entry")
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
        addafter("Location State Code")
        {
            field("GST Reason Type"; Rec."GST Reason Type")
            {
                ApplicationArea = all;
            }
        }
        moveafter("GST Reason Type"; "GST Credit")
        addafter("GST Credit")
        {
            field(Exempted; Rec.Exempted)
            {
                ApplicationArea = all;
            }
            field("Ship-to Code"; Rec."Ship-to Code")
            {
                ApplicationArea = all;
            }
            field("Bill Of Export No."; Rec."Bill Of Export No.")
            {
                ApplicationArea = all;
            }
            field("Bill Of Export Date"; Rec."Bill Of Export Date")
            {
                ApplicationArea = all;
            }
            field("GST Without Payment of Duty"; Rec."GST Without Payment of Duty")
            {
                ApplicationArea = all;
            }
        }
        moveafter("GST Without Payment of Duty"; "Location Code")
        addafter("Location Code")
        {
            field("Sales Invoice Type"; Rec."Sales Invoice Type")
            {
                ApplicationArea = all;
            }
            field("Purch. Invoice Type"; Rec."Purch. Invoice Type")
            {
                ApplicationArea = all;
            }

        }
        moveafter("Purch. Invoice Type"; "Order Address Code")
        addafter("Order Address Code")
        {
            field("Bill to-Location(POS)"; Rec."Bill to-Location(POS)")
            {
                ApplicationArea = all;
            }
            field("Inc. GST in TDS Base"; Rec."Inc. GST in TDS Base")
            {
                ApplicationArea = all;
            }
            field("Reference Invoice No."; Rec."Reference Invoice No.")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Reference Invoice No."; Comment)
        addafter(Comment)
        {
            field("Rate Change Applicable"; Rec."Rate Change Applicable")
            {
                ApplicationArea = all;
            }
            field("Supply Finish Date"; Rec."Supply Finish Date")
            {
                ApplicationArea = all;
            }
            field("Posting No. Series"; Rec."Posting No. Series")
            {
                ApplicationArea = all;
            }
            field("Payment Date"; Rec."Payment Date")
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
        GenJnlLineL: Record "Gen. Journal Line";
        Emp: Record Employee;
        EmpName: Text[200];
        Dimvalue: Record "Dimension Value";
        CostCenterName: Text[200];
        GLSetup: Record "General Ledger Setup";
        CFDesc: Text[120];
        GLJnlLine: Record "Gen. Journal Line";
        GLEntry: Record "G/L Entry";
        LastNo: Code[20];
        DeptName: Text[200];
        AcBal: Decimal;
        BAcBal: Decimal;
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        BankAcc: Record "Bank Account";
        FA: Record "Fixed Asset";
        CheckLine: Codeunit "Gen. Jnl.-Check Line";
        MemberOf: Record "Access Control";
        DimSetEntry: Record "Dimension Set Entry";

    trigger OnOpenPage()
    begin
        GLSetup.GET;  //SC
    end;

    trigger OnAfterGetRecord()
    begin

        //SC ->>
        EmpName := '';
        IF Rec."Employee No." <> '' THEN BEGIN
            IF Emp.GET(Rec."Employee No.") THEN
                EmpName := Emp.FullName;
        END;

        CostCenterName := '';
        IF Rec."Shortcut Dimension 1 Code" <> '' THEN BEGIN
            IF Dimvalue.GET(GLSetup."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code") THEN
                CostCenterName := Dimvalue.Name;
        END;


        CFDesc := '';
        // ALLE MM Code Commented

        //                IF JLDim.GET(81, "Journal Template Name", "Journal Batch Name", "Line No.", 0, GLSetup."Shortcut Dimension 3 Code") THEN BEGIN
        //     IF Dimvalue.GET(GLSetup."Shortcut Dimension 3 Code", JLDim."Dimension Value Code") THEN
        //         CFDesc := Dimvalue.Name;
        // END;

        // ALLE MM Code Commented
        // ALLE MM Code Added
        DimSetEntry.RESET;
        DimSetEntry.SETRANGE("Dimension Set ID", Rec."Dimension Set ID");
        DimSetEntry.SETRANGE("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
        IF DimSetEntry.FINDFIRST THEN
            CFDesc := DimSetEntry."Dimension Value Code";
        // ALLE MM Code Added
        DeptName := '';
        IF Rec."Shortcut Dimension 2 Code" <> '' THEN BEGIN
            IF Dimvalue.GET(GLSetup."Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code") THEN
                DeptName := Dimvalue.Name;
        END;

        AcBal := 0;
        IF Rec."Account No." <> '' THEN
            CASE Rec."Account Type" OF
                Rec."Account Type"::"G/L Account":
                    IF GLAcc.GET(Rec."Account No.") THEN BEGIN
                        GLAcc.CALCFIELDS(Balance);
                        AcBal := GLAcc.Balance;
                    END;
                Rec."Account Type"::Customer:
                    IF Cust.GET(Rec."Account No.") THEN BEGIN
                        Cust.CALCFIELDS(Balance);
                        AcBal := Cust.Balance;
                    END;
                Rec."Account Type"::Vendor:
                    IF Vend.GET(Rec."Account No.") THEN BEGIN
                        Vend.CALCFIELDS(Balance);
                        AcBal := Vend.Balance;
                    END;
                Rec."Account Type"::"Bank Account":
                    IF BankAcc.GET(Rec."Account No.") THEN BEGIN
                        BankAcc.CALCFIELDS(Balance);
                        AcBal := BankAcc.Balance;
                    END;
                Rec."Account Type"::"Fixed Asset":

                    AcBal := 0;
            END;

        BAcBal := 0;
        IF Rec."Bal. Account No." <> '' THEN
            CASE Rec."Bal. Account Type" OF
                Rec."Bal. Account Type"::"G/L Account":
                    IF GLAcc.GET(Rec."Bal. Account No.") THEN BEGIN
                        GLAcc.CALCFIELDS(Balance);
                        BAcBal := GLAcc.Balance;
                    END;
                Rec."Bal. Account Type"::Customer:
                    IF Cust.GET(Rec."Bal. Account No.") THEN BEGIN
                        Cust.CALCFIELDS(Balance);
                        BAcBal := Cust.Balance;
                    END;
                Rec."Bal. Account Type"::Vendor:
                    IF Vend.GET(Rec."Bal. Account No.") THEN BEGIN
                        Vend.CALCFIELDS(Balance);
                        BAcBal := Vend.Balance;
                    END;
                Rec."Bal. Account Type"::"Bank Account":
                    IF BankAcc.GET(Rec."Bal. Account No.") THEN BEGIN
                        BankAcc.CALCFIELDS(Balance);
                        BAcBal := BankAcc.Balance;
                    END;
                Rec."Bal. Account Type"::"Fixed Asset":

                    BAcBal := 0;
            END;

        //SC <<-
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //GKG
        Rec."Ref Document Type" := Rec."Ref Document Type"::Order;
    end;
}