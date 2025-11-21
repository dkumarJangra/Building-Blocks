page 97944 "Application List"
{
    // ALLEPG 310812 : Added Fields.

    Editable = false;
    PageType = List;
    SourceTable = Application;
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
                field("Pass Book No."; Rec."Pass Book No.")
                {
                }
                field("Unit No."; Rec."Unit No.")
                {
                }
                field("Unit Code"; Rec."Unit Code")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Project Type"; Rec."Project Type")
                {
                }
                field("Scheme Code"; Rec."Scheme Code")
                {
                }
                field("Scheme Version No."; Rec."Scheme Version No.")
                {
                }
                field("Scheme Sub Version No."; Rec."Scheme Sub Version No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
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
                field("Received From Code"; Rec."Received From Code")
                {
                }
                field("GetDescription.GetVendorName(Received From Code)";
                GetDescription.GetVendorName(Rec."Received From Code"))
                {
                    Caption = 'Receive from Name';
                }
                field("Investment Type"; Rec."Investment Type")
                {
                }
                field("Investment Frequency"; Rec."Investment Frequency")
                {
                }
                field("Investment Amount"; Rec."Investment Amount")
                {
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                }
                field("Return Payment Mode"; Rec."Return Payment Mode")
                {
                }
                field("Return Frequency"; Rec."Return Frequency")
                {
                }
                field("Return Amount"; Rec."Return Amount")
                {
                }
                field("Maturity Date"; Rec."Maturity Date")
                {
                }
                field("Maturity Amount"; Rec."Maturity Amount")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Service Charge Amount"; Rec."Service Charge Amount")
                {
                }
                field(Duration; Rec.Duration)
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Amount Received"; Rec."Amount Received")
                {
                }
                field(Category; Rec.Category)
                {
                }
                field("Posted Doc No."; Rec."Posted Doc No.")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
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

