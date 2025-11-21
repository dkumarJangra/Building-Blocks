xmlport 50080 "TDS to Vend data upload"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Gen. Journal Line"; "Gen. Journal Line")
            {
                XmlName = 'GenJournalLine';
                fieldelement(JrnlTemplateName; "Gen. Journal Line"."Journal Template Name")
                {
                }
                fieldelement(JrnlBatchName; "Gen. Journal Line"."Journal Batch Name")
                {
                }
                fieldelement(LineNo; "Gen. Journal Line"."Line No.")
                {
                }
                fieldelement(DocNo; "Gen. Journal Line"."Document No.")
                {
                }
                fieldelement(PostingDate; "Gen. Journal Line"."Posting Date")
                {
                }
                fieldelement(AccType; "Gen. Journal Line"."Account Type")
                {
                }
                fieldelement(AccNo; "Gen. Journal Line"."Account No.")
                {
                }
                fieldelement(Amt; "Gen. Journal Line".Amount)
                {
                }
                fieldelement(BalAccType; "Gen. Journal Line"."Bal. Account Type")
                {
                }
                fieldelement(BalAccNo; "Gen. Journal Line"."Bal. Account No.")
                {
                }
                fieldelement(PostingType; "Gen. Journal Line"."Posting Type")
                {
                }
                fieldelement(Verified; "Gen. Journal Line".Verified)
                {
                }
                fieldelement(ExtDocNo; "Gen. Journal Line"."External Document No.")
                {
                }
                fieldelement(Desc; "Gen. Journal Line".Description)
                {
                }
                fieldelement(VerifiedBy; "Gen. Journal Line"."Verified By")
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
}

