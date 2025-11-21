pageextension 50043 "BBG Payment Journal Ext" extends "Payment Journal"
{
    layout
    {
        // Add changes to page layout here
        addafter("Document No.")
        {
            field("Project Unit No."; Rec."Project Unit No.")
            {
                ApplicationArea = All;
            }
            field(Reason; Rec.Reason)
            {
                ApplicationArea = All;
            }
            field("Introducer Code"; Rec."Introducer Code")
            {
                ApplicationArea = All;
            }
            field(Verified; Rec.Verified)
            {
                ApplicationArea = All;
            }
            field(RegDimName; Rec.RegDimName)
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
            field("Work Type"; Rec."Work Type")
            {
                ApplicationArea = All;
            }
            field("Emp Advance Type"; Rec."Emp Advance Type")
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
            field(Narration; Rec.Narration)
            {
                ApplicationArea = All;
            }
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
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        Emp: Record Employee;
        EmpName: Text[200];
        DimValue: Record "Dimension Value";
        CostCenterName: Text[200];
        CFDesc: Text[120];
        GLJnlLine: Record "Gen. Journal Line";
        DeptName: Text[200];
        AcBal: Decimal;
        BAcBal: Decimal;
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        BankAcc: Record "Bank Account";
        FA: Record "Fixed Asset";
        DimSetEntry: Record "Dimension Set Entry";
        GLSetup: Record "General Ledger Setup";

    trigger OnOpenPage()
    begin
        GLSetup.Get();
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
            IF DimValue.GET(GLSetup."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code") THEN
                CostCenterName := DimValue.Name;
        END;

        // ALLE MM Code Commented

        //                 CFDesc := '';
        // IF JLDim.GET(81, "Journal Template Name", "Journal Batch Name", "Line No.", 0, GLSetup."Shortcut Dimension 3 Code") THEN BEGIN
        //     IF DimValue.GET(GLSetup."Shortcut Dimension 3 Code", JLDim."Dimension Value Code") THEN
        //         CFDesc := DimValue.Name;
        // END;

        // ALLE MM Code Commented
        // ALLE MM Code Added
        DimSetEntry.RESET;
        DimSetEntry.SETRANGE("Dimension Set ID", Rec."Dimension Set ID");
        DimSetEntry.SETRANGE("Dimension Code", 'EMPLOYEES');
        IF DimSetEntry.FINDFIRST THEN BEGIN
            CFDesc := DimSetEntry."Dimension Value Code";
        END;
        // ALLE MM Code Added

        DeptName := '';
        IF Rec."Shortcut Dimension 2 Code" <> '' THEN BEGIN
            IF DimValue.GET(GLSetup."Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code") THEN
                DeptName := DimValue.Name;
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
                    //IF FA.GET("Account No.") THEN BEGIN
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
                    //IF FA.GET("Bal. Account No.") THEN BEGIN
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