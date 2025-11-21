pageextension 50032 "BBG Posted Purch. Invoice Ext" extends "Posted Purchase Invoice"
{
    layout
    {
        // Add changes to page layout here
        addafter(General)
        {
            group("BBG Fields")
            {
                Caption = 'BBG Fields';
                field("Received Invoice Amount"; Rec."Received Invoice Amount")
                {
                    ApplicationArea = All;
                }
                field("Order Ref. No."; Rec."Order Ref. No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Sent for Approval"; Rec."Sent for Approval")
                {
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                field("Creation Time"; Rec."Creation Time")
                {
                    ApplicationArea = All;
                }
                field("Sent for Approval Date"; Rec."Sent for Approval Date")
                {
                    ApplicationArea = All;
                }
                field("Sent for Approval Time"; Rec."Sent for Approval Time")
                {
                    ApplicationArea = All;
                }
                field(Approved; Rec.Approved)
                {
                    ApplicationArea = All;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ApplicationArea = All;
                }
                field("Approved Time"; Rec."Approved Time")
                {
                    ApplicationArea = All;
                }
                field(Initiator; Rec.Initiator)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(Approvals)
        {
            action("Payment Milestone")
            {
                Caption = 'Payment Milestone';
                RunObject = Page "Payment Terms Line Purchase";
                RunPageLink = "Document Type" = FILTER(Invoice),
                                  "Document No." = FIELD("Pre-Assigned No.");
                ApplicationArea = All;
            }
            group(Reverse)
            {
                Caption = 'Reverse';
                action("Reverse &Invoice")
                {
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        VLE: Record "Vendor Ledger Entry";
                        ReversalEntry: Record "Reversal Entry";
                        RevEntry: Record "Reversal Entry";
                        FormRevEntries: Page "Auto Reverse Entries";
                    begin

                        VLE.RESET;
                        VLE.SETRANGE("External Document No.", Rec."Vendor Invoice No.");
                        VLE.SETRANGE("Document Type", VLE."Document Type"::Invoice);
                        IF VLE.FINDFIRST THEN BEGIN
                            CLEAR(ReversalEntry);
                            IF VLE.Reversed THEN
                                ReversalEntry.AlreadyReversedEntry(Rec.TABLECAPTION, VLE."Entry No.");
                            VLE.TESTFIELD("Transaction No.");
                            RevEntry.DELETEALL;
                            ReversalEntry.AutoReverseTransaction(VLE."Transaction No.", Rec."Posting Date");
                            FormRevEntries.RUN;
                        END;
                        /*
                        VendLE.RESET;
                        VendLE.SETRANGE("External Document No.","Document No.");
                        VendLE.SETRANGE("Document Type",VendLE."Document Type"::Invoice);
                        VendLE.SETRANGE(Reversed,TRUE);
                        IF VendLE.FINDFIRST THEN BEGIN
                          "Invoice Reversed" := TRUE;
                          MODIFY;
                        END;
                        */

                    end;
                }
                action("Reverse &Payment")
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        VLE: Record "Vendor Ledger Entry";
                        ReversalEntry: Record "Reversal Entry";
                        RevEntry: Record "Reversal Entry";
                        FormRevEntries: Page "Auto Reverse Entries";
                        VLE2: Record "Vendor Ledger Entry";
                    begin

                        VLE.RESET;
                        VLE.SETRANGE("External Document No.", Rec."Vendor Invoice No.");
                        VLE.SETRANGE("Document Type", VLE."Document Type"::Payment);
                        IF VLE.FINDFIRST THEN BEGIN
                            CLEAR(ReversalEntry);
                            IF VLE.Reversed THEN
                                ReversalEntry.AlreadyReversedEntry(Rec.TABLECAPTION, VLE."Entry No.");
                            VLE.TESTFIELD("Transaction No.");
                            RevEntry.DELETEALL;
                            ReversalEntry.AutoReverseTransaction(VLE."Transaction No.", Rec."Posting Date");
                            FormRevEntries.RUN;
                        END;
                    end;
                }
            }
        }
        addafter(Navigate)
        {
            action("&Print Sub Contract Bill")
            {
                Caption = '&Print Sub Contract Bill';
                ApplicationArea = All;
                trigger OnAction()
                begin
                    PIH.RESET;
                    PIH.SETRANGE(PIH."No.", Rec."No.");
                    IF PIH.FINDFIRST THEN
                        REPORT.RUN(97835, TRUE, FALSE, PIH);
                end;
            }
            action("&Print Supplier Bill")
            {
                Caption = '&Print Supplier Bill';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(PurchInvHeader);
                    PurchInvHeader.PrintRecords(TRUE);
                end;
            }

        }
    }

    var
        myInt: Integer;
        PurchInvHeader: Record "Purch. Inv. Header";
        RecPL: Record "Purchase Line";
        PIH: Record "Purch. Inv. Header";
        Usermgt: Codeunit "EPC User Setup Management";
}