page 50084 "Application List (POC)"
{
    // ALLEPG 310812 : Added Fields.

    CardPageID = "New Application booking";
    Editable = false;
    PageType = List;
    SourceTable = "New Application Booking";
    SourceTableView = SORTING("Application No.");
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Application No."; Rec."Application No.")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Unit Code"; Rec."Unit Code")
                {
                }
                field("User Id"; Rec."User Id")
                {
                }
                field("Project Type"; Rec."Project Type")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("GetDescription.GetVendorName(Associate Code)";
                GetDescription.GetVendorName(Rec."Associate Code"))
                {
                    Caption = 'MM Name';
                }
                field("Investment Amount"; Rec."Investment Amount")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Amount Received"; Rec."Amount Received")
                {
                }
                field("Development Charges"; Rec."Development Charges")
                {
                }
                field("Unit Payment Plan"; Rec."Unit Payment Plan")
                {
                }
                field("Unit Plan Name"; Rec."Unit Plan Name")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Application")
            {
                Caption = '&Application';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page Application;
                    RunPageLink = "Application No." = FIELD("Application No.");
                    RunPageView = SORTING("Application No.");
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.GET(USERID);
        IF UserSetup."Shortcut Dimension 2 Code" <> '' THEN
            Rec.SETRANGE("Shortcut Dimension 2 Code", UserSetup."Shortcut Dimension 2 Code");
    end;

    var
        GetDescription: Codeunit GetDescription;
}

