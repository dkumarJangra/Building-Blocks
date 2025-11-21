page 97853 "Workflow Doc. Type Approvers"
{
    AutoSplitKey = true;
    Caption = 'Workflow Document Type Approvers';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Workflow Doc. Type Approvers";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transaction Type"; Rec."Transaction Type")
                {
                    Visible = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    Visible = false;
                }
                field("Sub Document Type"; Rec."Sub Document Type")
                {
                    OptionCaption = ' ,FA,Regular,Direct,WorkOrder,Inward,Outward,TypeD1,TypeD2,TypeD3,TypeD4,TypeD5,TypeD6,TypeD7,TypeD8,TypeD9,TypeD10,TypeD11,TypeD12,TypeD13,TypeD14,TypeD15,TypeFADS,TypeFADM,TypeD12M,TypeD12S,TypeD8S,TypeD8M,TypeD3S,TypeD3M,TypeC13,TypeC4,TypeC14';
                    Visible = false;
                }
                field("Template Name"; Rec."Template Name")
                {
                    Visible = false;
                }
                field("Batch Name"; Rec."Batch Name")
                {
                    Visible = false;
                }
                field("Initiator User ID"; Rec."Initiator User ID")
                {
                    Visible = false;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Visible = false;
                }
                field(Amendment; Rec.Amendment)
                {
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                }
                field("Approver ID"; Rec."Approver ID")
                {
                }
                field(GetUserName1; Rec.GetUserName(Rec."Initiator User ID"))
                {
                    Caption = 'Alt. Approvar Name';
                    Editable = false;
                    //OptionCaption = 'Alt Approvar Name';
                    Visible = false;
                }
                field(GetRespCenterName; Rec.GetRespCenterName(Rec."Responsibility Center"))
                {
                    Caption = 'Key Responsibility Center Name';
                    Editable = false;
                    Visible = false;
                }
                field("&GetUserName"; Rec.GetUserName(Rec."Approver ID"))
                {
                    Caption = 'Approver Name';
                    Editable = false;
                    //OptionCaption = 'Alt Approvar Name';
                }
                field("Alternate Approver ID"; Rec."Alternate Approver ID")
                {
                    Visible = false;
                }
                field(GetUserName; Rec.GetUserName(Rec."Alternate Approver ID"))
                {
                    Caption = 'Alt. Approvar Name';
                    Editable = false;
                    //OptionCaption = 'Alt Approvar Name';
                    Visible = false;
                }
                field("Approval Amount Limit"; Rec."Approval Amount Limit")
                {
                }
            }
        }
    }

    actions
    {
    }
}

