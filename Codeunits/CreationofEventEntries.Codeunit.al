codeunit 50041 "Creation of Event Entries"
{

    trigger OnRun()
    begin
        CLEAR(CustomFunctions);
        CustomFunctions.EventEntriesCreation;
    end;

    var
        CustomFunctions: Codeunit "Custom Functions";
}

