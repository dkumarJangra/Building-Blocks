page 50383 "Gold_Silver Voucher Lines-R"
{
    // ALLEPG RAHEE1.00 240212 : Created functions for tracking line.

    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Gate Pass Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {

                    trigger OnValidate()
                    begin
                        CheckEntry;  //070524
                        ItemNoOnAfterValidate;
                    end;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Application No."; Rec."Application No.")
                {
                    Caption = 'Application No.';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        CheckEntry;  //070524 Added new code
                        ApplicationNoOnAfterValidate;
                    end;
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("PO Line No."; Rec."PO Line No.")
                {
                    Visible = false;
                }
                field("Description 2"; Rec."Description 2")
                {
                    Visible = false;
                }
                field("Description 3"; Rec."Description 3")
                {
                    Visible = false;
                }
                field("Description 4"; Rec."Description 4")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = true;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = true;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    Visible = false;
                }
                field("Job No."; Rec."Job No.")
                {
                    Visible = false;
                }
                field("Fixed Asset No"; Rec."Fixed Asset No")
                {
                    Visible = false;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    Visible = false;
                }
                field("Current Stock"; Rec."Current Stock")
                {
                }
                field("Required Qty"; Rec."Required Qty")
                {

                    trigger OnValidate()
                    begin
                        CheckEntry;  //070524 Added new code
                        GatePassHeader.RESET;
                        IF GatePassHeader.GET(Rec."Document Type", Rec."Document No.") THEN BEGIN
                            IF GatePassHeader."Item Type" = GatePassHeader."Item Type"::Gold THEN BEGIN
                                IF Rec."Required Qty" > Rec."Gold Coin Qty" THEN
                                    ERROR('You cant consume Quantity greater than=' + FORMAT(Rec."Gold Coin Qty"));
                            END ELSE BEGIN
                                Rec."Issuing Weight" := Rec.Qty * Rec."Silver / Gold in Grams";
                            END;
                        END;
                    end;
                }
                field(Qty; Rec.Qty)
                {
                    Caption = 'Issued Qty';

                    trigger OnValidate()
                    begin
                        GatePassHeader.RESET;
                        IF GatePassHeader.GET(Rec."Document Type", Rec."Document No.") THEN BEGIN
                            IF GatePassHeader."Item Type" = GatePassHeader."Item Type"::Silver THEN BEGIN
                                Rec."Issuing Weight" := Rec.Qty * Rec."Silver / Gold in Grams";
                            END;
                        END;
                    end;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    Editable = true;
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Journal Line Created"; Rec."Journal Line Created")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Debit Note Created"; Rec."Debit Note Created")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Silver / Gold in Grams"; Rec."Silver / Gold in Grams")
                {
                }
                field("Issuing Weight"; Rec."Issuing Weight")
                {
                    Caption = 'issuing weight (grms)';
                }
            }
        }
    }

    actions
    {
        // area(processing)
        // {
        //     group("Related Information")
        //     {
        //         Caption = 'Related Information';

        //         action("Item &Tracking Lines")
        //         {
        //             ApplicationArea = ItemTracking;
        //             Caption = 'Item &Tracking Lines';
        //             Image = ItemTrackingLines;
        //             ShortCutKey = 'Ctrl+Alt+I';
        //             //RunObject = page "Gold/SL Voucher Item Journal";
        //             trigger OnAction()
        //             var
        //                 myInt: Integer;
        //                 VoucheritemJnlLine: page "Gold/SL Voucher Item Journal";
        //                 ItemJnlLines_2: Record "Item Journal Line";
        //                 Unitsetup: Record "Unit Setup";
        //                 ItemJnl: Record "Item Journal Line";
        //                 GatePassLines: Record "Gate Pass Line";
        //                 ItemJournal: Record "Item Journal Line";
        //                 EndLineNo: Integer;
        //                 Gatepassheader: Record "Gate Pass Header";
        //             begin
        //                 Clear(VoucheritemJnlLine);

        //                 Unitsetup.GET;
        //                 Unitsetup.TestField("Gold/Silver Voucher Template");
        //                 Unitsetup.TestField("Gold/Silver Voucher Batch");
        //                 Gatepassheader.RESET;
        //                 IF Gatepassheader.GET(Rec."Document Type", Rec."Document No.") THEN;
        //                 ItemJournal.RESET;
        //                 ItemJournal.SetRange("Journal Template Name", Unitsetup."Gold/Silver Voucher Template");
        //                 ItemJournal.SetRange("Journal Batch Name", Unitsetup."Gold/Silver Voucher Batch");

        //                 IF ItemJournal.FINDLAST THEN
        //                     EndLineNo := ItemJournal."Line No." + 10000
        //                 ELSE
        //                     EndLineNo := 10000;

        //                 GatePassLines.RESET;
        //                 GatePassLines.SetRange("Document Type", Rec."Document Type");
        //                 GatePassLines.SetRange("Document No.", Rec."Document No.");
        //                 If GatePassLines.FindSet() then
        //                     repeat

        //                         ItemJnl.VALIDATE("Journal Template Name", Unitsetup."Gold/Silver Voucher Template");
        //                         ItemJnl.VALIDATE("Journal Batch Name", Unitsetup."Gold/Silver Voucher Batch");
        //                         ItemJnl.VALIDATE("Document No.", Rec."Document No.");
        //                         ItemJnl.VALIDATE("Line No.", EndLineNo);
        //                         ItemJnl.VALIDATE("Vendor No.", Gatepassheader."Vendor No.");
        //                         ItemJnl.VALIDATE("PO No.", Gatepassheader."Purchase Order No.");
        //                         ItemJnl.VALIDATE("Item Shpt. Entry No.", 0);
        //                         ItemJnl.INSERT(TRUE);
        //                         ItemJnl.VALIDATE("Posting Date", Gatepassheader."Posting Date");
        //                         ItemJnl.VALIDATE("Entry Type", ItemJnl."Entry Type"::"Negative Adjmt.");
        //                         ItemJnl.VALIDATE("Item No.", Rec."Item No.");
        //                         ItemJnl.VALIDATE("Location Code", Rec."Location Code");
        //                         ItemJnl.VALIDATE(Quantity, Rec.Qty);
        //                         IF Rec."Gen. Bus. Posting Group" <> '' THEN
        //                             ItemJnl.VALIDATE("Gen. Bus. Posting Group", Rec."Gen. Bus. Posting Group");
        //                         IF Rec."Gen. Prod. Posting Group" <> '' THEN
        //                             ItemJnl.VALIDATE("Gen. Prod. Posting Group", Rec."Gen. Prod. Posting Group");
        //                         ItemJnl.VALIDATE("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
        //                         ItemJnl.VALIDATE("Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
        //                         IF Rec."Applies-to Entry" <> 0 THEN
        //                             ItemJnl.VALIDATE("Applies-to Entry", Rec."Applies-to Entry");
        //                         ItemJnl.VALIDATE("Issue Type", Gatepassheader."Issue Type");
        //                         ItemJnl."Reference No." := Gatepassheader."Reference No.";
        //                         ItemJnl."Application No." := Rec."Application No.";
        //                         ItemJnl."Application Line No." := Rec."Application Line No.";
        //                         ItemJnl."Item Type" := Gatepassheader."Item Type";

        //                         ItemJnl.VALIDATE("Bin Code", Rec."Bin Code");
        //                         ItemJnl.Narration := Rec.Description + ' Qty:' + FORMAT(Rec.Qty);
        //                         ItemJnl.MODIFY(TRUE);
        //                         EndLineNo := ItemJnl."Line No." + 10000;

        //                     Until GatePassLines.Next = 0;




        //                 ItemJnlLines_2.RESET;
        //                 ItemJnlLines_2.SetRange("Journal Template Name", Unitsetup."Gold/Silver Voucher Template");
        //                 ItemJnlLines_2.SetRange("Journal Batch Name", Unitsetup."Gold/Silver Voucher Batch");
        //                 ItemJnlLines_2.SetRange("Line No.", Rec."Line No.");
        //                 ItemJnlLines_2.SetRange("Document No.", ItemJnl."Document No.");
        //                 If ItemJnlLines_2.FindFirst() then
        //                     PAge.RunModal(Page::"Gold/SL Voucher Item Journal", ItemJnlLines_2);

        //             end;

        //         }


        //     }
        // }
    }
    trigger OnAfterGetRecord()
    begin
        BBGOnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        GatePassHeader.RESET;
        GatePassHeader.SETRANGE("Document No.", Rec."Document No.");
        IF GatePassHeader.FIND('-') THEN BEGIN
            Rec."Shortcut Dimension 1 Code" := GatePassHeader."Shortcut Dimension 1 Code";
            Rec."Shortcut Dimension 2 Code" := GatePassHeader."Shortcut Dimension 2 Code";
            Rec."Cost Centre Name" := GatePassHeader."Cost Centre Name";
            Rec."Purchase Order No." := GatePassHeader."Purchase Order No.";
            Rec."Gen. Bus. Posting Group" := GatePassHeader."Gen. Business Posting Group";
            Rec."Location Code" := GatePassHeader."Location Code";

        END;
        BBGOnAfterGetCurrRecord;
    end;

    var
        GatePassHeader: Record "Gate Pass Header";
        "Confirmed Order": Record "Confirmed Order";
        ApplicationNo: Code[20];
        AP: page 47;


    procedure OpenFreeTrackingLines()
    begin
        //TESTFIELD("Journal Line Created");
        Rec.OpenFreeSampleTrackingLines; // BIOMAB1.0
    end;


    procedure GetIndentLineInfo()
    begin
        Rec.GetIndentLines;  //RAHEE1.00 180412
    end;


    procedure GetFOCLineInfo()
    begin
        Rec.GetFOCLines;    //RAHEE1.00 180412
    end;

    local procedure ItemNoOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        CurrPage.UPDATE(FALSE);
    end;

    local procedure ApplicationNoOnAfterValidate()
    begin
        IF GatePassHeader.GET(Rec."Document Type", Rec."Document No.") THEN
            IF GatePassHeader.Type = GatePassHeader.Type::Regular THEN
                ERROR('Type must be Direct');
    end;

    local procedure BBGOnAfterGetCurrRecord()
    begin
        xRec := Rec;
        Rec.Amount := Rec.Qty * Rec."Unit Cost";
    end;

    local procedure CheckEntry()
    begin
        IF Rec."Item No." <> '' THEN BEGIN
            GatePassHeader.RESET;
            IF GatePassHeader.GET(Rec."Document Type", Rec."Document No.") THEN
                IF GatePassHeader."Item Type" = GatePassHeader."Item Type"::Gold THEN
                    ERROR('You can not change the value');
        END;
    end;
}

