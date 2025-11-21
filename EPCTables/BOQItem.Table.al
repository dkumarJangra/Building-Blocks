table 97744 "BOQ Item"
{
    // ALLESP BCL0011 10-07-2007: New Table Created to store BOQ Item related to a Project
    // ALLESS BCL 10-09-2007: Added Export To Excel Function to the Table
    // ALLEAA - New Field Added
    // ALLERP KRN0008 18-08-2010: Field 27 and 28 has been added

    DrillDownPageID = "BOQ Item List";
    LookupPageID = "BOQ Item List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'BOQ No.';
        }
        field(2; Description; Text[50])
        {

            trigger OnValidate()
            begin
                "Seach Name" := Description;
            end;
        }
        field(3; "Description 2"; Text[50])
        {
        }
        field(4; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            Editable = true;

            trigger OnValidate()
            begin
                "Total Price" := "Unit Price" * Quantity;
            end;
        }
        field(5; "Base UOM"; Code[20])
        {
            TableRelation = "Unit of Measure";
        }
        field(6; "Seach Name"; Text[50])
        {
        }
        field(7; "Brick Std Consumption"; Decimal)
        {
        }
        field(8; "Cement Std Consumption"; Decimal)
        {
        }
        field(9; "Steel Std Consumption"; Decimal)
        {
        }
        field(10; Material; Decimal)
        {

            trigger OnValidate()
            begin
                CalculateRate;
            end;
        }
        field(11; Labor; Decimal)
        {

            trigger OnValidate()
            begin
                CalculateRate;
            end;
        }
        field(12; Equipment; Decimal)
        {

            trigger OnValidate()
            begin
                CalculateRate;
            end;
        }
        field(13; Other; Decimal)
        {

            trigger OnValidate()
            begin
                CalculateRate;
            end;
        }
        field(14; "OverHead %"; Decimal)
        {

            trigger OnValidate()
            begin
                CalculateRate;
            end;
        }
        field(15; Quantity; Decimal)
        {

            trigger OnValidate()
            begin
                "Total Price" := "Unit Price" * Quantity;
                "Total Cost" := "Unit Cost" * Quantity;
            end;
        }
        field(16; "Project Code"; Code[20])
        {
            TableRelation = Job;
        }
        field(17; "Entry No."; Integer)
        {
        }
        field(18; Type; Option)
        {
            OptionCaption = ' ,,G/L Account';
            OptionMembers = " ",,"G/L Account";
        }
        field(19; "Total Price"; Decimal)
        {
        }
        field(20; "Unit Cost"; Decimal)
        {

            trigger OnValidate()
            begin
                "Total Cost" := "Unit Cost" * Quantity;
            end;
        }
        field(21; "Total Cost"; Decimal)
        {
        }
        field(22; "Value Type"; Option)
        {
            Caption = 'Dimension Value Type';
            OptionCaption = 'Posting,Heading,Total,Begin-Total,End-Total';
            OptionMembers = Posting,Heading,Total,"Begin-Total","End-Total";
        }
        field(23; "Phase Code"; Code[20])
        {
            //TableRelation = Table161;
        }
        field(24; Indentation; Integer)
        {
        }
        field(25; "BOQ Type"; Option)
        {
            Caption = 'BOQ Type';
            Description = 'ALLEAA';
            Editable = false;
            OptionCaption = ' ,Sale,Purchase';
            OptionMembers = " ",Sale,Purchase;
        }
        field(26; "G/L Account"; Code[20])
        {
        }
        field(27; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(28; "BOQ Tender Rate"; Decimal)
        {
            Caption = 'Tender Rate';
            Description = 'ALLERP KRN0008 18-08-2010:';
        }
        field(29; "BOQ Tender Amount"; Decimal)
        {
            Caption = 'Premium/Discount Amount';
            Description = 'ALLERP KRN0008 18-08-2010:';
        }
        field(50054; "BOQ Job Type"; Option)
        {
            OptionCaption = 'Service,Supply,Supply & Service';
            OptionMembers = Service,Supply,"Supply & Service";
        }
        field(90032; "BOQ Rate"; Decimal)
        {
        }
        field(90033; "Percent Change"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Project Code", "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Unit Price")
        {
        }
        key(Key3; "Seach Name")
        {
        }
        key(Key4; "Base UOM", "Unit Price")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        ExtendTextHdr.RESET;
        IF ExtendTextHdr.GET(ExtendTextHdr."Table Name"::"BOQ Item", "Project Code", '', "Entry No.") THEN
            ExtendTextHdr.DELETE(TRUE);
    end;

    var
        Text50004: Label 'Indenting  @1@@@@@@@@@@@@@@@@@@';
        Text50005: Label 'End-Total %1 is missing a matching Begin-Total. %2';
        ExtendTextHdr: Record "Extended Text Header";
        ExcelBuf: Record "Excel Buffer" temporary;
        NotDecimalValues: Boolean;
        i: Integer;


    procedure CalculateRate()
    begin
        //Rate := (Material+Labor+Equipment+Other)*(1+("OverHead %"/100));
    end;


    procedure Indent(pCode: Code[20])
    var
        NoOfDimVals: Integer;
        Progress: Integer;
        BOQ: Record "BOQ Item";
        Window: Dialog;
        i: Integer;
    begin
        //ALLESP BCL0011 10-07-2007 Start:
        BOQ.SETRANGE("Project Code", pCode);
        Window.OPEN(Text50004);
        NoOfDimVals := BOQ.COUNTAPPROX;
        IF NoOfDimVals = 0 THEN
            NoOfDimVals := 1;
        IF BOQ.FIND('-') THEN
            REPEAT
                Progress := Progress + 1;
                Window.UPDATE(1, 10000 * Progress DIV NoOfDimVals);
                IF BOQ."Value Type" = BOQ."Value Type"::"End-Total" THEN BEGIN
                    IF i < 1 THEN
                        ERROR(Text50005, BOQ.Code, Rec."Entry No.");
                    i := i - 1;
                END;
                BOQ.Indentation := i;
                BOQ.MODIFY;
                IF BOQ."Value Type" = BOQ."Value Type"::"Begin-Total" THEN
                    i := i + 1;
            UNTIL BOQ.NEXT = 0;
        Window.CLOSE;
        //ALLESP BCL0011 10-07-2007 End:
    end;


    procedure ExportToEx()
    begin
        //For Export to Excel
        i := 1;

        ExcelBuf.DELETEALL;
        CLEAR(ExcelBuf);

        IF i <= 0 THEN BEGIN
            i := 0;
            i := i + 1;
        END;


        //For printing the Headings
        EnterCell(i, 1, 'Project Code', TRUE, FALSE);
        EnterCell(i, 2, 'Entry No.', TRUE, FALSE);
        EnterCell(i, 3, 'Type', TRUE, FALSE);
        EnterCell(i, 4, 'BOQ No.', TRUE, FALSE);
        EnterCell(i, 5, 'Description', TRUE, FALSE);

        IF "Description 2" <> '' THEN BEGIN
            i := i + 1;
            EnterCell(i, 5, 'Description 2', TRUE, FALSE);
            // i:=i-1;
        END
        ELSE BEGIN
            EnterCell(i, 6, 'Quantity', TRUE, FALSE);
            EnterCell(i, 7, 'Unit Cost', TRUE, FALSE);
            EnterCell(i, 8, 'Unit Price', TRUE, FALSE);
            EnterCell(i, 9, 'Total Cost', TRUE, FALSE);
            EnterCell(i, 10, 'Total Price', TRUE, FALSE);
            EnterCell(i, 11, 'BASE UOM', TRUE, FALSE);
            i := i + 2;
        END;


        //For printing the Data from the table
        Rec.SETRANGE(Rec."Project Code");
        IF Rec.FIND('-') THEN
            REPEAT

                EnterCell(i, 1, FORMAT("Project Code"), FALSE, FALSE);
                EnterCell(i, 2, FORMAT("Entry No."), FALSE, FALSE);
                EnterCell(i, 3, FORMAT(Type), FALSE, FALSE);
                EnterCell(i, 4, FORMAT(Code), FALSE, FALSE);
                EnterCell(i, 5, FORMAT(Description), FALSE, FALSE);

                IF "Description 2" <> '' THEN BEGIN
                    i := i + 1;
                    EnterCell(i, 6, FORMAT("Description 2"), TRUE, FALSE);
                END
                ELSE BEGIN
                    i := i + 1;
                    EnterCell(i, 6, FORMAT(Quantity), FALSE, FALSE);
                    EnterCell(i, 7, FORMAT("Unit Cost"), FALSE, FALSE);
                    EnterCell(i, 8, FORMAT("Unit Price"), FALSE, FALSE);
                    EnterCell(i, 9, FORMAT("Total Cost"), FALSE, FALSE);
                    EnterCell(i, 10, FORMAT("Total Price"), FALSE, FALSE);
                    EnterCell(i, 11, FORMAT("Base UOM"), FALSE, FALSE);
                    i := i + 1;
                END;

            UNTIL (Rec.NEXT = 0);



        ExcelBuf.CreateNewBook('BOQ ITEM LIST');
        //ExcelBuf.CreateSheet('BOQ ITEM LIST','BOQ ITEM LIST',COMPANYNAME,USERID);
        //ExcelBuf.GiveUserControl; //Not Found 
        CLEAR(ExcelBuf);
    end;


    procedure EnterCell(RowNo: Integer; ColumnNo: Integer; CellValue: Text[250]; Bold: Boolean; UnderLine: Boolean)
    begin
        //For Export to Excel
        ExcelBuf.INIT;
        IF NotDecimalValues THEN
            ExcelBuf.NumberFormat := '0.000';
        ExcelBuf.VALIDATE("Row No.", RowNo);
        ExcelBuf.VALIDATE("Column No.", ColumnNo);
        ExcelBuf."Cell Value as Text" := CellValue;
        ExcelBuf.Formula := '';
        ExcelBuf.Bold := Bold;
        ExcelBuf.Underline := UnderLine;
        ExcelBuf.INSERT;
    end;
}

