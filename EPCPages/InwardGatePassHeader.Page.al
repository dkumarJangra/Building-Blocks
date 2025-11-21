page 97745 "Inward Gate Pass Header"
{
    PageType = Card;
    SourceTable = "Gate Pass Header";
    SourceTableView = SORTING("Document Type", "Document No.")
                      ORDER(Ascending)
                      WHERE("Document Type" = FILTER("Inward Gatepass"),
                            Status = FILTER(Open));
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
                        PurAndPay.TESTFIELD("Inward Gate Pass");
                        IF NoSeriesMgt.SelectSeries(PurAndPay."Inward Gate Pass", Rec."IWGP No. Series", Rec."IWGP No. Series") THEN BEGIN
                            PurAndPay.GET;
                            PurAndPay.TESTFIELD("Inward Gate Pass");
                            NoSeriesMgt.SetSeries(Rec."Document No.");
                            CurrPage.UPDATE;
                        END;
                    end;
                }
                field("Vendor No."; Rec."Vendor No.")
                {

                    trigger OnValidate()
                    begin
                        VendorNoOnAfterValidate;
                    end;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field(Remarks; Rec.Remarks)
                {
                }
                field("Address of Despatch"; Rec."Address of Despatch")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;

                    trigger OnValidate()
                    begin
                        ShortcutDimension1CodeOnAfterV;
                    end;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
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
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Entered By"; Rec."Entered By")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Mode of Transport"; Rec."Mode of Transport")
                {
                }
            }
            part(""; "Inward Gate Pass Lines")
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
        area(navigation)
        {
            group("&Post")
            {
                Caption = '&Post';
                action("Post")
                {
                    Caption = '&Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);

                        IF CONFIRM(txtConfirm, TRUE) THEN BEGIN
                            IF Rec."Outward Gatepass Type" = Rec."Outward Gatepass Type"::Returnable THEN
                                PostLedger;

                            Rec.VALIDATE(Status, Rec.Status::Close);
                            Rec.MODIFY;
                        END;
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Status := Rec.Status::Open;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PurAndPay: Record "Purchases & Payables Setup";
        recGatePassLines: Record "Gate Pass Line";
        txtConfirm: Label 'Are You sure about the details to be updated in Ledgers ?';


    procedure PostLedger()
    begin
        /*recGatePassLines.RESET;
        recGatePassLines.SETRANGE(recGatePassLines."Document Type",recGatePassLines."Document Type"::"Inward Gatepass");
        recGatePassLines.SETRANGE(recGatePassLines."Document No.","Document No.");
        IF recGatePassLines.FIND('-') THEN REPEAT
          IF RetILE1.FIND('+') THEN;
          RetILE.INIT;
          RetILE.VALIDATE("Entry No.",RetILE1."Entry No." + 1);
          RetILE.VALIDATE("Document Type",RetILE."Document Type"::"1");
          RetILE.VALIDATE("Document No",recGatePassLines."Document No.");
          RetILE.VALIDATE("Outward Document Entry No",recGatePassLines."Outward Gatepass Entry No");
          RetILE2.RESET;
          RetILE2.SETRANGE(RetILE2."Entry No.",recGatePassLines."Outward Gatepass Entry No");
          IF RetILE2.FIND('-') THEN BEGIN
            RetILE.VALIDATE("Outward Document No",RetILE2."Document No");
            RetILE.VALIDATE("Outward Gatepass Line No",RetILE2."Outward Gatepass Line No");
            IF RetILE2."Remaining Qty"-recGatePassLines.Qty<0 THEN
              ERROR('Remaining Qty =%1 should be greater than or equal to Returned Qty=%2',
                  RetILE2."Remaining Qty",recGatePassLines.Qty);
            RetILE2."Remaining Qty":=RetILE2."Remaining Qty"-recGatePassLines.Qty;
            RetILE2.MODIFY;
          END;
          RetILE.VALIDATE("Item No.",recGatePassLines."Item No.");
          RetILE.VALIDATE(Description,recGatePassLines.Description);
          RetILE.VALIDATE(Uom,recGatePassLines."Unit of Measure");
          RetILE.VALIDATE(Open,TRUE);
          RetILE.VALIDATE("Return Due Date",recGatePassLines."Return Due Date");
          RetILE.VALIDATE("Posting Date","Posting Date");
          RetILE.VALIDATE(Quantity,-(recGatePassLines.Qty));
          RetILE.VALIDATE("Inward Gatepass Line No",recGatePassLines."Line No.");
          RetILE.INSERT(TRUE);
        UNTIL recGatePassLines.NEXT = 0;
         */

    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.UPDATE;
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.UPDATE;
    end;

    local procedure VendorNoOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;
}

