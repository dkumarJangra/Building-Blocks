pageextension 50003 "BBG G/L Account Card Ext" extends "G/L Account Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            field("BBG Name 2"; Rec."BBG Name 2")
            {
                ApplicationArea = all;
            }
        }
        addafter("New Page")
        {
            field("BBG Branch Code"; Rec."BBG Branch Code")
            {
                ApplicationArea = all;
            }
            field("BBG Branch Name"; Rec."BBG Branch Name")
            {
                ApplicationArea = all;
            }
        }
        addafter("Omit Default Descr. in Jnl.")
        {
            field("BBG Cash Account"; Rec."BBG Cash Account")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;

    LOCAL PROCEDURE SetSecurity(OpenForm: Boolean);
    BEGIN
        //   //BBG1.00 ALLEDK 050313
        //   IF OpenForm THEN BEGIN
        //     IF NOT Security.GetSecurity(FORM::"G/L Account Card") THEN
        //       EXIT;

        //     IF Security."Form General Permission" = Security."Form General Permission"::Visible THEN
        //       CurrForm.EDI(FALSE);

        //     Security.SetFieldFilters(Rec);
        //   END ELSE
        //     IF Security."Security for Form No." = 0 THEN
        //       EXIT;

        //   IF CurrForm."No.".EDI THEN
        //     CurrForm."No.".EDI(Security."No." = 0);
        //   CurrForm."No.".VISIBLE(Security."No." IN [0,1,3,4]);
        //   IF Security."No." IN [2,5] THEN
        //     SETRANGE("No.");
        //   IF CurrForm.Name.EDI THEN
        //     CurrForm.Name.EDI(Security.Name = 0);
        //   CurrForm.Name.VISIBLE(Security.Name IN [0,1,3,4]);
        //   IF Security.Name IN [2,5] THEN
        //     SETRANGE(Name);
        //   IF CurrForm."Search Name".EDI THEN
        //     CurrForm."Search Name".EDI(Security."Search Name" = 0);
        //   CurrForm."Search Name".VISIBLE(Security."Search Name" IN [0,1,3,4]);
        //   IF Security."Search Name" IN [2,5] THEN
        //     SETRANGE("Search Name");
        //   IF CurrForm."Account Type".EDI THEN
        //     CurrForm."Account Type".EDI(Security."Account Type" = 0);
        //   CurrForm."Account Type".VISIBLE(Security."Account Type" IN [0,1,3,4]);
        //   IF Security."Account Type" IN [2,5] THEN
        //     SETRANGE("Account Type");
        //   IF CurrForm."Income/Balance".EDI THEN
        //     CurrForm."Income/Balance".EDI(Security."Income/Balance" = 0);
        //   CurrForm."Income/Balance".VISIBLE(Security."Income/Balance" IN [0,1,3,4]);
        //   IF Security."Income/Balance" IN [2,5] THEN
        //     SETRANGE("Income/Balance");
        //   IF CurrForm."Debit/Credit".EDI THEN
        //     CurrForm."Debit/Credit".EDI(Security."Debit/Credit" = 0);
        //   CurrForm."Debit/Credit".VISIBLE(Security."Debit/Credit" IN [0,1,3,4]);
        //   IF Security."Debit/Credit" IN [2,5] THEN
        //     SETRANGE("Debit/Credit");
        //   IF CurrForm.Blocked.EDI THEN
        //     CurrForm.Blocked.EDI(Security.Blocked = 0);
        //   CurrForm.Blocked.VISIBLE(Security.Blocked IN [0,1,3,4]);
        //   IF Security.Blocked IN [2,5] THEN
        //     SETRANGE(Blocked);
        //   IF CurrForm."Direct Posting".EDI THEN
        //     CurrForm."Direct Posting".EDI(Security."Direct Posting" = 0);
        //   CurrForm."Direct Posting".VISIBLE(Security."Direct Posting" IN [0,1,3,4]);
        //   IF Security."Direct Posting" IN [2,5] THEN
        //     SETRANGE("Direct Posting");
        //   IF CurrForm."Reconciliation Account".EDI THEN
        //     CurrForm."Reconciliation Account".EDI(Security."Reconciliation Account" = 0);
        //   CurrForm."Reconciliation Account".VISIBLE(Security."Reconciliation Account" IN [0,1,3,4]);
        //   IF Security."Reconciliation Account" IN [2,5] THEN
        //     SETRANGE("Reconciliation Account");
        //   IF CurrForm."New Page".EDI THEN
        //     CurrForm."New Page".EDI(Security."New Page" = 0);
        //   CurrForm."New Page".VISIBLE(Security."New Page" IN [0,1,3,4]);
        //   IF Security."New Page" IN [2,5] THEN
        //     SETRANGE("New Page");
        //   IF CurrForm."No. of Blank Lines".EDI THEN
        //     CurrForm."No. of Blank Lines".EDI(Security."No. of Blank Lines" = 0);
        //   CurrForm."No. of Blank Lines".VISIBLE(Security."No. of Blank Lines" IN [0,1,3,4]);
        //   IF Security."No. of Blank Lines" IN [2,5] THEN
        //     SETRANGE("No. of Blank Lines");
        //   IF CurrForm."Last Date Modified".EDI THEN
        //     CurrForm."Last Date Modified".EDI(Security."Last Date Modified" = 0);
        //   CurrForm."Last Date Modified".VISIBLE(Security."Last Date Modified" IN [0,1,3,4]);
        //   IF Security."Last Date Modified" IN [2,5] THEN
        //     SETRANGE("Last Date Modified");
        //   IF CurrForm.Totaling.EDI THEN
        //     CurrForm.Totaling.EDI(Security.Totaling = 0);
        //   CurrForm.Totaling.VISIBLE(Security.Totaling IN [0,1,3,4]);
        //   IF Security.Totaling IN [2,5] THEN
        //     SETRANGE(Totaling);
        //   IF CurrForm.Balance.EDI THEN
        //     CurrForm.Balance.EDI(Security.Balance = 0);
        //   CurrForm.Balance.VISIBLE(Security.Balance IN [0,1,3,4]);
        //   IF Security.Balance IN [2,5] THEN
        //     SETRANGE(Balance);
        //   IF CurrForm."Consol. Translation Method".EDI THEN
        //     CurrForm."Consol. Translation Method".EDI(Security."Consol. Translation Method" = 0);
        //   CurrForm."Consol. Translation Method".VISIBLE(Security."Consol. Translation Method" IN [0,1,3,4]);
        //   IF Security."Consol. Translation Method" IN [2,5] THEN
        //     SETRANGE("Consol. Translation Method");
        //   IF CurrForm."Consol. Debit Acc.".EDI THEN
        //     CurrForm."Consol. Debit Acc.".EDI(Security."Consol. Debit Acc." = 0);
        //   CurrForm."Consol. Debit Acc.".VISIBLE(Security."Consol. Debit Acc." IN [0,1,3,4]);
        //   IF Security."Consol. Debit Acc." IN [2,5] THEN
        //     SETRANGE("Consol. Debit Acc.");
        //   IF CurrForm."Consol. Credit Acc.".EDI THEN
        //     CurrForm."Consol. Credit Acc.".EDI(Security."Consol. Credit Acc." = 0);
        //   CurrForm."Consol. Credit Acc.".VISIBLE(Security."Consol. Credit Acc." IN [0,1,3,4]);
        //   IF Security."Consol. Credit Acc." IN [2,5] THEN
        //     SETRANGE("Consol. Credit Acc.");
        //   IF CurrForm."Gen. Posting Type".EDI THEN
        //     CurrForm."Gen. Posting Type".EDI(Security."Gen. Posting Type" = 0);
        //   CurrForm."Gen. Posting Type".VISIBLE(Security."Gen. Posting Type" IN [0,1,3,4]);
        //   IF Security."Gen. Posting Type" IN [2,5] THEN
        //     SETRANGE("Gen. Posting Type");
        //   IF CurrForm."Gen. Bus. Posting Group".EDI THEN
        //     CurrForm."Gen. Bus. Posting Group".EDI(Security."Gen. Bus. Posting Group" = 0);
        //   CurrForm."Gen. Bus. Posting Group".VISIBLE(Security."Gen. Bus. Posting Group" IN [0,1,3,4]);
        //   IF Security."Gen. Bus. Posting Group" IN [2,5] THEN
        //     SETRANGE("Gen. Bus. Posting Group");
        //   IF CurrForm."Gen. Prod. Posting Group".EDI THEN
        //     CurrForm."Gen. Prod. Posting Group".EDI(Security."Gen. Prod. Posting Group" = 0);
        //   CurrForm."Gen. Prod. Posting Group".VISIBLE(Security."Gen. Prod. Posting Group" IN [0,1,3,4]);
        //   IF Security."Gen. Prod. Posting Group" IN [2,5] THEN
        //     SETRANGE("Gen. Prod. Posting Group");
        //   IF CurrForm."Automatic Ext. Texts".EDI THEN
        //     CurrForm."Automatic Ext. Texts".EDI(Security."Automatic Ext. Texts" = 0);
        //   CurrForm."Automatic Ext. Texts".VISIBLE(Security."Automatic Ext. Texts" IN [0,1,3,4]);
        //   IF Security."Automatic Ext. Texts" IN [2,5] THEN
        //     SETRANGE("Automatic Ext. Texts");
        //   IF CurrForm."Tax Group Code".EDI THEN
        //     CurrForm."Tax Group Code".EDI(Security."Tax Group Code" = 0);
        //   CurrForm."Tax Group Code".VISIBLE(Security."Tax Group Code" IN [0,1,3,4]);
        //   IF Security."Tax Group Code" IN [2,5] THEN
        //     SETRANGE("Tax Group Code");
        //   IF CurrForm."VAT Bus. Posting Group".EDI THEN
        //     CurrForm."VAT Bus. Posting Group".EDI(Security."VAT Bus. Posting Group" = 0);
        //   CurrForm."VAT Bus. Posting Group".VISIBLE(Security."VAT Bus. Posting Group" IN [0,1,3,4]);
        //   IF Security."VAT Bus. Posting Group" IN [2,5] THEN
        //     SETRANGE("VAT Bus. Posting Group");
        //   IF CurrForm."VAT Prod. Posting Group".EDI THEN
        //     CurrForm."VAT Prod. Posting Group".EDI(Security."VAT Prod. Posting Group" = 0);
        //   CurrForm."VAT Prod. Posting Group".VISIBLE(Security."VAT Prod. Posting Group" IN [0,1,3,4]);
        //   IF Security."VAT Prod. Posting Group" IN [2,5] THEN
        //     SETRANGE("VAT Prod. Posting Group");
        //   IF CurrForm."Exchange Rate Adjustment".EDI THEN
        //     CurrForm."Exchange Rate Adjustment".EDI(Security."Exchange Rate Adjustment" = 0);
        //   CurrForm."Exchange Rate Adjustment".VISIBLE(Security."Exchange Rate Adjustment" IN [0,1,3,4]);
        //   IF Security."Exchange Rate Adjustment" IN [2,5] THEN
        //     SETRANGE("Exchange Rate Adjustment");
        //   IF CurrForm."Default IC Partner G/L Acc. No".EDI THEN
        //     CurrForm."Default IC Partner G/L Acc. No".EDI(Security."Default IC Partner G/L Acc. No" = 0);
        //   CurrForm."Default IC Partner G/L Acc. No".VISIBLE(Security."Default IC Partner G/L Acc. No" IN [0,1,3,4]);
        //   IF Security."Default IC Partner G/L Acc. No" IN [2,5] THEN
        //     SETRANGE("Default IC Partner G/L Acc. No");
        //   IF CurrForm."Service Tax Group Code".EDI THEN
        //     CurrForm."Service Tax Group Code".EDI(Security."Service Tax Group Code" = 0);
        //   CurrForm."Service Tax Group Code".VISIBLE(Security."Service Tax Group Code" IN [0,1,3,4]);
        //   IF Security."Service Tax Group Code" IN [2,5] THEN
        //     SETRANGE("Service Tax Group Code");
        //   IF CurrForm."FBT Group Code".EDI THEN
        //     CurrForm."FBT Group Code".EDI(Security."FBT Group Code" = 0);
        //   CurrForm."FBT Group Code".VISIBLE(Security."FBT Group Code" IN [0,1,3,4]);
        //   IF Security."FBT Group Code" IN [2,5] THEN
        //     SETRANGE("FBT Group Code");
        //   IF CurrForm."Excise Prod. Posting Group".EDI THEN
        //     CurrForm."Excise Prod. Posting Group".EDI(Security."Excise Prod. Posting Group" = 0);
        //   CurrForm."Excise Prod. Posting Group".VISIBLE(Security."Excise Prod. Posting Group" IN [0,1,3,4]);
        //   IF Security."Excise Prod. Posting Group" IN [2,5] THEN
        //     SETRANGE("Excise Prod. Posting Group");
        //   IF CurrForm."Capital Item".EDI THEN
        //     CurrForm."Capital Item".EDI(Security."Capital Item" = 0);
        //   CurrForm."Capital Item".VISIBLE(Security."Capital Item" IN [0,1,3,4]);
        //   IF Security."Capital Item" IN [2,5] THEN
        //     SETRANGE("Capital Item");
        //   IF CurrForm."Analysis Account Type".EDI THEN
        //     CurrForm."Analysis Account Type".EDI(Security."Analysis Account Type" = 0);
        //   CurrForm."Analysis Account Type".VISIBLE(Security."Analysis Account Type" IN [0,1,3,4]);
        //   IF Security."Analysis Account Type" IN [2,5] THEN
        //     SETRANGE("Analysis Account Type");
        //   IF CurrForm."Cash Account".EDI THEN
        //     CurrForm."Cash Account".EDI(Security."Cash Account" = 0);
        //   CurrForm."Cash Account".VISIBLE(Security."Cash Account" IN [0,1,3,4]);
        //   IF Security."Cash Account" IN [2,5] THEN
        //     SETRANGE("Cash Account");



        //BBG1.00 ALLEDK 050313
    END;
}