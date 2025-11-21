tableextension 97034 "EPC Responsibility Center Ext" extends "Responsibility Center"
{
    fields
    {
        // Add changes to table fields here
        field(50016; "Company Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Company;
        }
        field(50014; "Active Projects"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                RespCenter: Record "Responsibility Center 1";
            begin
                CompanyWise.RESET;
                CompanyWise.SETRANGE("MSC Company", TRUE);
                IF CompanyWise.FINDFIRST THEN BEGIN
                    IF CompanyWise."Company Code" <> COMPANYNAME THEN BEGIN
                        RespCenter.RESET;
                        RespCenter.CHANGECOMPANY(CompanyWise."Company Code");
                        RespCenter.SETRANGE(Code, Code);
                        IF RespCenter.FINDFIRST THEN BEGIN
                            RespCenter."Active Projects" := "Active Projects";
                            RespCenter.MODIFY;
                        END;
                    END;
                END;
            end;
        }
        field(50007; Branch; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAT 181012';
            TableRelation = Location.Code WHERE("BBG Branch" = FILTER(true));

            trigger OnValidate()
            begin
                IF BranchName.GET(Branch) THEN
                    "Branch Name" := BranchName.Name
                ELSE
                    "Branch Name" := '';
            end;
        }
        field(50009; "Branch Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleAD:BBG01.00:191112';
        }
        field(50022; Trading; Boolean)
        {
            CalcFormula = Lookup(Job.Trading WHERE("No." = FIELD(Code)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
        CompanyWise: Record "Company wise G/L Account";
        BranchName: Record Location;
}