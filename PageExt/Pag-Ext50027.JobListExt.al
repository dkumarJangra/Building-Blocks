pageextension 50027 "BBG Job List Ext" extends "Job List"
{
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Company Name"; Rec."Company Name")
            {
                ApplicationArea = All;
            }
            field(Trading; Rec.Trading)
            {
                ApplicationArea = All;
            }
            field("Non-Trading"; Rec."Non-Trading")
            {
                ApplicationArea = All;
            }
            field("Region Code for Rank Hierarcy"; Rec."Region Code for Rank Hierarcy")
            {
                ApplicationArea = All;
            }
            field("Total No. of Units"; Rec."Total No. of Units")
            {
                ApplicationArea = All;
            }
            field("Sub Project Code"; Rec."Sub Project Code")
            {
                ApplicationArea = All;
            }
            field("Total No. of Sub Project Units"; Rec."Total No. of Sub Project Units")
            {
                ApplicationArea = All;
            }
            field("Starting Date"; Rec."Starting Date")
            {
                ApplicationArea = All;
            }
            field("Default Project Type"; Rec."Default Project Type")
            {
                ApplicationArea = All;
            }
            field("Launch Date"; Rec."Launch Date")
            {
                ApplicationArea = All;
            }
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Job Task &Lines")
        {
            action("Project Card")
            {
                Caption = 'Project Card';
                ApplicationArea = All;
            }
        }
    }

    var
        myInt: Integer;
        OpenJob: Boolean;
        UserMgt: Codeunit "EPC User Setup Management";

    trigger OnOpenPage()
    begin
        IF NOT OpenJob THEN BEGIN
            //RAHEE1.00 070512
            IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETRANGE("Responsibility Center", UserMgt.GetPurchasesFilter());
                Rec.FILTERGROUP(0);
            END;
            //RAHEE1.00 070512
        END;
    end;

    PROCEDURE OpenJobfromBG(VOpen: Boolean);
    BEGIN
        OpenJob := VOpen;
    END;
}