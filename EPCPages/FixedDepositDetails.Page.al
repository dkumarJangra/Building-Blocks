page 97788 "Fixed Deposit Details"
{
    // +------------------------------------------+
    // | Voith Turbo Private Limited , Hyderabad  |
    // +------------------------------------------+
    // 
    // -------------------------------------------------------------------------------------------------------------
    // Local Specifications
    // -------------------------------------------------------------------------------------------------------------
    // Nr. Update    Date       SS         No.      Description
    // -------------------------------------------------------------------------------------------------------------
    // L01           26.06.09  Hyd_Msr             New menu items,Import Attachment,Import Attachment2,Import Attachment3,
    //                                             Delete attachments added in the Fixed Deposit menu button.
    // L02           26.06.09  Hyd_Msr             New menu button, "Functions" created.
    // L03           26.06.09  Hyd_Msr             Text constants Text001,Text002,Text003,Text004,Text005 created.
    // L04           06.07.09  Hyd_Msr             To remove filters on the primary key.
    // ALLEPG RIL1.09 121011 : Added fields

    DelayedInsert = true;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Fixed Deposit Details";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("FD No."; Rec."FD No.")
                {
                    Editable = false;
                }
                field("FD Start date"; Rec."FD Start date")
                {
                }
                field("FD maturity date"; Rec."FD maturity date")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                }
                field("Bank Name"; Rec."Bank Name")
                {
                }
                field("Bank FD Account No."; Rec."Bank FD Account No.")
                {
                }
                field("TDS Rate"; Rec."TDS Rate")
                {
                }
                field("TDS Amount"; Rec."TDS Amount")
                {
                }
                field("BG / LC No."; Rec."BG / LC No.")
                {
                }
                field("Bank FD Receipt No."; Rec."Bank FD Receipt No.")
                {
                }
                field("FD Type"; Rec."FD Type")
                {
                }
                field("Benificiary Name"; Rec."Benificiary Name")
                {
                }
                field("Tender Notice No."; Rec."Tender Notice No.")
                {
                }
                field("FD Amount"; Rec."FD Amount")
                {
                }
                field("Total Maturity Amount"; Rec."Total Maturity Amount")
                {
                }
                field("Interest rate"; Rec."Interest rate")
                {
                }
                field("Intrest Amount"; Rec."Intrest Amount")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Actual Closed Date"; Rec."Actual Closed Date")
                {
                }
                field("Int Rate on Liquidation"; Rec."Int Rate on Liquidation")
                {
                }
                field("Interest Amt on Liquidation"; Rec."Interest Amt on Liquidation")
                {
                }
                field("FD Placement Entries Created"; Rec."FD Placement Entries Created")
                {
                }
                field("FD Liquidation Entries Created"; Rec."FD Liquidation Entries Created")
                {
                }
                field(Period; Rec.Period)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Fixed Deposits")
            {
                Caption = '&Fixed Deposits';
                action("Import Attachment")
                {
                    Caption = 'Import Attachment';

                    trigger OnAction()
                    begin
                        Rec.ImportAttachment;
                        CurrPage.UPDATE;
                    end;
                }
                action("Import Attachment 2")
                {
                    Caption = 'Import Attachment 2';

                    trigger OnAction()
                    begin
                        Rec.ImportAttachment2;
                        CurrPage.UPDATE;
                    end;
                }
                action("Import Attachment 3")
                {
                    Caption = 'Import Attachment 3';

                    trigger OnAction()
                    begin
                        Rec.ImportAttachment3;
                        CurrPage.UPDATE;
                    end;
                }
                action("Open Attachments")
                {
                    Caption = 'Open Attachments';

                    trigger OnAction()
                    var
                        Selection: Integer;
                    begin
                        Selection := STRMENU(Text001, 3);
                        IF Selection = 0 THEN
                            EXIT;
                        IF Selection = 1 THEN
                            Rec.OpenAttachment;
                        IF Selection = 2 THEN
                            Rec.OpenAttachment2;
                        IF Selection = 3 THEN
                            Rec.OpenAttachment3;
                    end;
                }
                action("Delete Attachments")
                {
                    Caption = 'Delete Attachments';

                    trigger OnAction()
                    var
                        Selection: Integer;
                    begin
                        Selection := STRMENU(Text001, 1);
                        IF Selection = 0 THEN
                            EXIT;
                        IF Selection = 1 THEN
                            Rec.RemoveAttachment(TRUE);
                        IF Selection = 2 THEN
                            Rec.RemoveAttachment2(TRUE);
                        IF Selection = 3 THEN
                            Rec.RemoveAttachment3(TRUE);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Calculate Interest Amt")
                {
                    Caption = 'Calculate Interest Amt';
                    Visible = false;

                    trigger OnAction()
                    begin
                        Rec.GetInterestAmount;
                        CurrPage.UPDATE;
                        MESSAGE(Text002);
                    end;
                }
                action("Calculate TDS Amt")
                {
                    Caption = 'Calculate TDS Amt';
                    Visible = false;

                    trigger OnAction()
                    begin
                        Rec.GetTDSAmount;
                        CurrPage.UPDATE;
                        MESSAGE(Text003);
                    end;
                }
                action("Generate Bank FD Letter")
                {
                    Caption = 'Generate Bank FD Letter';
                    Visible = false;

                    trigger OnAction()
                    begin
                        IF PAGE.RUNMODAL(PAGE::"Travel Approved Subform", FDDetails) = ACTION::LookupOK THEN BEGIN
                            FDDetails.SETRANGE(Selected, TRUE);
                            REPORT.RUNMODAL(97882, TRUE, FALSE, FDDetails);
                        END;
                    end;
                }
                action("Generate Liquidation Letter")
                {
                    Caption = 'Generate Liquidation Letter';
                    Visible = false;

                    trigger OnAction()
                    begin
                        IF PAGE.RUNMODAL(PAGE::"Travel Approved Subform", FDDetails) = ACTION::LookupOK THEN BEGIN
                            FDDetails.SETRANGE(Selected, TRUE);
                            REPORT.RUNMODAL(97880, TRUE, FALSE, FDDetails);
                        END;
                    end;
                }
                action("Insert FD placement to Gen Jnl")
                {
                    Caption = 'Insert FD placement to Gen Jnl';

                    trigger OnAction()
                    var
                        GenJnlTemplate: Record "Gen. Journal Template";
                        GenJnlBatch: Record "Gen. Journal Batch";
                        "LineNo.": Integer;
                        NoSeriesMgmt: Codeunit NoSeriesManagement;
                        "DocumentNo.": Code[20];
                        GenJournalLine: Record "Gen. Journal Line";
                        GenJournalLine2: Record "Gen. Journal Line";
                        ShortcutDim8Code: Code[10];
                    begin
                        Rec.TESTFIELD("FD Placement Entries Created", FALSE);
                        GenLedgSetup.GET;
                        GenLedgSetup.TESTFIELD(GenLedgSetup."FD Template Name");
                        GenLedgSetup.TESTFIELD(GenLedgSetup."FD Placement Batch Name");
                        GenJnlTemplate.GET(GenLedgSetup."FD Template Name");
                        GenJnlBatch.GET(GenLedgSetup."FD Template Name", GenLedgSetup."FD Placement Batch Name");

                        "DocumentNo." := '';
                        "LineNo." := 0;
                        GenJournalLine2.RESET;
                        GenJournalLine2.SETRANGE("Journal Template Name", GenLedgSetup."FD Template Name");
                        GenJournalLine2.SETRANGE("Journal Batch Name", GenLedgSetup."FD Placement Batch Name");
                        IF GenJournalLine2.FINDLAST THEN BEGIN
                            "LineNo." := GenJournalLine2."Line No." + 10000;
                            "DocumentNo." := INCSTR(GenJournalLine2."Document No.");
                        END ELSE BEGIN
                            "LineNo." += 10000;
                            CLEAR(NoSeriesMgmt);
                            IF GenJnlBatch."No. Series" <> '' THEN
                                "DocumentNo." := NoSeriesMgmt.TryGetNextNo(GenJnlBatch."No. Series", TODAY);
                        END;

                        //Debit Entry;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name" := GenLedgSetup."FD Template Name";
                        GenJournalLine."Journal Batch Name" := GenLedgSetup."FD Placement Batch Name";
                        GenJournalLine."Line No." := "LineNo.";
                        GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"G/L Account");
                        GenJournalLine.VALIDATE("Account No.", GenLedgSetup."FD Placement Account Code");
                        GenJournalLine."Posting Date" := TODAY;
                        GenJournalLine."Document Type" := GenJournalLine."Document Type"::Payment;
                        GenJournalLine."Document No." := "DocumentNo.";
                        GenJournalLine.Amount := Rec."FD Amount";
                        GenJournalLine."Shortcut Dimension 1 Code" := GenLedgSetup."FD Placement Dimension Code";
                        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code");
                        GenJournalLine."Posting Type" := 0;
                        GenJournalLine."Posting Date" := Rec."FD Start date";
                        GenJournalLine.VALIDATE("Posting No. Series", GenJnlBatch."Posting No. Series");
                        GenJournalLine.Description :=
                          'FD ' + Rec."Bank FD Account No." + ' of Rs ' + FORMAT(Rec."FD Amount");
                        //ShortcutDim8Code :='6';
                        //GenJournalLine.ValidateShortcutDimCode(8, ShortcutDim8Code);
                        GenJournalLine.INSERT(TRUE);

                        //Credit Entry
                        "LineNo." += 10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name" := GenLedgSetup."FD Template Name";
                        GenJournalLine."Journal Batch Name" := GenLedgSetup."FD Placement Batch Name";
                        GenJournalLine."Line No." := "LineNo.";
                        GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"Bank Account");
                        GenJournalLine.VALIDATE("Account No.", Rec."Bank Account No.");
                        GenJournalLine."Posting Date" := TODAY;
                        GenJournalLine."Document Type" := GenJournalLine."Document Type"::Payment;
                        GenJournalLine."Document No." := "DocumentNo.";
                        GenJournalLine.Amount := -Rec."FD Amount";
                        GenJournalLine."Shortcut Dimension 1 Code" := GenLedgSetup."FD Placement Dimension Code";
                        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code");
                        GenJournalLine."Posting Type" := 0;
                        GenJournalLine."Posting Date" := Rec."FD Start date";
                        GenJournalLine.VALIDATE("Posting No. Series", GenJnlBatch."Posting No. Series");
                        GenJournalLine.Description :=
                          'FD ' + Rec."Bank FD Account No." + ' of Rs ' + FORMAT(Rec."FD Amount");
                        //ShortcutDim8Code :='6';
                        //GenJournalLine.ValidateShortcutDimCode(8, ShortcutDim8Code);
                        GenJournalLine.INSERT(TRUE);
                        MESSAGE(Text005);
                        Rec."FD Placement Entries Created" := TRUE;
                        Rec.MODIFY;
                    end;
                }
                action("Insert FD liquidation to Gen Jnl")
                {
                    Caption = 'Insert FD liquidation to Gen Jnl';

                    trigger OnAction()
                    var
                        GenJnlTemplate: Record "Gen. Journal Template";
                        GenJnlBatch: Record "Gen. Journal Batch";
                        "LineNo.": Integer;
                        NoSeriesMgmt: Codeunit NoSeriesManagement;
                        "DocumentNo.": Code[20];
                        GenJournalLine: Record "Gen. Journal Line";
                        GenJournalLine2: Record "Gen. Journal Line";
                        ShortcutDim8Code: Code[10];
                    begin
                        IF Rec.Status = Rec.Status::Open THEN
                            ERROR(Text004);
                        Rec.TESTFIELD("FD Liquidation Entries Created", FALSE);

                        GenLedgSetup.GET;
                        GenLedgSetup.TESTFIELD(GenLedgSetup."FD Template Name");
                        GenLedgSetup.TESTFIELD(GenLedgSetup."FD Liquidation Batch Name");
                        GenJnlTemplate.GET(GenLedgSetup."FD Template Name");
                        GenJnlBatch.GET(GenLedgSetup."FD Template Name", GenLedgSetup."FD Liquidation Batch Name");

                        "DocumentNo." := '';
                        "LineNo." := 0;
                        GenJournalLine2.RESET;
                        GenJournalLine2.SETRANGE("Journal Template Name", GenLedgSetup."FD Template Name");
                        GenJournalLine2.SETRANGE("Journal Batch Name", GenLedgSetup."FD Liquidation Batch Name");
                        IF GenJournalLine2.FINDLAST THEN BEGIN
                            "LineNo." := GenJournalLine2."Line No." + 10000;
                            "DocumentNo." := INCSTR(GenJournalLine2."Document No.");
                        END ELSE BEGIN
                            "LineNo." += 10000;
                            CLEAR(NoSeriesMgmt);
                            IF GenJnlBatch."No. Series" <> '' THEN
                                "DocumentNo." := NoSeriesMgmt.TryGetNextNo(GenJnlBatch."No. Series", TODAY);
                        END;

                        //Principal
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name" := GenLedgSetup."FD Template Name";
                        GenJournalLine."Journal Batch Name" := GenLedgSetup."FD Liquidation Batch Name";
                        GenJournalLine."Line No." := "LineNo.";
                        GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"G/L Account");
                        GenJournalLine.VALIDATE("Account No.", GenLedgSetup."FD Liquidation Account Code");
                        IF Rec.Status = Rec.Status::Matured THEN
                            GenJournalLine."Posting Date" := Rec."FD maturity date"
                        ELSE
                            GenJournalLine."Posting Date" := Rec."Actual Closed Date";
                        GenJournalLine."Document Type" := GenJournalLine."Document Type"::Payment;
                        GenJournalLine."Document No." := "DocumentNo.";
                        GenJournalLine.Amount := -Rec."FD Amount";
                        GenJournalLine."Shortcut Dimension 1 Code" := GenLedgSetup."FD Liquidation Dimension Code";
                        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code");
                        GenJournalLine."Posting Type" := 0;
                        GenJournalLine."Posting Date" := Rec."FD Start date";
                        GenJournalLine.VALIDATE("Posting No. Series", GenJnlBatch."Posting No. Series");
                        GenJournalLine.Description :=
                          'FD ' + Rec."Bank FD Account No." + ' of Rs ' + FORMAT(Rec."FD Amount");

                        //ShortcutDim8Code :='6';
                        //GenJournalLine.ValidateShortcutDimCode(8, ShortcutDim8Code);
                        GenJournalLine.INSERT(TRUE);

                        //Interest
                        "LineNo." += 10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name" := GenLedgSetup."FD Template Name";
                        GenJournalLine."Journal Batch Name" := GenLedgSetup."FD Liquidation Batch Name";
                        GenJournalLine."Line No." := "LineNo.";
                        GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"G/L Account");
                        GenJournalLine.VALIDATE("Account No.", GenLedgSetup."FD Liquidation Interest Acc.");
                        IF Rec.Status = Rec.Status::Matured THEN
                            GenJournalLine."Posting Date" := Rec."FD maturity date"
                        ELSE
                            GenJournalLine."Posting Date" := Rec."Actual Closed Date";
                        GenJournalLine."Document Type" := GenJournalLine."Document Type"::Payment;
                        GenJournalLine."Document No." := "DocumentNo.";
                        GenJournalLine.Amount := -Rec."Intrest Amount";
                        GenJournalLine."Shortcut Dimension 1 Code" := GenLedgSetup."FD Liquidation Dimension Code";
                        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code");
                        GenJournalLine."Posting Type" := 0;
                        GenJournalLine."Posting Date" := Rec."FD Start date";
                        GenJournalLine.VALIDATE("Posting No. Series", GenJnlBatch."Posting No. Series");
                        /*
                        GenJournalLine.Description :=
                          FORMAT("FD Start date")+' to '+FORMAT("FD maturity date")+' ' +FORMAT("FD Amount")+' '+FORMAT("Interest rate") +
                          ' '+"Bank FD No.";
                        */
                        GenJournalLine.Description :=
                          'FD ' + Rec."Bank FD Account No." + ' of Rs ' + FORMAT(Rec."FD Amount");
                        //ShortcutDim8Code :='6';
                        //GenJournalLine.ValidateShortcutDimCode(8, ShortcutDim8Code);
                        GenJournalLine.INSERT(TRUE);

                        //Principal + Interest --> Debit to Bank
                        "LineNo." += 10000;
                        GenJournalLine.INIT;
                        GenJournalLine."Journal Template Name" := GenLedgSetup."FD Template Name";
                        GenJournalLine."Journal Batch Name" := GenLedgSetup."FD Liquidation Batch Name";
                        GenJournalLine."Line No." := "LineNo.";
                        GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"Bank Account");
                        GenJournalLine.VALIDATE("Account No.", Rec."Bank Account No.");
                        IF Rec.Status = Rec.Status::Matured THEN
                            GenJournalLine."Posting Date" := Rec."FD maturity date"
                        ELSE
                            GenJournalLine."Posting Date" := Rec."Actual Closed Date";
                        GenJournalLine."Document Type" := GenJournalLine."Document Type"::Payment;
                        GenJournalLine."Document No." := "DocumentNo.";
                        GenJournalLine.Amount := Rec."FD Amount" + Rec."Intrest Amount";
                        GenJournalLine."Shortcut Dimension 1 Code" := GenLedgSetup."FD Liquidation Dimension Code";
                        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code");
                        GenJournalLine."Posting Type" := 0;
                        GenJournalLine."Posting Date" := Rec."FD Start date";
                        GenJournalLine.VALIDATE("Posting No. Series", GenJnlBatch."Posting No. Series");
                        /*
                        GenJournalLine.Description :=
                          FORMAT("FD Start date")+' to '+FORMAT("FD maturity date")+' ' +FORMAT("FD Amount")+' '+FORMAT("Interest rate") +
                          ' '+"Bank FD No.";
                        */
                        GenJournalLine.Description :=
                          'FD ' + Rec."Bank FD Account No." + ' of Rs ' + FORMAT(Rec."FD Amount");
                        //ShortcutDim8Code :='6';
                        //GenJournalLine.ValidateShortcutDimCode(8, ShortcutDim8Code);
                        GenJournalLine.INSERT(TRUE);
                        MESSAGE(Text005);
                        Rec."FD Liquidation Entries Created" := TRUE;
                        Rec.MODIFY;

                    end;
                }
                action("Issue Of Deposit Receipt")
                {
                    Caption = 'Issue Of Deposit Receipt';

                    trigger OnAction()
                    begin
                        IF Rec."FD Type" = Rec."FD Type"::EMD THEN BEGIN
                            IF PAGE.RUNMODAL(PAGE::"Travel Approved Subform", FDDetails) = ACTION::LookupOK THEN BEGIN
                                FDDetails.SETRANGE(Selected, TRUE);
                                REPORT.RUNMODAL(97730, TRUE, FALSE, FDDetails);
                            END;
                        END ELSE
                            ERROR('FD Type not EMD');
                    end;
                }
                action("STDeposit Receipt")
                {
                    Caption = 'STDeposit Receipt';

                    trigger OnAction()
                    begin
                        IF PAGE.RUNMODAL(PAGE::"Travel Approved Subform", FDDetails) = ACTION::LookupOK THEN BEGIN
                            FDDetails.SETRANGE(Selected, TRUE);
                            REPORT.RUNMODAL(97758, TRUE, FALSE, FDDetails);
                        END;
                    end;
                }
            }
            action("&Confirm")
            {
                Caption = '&Confirm';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Text501: Label 'Do you want to Update the master Information?';
                    Cust: Record Customer;
                begin
                    IF NOT Rec.INSERT(TRUE) THEN
                        Rec.MODIFY(TRUE);
                end;
            }
        }
    }

    var
        Text001: Label 'Attachment1,Attachment2,Attachment3';
        Text002: Label 'Interest amount was calculated successfully.';
        Text003: Label 'TDS amount was calculated successfully.';
        FDDetails: Record "Fixed Deposit Details";
        Text004: Label 'Status must not be open.';
        Text005: Label 'The entry was sent to Gen Journal successfully.';
        GenLedgSetup: Record "General Ledger Setup";

    local procedure IntRateonLiquidationOnBeforeIn()
    begin
        /*
        IF Status = Status ::Liquidated THEN
          CurrPage."Int Rate on Liquidation".UPDATEEDITABLE(TRUE)
        ELSE
          CurrPage."Int Rate on Liquidation".UPDATEEDITABLE(FALSE);
         */

    end;
}

