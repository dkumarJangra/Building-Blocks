page 50177 "Associate Event Details"
{
    Editable = true;
    PageType = List;
    SourceTable = "Associate Event Datails";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID"; Rec."User ID")
                {
                }
                field("Event Name"; Rec."Event Name")
                {
                }
                field("Event Date"; Rec."Event Date")
                {
                }
                field("Event ID"; Rec."Event ID")
                {
                }
                field("Event Long"; Rec."Event Long")
                {
                }
                field("Event Latitude"; Rec."Event Latitude")
                {
                }
                field("Associate ID"; Rec."Associate ID")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("Team Code"; Rec."Team Code")
                {
                }
                field("Leader Code"; Rec."Leader Code")
                {
                }
                field("Sub Team Code"; Rec."Sub Team Code")
                {
                }
                field("Sub Team Name"; Rec."Sub Team Name")
                {
                }
                field("Event Time In"; Rec."Event Time In")
                {
                }
                field("Event Time Out"; Rec."Event Time Out")
                {
                }
                field("No. of Customers"; Rec."No. of Customers")
                {
                }
                field("Check In Image Name"; Rec."Check In Image Name")
                {
                    Editable = false;
                }
                field("Check Out Image Name"; Rec."Check Out Image Name")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Show Check In Images")
            {
                Caption = 'Show Check In Images';
                Image = showdocument;

                trigger OnAction()
                var
                    UnitSetup: Record "Unit Setup";
                    BBGSetups: Record "BBG Setups";
                    FileTranferCu: Codeunit "File Transfer";
                begin

                    BBGSetups.GET;  //ALLE 230823  Added
                    BBGSetups.TESTFIELD("Event Image Path");   //ALLE 230823  Added

                    Clear(FileTranferCu);  //040325 Added new code
                    FileTranferCu.JagratiExportFile(BBGSetups."Event Image Path", Rec."Check In Image Name");  //040325 Added new code

                    // IF FILE.EXISTS(BBGSetups."Event Image Path" + Rec."Check In Image Name") THEN     //ALLE 230823  Added
                    //     HYPERLINK(BBGSetups."Event Image Path" + Rec."Check In Image Name")
                    // ELSE
                    //     MESSAGE('Image not found');


                end;
            }
            action("Show Check Out Images")
            {
                Caption = 'Show Check Out Images';
                Image = showdocument;

                trigger OnAction()
                var
                    UnitSetup: Record "Unit Setup";
                    BBGSetups: Record "BBG Setups";
                    FileTranferCu: Codeunit "File Transfer";
                begin

                    BBGSetups.GET;  //ALLE 230823  Added
                    BBGSetups.TESTFIELD("Event Image Path");   //ALLE 230823  Added
                    Clear(FileTranferCu);  //040325 Added new code
                    FileTranferCu.JagratiExportFile(BBGSetups."Event Image Path", Rec."Check Out Image Name");  //040325 Added new code


                    // IF FILE.EXISTS(BBGSetups."Event Image Path" + Rec."Check Out Image Name") THEN     //ALLE 230823  Added
                    //     HYPERLINK(BBGSetups."Event Image Path" + Rec."Check Out Image Name")
                    // ELSE
                    //     MESSAGE('Image not found');
                end;
            }
        }
    }
}

