page 50161 "Land Agreement Check List"
{
    AutoSplitKey = true;
    PageType = List;
    SourceTable = "Land Agreement Check List";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("Description 2"; Rec."Description 2")
                {
                    Editable = false;
                }
                field("Document Uploaded"; Rec."Document Uploaded")
                {
                }
                field("Submission Date"; Rec."Submission Date")
                {
                }
                field("Approval Date"; Rec."Approval Date")
                {
                }
                field("Assigned To"; Rec."Assigned To")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Insert Document Check List")
            {
                Promoted = true;

                trigger OnAction()
                var
                    ExistLandMasterCheckList: Record "Land Agreement Check List";
                begin
                    IF CONFIRM('Do you want to insert Check List') THEN BEGIN
                        LandMasterCheckList.RESET;
                        LandMasterCheckList.SETRANGE("Master Setup", TRUE);
                        IF LandMasterCheckList.FINDSET THEN BEGIN
                            REPEAT
                                IF NOT ExistLandMasterCheckList.GET(Rec."Document No.", LandMasterCheckList."Line No.") THEN BEGIN
                                    NewLandMasterCheckList.INIT;
                                    NewLandMasterCheckList.TRANSFERFIELDS(LandMasterCheckList);
                                    NewLandMasterCheckList."Document No." := Rec."Document No.";
                                    NewLandMasterCheckList."Master Setup" := FALSE;
                                    NewLandMasterCheckList."Table No." := 50054;
                                    NewLandMasterCheckList."From Land Master" := TRUE;
                                    NewLandMasterCheckList.INSERT;
                                END;
                            UNTIL LandMasterCheckList.NEXT = 0;
                        END ELSE
                            ERROR('Check list master not found');
                    END ELSE
                        ERROR('Nothing to Insert');
                end;
            }
        }
    }

    var
        LandMasterCheckList: Record "Land Agreement Check List";
        NewLandMasterCheckList: Record "Land Agreement Check List";
}

