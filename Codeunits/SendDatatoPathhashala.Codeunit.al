codeunit 50007 "Send Data to Pathhashala"
{

    trigger OnRun()
    begin
        SendAssociateDatatoPathhashala;
    end;

    var
        Vendor: Record Vendor;
        WebAppService: Codeunit "Data Push to Pathsala";
        VendorFilters: Text;
        AssociateLoginDetails: Record "Associate Login Details";

    local procedure SendAssociateDatatoPathhashala()
    begin

        AssociateLoginDetails.RESET;
        //AssociateLoginDetails.SETRANGE(AssociateLoginDetails.USER_ID,71000,75000);
        AssociateLoginDetails.SETRANGE(Status, AssociateLoginDetails.Status::Approved);
        AssociateLoginDetails.SETRANGE("Send Data to Pathsala", FALSE);
        AssociateLoginDetails.SETFILTER(Associate_ID, '<>%1', '');
        AssociateLoginDetails.SETFILTER(Password, '<>%1', '');
        IF AssociateLoginDetails.FINDSET THEN BEGIN
            VendorFilters := '';
            REPEAT
                Vendor.RESET;
                IF Vendor.GET(AssociateLoginDetails.Associate_ID) THEN BEGIN
                    IF NOT Vendor."BBG Black List" THEN BEGIN
                        CLEAR(WebAppService);
                        WebAppService.SetVendValue(AssociateLoginDetails.Associate_ID);
                        IF NOT WebAppService.RUN THEN BEGIN
                        END ELSE BEGIN
                            AssociateLoginDetails."Send Data to Pathsala" := TRUE;
                            AssociateLoginDetails.MODIFY;
                        END;
                    END;
                END;
                COMMIT;
            UNTIL AssociateLoginDetails.NEXT = 0;

        END;
        MESSAGE('%1', 'Done');
    end;
}

