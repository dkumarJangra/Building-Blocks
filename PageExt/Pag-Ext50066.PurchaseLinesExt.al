pageextension 50066 "BBG Purchase Lines Ext" extends "Purchase Lines"
{
    layout
    {
        // Add changes to page layout here

    }

    actions
    {
        // Add changes to page actions here
        addafter("&Line")
        {
            action(OK)
            {
                Caption = 'Insert PO Lines';
                Image = Insert;
                ApplicationArea = All;
                Promoted = true;
                trigger OnAction()
                begin
                    //IF GRNMode THEN BEGIN
                    CurrPage.SETSELECTIONFILTER(Rec);
                    GRNLine.FillGRNLines(Rec, GRNHeader);
                    //END;
                    //IF InspectionMode THEN BEGIN
                    //  CurrPage.SETSELECTIONFILTER(Rec);
                    //  InspectionLine.FillGRNLines(Rec,InspectionHeader);
                    //END;
                    //IF GPassMode THEN BEGIN
                    // CurrPage.SETSELECTIONFILTER(Rec);
                    //GatePassLine.FillGatePassLines(Rec,GatePassHdr);
                    //END;

                    //IF InspectionMode THEN BEGIN
                    // CurrPage.SETSELECTIONFILTER(Rec);
                    //InspectionDocLine.FillGRNLines(Rec,InspectionDocument);
                    //END;
                    CurrPage.CLOSE;
                end;
            }

        }
    }

    var
        myInt: Integer;
        GRNLine: Record "GRN Line";
        GRNMode: Boolean;
        GRNHeader: Record "GRN Header";

}