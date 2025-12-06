xmlport 50103 "Project MIS Sum. Data Upload"
{
    Caption = 'Project MIS Summary Data Upload';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                AutoSave = false;
                XmlName = 'Integer';

                textelement(ProjectCode)
                {
                }
                textelement(ProjectCreationDt)
                {
                }
                textelement(ClusterName)
                {
                }
                textelement(DeedLLPName)
                {
                }
                textelement(BankAPF)
                {
                }
                textelement(BankLoanProject)
                {
                }
                textelement(DraftLPNo)
                {
                }
                textelement(ExtentLayoutAcres)
                {
                }
                textelement(ExtentLayoutGuntas)
                {
                }
                textelement(ApprovalType)
                {
                }
                textelement(ProjectType)
                {
                }
                textelement(Village)
                {
                }
                textelement(Rerano)
                {
                }
                textelement(ReraFrom)
                {
                }
                textelement(ReraTo)
                {
                }
                textelement(ReraRegistrationDt)
                {
                }

                textelement(ReraExpiryDt)
                {
                }
                textelement(FinalLayout)
                {
                }
                textelement(BankAPFPerSquardValue)
                {
                }
                textelement(PurchasingLLPName)
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    SNo := SNo + 1;
                    IF SNo > 1 THEN BEGIN
                        job.RESET;
                        job.SetRange("No.", ProjectCode);
                        If job.FindFirst() then begin
                            Evaluate(job."Project Creation Date", ProjectCreationDt);
                            job."Cluster Name" := ClusterName;
                            job."Deed LLp Name" := DeedLLPName;
                            if (BankAPF = 'TRUE') OR (BankAPF = 'true') then
                                job."Bank APF" := true
                            ELSE
                                job."Bank APF" := false;
                            If (BankLoanProject = 'true') OR (BankLoanProject = 'TRUE') then
                                job."Bank Loan Project" := true
                            ELSE
                                job."Bank Loan Project" := false;


                            job."Draft LP No" := DraftLPNo;
                            Evaluate(job."Extent of Layout (Acres)", ExtentLayoutAcres);
                            Evaluate(job."Extent of Layout(Guntas/Cents)", ExtentLayoutGuntas);

                            job."Approval Type 1" := ApprovalType;

                            job."Project Type" := ProjectType;
                            job.Village := Village;
                            job."Rera No" := Rerano;
                            Evaluate(job."Rera From", ReraFrom);
                            Evaluate(job."Rera To", ReraTo);
                            Evaluate(job."RERA Registration Date", ReraRegistrationDt);
                            Evaluate(job."RERA Expire Date", ReraExpiryDt);
                            IF (FinalLayout = 'TRUE') OR (FinalLayout = 'true') then
                                job."Final Layout (OC)" := true
                            ELSE
                                job."Final Layout (OC)" := false;


                            Evaluate(job."Bank APF PER SQYD VALUE", BankAPFPerSquardValue);
                            job."Purchasing LLP Name" := PurchasingLLPName;
                            job.Modify;
                        end;
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
        MESSAGE('%1', 'Process Done');
    end;

    var

        SNo: Integer;
        job: Record job;
}

