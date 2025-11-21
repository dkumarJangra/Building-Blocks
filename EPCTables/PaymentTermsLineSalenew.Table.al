table 97865 "Payment Terms Line Sale new"
{
    // Alle SP VSID 0011: New Table created for multiple payment terms line for one purchase order.
    // //MKS commented the code
    // //ALLETDK081112- Changed flow field of "Received Amt" field
    //     //ALLETDK221112- Changed Caption of Milestone code field to Sequence

    DrillDownPageID = "Payment Terms Line Sale List";
    LookupPageID = "Payment Terms Line Sale List";

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Credit Note","Posted Purchase Invoice","Posted Sales Invoice";
        }
        field(2; "Document No."; Code[20])
        {
        }
        field(3; "Payment Term Code"; Code[20])
        {
            TableRelation = "Payment Terms".Code;

            trigger OnValidate()
            begin
                PaymentTerms.RESET;
                IF PaymentTerms.GET("Payment Term Code") THEN BEGIN
                    VALIDATE("Due Date Calculation", PaymentTerms."Due Date Calculation");
                    //Description := PaymentTerms.Description;
                END
            end;
        }
        field(4; "Actual Milestone"; Code[20])
        {
        }
        field(5; "Posted Document No."; Code[20])
        {
            Caption = 'Posted Payment Document No.';
            Editable = false;
        }
        field(6; Sequence; Code[20])
        {
            Caption = 'Sequence ';
        }
        field(7; Criteria; Option)
        {
            Description = 'Not In Use';
            OptionMembers = Milestone,"% Complete";

            trigger OnValidate()
            begin
                //TESTFIELD("Stage Complete",FALSE);
            end;
        }
        field(8; "Criteria Value / Base Amount"; Decimal)
        {
            Description = 'Not In Use';

            trigger OnValidate()
            begin
                /*
                IF ("Document Type" <> "Document Type"::Order) AND ("Document Type" <> "Document Type"::Invoice) THEN
                   TESTFIELD("Stage Complete",FALSE);
                
                IF "Calculation Type" = "Calculation Type"::"% age" THEN
                    "Due Amount" := ("Criteria Value / Base Amount" * "Calculation Value")/100;
                */

                /*
                CALCFIELDS("Order Value");
                IF "Calculation Type" = "Calculation Type"::"% age" THEN
                    "Due Amount" := ("Order Value" * "Calculation Value")/100;
                */

                //{MKS
                //CalculateCriteriaValue;
                //MKS}

            end;
        }
        field(9; "Calculation Type"; Option)
        {
            Description = 'Not In Use';
            OptionMembers = "% age","Fixed Value";
        }
        field(10; "Calculation Value"; Decimal)
        {
            Description = 'Not In Use';

            trigger OnValidate()
            begin
                /*IF "Calculation Type" = "Calculation Type"::"% age" THEN
                    "Due Amount" := ("Criteria Value / Base Amount" * "Calculation Value")/100;
                */
                /*
                CALCFIELDS("Order Value");
                IF "Calculation Type" = "Calculation Type"::"% age" THEN
                    "Due Amount" := ("Order Value" * "Calculation Value")/100;
                */

                //{MKS
                CalculateCriteriaValue;
                //MKS}
                Adjust := TRUE;

            end;
        }
        field(11; "Due Date Calculation"; DateFormula)
        {

            trigger OnValidate()
            begin
                /*MKS
                IF "Transaction Type" = "Transaction Type"::Purchase THEN BEGIN
                  PurchaseHeader.GET("Document Type","Document No.");
                  "Due Date" := CALCDATE("Due Date Calculation",PurchaseHeader."Document Date");
                END;
                MKS*/

                // ALLEPG 280812 Start
                IF SalesHeader2.GET("Document Type", "Document No.") THEN
                    "Due Date" := CALCDATE("Due Date Calculation", SalesHeader2."Document Date");
                IF Application.GET("Document No.") THEN
                    "Due Date" := CALCDATE("Due Date Calculation", Application."Posting Date");
                // ALLEPG 280812 End

            end;
        }
        field(12; "Due Amount"; Decimal)
        {
            DecimalPlaces = 2 : 2;

            trigger OnValidate()
            begin
                VALIDATE("Brokerage %");
            end;
        }
        field(13; Status; Option)
        {
            Description = 'from Sales Header';
            OptionMembers = Open,Released,Posted;
        }
        field(14; "Payment Made"; Boolean)
        {
            Editable = true;
        }
        field(15; Adjust; Boolean)
        {
        }
        field(16; Description; Text[50])
        {
            Description = '070604 : Field added for more details';
        }
        field(17; "Due Date"; Date)
        {
            Description = '070604 : Field added for more details';
        }
        field(18; "Posted Invoice No."; Code[20])
        {
            Description = '070604 : Field added for more details';
        }
        field(19; "Transaction Type"; Option)
        {
            OptionCaption = 'Sale,Purchase';
            OptionMembers = Sale,Purchase;
        }
        field(20; "Payment Type"; Option)
        {
            Description = 'ALLEAS02';
            OptionCaption = ' ,Advance,Running,Retention,Secured Advance,Adhoc Advance,Provisional,LD/Interest,ROI,Ticket Control,Mobile,Conveyance,Travel';
            OptionMembers = " ",Advance,Running,Retention,"Secured Advance","Adhoc Advance",Provisional,"LD/Interest",ROI,"Ticket Control",Mobile,Conveyance,Travel;
        }
        field(21; "Broker No."; Code[20])
        {
            Description = 'from Sales Header';
            //TableRelation = Vendor."No." WHERE("Vendor Type" = FILTER(Broker));
        }
        field(50000; "Sub Document Type"; Option)
        {
            Description = 'from Sales Header';
            Editable = false;
            OptionCaption = ' ,,,,,,,,,,,,,,Sales,Lease,,,Sale Property,Sale Normal,Lease Property';
            OptionMembers = " ","WO-Project","WO-Normal","Regular PO-Project","Regular PO Normal","Property PO","Direct PO-Normal","GRN for PO","GRN for Aerens","GRN for Packages","GRN for Fabricated Material for WO","JES for WO","GRN-Direct Purchase","Freight Advice",Sales,Lease,"Project Indent","Non-Project Indent","Sale Property","Sale Normal","Lease Property";
        }
        field(50009; "Order Value"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Line Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                "Document No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50021; "Brokerage Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                "Brokerage %" := 0;
                IF "Due Amount" <> 0 THEN
                    "Brokerage %" := ("Brokerage Amount" * 100) / "Due Amount";
                CalculateTDS;
            end;
        }
        field(70003; "Payment Plan"; Code[20])
        {
            TableRelation = "Document Master".Code WHERE("Document Type" = FILTER("Payment Plan"),
                                                          "Project Code" = FIELD("Project Code"));
        }
        field(70004; "Brokerage %"; Decimal)
        {

            trigger OnValidate()
            begin
                IF SalesHeader.GET("Document Type", "Document No.") THEN //ALLETDK081112
                    SalesHeader.TESTFIELD(SalesHeader."Associate Code");

                "Brokerage Amount" := "Brokerage %" * "Due Amount" / 100;
                CalculateTDS;
            end;
        }
        field(70005; "Customer No."; Code[20])
        {
            Description = 'from Sales Header';
            TableRelation = Customer;
        }
        field(70006; "Discount %"; Decimal)
        {

            trigger OnValidate()
            begin
                "Due Amount" := "Due Amount" - ("Due Amount" * "Discount %" / 100);  // ALLEAA
            end;
        }
        field(70007; "Related Vendor No."; Code[20])
        {
            Description = 'from Sales Header';
            TableRelation = Vendor;
        }
        field(70008; "Last Issued Reminder Level"; Integer)
        {
            Caption = 'Last Issued Reminder Level';
        }
        field(70009; "On Hold"; Code[3])
        {
            Caption = 'On Hold';
        }
        field(70010; "Calculate Interest"; Boolean)
        {
        }
        field(70011; "Received Amt"; Decimal)
        {
            CalcFormula = Sum("Unit Payment Entry new".Amount WHERE("Document No." = FIELD("Document No."),
                                                                     Sequence = FIELD(Sequence)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(70012; "Brokerage Paid Amt"; Decimal)
        {
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Posting Type" = FILTER(Running),
                                                                                  "Order Ref No." = FIELD("Document No."),
                                                                                  "Milestone Code" = FIELD(Sequence),
                                                                                  "Ref Document Type" = FILTER(Order),
                                                                                  "Document Type" = FILTER(Payment | Refund),
                                                                                  "Vendor No." = FIELD("Broker No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(70013; "ROI Paid Amt"; Decimal)
        {
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Posting Type" = FILTER("Mobilization Advance"),
                                                                                  "Order Ref No." = FIELD("Document No."),
                                                                                  "Milestone Code" = FIELD(Sequence),
                                                                                  "Ref Document Type" = FILTER(Order),
                                                                                  "Document Type" = FILTER(Payment | Refund),
                                                                                  "Vendor No." = FIELD("Related Vendor No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(70014; "Project Code"; Code[20])
        {
            Description = 'from Sales Header';
            Editable = true;
            TableRelation = Job;
        }
        field(70015; "Salesperson Code"; Code[20])
        {
            Description = 'from Sales Header';
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(70016; Approved; Boolean)
        {
            Description = 'from Sales Header';
            Editable = false;
        }
        field(70017; "Order Status"; Option)
        {
            Description = 'from Sales Header';
            Editable = false;
            OptionCaption = 'Booked,Transfered,Forfieted,Cancelled';
            OptionMembers = Booked,Transfered,Forfieted,Cancelled;
        }
        field(70018; "Brokerage TDS Amt"; Decimal)
        {
            Editable = false;
        }
        field(70019; "Brokerage TDS Paid Amt"; Decimal)
        {
            Editable = false;
        }
        field(70020; "Fixed Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                "Due Amount" := ROUND("Fixed Amount", 1);
            end;
        }
        field(70021; "Discount Amount"; Decimal)
        {
        }
        field(70022; "Charge Code"; Code[20])
        {
            TableRelation = "Unit Charge & Payment Pl. Code";
        }
        field(70023; "Commision Applicable"; Boolean)
        {
        }
        field(70024; "Direct Associate"; Boolean)
        {
        }
        field(70025; version; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", Sequence)
        {
            Clustered = true;
        }
        key(Key2; "Payment Type", Sequence, "Customer No.", "Project Code", "Broker No.", "Salesperson Code", "Sub Document Type", "Due Date", "Document Type")
        {
            SumIndexFields = "Due Amount", "Brokerage Amount";
        }
        key(Key3; "Customer No.", "Due Date")
        {
        }
        key(Key4; "Payment Type", "Related Vendor No.", "Project Code", "Sub Document Type", "Due Date")
        {
            SumIndexFields = "Due Amount";
        }
        key(Key5; "Actual Milestone")
        {
        }
        key(Key6; "Document No.", "Charge Code", "Commision Applicable")
        {
        }
        key(Key7; "Project Code", "Document No.", "Charge Code")
        {
        }
        key(Key8; version)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        /*MKS
        TESTFIELD("Payment Made",FALSE);
        IF Rec."Transaction Type" = Rec."Transaction Type"::Purchase THEN BEGIN
          PurchaseHeader.GET("Document Type","Document No.")     ;
          PurchaseHeader.TESTFIELD(Status,PurchaseHeader.Status::Open);
        END;
        IF Rec."Transaction Type" = Rec."Transaction Type"::Sale THEN BEGIN
          SalesHeader.GET("Document Type","Document No.")     ;
          SalesHeader.TESTFIELD(Status,SalesHeader.Status::Open);
        END
        MKS*/

    end;

    trigger OnInsert()
    begin
        /*
        //MKS START
        IF Rec."Transaction Type" = Rec."Transaction Type"::Purchase THEN BEGIN
          PurchaseHeader.GET("Document Type","Document No.")     ;
          PurchaseHeader.TESTFIELD(Status,PurchaseHeader.Status::Open);
          "Vendor Code":=PurchaseHeader."Buy-from Vendor No.";
        END;
        IF Rec."Transaction Type" = Rec."Transaction Type"::Sale THEN BEGIN
          SalesHeader.GET("Document Type","Document No.")     ;
          SalesHeader.TESTFIELD(Status,SalesHeader.Status::Open);
        END;
        
        IF ("Milestone Code" = '')  THEN
           ERROR('Please Enter Milestone Code');
        
        IF ("Payment Type" = "Payment Type"::" ")  THEN
           ERROR('Please Enter Payment Type');
        
        IF ("Payment Type" = "Payment Type"::Advance)  THEN
          "Payment Made":=TRUE;
        
        Adjust:=TRUE;
        IF ("Payment Type" = "Payment Type"::Advance)  THEN
        Adjust:=FALSE;
        */
        //MKS STOP

        IF SalesHeader.GET("Document No.") THEN BEGIN    //ALLETDK081112
                                                         //"Salesperson Code":=SalesHeader."Salesperson Code";
            "Sub Document Type" := SalesHeader."Sub Document Type";
            Status := SalesHeader.Status;
            "Customer No." := SalesHeader."Customer No.";
            "Broker No." := SalesHeader."Associate Code";
            //"Payment Plan":=SalesHeader."Payment Plan";
            //"Related Vendor No." :=SalesHeader."Related Vendor No.";
            "Project Code" := SalesHeader."Shortcut Dimension 1 Code";
            //Approved   :=SalesHeader.Approved;
            //"Order Status" :=SalesHeader."Order Status";
        END;       //ALLETDK081112
        //Copy Brokearge %
        IF ("Broker No." <> '') AND (SalesHeader."Sub Document Type" = SalesHeader."Sub Document Type"::Sales) THEN BEGIN
            Vendor.GET("Broker No.");
            "Brokerage %" := Vendor."BBG Broker %";
            IF "Brokerage %" = 0 THEN BEGIN
                SalesSetup.GET;
                "Brokerage %" := SalesSetup."Default Brokerage %";
            END;
            VALIDATE("Brokerage %");
        END;

    end;

    trigger OnModify()
    begin
        //TESTFIELD("Payment Made",FALSE);
        /*MKS
        IF Rec."Transaction Type" = Rec."Transaction Type"::Purchase THEN BEGIN
          PurchaseHeader.GET("Document Type","Document No.")     ;
          PurchaseHeader.TESTFIELD(Status,PurchaseHeader.Status::Open);
        END;
        IF Rec."Transaction Type" = Rec."Transaction Type"::Sale THEN BEGIN
          SalesHeader.GET("Document Type","Document No.")     ;
          SalesHeader.TESTFIELD(Status,SalesHeader.Status::Open);
        END
        MKS*/

    end;

    var
        PaymentTerms: Record "Payment Terms";
        PurchaseHeader: Record "Purchase Header";
        SalesHeader: Record Application;
        Phdr: Record "Purchase Header";
        Vendor: Record Vendor;
        SalesSetup: Record "Sales & Receivables Setup";
        "--TDS": Integer;
        //NODHeader: Record 13786;//Need to check the code in UAT
        //NODLines: Record 13785;//Need to check the code in UAT
        TDSDetail: Record "TDS Setup";//13728;
        Rate: Decimal;
        Rate1: Decimal;
        TotalAmount: Decimal;
        LoopingAmount: Decimal;
        OldMileStone: Code[10];
        Customer: Record Customer;
        RemainingAmt: Decimal;
        RemainingBrokerageAmt: Decimal;
        PaymentPlanDetails: Record "Payment Plan Details";
        PaymentPlanDetails1: Record "Payment Plan Details";
        Sno: Code[20];
        Applicablecharge: Record "Applicable Charges";
        PaymentPlanDetails2: Record "Payment Plan Details" temporary;
        CNT: Integer;
        MilestoneCodeG: Code[10];
        InLoop: Boolean;
        PaymentTermLine: Record "Payment Terms Line Sale";
        PaymentTermLines: Record "Payment Terms Line Sale";
        Application: Record Application;
        SalesHeader2: Record "Sales Header";


    procedure CalculateCriteriaValue()
    begin
        //{MKS
        IF SalesHeader.GET("Document Type", "Document No.") THEN; //ALLETDK081112
                                                                  /*
                                                                  PurchaseHeader.CALCFIELDS("Tot Service tax -Freight","Service Tax-Install & Comm Amt",
                                                                                             PurchaseHeader."Total Entry Tax/Octroi Amount",
                                                                                             PurchaseHeader."Total Freight Amount",PurchaseHeader."Intallation & Comm Amount");
                                                                  //Phdr.GET(Phdr."Document Type"::Order,PurchaseHeader."Order Ref. No.");
                                                                  */

        CALCFIELDS("Order Value");
        IF "Criteria Value / Base Amount" = 0 THEN
            "Criteria Value / Base Amount" := "Order Value";
        IF "Calculation Type" = "Calculation Type"::"% age" THEN
            "Due Amount" := ("Criteria Value / Base Amount" * "Calculation Value") / 100;
        //END;
        IF "Calculation Type" = "Calculation Type"::"Fixed Value" THEN
            "Due Amount" := ROUND("Fixed Amount", 1);
        //MKS}
        "Brokerage Amount" := "Brokerage %" * "Due Amount" / 100;

    end;


    procedure CalculateTDS()
    var
        Vendor: Record Vendor;
        AllowedSection: Record "Allowed Sections";
        CodeunitEventMgt: Codeunit "BBG Codeunit Event Mgnt.";
        TDSPercent: Decimal;
    begin
        IF "Broker No." = '' THEN
            EXIT;

        IF Vendor.Get("Broker No.") Then begin
            AllowedSection.Reset();
            AllowedSection.SetRange("Vendor No", Vendor."No.");
            AllowedSection.SetRange("TDS Section", '194H');
            IF AllowedSection.FindFirst() then begin
                TDSPercent := CodeunitEventMgt.GetTDSPer(Vendor."No.", AllowedSection."TDS Section", Vendor."Assessee Code");
                Rate := TDSPercent; //+ (TDSPercent * (TDSDetail."Surcharge %" / 100));
                Rate1 := Rate; //+ (Rate * (TDSDetail."eCESS %" / 100));
                "Brokerage TDS Amt" := ROUND(Rate1 * "Brokerage Amount" / 100, 1);
            end;
        end;
        /*//Need to check the code in UAT

                NODHeader.SETRANGE(Type, NODHeader.Type::Vendor);
                NODHeader.SETRANGE("No.", "Broker No.");
                NODHeader.FINDFIRST;
                /*IF NOT NODHeader.FINDFIRST THEN
                  EXIT;
                */
        /*//Need to check the code in UAT

                NODLines.SETRANGE(Type, NODLines.Type::Vendor);
                NODLines.SETRANGE("No.", "Broker No.");
                NODLines.SETRANGE("NOD/NOC", 'COMM');
                NODLines.FINDFIRST;
                /*
                IF NOT NODLines.FINDFIRST THEN
                  EXIT;
                */
        /*
              TDSDetail.RESET;
              TDSDetail.SETRANGE("TDS Nature of Deduction", NODLines."NOD/NOC");
              TDSDetail.SETRANGE("Assessee Code", NODHeader."Assesse Code");
              TDSDetail.SETRANGE("Effective Date", 0D, WORKDATE);
              IF NODLines."Concessional Code" <> '' THEN
                  TDSDetail.SETRANGE("Concessional Code", NODLines."Concessional Code")
              ELSE
                  TDSDetail.SETFILTER("Concessional Code", '');
              IF TDSDetail.FIND('+') THEN BEGIN
                  Rate := TDSDetail."TDS %" + (TDSDetail."TDS %" * (TDSDetail."Surcharge %" / 100));
                  Rate1 := Rate + (Rate * (TDSDetail."eCESS %" / 100));
                  "Brokerage TDS Amt" := ROUND(Rate1 * "Brokerage Amount" / 100, 1);
                  //MODIFY;
              END;
      *///Need to check the code in UAT

    end;


    procedure InsertMilestone()
    begin
        TotalAmount := 0;
        OldMileStone := '';
        PaymentTermLines.RESET;
        PaymentTermLines.SETRANGE("Document No.", "Document No.");
        IF PaymentTermLines.FIND('-') THEN
            //IF CONFIRM('Overwrite Milestones?') THEN
            //  PaymentTermLines.DELETEALL
            //ELSE
            //  EXIT;
            ERROR('Please delete the existing Milestone');
        Sno := '001';
        IF SalesHeader.GET("Document No.") THEN BEGIN
            PaymentPlanDetails2.RESET;
            PaymentPlanDetails2.DELETEALL;
            PaymentPlanDetails.RESET;
            PaymentPlanDetails.SETRANGE("Payment Plan Code", SalesHeader."Payment Plan");
            PaymentPlanDetails.SETRANGE("Document No.", "Document No.");
            IF PaymentPlanDetails.FINDSET THEN
                REPEAT
                    PaymentPlanDetails2.COPY(PaymentPlanDetails);
                    TotalAmount := TotalAmount + PaymentPlanDetails2."Milestone Charge Amount";
                    PaymentPlanDetails2.INSERT;
                UNTIL PaymentPlanDetails.NEXT = 0;

            Applicablecharge.RESET;
            Applicablecharge.SETCURRENTKEY("Document No.", Applicablecharge.Sequence);
            Applicablecharge.SETRANGE("Document No.", "Document No.");
            Applicablecharge.SETRANGE(Applicable, TRUE);
            IF Applicablecharge.FINDSET THEN BEGIN
                MilestoneCodeG := '1';
                PaymentPlanDetails2.RESET;
                PaymentPlanDetails2.SETRANGE("Payment Plan Code", SalesHeader."Payment Plan");
                PaymentPlanDetails2.SETRANGE("Document No.", "Document No.");
                PaymentPlanDetails2.SETRANGE(Checked, FALSE);
                IF PaymentPlanDetails2.FINDSET THEN
                    REPEAT
                        LoopingAmount := 0;
                        REPEAT
                            IF Applicablecharge."Net Amount" = PaymentPlanDetails2."Milestone Charge Amount" THEN BEGIN
                                CreatePaymentTermsLine(PaymentPlanDetails2."Milestone Code", PaymentPlanDetails2."Milestone Description",
                                PaymentPlanDetails2."Project Milestone Due Date", PaymentPlanDetails2."Milestone Charge Amount",
                                Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate");
                                PaymentPlanDetails2.Checked := TRUE;
                                PaymentPlanDetails2.MODIFY;
                                //Applicablecharge.NEXT;
                                //PaymentPlanDetails2.NEXT;
                                TotalAmount := TotalAmount - PaymentPlanDetails2."Milestone Charge Amount";
                                InLoop := TRUE;
                            END;
                            IF Applicablecharge."Net Amount" > PaymentPlanDetails2."Milestone Charge Amount" THEN BEGIN
                                CreatePaymentTermsLine(PaymentPlanDetails2."Milestone Code", PaymentPlanDetails2."Milestone Description",
                                PaymentPlanDetails2."Project Milestone Due Date", PaymentPlanDetails2."Milestone Charge Amount",
                                Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate");
                                PaymentPlanDetails2.Checked := TRUE;
                                PaymentPlanDetails2.MODIFY;

                                TotalAmount := TotalAmount - PaymentPlanDetails2."Milestone Charge Amount";//ALLE PS
                                LoopingAmount := 0;

                                Applicablecharge."Net Amount" := Applicablecharge."Net Amount" -
                                  PaymentPlanDetails2."Milestone Charge Amount";

                                //PaymentPlanDetails2.NEXT;
                                InLoop := TRUE;
                            END ELSE
                                IF Applicablecharge."Net Amount" < PaymentPlanDetails2."Milestone Charge Amount" THEN BEGIN
                                    CreatePaymentTermsLine(PaymentPlanDetails2."Milestone Code", PaymentPlanDetails2."Milestone Description",
                                    PaymentPlanDetails2."Project Milestone Due Date", Applicablecharge."Net Amount",
                                    Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate");
                                    //PaymentPlanDetails2.Checked := TRUE;

                                    TotalAmount := TotalAmount - Applicablecharge."Net Amount";//ALLE PS
                                    LoopingAmount := PaymentPlanDetails2."Milestone Charge Amount" - Applicablecharge."Net Amount";

                                    PaymentPlanDetails2."Milestone Charge Amount" := PaymentPlanDetails2."Milestone Charge Amount" -
                                    Applicablecharge."Net Amount";
                                    PaymentPlanDetails2.MODIFY;
                                    //Applicablecharge.NEXT;
                                    Applicablecharge."Net Amount" := 0;
                                    //PaymentPlanDetails2.NEXT(-1);

                                    InLoop := TRUE;
                                END;
                            IF Applicablecharge."Net Amount" = 0 THEN BEGIN
                                Applicablecharge.NEXT;
                            END;

                        UNTIL (LoopingAmount = 0) OR (TotalAmount = 0);
                    UNTIL (PaymentPlanDetails2.NEXT = 0) OR (TotalAmount = 0);

                //   UNTIL PaymentPlanDetails2.NEXT=0;

            END;


        END;
    end;


    procedure CreatePaymentTermsLine(MilestoneCode: Code[10]; MilestoneDescription: Text[50]; MilestoneDueDate: Date; Milestoneamt: Decimal; ChargeCode: Code[10]; CommisionApplicable: Boolean; DirectAssociate: Boolean)
    begin
        PaymentTermLines.INIT;
        PaymentTermLines.COPY(Rec);
        PaymentTermLines."Payment Type" := PaymentTermLines."Payment Type"::Advance;
        PaymentTermLines.Sequence := Sno;
        Sno := INCSTR(Sno);
        PaymentTermLines."Actual Milestone" := MilestoneCode;
        PaymentTermLines."Payment Plan" := PaymentPlanDetails."Payment Plan Code";
        //PaymentTermLines."Due Amount":=PaymentPlanDetails."Milestone Charge Amount";
        //PaymentTermLine."Broker No.":=SalesHeader."Broker Code";
        //PaymentTermLine."Customer No.":=SalesHeader."Sell-to Customer No.";
        //PaymentTermLine."Salesperson Code":=SalesHeader."Salesperson Code";
        //Customer.GET(SalesHeader."Customer No.");
        //PaymentTermLine."Related Vendor No.":=Customer."Related Vendor No.";
        PaymentTermLines.Description := MilestoneDescription;
        PaymentTermLines."Due Date" := MilestoneDueDate;
        PaymentTermLines."Project Code" := "Project Code";
        PaymentTermLines."Calculation Type" := PaymentTermLines."Calculation Type"::"% age";
        PaymentTermLines."Criteria Value / Base Amount" := Milestoneamt;
        PaymentTermLines."Calculation Value" := 100;
        PaymentTermLines."Due Amount" := ROUND(Milestoneamt, 0.01, '=');
        PaymentTermLines."Charge Code" := ChargeCode;
        PaymentTermLines."Commision Applicable" := CommisionApplicable;
        PaymentTermLines."Direct Associate" := DirectAssociate;
        PaymentTermLines.INSERT(TRUE);
    end;
}

