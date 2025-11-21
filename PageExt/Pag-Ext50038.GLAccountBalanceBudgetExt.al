pageextension 50038 "BBG G/L Acc. Bal. / Budget Ext" extends "G/L Account Balance/Budget"
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
        //     IF NOT TableSecurity.GetTableSecurity(FORM::"G/L Account Balance/Budget") THEN
        //       EXIT;

        //     IF TableSecurity."Form General Permission" = TableSecurity."Form General Permission"::Visible THEN
        //       CurrForm.EDITABLE(FALSE);

        //     TableSecurity.SetFieldFilters(Rec);
        //   END ELSE
        //     IF TableSecurity."Security for Form No." = 0 THEN
        //       EXIT;

        //   IF CurrForm."Global Dimension 1 Filter".EDITABLE THEN
        //     CurrForm."Global Dimension 1 Filter".EDITABLE(TableSecurity."Global Dimension 1 Filter" = 0);
        //   CurrForm."Global Dimension 1 Filter".VISIBLE(TableSecurity."Global Dimension 1 Filter" IN [0,1,3,4]);
        //   IF TableSecurity."Global Dimension 1 Filter" IN [2,5] THEN
        //     SETRANGE("Global Dimension 1 Filter");
        //   IF CurrForm."Global Dimension 2 Filter".EDITABLE THEN
        //     CurrForm."Global Dimension 2 Filter".EDITABLE(TableSecurity."Global Dimension 2 Filter" = 0);
        //   CurrForm."Global Dimension 2 Filter".VISIBLE(TableSecurity."Global Dimension 2 Filter" IN [0,1,3,4]);
        //   IF TableSecurity."Global Dimension 2 Filter" IN [2,5] THEN
        //     SETRANGE("Global Dimension 2 Filter");
        //   IF CurrForm."Budget Filter".EDITABLE THEN
        //     CurrForm."Budget Filter".EDITABLE(TableSecurity."Budget Filter" = 0);
        //   CurrForm."Budget Filter".VISIBLE(TableSecurity."Budget Filter" IN [0,1,3,4]);
        //   IF TableSecurity."Budget Filter" IN [2,5] THEN
        //     SETRANGE("Budget Filter");


        //BBG1.00 ALLEDK 050313
    END;

}