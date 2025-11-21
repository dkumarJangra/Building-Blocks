pageextension 50074 "BBG Assembly Order SubForm Ext" extends "Assembly Order Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Quantity to Consume")
        {
            field("Area (in Sqyd)"; Rec."Area (in Sqyd)")
            {
                ApplicationArea = All;

            }
            field("Conversion Rate"; Rec."Conversion Rate")
            {
                ApplicationArea = All;

            }
            field("Agreement Document No."; Rec."Agreement Document No.")
            {
                ApplicationArea = All;

            }
            field("Agreement Document Line No."; Rec."Agreement Document Line No.")
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