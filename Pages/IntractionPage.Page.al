page 60702 "Intraction Page"
{
    AutoSplitKey = true;
    PageType = List;
    SourceTable = "Customer Intraction Details";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer Prospect Line No."; Rec."Customer Prospect Line No.")
                {
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                }
                field(Date; Rec.Date)
                {
                }
                field(Duration; Rec.Duration)
                {
                }
                field("Followup Type"; Rec."Followup Type")
                {
                }
                field("Followup Date"; Rec."Followup Date")
                {
                }
                field("Followup Time"; Rec."Followup Time")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //"Contact No." := CustContactNo_1;
        //"Customer Prospect Line No." := CustLineNo_1;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //"Contact No." := CustContactNo_1;
        //"Customer Prospect Line No." := CustLineNo_1;
    end;

    var
        CustContactNo_1: Code[20];
        CustLineNo_1: Integer;


    procedure Setvalues(CustContactNo: Code[20]; CustLineNo: Integer)
    begin
        CustContactNo_1 := CustContactNo;
        CustLineNo_1 := CustLineNo;
    end;
}

