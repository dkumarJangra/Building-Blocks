pageextension 50087 "BBG Purchase Quotes Ext" extends "Purchase Quotes"
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
        addafter("Pay-to Name")
        {
            field("Indent No."; Rec."Indent No.")
            {
                ApplicationArea = All;

            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Quote")
        {
            action("Supply Quote")
            {
                Caption = 'Supply Quote';
                Image = NewOrder;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.CreateDocument(Rec."Document Type"::Quote, Rec."Workflow Sub Document Type"::Regular);
                end;
            }
            action("Service Quote")
            {
                Caption = 'Service Quote';
                Image = NewOrder;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.CreateDocument(Rec."Document Type"::Quote, Rec."Workflow Sub Document Type"::WorkOrder);
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
            }
        }
    }

    var
        myInt: Integer;
}