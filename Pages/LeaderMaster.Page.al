page 60682 "Leader Master"
{
    PageType = List;
    SourceTable = "Leader Master";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Leader Code"; Rec."Leader Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Allow Special Request"; Rec."Allow Special Request")
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
        LeaderMaster: Record "Leader Master";
        SelectionFilterManagement: Codeunit "BBG Codeunit Event Mgnt.";// SelectionFilterManagement;
    begin
        CurrPage.SETSELECTIONFILTER(LeaderMaster);
        EXIT(SelectionFilterManagement.GetSelectionFilterForLeaderCode(LeaderMaster));
    end;


    procedure SetSelection(var LeaderMaster: Record "Leader Master")
    begin
        CurrPage.SETSELECTIONFILTER(LeaderMaster);
    end;
}

