table 97831 "Travel Setup Header"
{
    DataPerCompany = false;
    LookupPageID = "Travel Setup List";

    fields
    {
        field(1; "Associate Code"; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
                IF "Associate Code" <> '' THEN BEGIN
                    IF Vend.GET("Associate Code") THEN
                        "Associate Name" := Vend.Name;
                END ELSE
                    "Associate Name" := '';
            end;
        }
        field(2; "Effective Date"; Date)
        {
            Editable = true;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
                TESTFIELD("End Date", 0D);

                TravelHeader.RESET;
                TravelHeader.SETCURRENTKEY("Top Person");
                TravelHeader.SETRANGE("Top Person", "Associate Code");
                IF TravelHeader.FINDSET THEN
                    REPEAT
                        IF TravelHeader."End Date" <> 0D THEN BEGIN
                            IF TravelHeader."End Date" < "Effective Date" THEN
                                ERROR('TA Setup Date overlap');
                        END;
                    UNTIL TravelHeader.NEXT = 0;
            end;
        }
        field(3; "Associate Name"; Text[60])
        {
        }
        field(4; Status; Option)
        {
            OptionCaption = 'Open,In-Active,Released';
            OptionMembers = Open,"In-Active",Released;
        }
        field(5; "End Date"; Date)
        {
            Description = 'BBG1.2 201213';
            Editable = false;

            trigger OnValidate()
            begin
                IF "End Date" < "Effective Date" THEN
                    ERROR('End Date can not be less than Start Date');

                TravelSetupLine.RESET;
                TravelSetupLine.SETRANGE("Associate Code", "Associate Code");
                TravelSetupLine.SETRANGE("Effective Date", "Effective Date");
                IF TravelSetupLine.FINDSET THEN
                    REPEAT
                        TravelSetupLine."End Date" := "End Date";
                        TravelSetupLine.MODIFY;
                    UNTIL TravelSetupLine.NEXT = 0;
            end;
        }
        field(6; "Creation Date"; Date)
        {

            trigger OnValidate()
            begin
                "Creation Date" := TODAY;
            end;
        }
    }

    keys
    {
        key(Key1; "Associate Code", "Effective Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF (Status = Status::"In-Active") OR (Status = Status::Released) THEN
            ERROR(TEXT50002);

        TravelSetupLine.RESET;
        TravelSetupLine.SETRANGE("Associate Code", "Associate Code");
        TravelSetupLine.SETRANGE("Effective Date", "Effective Date");
        IF TravelSetupLine.FINDSET THEN
            TravelSetupLine.DELETEALL;
    end;

    trigger OnInsert()
    begin
        CheckDuplicate(Rec);
        //TESTFIELD(Status,Status::Open);
    end;

    var
        Item: Record Item;
        Vend: Record Vendor;
        RespCenter: Record "Responsibility Center 1";
        TEXT50000: Label 'Travel with %1 status already exist. ';
        TEXT50001: Label 'Details of Released Travel cannot be modified.';
        TEXT50002: Label 'You cannot delete from in-active or release Travel.  ';
        TEXT50005: Label 'There already exist Travel with these details. ';
        TSetupHdr: Record "Travel Setup Header";
        TravelSetupLine: Record "Travel Setup Line New";
        TravelHeader: Record "Travel Header";


    procedure CheckDuplicate(TravelSetupHeader: Record "Travel Setup Header")
    begin
        TSetupHdr.RESET;
        TSetupHdr.SETRANGE("Effective Date", TravelSetupHeader."Effective Date");
        TSetupHdr.SETRANGE("Associate Code", TravelSetupHeader."Associate Code");
        IF TSetupHdr.FINDFIRST THEN
            ERROR(TEXT50005);
    end;
}

