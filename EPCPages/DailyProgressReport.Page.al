page 97800 "Daily Progress Report"
{
    // ALLETG RIL0100 16-06-2011: New PAGE`

    Caption = 'Daily Progress Report';
    DataCaptionFields = "Job No.";
    InsertAllowed = false;
    PageType = Card;
    SaveValues = true;
    SourceTable = "Job Task";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
    }

    actions
    {
    }

    var
        //PeriodPAGEMgt: Codeunit 359;
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        QtyType: Option "Net Change","Balance at Date";
        MeasureQty: Decimal;
        JobTask: Record "Job Task";

    local procedure SetDateFilter()
    begin
    end;
}

