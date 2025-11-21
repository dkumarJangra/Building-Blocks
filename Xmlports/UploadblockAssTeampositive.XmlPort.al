xmlport 97751 "Upload block Ass Team positive"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                AutoSave = false;
                XmlName = 'Integer';
                textelement(AssociateCode)
                {
                }
                textelement(Blocks)
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    RecVendor.RESET;
                    RecVendor.SETRANGE("No.", AssociateCode);
                    IF RecVendor.FINDFIRST THEN BEGIN
                        IF Blocks = 'TRUE' THEN
                            RecVendor."BBG Ass.Block forteam Pos. Report" := TRUE
                        ELSE
                            RecVendor."BBG Ass.Block forteam Pos. Report" := FALSE;
                        RecVendor.MODIFY;
                    END;
                end;
            }
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

    trigger OnPostXmlPort()
    begin
        MESSAGE('%1', 'Data Upload');
    end;

    trigger OnPreXmlPort()
    begin
        CompanywiseGLAccount.RESET;
        CompanywiseGLAccount.SETRANGE("MSC Company", TRUE);
        IF CompanywiseGLAccount.FINDFIRST THEN
            IF COMPANYNAME <> CompanywiseGLAccount."Company Code" THEN
                ERROR('Upload data from -' + CompanywiseGLAccount."Company Code");
    end;

    var
        Text001: Label 'Delete existing applicable charges.';
        Text002: Label 'Please define first Payment Plan Code on Project %1.';
        Text003: Label 'Please define first Charges on Project %1.';
        RecVendor: Record Vendor;
        CompanywiseGLAccount: Record "Company wise G/L Account";
}

