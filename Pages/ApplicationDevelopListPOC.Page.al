page 50141 "Application Develop List (POC)"
{
    Caption = 'Application Development List (POC)';
    CardPageID = "Application Development Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "New Confirmed Order";
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = true;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("User Id"; Rec."User Id")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field("Unit Code"; Rec."Unit Code")
                {
                }
                field("Saleable Area"; Rec."Saleable Area")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Total Received Amount"; Rec."Total Received Amount")
                {
                }
                field("Development Charges"; Rec."Development Charges")
                {
                }
                field("Total Received Dev. Charges"; Rec."Total Received Dev. Charges")
                {
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    var
        GetDescription: Codeunit GetDescription;
        AssHierarcyWithApp: Record "Associate Hierarcy with App.";
        NewConforder: Record "New Confirmed Order";
        Companywise: Record "Company wise G/L Account";
}

