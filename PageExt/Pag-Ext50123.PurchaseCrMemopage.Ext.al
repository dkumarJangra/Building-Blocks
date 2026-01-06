pageextension 50123 "Purchase Credit MemosExt" extends "Purchase Credit Memos"
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
        Rec.SetRange("Inter Purchase Document", false);
    end;
}