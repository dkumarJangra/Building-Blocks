pageextension 50019 "BBG Sales Invoice Subform Ext" extends "Sales Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Qty. Assigned")
        {
            field("BOQ Code"; Rec."BOQ Code")
            {
                ApplicationArea = All;
            }
            field("IPA Qty"; Rec."IPA Qty")
            {
                ApplicationArea = All;
            }
            field("Qty Since Last Bill"; Rec."Qty Since Last Bill")
            {
                ApplicationArea = All;
            }
            field("Escalation Type"; Rec."Escalation Type")
            {
                ApplicationArea = All;
            }
            field("Invoice Type1"; Rec."Invoice Type1")
            {
                ApplicationArea = All;
            }
            field("Present Index"; Rec."Present Index")
            {
                ApplicationArea = All;
            }
            field("Base Index"; Rec."Base Index")
            {
                ApplicationArea = All;
            }
            field("Escalation Line No."; Rec."Escalation Line No.")
            {
                ApplicationArea = All;
            }
            field("Entry No."; Rec."Entry No.")
            {
                ApplicationArea = All;
            }
            field("Approval Status"; Rec."Approval Status")
            {
                ApplicationArea = All;
            }
            field("Project Code"; Rec."Project Code")
            {
                ApplicationArea = All;
            }
            field("Upto Date Qty"; Rec."Upto Date Qty")
            {
                ApplicationArea = All;
            }
            field("Charge Type"; Rec."Charge Type")
            {
                ApplicationArea = All;
            }
            field("Super Area"; Rec."Super Area")
            {
                ApplicationArea = All;
            }
            field("Rate Per Area"; Rec."Rate Per Area")
            {
                ApplicationArea = All;
            }
            field("PLC %"; Rec."PLC %")
            {
                ApplicationArea = All;
            }
            field("Rate Per Area-Final"; Rec."Rate Per Area-Final")
            {
                ApplicationArea = All;
            }
            field("Escalation %"; Rec."Escalation %")
            {
                ApplicationArea = All;
            }
            field("BOQ Quantity"; Rec."BOQ Quantity")
            {
                ApplicationArea = All;
            }
            field("Steel Works"; Rec."Steel Works")
            {
                ApplicationArea = All;
            }
            field("Explode Bom Qty"; Rec."Explode Bom Qty")
            {
                ApplicationArea = All;
            }
            field("Escalation Account"; Rec."Escalation Account")
            {
                ApplicationArea = All;
            }
            field("BOQ Rate Inclusive Tax"; Rec."BOQ Rate Inclusive Tax")
            {
                ApplicationArea = All;
            }
            field("RIT Done"; Rec."RIT Done")
            {
                ApplicationArea = All;
            }
            field("RIT Tax"; Rec."RIT Tax")
            {
                ApplicationArea = All;
            }
            field("Phase Code 1"; Rec."Phase Code 1")
            {
                ApplicationArea = All;
            }
            field("Tender Rate"; Rec."Tender Rate")
            {
                ApplicationArea = All;
            }
            field("Premium/Discount Amount"; Rec."Premium/Discount Amount")
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

    PROCEDURE CalculateRIT();
    BEGIN
        CalculateRIT;
    END;
}