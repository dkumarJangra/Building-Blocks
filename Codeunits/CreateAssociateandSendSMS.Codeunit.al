codeunit 50009 "Create Associate and Send SMS"
{

    trigger OnRun()
    var
        AssociateLoginDetails_1: Record "Associate Login Details";
        OldAssociateLoginDetails: Record "Associate Login Details";
        AssStatus: Text;
        AssociateTeamforGamifiction: Report "Team Head Name Update";
        WRegionwiseVendor: Record "Region wise Vendor";
    begin

        AssociateLoginDetails.RESET;
        AssociateLoginDetails.SETRANGE(Associate_ID, '');
        AssociateLoginDetails.SETRANGE("NAV-Associate Created", FALSE);
        AssociateLoginDetails.SETFILTER(Rank_Code, '<>%1', 0.0);
        AssociateLoginDetails.SETFILTER("Creation Date", '>%1', 20210101D);
        //AssociateLoginDetails.SETRANGE("Send for Associate Create",TRUE);
        //AssociateLoginDetails.SETFILTER(Parent_ID,'<>%1','');
        AssociateLoginDetails.SETFILTER(Status, '%1|%2', AssociateLoginDetails.Status::"Under Process", AssociateLoginDetails.Status::"Sent for Approval");
        IF AssociateLoginDetails.FINDSET THEN
            REPEAT

                CLEAR(CreateAssociateSendSMS);
                CreateAssociateSendSMS.Setvalue(AssociateLoginDetails.USER_ID);
                IF NOT CreateAssociateSendSMS.RUN(AssociateLoginDetails) THEN BEGIN
                    AssociateLoginDetails_1.RESET;
                    IF AssociateLoginDetails_1.GET(AssociateLoginDetails.USER_ID) THEN BEGIN
                        AssociateLoginDetails_1."Associate Creation Error" := COPYSTR(GETLASTERRORTEXT, 1, 100);
                        AssociateLoginDetails_1.MODIFY;
                    END;
                END;
                //ALLEDK 221123
                OldAssociateLoginDetails.RESET;
                IF OldAssociateLoginDetails.GET(AssociateLoginDetails.USER_ID) THEN BEGIN
                    Vendor.RESET;
                    IF Vendor.GET(OldAssociateLoginDetails.Associate_ID) THEN BEGIN

                        CLEAR(WebAppService);
                        RegionwiseVendor.RESET;
                        RegionwiseVendor.SETCURRENTKEY(RegionwiseVendor."No.");
                        RegionwiseVendor.SETRANGE("No.", Vendor."No.");
                        IF RegionwiseVendor.FINDFIRST THEN;
                        RankCodeMaster.RESET;
                        RankCodeMaster.SETRANGE("Rank Batch Code", RegionwiseVendor."Region Code");
                        RankCodeMaster.SETRANGE(Code, RegionwiseVendor."Rank Code");
                        IF RankCodeMaster.FINDFIRST THEN;
                        IF Vendor."BBG Black List" THEN
                            AssStatus := 'Deactivate'
                        ELSE
                            AssStatus := 'Active';

                        //ALLEDK 160922
                        IF Vendor."BBG Team Code" = '' THEN BEGIN
                            WRegionwiseVendor.RESET;
                            WRegionwiseVendor.SETRANGE("No.", Vendor."No.");
                            WRegionwiseVendor.SETFILTER("Region Code", '<>%1', '');
                            IF WRegionwiseVendor.FINDFIRST THEN BEGIN
                                CLEAR(AssociateTeamforGamifiction);
                                AssociateTeamforGamifiction.ReportValues(Vendor."No.", WRegionwiseVendor."Region Code");
                                AssociateTeamforGamifiction.RUNMODAL;
                            END;
                        END;



                        WebAppService.Post_data('', Vendor."No.", Vendor.Name, Vendor."BBG Mob. No.", Vendor."E-Mail", Vendor."BBG Team Code", Vendor."BBG Leader Code", RegionwiseVendor."Parent Code",
                  FORMAT(AssStatus), FORMAT(RegionwiseVendor."Rank Code"), RankCodeMaster.Description);
                    END;
                END;
                //ALLEDK 221123
                COMMIT;
            UNTIL AssociateLoginDetails.NEXT = 0;
    end;

    var
        AssociateLoginDetails: Record "Associate Login Details";
        VendNo: Code[20];
        Vendor: Record Vendor;
        RegionwiseVendor: Record "Region wise Vendor";
        BondSetup: Record "Unit Setup";
        //NODHeader: Record 13786;
        //NODLine: Record 13785;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        CompanywiseGLAccount: Record "Company wise G/L Account";
        Vend: Record Vendor;
        RecVendorBankAccount: Record "Vendor Bank Account";
        VendorBankAccount: Record "Vendor Bank Account";
        PostPayment: Codeunit PostPayment;
        SMS: Text;
        //SMTPSetup: Record "SMTP Mail Setup";
        //SMTPMail: Codeunit 400;
        CompanyInformation: Record "Company Information";
        IntVender: Record Vendor;
        UserDocumentAttachment: Record "User Document Attachment";
        unitsetup: Record "Unit Setup";
        Filename: Text;
        CreateAssociateSendSMS: Codeunit "Create Associate / SendSMS";
        WebAppService: Codeunit "Web App Service";
        RankCodeMaster: Record "Rank Code";
}

