xmlport 97724 "Temp Auto BRS Details"
{
    // ALLESC YN013, YN016 10-03-2009: New Object Created for Importing "Bank Statement" & "Payment Gateway Statement".
    // ALLERK 19-03-2010: Code added for document type wise reconciliation.

    Direction = Import;
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Temp Auto BRS Details"; "Temp Auto BRS Details")
            {
                XmlName = 'TempAutoBRSDetails';
                fieldelement(EntryNo; "Temp Auto BRS Details"."Entry No.")
                {

                    trigger OnAfterAssignField()
                    begin
                        "Temp Auto BRS Details"."USER ID" := USERID;
                    end;
                }
                fieldelement(TrDate; "Temp Auto BRS Details"."Transaction Date")
                {
                }
                fieldelement(VLDate; "Temp Auto BRS Details"."Value Date")
                {
                }
                fieldelement(RefNo; "Temp Auto BRS Details"."Reference No.")
                {
                }
                fieldelement(TrDesc; "Temp Auto BRS Details"."Transaction Description")
                {
                }
                fieldelement(TrAmount; "Temp Auto BRS Details"."Transaction Amount")
                {
                }
                fieldelement(BankNo; "Temp Auto BRS Details"."Bank Account No.")
                {
                }
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

