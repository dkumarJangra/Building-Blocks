pageextension 50042 "BBG Cash Receipt Journal Ext" extends "Cash Receipt Journal"
{
    layout
    {
        // Add changes to page layout here
        addafter("TDS Certificate Receivable")
        {
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
            field("IC Land Purchase"; Rec."IC Land Purchase")
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
            field("Provisional Bill"; Rec."Provisional Bill")
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
            field("Branch Code"; Rec."Branch Code")
            {
                ApplicationArea = All;
            }
            field("Associate Code"; Rec."Associate Code")
            {
                ApplicationArea = All;
            }
            field("Associate Name"; Rec."Associate Name")
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
        GLSetup: Record "General Ledger Setup";
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



    trigger OnOpenPage()
    begin
        GLSetup.GET;   //SC
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

        //                CFDesc := '';
        // IF JLDim.GET(81, "Journal Template Name", "Journal Batch Name", "Line No.", 0, GLSetup."Shortcut Dimension 3 Code") THEN BEGIN
        //     IF DimValue.GET(GLSetup."Shortcut Dimension 3 Code", JLDim."Dimension Value Code") THEN
        //         CFDesc := DimValue.Name;
        // END;

        // ALLE MM Code Commented

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