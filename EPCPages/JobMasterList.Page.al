page 97720 "Job Master List"
{
    // //AllEAB001: New Menu Item Code written for opening new job card

    Editable = true;
    PageType = Card;
    SourceTable = "Job Master";
    SourceTableView = SORTING(Code)
                      ORDER(Ascending);
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                }
                field(Category; Rec.Category)
                {
                }
                field("Default Cost Center Code"; Rec."Default Cost Center Code")
                {
                    Editable = false;
                }
                field("Default Cost Center Name"; Rec."Default Cost Center Name")
                {
                    Editable = false;
                }
                field("Sub Category"; Rec."Sub Category")
                {
                }
                field("Sub Sub Category"; Rec."Sub Sub Category")
                {
                }
                field("Base UOM"; Rec."Base UOM")
                {
                }
                field(Rate; Rec.Rate)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                    Editable = true;
                    Visible = true;
                }
                field("Description 3"; Rec."Description 3")
                {
                }
                field("Description 4"; Rec."Description 4")
                {
                }
                field("Qty. on Work Order"; Rec."Qty. on Work Order")
                {
                }
                field("G/L Code"; Rec."G/L Code")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Card)
            {
                Caption = 'Card';
                action(Edit)
                {
                    Caption = 'Edit';
                    RunObject = Page "Job Master";
                    RunPageLink = Code = FIELD(Code);
                    ShortCutKey = 'Shift+F7';
                }
                action(New)
                {
                    Caption = 'New';

                    trigger OnAction()
                    begin
                        //ALLEAB001
                        IF CONFIRM('Are you sure you want to create Job', TRUE) THEN BEGIN
                            JobMaster.INIT;
                            JobMaster.Code := '';
                            JobMaster.INSERT(TRUE);
                            PAGE.RUN(PAGE::"Job Master", JobMaster);
                        END;
                        //ALLEAB001
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        IF CurrPage.LOOKUPMODE THEN
            CurrPage.EDITABLE := FALSE;
    end;

    var
        JobMaster: Record "Job Master";
}

