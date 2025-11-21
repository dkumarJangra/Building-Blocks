pageextension 97001 "EPC Approval Entries Ext" extends "Approval Entries"
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

    PROCEDURE Setfilters2(TableId: Integer; DocumentNo: Code[20]);
    BEGIN
        IF TableId <> 0 THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETCURRENTKEY("Table ID", "Document Type", "Document No.");
            Rec.SETRANGE("Table ID", TableId);
            IF DocumentNo <> '' THEN
                Rec.SETRANGE("Document No.", DocumentNo);
            Rec.FILTERGROUP(0);
        END;
    END;
}