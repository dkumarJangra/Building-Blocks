pageextension 50084 "BBG Transfer Order Subform Ext" extends "Transfer Order Subform"
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

    PROCEDURE BBGShowDimensions()
    BEGIN
        Rec.ShowDimensions;
    END;

    PROCEDURE OpenItemTrackingLines(Direction: Option Outbound,Inbound);
    BEGIN
        Rec.OpenItemTrackingLines(Direction);
    END;

    PROCEDURE BBGShowReservation()
    BEGIN
        Rec.FIND;
        Rec.ShowReservation;
    END;

    PROCEDURE GetIndentLineInfo()
    BEGIN
        Rec.GetIndentLines;
    END;
}