page 50291 "Associate Target Matrix"
{
    PageType = Card;
    SourceTable = Integer;
    SourceTableTemporary = true;
    SourceTableView = WHERE(Number = CONST(1));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group("Matrix Filters")
            {
                field(Monthly; Monthly)
                {
                }
                field(Year; Year)
                {

                    trigger OnValidate()
                    begin
                        IF NOT Monthly THEN
                            ERROR('Monthly should be Tick');
                    end;
                }
                field(Month; Month)
                {

                    trigger OnValidate()
                    begin

                        IF NOT Monthly THEN
                            ERROR('Monthly should be Tick');

                        IF Year = 0 THEN
                            ERROR('Year can not be blank');

                        IF Month = Month::" " THEN BEGIN
                            StartDate := 0D;
                            EndDate := 0D;
                        END;


                        IF Month = Month::Jan THEN
                            MonthNo := 1
                        ELSE
                            IF Month = Month::Feb THEN
                                MonthNo := 2
                            ELSE
                                IF Month = Month::March THEN
                                    MonthNo := 3
                                ELSE
                                    IF Month = Month::April THEN
                                        MonthNo := 4
                                    ELSE
                                        IF Month = Month::May THEN
                                            MonthNo := 5
                                        ELSE
                                            IF Month = Month::June THEN
                                                MonthNo := 6
                                            ELSE
                                                IF Month = Month::July THEN
                                                    MonthNo := 7
                                                ELSE
                                                    IF Month = Month::Aug THEN
                                                        MonthNo := 8
                                                    ELSE
                                                        IF Month = Month::Sept THEN
                                                            MonthNo := 9
                                                        ELSE
                                                            IF Month = Month::Oct THEN
                                                                MonthNo := 10
                                                            ELSE
                                                                IF Month = Month::Nov THEN
                                                                    MonthNo := 11
                                                                ELSE
                                                                    IF Month = Month::Dec THEN
                                                                        MonthNo := 12;


                        IF (MonthNo = 1) OR (MonthNo = 3) OR (MonthNo = 5) OR (MonthNo = 7) OR (MonthNo = 8) OR (MonthNo = 10) OR (MonthNo = 12) THEN BEGIN
                            StartDate := DMY2DATE(1, MonthNo, Year);
                            EndDate := DMY2DATE(31, MonthNo, Year);
                        END ELSE
                            IF (MonthNo = 4) OR (MonthNo = 6) OR (MonthNo = 9) OR (MonthNo = 11) THEN BEGIN
                                StartDate := DMY2DATE(1, MonthNo, Year);
                                EndDate := DMY2DATE(30, MonthNo, Year);
                            END ELSE
                                IF MonthNo = 2 THEN BEGIN
                                    IF (Year MOD 4) = 0 THEN BEGIN
                                        StartDate := DMY2DATE(1, MonthNo, Year);
                                        EndDate := DMY2DATE(28, MonthNo, Year);
                                    END ELSE BEGIN
                                        StartDate := DMY2DATE(1, MonthNo, Year);
                                        EndDate := DMY2DATE(29, MonthNo, Year);
                                    END;


                                END;
                    end;
                }
                field("Start Date"; StartDate)
                {
                    Caption = 'From Date';
                }
                field("End Date"; EndDate)
                {
                    Caption = 'To Date';
                }
                field("Associate Filter"; AssociateFilter)
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        VendorList: Page "Vendor List";
                        Vendor_L: Record Vendor;
                    begin
                        Vendor_L.RESET;
                        Vendor_L.SETRANGE("BBG Vendor Category", Vendor_L."BBG Vendor Category"::"IBA(Associates)");
                        IF Vendor_L.FINDSET THEN;
                        VendorList.SETTABLEVIEW(Vendor_L);
                        VendorList.LOOKUPMODE(TRUE);
                        IF VendorList.RUNMODAL = ACTION::LookupOK THEN
                            AssociateFilter := VendorList.GetSelectionFilter;
                    end;
                }
                field("Field Type Filter"; FiledTypeFilter)
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        TargetFieldMasterList: Page "Target Field Master List";
                    begin
                        TargetFieldMasterList.LOOKUPMODE(TRUE);
                        IF TargetFieldMasterList.RUNMODAL = ACTION::LookupOK THEN
                            FiledTypeFilter := TargetFieldMasterList.GetSelectionFilter;
                    end;
                }
                field("Team Name"; TeamName)
                {
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        TeamMasterList: Page "Team Master List";
                    begin

                        TeamMasterList.LOOKUPMODE(TRUE);
                        IF TeamMasterList.RUNMODAL = ACTION::LookupOK THEN
                            TeamName := TeamMasterList.GetSelectionFilter;
                    end;
                }
                field("Leader Code Filter"; LeaderCodeFilter)
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        LeaderMasterList: Page "Leader Master";
                    begin
                        LeaderMasterList.LOOKUPMODE(TRUE);
                        IF LeaderMasterList.RUNMODAL = ACTION::LookupOK THEN
                            LeaderCodeFilter := LeaderMasterList.GetSelectionFilter;
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Show Matrix")
            {
                Caption = 'Show &Matrix';
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    IF (StartDate = 0D) OR (EndDate = 0D) THEN
                        ERROR('Please enter From Date / To Date Filters');
                    CLEAR(AssociateTargetMatrixLine);
                    AssociateTargetMatrixLine.Load(StartDate, EndDate, AssociateFilter, TeamFilter, FiledTypeFilter, Monthly, LeaderCodeFilter);
                    AssociateTargetMatrixLine.RUNMODAL;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Target Functionality", FALSE);
        IF UserSetup.FINDFIRST THEN
            ERROR('Please contact admin');

        CompanywiseGLAccount.RESET;
        CompanywiseGLAccount.SETRANGE("MSC Company", TRUE);
        IF CompanywiseGLAccount.FINDFIRST THEN
            IF CompanywiseGLAccount."Company Code" <> COMPANYNAME THEN
                ERROR('This process will run in BBP company');
    end;

    var
        AssociateTargetMatrixLine: Page "Associate Target Matrix Line";
        StartDate: Date;
        EndDate: Date;
        AssociateFilter: Text;
        TeamFilter: Text;
        FiledTypeFilter: Text;
        RecVendor: Record Vendor;
        Monthly: Boolean;
        Year: Integer;
        Month: Option " ",Jan,Feb,March,April,May,June,July,Aug,Sept,Oct,Nov,Dec;
        MonthNo: Integer;
        TeamName: Text;
        LeaderCodeFilter: Text;
        CompanywiseGLAccount: Record "Company wise G/L Account";
        UserSetup: Record "User Setup";
}

