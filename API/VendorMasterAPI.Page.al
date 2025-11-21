page 50403 "Vendor Master API"
{
    PageType = API;

    APIVersion = 'v2.0';
    APIGroup = 'PowerBI';
    APIPublisher = 'Alletec';

    EntityCaption = 'VendorMasterAPI';
    EntitySetCaption = 'VendorMasterAPI';
    EntitySetName = 'VendorMasterAPI';
    EntityName = 'VendorMasterAPI';


    ODataKeyFields = SystemID;
    SourceTable = Vendor;

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
                    Caption = 'No';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(mobNo; Rec."BBG Mob. No.")
                {
                    Caption = 'Mob. No.';
                }
                field(city; Rec.City)
                {
                    Caption = 'City';
                }
                field(teamCode; Rec."BBG Team Code")
                {
                    Caption = 'Team Code';
                }
                field(leaderCode; Rec."BBG Leader Code")
                {
                    Caption = 'Leader Code';
                }
                field(clusterType; Rec."BBG Cluster Type")
                {
                    Caption = 'Cluster Type';
                }
                field(introducer; Rec."BBG Introducer")
                {
                    Caption = 'Introducer';
                }
                field(blocked; Rec.Blocked)
                {
                    Caption = 'Blocked';
                }
                field(blackList; Rec."BBG Black List")
                {
                    Caption = 'Black List';
                }
                field(creationDate; Rec."BBG Creation Date")
                {
                    Caption = 'Creation Date';
                }
                field(status; Rec."BBG Status")
                {
                    Caption = 'Status';
                }
                field(stateCode; Rec."State Code")
                {
                    Caption = 'State Code';
                }
                field(reportingOffice; Rec."BBG Reporting Office")
                {
                    Caption = 'Reporting Office';
                }
                field(isHelpDeskUser; Rec."BBG Is Help Desk User")
                {
                    Caption = 'Is Help Desk User';
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