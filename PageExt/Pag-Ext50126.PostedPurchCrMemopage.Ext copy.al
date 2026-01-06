pageextension 50126 "Posted Sales Cr. MemosExt" extends "Posted sales Credit Memos"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here

    }

    var
        myInt: Integer;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        Rec.SetRange("Inter Sales Document", false);
    end;
}