pageextension 50065 "BBG Jobs Setup Ext" extends "Jobs Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter(General)
        {
            group("BBG Fields")
            {
                Caption = 'BBG Fields';
                field("Job G/L Account"; Rec."Job G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Default project Budget Code"; Rec."Default project Budget Code")
                {
                    ApplicationArea = All;
                }
                field("Transporting Charges"; Rec."Transporting Charges")
                {
                    ApplicationArea = All;
                }
                field(Material; Rec.Material)
                {
                    ApplicationArea = All;
                }
                field("Sub- contractor (Drain)"; Rec."Sub- contractor (Drain)")
                {
                    ApplicationArea = All;
                }
                field("Sub- contractor (Concrete)"; Rec."Sub- contractor (Concrete)")
                {
                    ApplicationArea = All;
                }
                field("Direct Salary Exp. Acc."; Rec."Direct Salary Exp. Acc.")
                {
                    ApplicationArea = All;
                }
                field("Type of Work Dimension"; Rec."Type of Work Dimension")
                {
                    ApplicationArea = All;
                }
                field("Machinery Hire Charges"; Rec."Machinery Hire Charges")
                {
                    ApplicationArea = All;
                }
                field("Staff Salary"; Rec."Staff Salary")
                {
                    ApplicationArea = All;
                }
                field("Project Dimension"; Rec."Project Dimension")
                {
                    ApplicationArea = All;
                }
                field("Project Unit Dimension"; Rec."Project Unit Dimension")
                {
                    ApplicationArea = All;
                }
                field("Project Unit of Measure"; Rec."Project Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Project Unit Item Category"; Rec."Project Unit Item Category")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
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