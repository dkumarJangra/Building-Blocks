pageextension 50033 "BBG Ptd Purch. Inv Subform Ext" extends "Posted Purch. Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Job No.")
        {
            field("GRN No."; Rec."GRN No.")
            {
                ApplicationArea = All;
            }
            field("GRN Line No."; Rec."GRN Line No.")
            {
                ApplicationArea = All;
            }
            field("PO No."; Rec."PO No.")
            {
                ApplicationArea = All;
            }
            field("PO Line No."; Rec."PO Line No.")
            {
                ApplicationArea = All;
            }
            field("Ref. Gift Item No."; Rec."Ref. Gift Item No.")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}