page 50407 "Region wise Vendor API"
{
    PageType = API;

    APIVersion = 'v2.0';
    APIGroup = 'PowerBI';
    APIPublisher = 'Alletec';

    EntityCaption = 'RegionwiseVendorAPI';
    EntitySetCaption = 'RegionwiseVendorAPI';
    EntitySetName = 'RegionwiseVendorAPI';
    EntityName = 'RegionwiseVendorAPI';


    ODataKeyFields = SystemID;
    SourceTable = "Region wise Vendor";

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
                field(rankdescription; Rec."Rank Description")
                {
                    Caption = 'Rank Description';
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