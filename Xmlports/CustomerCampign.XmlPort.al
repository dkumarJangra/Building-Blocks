xmlport 50039 "Customer Campign"
{
    Direction = Import;
    //Encoding = UTF8;
    Format = VariableText;
    TextEncoding = UTF8;

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                AutoSave = false;
                XmlName = 'Integer';
                textelement(Name)
                {
                }
                textelement(EMail)
                {
                }
                textelement(PhoneNo)
                {
                }
                textelement(Typeofproperty)
                {
                }
                textelement(Medium)
                {
                }
                textelement(Source)
                {
                }
                textelement(Campiagn)
                {
                }
                textelement(Adgroup)
                {
                }
                textelement(Terms)
                {
                }
                textelement(LandingPage)
                {
                }
                textelement(LeadRelevance)
                {
                }
                textelement(AppointmentStatus)
                {
                }
                textelement(LeadConverted)
                {
                }

                trigger OnAfterInsertRecord()
                var
                    BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
                begin
                end;

                trigger OnBeforeInsertRecord()
                begin
                    Sno := Sno + 1;
                    IF Sno > 1 THEN BEGIN
                        CustomerCampiagn.RESET;
                        IF CustomerCampiagn.FINDLAST THEN
                            EntryNo := CustomerCampiagn."Entry No." + 1
                        ELSE
                            EntryNo := 1;

                        CustomerCampiagn.RESET;
                        CustomerCampiagn.INIT;
                        CustomerCampiagn."Entry No." := EntryNo;
                        CustomerCampiagn."Submitted At" := CURRENTDATETIME;
                        CustomerCampiagn.Name := Name;
                        CustomerCampiagn."E-Mail" := EMail;
                        CustomerCampiagn."Phone No." := PhoneNo;
                        CustomerCampiagn."Type of Property" := Typeofproperty;
                        CustomerCampiagn.Medium := Medium;
                        CustomerCampiagn.Source := Source;
                        CustomerCampiagn.Campiagn := Campiagn;
                        CustomerCampiagn."Ad group" := Adgroup;
                        CustomerCampiagn.Term := Terms;
                        CustomerCampiagn."Landing Page" := LandingPage;
                        CustomerCampiagn."Lead Relevance" := LeadRelevance;
                        CustomerCampiagn."Appointment Status" := AppointmentStatus;
                        CustomerCampiagn."Lead Converted" := LeadConverted;
                        CustomerCampiagn.INSERT;
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

    var
        CustomerCampiagn: Record "Customer Campiagn";
        EntryNo: Integer;
        Sno: Integer;
}

