pageextension 50104 "BBG Gen. Journal Template" extends "General Journal Templates"
{
    layout
    {
        // Add changes to page layout here
        modify("Page ID")
        {
            ApplicationArea = all;
            Visible = true;
        }
        modify("Posting Report ID")
        {
            ApplicationArea = all;
            Visible = true;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}