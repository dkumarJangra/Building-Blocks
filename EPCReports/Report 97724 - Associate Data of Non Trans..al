report 97724 "Associate Data of Non Trans."
{
    // version BBG format

    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = WHERE("No." = FILTER('IBA*'), "BBG Black List" = CONST(false));
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
                IF BlackList THEN BEGIN
                    PreDeactivateVendors.INIT;
                    PreDeactivateVendors.TRANSFERFIELDS(Vendor);
                    PreDeactivateVendors.Type := PreDeactivateVendors.Type::"Black List";
                    PreDeactivateVendors.Selected := TRUE;
                    PreDeactivateVendors."Batch Run By" := USERID;
                    PreDeactivateVendors."Batch Run Date" := TODAY;
                    PreDeactivateVendors."Batch Run Time" := TIME;
                    PreDeactivateVendors.INSERT
                END;

                IF NOT Recordfound THEN BEGIN
                    PreDeactivateVendors.INIT;
                    PreDeactivateVendors.TRANSFERFIELDS(Vendor);
                    PreDeactivateVendors.Type := PreDeactivateVendors.Type::Delete;
                    PreDeactivateVendors.Selected := TRUE;
                    PreDeactivateVendors."Batch Run By" := USERID;
                    PreDeactivateVendors."Batch Run Date" := TODAY;
                    PreDeactivateVendors."Batch Run Time" := TIME;
                    PreDeactivateVendors.INSERT
                END;
            end;

            trigger OnPreDataItem()
            var
                AssadjEntry_1: Record "Associate OD Ajustment Entry";
            begin
                PreDeactivateVendors.RESET;
                PreDeactivateVendors.DELETEALL;

                Vendor.SETFILTER("No.", '%1..%2', 'IBA0000001', 'IBA9999900');
                Vendor.SETFILTER("bbg Mob. No.", '<>%1', 'R*');
                Vendor.SETRANGE("BBG Black List", FALSE);
                CompanywiseGLAccount.RESET;
                CompanywiseGLAccount.SETRANGE("MSC Company", TRUE);
                IF CompanywiseGLAccount.FINDFIRST THEN
                    MSCCompany := CompanywiseGLAccount."Company Code";

                CutoffDate := CALCDATE('-12M', TODAY);  //200524

                //CutoffDate := 300423D;
                //MESSAGE('%1',CutoffDate);

                Vendor.SETRANGE("BBG Date of Joining", 0D, CutoffDate);
            end;
        }
    }

    requestpage
    {

        layout
        {
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
        //DeActivateVendors: Record 50068;
        CompanywiseGLAccount: Record "Company wise G/L Account";
        MSCCompany: Text;
        BlackList: Boolean;
        PreDeactivateVendors: Record "Pre- De-activate Vendors";
        NewConfirmedOrder: Record "New Confirmed Order";

    local procedure CheckEntries(): Boolean
    begin
        v_Company.RESET;
        IF v_Company.FINDSET THEN
            REPEAT
                VendorLedgerEntry.RESET;
                VendorLedgerEntry.CHANGECOMPANY(v_Company.Name);
                VendorLedgerEntry.SETCURRENTKEY("Vendor No.", "Posting Date");
                VendorLedgerEntry.SETRANGE("Vendor No.", Vendor."No.");
                VendorLedgerEntry.SETRANGE("Posting Date", 20230715D, TODAY);//150723D
                IF VendorLedgerEntry.FINDFIRST THEN BEGIN
                    Recordfound := TRUE;
                END;
            UNTIL (v_Company.NEXT = 0) OR (Recordfound);
        // IF ShowOnlyFinanace THEN BEGIN
        //  v_Company.RESET;
        //  IF v_Company.FINDSET THEN
        //  REPEAT
        //    VendorLedgerEntry.RESET;
        //    VendorLedgerEntry.CHANGECOMPANY(v_Company.Name);
        //    VendorLedgerEntry.SETCURRENTKEY("Vendor No.");
        //    VendorLedgerEntry.SETRANGE("Vendor No.",Vendor."No.");
        //    VendorLedgerEntry.SETRANGE("Posting Date",010113D,CutoffDate);
        //    IF VendorLedgerEntry.FINDFIRST THEN BEGIN
        //      Recordfound := TRUE;
        //    END;
        //  UNTIL (v_Company.NEXT = 0) OR (Recordfound);
        // END ELSE BEGIN

        v_Company.RESET;
        IF v_Company.FINDSET THEN
            REPEAT
                RecordSkip := TRUE;

                NewConfirmedOrder.RESET;
                NewConfirmedOrder.SETRANGE("Introducer Code", Vendor."No.");
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

                IF NOT Recordfound THEN BEGIN
                    VendorLedgerEntry.RESET;
                    VendorLedgerEntry.CHANGECOMPANY(v_Company.Name);
                    VendorLedgerEntry.SETCURRENTKEY("Vendor No.");
                    VendorLedgerEntry.SETRANGE("Vendor No.", Vendor."No.");
                    VendorLedgerEntry.SETRANGE("Posting Date", 20130101D, CutoffDate);//010113D
                    IF VendorLedgerEntry.FINDFIRST THEN
                        Recordfound := TRUE;
                END;
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
        //END;
    end;

    local procedure CheckBlackList()
    begin
        /*
        BlackList := TRUE;
        NewConfirmedOrder.RESET;
        NewConfirmedOrder.SETRANGE("Introducer Code",Vendor."No.");
        IF NewConfirmedOrder.FINDFIRST THEN
          BlackList := FALSE;
        
        IF BlackList THEN BEGIN
          v_Company.RESET;
          IF v_Company.FINDSET THEN
            REPEAT
              RecordSkip := FALSE;
              VendorLedgerEntry.RESET;
              VendorLedgerEntry.CHANGECOMPANY(v_Company.Name);
              VendorLedgerEntry.SETCURRENTKEY("Vendor No.");
              VendorLedgerEntry.SETRANGE("Vendor No.",Vendor."No.");
              IF VendorLedgerEntry.FINDFIRST THEN BEGIN
                BlackList := FALSE;
              END;
        
              IF NOT BlackList THEN
                RecordSkip := TRUE;
          UNTIL (v_Company.NEXT = 0) OR (RecordSkip);
        END;
        */

    end;
}

