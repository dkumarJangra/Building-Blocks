page 50024 "Travel Payment Entry View"
{
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Travel Payment Entry";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field("Sub Associate Code"; Rec."Sub Associate Code")
                {
                }
                field("Sub Associate Name"; Rec."Sub Associate Name")
                {
                }
                field("Amount to Pay"; Rec."Amount to Pay")
                {
                }
                field("TDS Deducat on Invoice"; Rec."TDS Deducat on Invoice")
                {
                }
                field("Application No."; Rec."Application No.")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Post from Approval"; Rec."Post from Approval")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                }
                field("Bank Acc. No."; Rec."Bank Acc. No.")
                {
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                }
                field("Bank Name"; Rec."Bank Name")
                {
                }
                field("Parent Code"; Rec."Parent Code")
                {
                }
                field("Activity Break down Str"; Rec."Activity Break down Str")
                {
                }
                field("Sent for Approval"; Rec."Sent for Approval")
                {
                }
                field(Approved; Rec.Approved)
                {
                }
                field("Parent Name"; Rec."Parent Name")
                {
                }
                field(Retrun; Rec.Retrun)
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Approver Name"; Rec."Approver Name")
                {
                }
                field("Approval Sender  Name"; Rec."Approval Sender  Name")
                {
                }
                field("Approved By"; Rec."Approved By")
                {
                }
                field("Sent By for Approval"; Rec."Sent By for Approval")
                {
                }
                field("TA Creation on Commission Vouc"; Rec."TA Creation on Commission Vouc")
                {
                }
                field("TDS Amount"; Rec."TDS Amount")
                {
                }
                field(Month; Rec.Month)
                {
                }
                field(Year; Rec.Year)
                {
                }
                field("Ready for Payment"; Rec."Ready for Payment")
                {
                }
                field("TA Rate"; Rec."TA Rate")
                {
                }
                field("Total Area"; Rec."Total Area")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("Voucher No."; Rec."Voucher No.")
                {
                }
                field("TDS %"; Rec."TDS %")
                {
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                }
                field("Adjust Remaining Amt"; Rec."Adjust Remaining Amt")
                {
                }
                field("Post Payment"; Rec."Post Payment")
                {
                }
                field("Entry No."; Rec."Entry No.")
                {
                }
                field(Reverse; Rec.Reverse)
                {
                }
                field(CreditMemo; Rec.CreditMemo)
                {
                    Editable = false;
                }
                field("CreditMemo No."; Rec."CreditMemo No.")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

