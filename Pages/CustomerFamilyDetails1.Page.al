page 60718 "Customer Family Details_1"
{
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Customer Family Details";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Family Member ID"; Rec."Family Member ID")
                {
                }
                field("Customer Lead ID"; Rec."Customer Lead ID")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("Mobile No."; Rec."Mobile No.")
                {
                }
                field(Address; Rec.Address)
                {
                }
                field("Address 2"; Rec."Address 2")
                {
                }
                field(City; Rec.City)
                {
                }
                field(Gender; Rec.Gender)
                {
                }
                field("Post Code"; Rec."Post Code")
                {
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                }
                field("E-Mail"; Rec."E-Mail")
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
                        FiletransferCu: Codeunit "File Transfer";
                    begin
                        Clear(FiletransferCu);
                        FiletransferCu.JagratiExportFile('https://epc.bbgindia.com:44389/Uploaded/DocPostCRM/', Rec."Image Path");
                    end;
                }
                field(Relation; Rec.Relation)
                {
                }
                field("Associate ID"; Rec."Associate ID")
                {
                }
                field("State code"; Rec."State code")
                {
                }
                field(Age; Rec.Age)
                {
                }
            }
        }
    }

    actions
    {
    }
}

