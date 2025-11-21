page 50296 "Target Field Master List"
{
    PageType = List;
    SourceTable = "Target field master";
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
                field(Description; Rec.Description)
                {
                }
            }
        }
    }

    actions
    {
    }


    procedure GetSelectionFilter(): Text
    var
        Targetfieldmaster: Record "Target field master";
        SelectionFilterManagement: Codeunit "BBG Codeunit Event Mgnt.";// SelectionFilterManagement;
    begin
        CurrPage.SETSELECTIONFILTER(Targetfieldmaster);
        EXIT(SelectionFilterManagement.GetSelectionFilterForTargetField(Targetfieldmaster));
    end;


    procedure SetSelection(var Targetfieldmaster: Record "Target field master")
    begin
        CurrPage.SETSELECTIONFILTER(Targetfieldmaster);
    end;
}

