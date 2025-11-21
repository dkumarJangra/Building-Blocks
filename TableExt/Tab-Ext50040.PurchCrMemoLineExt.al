tableextension 50040 "BBG Purch. cr. Memo Line Ext" extends "Purch. Cr. Memo Line"
{
    fields
    {
        // Add changes to table fields here
        modify("Responsibility Center")
        {
            TableRelation = "Responsibility Center 1";
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
            Description = '--JPL';
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
            Caption = 'Purch. Req. No.';
            DataClassification = ToBeClassified;
            Description = '--JPL';
            TableRelation = "Purchase Request Header"."Document No." WHERE("Document Type" = FILTER(Indent),
                                                                            Approved = FILTER(true));
        }
        field(50007; "Indent Line No"; Integer)
        {
            Caption = 'Purch. Req. Line No';
            DataClassification = ToBeClassified;
            Description = '--JPL';
            TableRelation = "Purchase Request Line"."Line No." WHERE("Document Type" = FILTER(Indent),
                                                                      "Document No." = FIELD("Indent No"),
                                                                      Approved = FILTER(true));

            trigger OnLookup()
            var
                POLineRec: Record "Purchase Line";
            begin
            end;
        }
        field(50041; "Tollerence Used"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ND 261205--JPL';
        }
        field(70000; "Order Status"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Field Added as a lookup to the Sales Header Order Status as Cancelled, Short Closed or Completed - ALLE SP 3/08/05--JPL';
            Editable = false;
            OptionMembers = " ",Cancelled,"Short Closed",Completed;
        }
        field(70001; "Rejected Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Description = '--JPL';
        }
        field(70002; "Rejection Note No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(70003; "Approved Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'SC--JPL';
        }
        field(70004; "GRN No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(70005; "GRN Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(70006; "PO No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(70007; "PO Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(70008; Blocked; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
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