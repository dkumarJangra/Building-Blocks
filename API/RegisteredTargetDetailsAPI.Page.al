page 50409 "Registered Target Details API"
{
    PageType = API;

    APIVersion = 'v2.0';
    APIGroup = 'PowerBI';
    APIPublisher = 'Alletec';

    EntityCaption = 'RegisteredTargetDetailsAPI';
    EntitySetCaption = 'RegisteredTargetDetailsAPI';
    EntitySetName = 'RegisteredTargetDetailsAPI';
    EntityName = 'RegisteredTargetDetailsAPI';


    ODataKeyFields = SystemID;
    SourceTable = "Registered Target Details";

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
                field(month; Rec.Month)
                {
                    Caption = 'Month';
                }
                field(year; Rec.Year)
                {
                    Caption = 'Year';
                }
                field(regionCode; Rec."Region Code")
                {
                    Caption = 'Region Code';
                }
                field(noofPlotTarget; Rec."No. of Plot Target")
                {
                    Caption = 'No. of Plot Target';
                }
                field(actualTarget; Rec."Actual Target")
                {
                    Caption = 'Actual Target';
                }
                field(received; Rec.Received)
                {
                    Caption = 'Received';
                }
                field(achivedPlots; Rec."Achived Plots")
                {
                    Caption = 'Achived Plots';
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