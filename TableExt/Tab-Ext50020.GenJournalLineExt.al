tableextension 50020 "BBG Gen. Journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        // Add changes to table fields here

        modify("Account No.")
        {
            trigger OnAfterValidate()
            begin
                "Created By" := USERID;
                //NDALLE021107

                IF ("Account Type" = "Account Type"::Customer) AND ("Posting Type" <> 0) THEN BEGIN
                    RecCustomer.RESET;
                    IF RecCustomer.GET("Account No.") THEN;
                    CASE TRUE OF
                        "Posting Type" = "Posting Type"::Advance:
                            "Posting Group" := RecCustomer."BBG Cust. Posting Group-Advance";
                        "Posting Type" = "Posting Type"::"Secured Advance":
                            "Posting Group" := RecCustomer."BBG Cust. Posting Group-Advance";
                        "Posting Type" = "Posting Type"::"Adhoc Advance":
                            "Posting Group" := RecCustomer."BBG Cust. Posting Group-Advance";
                        "Posting Type" = "Posting Type"::Running:
                            "Posting Group" := RecCustomer."BBG Cust. Posting Group-Running";
                        "Posting Type" = "Posting Type"::Retention:
                            "Posting Group" := RecCustomer."BBG Cust. Posting Group-Retention";
                    END;
                end;

                IF ("Account Type" = "Account Type"::Vendor) AND ("Posting Type" <> 0) THEN BEGIN
                    RecVendor.RESET;
                    IF RecVendor.GET("Account No.") THEN;
                    CASE TRUE OF
                        "Posting Type" = "Posting Type"::Advance:
                            "Posting Group" := RecVendor."BBG Vend. Posting Group-Advance";
                        "Posting Type" = "Posting Type"::"Secured Advance":
                            "Posting Group" := RecVendor."BBG Vend. Posting Group-Advance";
                        "Posting Type" = "Posting Type"::"Adhoc Advance":
                            "Posting Group" := RecVendor."BBG Vend. Posting Group-Advance";
                        "Posting Type" = "Posting Type"::Running:
                            "Posting Group" := RecVendor."BBG Vend. Posting Group-Running";
                        "Posting Type" = "Posting Type"::Retention:
                            "Posting Group" := RecVendor."BBG Vend. Posting Group-Retention";
                    END;
                END;
                //NDALLE021107


                //ALLEND 191107
                IF RecUserSetup.GET(USERID) THEN
                    IF RecRespCenter.GET(RecUserSetup."Purchase Resp. Ctr. Filter") THEN BEGIN
                        VALIDATE("Shortcut Dimension 1 Code", RecRespCenter."Global Dimension 1 Code");
                        VALIDATE("Project Code", RecRespCenter."Global Dimension 1 Code");
                        //  VALIDATE("Location Code",RecRespCenter."Location Code");

                        //dds-code commented in 2009 as giving problem for JOB no. posting IF "Source Code"='JOURNALV' THEN
                        //dds-code commented in 2009 as giving problem VALIDATE("Job No.",RecRespCenter."Job Code");//ALLE-PKS12

                    END;
                //ALLEND 191107
                "Branch Code" := RecUserSetup."User Branch"; //ALLETDK141112
                                                             //DDSALLE23Jan2008
                RegDimName := '';
                IF "Shortcut Dimension 1 Code" <> '' THEN BEGIN
                    IF DimValue.GET(GLSetup."Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code") THEN
                        RegDimName := DimValue.Name;
                END;
                //DDSALLE23Jan2008
            End;
        }
        modify("Document No.")
        {
            trigger OnAfterValidate()
            begin
                "Created By" := USERID;

                GenJnlNarration.RESET;
                GenJnlNarration.SETRANGE("Journal Template Name", "Journal Template Name");
                GenJnlNarration.SETRANGE("Journal Batch Name", "Journal Batch Name");
                GenJnlNarration.SETRANGE("Document No.", xRec."Document No.");
                //GenJnlNarration.SETRANGE("Gen. Journal Line No.", "Line No.");
                IF GenJnlNarration.FIND('-') THEN
                    REPEAT
                        //  GenJnlNarration."Document No." := "Document No.";
                        GenJnlNarration1 := GenJnlNarration;
                        GenJnlNarration1."Document No." := "Document No.";
                        GenJnlNarration1.INSERT;
                    UNTIL GenJnlNarration.NEXT = 0;

                GenJnlLine.RESET;
                GenJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
                GenJnlLine.SETRANGE("Journal Batch Name", "Journal Batch Name");
                GenJnlLine.SETRANGE("Document No.", xRec."Document No.");

                //GenJnlNarration.SETRANGE("Gen. Journal Line No.","Line No.");
                IF GenJnlLine.COUNT = 1 THEN BEGIN
                    GenJnlNarration.SETRANGE("Gen. Journal Line No.", 0);
                    IF GenJnlNarration.FIND('-') THEN
                        REPEAT
                            //  GenJnlNarration."Document No." := "Document No.";
                            GenJnlNarration1 := GenJnlNarration;
                            GenJnlNarration1."Document No." := "Document No.";
                            GenJnlNarration1.INSERT;
                        UNTIL GenJnlNarration.NEXT = 0;
                END;

                GenJnlNarration.RESET;
                GenJnlNarration.SETRANGE("Journal Template Name", "Journal Template Name");
                GenJnlNarration.SETRANGE("Journal Batch Name", "Journal Batch Name");
                GenJnlNarration.SETRANGE("Document No.", xRec."Document No.");
                GenJnlNarration.SETRANGE("Gen. Journal Line No.", "Line No.");
                GenJnlNarration.DELETEALL;

                GenJnlLine.RESET;
                GenJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
                GenJnlLine.SETRANGE("Journal Batch Name", "Journal Batch Name");
                GenJnlLine.SETRANGE("Document No.", xRec."Document No.");
                IF GenJnlLine.COUNT = 1 THEN BEGIN
                    GenJnlNarration.SETRANGE("Gen. Journal Line No.", 0);
                    GenJnlNarration.DELETEALL;
                END;
            end;
        }
        modify(Amount)
        {
            trigger OnBeforeValidate()
            var
                LandVendorPaymentTermsLine: Record "Land Vendor Payment Terms Line";
            begin
                "Created By" := USERID;
                //BBG2.0
                IF "Ref Document Type" = "Ref Document Type"::"Land Vendor" THEN BEGIN   //BBG2.0
                    LandVendorPaymentTermsLine.RESET;
                    IF ("Account Type" = "Account Type"::Vendor) THEN BEGIN
                        LandVendorPaymentTermsLine.RESET;
                        LandVendorPaymentTermsLine.SETRANGE(LandVendorPaymentTermsLine."Land Document No.", "Order Ref No.");
                        LandVendorPaymentTermsLine.SETRANGE("Actual Milestone", "Milestone Code");
                        LandVendorPaymentTermsLine.SETRANGE("Vendor No.", "Account No.");
                        IF LandVendorPaymentTermsLine.FINDFIRST THEN BEGIN
                            LandVendorPaymentTermsLine.CALCFIELDS("Payment Released Amount");
                            IF Amount > (LandVendorPaymentTermsLine."Due Amount" - LandVendorPaymentTermsLine."Payment Released Amount") THEN
                                ERROR('Amount can not be greater than ' + FORMAT((LandVendorPaymentTermsLine."Due Amount" - LandVendorPaymentTermsLine."Payment Released Amount")));
                        END
                        ELSE
                            ERROR('Record not found');
                    END;
                END;
                //BBG2.0
            end;
        }
        modify("Shortcut Dimension 1 Code")
        {
            trigger OnAfterValidate()
            begin

                //DDSALLE23Jan2008
                RegDimName := '';
                GLSetup.GET;
                IF Rec."Shortcut Dimension 1 Code" <> '' THEN BEGIN
                    IF DimValue.GET(GLSetup."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code") THEN
                        RegDimName := DimValue.Name;
                END;
                //DDSALLE23Jan2008
            end;
        }
        modify("TDS Certificate Receivable")
        {
            trigger OnBeforeValidate()
            begin
                IF "TDS Certificate Receivable" THEN BEGIN
                    TESTFIELD("Account Type", "Account Type"::Customer);
                    // TESTFIELD("GST TCS", FALSE);
                    // TESTFIELD("GST TDS", FALSE);
                    // VALIDATE("TDS Nature of Deduction", '');
                END;
            end;
        }
        field(50012; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0014 10-09-2007';
            TableRelation = Job;
        }
        field(50013; "Vendor Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Alle VK VSID are added for Report Booking Voucher (ID 50025)--JPL';
        }
        field(50014; "Item Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Alle PS Added field for Item No';
        }



        field(50021; "Entry Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'INS1.0';
            Editable = false;
        }
        field(50022; "Loan Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'MPS1.0';
            Enabled = false;
        }
        field(50035; "BBG Cheque No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'BBG Cheque No.';
        }






        field(55000; "Employee Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Alle PR1.0--JPL';
            TableRelation = Employee;

            trigger OnValidate()
            var
                DefaultDim: Record "Default Dimension";
            begin
                //ALLE MM Code Commented as Journal Line Dim Table has been remove in NAV 2016
                /*
                //Alle GA 091003 --- Begin (To Put Dimensions for Employee)
                DefaultDim.RESET;
                DefaultDim.SETRANGE(DefaultDim."Table ID", 5200);
                DefaultDim.SETRANGE("No.", "Employee Code");
                IF DefaultDim.FIND('-') THEN BEGIN
                  REPEAT
                    JournalLineDim.RESET;
                    JournalLineDim.SETRANGE(JournalLineDim."Journal Template Name","Journal Template Name");
                    JournalLineDim.SETRANGE("Journal Batch Name","Journal Batch Name");
                    JournalLineDim.SETRANGE("Journal Line No.","Line No.");
                    JournalLineDim.SETRANGE("Dimension Code", DefaultDim."Dimension Code");
                    IF JournalLineDim.FIND('-') THEN
                      EXIT;
                
                    JournalLineDim.RESET;
                    JournalLineDim.INIT;
                    JournalLineDim."Table ID" := 81;
                    JournalLineDim."Journal Template Name" := "Journal Template Name";
                    JournalLineDim."Journal Batch Name" := "Journal Batch Name";
                    JournalLineDim."Journal Line No." := "Line No.";
                    JournalLineDim."Dimension Code" := DefaultDim."Dimension Code";
                    JournalLineDim."Dimension Value Code" := DefaultDim."Dimension Value Code";
                    JournalLineDim.INSERT(TRUE);
                  UNTIL DefaultDim.NEXT <= 0;
                END;
                //Alle GA 091003 --- End
                */
                //ALLE MM Code Commented as Journal Line Dim Table has been remove in NAV 2016
                //ALLEMSN01 <<
                /*
                CreateDim(
                  DATABASE::Employee,"Employee Code",
                  DimMgt.TypeToTableID1("Account Type"),"Account No.",
                  DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
                  DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
                  DATABASE::Campaign,"Campaign No.");
                */
                //ALLEMSN01 >>

            end;
        }
        field(55001; "Component Code"; Code[5])
        {
            DataClassification = ToBeClassified;
            Description = 'Alle PR1.0--JPL';
        }
        field(55002; Month; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'Alle PR1.0--JPL';
        }
        field(55003; Year; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'Alle PR1.0--JPL';
        }

        field(55007; "Created By"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'NDALLE 310108';
            Editable = false;
        }
        field(55008; "Work Type"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleDK030708';
        }

        field(55010; "IC Land Purchase"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60010; "Emp Advance Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            OptionCaption = ' ,Travel Advance,Salary Advance,LTA Advance,Other Advance,Amex Corporate Card';
            OptionMembers = " ",Travel,Salary,LTA,Other,Amex;

            trigger OnValidate()
            begin
                IF ((("Account Type" = "Account Type"::Vendor) AND ("Account No." <> '')) OR
                   (("Bal. Account Type" = "Bal. Account Type"::Vendor) AND ("Bal. Account No." <> ''))) THEN BEGIN
                    IF VEndor.GET("Account No.") THEN
                        IF VEndor."BBG Is Employee" THEN BEGIN
                            VendPostingGrp.RESET;
                            VendPostingGrp.SETRANGE(VendPostingGrp."Advance Type", "Emp Advance Type");
                            IF VendPostingGrp.FIND('-') THEN;
                            "Posting Group" := VendPostingGrp.Code;
                        END ELSE BEGIN
                            TESTFIELD("Posting Type");
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
                END;
            end;
        }


        field(70030; "Provisional Bill"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }

        field(70031; "Ref. Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
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
        GLSetup: Record "General Ledger Setup";

        GenJnlLine: Record "Gen. Journal Line";

    trigger OnAfterInsert()
    begin
        IF WORKDATE < 20080221D THEN
            ERROR('You can not work on this workdate');
        "Ref Document Type" := "Ref Document Type"::Order;//GKG
                                                          //ALLETDK141112..BEGIN
        RecUserSetup.GET(USERID);
        RecUserSetup.TESTFIELD("User Branch");
        "Branch Code" := RecUserSetup."User Branch";
        //ALLETDK141112..END
        "Created By" := USERID;
    end;

    trigger OnDelete()
    var
        GenJournalNarration: record "Gen. Journal Narration";
        VGenJournalNarration: record "Gen. Journal Narration";
    begin
        GenJournalNarration.RESET;
        GenJournalNarration.SetRange("Journal Template Name", REc."Journal Template Name");
        GenJournalNarration.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        GenJournalNarration.SetRange("Document No.", REc."Document No.");
        GenJournalNarration.SetRange("Line No.", Rec."Line No.");
        IF GenJournalNarration.FindSet() then
            repeat
                GenJournalNarration.Delete;
            until GenJournalNarration.Next = 0;

        VGenJournalNarration.RESET;
        VGenJournalNarration.SetRange("Journal Template Name", REc."Journal Template Name");
        VGenJournalNarration.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        VGenJournalNarration.SetRange("Document No.", REc."Document No.");
        VGenJournalNarration.SetRange("Gen. Journal Line No.", 0);
        IF VGenJournalNarration.FindSet() then
            repeat
                VGenJournalNarration.Delete;
            Until VGenJournalNarration.Next = 0;


    end;




    PROCEDURE CheckLandVendor(P_Vendor: Record Vendor);
    VAR
        v_VendorLedgerEntry: Record "Vendor Ledger Entry";
    BEGIN
        IF P_Vendor."BBG Land Master" THEN BEGIN
            P_Vendor.TESTFIELD("BBG Allow First Pmt. to Land Vend");
            IF (P_Vendor."BBG Allow First Pmt. to Land Vend") AND (NOT P_Vendor."BBG Allow All Pmt. to Land Vend") THEN BEGIN
                v_VendorLedgerEntry.RESET;
                v_VendorLedgerEntry.SETCURRENTKEY("Vendor No.");
                v_VendorLedgerEntry.SETRANGE("Vendor No.", P_Vendor."No.");
                IF v_VendorLedgerEntry.FINDFIRST THEN
                    ERROR('You have already done the payment on Dt. ' + FORMAT(v_VendorLedgerEntry."Posting Date"));
            END;
        END;
    END;
}