page 97861 "Posted Material Return Header"
{
    // //NDALLE 081205
    // //ALLE-PKS15  for credit note

    Editable = false;
    PageType = Card;
    SourceTable = "Gate Pass Header";
    SourceTableView = SORTING("Document Type", "Document No.")
                      ORDER(Ascending)
                      WHERE("Document Type" = FILTER("Material Return"),
                            Status = FILTER(Close));
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
                        PurAndPay.TESTFIELD("Material Return Note");
                        IF NoSeriesMgt.SelectSeries(PurAndPay."Material Return Note", Rec."MRN No. Series", Rec."MRN No. Series") THEN BEGIN
                            PurAndPay.GET;
                            PurAndPay.TESTFIELD("Material Return Note");
                            NoSeriesMgt.SetSeries(Rec."Document No.");
                            CurrPage.UPDATE;
                        END;
                    end;
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    Caption = 'WO No.';
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
                }
                field("Cost Centre Name"; Rec."Cost Centre Name")
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                }
                field("Entered By"; Rec."Entered By")
                {
                }
                field("Issued By"; Rec."Issued By")
                {
                    Caption = 'Rceieved By -Stores';
                }
                field("Issued By Name"; Rec."Issued By Name")
                {
                    Editable = false;
                }
                field("Received By"; Rec."Received By")
                {
                    Caption = 'Returned By';
                }
                field("Received By Name"; Rec."Received By Name")
                {
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Gen. Business Posting Group"; Rec."Gen. Business Posting Group")
                {

                    trigger OnValidate()
                    begin
                        GenBusinessPostingGroupOnAfter;
                    end;
                }
                field("Reference No."; Rec."Reference No.")
                {
                }
            }
            part(""; "Material Return Lines")
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
            action("Print &Material Return Note")
            {
                Caption = 'Print &Material Return Note';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    GatePassHdr.RESET;
                    GatePassHdr.SETRANGE(GatePassHdr."Document No.", Rec."Document No.");
                    IF GatePassHdr.FIND('-') THEN BEGIN
                        GatePassHdr."Document No." := Rec."Document No.";
                        GatePassHdr."Posting Date" := Rec."Posting Date";
                        REPORT.RUN(97763, TRUE, FALSE, GatePassHdr);

                    END;
                end;
            }
            action("Print &Credit Note")
            {
                Caption = 'Print &Credit Note';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //ALLE-PKS15
                    GatePassHdr.RESET;
                    GatePassHdr.SETRANGE(GatePassHdr."Document No.", Rec."Document No.");
                    IF GatePassHdr.FIND('-') THEN BEGIN
                        GatePassHdr."Document No." := Rec."Document No.";
                        GatePassHdr."Posting Date" := Rec."Posting Date";
                        REPORT.RUN(97764, TRUE, FALSE, GatePassHdr);
                    END;
                    //ALLE-PKS15
                end;
            }
            action("&Navigate")
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
        txtConfirm: Label 'Are You sure about the details to be updated in Ledgers ?';
        Text001: Label 'Do you want to replace the existing picture of %1 %2?';
        Text002: Label 'Do you want to delete the picture of %1 %2?';
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
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PurAndPay: Record "Purchases & Payables Setup";
        Navigate: Page Navigate;
        UserMgt: Codeunit "EPC User Setup Management";
        GatePassHdr: Record "Gate Pass Header";


    procedure postItemJnl()
    begin

        recGatePassLines.RESET;
        recGatePassLines.SETRANGE(recGatePassLines."Document Type", recGatePassLines."Document Type"::"Material Return");
        recGatePassLines.SETRANGE(recGatePassLines."Document No.", Rec."Document No.");
        recGatePassLines.SETRANGE(recGatePassLines."Journal Line Created", FALSE);
        IF recGatePassLines.FIND('-') THEN
            REPEAT
                InsertItemJournals()
UNTIL recGatePassLines.NEXT = 0;

        GetLines;

        ItemJnl.RESET;
        ItemJnl.SETRANGE(ItemJnl."Journal Template Name", 'MR');
        ItemJnl.SETRANGE(ItemJnl."Journal Batch Name", 'MR');
        ItemJnl.SETRANGE(ItemJnl."Document No.", Rec."Document No.");
        IF ItemJnl.FIND('-') THEN
            REPEAT
                ItemJnl.MARK := TRUE;
            UNTIL ItemJnl.NEXT = 0;

        ItemJnl.MARKEDONLY(TRUE);
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
        ItemJournal.SETRANGE("Journal Template Name", 'MR');
        ItemJournal.SETRANGE("Journal Batch Name", 'MR');
        IF ItemJournal.FIND('+') THEN
            endLineNo := ItemJournal."Line No." + 10000
        ELSE
            endLineNo := 10000;

        ItemJnl.VALIDATE("Journal Template Name", 'MR');
        ItemJnl.VALIDATE("Journal Batch Name", 'MR');
        ItemJnl.VALIDATE("Document No.", Rec."Document No.");
        ItemJnl.VALIDATE("Line No.", endLineNo);
        ItemJnl.VALIDATE("Vendor No.", Rec."Vendor No.");
        ItemJnl.VALIDATE("PO No.", Rec."Purchase Order No.");
        ItemJnl.INSERT(TRUE);
        ItemJnl.VALIDATE("Posting Date", Rec."Posting Date");
        ItemJnl.VALIDATE("Entry Type", ItemJnl."Entry Type"::"Positive Adjmt.");
        ItemJnl.VALIDATE("Item No.", recGatePassLines."Item No.");
        ItemJnl.VALIDATE("Location Code", recGatePassLines."Location Code");
        ItemJnl.VALIDATE(Quantity, recGatePassLines.Qty);
        IF recGatePassLines."Gen. Bus. Posting Group" <> '' THEN
            ItemJnl.VALIDATE(ItemJnl."Gen. Bus. Posting Group", recGatePassLines."Gen. Bus. Posting Group");
        IF recGatePassLines."Gen. Prod. Posting Group" <> '' THEN
            ItemJnl.VALIDATE(ItemJnl."Gen. Prod. Posting Group", recGatePassLines."Gen. Prod. Posting Group");
        ItemJnl.VALIDATE(ItemJnl."Shortcut Dimension 1 Code", recGatePassLines."Shortcut Dimension 1 Code");
        ItemJnl.VALIDATE(ItemJnl."Shortcut Dimension 2 Code", recGatePassLines."Shortcut Dimension 2 Code");
        ItemJnl.MODIFY(TRUE);
        //recGatePassLines."Journal Line No" := endLineNo;
        recGatePassLines."Journal Line Created" := TRUE;
        recGatePassLines."Unit Cost" := ItemJnl."Unit Cost";
        recGatePassLines.MODIFY();
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.UPDATE;
    end;

    local procedure GenBusinessPostingGroupOnAfter()
    begin
        CurrPage.UPDATE;
    end;
}

