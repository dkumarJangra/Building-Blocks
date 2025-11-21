page 50392 "Associate Visit Schedule List"
{
    Caption = 'Associate Visit Schedule List';
    PageType = List;
    SourceTable = "Customer Visit Schedule Detail";
    DeleteAllowed = False;
    ModifyAllowed = False;

    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Schedule ID"; Rec."Schedule ID")
                {
                }
                field("Customer Lead ID"; Rec."Customer Lead ID")
                {
                }
                field("Associate ID"; Rec."Associate ID")
                {
                }
                field("Schedule Date"; Rec."Schedule Date")
                {
                }
                field("Visit Status"; Rec."Visit Status")
                {
                }
                field("Visit Type"; Rec."Visit Type")
                {
                }
                field("Visit Date"; Rec."Visit Date")
                {
                }
                field(Comments; Rec.Comments)
                {
                }
                field("Image Path"; Rec."Image Path")
                {
                }
                field("Schedule Time"; Rec."Schedule Time")
                {
                }
                field("Visit Time"; Rec."Visit Time")
                {
                }
                field("visitAddress"; Rec."visitAddress")
                {
                }
                field("Longitude"; Rec."Longitude")
                {
                }
                field("Latitude"; Rec."Latitude")
                {
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Show Image")
            {


                trigger OnAction()
                var
                    FileTransferCu: Codeunit "File Transfer";
                begin

                    Clear(FileTransferCu);
                    FileTransferCu.JagratiExportFile('https://epc.bbgindia.com:44389/Uploaded/DocPostCRMVisit/', Rec."Image Path");
                end;
            }
        }
    }

    var
        Document: Record Document;
        ApprovedRequestsList: Page "Approved Requests List";
}

