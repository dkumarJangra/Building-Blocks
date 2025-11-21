table 97742 "Master Mandatory Setup"
{

    fields
    {
        field(1; "Table ID"; Integer)
        {

            trigger OnLookup()
            begin
                CLEAR(FrmObject);
                Object.RESET;
                Object.SETRANGE("Object Type", Object."Object Type"::Table);
                SetFilters;
                FrmObject.SETTABLEVIEW(Object);
                FrmObject.LOOKUPMODE := TRUE;
                IF FrmObject.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    FrmObject.GETRECORD(Object);
                    VALIDATE("Table ID", Object."Object ID");
                END
            end;

            trigger OnValidate()
            begin

                IF "Table ID" <> 0 THEN BEGIN
                    Object.RESET;
                    Object.SETRANGE("Object Type", Object."Object Type"::Table);
                    SetFilters;
                    Object.SETRANGE("Object ID", "Table ID");
                    Object.FIND('-');
                    "Table Name" := Object."Object Name";
                    COMMIT;
                END;
            end;
        }
        field(2; "Table Name"; Text[50])
        {
            Editable = false;
        }
        field(3; "Field ID"; Integer)
        {
            TableRelation = Field."No." WHERE(TableNo = FIELD("Table ID"));

            trigger OnLookup()
            begin
                /*
                CLEAR(frmField);
                Field.RESET;
                Field.SETRANGE(TableNo, "Table ID");
                frmField.SETTABLEVIEW(Field);
                frmField.LOOKUPMODE := TRUE;
                IF frmField.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    frmField.GETRECORD(Field);
                    VALIDATE("Field ID", Field."No.");
                END;
                */
            end;

            trigger OnValidate()
            begin
                IF "Table ID" <> 0 THEN BEGIN
                    Field.RESET;
                    Field.SETRANGE(TableNo, "Table ID");
                    Field.SETRANGE(Field."No.", "Field ID");
                    IF Field.FIND('-') THEN
                        "Field Name" := Field.FieldName
                    ELSE
                        "Field Name" := '';
                END;
            end;
        }
        field(4; "Field Name"; Text[50])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Table ID", "Field ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        "Object": Record AllObj;
        "Field": Record Field;
        FrmObject: Page Objects;
        //frmField: Page 6218;
        ID: Integer;


    procedure SetFilters()
    begin
        IF "Table ID" IN [0, 18, 23, 27, 5050] THEN
            Object.SETFILTER("Object ID", '%1|%2|%3|%4',
            18, 23, 27, 5050, 50007)
        ELSE
            ERROR('You can not make fields mandatory for table id %1', "Table ID");
    end;


    procedure MasterValidate(FromTable: RecordRef)
    var
        MandFields: Record "Master Mandatory Setup";
        RefRec: RecordRef;
        RefField: FieldRef;
        ErrorFound: Boolean;
        ErrorFields: array[100] of Text[50];
        ErrCounter: Integer;
        ErrMsg: Text[1024];
        ErrMsgCounter: Integer;
        MsgCounter: Integer;
    begin
        //Checking for Mandatory Fields
        MandFields.RESET;
        RefRec := FromTable;
        MandFields.SETRANGE(MandFields."Table ID", RefRec.NUMBER);
        IF MandFields.FIND('-') THEN
            REPEAT
                ErrorFound := FALSE;
                RefField := RefRec.FIELD(MandFields."Field ID");
                IF (FORMAT(RefField.VALUE) = '') OR (FORMAT(RefField.VALUE) = '0') THEN
                    ErrorFound := TRUE;
                IF ErrorFound THEN BEGIN
                    ErrCounter += 1;
                    ErrorFields[ErrCounter] := RefField.NAME;
                END;
            UNTIL MandFields.NEXT = 0;
        //Generating Error

        IF ErrorFields[1] <> '' THEN BEGIN
            MsgCounter := 0;
            ErrMsgCounter := 0;
            ErrMsg := 'Error in following fields :';
            REPEAT
                MsgCounter += 1;
                ErrMsgCounter += 1;
                IF STRLEN(ErrMsg + ErrorFields[ErrMsgCounter]) < 1015 THEN
                    ErrMsg := ErrMsg + '\' + ErrorFields[ErrMsgCounter]
                ELSE
                    ErrMsg := ErrMsg;
            UNTIL MsgCounter = ErrCounter;
            ERROR(ErrMsg);
        END;
    end;


    procedure ColourFields(TableId: Integer; FieldId: Integer): Boolean
    var
        MandatoryFlds: Record "Master Mandatory Setup";
        ExitBoolean: Boolean;
    begin
        ExitBoolean := FALSE;
        MandatoryFlds.RESET;
        MandatoryFlds.SETRANGE(MandatoryFlds."Table ID", TableId);
        MandatoryFlds.SETRANGE(MandatoryFlds."Field ID", FieldId);
        IF MandatoryFlds.FIND('-') THEN
            ExitBoolean := TRUE
        ELSE
            ExitBoolean := FALSE;

        EXIT(ExitBoolean);
    end;
}

