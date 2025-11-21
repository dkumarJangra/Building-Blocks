pageextension 50004 "BBG G/L Account List" extends "G/L Account List"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            field("BBG Name 2"; Rec."BBG Name 2")
            {
                ApplicationArea = all;
            }
        }
        addafter("Default Deferral Template Code")
        {
            field("BBG Cash Account"; Rec."BBG Cash Account")
            {
                ApplicationArea = all;
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