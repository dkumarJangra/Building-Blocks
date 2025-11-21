pageextension 50057 "BBG G/L Balance/Budget Ext" extends "G/L Balance/Budget"
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
        SetSecurity(FALSE);
    end;

    LOCAL PROCEDURE SetSecurity(OpenForm: Boolean);
    BEGIN

        //BBG1.00 ALLEDK 050313

        //   IF OpenForm THEN BEGIN
        //     IF NOT TableSecurity.GetTableSecurity(FORM::"G/L Balance/Budget") THEN
        //       EXIT;

        //     IF TableSecurity."Form General Permission" = TableSecurity."Form General Permission"::Visible THEN
        //       CurrForm.EDITABLE(FALSE);

        //     TableSecurity.SetFieldFilters(Rec);
        //   END ELSE
        //     IF TableSecurity."Security for Form No." = 0 THEN
        //       EXIT;

        //   IF CurrForm."No.".EDITABLE THEN
        //     CurrForm."No.".EDITABLE(TableSecurity."No." = 0);
        //   IF TableSecurity."No." IN [2,5] THEN BEGIN
        //     CurrForm."No.".VISIBLE(FALSE);
        //     SETRANGE("No.");
        //   END;
        //   IF CurrForm.Name.EDITABLE THEN
        //     CurrForm.Name.EDITABLE(TableSecurity.Name = 0);
        //   IF TableSecurity.Name IN [2,5] THEN BEGIN
        //     CurrForm.Name.VISIBLE(FALSE);
        //     SETRANGE(Name);
        //   END;
        //   IF CurrForm."Income/Balance".EDITABLE THEN
        //     CurrForm."Income/Balance".EDITABLE(TableSecurity."Income/Balance" = 0);
        //   IF TableSecurity."Income/Balance" IN [2,5] THEN BEGIN
        //     CurrForm."Income/Balance".VISIBLE(FALSE);
        //     SETRANGE("Income/Balance");
        //   END;
        //   IF CurrForm."Date Filter".EDITABLE THEN
        //     CurrForm."Date Filter".EDITABLE(TableSecurity."Date Filter" = 0);
        //   IF TableSecurity."Date Filter" IN [2,5] THEN BEGIN
        //     CurrForm."Date Filter".VISIBLE(FALSE);
        //     SETRANGE("Date Filter");
        //   END;
        //   IF CurrForm."Global Dimension 1 Filter".EDITABLE THEN
        //     CurrForm."Global Dimension 1 Filter".EDITABLE(TableSecurity."Global Dimension 1 Filter" = 0);
        //   IF TableSecurity."Global Dimension 1 Filter" IN [2,5] THEN BEGIN
        //     CurrForm."Global Dimension 1 Filter".VISIBLE(FALSE);
        //     SETRANGE("Global Dimension 1 Filter");
        //   END;
        //   IF CurrForm."Global Dimension 2 Filter".EDITABLE THEN
        //     CurrForm."Global Dimension 2 Filter".EDITABLE(TableSecurity."Global Dimension 2 Filter" = 0);
        //   IF TableSecurity."Global Dimension 2 Filter" IN [2,5] THEN BEGIN
        //     CurrForm."Global Dimension 2 Filter".VISIBLE(FALSE);
        //     SETRANGE("Global Dimension 2 Filter");
        //   END;
        //   IF CurrForm."Net Change".EDITABLE THEN
        //     CurrForm."Net Change".EDITABLE(TableSecurity."Net Change" = 0);
        //   IF TableSecurity."Net Change" IN [2,5] THEN BEGIN
        //     CurrForm."Net Change".VISIBLE(FALSE);
        //     SETRANGE("Net Change");
        //   END;
        //   IF CurrForm."Budgeted Amount".EDITABLE THEN
        //     CurrForm."Budgeted Amount".EDITABLE(TableSecurity."Budgeted Amount" = 0);
        //   IF TableSecurity."Budgeted Amount" IN [2,5] THEN BEGIN
        //     CurrForm."Budgeted Amount".VISIBLE(FALSE);
        //     SETRANGE("Budgeted Amount");
        //   END;
        //   IF CurrForm."Budget Filter".EDITABLE THEN
        //     CurrForm."Budget Filter".EDITABLE(TableSecurity."Budget Filter" = 0);
        //   IF TableSecurity."Budget Filter" IN [2,5] THEN BEGIN
        //     CurrForm."Budget Filter".VISIBLE(FALSE);
        //     SETRANGE("Budget Filter");
        //   END;
        //   IF CurrForm."Debit Amount".EDITABLE THEN
        //     CurrForm."Debit Amount".EDITABLE(TableSecurity."Debit Amount" = 0);
        //   IF TableSecurity."Debit Amount" IN [2,5] THEN BEGIN
        //     CurrForm."Debit Amount".VISIBLE(FALSE);
        //     SETRANGE("Debit Amount");
        //   END;
        //   IF CurrForm."Credit Amount".EDITABLE THEN
        //     CurrForm."Credit Amount".EDITABLE(TableSecurity."Credit Amount" = 0);
        //   IF TableSecurity."Credit Amount" IN [2,5] THEN BEGIN
        //     CurrForm."Credit Amount".VISIBLE(FALSE);
        //     SETRANGE("Credit Amount");
        //   END;
        //   IF CurrForm."Budgeted Debit Amount".EDITABLE THEN
        //     CurrForm."Budgeted Debit Amount".EDITABLE(TableSecurity."Budgeted Debit Amount" = 0);
        //   IF TableSecurity."Budgeted Debit Amount" IN [2,5] THEN BEGIN
        //     CurrForm."Budgeted Debit Amount".VISIBLE(FALSE);
        //     SETRANGE("Budgeted Debit Amount");
        //   END;
        //   IF CurrForm."Budgeted Credit Amount".EDITABLE THEN
        //     CurrForm."Budgeted Credit Amount".EDITABLE(TableSecurity."Budgeted Credit Amount" = 0);
        //   IF TableSecurity."Budgeted Credit Amount" IN [2,5] THEN BEGIN
        //     CurrForm."Budgeted Credit Amount".VISIBLE(FALSE);
        //     SETRANGE("Budgeted Credit Amount");
        //   END;


        //BBG1.00 ALLEDK 050313
    END;

}