xmlport 97781 "Unit allotment"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Unit Master"; "Unit Master")
            {
                AutoSave = false;
                XmlName = 'UnitMaster';
                textelement(ProjectCode)
                {
                }
                textelement(UnitID)
                {
                }
                textelement(Extent)
                {
                }
                textelement(PaymentPlan)
                {
                }
                textelement(MinAllotment)
                {
                }
                textelement(SizeEast)
                {
                }
                textelement(SizeWest)
                {
                }
                textelement(SizeNorth)
                {
                }
                textelement(SizeSouth)
                {
                }
                textelement(NoofIncentive)
                {
                }

                trigger OnAfterGetRecord()
                begin

                    "Unit Master".SETRANGE("Project Code", PCode); //PCode);
                    "Unit Master".SETRANGE(Status, "Unit Master".Status::Open);

                    ProjectCode := "Unit Master"."Project Code";
                    UnitID := "Unit Master"."No.";
                    Extent := FORMAT("Unit Master"."Saleable Area");
                    PaymentPlan := "Unit Master"."Payment Plan";
                    MinAllotment := FORMAT("Unit Master"."Min. Allotment Amount");
                    SizeEast := FORMAT("Unit Master"."Size-East");
                    SizeWest := FORMAT("Unit Master"."Size-West");
                    SizeNorth := FORMAT("Unit Master"."Size-North");
                    SizeSouth := FORMAT("Unit Master"."Size-South");
                    NoofIncentive := FORMAT("Unit Master"."No. of Plots for Incentive Cal");
                end;

                trigger OnAfterInsertRecord()
                begin
                    UnitMaster.RESET;
                    UnitMaster.SETRANGE("Project Code", ProjectCode);
                    UnitMaster.SETRANGE("No.", UnitID);
                    EVALUATE(Extent1, Extent);
                    UnitMaster.SETRANGE("Saleable Area", Extent1);
                    UnitMaster.SETRANGE("Payment Plan", PaymentPlan);
                    UnitMaster.SETRANGE(Status, UnitMaster.Status::Open);
                    IF UnitMaster.FINDFIRST THEN BEGIN
                        IF MinAllotment <> '' THEN
                            EVALUATE(MinAllotment1, MinAllotment);
                        IF SizeEast <> '' THEN
                            EVALUATE(SizeEast1, SizeEast);
                        IF SizeWest <> '' THEN
                            EVALUATE(SizeWest1, SizeWest);
                        IF SizeNorth <> '' THEN
                            EVALUATE(SizeNorth1, SizeNorth);
                        IF NoofIncentive <> '' THEN
                            EVALUATE(NoofIncentive1, NoofIncentive);
                        IF SizeSouth <> '' THEN
                            EVALUATE(SizeSouth1, SizeSouth);
                        UnitMaster."Min. Allotment Amount" := MinAllotment1;

                        UnitMaster."Size-East" := SizeEast1;
                        UnitMaster."Size-West" := SizeWest1;
                        UnitMaster."Size-North" := SizeNorth1;
                        UnitMaster."Size-South" := SizeSouth1;
                        UnitMaster."No. of Plots for Incentive Cal" := NoofIncentive1;
                        UnitMaster.MODIFY;
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
        Extent1: Decimal;
        UnitMaster: Record "Unit Master";
        PCode: Code[20];
        Companywise: Record "Company wise G/L Account";
        NewUMaster: Record "Unit Master";
        MinAllotment1: Decimal;
        SizeEast1: Decimal;
        SizeWest1: Decimal;
        SizeNorth1: Decimal;
        SizeSouth1: Decimal;
        NoofIncentive1: Decimal;


    procedure SetProject(var "code": Code[20])
    begin
        PCode := code;
    end;
}

