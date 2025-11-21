page 50404 "Reporting Office Master API"
{
    PageType = API;

    APIVersion = 'v2.0';
    APIGroup = 'PowerBI';
    APIPublisher = 'Alletec';

    EntityCaption = 'ReportingOfficeMasterAPI';
    EntitySetCaption = 'ReportingOfficeMasterAPI';
    EntitySetName = 'ReportingOfficeMasterAPI';
    EntityName = 'ReportingOfficeMasterAPI';


    ODataKeyFields = SystemID;
    SourceTable = "Reporting Office Master";

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