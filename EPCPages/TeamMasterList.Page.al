page 50250 "Team Master List"
{
    PageType = List;
    SourceTable = "Team Master";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Team Code"; Rec."Team Code")
                {
                }
                field("Team Name"; Rec."Team Name")
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
        TeamMaster: Record "Team Master";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SETSELECTIONFILTER(TeamMaster);
        // EXIT(SelectionFilterManagement.GetSelectionFilterForTeamCode(TeamMaster));
    end;


    procedure SetSelection(var TeamMaster: Record "Team Master")
    begin
        CurrPage.SETSELECTIONFILTER(TeamMaster);
    end;
}

