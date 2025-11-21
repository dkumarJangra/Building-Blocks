page 50401 "Unit Master API"
{
    PageType = API;

    APIVersion = 'v2.0';
    APIGroup = 'PowerBI';
    APIPublisher = 'Alletec';

    EntityCaption = 'UnitMasterAPI';
    EntitySetCaption = 'UnitMasterAPI';
    EntitySetName = 'UnitMasterAPI';
    EntityName = 'UnitMasterAPI';


    ODataKeyFields = SystemID;
    SourceTable = "Unit Master";

    Extensible = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(noofPlots; Rec."No. of Plots")
                {
                    Caption = 'No. of Plots';
                }
                field(hundredfeetRoad; Rec."100 feet Road")
                {
                    Caption = '100 feet Road';
                }
                field(sixtyfeetRoad; Rec."60 feet Road")
                {
                    Caption = '60 feet Road';
                }
                field(saleableArea; Rec."Saleable Area")
                {
                    Caption = 'Saleable Area';
                }
                field(facing; Rec.Facing)
                {
                    Caption = 'Facing';
                }
                field(unitType; Rec."Unit Type")
                {
                    Caption = 'Unit Type';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(totalValue; Rec."Total Value")
                {
                    Caption = 'Total Value';
                }
                field(mortgage; Rec.Mortgage)
                {
                    Caption = 'Mortgage';
                }
                field(nonUsable; Rec."Non Usable")
                {
                    Caption = 'Non Usable';
                }
                field(projectCode; Rec."Project Code")
                {
                    Caption = 'Project Code';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }


            }
        }
    }

    var
        myInt: Integer;
}