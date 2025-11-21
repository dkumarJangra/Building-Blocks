pageextension 50088 "BBG Purchase Order List Ext" extends "Purchase Order List"
{
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        // Add changes to page layout here
        addbefore("No.")
        {
            field("Workflow Sub Document Type"; Rec."Workflow Sub Document Type")
            {
                ApplicationArea = All;

            }
        }
        addafter("Posting Date")
        {
            field("Responsibility Center"; Rec."Responsibility Center")
            {
                ApplicationArea = All;

            }
            field("Initiator User ID"; Rec."Initiator User ID")
            {
                ApplicationArea = All;

            }

        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("O&rder")
        {
            action(Direct)
            {
                Caption = 'Direct';
                Image = NewOrder;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.CreateDocument(Rec."Document Type"::Order, Rec."Workflow Sub Document Type"::Direct);
                end;
            }
            action("Work Order")
            {
                Caption = 'Work Order';
                Image = NewOrder;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.CreateDocument(Rec."Document Type"::Order, Rec."Workflow Sub Document Type"::WorkOrder);
                end;
            }
            action(Terms)
            {
                Caption = 'Terms';
                Image = Text;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Project Material Consumption";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
            group("Terms && Conditions")
            {
                Caption = 'Terms && Conditions';
                Visible = false;
                group("Tax Details")
                {
                    Caption = 'Tax Details';
                    Image = BulletList;
                    action("Sales Tax")
                    {
                        Caption = 'Sales Tax';
                        RunObject = Page "Terms list";
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    var
        myInt: Integer;
}