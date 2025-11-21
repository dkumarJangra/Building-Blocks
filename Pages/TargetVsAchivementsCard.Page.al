page 50197 "Target Vs Achivements Card"
{
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Target Vs Achivement Summary";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Editable = false;
                }
                field("Team Head Code"; Rec."Team Head Code")
                {
                    Editable = false;
                }
                field("Target Amount"; Rec."Target Amount")
                {
                }
                field("Achived Amount"; Rec."Achived Amount")
                {
                }
                field(Month; Rec.Month)
                {
                    Editable = false;
                }
                field(Year; Rec.Year)
                {
                    Editable = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    Editable = false;
                }
                field("From Date"; Rec."From Date")
                {
                    Editable = false;
                }
                field("To Date"; Rec."To Date")
                {
                    Editable = false;
                }
                field("Period Duration"; Rec."Period Duration")
                {
                    Editable = false;
                }
                field("Target Increament %"; Rec."Target Increament %")
                {
                    Editable = false;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

