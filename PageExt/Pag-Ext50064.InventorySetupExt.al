pageextension 50064 "BBG Inventory Setup Ext" extends "Inventory Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter(General)
        {
            group("Land Setup")
            {
                Caption = 'Land Setup';
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Inventory Posting Group"; Rec."Inventory Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Item Revaluation Gen.Bus Group"; Rec."Item Revaluation Gen.Bus Group")
                {
                    ApplicationArea = All;
                }
                field("Int. Post. Group Finished Item"; Rec."Int. Post. Group Finished Item")
                {
                    ApplicationArea = All;
                    Caption = 'FG Item Inventory  Post. Group';
                }
                field("Item Tracking for Joint Ventur"; Rec."Item Tracking for Joint Ventur")
                {
                    ApplicationArea = All;
                }
                field("Item Lot No. Series"; Rec."Item Lot No. Series")
                {
                    ApplicationArea = All;
                }
                field("FG Item No. Series"; Rec."FG Item No. Series")
                {
                    ApplicationArea = All;
                }
                field("FG Item Gen.Prod. Posting Gr."; Rec."FG Item Gen.Prod. Posting Gr.")
                {
                    ApplicationArea = All;
                }
                field("FG Item Base Unit of Measure"; Rec."FG Item Base Unit of Measure")
                {
                    ApplicationArea = All;
                    Caption = 'FG Item Base Unit of Measure';
                }
                field("FG Item Global Dim. 1 Code"; Rec."FG Item Global Dim. 1 Code")
                {
                    ApplicationArea = All;
                    Caption = 'FG Item Global Dimension 1 Code';
                }
                field("FG Item Global Dim. 2 Code"; Rec."FG Item Global Dim. 2 Code")
                {
                    ApplicationArea = All;
                    Caption = 'FG Item Global Dimension 2 Code';
                }
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