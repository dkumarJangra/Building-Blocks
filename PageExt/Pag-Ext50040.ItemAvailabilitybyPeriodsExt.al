pageextension 50040 "BBG Item Avail. by Periods Ext" extends "Item Availability by Periods"
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
        SetSecurity(TRUE);
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.SETRANGE("No.");
        SetSecurity(FALSE);
    end;

    LOCAL PROCEDURE SetSecurity(OpenForm: Boolean);
    BEGIN

        //BBG1.00 ALLEDK 050313
        // IF OpenForm THEN BEGIN
        //     IF NOT TableSecurity.GetTableSecurity(FORM::"Item Availability by Periods") THEN
        //         EXIT;

        //     IF TableSecurity."Form General Permission" = TableSecurity."Form General Permission"::Visible THEN
        //         CurrForm.EDITABLE(FALSE);

        //     TableSecurity.SetFieldFilters(Rec);
        // END ELSE
        //     IF TableSecurity."Security for Form No." = 0 THEN
        //         EXIT;

        // IF CurrForm."Location Filter".EDITABLE THEN
        //     CurrForm."Location Filter".EDITABLE(TableSecurity."Location Filter" = 0);
        // CurrForm."Location Filter".VISIBLE(TableSecurity."Location Filter" IN [0, 1, 3, 4]);
        // IF TableSecurity."Location Filter" IN [2, 5] THEN
        //     SETRANGE("Location Filter");
        // IF CurrForm."Variant Filter".EDITABLE THEN
        //     CurrForm."Variant Filter".EDITABLE(TableSecurity."Variant Filter" = 0);
        // CurrForm."Variant Filter".VISIBLE(TableSecurity."Variant Filter" IN [0, 1, 3, 4]);
        // IF TableSecurity."Variant Filter" IN [2, 5] THEN
        //     SETRANGE("Variant Filter");


        //BBG1.00 ALLEDK 050313
    END;

}