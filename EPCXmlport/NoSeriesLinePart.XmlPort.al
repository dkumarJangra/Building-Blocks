xmlport 50015 "No Series Line Part"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("No. Series Line"; "No. Series Line")
            {
                XmlName = 'NoSeriesLine';
                fieldelement(SCode; "No. Series Line"."Series Code")
                {
                }
                fieldelement(NSDate; "No. Series Line"."Starting Date")
                {
                }
                fieldelement(StNo; "No. Series Line"."Starting No.")
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    NSLine.RESET;
                    NSLine.SETRANGE(NSLine."Series Code", "No. Series Line"."Series Code");
                    IF NSLine.FINDLAST THEN
                        "No. Series Line"."Line No." := NSLine."Line No." + 10000
                    ELSE
                        "No. Series Line"."Line No." := 10000;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    var
        NSLine: Record "No. Series Line";
}

