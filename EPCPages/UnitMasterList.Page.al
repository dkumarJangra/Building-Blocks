page 97945 "Unit Master List"
{
    // ALLEPG 310812 : Code added to show only not freezed Unit

    CardPageID = "Project Unit Card";
    Editable = false;
    PageType = List;
    SourceTable = "Unit Master";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Project Code"; Rec."Project Code")
                {
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Payment Plan"; Rec."Payment Plan")
                {
                }
                field("No. of Plots for Incentive Cal"; Rec."No. of Plots for Incentive Cal")
                {
                    Visible = false;
                }
                field("Total Value"; Rec."Total Value")
                {
                }
                field("No. of Plots"; Rec."No. of Plots")
                {
                    Visible = false;
                }
                field("Saleable Area"; Rec."Saleable Area")
                {
                }
                field(Facing; Rec.Facing)
                {
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                    Visible = false;
                }
                field("60 feet Road"; Rec."60 feet Road")
                {
                }
                field("100 feet Road"; Rec."100 feet Road")
                {
                }
                field("Size-East"; Rec."Size-East")
                {
                }
                field("Size-West"; Rec."Size-West")
                {
                }
                field("Size-North"; Rec."Size-North")
                {
                }
                field("Size-South"; Rec."Size-South")
                {
                }
                field("Super Area"; Rec."Super Area")
                {
                    Visible = false;
                }
                field("Carpet Area"; Rec."Carpet Area")
                {
                    Visible = false;
                }
                field("Project Name"; Rec."Project Name")
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                }
                field(Corner; Rec.Corner)
                {
                }
                field("PLC Applicable"; Rec."PLC Applicable")
                {
                }
                field("Minimum Booking Amount"; Rec."Minimum Booking Amount")
                {
                }
                field(Mortgage; Rec.Mortgage)
                {
                }
                field("East Boundary"; Rec."East Boundary")
                {
                }
                field("West Boundary"; Rec."West Boundary")
                {
                }
                field("North Boundary"; Rec."North Boundary")
                {
                }
                field("South Boundary"; Rec."South Boundary")
                {
                }
                field("Comment for Unit Block"; Rec."Comment for Unit Block")
                {
                }
                field("Last Unit Blocked DT"; Rec."Last Unit Blocked DT")
                {
                }
                field("Last Unit Blocked By"; Rec."Last Unit Blocked By")
                {
                }
                field("Type Of Deed"; Rec."Type Of Deed")
                {

                }
                field("Deed No"; Rec."Deed No")
                {

                }
                field("Purchasing LLP Name"; Rec."Purchasing LLP Name")
                {

                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Unit Card")
            {
                Caption = 'Unit Card';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Project Unit Card";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("&Unit Project Plan Details")
                {
                    Caption = '&Unit Project Plan Details';
                    RunObject = Report "OD Adjustment in Companies";
                }

                action("Project MIS Details upload")
                {
                    Caption = 'Project MIS Details upload';
                    RunObject = xmlport 50102;
                }

            }
        }
    }

    trigger OnOpenPage()
    begin
        // ALLEPG 310812 Start
        Rec.FILTERGROUP(2);
        //SETRANGE(Freeze,FALSE);
        Rec.FILTERGROUP(0);
        // ALLEPG 310812 End
    end;

    var
        Application: Record Application;
}

