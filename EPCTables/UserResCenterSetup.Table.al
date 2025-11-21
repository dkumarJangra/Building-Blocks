table 97746 "User Res. Center Setup"
{
    LookupPageID = "Job Planning Line Subform Sch.";

    fields
    {
        field(1; "User ID"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(3; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center 1".Code;
            trigger OnValidate()
            var
                RespCenter1: Record "Responsibility Center 1";
            begin
                RespCenter1.RESET;
                IF RespCenter1.GET("Responsibility Center") THEN
                    "Responsibility Center Name New" := RespCenter1.Name;

            end;
        }
        field(4; "Responsibility Center Name"; Text[100])
        {
            CalcFormula = Lookup("Responsibility Center 1".Name WHERE(Code = FIELD("Responsibility Center")));
            FieldClass = FlowField;
        }
        field(5; "Responsibility Center Name New"; Text[100])
        {

            Caption = 'Responsibility Center Name';
        }
    }

    keys
    {
        key(Key1; "User ID", "Responsibility Center")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        GenJnlTemplate: Record "Gen. Journal Template";
        ItemJnlTemplate: Record "Item Journal Template";
        ReqWorksheetTemplate: Record "Req. Wksh. Template";
}

