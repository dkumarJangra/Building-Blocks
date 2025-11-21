tableextension 50077 "BBG Dimension Value Ext" extends "Dimension Value"
{
    fields
    {
        // Add changes to table fields here
        modify(Code)
        {
            trigger OnAfterValidate()
            begin
                //------------For MSC Company
                GLSetup.GET;
                IF "Dimension Code" = GLSetup."Shortcut Dimension 1 Code" THEN BEGIN
                    ResRec.RESET;
                    CompanywiseGLAccount.RESET;
                    CompanywiseGLAccount.SETRANGE(CompanywiseGLAccount."MSC Company", TRUE);
                    IF CompanywiseGLAccount.FINDFIRST THEN;
                    ResRec.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                    ResRec.SETRANGE(Code, Code);
                    IF ResRec.FINDFIRST THEN
                        ERROR('The Project code already defined in company-' + ResRec."Company Name");
                END;
                //------------For MSC Company
            end;
        }
        modify(Name)
        {
            trigger OnAfterValidate()
            begin
                //BBG2.01 201214
                GLSetup.GET;
                IF "Dimension Code" = GLSetup."Shortcut Dimension 1 Code" THEN BEGIN
                    Company.RESET;
                    IF Company.FINDSET THEN
                        REPEAT
                            IF COMPANYNAME <> Company.Name THEN BEGIN
                                RecDimValue.RESET;
                                RecDimValue.CHANGECOMPANY(Company.Name);
                                RecDimValue.SETRANGE("Dimension Code", "Dimension Code");
                                RecDimValue.SETRANGE(Code, Code);
                                IF RecDimValue.FINDFIRST THEN BEGIN
                                    RecDimValue.Name := Name;
                                    RecDimValue.MODIFY;
                                END;
                            END;
                            RecJob.RESET;
                            RecJob.CHANGECOMPANY(Company.Name);
                            RecJob.SETRANGE("No.", Code);
                            IF RecJob.FINDFIRST THEN BEGIN
                                RecJob.Description := Name;
                                RecJob.MODIFY;
                            END;

                            RecLoc.RESET;
                            RecLoc.CHANGECOMPANY(Company.Name);
                            RecLoc.SETRANGE(Code, Code);
                            IF RecLoc.FINDFIRST THEN BEGIN
                                RecLoc.Name := Name;
                                RecLoc.MODIFY;
                            END;
                            RecRespCenter.RESET;
                            RecRespCenter.CHANGECOMPANY(Company.Name);
                            RecRespCenter.SETRANGE(Code, Code);
                            IF RecRespCenter.FINDFIRST THEN BEGIN
                                RecRespCenter.Name := Name;
                                RecRespCenter.MODIFY;
                            END;
                        UNTIL Company.NEXT = 0;
                END;
                //BBG2.01 201214
            end;
        }
        field(50000; "Region Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Mes-seema: added to filter cost centre dimension List as per selection of Plant Code';
        }
        field(50001; "GL Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'JPL0001 : Default GL Code for each Cost center Dimension';
            TableRelation = "G/L Account";
        }

        field(55000; "Default Dim. Value Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            TableRelation = "Dimension Value".Code;

            trigger OnLookup()
            var
                Dim: Record Dimension;
                DimValue: Record "Dimension Value";
            begin
                //ALLENIT01 <<
                Dim.GET("Dimension Code");
                IF Dim."Def. Dimension Code" <> '' THEN BEGIN
                    DimValue.RESET;
                    DimValue.SETRANGE("Dimension Code", Dim."Def. Dimension Code");
                    IF PAGE.RUNMODAL(0, DimValue) = ACTION::LookupOK THEN
                        "Default Dim. Value Code" := DimValue.Code;
                END;
                //ALLENIT01 >>
            end;
        }
        field(55001; "Auto Insert Default"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
        }


        field(55004; "Brand Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('BRAND'));
        }

        field(55006; "Old Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(55007; Trading; Boolean)
        {
            CalcFormula = Lookup(Job.Trading WHERE("No." = FIELD(Code)));
            FieldClass = FlowField;
        }
        field(55008; "Non Trading"; Boolean)
        {
            CalcFormula = Lookup(Job."Non-Trading" WHERE("No." = FIELD(Code)));
            FieldClass = FlowField;
        }
        field(55009; "Name 2"; Text[50])
        {
            DataClassification = ToBeClassified;
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
        GLSetup: Record "General Ledger Setup";
        ResRec: Record "Responsibility Center 1";
        CompanywiseGLAccount: Record "Company wise G/L Account";
        RecDimValue: Record "Dimension Value";
        RecJob: Record Job;
        RecLoc: Record Location;
        RecRespCenter: Record "Responsibility Center 1";
        Company: Record Company;
}