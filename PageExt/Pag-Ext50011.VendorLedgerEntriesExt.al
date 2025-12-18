pageextension 50011 "BBG Vendor Ledger Entries Ext" extends "Vendor Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Vendor Name")
        {
            field("Purchase Company Name"; Rec."Purchase Company Name")
            {
                ApplicationArea = All;
            }
            field("Company Name"; Rec."Company Name")
            {
                ApplicationArea = All;
            }
            field("P.A.N. No."; Rec."P.A.N. No.")
            {
                ApplicationArea = All;
            }
            field("Payment From Company"; Rec."Payment From Company")
            {
                ApplicationArea = All;
            }
            field("Order Ref No."; Rec."Order Ref No.")
            {
                ApplicationArea = All;
            }
            field("TDSAmt for Associate"; Rec."TDSAmt for Associate")
            {
                ApplicationArea = All;
            }
            field("Club 9 for Associate"; Rec."Club 9 for Associate")
            {
                ApplicationArea = All;
            }
            field("Cheque No."; Rec."Cheque No.")
            {
                ApplicationArea = All;
            }
            field("Cheque Date"; Rec."Cheque Date")
            {
                ApplicationArea = All;
            }
            field("Posting Type"; Rec."Posting Type")
            {
                ApplicationArea = All;
            }
            field("Application No."; Rec."Application No.")
            {
                ApplicationArea = All;
            }
            field("Check Remaining Amt"; Rec."Check Remaining Amt")
            {
                ApplicationArea = All;
            }
            field("Received Invoice Amount"; Rec."Received Invoice Amount")
            {
                ApplicationArea = All;
            }
            field("Total TDS Including SHE CESS"; Rec."Total TDS Including SHE CESS")
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
            field("Purchase (LCY)"; Rec."Purchase (LCY)")
            {
                ApplicationArea = All;
            }
            field("Club 9 Entry"; Rec."Club 9 Entry")
            {
                ApplicationArea = All;
            }
            field("Region Code"; Rec."Region Code")
            {
                ApplicationArea = All;
            }
            field("Region Code Description"; Rec."Region Code Description")
            {
                ApplicationArea = All;
            }
            field("Rank Code"; Rec."Rank Code")
            {
                ApplicationArea = All;
            }
            field("Rank Description"; Rec."Rank Description")
            {
                ApplicationArea = All;
            }
            field("Ref. External Doc. No."; Rec."Ref. External Doc. No.")  //New field added 15122025
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("F&unctions")
        {
            group("&Reverse")
            {
                Caption = '&Reverse';
                action("Reverse &Invoice")
                {
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        VLE: Record "Vendor Ledger Entry";
                        ReversalEntry: Record "Reversal Entry";
                        RevEntry: Record "Reversal Entry";
                        PAGERevEntries: Page "Auto Rev. Entries-Spcl. Incent";
                        VendLE: Record "Vendor Ledger Entry";
                    begin

                        //IF (Type IN[Type::Incentive]) THEN
                        //ERROR('Incentive Reversal option not available');
                        VLE.GET(Rec."Entry No.");
                        //VLE.RESET;
                        //VLE.SETRANGE("External Document No.","External Document No.");
                        //VLE.SETRANGE("Document Type",VLE."Document Type"::Invoice);
                        //IF VLE.FINDFIRST THEN BEGIN
                        CLEAR(ReversalEntry);
                        IF VLE.Reversed THEN
                            ReversalEntry.AlreadyReversedEntry(CAPTION, VLE."Entry No.");
                        VLE.TESTFIELD("Transaction No.");
                        RevEntry.DELETEALL;
                        ReversalEntry.AutoReverseTransaction(VLE."Transaction No.", Rec."Posting Date");
                        PAGERevEntries.RUN; // ALLE MM Code Commented as 80030 page is not exixting
                        //END;
                    end;
                }
                action("Reverse &Payment")
                {
                    Visible = false;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        VLE: Record "Vendor Ledger Entry";
                        ReversalEntry: Record "Reversal Entry";
                        RevEntry: Record "Reversal Entry";
                        VLE2: Record "Vendor Ledger Entry";
                        PAgeRevEntries: Page "Auto Rev. Entries-Spcl. Incent";
                    begin

                        //IF (Type IN[Type::Incentive]) THEN
                        //ERROR('Incentive Reversal option not available');
                        VLE.GET(Rec."Entry No.");
                        //VLE.RESET;
                        //VLE.SETRANGE("External Document No.","Document No.");
                        //VLE.SETRANGE("Document Type",VLE."Document Type"::Payment);
                        //IF VLE.FINDFIRST THEN BEGIN
                        CLEAR(ReversalEntry);
                        IF VLE.Reversed THEN
                            ReversalEntry.AlreadyReversedEntry(CAPTION, VLE."Entry No.");
                        VLE.TESTFIELD("Transaction No.");
                        RevEntry.DELETEALL;
                        ReversalEntry.AutoReverseTransaction(VLE."Transaction No.", Rec."Posting Date");
                        PAgeRevEntries.RUN; // ALLE MM Code Commented as 80030 page is not exixting
                        //END;
                    end;
                }
                action("Applied Commission Entries")
                {
                    Caption = 'Applied Commission Entries';
                    Image = "Page";
                    Promoted = true;
                    RunObject = Page "Commission Entry View Form";
                    RunPageLink = "Voucher No." = FIELD("Document No.");
                    ApplicationArea = All;
                }
                action("Applied Travel payment Entries")
                {
                    Caption = 'Applied Travel payment Entries';
                    Image = "Page";
                    Promoted = true;
                    RunObject = Page "Travel Payment Entry View";
                    RunPageLink = "Voucher No." = FIELD("Document No.");
                    ApplicationArea = All;
                }
            }
            action("BBG Posted Narration")
            {
                Caption = 'BBG Posted Narration';
                Image = "Page";
                Promoted = true;
                RunObject = Page "BBG Posted Narration";
                RunPageLink = "Document No." = FIELD("Document No.");
                ApplicationArea = All;
            }

        }
    }

    var
        myInt: Integer;
        TDSEntry: Record "TDS Entry";
        UserSetup: Record "User Setup";

    trigger OnOpenPage()
    begin
        //180124
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("View All Vendor ledger Entries", FALSE);
        IF UserSetup.FINDFIRST THEN BEGIN
            Rec.SETFILTER("Vendor No.", '%1', 'IBA*');
        END;
    end;
}