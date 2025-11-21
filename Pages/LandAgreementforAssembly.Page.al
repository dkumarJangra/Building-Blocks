page 50263 "Land Agreement for Assembly"
{
    AutoSplitKey = true;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Land Agreement Line";
    SourceTableView = WHERE("Approval Status" = FILTER(Approved),
                            "Land Item No." = FILTER(<> ''));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("Vendor Code"; Rec."Vendor Code")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("Land Item No."; Rec."Land Item No.")
                {
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                }
                field("PO Value"; Rec."PO Value")
                {
                }
                field("Quantity to PO"; Rec."Quantity to PO")
                {
                }
                field("Quantity on PO"; Rec."Quantity on PO")
                {
                }
                field("Area"; Rec.Area)
                {
                    Caption = 'Quantity';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                }
                field("Land Value"; Rec."Land Value")
                {
                }
                field("Land Type"; Rec."Land Type")
                {
                }
                field("Co-Ordinates"; Rec."Co-Ordinates")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Total Expense to Vendor"; Rec."Total Expense to Vendor")
                {
                }
                field("Nature of Deed"; Rec."Nature of Deed")
                {
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                }
                field("Sale Deed No."; Rec."Sale Deed No.")
                {
                }
                field("Approval Status"; Rec."Approval Status")
                {
                }
                field("Pending From USER ID"; Rec."Pending From USER ID")
                {
                }
                field("Date of Registration"; Rec."Date of Registration")
                {
                }
                field("Inspected By"; Rec."Inspected By")
                {
                }
                field("Inspected Date"; Rec."Inspected Date")
                {
                }
                field("Assigned To"; Rec."Assigned To")
                {
                }
                field(Note; Rec.Note)
                {
                }
                field("Payment Amount"; Rec."Payment Amount")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(InsertLines)
                {
                    Caption = 'Insert Lines';

                    trigger OnAction()
                    begin
                        InventorySetup.GET;
                        InsertAgreementLines;
                    end;
                }
            }
        }
    }

    var
        BBGSetups: Record "BBG Setups";
        LandPPRDocumentList: Record "Sub Team Master";
        RecLandPPRDocument: Record "Sub Team Master";
        LandPPR_2DocumentList: Record "Land R-2 PPR  Document List";
        RecLandPPR_2Document: Record "Land R-2 PPR  Document List";
        AssemblyDocNo: Code[20];
        InventorySetup: Record "Inventory Setup";

    local procedure InsertAgreementLines()
    var
        LandAgreementLine: Record "Land Agreement Line";
        AssemblyLine: Record "Assembly Line";
        Item: Record Item;
        OldAssemblyLine: Record "Assembly Line";
        LineNo: Integer;
        LineInserted: Boolean;
    begin

        OldAssemblyLine.RESET;
        OldAssemblyLine.SETRANGE("Document Type", OldAssemblyLine."Document Type"::Order);
        OldAssemblyLine.SETRANGE("Document No.", AssemblyDocNo);
        IF OldAssemblyLine.FINDLAST THEN
            LineNo := OldAssemblyLine."Line No.";
        LineInserted := FALSE;
        CurrPage.SETSELECTIONFILTER(LandAgreementLine);
        IF CONFIRM('Do you want to insert lines') THEN BEGIN
            LandAgreementLine.SETRANGE("Approval Status", LandAgreementLine."Approval Status"::Approved);
            LandAgreementLine.SETFILTER("Land Item No.", '<>%1', '');
            IF LandAgreementLine.FINDSET THEN BEGIN
                REPEAT
                    OldAssemblyLine.RESET;
                    OldAssemblyLine.SETRANGE("Document Type", OldAssemblyLine."Document Type"::Order);
                    OldAssemblyLine.SETRANGE("Document No.", AssemblyDocNo);
                    OldAssemblyLine.SETRANGE("Agreement Document No.", LandAgreementLine."Document No.");
                    OldAssemblyLine.SETRANGE("Agreement Document Line No.", LandAgreementLine."Line No.");
                    IF NOT OldAssemblyLine.FINDFIRST THEN BEGIN
                        LineNo := LineNo + 10000;
                        Item.RESET;
                        IF Item.GET(LandAgreementLine."Land Item No.") THEN;
                        AssemblyLine.INIT;
                        AssemblyLine."Document Type" := AssemblyLine."Document Type"::Order;
                        AssemblyLine."Document No." := AssemblyDocNo;
                        AssemblyLine."Line No." := LineNo;
                        AssemblyLine.VALIDATE(Type, AssemblyLine.Type::Item);
                        AssemblyLine.VALIDATE("No.", LandAgreementLine."Land Item No.");
                        AssemblyLine.Description := Item.Description;
                        AssemblyLine."Description 2" := Item."Description 2";
                        AssemblyLine.VALIDATE("Location Code", LandAgreementLine."Shortcut Dimension 1 Code");
                        AssemblyLine.VALIDATE("Shortcut Dimension 1 Code", LandAgreementLine."Shortcut Dimension 1 Code");
                        AssemblyLine.VALIDATE("Shortcut Dimension 2 Code", InventorySetup."Global Dimension 2 Code");
                        AssemblyLine.VALIDATE(Quantity, LandAgreementLine.Area);
                        AssemblyLine."Conversion Rate" := LandAgreementLine."Quantity in SQYD" / LandAgreementLine.Area;
                        AssemblyLine."Area (in Sqyd)" := LandAgreementLine.Area * AssemblyLine."Conversion Rate";
                        AssemblyLine."Agreement Document No." := LandAgreementLine."Document No.";
                        AssemblyLine."Agreement Document Line No." := LandAgreementLine."Line No.";
                        AssemblyLine."Unit of Measure Code" := LandAgreementLine."Unit of Measure Code";
                        AssemblyLine.INSERT;
                        LineInserted := TRUE;
                    END;
                UNTIL LandAgreementLine.NEXT = 0;
                IF LineInserted THEN
                    MESSAGE('Lines Inserted')
                ELSE
                    MESSAGE('No Lines Inserted');
            END;
        END;
    end;


    procedure SetDocumentNo(DocNo: Code[20])
    begin
        AssemblyDocNo := DocNo;
    end;
}

