page 97841 "Workflow Doc. Type Setup"
{
    Caption = 'Workflow Document Type Setup';
    DataCaptionFields = "Transaction Type", "Document Type", "Sub Document Type";
    PageType = List;
    SourceTable = "Workflow Doc. Type Setup";
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
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Sub Document Type"; Rec."Sub Document Type")
                {
                    OptionCaption = ' ,FA,Regular,Direct,WorkOrder,Inward,Outward,TypeD1,TypeD2,TypeD3,TypeD4,TypeD5,TypeD6,TypeD7,TypeD8,TypeD9,TypeD10,TypeD11,TypeD12,TypeD13,TypeD14,TypeD15,TypeFADS,TypeFADM,TypeD12M,TypeD12S,TypeD8S,TypeD8M,TypeD3S,TypeD3M,TypeC13,TypeC4,TypeC14';
                }
                field(Enabled; Rec.Enabled)
                {
                }
                field("Gate Entry Required"; Rec."Gate Entry Required")
                {
                }
                field("Job Allocation Required"; Rec."Job Allocation Required")
                {
                }
                field("Milestone Mandatory"; Rec."Milestone Mandatory")
                {
                }
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
                action(Initiator)
                {
                    Caption = 'Initiator';
                    Image = Users;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Workflow Doc. Type Initiator";
                    RunPageLink = "Transaction Type" = FIELD("Transaction Type"),
                                  "Document Type" = FIELD("Document Type"),
                                  "Sub Document Type" = FIELD("Sub Document Type");
                    RunPageView = SORTING("Transaction Type", "Document Type", "Sub Document Type", "Template Name", "Batch Name")
                                  ORDER(Ascending);
                    ShortCutKey = 'Shift+Ctrl+I';
                }
            }
        }
        area(processing)
        {
            group(Import)
            {
                Caption = 'Import';
                action("Import Intiators")
                {
                    Caption = 'Import Intiators';
                    Ellipsis = true;
                    Image = Import;
                    RunObject = XMLport "Vendor/Customer Upload";
                }
                action("Import Approvers")
                {
                    Caption = 'Import Approvers';
                    Ellipsis = true;
                    Image = Import;
                    RunObject = XMLport "Rank Change History";
                }
            }
        }
    }
}

