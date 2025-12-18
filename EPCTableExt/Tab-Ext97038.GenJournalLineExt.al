tableextension 97038 "EPC Gen. Journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        // Add changes to table fields here
        field(90011; Narration; Text[50])
        {
            Caption = 'Narration';
            DataClassification = ToBeClassified;
            Description = 'ALLEMSN01--JPL';
        }
        field(90016; "Posting Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS02--JPL';
            OptionCaption = ' ,Advance,Running,Retention,Secured Advance,Adhoc Advance,Provisional,LD,Mobilization Advance,Equipment Advance,,,,Commission,Travel Allowance,,Incentive,CommAndTA';
            OptionMembers = " ",Advance,Running,Retention,"Secured Advance","Adhoc Advance",Provisional,LD,"Mobilization Advance","Equipment Advance",,,,Commission,"Travel Allowance",,Incentive,CommAndTA;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                //ALLEAS02 <<
                IF ("Account Type" = "Account Type"::Customer) AND ("Account No." <> '') THEN BEGIN
                    Customer.RESET;
                    Customer.GET("Account No.");
                    CASE TRUE OF
                        "Posting Type" = "Posting Type"::Advance:
                            "Posting Group" := Customer."BBG Cust. Posting Group-Advance";
                        "Posting Type" = "Posting Type"::"Secured Advance":
                            "Posting Group" := Customer."BBG Cust. Posting Group-Advance";
                        "Posting Type" = "Posting Type"::"Adhoc Advance":
                            "Posting Group" := Customer."BBG Cust. Posting Group-Advance";
                        "Posting Type" = "Posting Type"::Running:
                            "Posting Group" := Customer."BBG Cust. Posting Group-Running";
                        "Posting Type" = "Posting Type"::Retention:
                            "Posting Group" := Customer."BBG Cust. Posting Group-Retention";
                    END;
                END;

                IF ("Account Type" = "Account Type"::Vendor) AND ("Account No." <> '') THEN BEGIN
                    VEndor.RESET;
                    VEndor.GET("Account No.");
                    CASE TRUE OF
                        "Posting Type" = "Posting Type"::Advance:
                            "Posting Group" := VEndor."BBG Vend. Posting Group-Advance";
                        "Posting Type" = "Posting Type"::"Secured Advance":
                            "Posting Group" := VEndor."BBG Vend. Posting Group-Advance";
                        "Posting Type" = "Posting Type"::"Adhoc Advance":
                            "Posting Group" := VEndor."BBG Vend. Posting Group-Advance";
                        "Posting Type" = "Posting Type"::Running:
                            "Posting Group" := VEndor."BBG Vend. Posting Group-Running";
                        "Posting Type" = "Posting Type"::Retention:
                            "Posting Group" := VEndor."BBG Vend. Posting Group-Retention";
                    END;
                END;

                //ALLEAS02 >>
            end;
        }
        field(90050; "Order Ref No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 Fields Added to Link Payments with the Milestones--JPL';
            TableRelation = IF ("Ref Document Type" = FILTER(Order),
                                "Account Type" = FILTER(Vendor),
                                "Tran Type" = FILTER(Purchase)) "Purchase Header"."No." WHERE("Document Type" = FILTER(Order),
                                                                                         "Buy-from Vendor No." = FIELD("Account No."),
                                                                                         "Order Status" = FILTER(<> Cancelled))
            ELSE IF ("Ref Document Type" = FILTER(Order),
                                                                                                  "Account Type" = FILTER(Customer),
                                                                                                  "Tran Type" = FILTER(Sale),
                                                                                                  "Document Type" = CONST(Refund)) "Confirmed Order"."No." WHERE(Status = FILTER(Cancelled),
                                                                                                                                                            "Customer No." = FIELD("Account No."))
            ELSE IF ("Ref Document Type" = FILTER(Order),
                                                                                                                                                                     "Account Type" = FILTER(Vendor),
                                                                                                                                                                     "Tran Type" = FILTER(Sale)) "Sales Header"."No." WHERE("Document Type" = FILTER(Order),
                                                                                                                                                                                                                       "Broker Code" = FIELD("Account No."),
                                                                                                                                                                                                                       Approved = FILTER(true),
                                                                                                                                                                                                                       "Order Status" = FILTER(<> Cancelled));
        }
        field(90051; "Milestone Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 Fields Added to Link Payments with the Milestones--JPL';
            TableRelation = IF ("Ref Document Type" = FILTER(Order),
                                "Account Type" = FILTER(Vendor),
                                "Tran Type" = FILTER(Purchase)) "Payment Terms Line"."Milestone Code" WHERE("Document Type" = FILTER(Order),
                                                                                                         "Document No." = FIELD("Order Ref No."))
            ELSE IF ("Ref Document Type" = FILTER(Order),
                                                                                                                  "Account Type" = FILTER(Customer),
                                                                                                                  "Tran Type" = FILTER(Sale)) "Payment Terms Line Sale".Sequence WHERE("Document Type" = FILTER(Order),
                                                                                                                                                                                    "Document No." = FIELD("Order Ref No."))
            ELSE IF ("Ref Document Type" = FILTER(Order),
                                                                                                                                                                                             "Account Type" = FILTER(Vendor),
                                                                                                                                                                                             "Tran Type" = FILTER(Sale)) "Payment Terms Line Sale".Sequence WHERE("Document Type" = FILTER(Order),
                                                                                                                                                                                                                                                               "Document No." = FIELD("Order Ref No."));

            trigger OnValidate()
            var
                recPaymentMileStone: Record "Payment Terms Line";
                recPaymentMileStonesale: Record "Payment Terms Line Sale";
                v_Vend: Record Vendor;
                LandVendorPaymentTermsLine: Record "Land Vendor Payment Terms Line";
            begin
                IF "Ref Document Type" = "Ref Document Type"::"Land Vendor" THEN BEGIN   //BBG2.0
                    LandVendorPaymentTermsLine.RESET;
                    IF ("Account Type" = "Account Type"::Vendor) THEN BEGIN
                        LandVendorPaymentTermsLine.RESET;
                        LandVendorPaymentTermsLine.SETRANGE(LandVendorPaymentTermsLine."Land Document No.", "Order Ref No.");
                        LandVendorPaymentTermsLine.SETRANGE("Actual Milestone", "Milestone Code");
                        LandVendorPaymentTermsLine.SETRANGE("Vendor No.", "Account No.");
                        IF LandVendorPaymentTermsLine.FINDFIRST THEN BEGIN
                            LandVendorPaymentTermsLine.CALCFIELDS("Payment Released Amount");
                            "Posting Type" := LandVendorPaymentTermsLine."Payment Type";
                            VALIDATE(Amount, (LandVendorPaymentTermsLine."Due Amount" - LandVendorPaymentTermsLine."Payment Released Amount"));
                        END
                        ELSE
                            ERROR('Record not found');
                    END;
                END ELSE BEGIN                                                            //BBG2.0
                                                                                          //AlleDK 230608
                    PaymentTermsLineSale.RESET;
                    IF ("Account Type" = "Account Type"::Customer) AND ("Tran Type" = "Tran Type"::Sale) THEN BEGIN
                        PaymentTermsLineSale.SETRANGE(PaymentTermsLineSale."Document Type", "Ref Document Type");
                        PaymentTermsLineSale.SETRANGE(PaymentTermsLineSale."Document No.", "Order Ref No.");
                        PaymentTermsLineSale.SETRANGE(PaymentTermsLineSale.Sequence, "Milestone Code");
                        IF PaymentTermsLineSale.FINDFIRST THEN
                            "Posting Type" := PaymentTermsLineSale."Payment Type";
                    END;
                    PaymentTermsLineSale.RESET;
                    IF ("Account Type" = "Account Type"::Vendor) AND ("Tran Type" = "Tran Type"::Sale) THEN BEGIN
                        "Posting Type" := "Posting Type"::Running;
                        //alleab
                        recPaymentMileStonesale.RESET;
                        IF "Account Type" = "Account Type"::Vendor THEN
                            recPaymentMileStonesale.SETRANGE("Transaction Type", recPaymentMileStone."Transaction Type"::Sale);
                        // recPaymentMileStonesale.SETRANGE(Adjust,TRUE);
                        recPaymentMileStonesale.SETRANGE("Document No.", "Order Ref No.");
                        recPaymentMileStonesale.SETRANGE(Sequence, "Milestone Code");
                        // recPaymentMileStonesale.SETRANGE("Payment Type","Posting Type");
                        IF recPaymentMileStonesale.FINDFIRST THEN BEGIN
                            IF ("Document Type" = "Document Type"::Payment) AND ("Account Type" = "Account Type"::Vendor) THEN
                                VALIDATE(Amount, (recPaymentMileStonesale."Brokerage Amount"));
                        END;
                        //alleab
                    END;

                    //AlleDK 230608


                    // VSID Alle SP Code written to bring the due amount on validation of Milestone Code >> >> Start
                    //NDALLE021107
                    //IF "Posting Type" = "Posting Type"::"Advance" THEN BEGIN
                    //NDALLE
                    IF "Posting Type" IN ["Posting Type"::Advance, "Posting Type"::"Secured Advance", "Posting Type"::"Adhoc Advance"] THEN BEGIN
                        recPaymentMileStone.RESET;
                        IF "Account Type" = "Account Type"::Vendor THEN
                            recPaymentMileStone.SETRANGE("Transaction Type", recPaymentMileStone."Transaction Type"::Purchase);
                        recPaymentMileStone.SETRANGE(Adjust, TRUE);
                        recPaymentMileStone.SETRANGE("Document No.", "Order Ref No.");
                        recPaymentMileStone.SETRANGE("Milestone Code", "Milestone Code");
                        recPaymentMileStone.SETRANGE("Payment Type", "Posting Type");
                        IF recPaymentMileStone.FINDFIRST THEN BEGIN
                            IF ("Document Type" = "Document Type"::Payment) AND ("Account Type" = "Account Type"::Vendor) THEN
                                VALIDATE(Amount, (recPaymentMileStone."Due Amount"));
                        END;
                        recPaymentMileStonesale.RESET;
                        IF "Account Type" = "Account Type"::Customer THEN
                            recPaymentMileStonesale.SETRANGE("Transaction Type", recPaymentMileStone."Transaction Type"::Sale);
                        // recPaymentMileStonesale.SETRANGE(Adjust,TRUE);
                        recPaymentMileStonesale.SETRANGE("Document No.", "Order Ref No.");
                        recPaymentMileStonesale.SETRANGE(Sequence, "Milestone Code");
                        recPaymentMileStonesale.SETRANGE("Payment Type", "Posting Type");
                        IF recPaymentMileStonesale.FINDFIRST THEN BEGIN
                            IF ("Document Type" = "Document Type"::Payment) AND ("Account Type" = "Account Type"::Customer) THEN
                                VALIDATE(Amount, -(recPaymentMileStonesale."Due Amount"));
                        END;


                    END;
                    // VSID Alle SP Code written to bring the due amount on validation of Milestone Code << << END
                END; //BBG2.0
            end;
        }
        field(90052; "Ref Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 Fields Added to Link Payments with the Milestones--JPL';
            OptionCaption = ',Order,,,Blanket Order,,LAnd Vendor';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Land Vendor";
        }
        field(90053; "Tran Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            OptionCaption = ' ,Purchase,Sale';
            OptionMembers = " ",Purchase,Sale;
        }
        field(90059; "Received Invoice Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'NDALLE240108';
        }
        field(90096; "Employee No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS01,Alle PR1.0--JPL';
            TableRelation = Employee;

            trigger OnValidate()
            begin
                //ALLEAS01 <<

                /*IF "Employee No." <> '' THEN
                  BEGIN
                    IF Accountno.GET("Account No.") THEN
                      BEGIN
                        IF NOT Accountno."Employee Account" THEN
                        ERROR(Text16354);
                      END;
                    IF Employee.GET("Employee No.") THEN
                      BEGIN
                        IF Employee."Resource No." = '' THEN
                           ERROR(Text16356);
                      "Resource No.":=Employee."Resource No.";
                      END;
                  END;
                */

                //GKG Commented
                /*
                    IF Employee.GET("Employee No.") THEN
                      BEGIN
                        IF Employee."Resource No." = '' THEN
                           ERROR(Text16356);
                      "Resource No.":=Employee."Resource No.";
                      END;
                */
                //GKG STOP

                /*CreateDim(
                  DATABASE::Employee,"Employee No.",
                  DimMgt.TypeToTableID1("Account Type"),"Account No.",
                  DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
                  DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
                  DATABASE::Campaign,"Campaign No.");
                */
                //ALLEAS01 >>
                //VALIDATE("Resource No.");

            end;
        }
        field(90097; "Resource No."; Code[5])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS01--JPL';
            TableRelation = Resource WHERE(Type = CONST(Person));

            trigger OnValidate()
            begin
                //ALLEAS01 <<
                /*CreateDim(
                  DATABASE::Resource,"Resource No.",
                  DimMgt.TypeToTableID1("Account Type"),"Account No.",
                  DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
                  DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
                  DATABASE::Campaign,"Campaign No.");
                */

                IF "Resource No." <> '' THEN BEGIN
                    IF Accountno.GET("Account No.") THEN BEGIN
                        IF Accountno."BBG Resource Account" = FALSE THEN
                            ERROR(Text16355);
                    END;
                END;

                IF ("Resource No." <> '') AND Res.WRITEPERMISSION THEN
                    EmployeeResUpdate.ResUpdate(Employee);

                IF "Resource No." = '' THEN
                    VALIDATE("Employee No.");

                CreateDimFromDefaultDim(FieldNo("Resource No."));
                // CreateDim(
                //   DATABASE::Resource, "Resource No.",
                //   DimMgt.TypeToTableID1("Account Type"), "Account No.",
                //   DimMgt.TypeToTableID1("Bal. Account Type"), "Bal. Account No.",
                //   DATABASE::"Salesperson/Purchaser", "Salespers./Purch. Code",
                //   DATABASE::Campaign, "Campaign No.");

                //ALLEAS01 >>

            end;
        }
        field(90101; "Order Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            TableRelation = "Purchase Line"."Line No." WHERE("Document Type" = FILTER(Order),
                                                              "Document No." = FIELD("Order Ref No."));
        }
        field(90102; "Payroll Document No."; Code[5])
        {
            DataClassification = ToBeClassified;
            Description = 'Alle PR1.0--JPL';
        }
        field(90103; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = ToBeClassified;
            Description = 'ALLEAA 141209';
            TableRelation = IF ("Account Type" = FILTER(Customer)) "Sales Header"."No." WHERE("Document Type" = FILTER(Order),
                                                                                         "Sell-to Customer No." = FIELD("Account No."));

            trigger OnValidate()
            begin
                // ALLEAA 14.12.09
                IF JVSalesLine.GET(JVSalesLine."Document Type"::Order, "Sales Order No.", 10000) THEN
                    "Project Unit No." := JVSalesLine."No.";
                // ALLEAA 14.12.09
            end;
        }
        field(90104; "Project Unit No."; Code[20])
        {
            Caption = 'Project Unit No.';
            DataClassification = ToBeClassified;
            Description = 'ALLEAA 141209';
            Editable = true;
        }
        field(90105; Reason; Option)
        {
            Caption = 'Reason';
            DataClassification = ToBeClassified;
            Description = 'ALLEAA 141209';
            OptionCaption = ' ,Cancel,Forfeit,Transfer,Other';
            OptionMembers = " ",Cancel,Forfeit,Transfer,Other;
        }
        field(90106; "Introducer Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'MPS1.0';
        }
        field(90107; "Cheque clear Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'MPS1.0';
        }
        field(90108; "Branch Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(90109; "Associate Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                IF "Associate Code" <> '' THEN
                    IF Vend.GET("Associate Code") THEN
                        "Associate Name" := Vend.Name
                    ELSE
                        "Associate Name" := '';
            end;
        }
        field(90110; "Unit Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Master" WHERE("Non Usable" = FILTER(true));

            trigger OnValidate()
            begin
                IF "Unit Code" <> '' THEN
                    IF UnitMaster.GET("Unit Code") THEN
                        Extent := UnitMaster."Saleable Area"
                    ELSE
                        Extent := 0;
            end;
        }
        field(90111; Extent; Decimal)
        {
            DataClassification = ToBeClassified;
            Enabled = false;
        }
        field(90112; "Associate Name"; Text[60])
        {
            DataClassification = ToBeClassified;
            Enabled = false;
        }
        field(90113; "Payment Mode"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 201112';
            OptionCaption = ' ,Cash,Bank,D.D.,MJVM,D.C./C.C./Net Banking,Refund Cash,Refund Bank,AJVM,Debit Note,JV,Negative Adjmt.';
            OptionMembers = " ",Cash,Bank,"D.D.",MJVM,"D.C./C.C./Net Banking","Refund Cash","Refund Bank",AJVM,"Debit Note",JV,"Negative Adjmt.";
        }
        field(90114; "Bank Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 201112';
            Enabled = false;
            TableRelation = "Bank Account";
        }
        field(90115; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETDK';
            Editable = false;
        }
        field(90116; "Vendor Cheque Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETDK';
            MinValue = 0;

            trigger OnValidate()
            var
                UnitSetup: Record "Unit Setup";
                RecTDSSetup: Record "TDS Setup";// 13728;
                TDSP: Decimal;
                ClubP: Decimal;
                JnlBankCharge: Record "Journal Bank Charges";// 16511;
            begin
                //ALLETDK201212..BEGIN
                IF "Vendor Cheque Amount" <> 0 THEN BEGIN
                    IF "Payment Mode" <> "Payment Mode"::"Negative Adjmt." THEN
                        TESTFIELD("TDS Section Code");
                    TESTFIELD("Bal. Account No.");
                    UnitSetup.GET;
                    UnitSetup.TESTFIELD("Corpus %");
                    TDSP := CalculateTDSPercentage;
                    ClubP := UnitSetup."Corpus %";
                    VALIDATE(Amount, (ROUND((100 * "Vendor Cheque Amount") / (100 - ClubP - TDSP), 0.01)));
                END ELSE BEGIN
                    VALIDATE(Amount, 0);
                    JnlBankCharge.RESET;
                    JnlBankCharge.SETRANGE("Journal Template Name", "Journal Template Name");
                    JnlBankCharge.SETRANGE("Journal Batch Name", "Journal Batch Name");
                    JnlBankCharge.SETRANGE("Line No.", "Line No.");
                    IF JnlBankCharge.FINDFIRST THEN
                        JnlBankCharge.DELETE;
                END;
                //ALLETDK201212..END;
            end;
        }
        field(90117; "Club9 Charge Amount"; Decimal)
        {
            CalcFormula = Lookup("Journal Bank Charges".Amount WHERE("Journal Template Name" = FIELD("Journal Template Name"),
                                                                   "Journal Batch Name" = FIELD("Journal Batch Name"),
                                                                   "Line No." = FIELD("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90118; Bounced; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETDK';
        }
        field(90119; "ARM Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'BBG1.00 290513';
        }
        field(90120; "TA/Comm Credit Memo"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90121; "Receipt Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 10112016';
            Editable = false;
        }
        field(90122; "Land Vendor Document Line No."; Integer)
        {
            Caption = 'Order Ref. Line No. ';
            DataClassification = ToBeClassified;
            TableRelation = "Land Agreement Line"."Line No." WHERE("Document No." = FIELD("Order Ref No."));
        }
        field(90123; "Land Agreement Expense Entry"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90124; "Land Agreement No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Land Agreement Header";
        }
        field(90125; "Land Expense"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90127; "Special Incentive Bonanza"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(55005; RegDimName; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'dds';
            Editable = false;
        }
        field(55004; Verified; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'SC--JPL';

            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
            begin
                //ALLEDK 020821
                UserSetup.RESET;
                UserSetup.SETRANGE("User ID", USERID);
                IF "Source Code" = 'BANKPYMTV' THEN
                    UserSetup.SETRANGE("Bank Payment Voucher Verify", TRUE)
                ELSE IF "Source Code" = 'CONTRAV' THEN
                    UserSetup.SETRANGE("Contra Voucher Verify", TRUE)
                ELSE IF "Source Code" = 'BANKRCPTV' THEN
                    UserSetup.SETRANGE("Bank Receipt Voucher Verify", TRUE)
                ELSE IF "Source Code" = 'CASHRCPTV' THEN
                    UserSetup.SETRANGE("Cash Receipt Voucher Verify", TRUE)
                ELSE IF "Source Code" = 'CASHPYMTV' THEN
                    UserSetup.SETRANGE("Cash Payment Voucher Verify", TRUE)
                ELSE IF "Source Code" = 'JOURNALV' THEN
                    UserSetup.SETRANGE("Journal Voucher Verify", TRUE)
                ELSE IF "Source Code" = 'GENJNL' THEN
                    UserSetup.SETRANGE("General Journal Voucher Verify", TRUE);
                IF NOT UserSetup.FINDFIRST THEN
                    ERROR('Contact Admin');
                //ALLEDK 020821
                IF Verified = TRUE THEN
                    "Verified By" := USERID
                ELSE
                    "Verified By" := '';
            end;
        }

        field(55006; "Verified By"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'NDALLE 310108';
            Editable = false;
        }
        field(60025; "LC/BG No."; Code[10])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "LC Detail";
        }
        field(60026; "BG Charges Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Handling Charges,Stamp Charges,Courier Charges,Service Tax,Commision';
            OptionMembers = " ","Handling Charges","Stamp Charges","Courier Charges","Service Tax",Commision;
        }
        field(50023; "Bond Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "Unit No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = true;
            TableRelation = "Confirmed Order";
        }
        field(50025; "Installment No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'MPS1.0';
        }
        field(50019; "Paid To/Received From Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = true;
            TableRelation = IF ("Paid To/Received From" = CONST("Marketing Member")) Vendor."No."
            ELSE IF ("Paid To/Received From" = CONST("Bond Holder")) Customer."No.";
        }
        field(50018; "Paid To/Received From"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = true;
            OptionMembers = " ","Marketing Member","Bond Holder";
        }
        field(50024; "Do Not Show"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50103; "Development Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50102; "Development Appl. Rcpt LineNo."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50100; "Payment Trasnfer from Other"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(55009; "Tranasaction Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Trading';
            OptionMembers = " ",Trading;
        }
        field(50101; "Payment As Advance"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50111; "Club 9 Entry"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50120; "Ref. External Doc. No."; Code[50])   //New field added 15122025 
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
        VEndor: Record Vendor;
        Employee: Record Employee;
        Res: Record Resource;
        EmployeeResUpdate: Codeunit "Employee/Resource Update";
        Accountno: Record "G/L Account";
        recEmp: Record Employee;
        EmpName: Text[200];
        VendPostingGrp: Record "Vendor Posting Group";
        RecLocation: Record Location;
        RecRespCenter: Record "Responsibility Center 1";
        RecUserSetup: Record "User Setup";
        DimValue: Record "Dimension Value";
        PaymentTermsLineSale: Record "Payment Terms Line Sale";
        JVSalesLine: Record "Sales Line";
        JobCurrency: Record Currency;
        TestJobTask: Boolean;
        GenJnlNarration1: Record "Gen. Journal Narration";// 16549;
        UnitMaster: Record "Unit Master";
        UnitSetup: Record "Unit Setup";
        RecCustomer: Record Customer;
        RecVendor: Record Vendor;
        GenJnlNarration: Record "Gen. Journal Narration";// 16549;
        Text16354: Label 'ENU=Please select the Employee Account';
        Text16355: Label 'ENU=Please select the Resource Account';
        Text16356: Label 'ENU=Please select the Resource code in Employee card';
        UserSetup: Record "User Setup";
        DimMgt: Codeunit DimensionManagement;
        Vend: Record Vendor;
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        OpenedOnLookup: Boolean;

    PROCEDURE CalculateTDSPercentage(): Decimal;
    VAR
        TDSPercent: Decimal;
        eCessPercent: Decimal;
        SheCessPercent: Decimal;
        RecTDSSetup: Record "TDS Setup";// 13728;
                                        //RecNODHeader: Record 13786;
                                        //RecNODLines: Record 13785;
        Vendor: Record Vendor;
        AllowedSection: Record "Allowed Sections";
        CodeunitEventMgt: Codeunit "BBG Codeunit Event Mgnt.";
    BEGIN
        IF "Payment Mode" <> "Payment Mode"::"Negative Adjmt." THEN BEGIN
            IF Vendor.Get("Party Code") Then begin
                AllowedSection.Reset();
                AllowedSection.SetRange("Vendor No", Vendor."No.");
                AllowedSection.SetRange("TDS Section", Rec."TDS Section Code");
                IF AllowedSection.FindFirst() then begin
                    TDSPercent := CodeunitEventMgt.GetTDSPer(Vendor."No.", AllowedSection."TDS Section", Vendor."Assessee Code");
                    EXIT(((10000 * TDSPercent) + (100 * TDSPercent * eCessPercent) + (100 * TDSPercent * SheCessPercent) +
                          (TDSPercent * eCessPercent * SheCessPercent)) / 10000);
                end;
            end;

            /*
            RecTDSSetup.RESET;
            RecTDSSetup.SETRANGE("TDS Nature of Deduction", "TDS Nature of Deduction");
            RecTDSSetup.SETRANGE("Assessee Code", "Assessee Code");
            RecTDSSetup.SETRANGE("TDS Group", "TDS Group");
            RecTDSSetup.SETRANGE("Effective Date", 0D, "Posting Date");
            RecNODLines.RESET;
            RecNODLines.SETRANGE(Type, "Party Type");
            RecNODLines.SETRANGE("No.", "Party Code");
            RecNODLines.SETRANGE("NOD/NOC", "TDS Nature of Deduction");
            IF RecNODLines.FINDFIRST THEN BEGIN
                IF RecNODLines."Concessional Code" <> '' THEN
                    RecTDSSetup.SETRANGE("Concessional Code", RecNODLines."Concessional Code")
                ELSE
                    RecTDSSetup.SETRANGE("Concessional Code", '');
                IF RecTDSSetup.FINDLAST THEN BEGIN
                    IF "Party Type" = "Party Type"::Vendor THEN BEGIN
                        Vend.GET("Party Code");
                        IF (Vend."P.A.N. Status" = Vend."P.A.N. Status"::" ") AND (Vend."P.A.N. No." <> '') THEN BEGIN
                            IF Vend."206AB" THEN
                                TDSPercent := RecTDSSetup."206AB %"
                            ELSE
                                TDSPercent := RecTDSSetup."TDS %"
                        END ELSE
                            TDSPercent := RecTDSSetup."Non PAN TDS %";

                        eCessPercent := RecTDSSetup."eCESS %";
                        SheCessPercent := RecTDSSetup."SHE Cess %";
                        EXIT(((10000 * TDSPercent) + (100 * TDSPercent * eCessPercent) + (100 * TDSPercent * SheCessPercent) +
                          (TDSPercent * eCessPercent * SheCessPercent)) / 10000);
                    END ELSE
                        ERROR('Party Type must be Vendor');
                END ELSE
                    ERROR('TDS Setup does not exist');
            END ELSE
                ERROR('TDS Setup does not exist');
                *///Need to check the code in UAT
        END;
    END;

    PROCEDURE UpdateOpenonLookup();
    VAR
        AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        AccNo: Code[20];
        TransactionType: Option Purchase,Sales,Transfer;
    BEGIN
        //IsGSTCalculated;
        OpenedOnLookup := TRUE;
        xRec.Amount := Amount;
        xRec."Currency Code" := "Currency Code";
        xRec."Posting Date" := "Posting Date";
        //xRec."GST Base Amount" := "GST Base Amount";
        //xRec."Total GST Amount" := "Total GST Amount";



        GetAccTypeAndNo(Rec, AccType, AccNo);
        CLEAR(CustLedgEntry);
        CLEAR(VendLedgEntry);



        VALIDATE("Applies-to Doc. No.");
        SetJournalLineFieldsFromApplication;



        CustLedgEntry.CALCFIELDS(Amount);
        VendLedgEntry.CALCFIELDS(Amount);



        CASE "Account Type" OF
            "Account Type"::Customer:
                BEGIN
                    CustLedgEntry.CALCFIELDS("Remaining Amt. (LCY)");
                    IF CustLedgEntry."Remaining Amt. (LCY)" <> 0 THEN;
                    // GetGSTAmounts(
                    //   CustLedgEntry."Document No.", ("Amount (LCY)" / CustLedgEntry."Remaining Amt. (LCY)"),
                    //   TransactionType::Sales, CustLedgEntry."Entry No.");
                END;
            "Account Type"::Vendor:
                BEGIN
                    VendLedgEntry.CALCFIELDS("Remaining Amt. (LCY)");
                    IF VendLedgEntry."Remaining Amt. (LCY)" <> 0 THEN;
                    // GetGSTAmounts(
                    //   VendLedgEntry."Document No.", ("Amount (LCY)" / VendLedgEntry."Remaining Amt. (LCY)"),
                    //   TransactionType::Purchase, VendLedgEntry."Entry No.");
                END;
        END;
        IF ("Currency Code" <> '') AND ("Document Type" = "Document Type"::Refund) THEN BEGIN
            // VALIDATE("GST Base Amount", "GST Base Amount" * "Currency Factor");
            // VALIDATE("Total GST Amount", "Total GST Amount" * "Currency Factor");
        END;
    END;


}