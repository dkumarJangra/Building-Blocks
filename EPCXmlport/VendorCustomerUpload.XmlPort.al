xmlport 50017 "Vendor/Customer Upload"
{

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'Integer';
                textelement(VFilter)
                {
                }
                textelement(CFilter)
                {
                }
                textelement(SMSText)
                {
                }

                trigger OnPreXmlItem()
                begin
                    LineNo := 10000;
                end;

                trigger OnAfterInsertRecord()
                begin
                    IF VFilter <> '' THEN
                        EVALUATE(VFilter1, VFilter);
                    IF NOT Vend.GET(VFilter) THEN
                        ERROR('Vendor No %1 does not exist', VFilter1);
                    IF CFilter <> '' THEN
                        EVALUATE(CFilter1, CFilter);
                    IF NOT Cust.GET(CFilter) THEN
                        ERROR('Customer No %1 does not exist', CFilter);

                    IF SMSText <> '' THEN
                        EVALUATE(SMSText1, SMSText);

                    CommSMSLine.INIT;
                    CommSMSLine."Document No." := DocNo;
                    CommSMSLine."Line No." := LineNo;
                    CommSMSLine.VALIDATE("SMS Text", SMSText1);
                    CommSMSLine.VALIDATE(Vendor, VFilter);
                    CommSMSLine.VALIDATE(Customer, CFilter);
                    CommSMSLine.Status := CommSMSLine.Status::Open;
                    CommSMSLine.INSERT;
                    LineNo += 10000;
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

    var
        Vend: Record "Vendor";
        Cust: Record "Customer";
        CommSMSLine: Record "Common SMS Line";
        VFilter1: Code[250];
        CFilter1: Code[250];
        SMSText1: Text[250];
        CommSMSLast: Record "Common SMS Line";
        LineNo: Integer;
        DocNo: Integer;


    procedure SetNo(var DocumentNo: Integer)
    begin
        DocNo := DocumentNo;
    end;
}

