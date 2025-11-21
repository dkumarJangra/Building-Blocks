page 50408 "New Confirmed Order API"
{
    PageType = API;

    APIVersion = 'v2.0';
    APIGroup = 'PowerBI';
    APIPublisher = 'Alletec';

    EntityCaption = 'NewConfirmedOrderAPI';
    EntitySetCaption = 'NewConfirmedOrderAPI';
    EntitySetName = 'NewConfirmedOrderAPI';
    EntityName = 'NewConfirmedOrderAPI';


    ODataKeyFields = SystemID;
    SourceTable = "New Confirmed Order";

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
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(unitCode; Rec."Unit Code")
                {
                    Caption = 'Unit Code';
                }
                field(shortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Shortcut Dimension 1 Code';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(minAllotmentAmount; Rec."Min. Allotment Amount")
                {
                    Caption = 'Min. Allotment Amount';
                }
                field(registrationDate; Rec."Registration Date")
                {
                    Caption = 'Registration Date';
                }
                field(registrationNo; Rec."Registration No.")
                {
                    Caption = 'Registration No.';
                }
                field(regOffice; Rec."Reg. Office")
                {
                    Caption = 'Reg. Office';
                }
                field(registrationInFavourOf; Rec."Registration In Favour Of")
                {
                    Caption = 'Registration In Favour Of';
                }
                field(registeredOfficeName; Rec."Registered/Office Name")
                {
                    Caption = 'Registered/Office Name';
                }
                field(regAddress; Rec."Reg. Address")
                {
                    Caption = 'Reg. Address';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(IntroducerCode; Rec."Introducer Code")
                {
                    Caption = 'IBA No.';
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