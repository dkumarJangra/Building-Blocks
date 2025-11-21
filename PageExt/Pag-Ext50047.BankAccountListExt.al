pageextension 50047 "BBG Bank Account List Ext" extends "Bank Account List"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            field("Name 2"; Rec."Name 2")
            {
                ApplicationArea = All;
            }
            field("Balance (LCY)"; Rec."Balance (LCY)")
            {
                ApplicationArea = All;
            }
            field("Net Change (LCY)"; Rec."Net Change (LCY)")
            {
                ApplicationArea = All;
            }
            field(Address; Rec.Address)
            {
                ApplicationArea = All;
            }
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = All;
            }
        }
        addafter("Post Code")
        {
            field(City; Rec.City)
            {
                ApplicationArea = All;
            }
        }
        addafter("Search Name")
        {
            field(Blocked; Rec.Blocked)
            {
                ApplicationArea = All;
            }
            field("Date Filter"; Rec."Date Filter")
            {
                ApplicationArea = All;
            }
            Field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = All;
            }
            field("Created By"; Rec."Created By")
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
        UserSetup: Record "User Setup";

    trigger OnOpenPage()
    begin

        Rec.FilterGroup(10);
        Rec.SetRange("Hide Bank Account", false);
        Rec.FilterGroup(0);

        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("View of BALedger Entry", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            UserSetup.TESTFIELD("View of BALedger Entry");


        //ALLETDK061212--BEGIN
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("User Branch");
        Rec.SETFILTER("Branch Code", '%1|%2', UserSetup."User Branch", '');
        Rec.FILTERGROUP(3);
        //ALLETDK061212--END
    end;
}