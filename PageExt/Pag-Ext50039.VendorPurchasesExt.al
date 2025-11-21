pageextension 50039 "BBG Vendor Purchases Ext" extends "Vendor Purchases"
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
        //   IF OpenForm THEN BEGIN
        //         IF NOT TableSecurity.GetTableSecurity(FORM::"Vendor Purchases") THEN
        //             EXIT;

        //         IF TableSecurity."Form General Permission" = TableSecurity."Form General Permission"::Visible THEN
        //             CurrForm.EDITABLE(FALSE);

        //         TableSecurity.SetFieldFilters(Rec);
        //     END ELSE
        //         IF TableSecurity."Security for Form No." = 0 THEN
        //             EXIT;

        //BBG1.00 ALLEDK 050313
    END;

}