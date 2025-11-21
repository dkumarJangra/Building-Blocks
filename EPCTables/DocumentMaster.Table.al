table 97753 "Document Master"
{
    DataCaptionFields = "Document Type", "Code", Description;
    DataPerCompany = false;
    DrillDownPageID = "Document Master";
    LookupPageID = "Document Master";

    fields
    {
        field(1; "Code"; Code[20])
        {
            TableRelation = "Unit Charge & Payment Pl. Code";

            trigger OnValidate()
            begin
                IF Code <> '' THEN
                    IF NOT UnitChargePaymentCode.GET(Code) THEN;
                //    ERROR('Please define the Code on This Table Unit Charge & Payment Pl. Code');
            end;
        }
        field(2; "Document Type"; Option)
        {
            OptionCaption = ',Unit,Zone,Charge,Brand,Payment Plan,Co-Applicants,Project Price Groups';
            OptionMembers = ,Unit,Zone,Charge,Brand,"Payment Plan","Co-Applicants","Project Price Groups";
        }
        field(3; Description; Text[30])
        {
        }
        field(4; "Project Code"; Code[20])
        {
            TableRelation = "Responsibility Center 1";
        }
        field(5; "Rate/Sq. Yd"; Decimal)
        {
            DecimalPlaces = 0 : 4;

            trigger OnValidate()
            begin
                IF Code = 'OTH' THEN
                    ERROR('The CODE-OTH is used only roundoff');

                TotalValue := 0;
                FixedValue := 0;
                CalDocMaster.RESET;
                CalDocMaster.SETCURRENTKEY("Document Type", "Project Code", Code, "Sale/Lease", "Unit Code", "App. Charge Code");
                CalDocMaster.SETRANGE("Project Code", "Project Code");
                CalDocMaster.SETRANGE("Unit Code", "Unit Code");
                IF CalDocMaster.FINDFIRST THEN
                    REPEAT
                        IF CalDocMaster.Code <> Code THEN BEGIN
                            TotalValue := TotalValue + CalDocMaster."Rate/Sq. Yd";
                            FixedValue := FixedValue + CalDocMaster."Fixed Price";
                        END ELSE BEGIN
                            TotalValue := TotalValue + "Rate/Sq. Yd";
                            FixedValue := FixedValue + "Fixed Price";
                        END;
                    UNTIL CalDocMaster.NEXT = 0;



                UnitMaster.RESET;
                UnitMaster.SETRANGE("No.", "Unit Code");
                UnitMaster.SETRANGE("Project Code", "Project Code");
                IF UnitMaster.FINDFIRST THEN BEGIN
                    // UnitMaster."Total Value" := FixedValue + (TotalValue * UnitMaster."Saleable Area");
                    // UnitMaster.MODIFY;
                    "Total Charge Amount" := UnitMaster."Saleable Area" * "Rate/Sq. Yd"; //ALLEDK 240113
                END;
            end;
        }
        field(6; "Fixed Price"; Decimal)
        {
            DecimalPlaces = 0 : 4;

            trigger OnValidate()
            begin
                TotalValue := 0;
                FixedValue := 0;
                CalDocMaster.RESET;
                CalDocMaster.SETCURRENTKEY("Document Type", "Project Code", Code, "Sale/Lease", "Unit Code", "App. Charge Code");
                CalDocMaster.SETRANGE("Project Code", "Project Code");
                CalDocMaster.SETRANGE("Unit Code", "Unit Code");
                IF CalDocMaster.FINDFIRST THEN
                    REPEAT
                        IF CalDocMaster.Code <> Code THEN BEGIN
                            TotalValue := TotalValue + CalDocMaster."Rate/Sq. Yd";
                            FixedValue := FixedValue + CalDocMaster."Fixed Price";
                        END ELSE BEGIN
                            TotalValue := TotalValue + "Rate/Sq. Yd";
                            FixedValue := FixedValue + "Fixed Price";
                        END;
                    UNTIL CalDocMaster.NEXT = 0;

                UnitMaster.RESET;
                UnitMaster.SETRANGE("No.", "Unit Code");
                UnitMaster.SETRANGE("Project Code", "Project Code");
                IF UnitMaster.FINDFIRST THEN BEGIN
                    // UnitMaster."Total Value" := FixedValue + (TotalValue * UnitMaster."Saleable Area");
                    //  UnitMaster.MODIFY;
                    "Total Charge Amount" := "Fixed Price"; //ALLEDK 240113
                END;
            end;
        }
        field(7; "BP Dependency"; Boolean)
        {
        }
        field(8; "Rate Not Allowed"; Boolean)
        {
        }
        field(9; "Project Price Dependency Code"; Code[20])
        {
            TableRelation = "Document Master".Code WHERE("Document Type" = FILTER("Project Price Groups"),
                                                          "Project Code" = FIELD("Project Code"),
                                                          "Sale/Lease" = FIELD("Sale/Lease"));
        }
        field(10; "Payment Plan Type"; Option)
        {
            OptionCaption = ' ,Construction Linked,Down Payment,Time Linked,Special,Others';
            OptionMembers = " ","Construction Linked","Down Payment","Time Linked",Special,Others;
        }
        field(11; "Sale/Lease"; Option)
        {
            OptionCaption = ' ,Sale,Lease';
            OptionMembers = " ",Sale,Lease;
        }
        field(16; "Commision Applicable"; Boolean)
        {
        }
        field(17; "Direct Associate"; Boolean)
        {
        }
        field(18; Sequence; Integer)
        {

            trigger OnValidate()
            begin
                IF Sequence > 0 THEN BEGIN
                    RecDocMaster.RESET;
                    RecDocMaster.SETRANGE("Document Type", "Document Type");
                    RecDocMaster.SETRANGE("Project Code", "Project Code");
                    RecDocMaster.SETFILTER(Code, '<>%1', Code);
                    RecDocMaster.SETRANGE(Sequence, Sequence);
                    RecDocMaster.SETRANGE("Unit Code", "Unit Code");
                    RecDocMaster.SETRANGE("Fixed Price", 0);
                    IF RecDocMaster.FINDFIRST THEN
                        ERROR('You have already assigned this sequence no in another Code =' + RecDocMaster.Code);
                END;
            end;
        }
        field(19; "Unit Code"; Code[20])
        {
            TableRelation = "Unit Master";
        }
        field(20; "Membership Fee"; Boolean)
        {
        }
        field(50000; "App. Charge Code"; Code[20])
        {
            TableRelation = "App. Charge Code";

            trigger OnValidate()
            begin
                IF "App. Charge Code" <> '' THEN
                    IF APPCharge.GET("App. Charge Code") THEN BEGIN
                        "App. Charge Name" := APPCharge.Description;
                        "Sub Payment Plan" := APPCharge."Sub Payment Plan";
                        "Sub Sub Payment Plan Code" := APPCharge."Sub Sub Payment Plan Code";
                        IF APPCharge."Default Payment Plan" THEN
                            "Sub Payment Plan" := FALSE;
                    END ELSE BEGIN
                        "App. Charge Name" := '';
                        "Sub Payment Plan" := FALSE;
                    END;
            end;
        }
        field(50001; "App. Charge Name"; Text[60])
        {
        }
        field(50002; "Default Setup"; Boolean)
        {
            Description = '081012';
            Editable = true;
        }
        field(50003; Status; Option)
        {
            Description = 'ALLECK 040113';
            OptionCaption = 'Open,Release,Pending for Approval,Rejected';
            OptionMembers = Open,Release,"Pending for Approval",Rejected;
            Editable = False;
        }
        field(50004; Version; Integer)
        {
            CalcFormula = Max("Archive Document Master".Version WHERE("Unit Code" = FIELD("Unit Code"),
                                                                       "Project Code" = FIELD("Project Code")));
            Description = 'ALLECK 040113';
            FieldClass = FlowField;
        }
        field(50005; "Total Charge Amount"; Decimal)
        {
            DecimalPlaces = 0 : 4;
            Description = 'ALLEDK 240113';
            Editable = false;
        }
        field(50006; "Sub Payment Plan"; Boolean)
        {
            Editable = false;
        }
        field(50010; "Sub Sub Payment Plan Code"; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            var
                AppChargeCode: Record "App. Charge Code";
            begin
            end;
        }
        field(50100; "New Sequence 1"; Integer)
        {
        }
        field(50101; "Old Sequence"; Integer)
        {
        }
        field(50200; "Company Name"; Text[30])
        {
        }
        field(50201; "BSP4 Plan wise Rate / Sq. Yd"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                RecJob.RESET;
                IF RecJob.GET("Project Code") THEN
                    RecJob.TESTFIELD("BSP4 Plan wise Applicable", FALSE);

                IF (Code <> 'PPLAN') THEN
                    ERROR('Code should be only PPLAN');
            end;
        }
        field(50202; "Created By"; Code[50])
        {
            Editable = False;
        }


    }

    keys
    {
        key(Key1; "Document Type", "Project Code", "Code", "Sale/Lease", "Unit Code", "App. Charge Code")
        {
            Clustered = true;
        }
        key(Key2; "Document Type", "Code")
        {
        }
        key(Key3; "Document Type", "Project Code", "Unit Code")
        {
            SumIndexFields = "Total Charge Amount";
        }
        key(Key4; "Project Code", "Unit Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        /*IF ("Document Type"="Document Type"::Charge) AND (Code<>'') THEN
        BEGIN
        PPDRec.RESET;
        PPDRec.SETRANGE(PPDRec."Charge Code",Code);
        PPDRec.SETRANGE("Project Code","Project Code");
        IF PPDRec.FINDFIRST THEN
           ERROR('You can not delete,Charge Code Already exists in Payment Plan')
        END;
        
         */

        IF ("Document Type" = "Document Type"::"Payment Plan") AND (Code <> '') THEN BEGIN
            ShRec.RESET;
            ShRec.SETRANGE(ShRec."Payment Plan", Code);
            ShRec.SETRANGE(ShRec."Project Code", "Project Code");
            IF ShRec.FINDFIRST THEN
                ERROR('You can not delete,Data Already exists in Sale Order No. %1', ShRec."No.")
        END;

        UMaster.RESET;
        UMaster.SETRANGE("Project Code", "Project Code");
        UMaster.SETRANGE("No.", "Unit Code");
        IF UMaster.FINDFIRST THEN BEGIN
            IF ISEMPTY THEN
                UMaster."Total Value" := 0;
            IF UMaster.Status = UMaster.Status::Booked THEN
                //    ERROR('Payment Receipt already Exists');
                UMaster.MODIFY;
        END;

    end;

    var
        PPDRec: Record "Payment Plan Details";
        ShRec: Record "Sales Header";
        APPCharge: Record "App. Charge Code";
        UnitMaster: Record "Unit Master";
        TotalValue: Decimal;
        CalDocMaster: Record "Document Master";
        FixedValue: Decimal;
        UMaster: Record "Unit Master";
        AppPaymentEntry: Record "Application Payment Entry";
        UnitChargePaymentCode: Record "Unit Charge & Payment Pl. Code";
        RecDocMaster: Record "Document Master";
        RecJob: Record Job;

}

