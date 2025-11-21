tableextension 50079 "BBG Excel Buffer Ext" extends "Excel Buffer"
{
    fields
    {
        // Add changes to table fields here
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
        RunFromNas: Boolean;
        UnitSetup: Record "Unit Setup";
        ExcelBufferDialogMngt_1: Codeunit "Excel Buffer Dialog Mngt_1";



    PROCEDURE CreateBookAndSaveExcel(FileName: Text; SheetName: Text[250]; ReportHeader: Text; CompanyName2: Text; UserID2: Text; ServerFileName: Text);
    BEGIN
        //CreateBook(FileName, SheetName);
        NewWriteSheet(ReportHeader, CompanyName2, UserID2);
        CloseBook;
        IF NOT RunFromNas THEN
            SaveExcel
        ELSE
            MoveExcelInServer(ServerFileName);
    END;

    LOCAL PROCEDURE SaveExcel()
    VAR
        FileNameClient: Text;
    BEGIN
        UnitSetup.GET;
        // IF OpenUsingDocumentService('') THEN
        //     EXIT;

        // IF NOT PreOpenExcel THEN
        //     EXIT;

        // FileNameClient := FileManagement.DownloadTempFile(FileNameServer);
        // FileNameClient := FileManagement.MoveAndRenameClientFile(FileNameClient, 'Book1.xlsx', UnitSetup."Excel File Save Path");
    END;

    PROCEDURE SetRunViaNAS(NAS: Boolean);
    BEGIN
        RunFromNas := NAS;
    END;

    LOCAL PROCEDURE MoveExcelInServer(ServerFileName: Text);
    VAR
    // SmtpSetup: Record 409;
    BEGIN
        UnitSetup.GET;
        // IF OpenUsingDocumentService('') THEN
        //     EXIT;
        // FileManagement.CopyServerFile(FileNameServer, FORMAT(UnitSetup."Excel File Save Path") + ServerFileName, TRUE);
    END;

    PROCEDURE NewWriteSheet(ReportHeader: Text; CompanyName2: Text; UserID2: Text);
    VAR
        ExcelBufferDialogMgt: Codeunit "Excel Buffer Dialog Management";
        //OrientationValues: DotNet "'DocumentFormat.OpenXml, Version=2.5.5631.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.DocumentFormat.OpenXml.Spreadsheet.OrientationValues";
        CRLF: Char;
        RecNo: Integer;
        InfoRecNo: Integer;
        TotalRecNo: Integer;
        LastUpdate: DateTime;
    BEGIN
        // LastUpdate := CURRENTDATETIME;
        // //ExcelBufferDialogMgt.Open(Text005);
        // ExcelBufferDialogMngt_1.Open(Text005); //New code

        // CRLF := 10;
        // RecNo := 1;
        // TotalRecNo := COUNT + InfoExcelBuf.COUNT;
        // RecNo := 0;

        // IF ExcelBookCreated THEN
        //     XlWrkShtWriter := XlWrkBkWriter.AddWorksheet(NewSheetName);

        // XlWrkShtWriter.AddPageSetup(OrientationValues.Landscape, 9); // 9 - default value for Paper Size - A4

        // // commit is required because of the result boolean check of ExcelBufferDialogMgt.RUN
        // COMMIT;

        // IF FINDSET THEN
        //     REPEAT
        //         RecNo := RecNo + 1;
        //         IF NOT NewUpdateProgressDialog(ExcelBufferDialogMngt_1, LastUpdate, RecNo, TotalRecNo) THEN BEGIN
        //             QuitExcel;
        //             ERROR(Text035)
        //         END;
        //         IF Formula = '' THEN
        //             WriteCellValue(Rec)
        //         ELSE
        //             WriteCellFormula(Rec)
        //     UNTIL NEXT = 0;

        // IF ReportHeader <> '' THEN
        //     XlWrkShtWriter.AddHeader(
        //       TRUE,
        //       STRSUBSTNO('%1%2%1%3%4', GetExcelReference(1), ReportHeader, CRLF, CompanyName2));

        // XlWrkShtWriter.AddHeader(
        //   FALSE,
        //   STRSUBSTNO(Text006, GetExcelReference(2), GetExcelReference(3), CRLF, UserID2));

        // IF UseInfoSheet THEN
        //     IF InfoExcelBuf.FINDSET THEN BEGIN
        //         XlWrkShtWriter := XlWrkBkWriter.AddWorksheet(Text023);
        //         REPEAT
        //             InfoRecNo := InfoRecNo + 1;
        //             IF NOT NewUpdateProgressDialog(ExcelBufferDialogMngt_1, LastUpdate, RecNo + InfoRecNo, TotalRecNo) THEN BEGIN
        //                 QuitExcel;
        //                 ERROR(Text035)
        //             END;
        //             IF InfoExcelBuf.Formula = '' THEN
        //                 WriteCellValue(InfoExcelBuf)
        //             ELSE
        //                 WriteCellFormula(InfoExcelBuf)
        //         UNTIL InfoExcelBuf.NEXT = 0;
        //     END;

        // ExcelBufferDialogMngt_1.Close;
    END;

    LOCAL PROCEDURE NewUpdateProgressDialog(VAR ExcelBufferDialogManagement: Codeunit "Excel Buffer Dialog Mngt_1"; VAR LastUpdate: DateTime; CurrentCount: Integer; TotalCount: Integer): Boolean;
    VAR
        CurrentTime: DateTime;
    BEGIN
        // Refresh at 100%, and every second in between 0% to 100%
        // Duration is measured in miliseconds -> 1 sec = 1000 ms
        CurrentTime := CURRENTDATETIME;
        IF (CurrentCount = TotalCount) OR (CurrentTime - LastUpdate >= 1000) THEN BEGIN
            LastUpdate := CurrentTime;
            ExcelBufferDialogManagement.SetProgress(ROUND(CurrentCount / TotalCount * 10000, 1));
            IF NOT ExcelBufferDialogManagement.RUN THEN
                EXIT(FALSE);
        END;

        EXIT(TRUE)
    END;
}