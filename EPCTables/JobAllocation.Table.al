table 97767 "Job Allocation"
{

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FIELD("Document Type"));
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; "GL Account No."; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(6; Amount; Decimal)
        {
        }
        field(7; "Allocation Line No."; Integer)
        {
        }
        field(40; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(41; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(42; Description; Text[100])
        {
            CalcFormula = Lookup("G/L Account".Name WHERE("No." = FIELD("GL Account No.")));
            FieldClass = FlowField;
        }
        field(70004; "GRN No."; Code[20])
        {
            TableRelation = "Purch. Rcpt. Header"."No.";
        }
        field(70005; "GRN Line No."; Integer)
        {
            TableRelation = "Purch. Rcpt. Line"."Line No." WHERE("Document No." = FIELD("GRN No."));
        }
        field(70006; "PO No."; Code[20])
        {
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FILTER(Order));
        }
        field(70007; "PO Line No."; Integer)
        {
            TableRelation = "Purchase Line"."Line No." WHERE("Document No." = FIELD("PO No."),
                                                              "Document Type" = FILTER(Order));
        }
        field(70008; "PO Line Desc"; Text[100])
        {
            CalcFormula = Lookup("Purchase Line".Description WHERE("Document Type" = FILTER(Order),
                                                                    "Document No." = FIELD("PO No."),
                                                                    "Line No." = FIELD("PO Line No.")));
            FieldClass = FlowField;
        }
        field(70009; "Posting Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Purch. Inv. Header"."Posting Date" WHERE("Pre-Assigned No." = FIELD("Document No.")));

        }
        field(70010; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('CASH FLOW'));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(70011; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('CAPITALIZATION'));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(70012; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('WORK CENTER'));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.", "Allocation Line No.")
        {
            Clustered = true;
        }
        key(Key2; "PO No.", "PO Line No.", "GL Account No.")
        {
            SumIndexFields = Amount;
        }
        key(Key3; "GL Account No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        PInvLine.GET("Document Type", "Document No.", "Line No.");
        "GRN No." := PInvLine."GRN No.";
        "GRN Line No." := PInvLine."GRN Line No.";
        "PO No." := PInvLine."PO No.";
        "PO Line No." := PInvLine."PO Line No.";
    end;

    var
        PInvLine: Record "Purchase Line";
}

