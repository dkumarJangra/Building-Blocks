page 97842 "Workflow Doc. Type Initiator"
{
    Caption = 'Workflow Document Type Initiator';
    DataCaptionFields = "Transaction Type", "Document Type", "Sub Document Type", "Template Name", "Batch Name";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Workflow Doc. Type Initiator";
    UsageCategory = Lists;
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
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field(Amendment; Rec.Amendment)
                {
                }
                field("Posting User ID"; Rec."Posting User ID")
                {
                }
                field("GetUserName1"; Rec.GetUserName(Rec."Initiator User ID"))
                {
                    Caption = 'Initiator Name';
                }
                field(GetRespCenterName; Rec.GetRespCenterName(Rec."Responsibility Center"))
                {
                    Caption = 'User Responsibility Center Name';
                    Editable = false;
                }
                field(GetUserName; Rec.GetUserName(Rec."Posting User ID"))
                {
                    Caption = 'Posting User Name';
                    Editable = false;
                    //OptionCaption = 'Posting Employee Name';
                }
                field("Approval Limit Exists"; Rec."Approval Limit Exists")
                {
                }
                field("Workflow Code"; Rec."Workflow Code")
                {
                    ApplicationArea = all;
                }

            }
            part(""; "Workflow Doc. Type Approvers")
            {
                SubPageLink = "Transaction Type" = FIELD("Transaction Type"),
                              "Document Type" = FIELD("Document Type"),
                              "Sub Document Type" = FIELD("Sub Document Type"),
                              "Template Name" = FIELD("Template Name"),
                              "Batch Name" = FIELD("Batch Name"),
                              "Initiator User ID" = FIELD("Initiator User ID"),
                              "Responsibility Center" = FIELD("Responsibility Center"),
                              Amendment = FIELD(Amendment);
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Document Type")
            {
                Caption = 'Document Type';
                action("Approvar Hierarchy")
                {
                    Caption = 'Approvar Hierarchy';
                    Image = Hierarchy;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Workflow Doc. Type Approvers";
                    RunPageLink = "Transaction Type" = FIELD("Transaction Type"),
                                  "Document Type" = FIELD("Document Type"),
                                  "Sub Document Type" = FIELD("Sub Document Type"),
                                  "Template Name" = FIELD("Template Name"),
                                  "Batch Name" = FIELD("Batch Name"),
                                  "Initiator User ID" = FIELD("Initiator User ID"),
                                  "Responsibility Center" = FIELD("Responsibility Center"),
                                  Amendment = FIELD(Amendment);
                    RunPageView = SORTING("Transaction Type", "Document Type", "Sub Document Type", "Template Name", "Batch Name", "Initiator User ID", "Responsibility Center", "Line No.");
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //IsJournal := (("Transaction Type" = "Transaction Type"::" ") AND ("Document Type" = "Document Type"::Amendment));
    end;

    var
        Text19029362: Label 'Document Initiator''s';
        Text19006551: Label 'Document Approver''s';
        IsJournal: Boolean;
}

