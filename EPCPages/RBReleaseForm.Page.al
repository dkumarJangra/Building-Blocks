page 50025 "RB Release Form"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Confirmed Order";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                }
                field("Total Clear App. Amt"; Rec."Total Clear App. Amt")
                {
                    Caption = 'After Clearance Amount';
                    Editable = false;
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                }
                field("Amount Received"; Rec."Amount Received")
                {
                }
                field("Commission Not Generate"; Rec."Commission Not Generate")
                {
                }
                field("Commission Hold on Full Pmt"; Rec."Commission Hold on Full Pmt")
                {
                }
                field("RB Amount"; Rec."RB Amount")
                {
                }
                field("Received RB Amount"; Rec."Received RB Amount")
                {
                }
                field("Commission RB Amount"; Rec."Commission RB Amount")
                {
                }
                field("Registration Bonus Hold(BSP2)"; Rec."Registration Bonus Hold(BSP2)")
                {
                }
                field("Commission Base amt"; Rec."Commission Base amt")
                {
                }
                field("Commission applicable base amt"; Rec."Commission applicable base amt")
                {
                }
                field("User Id"; Rec."User Id")
                {
                }
            }
        }
    }

    actions
    {
    }
}

