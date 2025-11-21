pageextension 97003 "EPC Job Task Lines Ext" extends "Job Task Lines"
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
        CurrentJobNo: Code[20];
        CurrentJobNo3: Code[30];

    PROCEDURE SetJobNo(CurrentJobNo2: Code[20]);
    BEGIN
        CurrentJobNo3 := CurrentJobNo2;
    END;

}