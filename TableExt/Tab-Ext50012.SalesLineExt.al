tableextension 50012 "BBG Sales Line Ext" extends "Sales Line"
{
    fields
    {
        // Add changes to table fields here
        modify(Type)
        {
            trigger OnAfterValidate()
            begin
                //AEREN03 START
                IF (SalesHeader."Sub Document Type" = SalesHeader."Sub Document Type"::Lease) OR
                   (SalesHeader."Sub Document Type" = SalesHeader."Sub Document Type"::"Lease Property") THEN
                    TESTFIELD(Type, Type::"G/L Account");
                IF (SalesHeader."Sub Document Type" = SalesHeader."Sub Document Type"::Sales) OR
                   (SalesHeader."Sub Document Type" = SalesHeader."Sub Document Type"::"Sale Property") THEN BEGIN
                    SalesHeader.TESTFIELD("Item Code");
                    IF Type = Type::Item THEN
                        VALIDATE("No.", SalesHeader."Item Code");
                END;
                //AEREN03 STOP
            end;
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                ItemL: Record Item;
            Begin
                CASE Type OF
                    Type::"G/L Account":
                        BEGIN
                            //AEREN03 START
                            IF (SalesHeader."Sub Document Type" = SalesHeader."Sub Document Type"::Lease) OR
                               (SalesHeader."Sub Document Type" = SalesHeader."Sub Document Type"::"Lease Property") THEN BEGIN
                                SalesHeader.TESTFIELD("Item Code");
                                ItemL.GET(SalesHeader."Item Code");
                                "Super Area" := ItemL."Super Area (sq ft)";
                                // ProjectPriceDtl.RESET;
                                // ProjectPriceDtl.SETFILTER("Project Code", '%1', ItemL."Job No.");
                                // ProjectPriceDtl.SETRANGE("Project Price Group", ItemL."Project Price Group");
                                // ProjectPriceDtl.SETFILTER("Starting Date", '<=%1', WORKDATE);
                                // IF ProjectPriceDtl.FIND('+') THEN
                                //     "Rate Per Area" := ProjectPriceDtl."Lease Rate (per sq ft)"
                                // ELSE
                                //     "Rate Per Area" := ItemL."Lease Rate (per sq ft)";

                                "Rate Per Area-Final" := "Rate Per Area";
                                "Escalation %" := 0.0;
                                "Unit Price" := "Super Area" * "Rate Per Area-Final"; //lease rent per month
                            END;
                            //AEREN03 STOP
                            //ALLEAA START
                            IF "Document Type" = "Document Type"::Invoice THEN
                                "Job No." := SalesHeader."Job No.";
                            //ALLEAA STOP
                        End;

                    Type::Item:
                        BEGIN
                            //AEREN03 START
                            IF (SalesHeader."Sub Document Type" = SalesHeader."Sub Document Type"::Sales) OR
                               (SalesHeader."Sub Document Type" = SalesHeader."Sub Document Type"::"Sale Property") THEN BEGIN
                                TESTFIELD("No.", SalesHeader."Item Code");

                                //                                         {ProjectPriceDtl.RESET;
                                // ProjectPriceDtl.SETRANGE("Project Code", Item."Job No.");
                                // ProjectPriceDtl.SETFILTER("Project Price Group", '%1', Item."Project Price Group");
                                // ProjectPriceDtl.SETFILTER("Starting Date", '<=%1', WORKDATE);
                                // IF ProjectPriceDtl.FIND('+') THEN
                                //     "Rate Per Area" := ProjectPriceDtl."Sales Rate (per sq ft)"

                                // ELSE
                                //     "Rate Per Area" := Item."Sales Rate (per sq ft)";
                                //                                          }
                                "Super Area" := Item."Super Area (sq ft)";
                                "PLC %" := Item."PLC (%)";
                                VALIDATE(Quantity, 1);

                            END;
                            //AEREN03 STOP
                        End;
                End;
                VALIDATE(Quantity);//AEREN03
            End;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            Begin
                //AEREN03 START
                IF (SalesHeader."Sub Document Type" = SalesHeader."Sub Document Type"::Sales) OR
                  (SalesHeader."Sub Document Type" = SalesHeader."Sub Document Type"::"Sale Property") THEN BEGIN
                    IF (Quantity <> 0) AND (Type = Type::Item) THEN BEGIN

                        "Unit Price" := ("Super Area" * "Rate Per Area") * (1 + ("PLC %" / 100)) / Quantity;
                        VALIDATE("Line Discount %");
                    END;
                END;
                //AEREN03 STOP
            End;
        }
        modify("Responsibility Center")
        {
            TableRelation = "Responsibility Center 1";
        }




        field(50003; "Escalation Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0006 27-07-2007';
            OptionCaption = ' ,Labour,Cement,Steel,Bitumen,POL,Plant & Machinery,Explosives,Detonator,Others';
            OptionMembers = " ",Labour,Cement,Steel,Bitumen,POL,"Plant & Machinery",Explosives,Detonator,Others;
        }

        field(50005; "Present Index"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0006 27-07-2007';
        }
        field(50006; "Base Index"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0006 27-07-2007';
        }
        field(50007; "Escalation Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0006 27-07-2007';
        }
        field(50008; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0016 24-08-2007';
            TableRelation = "BOQ Item"."Entry No.";

            trigger OnValidate()
            var
                JobMst: Record "BOQ Item";
                DimVal: Record "Dimension Value";
            begin
                //ALLESP BCL0016 16-07-2007 Start:
                JobMst.RESET;
                IF JobMst.GET("Job No.", "Entry No.") THEN BEGIN
                    GetSalesHeader;
                    SalesHeader.TESTFIELD("Sell-to Customer No.");
                    Description := JobMst.Description;
                    "Description 2" := JobMst."Description 2";
                    VALIDATE("Unit of Measure Code", JobMst."Base UOM");
                END;
                //ALLESP BCL0016 16-07-2007 End:
            end;
        }
        field(50009; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0024 11-09-2007';
            OptionCaption = ' ,Sent for Approval,Approved,Returned,Rejected';
            OptionMembers = " ","Sent for Approval",Approved,Returned,Rejected;
        }




        field(50014; "Rate Per Area"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
        }
        field(50015; "PLC %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
        }
        field(50016; "Rate Per Area-Final"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
        }
        field(50017; "Escalation %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
        }
        field(50010; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0016 17-07-2007';
            TableRelation = Job;
        }

        field(50020; "Explode Bom Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00 060512';
            Editable = false;
        }




        field(90022; "Phase Code 1"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Upgrade';
        }
        field(90023; "Tender Rate"; Decimal)
        {
            Caption = 'Tender Rate';
            DataClassification = ToBeClassified;
            Description = 'ALLERP KRN0008 18-08-2010:';
        }
        field(90024; "Premium/Discount Amount"; Decimal)
        {
            Caption = 'Premium/Discount Amount';
            DataClassification = ToBeClassified;
            Description = 'ALLERP KRN0008 18-08-2010:';
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
        SalesHeader: Record "Sales Header";
        Text50000: Label 'ENU="has been changed (initial a %1: %2= %3, %4= %5)"';
        Item: Record Item;
}