pageextension 50072 "BBG Job Queue Entry Card Ext" extends "Job Queue Entry Card"
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
    begin
        IF (USERID <> '100360') AND (USERID <> 'BCUSER') AND (USERID <> 'NAVUSER4') AND (USERID <> 'NAVUSER3') AND (USERID <> 'BCUSER') AND (USERID <> 'BCUSER') THEN
            ERROR('Please contact Admin');
    end;
}