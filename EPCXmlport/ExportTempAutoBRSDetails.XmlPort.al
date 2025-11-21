xmlport 97725 "Export Temp Auto BRS Details"
{
    Direction = Export;
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Temp Auto BRS Details"; "Temp Auto BRS Details")
            {
                XmlName = 'TempAutoBRSDetails';
                SourceTableView = WHERE("BALEntry Exists" = CONST(true));
                fieldelement(VLDate; "Temp Auto BRS Details"."Posting Date")
                {
                }
                textelement(Descriptions)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Descriptions := 'Bank payment voucher';
                    end;
                }
                fieldelement(TrAmount; "Temp Auto BRS Details"."Transaction Amount")
                {

                    trigger OnBeforePassField()
                    begin
                        //"Temp Auto BRS Details"."Transaction Amount" := -1*"Temp Auto BRS Details"."Transaction Amount";
                    end;
                }
                fieldelement(TrDate; "Temp Auto BRS Details"."Value Date")
                {
                }
                fieldelement(ChqNo; "Temp Auto BRS Details"."Cheque No.")
                {
                }

                trigger OnPreXmlItem()
                begin
                    "Temp Auto BRS Details".SETRANGE("USER ID", USERID);
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

    trigger OnPostXmlPort()
    begin
        MESSAGE('%1', 'Done');
    end;

    var
        BankAccount: Record "Bank Account";
        HeaderUpdated: Boolean;
        LineNo: Integer;
        "--FiledsToImport--": Integer;
        Text000: Label 'You are importing wrong Bank''s statement.';
        NewTempAutoBRSDetails: Record "Temp Auto BRS Details";

    procedure InsertBankRecoLines()
    begin
    end;
}

