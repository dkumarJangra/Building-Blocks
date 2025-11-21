page 50097 "Posted Associate Payment Form"
{
    // // BBG1.01_NB 231012 : Adding functionality of approving the selected lines.

    DelayedInsert = true;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Associate Payment Hdr";
    SourceTableView = WHERE(Post = CONST(true));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("Document No."; Rec."Document No.")
                {
                }
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                }
                field("Sms Sent"; Rec."Sms Sent")
                {
                }
                field("Posted on LLP Company"; Rec."Posted on LLP Company")
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                }
                field("Bank/G L Code"; Rec."Bank/G L Code")
                {
                }
                field("Payment Reversed"; Rec."Payment Reversed")
                {
                }
                field("Bank/G L Name"; Rec."Bank/G L Name")
                {
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                }
                field("Eligible Amount"; Rec."Eligible Amount")
                {
                }
                field("Payable Amount"; Rec."Payable Amount")
                {
                }
                field("TDS Amount"; Rec."TDS Amount")
                {
                }
                field("Club 9 Amount"; Rec."Club 9 Amount")
                {
                }
                field("Advance Amount"; Rec."Advance Amount")
                {
                }
                field("Net Payable (As per Actual)"; Rec."Net Payable (As per Actual)")
                {
                }
                field("Amt applicable for Payment"; Rec."Amt applicable for Payment")
                {
                }
                field("Cheque Amount"; Rec."Cheque Amount")
                {
                }
                field("Cut-off Date"; Rec."Cut-off Date")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("Ignore Advance Payment"; Rec."Ignore Advance Payment")
                {
                }
                field("Rejected/Approved"; Rec."Rejected/Approved")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Calculate Eligibility")
            {
                Caption = '&Approval';
                Visible = false;
                action("Send for &A&pproval")
                {
                    Caption = 'Send for &A&pproval';

                    trigger OnAction()
                    begin
                        // BBG1.01 231012 START
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        /*
                        Memberof.RESET;
                        Memberof.SETRANGE(Memberof."User ID",USERID);
                        Memberof.SETRANGE(Memberof."Role ID",'A_GOLDCOINELIG.');
                        IF NOT Memberof.FINDFIRST THEN
                          ERROR('You do not have permission of role :A_GOLDCOINELIG.');
                        */
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016

                    end;
                }
            }
            group("Calculate Eligibility1")
            {
                Caption = 'F&unction';
                Visible = true;
                action("Print Voucher")
                {
                    Caption = 'Print Voucher';

                    trigger OnAction()
                    begin
                        GLEntry.RESET;
                        GLEntry.SETRANGE("Document No.", Rec."Posted Document No.");
                        GLEntry.SETRANGE("Posting Date", Rec."Posting Date");
                        IF GLEntry.FINDFIRST THEN BEGIN
                            REPORT.RUNMODAL(REPORT::"Bank Transactions Status", TRUE, TRUE, GLEntry);
                        END;
                    end;
                }
                action("Reversal of Payment")
                {
                    Caption = 'Reversal of Payment';

                    trigger OnAction()
                    begin
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        /*
                        CLEAR(Memberof);
                        Memberof.RESET;
                        Memberof.SETRANGE("User ID",USERID);
                        Memberof.SETRANGE("Role ID",'A_IBAPMTREVSL');
                        IF NOT Memberof.FINDFIRST THEN
                         ERROR('You are not Assigned user');
                        */
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        Rec.TESTFIELD("Posted Document No.");
                        IF CONFIRM('Do you want to Reverse the Payment against Document No. -' + Rec."Document No.") THEN BEGIN
                            IF NOT Rec."Payment Reversed" THEN BEGIN
                                PostdocNo := '';
                                ReversalPostPayment.ReversalAssPmtVoucher(Rec);
                            END ELSE
                                MESSAGE('%1', 'Payment already Reversed')
                        END;

                    end;
                }
                action("Payment SMS")
                {
                    Caption = 'Payment SMS';

                    trigger OnAction()
                    begin
                        DocNo := '';
                        MailAssoPmt.RESET;
                        MailAssoPmt.SETRANGE("Sms Sent", FALSE);
                        MailAssoPmt.SETRANGE(Post, TRUE);
                        MailAssoPmt.SETRANGE("Posting Date", Rec."Posting Date");
                        MailAssoPmt.SETRANGE("Payment Reversed", FALSE);
                        IF MailAssoPmt.FINDSET THEN
                            REPEAT
                                IF DocNo <> MailAssoPmt."Document No." THEN BEGIN
                                    DocNo := MailAssoPmt."Document No.";
                                    AssociateSMS.SmsonCommissionReleaseMSC(MailAssoPmt."Document No.");
                                END;
                                MailAssoPmt."Sms Sent" := TRUE;
                                MailAssoPmt.MODIFY;
                            UNTIL MailAssoPmt.NEXT = 0;
                    end;
                }
            }
        }
        area(processing)
        {
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Posted Document No.");
                    Navigate.RUN;
                end;
            }
        }
    }

    var
        Text001: Label 'Do you want to Insert the Lines?';
        VendNoFilter: Text[500];
        Stdate: Date;
        CompanyFilter: Code[30];
        Vend: Record Vendor;
        CustName: Text[60];
        CutoffDate: Date;
        TypeFilter: Option " ",Incentive,Commission,TA,ComAndTA;
        TeamType: Option " ",WithTeam,WithoutTeam;
        //GenerateCommElg: Report 50099;
        Postpayment: Codeunit PostPayment;
        AssociatePaymentHdr: Record "Associate Payment Hdr";
        GLEntry: Record "G/L Entry";
        ReversalPostPayment: Codeunit "UpdateCharges /Post/Rev AssPmt";
        ReverseAssPmtHdr: Record "Associate Payment Hdr";
        Navigate: Page Navigate;
        RecGLEntry: Record "G/L Entry";
        PostdocNo: Code[20];
        DocNo: Code[20];
        MailAssoPmt: Record "Associate Payment Hdr";
        AssociateSMS: Codeunit "SMS Features";


    procedure SetRecordFilters()
    begin
        IF VendNoFilter <> '' THEN
            Rec.SETFILTER("Associate Code", VendNoFilter)
        ELSE
            Rec.SETRANGE("Team Head");

        IF CompanyFilter <> '' THEN
            Rec.SETFILTER("Company Name", CompanyFilter)
        ELSE
            Rec.SETRANGE("Company Name");

        IF (CutoffDate <> 0D) THEN
            Rec.SETRANGE("Cut-off Date", CutoffDate)
        ELSE
            Rec.SETRANGE("Cut-off Date");

        IF (TypeFilter = TypeFilter::Commission) OR (TypeFilter = TypeFilter::TA) THEN
            Rec.SETRANGE(Type, TypeFilter)
        ELSE
            Rec.SETRANGE(Type);
    end;

    local procedure VendNoFilterOnAfterValidate()
    begin
        CurrPage.UPDATE(FALSE);
    end;

    local procedure CompanyFilterOnAfterValidate()
    begin
        CurrPage.UPDATE(FALSE);
    end;

    local procedure CutoffDateOnAfterValidate()
    begin
        CurrPage.UPDATE(FALSE);
    end;

    local procedure TypeFilterOnAfterValidate()
    begin
        CurrPage.UPDATE(FALSE);
    end;
}

