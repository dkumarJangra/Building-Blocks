page 50412 "R194 Posted Gift"
{
    // //NDALLE 071205

    Editable = false;
    PageType = Card;
    SourceTable = "Gate Pass Header";
    SourceTableView = SORTING("Document Type", "Document No.")
                      ORDER(Ascending)
                      WHERE(Status = FILTER(Close),
                            "Item Type" = FILTER(R194_Gift));
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

                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("R194_Application No."; Rec."R194_Application No.")
                {

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

                field(Remarks; Rec.Remarks)
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

                field("Item Type"; Rec."Item Type")
                {
                }
            }
            part("1"; "R194Gift Lines")
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
            // group("Attachments")
            // {
            //     action("&Attach Documents")
            //     {
            //         Caption = '&Attach Documents';
            //         Promoted = true;
            //         RunObject = Page "Documents";
            //         RunPageLink = "Table No." = CONST(97733),
            //                       "Document No." = FIELD("Document No.");
            //     }
            // }
            action("Dream Sales Career Gifts")
            {
                Caption = 'Dream Sales Career Gifts';
                Promoted = true;
                PromotedCategory = Process;


                trigger OnAction()
                begin

                    GatePassHdr.RESET;
                    GatePassHdr.SETRANGE("Document Type", Rec."Document Type"::MIN);
                    GatePassHdr.SETRANGE(GatePassHdr."Document No.", Rec."Document No.");
                    IF GatePassHdr.FIND('-') THEN BEGIN
                        REPORT.RUN(50138, TRUE, FALSE, GatePassHdr);
                    END;
                END;

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

