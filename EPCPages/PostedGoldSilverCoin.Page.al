page 97977 "Posted Gold/Silver Coin"
{
    // //NDALLE 071205

    Editable = false;
    PageType = Card;
    SourceTable = "Gate Pass Header";
    SourceTableView = SORTING("Document Type", "Document No.")
                      ORDER(Ascending)
                      WHERE(Status = FILTER(Close),
                            "Item Type" = FILTER(Gold | Silver | Gold_SilverVoucher | R194_Gift));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Document No."; Rec."Document No.")
                {

                    trigger OnAssistEdit()
                    begin

                        PurAndPay.GET;
                        PurAndPay.TESTFIELD("Material Issue Note");
                        IF NoSeriesMgt.SelectSeries(PurAndPay."Material Issue Note", Rec."MIN No. Series", Rec."MIN No. Series") THEN BEGIN
                            PurAndPay.GET;
                            PurAndPay.TESTFIELD("Material Issue Note");
                            NoSeriesMgt.SetSeries(Rec."Document No.");
                            CurrPage.UPDATE;
                        END;
                    end;
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    Caption = 'WO No.';

                    trigger OnValidate()
                    begin
                        PurchaseOrderNoOnAfterValidate;
                    end;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {

                    trigger OnValidate()
                    begin
                        ShortcutDimension1CodeOnAfterV;
                    end;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {

                    trigger OnValidate()
                    begin
                        ShortcutDimension2CodeOnAfterV;
                    end;
                }
                field("Cost Centre Name"; Rec."Cost Centre Name")
                {

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Gen. Business Posting Group"; Rec."Gen. Business Posting Group")
                {
                    Caption = 'Gen. Bus. Posting Group';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        GenBusinessPostingGroupOnAfter;
                    end;
                }
                field("Receiver Name"; Rec."Receiver Name")
                {
                }
                field(Remarks; Rec.Remarks)
                {
                }
                field("Reference No."; Rec."Reference No.")
                {
                }
                field("Issue Type"; Rec."Issue Type")
                {
                }
                field("Entered By"; Rec."Entered By")
                {
                }
                field("Issued By"; Rec."Issued By")
                {
                }
                field("Issued By Name"; Rec."Issued By Name")
                {
                }
                field("Received By"; Rec."Received By")
                {
                }
                field("Received By Name"; Rec."Received By Name")
                {
                }
                field(Status; Rec.Status)
                {

                    trigger OnValidate()
                    begin
                        StatusOnAfterValidate;
                    end;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("Item Type"; Rec."Item Type")
                {
                }
            }
            part("1"; "MIN Lines")
            {
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No.");
                SubPageView = SORTING("Document Type", "Document No.", "Line No.")
                              ORDER(Ascending);
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Attachments")
            {
                action("&Attach Documents")
                {
                    Caption = '&Attach Documents';
                    Promoted = true;
                    RunObject = Page "Documents";
                    RunPageLink = "Table No." = CONST(97733),
                                  "Document No." = FIELD("Document No.");
                }
            }
            action("Print Material Return")
            {
                Caption = 'Print Material Return';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    GatePassHdr.RESET;
                    GatePassHdr.SETRANGE("Document Type", Rec."Document Type"::"Material Return");
                    GatePassHdr.SETRANGE(GatePassHdr."Document No.", Rec."Document No.");
                    IF GatePassHdr.FIND('-') THEN BEGIN
                        REPORT.RUN(97763, TRUE, FALSE, GatePassHdr);
                    END;
                end;
            }
            action("&Print MIN")
            {
                Caption = '&Print MIN';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    GatePassHdr.RESET;
                    GatePassHdr.SETRANGE(GatePassHdr."Document No.", Rec."Document No.");
                    IF GatePassHdr.FIND('-') THEN BEGIN
                        REPORT.RUN(50037, TRUE, FALSE, GatePassHdr);
                    END;
                end;
            }

            action("&PrintVoucherMIN")
            {
                Caption = '&Print Voucher MIN';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    GatePassHdr.RESET;
                    GatePassHdr.SETRANGE(GatePassHdr."Document No.", Rec."Document No.");
                    IF GatePassHdr.FIND('-') THEN BEGIN
                        REPORT.RUN(50137, TRUE, FALSE, GatePassHdr);
                    END;
                end;
            }
            action(NAVIGATE)
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.RUN;
                end;
            }
        }
    }

    var
        GatePassLines: Record "Gate Pass Line";
        JobJnl: Record "Job Journal Line";
        ItemJnl: Record "Item Journal Line";
        ItemJournalTemplate: Record "Item Journal Template";
        numSeries: Code[10];
        NoSeries: Codeunit NoSeriesManagement;
        PictureExists: Boolean;
        DocNumber: Code[10];
        ItemJournal: Record "Item Journal Line";
        endLineNo: Integer;
        recGatePassLines: Record "Gate Pass Line";
        recEmployee: Record Employee;
        CodeUnitRun: Boolean;
        txtConfirm: Label 'Are You sure about the details to be updated in Ledgers ?';
        Text001: Label 'Do you want to replace the existing picture of %1 %2?';
        Text002: Label 'Do you want to delete the picture of %1 %2?';
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PurAndPay: Record "Purchases & Payables Setup";
        GenPostSetup: Record "General Posting Setup";
        GPassLine: Record "Gate Pass Line";
        Tamt: Decimal;
        Amount: Decimal;
        vLineNo: Integer;
        GenTemplateCode: Code[20];
        GenBatchCode: Code[20];
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        GatePassHdr: Record "Gate Pass Header";
        Navigate: Page Navigate;
        NonEditable: Boolean;
        UserMgt: Codeunit "EPC User Setup Management";


    procedure postItemJnl()
    begin

        recGatePassLines.RESET;
        recGatePassLines.SETRANGE(recGatePassLines."Document Type", recGatePassLines."Document Type"::MIN);
        recGatePassLines.SETRANGE(recGatePassLines."Document No.", Rec."Document No.");
        recGatePassLines.SETRANGE(recGatePassLines."Journal Line Created", FALSE);
        IF recGatePassLines.FIND('-') THEN
            REPEAT
                InsertItemJournals()
UNTIL recGatePassLines.NEXT = 0;

        GetLines;

        ItemJnl.RESET;
        ItemJnl.SETRANGE("Journal Template Name", 'MIN');
        ItemJnl.SETRANGE("Journal Batch Name", 'MIN');
        ItemJnl.SETRANGE("Document No.", Rec."Document No.");
        IF ItemJnl.FIND('-') THEN
            REPEAT
                ItemJnl.MARK := TRUE;
            UNTIL ItemJnl.NEXT = 0;

        ItemJnl.MARKEDONLY(TRUE);
        //ERROR(FORMAT(ItemJnl.COUNT));
        CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post", ItemJnl);
    end;


    procedure GetLines()
    begin

        GatePassLines.RESET;
        GatePassLines.SETRANGE("Document Type", Rec."Document Type");
        GatePassLines.SETRANGE("Document No.", Rec."Document No.");
        IF NOT GatePassLines.FIND('-') THEN
            ERROR('Nothing to Post');
    end;


    procedure InsertItemJournals()
    begin

        ItemJournal.RESET;
        ItemJournal.SETRANGE("Journal Template Name", 'MIN');
        ItemJournal.SETRANGE("Journal Batch Name", 'MIN');
        IF ItemJournal.FIND('+') THEN
            endLineNo := ItemJournal."Line No." + 10000
        ELSE
            endLineNo := 10000;

        ItemJnl.VALIDATE("Journal Template Name", 'MIN');
        ItemJnl.VALIDATE("Journal Batch Name", 'MIN');
        ItemJnl.VALIDATE("Document No.", Rec."Document No.");
        ItemJnl.VALIDATE("Line No.", endLineNo);
        ItemJnl.VALIDATE("Vendor No.", Rec."Vendor No.");
        ItemJnl.VALIDATE("PO No.", Rec."Purchase Order No.");
        ItemJnl.INSERT(TRUE);
        ItemJnl.VALIDATE("Posting Date", Rec."Posting Date");
        ItemJnl.VALIDATE("Entry Type", ItemJnl."Entry Type"::"Negative Adjmt.");
        ItemJnl.VALIDATE("Item No.", recGatePassLines."Item No.");
        ItemJnl.VALIDATE("Location Code", recGatePassLines."Location Code");
        ItemJnl.VALIDATE(Quantity, recGatePassLines.Qty);
        IF recGatePassLines."Gen. Bus. Posting Group" <> '' THEN
            ItemJnl.VALIDATE(ItemJnl."Gen. Bus. Posting Group", recGatePassLines."Gen. Bus. Posting Group");
        IF recGatePassLines."Gen. Prod. Posting Group" <> '' THEN
            ItemJnl.VALIDATE(ItemJnl."Gen. Prod. Posting Group", recGatePassLines."Gen. Prod. Posting Group");
        ItemJnl.VALIDATE(ItemJnl."Shortcut Dimension 1 Code", recGatePassLines."Shortcut Dimension 1 Code");
        ItemJnl.VALIDATE(ItemJnl."Shortcut Dimension 2 Code", recGatePassLines."Shortcut Dimension 2 Code");
        ItemJnl.VALIDATE(ItemJnl."Applies-to Entry", recGatePassLines."Applies-to Entry");
        ItemJnl.MODIFY(TRUE);
        //recGatePassLines."Journal Line No" := endLineNo;
        recGatePassLines."Journal Line Created" := TRUE;
        recGatePassLines."Unit Cost" := ItemJnl."Unit Cost";
        recGatePassLines.MODIFY();
    end;


    procedure InsertGlLInes()
    var
        LineNo: Integer;
        AccNo: Code[20];
    begin
        GenTemplateCode := 'General';
        GenBatchCode := 'DEFAULT';

        GenJnlTemplate.GET(GenTemplateCode);
        GenJnlBatch.GET(GenTemplateCode, GenBatchCode);

        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", GenTemplateCode);
        GenJnlLine.SETRANGE("Journal Batch Name", GenBatchCode);
        IF GenJnlLine.FIND('+') THEN
            vLineNo := GenJnlLine."Line No.";

        Tamt := 0;
        REPEAT

            Amount := 0;
            AccNo := recGatePassLines."Account No.";
            recGatePassLines.SETRANGE("Account No.", AccNo);
            GPassLine.RESET;
            GPassLine.SETRANGE("Document Type", recGatePassLines."Document Type");
            GPassLine.SETRANGE("Document No.", recGatePassLines."Document No.");
            GPassLine.SETRANGE("Account No.", recGatePassLines."Account No.");
            IF GPassLine.FIND('-') THEN
                REPEAT

                    Amount := Amount + (GPassLine.Qty * GPassLine."Unit Cost");
                    Tamt := Tamt + (GPassLine.Qty * GPassLine."Unit Cost");
                    recGatePassLines."Debit Note Created" := TRUE;
                    recGatePassLines.MODIFY;
                UNTIL GPassLine.NEXT = 0;

            GenJnlLine.INIT;
            vLineNo := vLineNo + 10000;
            GenJnlLine."Journal Template Name" := GenTemplateCode;
            GenJnlLine."Journal Batch Name" := GenBatchCode;
            GenJnlLine."Line No." := vLineNo;
            GenJnlLine."Posting Date" := Rec."Posting Date";
            GenJnlLine."Document No." := Rec."Document No.";
            GenJnlLine.INSERT;
            GenJnlLine."Document Date" := Rec."Document Date";
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo";
            GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
            GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine.VALIDATE("Account No.", recGatePassLines."Account No.");
            GenJnlLine.VALIDATE(Amount, -Amount);
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
            GenJnlLine.MODIFY;
            MESSAGE('%1', Amount);
            recGatePassLines.FIND('+');
            recGatePassLines.SETRANGE("Account No.");
        UNTIL recGatePassLines.NEXT = 0;

        IF Tamt > 0 THEN BEGIN
            GenJnlLine.INIT;
            vLineNo := vLineNo + 10000;
            GenJnlLine."Journal Template Name" := GenTemplateCode;
            GenJnlLine."Journal Batch Name" := GenBatchCode;
            GenJnlLine."Line No." := vLineNo;
            GenJnlLine."Posting Date" := Rec."Posting Date";
            GenJnlLine."Document No." := Rec."Document No.";
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."External Document No." := Rec."Document No.";
            GenJnlLine.INSERT;
            GenJnlLine."Document Date" := Rec."Document Date";
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo";
            GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
            GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
            GenJnlLine.VALIDATE("Account No.", Rec."Vendor No.");
            GenJnlLine.VALIDATE(Amount, Tamt);
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
            GenJnlLine.MODIFY;
            MESSAGE('%1', Tamt);
        END;
    end;


    procedure SETTYPE(vNonEditable: Boolean)
    begin
        //NonEditable:=vNonEditable;
    end;

    local procedure PurchaseOrderNoOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.UPDATE;
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.UPDATE;
    end;

    local procedure StatusOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;

    local procedure GenBusinessPostingGroupOnAfter()
    begin
        CurrPage.UPDATE;
    end;
}

