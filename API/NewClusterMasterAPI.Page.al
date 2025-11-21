page 50400 "New Cluster Master API"
{
    PageType = API;

    APIVersion = 'v2.0';
    APIGroup = 'PowerBI';
    APIPublisher = 'Alletec';

    EntityCaption = 'NewClusterMasterAPI';
    EntitySetCaption = 'NewClusterMasterAPI';
    EntitySetName = 'NewClusterMasterAPI';
    EntityName = 'NewClusterMasterAPI';


    ODataKeyFields = SystemID;
    SourceTable = "New Cluster Master";

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
                field(clusterCode; Rec."Cluster Code")
                {
                    Caption = 'Cluster Code';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(regionCode; Rec."Region Code")
                {
                    Caption = 'Region Code';
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