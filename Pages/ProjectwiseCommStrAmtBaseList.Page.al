page 50248 "Project Wise Comm. Str. List"
{
    PageType = List;
    SourceTable = "Commission Structr Amount Base";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Project Code"; Rec."Project Code")
                {
                }
                field("Start Date"; Rec."Start Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field("Rank Code"; Rec."Rank Code")
                {
                }
                field("Desg. Code"; Rec."Desg. Code")
                {
                }
                field("Payment Plan Code"; Rec."Payment Plan Code")
                {
                }
                field("% Per Square"; Rec."% Per Square")
                {

                }
                field("60 Ft % Per Square"; Rec."60 Ft % Per Square")
                {

                }
                field("Corner % Per Square"; Rec."Corner % Per Square")
                {

                }
                field("Corner And 60 Ft % Per Sq."; Rec."Corner And 60 Ft % Per Sq.")
                {

                }
                field("East Facing % Per Sq."; Rec."East Facing % Per Sq.")
                {

                }

                field("Rate Per Square"; Rec."Rate Per Square")
                {
                }
                field("Commission % on Min.Allotment"; Rec."Commission % on Min.Allotment")
                {
                    Visible = False;
                }
                field("Corner Rate Per Square"; Rec."Corner Rate Per Square")
                {
                }
                field("60 Ft Rate Per Square"; Rec."60 Ft Rate Per Square")
                {
                }
                field("Corner And 60 Ft Rate Per Sq."; Rec."Corner And 60 Ft Rate Per Sq.")
                {
                }
                field("East Facing Rate Per Sq."; Rec."East Facing Rate Per Sq.")
                {
                }

            }
        }
    }

    actions
    {
        area(processing)
        {

        }
    }

    var

}

