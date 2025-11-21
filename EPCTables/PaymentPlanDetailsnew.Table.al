table 97864 "Payment Plan Details new"
{
    // BLK2.01 250111 : Added fields.


    fields
    {
        field(1; "Payment Plan Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Document Master".Code WHERE("Document Type" = FILTER("Payment Plan"),
                                                          "Project Code" = FIELD("Project Code"));
        }
        field(2; "Milestone Code"; Code[20])
        {
        }
        field(3; "Charge Code"; Code[20])
        {
            TableRelation = "Document Master".Code WHERE("Document Type" = FILTER(Charge),
                                                          "Project Code" = FIELD("Project Code"),
                                                          "Sale/Lease" = FIELD("Sale/Lease"));

            trigger OnValidate()
            begin
                DocumentMaster.RESET;
                DocumentMaster.SETRANGE(DocumentMaster."Document Type", DocumentMaster."Document Type"::Charge);
                DocumentMaster.SETRANGE(DocumentMaster.Code, "Charge Code");
                IF DocumentMaster.FIND('-') THEN BEGIN
                    "Commision Applicable" := DocumentMaster."Commision Applicable";
                    "Direct Associate" := DocumentMaster."Direct Associate";
                END;
            end;
        }
        field(4; "Charge %"; Decimal)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Fixed Amount", 0);
                IF "Document No." = '' THEN BEGIN

                    ChargeTotal := 0;
                    PPDRec.RESET;
                    PPDRec.SETFILTER(PPDRec."Payment Plan Code", "Payment Plan Code");
                    PPDRec.SETFILTER(PPDRec."Project Code", "Project Code");
                    PPDRec.SETFILTER(PPDRec."Charge Code", "Charge Code");
                    PPDRec.SETFILTER(PPDRec."Milestone Code", '<>%1', "Milestone Code");
                    PPDRec.SETFILTER(PPDRec."Document No.", '=%1', '');
                    IF PPDRec.FINDFIRST THEN
                        REPEAT
                            //  MESSAGE('%1 %2 %3',PPDRec."Project Code",PPDRec."Payment Plan Code",PPDRec."Document No.");
                            ChargeTotal := ChargeTotal + PPDRec."Charge %"
                        UNTIL PPDRec.NEXT = 0;
                END;

                IF ChargeTotal + "Charge %" > 100 THEN
                    ERROR('You can not enter more then 100 % for Charge Code %1', "Charge Code");

                CalcMilestoneChargeAmount;
            end;
        }
        field(5; "Milestone Description"; Text[50])
        {
        }
        field(6; "Document No."; Code[20])
        {
            Editable = false;
            Enabled = true;
        }
        field(7; "Total Charge Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                CalcMilestoneChargeAmount;
                /*PayPlanDetail.RESET;
                PayPlanDetail.SETRANGE("Project Code","Project Code");
                PayPlanDetail.SETRANGE("Payment Plan Code","Payment Plan Code");
                PayPlanDetail.SETRANGE("Charge Code","Charge Code");
                PayPlanDetail.SETFILTER("Document No.",'%1',"Document No.");
                PayPlanDetail.SETFILTER("Milestone Code",'<>%1',"Milestone Code");
                IF PayPlanDetail.FIND('-') THEN
                REPEAT
                  PayPlanDetail."Total Charge Amount":="Total Charge Amount";
                  PayPlanDetail.CalcMilestoneChargeAmount;
                  PayPlanDetail.MODIFY;
                UNTIL PayPlanDetail.NEXT=0;
                 */

            end;
        }
        field(8; "Milestone Charge Amount"; Decimal)
        {
        }
        field(11; "Discount %"; Decimal)
        {

            trigger OnValidate()
            begin
                CalcMilestoneChargeAmount;
            end;
        }
        field(12; "Project Code"; Code[20])
        {
            Editable = true;
            TableRelation = Job."No.";
        }
        field(13; "Project Milestone Due Date"; Date)
        {
            Description = 'this is to be filled in only if milestone is linked to project progress';

            trigger OnValidate()
            begin
                PayPlanDetail.RESET;
                PayPlanDetail.SETRANGE("Project Code", "Project Code");
                PayPlanDetail.SETRANGE("Payment Plan Code", "Payment Plan Code");
                PayPlanDetail.SETRANGE("Milestone Code", "Milestone Code");
                PayPlanDetail.SETFILTER("Document No.", '%1', "Document No.");
                PayPlanDetail.SETFILTER("Charge Code", '<>%1', "Charge Code");
                IF PayPlanDetail.FIND('-') THEN
                    REPEAT
                        PayPlanDetail."Project Milestone Due Date" := "Project Milestone Due Date";
                        PayPlanDetail.MODIFY;
                    UNTIL PayPlanDetail.NEXT = 0;
            end;
        }
        field(14; "Group Code"; Code[10])
        {
        }
        field(15; "Fixed Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Charge %", 0);
            end;
        }
        field(16; Completed; Boolean)
        {
        }
        field(17; "Sale/Lease"; Option)
        {
            OptionCaption = ' ,Sale,Lease';
            OptionMembers = " ",Sale,Lease;
        }
        field(18; "Due Date Calculation"; DateFormula)
        {
            Description = 'BLK2.01 250111';

            trigger OnValidate()
            begin
                IF FORMAT("Actual Date") <> '' THEN
                    ERROR(Text50001, "Project Code", "Payment Plan Code", "Milestone Code", "Charge Code", "Document No.", "Sale/Lease");
            end;
        }
        field(19; "Actual Date"; Date)
        {
            Description = 'BLK2.01 250111';

            trigger OnValidate()
            begin
                IF FORMAT("Due Date Calculation") <> '' THEN
                    TESTFIELD("Actual Date", 0D);
            end;
        }
        field(20; "Commision Applicable"; Boolean)
        {
        }
        field(21; "Direct Associate"; Boolean)
        {
        }
        field(22; "Percentage Cum"; Decimal)
        {
        }
        field(23; Checked; Boolean)
        {
        }
        field(24; "Default Setup"; Boolean)
        {
            Description = 'ALLEDK 081012';
        }
    }

    keys
    {
        key(Key1; "Project Code", "Payment Plan Code", "Milestone Code", "Charge Code", "Document No.", "Sale/Lease")
        {
            Clustered = true;
            SumIndexFields = "Milestone Charge Amount";
        }
        key(Key2; "Milestone Code", "Payment Plan Code", "Charge Code", "Sale/Lease")
        {
        }
        key(Key3; "Project Code", "Payment Plan Code", "Document No.", "Milestone Code", "Charge Code", "Sale/Lease")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF "Document No." = '' THEN BEGIN
            PPDRec.RESET;
            PPDRec.SETFILTER("Project Code", "Project Code");
            PPDRec.SETFILTER("Charge Code", "Charge Code");
            PPDRec.SETFILTER(PPDRec."Document No.", '<>%1', '');
            IF PPDRec.FINDFIRST THEN BEGIN
                //  ERROR('Data Already exists in Sale Order No. %1', PPDRec."Document No.");
            END;
        END;
    end;

    var
        PayPlanDetail: Record "Payment Plan Details";
        PPDRec: Record "Payment Plan Details";
        ChargeTotal: Decimal;
        Text50001: Label 'You must not specify Due Date Calculation in Payment Plan Details Project Code=%1,Payment Plan Code=%2,Milestone Code=%3,Charge Code=%4,Document No.=%5,Sale/Lease=%6.';
        DocumentMaster: Record "Document Master";
        Application: Record Application;
        TotalAmount: Decimal;


    procedure CalcMilestoneChargeAmount()
    begin
        //IF "Charge %"<>0 THEN
        //"Milestone Charge Amount":=ROUND("Total Charge Amount"*(1-("Discount %"/100))*"Charge %"/100,1);
        "Milestone Charge Amount" := "Total Charge Amount" - ("Discount %" / 100);
        IF "Fixed Amount" <> 0 THEN
            "Milestone Charge Amount" := "Fixed Amount";
    end;


    procedure CalcMilestoneDueDate()
    begin
    end;


    procedure RefreshMilestoneAmount()
    begin

        Application.GET("Document No.");
        RESET;
        SETFILTER("Project Code", "Project Code");
        SETFILTER("Document No.", "Document No.");
        //SETFILTER("Charge Code",Code);
        IF FINDFIRST THEN
            REPEAT
                IF "Percentage Cum" > 0 THEN BEGIN
                    "Total Charge Amount" := (Application."Investment Amount" * "Percentage Cum" / 100) - TotalAmount;
                END;
                IF "Fixed Amount" <> 0 THEN BEGIN
                    "Total Charge Amount" := "Fixed Amount";
                END;

                TotalAmount := "Total Charge Amount" + TotalAmount;
                //"Total Charge Amount":=AppCharRec."Net Amount";
                VALIDATE("Total Charge Amount");
                MODIFY;
            UNTIL NEXT = 0;
    end;
}

