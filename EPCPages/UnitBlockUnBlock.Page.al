page 50039 "Unit Block/UnBlock"
{
    Editable = true;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Unit Master";
    SourceTableView = WHERE(Status = FILTER(<> Booked));
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
                    Editable = false;
                }
                field("Old No."; Rec."Old No.")
                {
                    Editable = false;
                }
                field("Total Value"; Rec."Total Value")
                {
                    Editable = false;
                }
                field(Blocked; Rec.Blocked)
                {

                    trigger OnValidate()
                    begin

                        CLEAR(WebAppService);
                        COMMIT;
                        WebAppService.UpdateUnitStatus(Rec);
                    end;
                }
                field("Comment for Unit Block"; Rec."Comment for Unit Block")
                {
                }
                field("Block SubType"; Rec."Block SubType")
                {
                }
                field("Non Usable"; Rec."Non Usable")
                {
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field(Reserve; Rec.Reserve)
                {
                }
                field("Web Portal Status"; Rec."Web Portal Status")
                {
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("No. of Plots"; Rec."No. of Plots")
                {
                    Editable = false;
                }
                field("Saleable Area"; Rec."Saleable Area")
                {
                    Editable = false;
                }
                field(Facing; Rec.Facing)
                {
                    Editable = false;
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                    Editable = false;
                }
                field(Freeze; Rec.Freeze)
                {
                    Editable = false;
                }
                field("60 feet Road"; Rec."60 feet Road")
                {
                    Editable = false;
                }
                field("Size-East"; Rec."Size-East")
                {
                    Editable = false;
                }
                field("Size-West"; Rec."Size-West")
                {
                    Editable = false;
                }
                field("Size-North"; Rec."Size-North")
                {
                    Editable = false;
                }
                field("Size-South"; Rec."Size-South")
                {
                    Editable = false;
                }
                field("Super Area"; Rec."Super Area")
                {
                    Editable = false;
                }
                field("Carpet Area"; Rec."Carpet Area")
                {
                    Editable = false;
                }
                field("Efficiency (%)"; Rec."Efficiency (%)")
                {
                    Editable = false;
                }
                field("Sales Rate"; Rec."Sales Rate")
                {
                    Editable = false;
                }
                field("PLC (%)"; Rec."PLC (%)")
                {
                    Editable = false;
                }
                field("Lease Zone Code"; Rec."Lease Zone Code")
                {
                    Editable = false;
                }
                field("Unit Type"; Rec."Unit Type")
                {
                    Editable = false;
                }
                field("Lease Rate"; Rec."Lease Rate")
                {
                    Editable = false;
                }
                field("Sales Blocked"; Rec."Sales Blocked")
                {
                    Editable = false;
                }
                field("Lease Blocked"; Rec."Lease Blocked")
                {
                    Editable = false;
                }
                field("Project Price Group"; Rec."Project Price Group")
                {
                    Editable = false;
                }
                field("Sales Order Count"; Rec."Sales Order Count")
                {
                    Editable = false;
                }
                field("Lease Order Count"; Rec."Lease Order Count")
                {
                    Editable = false;
                }
                field("Constructed Property"; Rec."Constructed Property")
                {
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    Editable = false;
                }
                field("Sub Project Code"; Rec."Sub Project Code")
                {
                    Editable = false;
                }
                field("Sell to Customer No."; Rec."Sell to Customer No.")
                {
                    Editable = false;
                }
                field("Broker No."; Rec."Broker No.")
                {
                    Editable = false;
                }
                field("Floor No."; Rec."Floor No.")
                {
                    Editable = false;
                }
                field("Project Name"; Rec."Project Name")
                {
                    Editable = false;
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
            }
        }
    }

    trigger OnOpenPage()
    begin
        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
        /*
        Memberof.RESET;
        Memberof.SETRANGE(Memberof."User ID",USERID);
        Memberof.SETRANGE(Memberof."Role ID",'A_UnitClosed');
        IF NOT Memberof.FINDFIRST THEN
          ERROR('You do not have permission of Role: A_UnitClosed');
        */
        // ALLE MM Code Commented as Member of table has been remove in NAV 2016

    end;

    var
        Application: Record Application;
        WebAppService: Codeunit "Web App Service";
}

