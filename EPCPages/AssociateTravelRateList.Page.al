page 50023 "Associate Travel Rate List"
{
    Editable = false;
    PageType = Card;
    SourceTable = "Travel Setup Line New";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Effective Date"; Rec."Effective Date")
                {
                }
                field("Project Code"; Rec."Project Code")
                {
                }
                field(Rate; Rec.Rate)
                {
                }
                field("Branch Code"; Rec."Branch Code")
                {
                }
                field("Project Name"; Rec."Project Name")
                {
                }
                field("Branch Name"; Rec."Branch Name")
                {
                }
            }
        }
    }

    actions
    {
    }


    procedure GetSelectionFilter(): Code[100]
    var
        DimVal: Record "Travel Setup Line New";
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
                FirstDimVal := DimVal."Project Code";
                LastDimVal := FirstDimVal;
                More := (DimValCount > 0);
                WHILE More DO
                    IF DimVal.NEXT = 0 THEN
                        More := FALSE
                    ELSE
                        IF NOT DimVal.MARK THEN
                            More := FALSE
                        ELSE BEGIN
                            LastDimVal := DimVal."Project Code";
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

