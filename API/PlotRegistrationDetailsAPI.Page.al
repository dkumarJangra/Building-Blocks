page 50405 "Plot Registration Details API"
{
    PageType = API;

    APIVersion = 'v2.0';
    APIGroup = 'PowerBI';
    APIPublisher = 'Alletec';

    EntityCaption = 'PlotRegistrationDetailsAPI';
    EntitySetCaption = 'PlotRegistrationDetailsAPI';
    EntitySetName = 'PlotRegistrationDetailsAPI';
    EntityName = 'PlotRegistrationDetailsAPI';


    ODataKeyFields = SystemID;
    SourceTable = "Plot Registration Details";

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
                field(customerNo; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(unitCode; Rec."Unit Code")
                {
                    Caption = 'Unit Code';
                }
                field(registrationDate; Rec."Registration Date")
                {
                    Caption = 'Registration Date';
                }
                field(regOffice; Rec."Reg. Office")
                {
                    Caption = 'Reg. Office';
                }
                field(registeredOfficeName; Rec."Registered/Office Name")
                {
                    Caption = 'RegisteredOffice Name';
                }
                field(registrationInFavourOf; Rec."Registration In Favour Of")
                {
                    Caption = 'Registration In Favour Of';
                }
                field(regAddress; Rec."Reg. Address")
                {
                    Caption = 'Reg. Address';
                }
                field(registeredCity; Rec."Registered City")
                {
                    Caption = 'Registered City';
                }
                field(fatherHusbandName; Rec."Father/Husband Name")
                {
                    Caption = 'Father/Husband Name';
                }
                field(zipCode; Rec."Zip Code")
                {
                    Caption = 'Zip Code';
                }
                field(shortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Shortcut Dimension 1 Code';
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