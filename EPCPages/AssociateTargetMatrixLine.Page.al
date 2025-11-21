page 50292 "Associate Target Matrix Line"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Team Master";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Team Code"; Rec."Team Code")
                {
                }
                field("Total Target Value"; TotalTargetValue)
                {

                    trigger OnDrillDown()
                    begin
                        FilterTargetupdatedEntries.RESET;
                        FilterTargetupdatedEntries.SETRANGE("Team Code", Rec."Team Code");
                        FilterTargetupdatedEntries.SETFILTER("From Date", '>=%1', StartDate);
                        FilterTargetupdatedEntries.SETFILTER("To Date", '<=%1', EndDate);
                        IF AssociateNo <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Associate Code", AssociateNo);
                        IF LeaderCodeFilter <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Leader Code", LeaderCodeFilter);
                        IF FilterTargetupdatedEntries.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Target Submitted from Associat", FilterTargetupdatedEntries);
                    end;
                }
                field(Field1; MATRIX_CellData[1])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[1];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field1Visible;

                    trigger OnDrillDown()
                    begin
                        FilterTargetupdatedEntries.RESET;
                        FilterTargetupdatedEntries.SETRANGE("Team Code", Rec."Team Code");
                        FilterTargetupdatedEntries.SETRANGE("Field Type", ColumnCaptions[1]);
                        FilterTargetupdatedEntries.SETFILTER("From Date", '>=%1', StartDate);
                        FilterTargetupdatedEntries.SETFILTER("To Date", '<=%1', EndDate);
                        IF AssociateNo <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Associate Code", AssociateNo);
                        IF LeaderCodeFilter <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Leader Code", LeaderCodeFilter);
                        IF FilterTargetupdatedEntries.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Target Submitted from Associat", FilterTargetupdatedEntries);
                    end;
                }
                field(Field2; MATRIX_CellData[2])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[2];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field2Visible;

                    trigger OnDrillDown()
                    begin
                        FilterTargetupdatedEntries.RESET;
                        FilterTargetupdatedEntries.SETRANGE("Team Code", Rec."Team Code");
                        FilterTargetupdatedEntries.SETRANGE("Field Type", ColumnCaptions[2]);
                        FilterTargetupdatedEntries.SETFILTER("From Date", '>=%1', StartDate);
                        FilterTargetupdatedEntries.SETFILTER("To Date", '<=%1', EndDate);
                        IF AssociateNo <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Associate Code", AssociateNo);
                        IF LeaderCodeFilter <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Leader Code", LeaderCodeFilter);
                        IF FilterTargetupdatedEntries.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Target Submitted from Associat", FilterTargetupdatedEntries);
                    end;
                }
                field(Field3; MATRIX_CellData[3])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[3];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field3Visible;

                    trigger OnDrillDown()
                    begin
                        FilterTargetupdatedEntries.RESET;
                        FilterTargetupdatedEntries.SETRANGE("Team Code", Rec."Team Code");
                        FilterTargetupdatedEntries.SETRANGE("Field Type", ColumnCaptions[3]);
                        FilterTargetupdatedEntries.SETFILTER("From Date", '>=%1', StartDate);
                        FilterTargetupdatedEntries.SETFILTER("To Date", '<=%1', EndDate);
                        IF AssociateNo <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Associate Code", AssociateNo);
                        IF LeaderCodeFilter <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Leader Code", LeaderCodeFilter);
                        IF FilterTargetupdatedEntries.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Target Submitted from Associat", FilterTargetupdatedEntries);
                    end;
                }
                field(Field4; MATRIX_CellData[4])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[4];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field4Visible;

                    trigger OnDrillDown()
                    begin
                        FilterTargetupdatedEntries.RESET;
                        FilterTargetupdatedEntries.SETRANGE("Team Code", Rec."Team Code");
                        FilterTargetupdatedEntries.SETRANGE("Field Type", ColumnCaptions[4]);
                        FilterTargetupdatedEntries.SETFILTER("From Date", '>=%1', StartDate);
                        FilterTargetupdatedEntries.SETFILTER("To Date", '<=%1', EndDate);
                        IF AssociateNo <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Associate Code", AssociateNo);
                        IF LeaderCodeFilter <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Leader Code", LeaderCodeFilter);
                        IF FilterTargetupdatedEntries.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Target Submitted from Associat", FilterTargetupdatedEntries);
                    end;
                }
                field(Field5; MATRIX_CellData[5])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[5];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field5Visible;

                    trigger OnDrillDown()
                    begin
                        FilterTargetupdatedEntries.RESET;
                        FilterTargetupdatedEntries.SETRANGE("Team Code", Rec."Team Code");
                        FilterTargetupdatedEntries.SETRANGE("Field Type", ColumnCaptions[5]);
                        FilterTargetupdatedEntries.SETFILTER("From Date", '>=%1', StartDate);
                        FilterTargetupdatedEntries.SETFILTER("To Date", '<=%1', EndDate);
                        IF AssociateNo <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Associate Code", AssociateNo);
                        IF LeaderCodeFilter <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Leader Code", LeaderCodeFilter);
                        IF FilterTargetupdatedEntries.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Target Submitted from Associat", FilterTargetupdatedEntries);
                    end;
                }
                field(Field6; MATRIX_CellData[6])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[6];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field6Visible;

                    trigger OnDrillDown()
                    begin
                        FilterTargetupdatedEntries.RESET;
                        FilterTargetupdatedEntries.SETRANGE("Team Code", Rec."Team Code");
                        FilterTargetupdatedEntries.SETRANGE("Field Type", ColumnCaptions[6]);
                        FilterTargetupdatedEntries.SETFILTER("From Date", '>=%1', StartDate);
                        FilterTargetupdatedEntries.SETFILTER("To Date", '<=%1', EndDate);
                        IF AssociateNo <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Associate Code", AssociateNo);
                        IF LeaderCodeFilter <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Leader Code", LeaderCodeFilter);
                        IF FilterTargetupdatedEntries.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Target Submitted from Associat", FilterTargetupdatedEntries);
                    end;
                }
                field(Field7; MATRIX_CellData[7])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[7];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field7Visible;

                    trigger OnDrillDown()
                    begin
                        FilterTargetupdatedEntries.RESET;
                        FilterTargetupdatedEntries.SETRANGE("Team Code", Rec."Team Code");
                        FilterTargetupdatedEntries.SETRANGE("Field Type", ColumnCaptions[7]);
                        FilterTargetupdatedEntries.SETFILTER("From Date", '>=%1', StartDate);
                        FilterTargetupdatedEntries.SETFILTER("To Date", '<=%1', EndDate);
                        IF AssociateNo <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Associate Code", AssociateNo);
                        IF LeaderCodeFilter <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Leader Code", LeaderCodeFilter);
                        IF FilterTargetupdatedEntries.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Target Submitted from Associat", FilterTargetupdatedEntries);
                    end;
                }
                field(Field8; MATRIX_CellData[8])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[8];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field8Visible;

                    trigger OnDrillDown()
                    begin
                        FilterTargetupdatedEntries.RESET;
                        FilterTargetupdatedEntries.SETRANGE("Team Code", Rec."Team Code");
                        FilterTargetupdatedEntries.SETRANGE("Field Type", ColumnCaptions[8]);
                        FilterTargetupdatedEntries.SETFILTER("From Date", '>=%1', StartDate);
                        FilterTargetupdatedEntries.SETFILTER("To Date", '<=%1', EndDate);
                        IF AssociateNo <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Associate Code", AssociateNo);
                        IF LeaderCodeFilter <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Leader Code", LeaderCodeFilter);
                        IF FilterTargetupdatedEntries.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Target Submitted from Associat", FilterTargetupdatedEntries);
                    end;
                }
                field(Field9; MATRIX_CellData[9])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[9];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field9Visible;

                    trigger OnDrillDown()
                    begin
                        FilterTargetupdatedEntries.RESET;
                        FilterTargetupdatedEntries.SETRANGE("Team Code", Rec."Team Code");
                        FilterTargetupdatedEntries.SETRANGE("Field Type", ColumnCaptions[9]);
                        FilterTargetupdatedEntries.SETFILTER("From Date", '>=%1', StartDate);
                        FilterTargetupdatedEntries.SETFILTER("To Date", '<=%1', EndDate);
                        IF AssociateNo <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Associate Code", AssociateNo);
                        IF LeaderCodeFilter <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Leader Code", LeaderCodeFilter);
                        IF FilterTargetupdatedEntries.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Target Submitted from Associat", FilterTargetupdatedEntries);
                    end;
                }
                field(Field10; MATRIX_CellData[10])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[10];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field10Visible;

                    trigger OnDrillDown()
                    begin
                        FilterTargetupdatedEntries.RESET;
                        FilterTargetupdatedEntries.SETRANGE("Team Code", Rec."Team Code");
                        FilterTargetupdatedEntries.SETRANGE("Field Type", ColumnCaptions[10]);
                        FilterTargetupdatedEntries.SETFILTER("From Date", '>=%1', StartDate);
                        FilterTargetupdatedEntries.SETFILTER("To Date", '<=%1', EndDate);
                        IF AssociateNo <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Associate Code", AssociateNo);
                        IF LeaderCodeFilter <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Leader Code", LeaderCodeFilter);
                        IF FilterTargetupdatedEntries.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Target Submitted from Associat", FilterTargetupdatedEntries);
                    end;
                }
                field(Field11; MATRIX_CellData[11])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[11];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field11Visible;

                    trigger OnDrillDown()
                    begin
                        FilterTargetupdatedEntries.RESET;
                        FilterTargetupdatedEntries.SETRANGE("Team Code", Rec."Team Code");
                        FilterTargetupdatedEntries.SETRANGE("Field Type", ColumnCaptions[11]);
                        FilterTargetupdatedEntries.SETFILTER("From Date", '>=%1', StartDate);
                        FilterTargetupdatedEntries.SETFILTER("To Date", '<=%1', EndDate);
                        IF AssociateNo <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Associate Code", AssociateNo);
                        IF LeaderCodeFilter <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Leader Code", LeaderCodeFilter);
                        IF FilterTargetupdatedEntries.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Target Submitted from Associat", FilterTargetupdatedEntries);
                    end;
                }
                field(Field12; MATRIX_CellData[12])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[12];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field12Visible;

                    trigger OnDrillDown()
                    begin
                        FilterTargetupdatedEntries.RESET;
                        FilterTargetupdatedEntries.SETRANGE("Team Code", Rec."Team Code");
                        FilterTargetupdatedEntries.SETRANGE("Field Type", ColumnCaptions[12]);
                        FilterTargetupdatedEntries.SETFILTER("From Date", '>=%1', StartDate);
                        FilterTargetupdatedEntries.SETFILTER("To Date", '<=%1', EndDate);
                        IF AssociateNo <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Associate Code", AssociateNo);
                        IF LeaderCodeFilter <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Leader Code", LeaderCodeFilter);
                        IF FilterTargetupdatedEntries.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Target Submitted from Associat", FilterTargetupdatedEntries);
                    end;
                }
                field(Field13; MATRIX_CellData[13])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[13];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field13Visible;

                    trigger OnDrillDown()
                    begin
                        FilterTargetupdatedEntries.RESET;
                        FilterTargetupdatedEntries.SETRANGE("Team Code", Rec."Team Code");
                        FilterTargetupdatedEntries.SETRANGE("Field Type", ColumnCaptions[13]);
                        FilterTargetupdatedEntries.SETFILTER("From Date", '>=%1', StartDate);
                        FilterTargetupdatedEntries.SETFILTER("To Date", '<=%1', EndDate);
                        IF AssociateNo <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Associate Code", AssociateNo);
                        IF LeaderCodeFilter <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Leader Code", LeaderCodeFilter);
                        IF FilterTargetupdatedEntries.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Target Submitted from Associat", FilterTargetupdatedEntries);
                    end;
                }
                field(Field14; MATRIX_CellData[14])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[14];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field14Visible;

                    trigger OnDrillDown()
                    begin
                        FilterTargetupdatedEntries.RESET;
                        FilterTargetupdatedEntries.SETRANGE("Team Code", Rec."Team Code");
                        FilterTargetupdatedEntries.SETRANGE("Field Type", ColumnCaptions[14]);
                        FilterTargetupdatedEntries.SETFILTER("From Date", '>=%1', StartDate);
                        FilterTargetupdatedEntries.SETFILTER("To Date", '<=%1', EndDate);
                        IF AssociateNo <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Associate Code", AssociateNo);
                        IF LeaderCodeFilter <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Leader Code", LeaderCodeFilter);
                        IF FilterTargetupdatedEntries.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Target Submitted from Associat", FilterTargetupdatedEntries);
                    end;
                }
                field(Field15; MATRIX_CellData[15])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[15];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field15Visible;

                    trigger OnDrillDown()
                    begin
                        FilterTargetupdatedEntries.RESET;
                        FilterTargetupdatedEntries.SETRANGE("Team Code", Rec."Team Code");
                        FilterTargetupdatedEntries.SETRANGE("Field Type", ColumnCaptions[15]);
                        FilterTargetupdatedEntries.SETFILTER("From Date", '>=%1', StartDate);
                        FilterTargetupdatedEntries.SETFILTER("To Date", '<=%1', EndDate);
                        IF AssociateNo <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Associate Code", AssociateNo);
                        IF LeaderCodeFilter <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Leader Code", LeaderCodeFilter);
                        IF FilterTargetupdatedEntries.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Target Submitted from Associat", FilterTargetupdatedEntries);
                    end;
                }
                field(Field16; MATRIX_CellData[16])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[16];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field16Visible;

                    trigger OnDrillDown()
                    begin
                        FilterTargetupdatedEntries.RESET;
                        FilterTargetupdatedEntries.SETRANGE("Team Code", Rec."Team Code");
                        FilterTargetupdatedEntries.SETRANGE("Field Type", ColumnCaptions[16]);
                        FilterTargetupdatedEntries.SETFILTER("From Date", '>=%1', StartDate);
                        FilterTargetupdatedEntries.SETFILTER("To Date", '<=%1', EndDate);
                        IF AssociateNo <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Associate Code", AssociateNo);
                        IF LeaderCodeFilter <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Leader Code", LeaderCodeFilter);
                        IF FilterTargetupdatedEntries.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Target Submitted from Associat", FilterTargetupdatedEntries);
                    end;
                }
                field(Field17; MATRIX_CellData[17])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[17];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field17Visible;

                    trigger OnDrillDown()
                    begin
                        FilterTargetupdatedEntries.RESET;
                        FilterTargetupdatedEntries.SETRANGE("Team Code", Rec."Team Code");
                        FilterTargetupdatedEntries.SETRANGE("Field Type", ColumnCaptions[17]);
                        FilterTargetupdatedEntries.SETFILTER("From Date", '>=%1', StartDate);
                        FilterTargetupdatedEntries.SETFILTER("To Date", '<=%1', EndDate);
                        IF AssociateNo <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Associate Code", AssociateNo);
                        IF LeaderCodeFilter <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Leader Code", LeaderCodeFilter);
                        IF FilterTargetupdatedEntries.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Target Submitted from Associat", FilterTargetupdatedEntries);
                    end;
                }
                field(Field18; MATRIX_CellData[18])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[18];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field18Visible;

                    trigger OnDrillDown()
                    begin
                        FilterTargetupdatedEntries.RESET;
                        FilterTargetupdatedEntries.SETRANGE("Team Code", Rec."Team Code");
                        FilterTargetupdatedEntries.SETRANGE("Field Type", ColumnCaptions[18]);
                        FilterTargetupdatedEntries.SETFILTER("From Date", '>=%1', StartDate);
                        FilterTargetupdatedEntries.SETFILTER("To Date", '<=%1', EndDate);
                        IF AssociateNo <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Associate Code", AssociateNo);
                        IF LeaderCodeFilter <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Leader Code", LeaderCodeFilter);
                        IF FilterTargetupdatedEntries.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Target Submitted from Associat", FilterTargetupdatedEntries);
                    end;
                }
                field(Field19; MATRIX_CellData[19])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[19];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field19Visible;

                    trigger OnDrillDown()
                    begin
                        FilterTargetupdatedEntries.RESET;
                        FilterTargetupdatedEntries.SETRANGE("Team Code", Rec."Team Code");
                        FilterTargetupdatedEntries.SETRANGE("Field Type", ColumnCaptions[19]);
                        FilterTargetupdatedEntries.SETFILTER("From Date", '>=%1', StartDate);
                        FilterTargetupdatedEntries.SETFILTER("To Date", '<=%1', EndDate);
                        IF AssociateNo <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Associate Code", AssociateNo);
                        IF LeaderCodeFilter <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Leader Code", LeaderCodeFilter);
                        IF FilterTargetupdatedEntries.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Target Submitted from Associat", FilterTargetupdatedEntries);
                    end;
                }
                field(Field20; MATRIX_CellData[20])
                {
                    BlankZero = true;
                    CaptionClass = '3,' + ColumnCaptions[20];
                    Style = Strong;
                    StyleExpr = Emphasize;
                    Visible = Field20Visible;

                    trigger OnDrillDown()
                    begin
                        FilterTargetupdatedEntries.RESET;
                        FilterTargetupdatedEntries.SETRANGE("Team Code", Rec."Team Code");
                        FilterTargetupdatedEntries.SETRANGE("Field Type", ColumnCaptions[20]);
                        FilterTargetupdatedEntries.SETFILTER("From Date", '>=%1', StartDate);
                        FilterTargetupdatedEntries.SETFILTER("To Date", '<=%1', EndDate);
                        IF AssociateNo <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Associate Code", AssociateNo);
                        IF LeaderCodeFilter <> '' THEN
                            FilterTargetupdatedEntries.SETFILTER("Leader Code", LeaderCodeFilter);
                        IF FilterTargetupdatedEntries.FINDSET THEN
                            PAGE.RUNMODAL(Page::"Target Submitted from Associat", FilterTargetupdatedEntries);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SNo := 0;
        Targetfieldmaster.RESET;
        IF fieldfilters <> '' THEN
            Targetfieldmaster.SETFILTER(Code, fieldfilters);
        IF Targetfieldmaster.FINDSET THEN
            REPEAT
                SNo := SNo + 1;
                ColumnCaptions[SNo] := Targetfieldmaster.Code;
            UNTIL Targetfieldmaster.NEXT = 0;
        SetVisible;


        ShowMatrixDetails;
    end;

    trigger OnInit()
    begin
        Field20Visible := TRUE;
        Field19Visible := TRUE;
        Field18Visible := TRUE;
        Field17Visible := TRUE;
        Field16Visible := TRUE;
        Field15Visible := TRUE;
        Field14Visible := TRUE;
        Field13Visible := TRUE;
        Field12Visible := TRUE;
        Field11Visible := TRUE;
        Field10Visible := TRUE;
        Field9Visible := TRUE;
        Field8Visible := TRUE;
        Field7Visible := TRUE;
        Field6Visible := TRUE;
        Field5Visible := TRUE;
        Field4Visible := TRUE;
        Field3Visible := TRUE;
        Field2Visible := TRUE;
        Field1Visible := TRUE;
    end;

    var
        StartDate: Date;
        EndDate: Date;
        AssociateNo: Text;
        EntryNo: Integer;
        TargetsubmissionfromMobile: Page "Target Submitted from Associat";
        MATRIX_CellData: array[32] of Decimal;

        Field1Visible: Boolean;

        Field2Visible: Boolean;

        Field3Visible: Boolean;

        Field4Visible: Boolean;

        Field5Visible: Boolean;

        Field6Visible: Boolean;

        Field7Visible: Boolean;

        Field8Visible: Boolean;

        Field9Visible: Boolean;

        Field10Visible: Boolean;

        Field11Visible: Boolean;

        Field12Visible: Boolean;

        Field13Visible: Boolean;

        Field14Visible: Boolean;

        Field15Visible: Boolean;

        Field16Visible: Boolean;

        Field17Visible: Boolean;

        Field18Visible: Boolean;

        Field19Visible: Boolean;

        Field20Visible: Boolean;
        Emphasize: Boolean;
        ColumnCaptions: array[32] of Text[250];
        Targetfieldmaster: Record "Target field master";
        SNo: Integer;
        TargetupdatedEntries: Record "Target Submitted from Associat";
        TotalTargetValue: Decimal;
        TeamCode: Text;
        LineNo: Integer;
        fieldfilters: Text;
        FilterTargetupdatedEntries: Record "Target Submitted from Associat";
        Monthly: Boolean;
        LeaderCodeFilter: Text;


    procedure Load(StartDateFilter: Date; EndDateFilter: Date; AssociateFilter: Text; TeamFilter: Text; V_Fieldfilters: Text; v_Monthly: Boolean; v_LeaderCodeFilter: Text)
    begin
        StartDate := StartDateFilter;
        EndDate := EndDateFilter;
        AssociateNo := AssociateFilter;
        TeamCode := TeamFilter;
        fieldfilters := V_Fieldfilters;
        Monthly := v_Monthly;
        LeaderCodeFilter := v_LeaderCodeFilter;
    end;

    local procedure ShowMatrixDetails()
    begin
        LineNo := 0;
        CLEAR(MATRIX_CellData);
        TotalTargetValue := 0;
        Targetfieldmaster.RESET;
        IF fieldfilters <> '' THEN
            Targetfieldmaster.SETFILTER(Code, fieldfilters);
        IF Targetfieldmaster.FINDSET THEN
            REPEAT
                LineNo := LineNo + 1;
                TargetupdatedEntries.RESET;
                TargetupdatedEntries.SETFILTER("Team Code", Rec."Team Code");
                IF Monthly THEN
                    TargetupdatedEntries.SETRANGE(Monthly, TRUE);
                IF LeaderCodeFilter <> '' THEN
                    TargetupdatedEntries.SETFILTER("Leader Code", LeaderCodeFilter);
                TargetupdatedEntries.SETFILTER("From Date", '>=%1', StartDate);
                TargetupdatedEntries.SETFILTER("To Date", '<=%1', EndDate);
                TargetupdatedEntries.SETRANGE("Field Type", Targetfieldmaster.Code);
                IF AssociateNo <> '' THEN
                    TargetupdatedEntries.SETFILTER("Associate Code", AssociateNo);
                IF TargetupdatedEntries.FINDSET THEN
                    REPEAT
                        MATRIX_CellData[LineNo] := MATRIX_CellData[LineNo] + TargetupdatedEntries."Target Value";
                        TotalTargetValue := TotalTargetValue + TargetupdatedEntries."Target Value";
                    UNTIL TargetupdatedEntries.NEXT = 0;
            UNTIL Targetfieldmaster.NEXT = 0;
    end;


    procedure SetVisible()
    begin
        Field1Visible := ColumnCaptions[1] <> '';
        Field2Visible := ColumnCaptions[2] <> '';
        Field3Visible := ColumnCaptions[3] <> '';
        Field4Visible := ColumnCaptions[4] <> '';
        Field5Visible := ColumnCaptions[5] <> '';
        Field6Visible := ColumnCaptions[6] <> '';
        Field7Visible := ColumnCaptions[7] <> '';
        Field8Visible := ColumnCaptions[8] <> '';
        Field9Visible := ColumnCaptions[9] <> '';
        Field10Visible := ColumnCaptions[10] <> '';
        Field11Visible := ColumnCaptions[11] <> '';
        Field12Visible := ColumnCaptions[12] <> '';
        Field13Visible := ColumnCaptions[13] <> '';
        Field14Visible := ColumnCaptions[14] <> '';
        Field15Visible := ColumnCaptions[15] <> '';
        Field16Visible := ColumnCaptions[16] <> '';
        Field17Visible := ColumnCaptions[17] <> '';
        Field18Visible := ColumnCaptions[18] <> '';
        Field19Visible := ColumnCaptions[19] <> '';
        Field20Visible := ColumnCaptions[20] <> '';
    end;
}

