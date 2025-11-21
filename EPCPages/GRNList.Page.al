page 97738 "GRN List"
{
    CardPageID = "GRN Header";
    Editable = false;
    PageType = List;
    SourceTable = "GRN Header";
    SourceTableView = SORTING("Document Type", "GRN No.")
                      ORDER(Ascending)
                      WHERE("Workflow Sub Document Type" = FILTER(Regular | Direct),
                            Status = CONST(Open));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Workflow Sub Document Type"; Rec."Workflow Sub Document Type")
                {
                    Editable = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("GRN No."; Rec."GRN No.")
                {
                }
                field("Total GRN Value"; Rec."Total GRN Value")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Sub Document Type"; Rec."Sub Document Type")
                {
                }
                field("Gate Entry No."; Rec."Gate Entry No.")
                {
                }
                field("Gate Entry Date"; Rec."Gate Entry Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Vendor name"; Rec."Vendor name")
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                }
                field("Form 59A No"; Rec."Form 59A No")
                {
                }
                field("Challan No"; Rec."Challan No")
                {
                }
                field("Challan Date"; Rec."Challan Date")
                {
                }
                field("Bill No"; Rec."Bill No")
                {
                }
                field("Bill Date"; Rec."Bill Date")
                {
                }
                field("CN/RR No."; Rec."CN/RR No.")
                {
                }
                field("CN/RR Date"; Rec."CN/RR Date")
                {
                }
                field("Mode of Transport"; Rec."Mode of Transport")
                {
                }
                field("Vehicle No."; Rec."Vehicle No.")
                {
                }
                field(Remarks; Rec.Remarks)
                {
                }
                field("Reason for Rejection"; Rec."Reason for Rejection")
                {
                }
                field("Rejection Note No."; Rec."Rejection Note No.")
                {
                }
                field(Approved; Rec.Approved)
                {
                }
                field("Approved Date"; Rec."Approved Date")
                {
                }
                field("Approved Time"; Rec."Approved Time")
                {
                }
                field(Initiator; Rec.Initiator)
                {
                }
                field("Sent for Approval"; Rec."Sent for Approval")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Creation Time"; Rec."Creation Time")
                {
                }
                field("Sent for Approval Date"; Rec."Sent for Approval Date")
                {
                }
                field("Sent for Approval Time"; Rec."Sent for Approval Time")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Regular)
            {
                Caption = 'Regular';
                Image = NewReceipt;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    WorkFlowApprovalMgmt.CreateGRNRegular(TRUE, Rec);
                end;
            }
            action(Direct)
            {
                Caption = 'Direct';
                Image = NewReceipt;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    WorkFlowApprovalMgmt.CreateGRNDirect(TRUE, Rec);
                end;
            }
        }
        area(navigation)
        {
            group("&GRN")
            {
                Caption = '&GRN';
                action(Card)
                {
                    Caption = 'Card';
                    Image = Card;
                    RunObject = Page "GRN Header";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "GRN No." = FIELD("GRN No.");
                    ShortCutKey = 'Shift+F7';
                    Visible = false;
                }
            }
        }
    }

    var
        WorkFlowApprovalMgmt: Codeunit "Document Managment";
}

