page 50176 "Event Details"
{
    PageType = List;
    SourceTable = "Event Datails";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
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
                field("Event Status"; Rec."Event Status")
                {
                }
                field("Event Radius"; Rec."Event Radius")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Create Entry")
            {
                Image = New;
                Promoted = true;

                trigger OnAction()
                var
                    LastEntryNo: Integer;
                    NewEntryNo: Integer;
                    LastEventID: Integer;
                    NewEventID: Integer;
                    FromEntryNo: Integer;
                    ToEntryNo: Integer;
                    CustomFunctions: Codeunit "Custom Functions";
                begin
                    IF NOT CONFIRM('Do you want to create entries?', FALSE) THEN
                        EXIT;


                    CustomFunctions.EventEntriesCreation;  //260523 Code added

                    //260523 Code comment start
                    /*
                    EventDatails.RESET;
                    IF EventDatails.FINDLAST THEN
                      BEGIN
                        LastEntryNo := EventDatails."Entry No.";
                        LastEventID := EventDatails."Event ID";
                      END;
                    
                    NewEntryNo := LastEntryNo +1;
                    NewEventID := LastEventID +1;
                    
                    EventDatails.RESET;
                    EventDatails.SETRANGE("Event Status",EventDatails."Event Status"::Active);
                    IF EventDatails.FINDFIRST THEN
                      FromEntryNo := EventDatails."Entry No.";
                    
                    EventDatails.RESET;
                    EventDatails.SETRANGE("Event Status",EventDatails."Event Status"::Active);
                    IF EventDatails.FINDLAST THEN
                      ToEntryNo := EventDatails."Entry No.";
                    
                    OldEventDatails.RESET;
                    OldEventDatails.SETRANGE("Entry No.",FromEntryNo,ToEntryNo);
                    OldEventDatails.SETRANGE("Event Status",OldEventDatails."Event Status"::Active);
                    IF OldEventDatails.FINDFIRST THEN
                      REPEAT
                        NewEventDatails.INIT;
                        NewEventDatails.TRANSFERFIELDS(OldEventDatails);
                        NewEventDatails."Entry No." := NewEntryNo;
                        NewEventDatails."Event ID" := NewEventID;
                        NewEventDatails."Event Date" := TODAY;
                        NewEventDatails.INSERT(TRUE);
                        OldEventDatails."Event Status":= OldEventDatails."Event Status"::"In-Active";
                        OldEventDatails.MODIFY;
                        COMMIT;
                        NewEntryNo := NewEntryNo+1;
                        NewEventID := NewEventID+1;
                      UNTIL OldEventDatails.NEXT =0;
                    */

                    //260523 Code comment END;

                end;
            }
        }
    }

    var
        EventDatails: Record "Event Datails";
        OldEventDatails: Record "Event Datails";
        NewEventDatails: Record "Event Datails";
}

