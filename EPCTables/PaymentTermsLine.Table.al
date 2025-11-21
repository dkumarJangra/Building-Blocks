table 97725 "Payment Terms Line"
{
    // Alle SP VSID 0011: New Table created for multiple payment terms line for one purchase order.
    // --to be deleted - DDS
    // //AlleBLK : New field added
    // //AlleGKG : Commenting Adjust= False

    LookupPageID = "Payment Terms Line Purchase";

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
                    Description := PaymentTerms.Description;
                END
            end;
        }
        field(4; Sequence; Integer)
        {
            Description = 'Not In Use';
        }
        field(5; "Posted Document No."; Code[20])
        {
            Caption = 'Posted Payment Document No.';
            Editable = false;
        }
        field(6; "Milestone Code"; Code[20])
        {
        }
        field(7; Criteria; Option)
        {
            OptionMembers = Milestone,"% Complete";

            trigger OnValidate()
            begin
                //TESTFIELD("Stage Complete",FALSE);
            end;
        }
        field(8; "Criteria Value / Base Amount"; Decimal)
        {

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

                CalculateCriteriaValue;

            end;
        }
        field(9; "Calculation Type"; Option)
        {
            OptionMembers = "% age","Fixed Value";
        }
        field(10; "Calculation Value"; Decimal)
        {

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

                CalculateCriteriaValue;

            end;
        }
        field(11; "Due Date Calculation"; DateFormula)
        {

            trigger OnValidate()
            begin

                IF "Transaction Type" = "Transaction Type"::Purchase THEN BEGIN
                    PurchaseHeader.GET("Document Type", "Document No.");
                    "Due Date" := CALCDATE("Due Date Calculation", PurchaseHeader."Document Date");
                END;
                IF "Transaction Type" = "Transaction Type"::Sale THEN BEGIN
                    SalesHeader.GET("Document Type", "Document No.");
                    "Due Date" := CALCDATE("Due Date Calculation", SalesHeader."Document Date");
                END
            end;
        }
        field(12; "Due Amount"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(13; Status; Option)
        {
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
            OptionCaption = ' ,Advance,Running,Retention,Secured Advance,Adhoc Advance,Provisional,LD';
            OptionMembers = " ",Advance,Running,Retention,"Secured Advance","Adhoc Advance",Provisional,LD;
        }
        field(21; "Vendor Code"; Code[20])
        {
            Description = 'JPL03';
            TableRelation = Vendor;
        }
        field(50001; "Advance Debit Amt"; Decimal)
        {
            AutoFormatType = 1;
            Description = '--to be deleted - DDS';
            Editable = false;
        }
        field(50002; "Running Debit Amt"; Decimal)
        {
            AutoFormatType = 1;
            Description = '--to be deleted - DDS';
            Editable = false;
        }
        field(50003; "Retention Debit Amt"; Decimal)
        {
            AutoFormatType = 1;
            Description = '--to be deleted - DDS';
            Editable = false;
        }
        field(50004; "Secured Advance Debit Amt"; Decimal)
        {
            AutoFormatType = 1;
            Description = '--to be deleted - DDS';
            Editable = false;
        }
        field(50005; "Adhoc Advance Debit Amt"; Decimal)
        {
            AutoFormatType = 1;
            Description = '--to be deleted - DDS';
            Editable = false;
        }
        field(50006; "Provisional Debit Amt"; Decimal)
        {
            AutoFormatType = 1;
            Description = '--to be deleted - DDS';
            Editable = false;
        }
        field(50007; "Advance Credit Amt"; Decimal)
        {
            AutoFormatType = 1;
            Description = '--to be deleted - DDS';
            Editable = false;
        }
        field(50008; "Running Credit Amt"; Decimal)
        {
            AutoFormatType = 1;
            Description = '--to be deleted - DDS';
            Editable = false;
        }
        field(50009; "Retention Credit Amt"; Decimal)
        {
            AutoFormatType = 1;
            Description = '--to be deleted - DDS';
            Editable = false;
        }
        field(50010; "Secured Advance Credit Amt"; Decimal)
        {
            AutoFormatType = 1;
            Description = '--to be deleted - DDS';
            Editable = false;
        }
        field(50011; "Adhoc Advance Credit Amt"; Decimal)
        {
            AutoFormatType = 1;
            Description = '--to be deleted - DDS';
            Editable = false;
        }
        field(50012; "Provisional Credit Amt"; Decimal)
        {
            AutoFormatType = 1;
            Description = '--to be deleted - DDS';
            Editable = false;
        }
        field(50013; "Order Value"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Line Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                   "Document No." = FIELD("Document No.")));
            Description = 'AlleBLk';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50014; "Advance Amount"; Decimal)
        {
            AutoFormatType = 1;
            Description = '--to be deleted - DDS';
            Editable = false;
        }
        field(50015; "Running Amount"; Decimal)
        {
            AutoFormatType = 1;
            Description = '--to be deleted - DDS';
            Editable = false;
        }
        field(50016; "Retention Amount"; Decimal)
        {
            AutoFormatType = 1;
            Description = '--to be deleted - DDS';
            Editable = false;
        }
        field(50017; "Secured Advance Amount"; Decimal)
        {
            AutoFormatType = 1;
            Description = '--to be deleted - DDS';
            Editable = false;
        }
        field(50018; "Adhoc Advance Amount"; Decimal)
        {
            AutoFormatType = 1;
            Description = '--to be deleted - DDS';
            Editable = false;
        }
        field(50019; "Provisional Amount"; Decimal)
        {
            AutoFormatType = 1;
            Description = '--to be deleted - DDS';
            Editable = false;
        }
        field(50020; "LD Amount"; Decimal)
        {
            AutoFormatType = 1;
            Description = '--to be deleted - DDS';
            Editable = false;
        }
        field(50021; "Order Value Sale"; Decimal)
        {
            Description = '--to be deleted - DDS';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Milestone Code")
        {
            Clustered = true;
        }
        key(Key2; "Payment Type", "Milestone Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD("Payment Made", FALSE);
        IF Rec."Transaction Type" = Rec."Transaction Type"::Purchase THEN BEGIN
            PurchaseHeader.GET("Document Type", "Document No.");
            PurchaseHeader.TESTFIELD(Status, PurchaseHeader.Status::Open);
        END;
        IF Rec."Transaction Type" = Rec."Transaction Type"::Sale THEN BEGIN
            SalesHeader.GET("Document Type", "Document No.");
            SalesHeader.TESTFIELD(Status, SalesHeader.Status::Open);
        END
    end;

    trigger OnInsert()
    begin
        IF Rec."Transaction Type" = Rec."Transaction Type"::Purchase THEN BEGIN
            PurchaseHeader.GET("Document Type", "Document No.");
            PurchaseHeader.TESTFIELD(Status, PurchaseHeader.Status::Open);
            "Vendor Code" := PurchaseHeader."Buy-from Vendor No.";
        END;
        IF Rec."Transaction Type" = Rec."Transaction Type"::Sale THEN BEGIN
            SalesHeader.GET("Document Type", "Document No.");
            SalesHeader.TESTFIELD(Status, SalesHeader.Status::Open);
        END;

        IF ("Milestone Code" = '') THEN
            ERROR('Please Enter Milestone Code');

        IF ("Payment Type" = "Payment Type"::" ") THEN
            ERROR('Please Enter Payment Type');

        IF ("Payment Type" = "Payment Type"::Advance) THEN
            "Payment Made" := TRUE;

        Adjust := TRUE;
        //IF ("Payment Type" = "Payment Type"::Advance)  THEN //AlleGKG commented
        //Adjust:=FALSE; //AlleGKG commented
    end;

    trigger OnModify()
    begin
        //TESTFIELD("Payment Made",FALSE);
        IF Rec."Transaction Type" = Rec."Transaction Type"::Purchase THEN BEGIN
            PurchaseHeader.GET("Document Type", "Document No.");
            PurchaseHeader.TESTFIELD(Status, PurchaseHeader.Status::Open);
        END;
        IF Rec."Transaction Type" = Rec."Transaction Type"::Sale THEN BEGIN
            SalesHeader.GET("Document Type", "Document No.");
            SalesHeader.TESTFIELD(Status, SalesHeader.Status::Open);
        END
    end;

    var
        PaymentTerms: Record "Payment Terms";
        PurchaseHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
        Phdr: Record "Purchase Header";


    procedure CalculateCriteriaValue()
    begin
        //ALLEAB
        IF "Transaction Type" = "Transaction Type"::Purchase THEN BEGIN
            PurchaseHeader.GET("Document Type", "Document No.");
            CALCFIELDS("Order Value");
            "Criteria Value / Base Amount" := "Order Value";
        END;
        IF "Transaction Type" = "Transaction Type"::Sale THEN BEGIN
            SalesHeader.GET("Document Type", "Document No.");
            CALCFIELDS("Order Value Sale");
            "Criteria Value / Base Amount" := "Order Value Sale";
        END;
        //ALLEAB





        "Due Amount" := ROUND(("Criteria Value / Base Amount" * "Calculation Value") / 100, 1);
    end;
}

