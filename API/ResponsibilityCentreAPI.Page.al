page 50402 "Responsiblity Centre API"
{
    PageType = API;

    APIVersion = 'v2.0';
    APIGroup = 'PowerBI';
    APIPublisher = 'Alletec';

    EntityCaption = 'ResponsibilityCenterAPI';
    EntitySetCaption = 'ResponsibilityCenterAPI';
    EntitySetName = 'ResponsibilityCenterAPI';
    EntityName = 'ResponsibilityCenterAPI';


    ODataKeyFields = SystemID;
    SourceTable = "Responsibility Center 1";

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
                field(code; Rec.Code)
                {
                    Caption = 'Code';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(published; Rec.Published)
                {
                    Caption = 'Published';
                }
                field(clusterCode; Rec."Cluster Code")
                {
                    Caption = 'Cluster Code';
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