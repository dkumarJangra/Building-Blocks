page 97984 "Incentive Line Subform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Incentive Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Incentive Type"; Rec."Incentive Type")
                {
                    Editable = true;
                }
                field("Project Code"; Rec."Project Code")
                {
                }
                field("Project Name"; Rec."Project Name")
                {
                }
                field("Extent Eligibilty"; Rec."Extent Eligibilty")
                {
                    Visible = "Extent EligibiltyVisible";
                }
                field("Plot Eligibility"; Rec."Plot Eligibility")
                {
                    Visible = "Plot EligibilityVisible";
                }
                field(UOM; Rec.UOM)
                {
                    Visible = UOMVisible;
                }
                field("Min. Required Collection"; Rec."Min. Required Collection")
                {
                }
                field("Incentive Amount"; Rec."Incentive Amount")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        "Plot EligibilityVisible" := TRUE;
        UOMVisible := TRUE;
        "Extent EligibiltyVisible" := TRUE;
    end;

    var

        "Extent EligibiltyVisible": Boolean;

        UOMVisible: Boolean;

        "Plot EligibilityVisible": Boolean;


    procedure EnableControls(NoOfUnit: Boolean)
    begin
        IF NoOfUnit THEN BEGIN
            "Extent EligibiltyVisible" := FALSE;
            UOMVisible := FALSE;
            "Plot EligibilityVisible" := TRUE;
        END ELSE BEGIN
            "Extent EligibiltyVisible" := TRUE;
            UOMVisible := TRUE;
            "Plot EligibilityVisible" := FALSE;
        END;
    end;
}

