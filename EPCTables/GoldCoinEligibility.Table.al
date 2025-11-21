table 97827 "Gold Coin Eligibility"
{

    fields
    {
        field(1; "Project Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Responsibility Center 1";
        }
        field(2; "Application No."; Code[20])
        {
            Editable = false;
            TableRelation = "Confirmed Order";
        }
        field(3; "Application Date"; Date)
        {
            Editable = false;
        }
        field(4; "Customer No."; Code[20])
        {
            Editable = false;
            TableRelation = Customer;

            trigger OnValidate()
            begin
                IF "Customer No." <> '' THEN
                    IF Cust.GET("Customer No.") THEN
                        "Customer Name" := Cust.Name;
            end;
        }
        field(5; "Customer Name"; Text[60])
        {
            Editable = false;
        }
        field(6; "Due Amount"; Decimal)
        {
            Editable = false;
        }
        field(7; "Amount Received"; Decimal)
        {
            Editable = false;
        }
        field(8; "Min. Allotment"; Decimal)
        {
            Editable = false;
        }
        field(9; "Plot No."; Code[20])
        {
            Editable = false;
            TableRelation = "Unit Master";
        }
        field(10; "Total Unit Amount"; Decimal)
        {
            Editable = false;
        }
        field(11; "Issue Request"; Boolean)
        {

            trigger OnValidate()
            begin
                TESTFIELD(Approved, TRUE);
            end;
        }
        field(12; "Send for Approval"; Boolean)
        {

            trigger OnValidate()
            begin
                TESTFIELD(Approved, FALSE);

                IF "Send for Approval" THEN BEGIN
                    "Sent By for Approval" := USERID;
                    USER.RESET;
                    USER.SETRANGE("User Name", USERID);
                    IF USER.FINDFIRST THEN
                        "Sent By for Approval Name" := USER."User Name";
                END ELSE BEGIN
                    "Sent By for Approval" := '';
                    "Sent By for Approval Name" := '';
                END;
            end;
        }
        field(13; Approved; Boolean)
        {
            Editable = false;

            trigger OnValidate()
            begin
                MemberOf.RESET;
                MemberOf.SETRANGE("User Name", USERID);
                MemberOf.SETRANGE("Role ID", 'GOLDCOINAPP');
                IF NOT MemberOf.FINDFIRST THEN
                    ERROR('You are not authorised to Approved this Eligibility');

                IF Approved THEN BEGIN
                    "Approved By" := USERID;
                    USER.RESET;
                    USER.SETRANGE("User Name", USERID);
                    IF USER.FINDFIRST THEN
                        "Approver Name" := USER."User Name";
                END ELSE BEGIN
                    "Approved By" := '';
                    "Approver Name" := '';
                END;
            end;
        }
        field(14; "Issued to Customer"; Boolean)
        {
            Editable = false;

            trigger OnValidate()
            begin
                /*
                CALCFIELDS("Issued Gold");
                IF "Issued Gold" = "Eligibility Gold"  THEN
                  "Gold Issue Status" := "Gold Issue Status" ::Full
                ELSE
                  "Gold Issue Status" := "Gold Issue Status" ::Partial;
                
                "Issued to Customer" := TRUE;
                 */

            end;
        }
        field(15; "Issued Date"; Date)
        {
            Editable = false;
        }
        field(16; "Eligibility Gold / Silver"; Integer)
        {
            Editable = false;
        }
        field(17; "Due Date"; Date)
        {
        }
        field(18; Extent; Decimal)
        {
        }
        field(19; "Last Payment Date"; Date)
        {
        }
        field(20; "Issued Gold / Silver"; Decimal)
        {
            CalcFormula = Sum("Gate Pass Line".Qty WHERE("Application No." = FIELD("Application No."),
                                                          "Application Line No." = FIELD("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Balance Gold / Silver"; Integer)
        {
        }
        field(22; "Agent ID"; Code[20])
        {
        }
        field(23; "Agent Name"; Text[60])
        {
        }
        field(24; "Min Doc No."; Code[20])
        {
            Editable = false;
        }
        field(25; "Total No.of Gold/Silver Issued"; Decimal)
        {
            CalcFormula = - Sum("Item Ledger Entry".Quantity WHERE("Application No." = FIELD("Application No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(26; "Line No."; Integer)
        {
        }
        field(27; "Approved By"; Code[20])
        {
            Editable = false;
        }
        field(28; "Approver Name"; Text[60])
        {
            Editable = false;
        }
        field(29; "Sent By for Approval"; Code[20])
        {
            Editable = false;
        }
        field(30; "Sent By for Approval Name"; Text[60])
        {
            Editable = false;
        }
        field(31; Status; Option)
        {
            Description = 'BBG1.01';
            Editable = false;
            OptionCaption = 'Normal,Return';
            OptionMembers = Normal,Return;
        }
        field(32; "Approval Date"; Date)
        {
            Description = 'ALLECK 311212';
        }
        field(33; "Gold/Silver Issue Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Partial,Full';
            OptionMembers = Partial,Full;
        }
        field(34; "Gold/Silver Issue upload"; Decimal)
        {
            Description = 'BBG1.00 For historical';
            Editable = false;
        }
        field(35; "Gold/Silver Issue Date Upload"; Date)
        {
            Editable = false;
        }
        field(36; "Gold/Silver Elegibility Upload"; Decimal)
        {
            Editable = false;
        }
        field(37; "Item Type"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Gold,Silver';
            OptionMembers = " ",Gold,Silver;
        }
        field(38; Select; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Project Code", "Application No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Customer No.", "Project Code")
        {
        }
        key(Key3; "Customer Name")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD(Approved, FALSE);
    end;

    var
        Cust: Record Customer;
        USER: Record User;
        MemberOf: Record "Access Control";
}

