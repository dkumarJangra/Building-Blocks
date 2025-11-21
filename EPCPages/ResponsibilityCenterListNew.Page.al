page 97820 "Responsibility Center ListNew"
{
    Caption = 'Responsibility Center BBG';
    CardPageID = "Responsibility Center Card New";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Responsibility Center 1";
    SourceTableView = WHERE(Blocked = CONST(false));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("Cluster Code"; Rec."Cluster Code")
                {
                }
                field(Address; Rec.Address)
                {
                }
                field("Branch Name"; Rec."Branch Name")
                {
                }
                field(Published; Rec.Published)
                {
                }
                field("Sequence of Project"; Rec."Sequence of Project")
                {
                }
                field("Full Name"; Rec."Full Name")
                {
                }
                field("Active Projects"; Rec."Active Projects")
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                }
                field(Trading; Rec.Trading)
                {
                }
                field("Non-Trading"; Rec."Non-Trading")
                {
                }
                field("Min. Amt. Single plot for Web"; Rec."Min. Amt. Single plot for Web")
                {
                }
                field("Min. Amt. Double plot for Web"; Rec."Min. Amt. Double plot for Web")
                {
                }
                field("Min. Amt. Days (First Day)"; Rec."Min. Amt. Days (First Day)")
                {
                }
                field("Min. Amt. Option Change Day"; Rec."Min. Amt. Option Change Day")
                {
                }
                field("Allotment Amt Days (First Day)"; Rec."Allotment Amt Days (First Day)")
                {
                }
                field("Allotment Amt. Change Days"; Rec."Allotment Amt. Change Days")
                {
                }
                field("Option A Days (First Days)"; Rec."Option A Days (First Days)")
                {
                }
                field("Option A Option Change Days"; Rec."Option A Option Change Days")
                {
                }
                field("Option B Days (First Days)"; Rec."Option B Days (First Days)")
                {
                }
                field("Option B Option Change Days"; Rec."Option B Option Change Days")
                {
                }
                field("Option C Days (First Days)"; Rec."Option C Days (First Days)")
                {
                }
                field("Option C Option Change Days"; Rec."Option C Option Change Days")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Resp. Ctr.")
            {
                Caption = '&Resp. Ctr.';
                Image = Dimensions;
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action("Dimensions-Single")
                    {
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = CONST(5714),
                                      "No." = FIELD(Code);
                        ShortCutKey = 'Shift+Ctrl+D';
                    }
                    action("Dimensions-&Multiple")
                    {
                        AccessByPermission = TableData Dimension = R;
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;

                        trigger OnAction()
                        var
                            RespCenter: Record "Responsibility Center";
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SETSELECTIONFILTER(RespCenter);
                            //DefaultDimMultiple.SetMultiRespCenter(RespCenter);
                            DefaultDimMultiple.RUNMODAL;
                        end;
                    }
                }
            }
        }
    }


    procedure GetSelectionFilter(): Code[100]
    var
        DimVal: Record "Responsibility Center 1";
        FirstDimVal: Code[20];
        LastDimVal: Code[20];
        SelectionFilter: Code[250];
        DimValCount: Integer;
        More: Boolean;
    begin
        CurrPage.SETSELECTIONFILTER(DimVal);
        DimValCount := DimVal.COUNT;
        IF DimValCount > 0 THEN BEGIN
            DimVal.FIND('-');
            WHILE DimValCount > 0 DO BEGIN
                DimValCount := DimValCount - 1;
                DimVal.MARKEDONLY(FALSE);
                FirstDimVal := DimVal.Code;
                LastDimVal := FirstDimVal;
                More := (DimValCount > 0);
                WHILE More DO
                    IF DimVal.NEXT = 0 THEN
                        More := FALSE
                    ELSE
                        IF NOT DimVal.MARK THEN
                            More := FALSE
                        ELSE BEGIN
                            LastDimVal := DimVal.Code;
                            DimValCount := DimValCount - 1;
                            IF DimValCount = 0 THEN
                                More := FALSE;
                        END;
                IF SelectionFilter <> '' THEN
                    SelectionFilter := SelectionFilter + '|';
                IF FirstDimVal = LastDimVal THEN
                    SelectionFilter := SelectionFilter + FirstDimVal
                ELSE
                    SelectionFilter := SelectionFilter + FirstDimVal + '..' + LastDimVal;
                IF DimValCount > 0 THEN BEGIN
                    DimVal.MARKEDONLY(TRUE);
                    DimVal.NEXT;
                END;
            END;
        END;
        EXIT(SelectionFilter);
    end;
}

