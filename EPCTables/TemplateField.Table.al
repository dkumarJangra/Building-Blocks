table 97771 "Template Field"
{
    // *** Matriks Doc Version 3 ***
    // By Tim Ahrentl¢v for Matriks A/S.
    // Visit www.matriks.com for news and updates.
    // 
    // 3.04 (2005.10.23):
    // Removal of unecessary call to a calcfield that requires a more elaboate security role setup.
    // 
    // 3.03 (2004.06.17):
    // Bugfix in RefreshTemplate function's while loop that did not process the last field.
    // 
    // 3.02 (2003.07.25):
    // RefreshTemplate() parameter change to facillitate special templates.
    // Special template logic added to RefreshTemplate();
    // 
    // 3.01 (2003.07.01):
    // New function "CloneTemplate" created.

    Caption = 'Template Field';

    fields
    {
        field(1; "Template Name"; Code[20])
        {
            Caption = 'Template Name';
            Editable = false;
            TableRelation = Document."No." WHERE("Document Type" = CONST(Template));
        }
        field(2; "Field Index"; Integer)
        {
            Caption = 'Field Index';
        }
        field(3; "Field No"; Integer)
        {
            Caption = 'Field No.';
        }
        field(4; "Field Caption"; Text[128])
        {
            Caption = 'Field Caption';
        }
        field(7; RelationTableNo; Integer)
        {
            Caption = 'RelationTableNo';
        }
        field(8; RelationTableFieldNo; Integer)
        {
            Caption = 'RelationTableFieldNo';
        }
        field(9; Active; Boolean)
        {
            Caption = 'Active';
        }
        field(10; "Use description"; Boolean)
        {
            Caption = 'Use Description';

            trigger OnValidate()
            begin
                IF RelationTableNo = 0 THEN
                    "Use description" := FALSE;
            end;
        }
    }

    keys
    {
        key(Key1; "Template Name", "Field Index")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        FromTmplField: Record "Template Field";
        ToTmplField: Record "Template Field";


    procedure RefreshTemplate(var TemplateRec: Record Document; WithDelete: Boolean)
    var
        OK: Boolean;
        i: Integer;
        "Field": Record Field;
        TemplateField: Record "Template Field";
        Template: Record Document;
        TableRecord: RecordRef;
        TableField: FieldRef;
        FCLS: Text[20];
        Names: array[100] of Text[128];
    begin
        /*
        IF WithDelete THEN BEGIN
          TemplateField.SETRANGE("Template Name", TemplateRec."No." );
          TemplateField.DELETEALL;
        END;
        
        IF (TemplateRec."Table No." = 0) AND (NOT TemplateRec.Special) THEN EXIT;
        
        IF NOT TemplateRec.Special THEN BEGIN
        
          // Open instance of a table with the tableno from document record
          TableRecord.OPEN(TemplateRec."Table No.");
        
          i := 1;
          // Loop over fields in record
          WHILE i <= TableRecord.FIELDCOUNT DO BEGIN
        
            // Prepare Record
            CLEAR(TemplateField);
        
            // Get field based on index
            TableField := TableRecord.FIELDINDEX(i);
        
            // On
            FCLS := FORMAT(TableField.CLASS);
            IF (FCLS <> 'FlowFilter') AND TableField.ACTIVE THEN BEGIN
        
              TemplateField."Template Name" := TemplateRec."No.";
              TemplateField."Field Index" := i;
              TemplateField."Field No" := TableField.NUMBER;
              TemplateField."Field Caption" := TableField.CAPTION;
              TemplateField.Active := FALSE;
        
              IF Field.GET(TemplateRec."Table No.", TableField.NUMBER) THEN BEGIN
                TemplateField.RelationTableNo := Field.RelationTableNo;
                TemplateField.RelationTableFieldNo := Field.RelationFieldNo;
              END;
        
              OK := TemplateField.INSERT;
            END;
        
            i := i + 1;
          END;
        
          // Close table instance
          TableRecord.CLOSE();
        
        END ELSE BEGIN
          FOR i := 1 TO SpclTmplMgt.GetNames(TemplateRec, Names) DO BEGIN
            // Prepare Record
            CLEAR(TemplateField);
        
            TemplateField."Template Name" := TemplateRec."No.";
            TemplateField."Field Index" := i;
            TemplateField."Field No" := i;
            TemplateField."Field Caption" := Names[i];
            TemplateField.Active := FALSE;
        
            OK := TemplateField.INSERT;
          END;
        END;
        */

    end;


    procedure CloneTemplate(FromName: Code[20]; ToName: Code[20])
    var
        FromTmplField: Record "Template Field";
        ToTmplField: Record "Template Field";
    begin
        FromTmplField.SETRANGE("Template Name", FromName);
        IF FromTmplField.FIND('-') THEN
            REPEAT
                ToTmplField.COPY(FromTmplField);
                ToTmplField."Template Name" := ToName;
                ToTmplField.INSERT;
            UNTIL FromTmplField.NEXT = 0;
    end;
}

