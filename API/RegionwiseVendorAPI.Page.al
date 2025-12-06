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
                field(name; Rec.Name)
                {
                    Caption = 'Name';

                }
                field(rankCode; Rec."Rank Code")
                {
                    Caption = 'Rank Code';

                }

                field(rankdescription; Rec."Rank Description")
                {
                    Caption = 'Rank Description';
                }
                field(regionCode; Rec."Region Code")
                {
                    Caption = 'Region Code';

                }
                field(regionDescription; Rec."Region Description")
                {
                    Caption = 'Region Description';

                }

                field(parentCode; Rec."Parent Code")
                {
                    Caption = 'Parent Code';

                }
                field(parentName; Rec."Parent Name")
                {
                    Caption = 'Parent Name';

                }
                field(parentRank; Rec."Parent Rank")
                {
                    Caption = 'Parent Rank';

                }
                field(parentDescription; Rec."Parent Description")
                {
                    Caption = 'Parent Description';

                }

                field(status; Rec.Status)
                {
                    Caption = 'Status';

                }


                field(VendorCheckStatus; Rec."Vendor Check Status")
                {

                }



                field(EMail; Rec."E-Mail")
                {

                }
                field(NewRegionCode; Rec."New Region Code")
                {

                }
                field(TeamHead; Rec."Team Head")
                {

                }
                field(TeamCode; Rec."Team Code")
                {

                }
                field(LeaderCode; Rec."Leader Code")
                {

                }
                field(SubTeamCode; Rec."Sub Team Code")
                {

                }
                field(CPTeamCode; Rec."CP Team Code")
                {

                }
                field(CPLeaderCode; Rec."CP Leader Code")
                {

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