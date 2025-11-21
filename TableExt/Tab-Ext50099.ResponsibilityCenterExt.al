tableextension 50099 "BBG Responsibility Center Ext" extends "Responsibility Center"
{
    fields
    {
        // Add changes to table fields here
        modify("Global Dimension 1 Code")
        {
            trigger OnAfterValidate()
            begin
                //dds - added to have dim name
                GLSetup.GET;
                DimValue.RESET;
                DimValue.SETRANGE(DimValue."Dimension Code", GLSetup."Global Dimension 1 Code");
                DimValue.SETRANGE(DimValue.Code, "Global Dimension 1 Code");
                IF DimValue.FIND('-') THEN BEGIN
                    "Region Name" := DimValue.Name;
                END;
            end;
        }
        modify("Location Code")
        {
            trigger OnAfterValidate()
            begin
                //dds - added to have dim name
                LocValue.RESET;
                LocValue.SETRANGE(Code, "Location Code");
                IF LocValue.FIND('-') THEN BEGIN
                    "Location Name" := LocValue.Name;
                END;
            end;
        }
        field(50000; "Region Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'dds - region dim code name';
            Editable = false;
        }
        field(50001; "Location Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'dds - location code name';
            Editable = false;
        }
        field(50002; "Job Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB005';
            TableRelation = Job;
        }
        field(50003; Blocked; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB014';
        }
        field(50005; "Subcon/Site Location"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00';
            TableRelation = Location.Code WHERE("BBG Use As Subcon/Site Location" = CONST(true));
        }
        field(50006; Division; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 231211';
            Editable = true;
        }

        field(50008; "Incentive Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEPG 061112';
            TableRelation = "Incentive Header";
        }

        field(50010; Published; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'BBG1.00 26/03/13';
        }
        field(50011; "Sequence of Project"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50012; Picture; BLOB)
        {
            Caption = 'Picture';
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(50013; "Full Name"; Text[80])
        {
            DataClassification = ToBeClassified;
        }


        field(50017; "Fields Not Show on Receipt"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "Publish Plot Cost"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("Company Name");
                CompanyWise.RESET;
                CompanyWise.SETRANGE(CompanyWise."MSC Company", TRUE);
                IF CompanyWise.FINDFIRST THEN BEGIN
                    IF CompanyWise."Company Code" = COMPANYNAME THEN BEGIN
                        NewConfOrder.RESET;
                        NewConfOrder.CHANGECOMPANY("Company Name");
                        NewConfOrder.SETCURRENTKEY(NewConfOrder."Shortcut Dimension 1 Code");
                        NewConfOrder.SETRANGE("Shortcut Dimension 1 Code", Code);
                        NewConfOrder.SETFILTER("Unit Code", '<>%1', '');
                        IF NewConfOrder.FINDSET THEN
                            REPEAT
                                IF "Publish Plot Cost" THEN BEGIN
                                    UnitMaster.RESET;
                                    UnitMaster.SETRANGE("Project Code", Code);
                                    UnitMaster.SETRANGE("No.", NewConfOrder."Unit Code");
                                    IF UnitMaster.FINDFIRST THEN BEGIN
                                        UnitMaster."Plot Cost" := UnitMaster."Total Value";
                                        UnitMaster.MODIFY;
                                    END;
                                END ELSE BEGIN
                                    UnitMaster.RESET;
                                    UnitMaster.SETRANGE("Project Code", Code);
                                    UnitMaster.SETRANGE("No.", NewConfOrder."Unit Code");
                                    IF UnitMaster.FINDFIRST THEN BEGIN
                                        UnitMaster."Plot Cost" := 0;
                                        UnitMaster.MODIFY;
                                    END;
                                END;
                            UNTIL NewConfOrder.NEXT = 0;
                    END ELSE
                        ERROR('This process will be done from MScompany');
                END;
                MESSAGE('%1', 'Records Updated');
            end;
        }
        field(50019; "Publish CustomerName"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("Company Name");
                CompanyWise.RESET;
                CompanyWise.SETRANGE(CompanyWise."MSC Company", TRUE);
                IF CompanyWise.FINDFIRST THEN BEGIN
                    IF CompanyWise."Company Code" = COMPANYNAME THEN BEGIN
                        NewConfOrder.RESET;
                        NewConfOrder.CHANGECOMPANY("Company Name");
                        NewConfOrder.SETCURRENTKEY(NewConfOrder."Shortcut Dimension 1 Code");
                        NewConfOrder.SETRANGE("Shortcut Dimension 1 Code", Code);
                        NewConfOrder.SETFILTER("Unit Code", '<>%1', '');
                        NewConfOrder.SETRANGE(Status, NewConfOrder.Status::Registered);
                        IF NewConfOrder.FINDSET THEN
                            REPEAT
                                IF "Publish CustomerName" THEN BEGIN
                                    IF NewConfOrder."Registration In Favour Of" <> '' THEN BEGIN
                                        UnitMaster.RESET;
                                        UnitMaster.SETRANGE("Project Code", Code);
                                        UnitMaster.SETRANGE("No.", NewConfOrder."Unit Code");
                                        IF UnitMaster.FINDFIRST THEN BEGIN
                                            UnitMaster."Customer Name" := NewConfOrder."Registration In Favour Of";
                                            UnitMaster."Customer Code" := NewConfOrder."Customer No.";
                                            UnitMaster."Unit Registered" := TRUE;
                                            UnitMaster.MODIFY;
                                        END;
                                    END;
                                END ELSE BEGIN
                                    UnitMaster.RESET;
                                    UnitMaster.SETRANGE("Project Code", Code);
                                    UnitMaster.SETRANGE("No.", NewConfOrder."Unit Code");
                                    IF UnitMaster.FINDFIRST THEN BEGIN
                                        UnitMaster."Customer Name" := '';
                                        UnitMaster."Unit Registered" := FALSE;
                                        UnitMaster.MODIFY;
                                    END;
                                END;
                            UNTIL NewConfOrder.NEXT = 0;
                    END ELSE
                        ERROR('This process will be done from MScompany');
                END;
                MESSAGE('%1', 'Records Updated');
            end;
        }
        field(50020; "Publish Registration No."; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("Company Name");
                CompanyWise.RESET;
                CompanyWise.SETRANGE(CompanyWise."MSC Company", TRUE);
                IF CompanyWise.FINDFIRST THEN BEGIN
                    IF CompanyWise."Company Code" = COMPANYNAME THEN BEGIN
                        NewConfOrder.RESET;
                        NewConfOrder.CHANGECOMPANY("Company Name");
                        NewConfOrder.SETCURRENTKEY(NewConfOrder."Shortcut Dimension 1 Code");
                        NewConfOrder.SETRANGE("Shortcut Dimension 1 Code", Code);
                        NewConfOrder.SETFILTER("Unit Code", '<>%1', '');
                        NewConfOrder.SETRANGE(Status, NewConfOrder.Status::Registered);
                        IF NewConfOrder.FINDSET THEN
                            REPEAT
                                IF "Publish Registration No." THEN BEGIN
                                    IF NewConfOrder."Registration No." <> '' THEN BEGIN
                                        UnitMaster.RESET;
                                        UnitMaster.SETRANGE("Project Code", Code);
                                        UnitMaster.SETRANGE("No.", NewConfOrder."Unit Code");
                                        IF UnitMaster.FINDFIRST THEN BEGIN
                                            UnitMaster."Registration No." := NewConfOrder."Registration No.";
                                            UnitMaster."Unit Registered" := TRUE;
                                            UnitMaster.MODIFY;
                                        END;
                                    END;
                                END ELSE BEGIN
                                    UnitMaster.RESET;
                                    UnitMaster.SETRANGE("Project Code", Code);
                                    UnitMaster.SETRANGE("No.", NewConfOrder."Unit Code");
                                    IF UnitMaster.FINDFIRST THEN BEGIN
                                        UnitMaster."Registration No." := '';
                                        UnitMaster."Unit Registered" := FALSE;
                                        UnitMaster.MODIFY;
                                    END;
                                END;
                            UNTIL NewConfOrder.NEXT = 0;
                    END ELSE
                        ERROR('This process will be done from MScompany');
                END;
                MESSAGE('%1', 'Records Updated');
            end;
        }
        field(50021; "Ref. Company Code"; Text[30])
        {
            DataClassification = ToBeClassified;
        }

        field(50023; "Non-Trading"; Boolean)
        {
            CalcFormula = Lookup(Job."Non-Trading" WHERE("No." = FIELD(Code)));
            FieldClass = FlowField;
        }
        field(50024; "Print Image on Reciept"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50025; "Publish CustomerName on Rcpt"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50026; "Project Bank Account No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50027; "Project Bank IFSC Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50028; "Project Branch Name"; Text[100])
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
        DimValue: Record "Dimension Value";
        LocValue: Record Location;
        BranchName: Record Location;
        GLSetup: Record "General Ledger Setup";
        CompanyWise: Record "Company wise G/L Account";
        UnitMaster: Record "Unit Master";
        NewConfOrder: Record "Confirmed Order";
        Cust: Record Customer;
        UnitMasterLLP: Record "Unit Master";
}