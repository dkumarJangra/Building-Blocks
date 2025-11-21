tableextension 50107 "BBG Return Shipment Line Ext" extends "Return Shipment Line"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "Budget Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'JPL03';
            TableRelation = "G/L Budget Name".Name;
        }
        field(50002; "Budget Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'JPL03';
            TableRelation = "G/L Budget Entry"."Entry No." WHERE("Budget Name" = FIELD("Budget Name"));
        }
        field(50003; "Description 3"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'SC';
        }
        field(50004; "Description 4"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'SC';
        }
        field(50005; "Job Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = "Job Master";

            trigger OnLookup()
            var
                JobMst: Record "Job Master";
            begin
            end;

            trigger OnValidate()
            var
                JobMst: Record "Job Master";
                DimVal: Record "Dimension Value";
            begin
            end;
        }
        field(50006; "Indent No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = "Purchase Request Header"."Document No." WHERE("Document Type" = FILTER(Indent),
                                                                            Approved = FILTER(true));
        }
        field(50007; "Indent Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = "Purchase Request Line"."Line No." WHERE("Document Type" = FILTER(Indent),
                                                                      "Document No." = FIELD("Indent No"),
                                                                      Approved = FILTER(true));

            trigger OnLookup()
            var
                POLineRec: Record "Purchase Line";
            begin
            end;
        }
        field(50008; "Original Direct Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50020; "Basic Rate"; Decimal)
        {
            AutoFormatType = 2;
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50021; "Basic Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50022; "Excise Percent"; Decimal)
        {
            AutoFormatType = 2;
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50023; "Excise Per Unit"; Decimal)
        {
            AutoFormatType = 2;
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50024; "Tot Excise Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50025; "Sales Tax %"; Decimal)
        {
            AutoFormatType = 2;
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50026; "Sales Tax Per Unit"; Decimal)
        {
            AutoFormatType = 2;
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50027; "Tot Sales Tax Amt"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50028; "Service Tax Percent-Freight"; Decimal)
        {
            AutoFormatType = 2;
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50029; "Service Tax Per Unit-Freight"; Decimal)
        {
            AutoFormatType = 2;
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50030; "Tot Service Tax Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50031; "Entry Tax / Octroi Per Unit"; Decimal)
        {
            AutoFormatType = 2;
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50032; "Entry Tax / Octroi Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50033; "Insurance Rate"; Decimal)
        {
            AutoFormatType = 2;
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50034; "Insurance Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50035; "Packing & Forwarding %"; Decimal)
        {
            AutoFormatType = 2;
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50036; "Packing & Forwarding Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50037; "Freight Rate"; Decimal)
        {
            AutoFormatType = 2;
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50038; "Freight Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50039; "Other Rate"; Decimal)
        {
            AutoFormatType = 2;
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50040; "Other Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50041; "Tollerence Used"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ND 261205';
        }
        field(50042; "Packing & Forwarding per Unit"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50043; "Entry Tax/Octroi %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50044; "Installation & Comm. Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50045; "Installation & Comm. Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50046; "Service Tax on Inst. & Comm %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50047; "ServiceTax-Inst.Comm per unit"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50048; "ServiceTax-Inst.Comm Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50049; "Bank Charges/DD Commision Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50050; "Bank Charges/DD Commision Amt"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50051; "Inspection Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50052; "Inspection Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50053; "Other Rate 2"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50054; "Other Amount 2"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50055; "Excise Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            OptionCaption = 'Percentage,PerUnit';
            OptionMembers = Percentage,PerUnit;
        }
        field(50056; "Discount %"; Decimal)
        {
            AutoFormatType = 2;
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50057; "Discount Rate"; Decimal)
        {
            AutoFormatType = 2;
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50058; "Discount Amt"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
        }
        field(60004; "Tax Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Alle VK Fields Added to Maintain the Tax type on Line Level - 15-Jul-05';
            OptionCaption = ' ,Freight,Services,Excise,Entry Tax,Service Tax';
            OptionMembers = " ",Freight,Services,Excise,"Entry Tax","Service Tax";
        }
        field(70000; "Order Status"; Option)
        {
            CalcFormula = Lookup("Purchase Header"."Order Status" WHERE("No." = FIELD("Document No.")));
            Description = 'Field Added as a lookup to the Sales Header Order Status as Cancelled, Short Closed or Completed - ALLE SP 3/08/05';
            Editable = false;
            FieldClass = FlowField;
            OptionMembers = " ",Cancelled,"Short Closed",Completed;
        }
        field(70001; "Rejected Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Description = 'AlleBLK';
        }
        field(70002; "Rejection Note No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(70004; "GRN No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(70005; "GRN Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(70006; "PO No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(70007; "PO Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
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
}