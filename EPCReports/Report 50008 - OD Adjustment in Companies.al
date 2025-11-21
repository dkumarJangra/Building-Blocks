report 50008 "OD Adjustment in Companies"
{
    // version Done

    DefaultLayout = RDLC;
    RDLCLayout = './Reports/OD Adjustment in Companies.rdl';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Associate OD Ajustment Entry"; "Associate OD Ajustment Entry")
        {
            DataItemTableView = WHERE("Sinking Process Done" = FILTER(false));

            trigger OnAfterGetRecord()
            begin
                IF ("Posted in From Company Name") AND ("Posted in To Company Name") THEN BEGIN
                    "Associate OD Ajustment Entry"."Sinking Process Done" := TRUE;
                    MODIFY;
                END;

                IF "Associate OD Ajustment Entry"."From Company Name" = COMPANYNAME THEN BEGIN
                    IF NOT "Posted in From Company Name" THEN BEGIN
                        Postpayment.PostAssODAdjustFromComp("Associate OD Ajustment Entry");
                    END;
                END;
                IF "Associate OD Ajustment Entry"."To Company Name" = COMPANYNAME THEN BEGIN
                    IF NOT "Posted in To Company Name" THEN BEGIN
                        Postpayment.PostAssODAdjustToComp("Associate OD Ajustment Entry");
                    END;
                END;
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

    var
        Postpayment: Codeunit PostPayment;

}

