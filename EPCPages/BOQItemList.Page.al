page 97814 "BOQ Item List"
{
    // ALLESP BCL0011 10-07-2007: New Form created to enter the BOQ Items

    DelayedInsert = true;
    Editable = false;
    InsertAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "BOQ Item";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Project Code"; Rec."Project Code")
                {
                    Editable = false;
                }
                field("Phase Code"; Rec."Phase Code")
                {
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    Editable = false;
                }
                field(Code; Rec.Code)
                {
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                    Visible = true;
                }
                field("Base UOM"; Rec."Base UOM")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                    BlankZero = true;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    BlankZero = true;
                    Caption = 'Unit Rate';
                }
                field("Total Price"; Rec."Total Price")
                {
                    BlankZero = true;
                    Caption = 'Total Amount';
                    Editable = false;
                }
                field(Material; Rec.Material)
                {
                    Editable = false;
                    Visible = false;
                }
                field(Labor; Rec.Labor)
                {
                    Editable = false;
                    Visible = false;
                }
                field(Equipment; Rec.Equipment)
                {
                    Editable = false;
                    Visible = false;
                }
                field(Other; Rec.Other)
                {
                    Editable = false;
                    Visible = false;
                }
                field("OverHead %"; Rec."OverHead %")
                {
                    Visible = false;
                }
                field("Brick Std Consumption"; Rec."Brick Std Consumption")
                {
                    Visible = false;
                }
                field("Cement Std Consumption"; Rec."Cement Std Consumption")
                {
                    Visible = false;
                }
                field("Steel Std Consumption"; Rec."Steel Std Consumption")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(BOQ)
            {
                Caption = 'BOQ';
                action(Import)
                {
                    Caption = 'Import';
                    RunObject = XMLport "Upload Sale BOQ Master";
                    Visible = false;
                }
                action("Extended Text")
                {
                    Caption = 'Extended Text';
                    RunObject = Page "Extended Text";
                    RunPageLink = "Table Name" = CONST("BOQ Item"),
                                  "No." = FIELD("Project Code"),
                                  "Text No." = FIELD("Entry No.");
                    RunPageView = SORTING("Table Name", "No.", "Language Code", "Text No.");
                }
                action(ExportToExcel)
                {
                    Caption = 'ExportToExcel';

                    trigger OnAction()
                    begin
                        Rec.ExportToEx();
                    end;
                }
                action("BOQ Modification")
                {
                    Caption = 'BOQ Modification';
                    RunObject = Page "BOQ Modification";
                    RunPageLink = Code = FIELD(Code),
                                  "Entry No." = FIELD("Entry No."),
                                  "Project Code" = FIELD("Project Code");
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        DescriptionOnFormat;
        Description2OnFormat;
    end;

    trigger OnOpenPage()
    begin
        IF CurrPage.LOOKUPMODE THEN
            CurrPage.EDITABLE := FALSE;
    end;

    var

        DescriptionEmphasize: Boolean;

        "Description 2Emphasize": Boolean;

    local procedure DescriptionOnFormat()
    begin
        //CurrPage.Description.UPDATEINDENT((Indentation) * 220); // ALLE MM Code Commented

        DescriptionEmphasize := Rec."Value Type" <> Rec."Value Type"::Posting;
    end;

    local procedure Description2OnFormat()
    begin
        "Description 2Emphasize" := Rec."Value Type" <> Rec."Value Type"::Posting;
    end;
}

