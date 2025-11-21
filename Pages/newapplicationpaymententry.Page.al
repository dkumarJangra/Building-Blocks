page 50085 "new application payment entry"
{
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "NewApplication Payment Entry";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field(Posted; Rec.Posted)
                {
                }
                field("Unit Code"; Rec."Unit Code")
                {
                }
                field("Payment Method"; Rec."Payment Method")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Cheque No./ Transaction No."; Rec."Cheque No./ Transaction No.")
                {
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                }
                field("Cheque Bank and Branch"; Rec."Cheque Bank and Branch")
                {
                }
                field("Cheque Status"; Rec."Cheque Status")
                {
                }
                field("Chq. Cl / Bounce Dt."; Rec."Chq. Cl / Bounce Dt.")
                {
                }
                field("Application No."; Rec."Application No.")
                {
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                }

                field("Installment No."; Rec."Installment No.")
                {
                }
                field("Deposit/Paid Bank"; Rec."Deposit/Paid Bank")
                {
                }
                field("Not Refundable"; Rec."Not Refundable")
                {
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Posting date"; Rec."Posting date")
                {
                }
                field(Reversed; Rec.Reversed)
                {
                }
                field("Milestone Code"; Rec."Milestone Code")
                {
                }
                field("Commision Applicable"; Rec."Commision Applicable")
                {
                }
                field("Direct Associate"; Rec."Direct Associate")
                {
                }
                field("Explode BOM"; Rec."Explode BOM")
                {
                }
                field("Reversal Document No."; Rec."Reversal Document No.")
                {
                }
                field("Order Ref No."; Rec."Order Ref No.")
                {
                }
                field("User Branch Code"; Rec."User Branch Code")
                {
                }
                field("Created From Application"; Rec."Created From Application")
                {
                }
                field("Deposit / Paid Bank Name"; Rec."Deposit / Paid Bank Name")
                {
                }
                field("Gold Coin Eligibility"; Rec."Gold Coin Eligibility")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field("Priority Payment"; Rec."Priority Payment")
                {
                }
                field(Approved; Rec.Approved)
                {
                }
                field("Approved By"; Rec."Approved By")
                {
                }
                field("Approved Date"; Rec."Approved Date")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Associate Transfer Amount"; Rec."Associate Transfer Amount")
                {
                }
                field("TDS %"; Rec."TDS %")
                {
                }
                field("Associate Code For Disc"; Rec."Associate Code For Disc")
                {
                }
                field("TDS Amount"; Rec."TDS Amount")
                {
                }
                field("Club 9%"; Rec."Club 9%")
                {
                }
                field("Club 9 Amount"; Rec."Club 9 Amount")
                {
                }
                field("Adjmt. Line No."; Rec."Adjmt. Line No.")
                {
                }
                field("AJVM Associate Code"; Rec."AJVM Associate Code")
                {
                }
                field(Narration; Rec.Narration)
                {
                }
                field("Provisional Rcpt. No."; Rec."Provisional Rcpt. No.")
                {
                }
                field("User Branch Name"; Rec."User Branch Name")
                {
                }
                field("AJVM Transfer Type"; Rec."AJVM Transfer Type")
                {
                }
                field("Opening Entries"; Rec."Opening Entries")
                {
                }
                field("No. Printed"; Rec."No. Printed")
                {
                }
                field("LD Amount"; Rec."LD Amount")
                {
                }
                field("Discount Payment Type"; Rec."Discount Payment Type")
                {
                }
                field("check app"; Rec."check app")
                {
                }
                field("Reverse AJVM Invoice"; Rec."Reverse AJVM Invoice")
                {
                }
                field("Reversed AJVM Invoice"; Rec."Reversed AJVM Invoice")
                {
                }
                field("Receipt post on InterComp"; Rec."Receipt post on InterComp")
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                }
                field("Receipt post InterComp Date"; Rec."Receipt post InterComp Date")
                {
                }
                field("Commmission Reverse"; Rec."Commmission Reverse")
                {
                }
                field("Create from MSC Company"; Rec."Create from MSC Company")
                {
                }
                field("Bank Type"; Rec."Bank Type")
                {
                }
                field("BRS Created All Comp From MSC"; Rec."BRS Created All Comp From MSC")
                {
                }
                field("BRS Date in All Comp From MSC"; Rec."BRS Date in All Comp From MSC")
                {
                }
                field("MJV Entry Not Posted"; Rec."MJV Entry Not Posted")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Balance Account No."; Rec."Balance Account No.")
                {
                }
                field("Ref. InterPost Doc. No."; Rec."Ref. InterPost Doc. No.")
                {
                }
                field("Refund Amount"; Rec."Refund Amount")
                {
                }
                field(Migration; Rec.Migration)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Delete Unposted Entry")
            {

                trigger OnAction()
                begin
                    IF USERID = 'NAVUSER4' THEN BEGIN
                        IF Rec.Posted THEN
                            ERROR('Entry Already Posted')
                        ELSE
                            Rec.DELETE;
                    END ELSE
                        ERROR('Contact Admin');
                end;
            }
        }
    }
}

