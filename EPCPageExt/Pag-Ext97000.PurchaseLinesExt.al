pageextension 97000 "EPC Purchase Lines Ext" extends "Purchase Lines"
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
        GRNHeader: Record "GRN Header";
        GRNMode: Boolean;
        GRNLine: Record "GRN Line";

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF CloseAction = ACTION::LookupOK THEN
            IF GRNMode THEN BEGIN
                CurrPage.SETSELECTIONFILTER(Rec);
                GRNLine.FillGRNLines(Rec, GRNHeader);
            END;
    end;

    PROCEDURE SetGRNHeader(vGRNHeader: Record "GRN Header");
    BEGIN
        GRNHeader := vGRNHeader;
    END;

    PROCEDURE SetGRNMode(vGRNMode: Boolean);
    BEGIN
        GRNMode := vGRNMode;
    END;

}