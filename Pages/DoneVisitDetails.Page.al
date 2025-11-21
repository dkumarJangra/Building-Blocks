page 60717 "Done Visit Details"
{
    Caption = 'Visit Details';
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Customer Visit Schedule Detail";
    SourceTableView = WHERE("Visit Status" = FILTER(Done));
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
                field("Visit Status"; Rec."Visit Status")
                {
                }
                field("Visit Type"; Rec."Visit Type")
                {
                }
                field("Visit Date"; Rec."Visit Date")
                {
                }
                field("Visit Time"; Rec."Visit Time")
                {
                }
                field("Image Path"; Rec."Image Path")
                {
                }
                field("View Images"; Rec."View Images")
                {
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    var
                        filetransferCU: Codeunit "File Transfer";
                    begin
                        Clear(filetransferCU);
                        filetransferCU.JagratiExportFile('https://epc.bbgindia.com:44389/Uploaded/DocPostCRMVisit/', Rec."Image Path");
                    end;
                }
                field("Schedule Date"; Rec."Schedule Date")
                {
                }
                field("Schedule Time"; Rec."Schedule Time")
                {
                }
                field(Comments; Rec.Comments)
                {
                }
            }
        }
    }

    actions
    {
    }
}

