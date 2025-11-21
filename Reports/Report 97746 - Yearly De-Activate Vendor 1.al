report 97746 "Yearly De-Activate Vendor"
{
    // version BBG format

    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = WHERE("No." = FILTER('IBA*'),
                                      "BBG Black List" = FILTER(false));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            var
                VLEntry_1: Record "Vendor Ledger Entry";
            begin
                Recordfound := FALSE;
                BlackList := FALSE;
                CheckEntries;
                //IF Recordfound THEN
                //CheckBlackList;
                IF Recordfound THEN BEGIN
                    CheckCurrentEntries;
                    IF NOT FindEntries THEN BEGIN
                        PreDeactivateVendors.INIT;
                        PreDeactivateVendors.TRANSFERFIELDS(Vendor);
                        PreDeactivateVendors.Type := PreDeactivateVendors.Type::"Black List";
                        PreDeactivateVendors.Selected := TRUE;
                        PreDeactivateVendors."Batch Run By" := USERID;
                        PreDeactivateVendors."Batch Run Date" := TODAY;
                        PreDeactivateVendors."Batch Run Time" := TIME;
                        PreDeactivateVendors.INSERT
                    END;
                END;
            end;

            trigger OnPreDataItem()
            var
                AssadjEntry_1: Record "Associate OD Ajustment Entry";
            begin
                PreDeactivateVendors.RESET;
                PreDeactivateVendors.DELETEALL;

                Vendor.SETFILTER("No.", '%1..%2', 'IBA0000001', 'IBA9999900');
                Vendor.SETFILTER("BBG Mob. No.", '<>%1', 'R*');

                CompanywiseGLAccount.RESET;
                CompanywiseGLAccount.SETRANGE("MSC Company", TRUE);
                IF CompanywiseGLAccount.FINDFIRST THEN
                    MSCCompany := CompanywiseGLAccount."Company Code";
                IF COMPANYNAME <> MSCCompany THEN
                    ERROR('Run this batch from MSC Company');

                //StartDate
                CutoffDate := CALCDATE('-1D', FromDate);  //200524

                //CutoffDate := 161023D;
                //MESSAGE('%1',CutoffDate);

                Vendor.SETRANGE("BBG Date of Joining", 0D, CutoffDate);
                Vendor.SETRANGE("BBG Black List", FALSE);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("From Date"; FromDate)
                {
                    ApplicationArea = All;
                }
                field("To Date"; ToDate)
                {
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        MESSAGE('DONE');
    end;

    trigger OnPreReport()
    begin

        IF FromDate = 0D THEN
            ERROR('From Date should not be blank');
        IF ToDate = 0D THEN
            ERROR('To Date should not be blank');

        CompInfo.GET;
        //    IF NOT CREATE(XlApp,TRUE,TRUE) THEN
        //    ERROR('Excel not found.');

        //XlWrkBook := XlApp.Workbooks.Add;
        //XLWkSheet := XlWrkBook.ActiveSheet;
        //XlApp.Visible := TRUE;
        /*
        J := 5;
        k := 1;
        XlRange := XLWkSheet.Range('A' + FORMAT(k));
        XlRange.Value := CompInfo.Name;
        k += 1;
        XlRange := XLWkSheet.Range('A' + FORMAT(k));
        XlRange.Value := CompInfo.Address + ' '+ CompInfo."Address 2"+ ' '+ CompInfo.City+ ' ' + CompInfo."Post Code";
        k += 1;

        XlRange := XLWkSheet.Range('A' + FORMAT(k));
        XlRange.Value := 'IBA Code';
        XlRange := XLWkSheet.Range('B' + FORMAT(k));
        XlRange.Value := 'IBA Name';
        XlRange := XLWkSheet.Range('C' + FORMAT(k));
        XlRange.Value := 'Type';

        k += 1;
        */

    end;

    var
        CompInfo: Record "Company Information";
        Filters: Text[30];
        Vendor_1: Record Vendor;
        k: Integer;
        J: Integer;
        FilterUsed: Text[250];
        ExportToExcel: Boolean;
        // XlApp: Automation ;
        // XlWrkBook: Automation ;
        // XLWkSheet: Automation ;
        // XlWrkshts: Automation ;
        // XlRange: Automation ;
        Text000: Label 'Invalid Parameters.';
        CommissionEntry: Record "Commission Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        VLEExists: Boolean;
        CommissionExists: Boolean;
        v_Company: Record Company;
        Recordfound: Boolean;
        RecordSkip: Boolean;
        AssociateHierarcywithApp: Record "Associate Hierarcy with App.";
        CutoffDate: Date;
        AssociateHierarcywithApp1: Record "New Associate Hier with Appl.";
        UnitCommCreationBuffer: Record "Unit & Comm. Creation Buffer";
        DeleteAssociate: Boolean;
        Company_1: Record Company;
        CompanywiseGLAccount: Record "Company wise G/L Account";
        MSCCompany: Text;
        BlackList: Boolean;
        PreDeactivateVendors: Record "Yearly De-Activate Vendor list";
        NewConfirmedOrder: Record "New Confirmed Order";
        FromDate: Date;
        ToDate: Date;
        FindEntries: Boolean;

    local procedure CheckEntries(): Boolean
    begin
        Recordfound := FALSE;
        v_Company.RESET;
        IF v_Company.FINDSET THEN
            REPEAT
                VendorLedgerEntry.RESET;
                VendorLedgerEntry.CHANGECOMPANY(v_Company.Name);
                VendorLedgerEntry.SETCURRENTKEY("Vendor No.", "Posting Date");
                VendorLedgerEntry.SETRANGE("Vendor No.", Vendor."No.");
                //VendorLedgerEntry.SETRANGE("Posting Date",150723D,TODAY);
                VendorLedgerEntry.SETRANGE("Posting Date", 0D, CutoffDate);
                IF VendorLedgerEntry.FINDFIRST THEN BEGIN
                    Recordfound := TRUE;
                END;
            UNTIL (v_Company.NEXT = 0) OR (Recordfound);

        IF NOT Recordfound THEN BEGIN
            v_Company.RESET;
            IF v_Company.FINDSET THEN
                REPEAT
                    RecordSkip := TRUE;

                    NewConfirmedOrder.RESET;
                    NewConfirmedOrder.SETRANGE("Introducer Code", Vendor."No.");
                    NewConfirmedOrder.SETRANGE("Posting Date", FromDate, ToDate);  //171024 added
                    IF NewConfirmedOrder.FINDFIRST THEN
                        Recordfound := TRUE;

                    IF NOT Recordfound THEN BEGIN
                        AssociateHierarcywithApp.RESET;
                        AssociateHierarcywithApp.SETCURRENTKEY("Associate Code");
                        AssociateHierarcywithApp.SETRANGE("Associate Code", Vendor."No.");
                        IF AssociateHierarcywithApp.FINDFIRST THEN
                            Recordfound := TRUE;
                    END;
                    IF NOT Recordfound THEN BEGIN
                        AssociateHierarcywithApp1.RESET;
                        AssociateHierarcywithApp1.SETCURRENTKEY("Associate Code");
                        AssociateHierarcywithApp1.SETRANGE("Associate Code", Vendor."No.");
                        IF AssociateHierarcywithApp1.FINDFIRST THEN
                            Recordfound := TRUE;
                    END;

                    //      IF NOT Recordfound THEN BEGIN
                    //        VendorLedgerEntry.RESET;
                    //        VendorLedgerEntry.CHANGECOMPANY(v_Company.Name);
                    //        VendorLedgerEntry.SETCURRENTKEY("Vendor No.");
                    //        VendorLedgerEntry.SETRANGE("Vendor No.",Vendor."No.");
                    //        VendorLedgerEntry.SETRANGE("Posting Date",010113D,CutoffDate);
                    //        //VendorLedgerEntry.SETRANGE("Posting Date",CutoffDate,TODAY-1);
                    //        IF VendorLedgerEntry.FINDFIRST THEN
                    //          Recordfound := TRUE;
                    //      END;
                    IF NOT Recordfound THEN BEGIN
                        CommissionEntry.RESET;
                        CommissionEntry.CHANGECOMPANY(v_Company.Name);
                        CommissionEntry.SETCURRENTKEY("Associate Code");
                        CommissionEntry.SETRANGE("Associate Code", Vendor."No.");
                        IF CommissionEntry.FINDFIRST THEN
                            Recordfound := TRUE;
                    END;
                    IF NOT Recordfound THEN BEGIN
                        UnitCommCreationBuffer.RESET;
                        UnitCommCreationBuffer.CHANGECOMPANY(v_Company.Name);
                        UnitCommCreationBuffer.SETCURRENTKEY("Introducer Code");
                        UnitCommCreationBuffer.SETRANGE("Introducer Code", Vendor."No.");
                        IF UnitCommCreationBuffer.FINDFIRST THEN
                            Recordfound := TRUE;
                    END;
                    IF Recordfound THEN BEGIN
                        //      EXIT(Recordfound);
                        RecordSkip := FALSE;
                    END;
                UNTIL (v_Company.NEXT = 0) OR (NOT RecordSkip);
        END;
    end;

    local procedure CheckCurrentEntries(): Boolean
    begin
        FindEntries := FALSE;
        v_Company.RESET;
        IF v_Company.FINDSET THEN
            REPEAT
                VendorLedgerEntry.RESET;
                VendorLedgerEntry.CHANGECOMPANY(v_Company.Name);
                VendorLedgerEntry.SETCURRENTKEY("Vendor No.", "Posting Date");
                VendorLedgerEntry.SETRANGE("Vendor No.", Vendor."No.");
                VendorLedgerEntry.SETRANGE("Posting Date", FromDate, ToDate);
                IF VendorLedgerEntry.FINDFIRST THEN BEGIN
                    FindEntries := TRUE;
                END;
            UNTIL (v_Company.NEXT = 0) OR (FindEntries);

        IF NOT FindEntries THEN BEGIN
            RecordSkip := TRUE;

            v_Company.RESET;
            IF v_Company.FINDSET THEN
                REPEAT
                    RecordSkip := TRUE;

                    NewConfirmedOrder.RESET;
                    NewConfirmedOrder.SETCURRENTKEY("Introducer Code", "Posting Date");
                    NewConfirmedOrder.SETRANGE("Introducer Code", Vendor."No.");
                    NewConfirmedOrder.SETRANGE("Posting Date", FromDate, ToDate);  //171024 added
                    IF NewConfirmedOrder.FINDFIRST THEN
                        FindEntries := TRUE;

                    IF NOT FindEntries THEN BEGIN
                        AssociateHierarcywithApp.RESET;
                        AssociateHierarcywithApp.SETCURRENTKEY("Associate Code");
                        AssociateHierarcywithApp.SETRANGE("Associate Code", Vendor."No.");
                        AssociateHierarcywithApp.SETRANGE("Posting Date", FromDate, ToDate);
                        IF AssociateHierarcywithApp.FINDFIRST THEN
                            FindEntries := TRUE;
                    END;

                    IF NOT FindEntries THEN BEGIN
                        AssociateHierarcywithApp1.RESET;
                        AssociateHierarcywithApp1.SETCURRENTKEY("Associate Code");
                        AssociateHierarcywithApp1.SETRANGE("Associate Code", Vendor."No.");
                        AssociateHierarcywithApp1.SETRANGE("Posting Date", FromDate, ToDate);
                        IF AssociateHierarcywithApp1.FINDFIRST THEN
                            FindEntries := TRUE;
                    END;

                    IF NOT FindEntries THEN BEGIN
                        CommissionEntry.RESET;
                        CommissionEntry.CHANGECOMPANY(v_Company.Name);
                        CommissionEntry.CALCFIELDS("Application DOJ");
                        CommissionEntry.SETRANGE("Associate Code", Vendor."No.");
                        CommissionEntry.SETRANGE("Application DOJ", FromDate, ToDate);
                        IF CommissionEntry.FINDFIRST THEN
                            FindEntries := TRUE;
                    END;

                    IF FindEntries THEN BEGIN
                        //      EXIT(Recordfound);
                        RecordSkip := FALSE;
                    END;
                UNTIL (v_Company.NEXT = 0) OR (NOT RecordSkip);
        END;
    end;
}

