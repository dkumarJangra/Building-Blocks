pageextension 50002 "BBG Chart Of Accounts Ext" extends "Chart of Accounts"
{
    layout
    {
        // Add changes to page layout here
        modify("Debit Amount")
        {
            ApplicationArea = all;
            Visible = true;
        }
        modify("Credit Amount")
        {
            ApplicationArea = all;
            Visible = true;
        }
        addafter(Name)
        {
            field("BBG Name 2"; Rec."BBG Name 2")
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
        UserSetup: Record "User Setup";

    trigger OnOpenPage()
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("View of Chart of Account", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            UserSetup.TESTFIELD("View of Chart of Account");
    end;

    LOCAL PROCEDURE SetSecurity(OpenForm: Boolean);
    BEGIN

        //   //ALLEDK 040313
        //   IF OpenForm THEN BEGIN
        //     IF NOT Security.GetSecurity(FORM::"Chart of Accounts") THEN
        //       EXIT;

        //     IF Security."Form General Permission" = Security."Form General Permission"::Visible THEN
        //       CurrForm.EDI(FALSE);

        //     Security.SetFieldFilters(Rec);
        //   END ELSE
        //     IF Security."Security for Form No." = 0 THEN
        //       EXIT;

        //   IF CurrForm."No.".EDI THEN
        //     CurrForm."No.".EDI(Security."No." = 0);
        //   IF Security."No." IN [2,5] THEN BEGIN
        //     CurrForm."No.".VISIBLE(FALSE);
        //     SETRANGE("No.");
        //   END;
        //   IF CurrForm.Name.EDI THEN
        //     CurrForm.Name.EDI(Security.Name = 0);
        //   IF Security.Name IN [2,5] THEN BEGIN
        //     CurrForm.Name.VISIBLE(FALSE);
        //     SETRANGE(Name);
        //   END;
        //   IF CurrForm."Account Type".EDI THEN
        //     CurrForm."Account Type".EDI(Security."Account Type" = 0);
        //   IF Security."Account Type" IN [2,5] THEN BEGIN
        //     CurrForm."Account Type".VISIBLE(FALSE);
        //     SETRANGE("Account Type");
        //   END;
        //   IF CurrForm."Income/Balance".EDI THEN
        //     CurrForm."Income/Balance".EDI(Security."Income/Balance" = 0);
        //   IF Security."Income/Balance" IN [2,5] THEN BEGIN
        //     CurrForm."Income/Balance".VISIBLE(FALSE);
        //     SETRANGE("Income/Balance");
        //   END;
        //   IF CurrForm.Blocked.EDI THEN
        //     CurrForm.Blocked.EDI(Security.Blocked = 0);
        //   IF Security.Blocked IN [2,5] THEN BEGIN
        //     CurrForm.Blocked.VISIBLE(FALSE);
        //     SETRANGE(Blocked);
        //   END;
        //   IF CurrForm."Direct Posting".EDI THEN
        //     CurrForm."Direct Posting".EDI(Security."Direct Posting" = 0);
        //   IF Security."Direct Posting" IN [2,5] THEN BEGIN
        //     CurrForm."Direct Posting".VISIBLE(FALSE);
        //     SETRANGE("Direct Posting");
        //   END;
        //   IF CurrForm."Balance at Date".EDI THEN
        //     CurrForm."Balance at Date".EDI(Security."Balance at Date" = 0);
        //   IF Security."Balance at Date" IN [2,5] THEN BEGIN
        //     CurrForm."Balance at Date".VISIBLE(FALSE);
        //     SETRANGE("Balance at Date");
        //   END;
        //   IF CurrForm."Net Change".EDI THEN
        //     CurrForm."Net Change".EDI(Security."Net Change" = 0);
        //   IF Security."Net Change" IN [2,5] THEN BEGIN
        //     CurrForm."Net Change".VISIBLE(FALSE);
        //     SETRANGE("Net Change");
        //   END;
        //   IF CurrForm.Totaling.EDI THEN
        //     CurrForm.Totaling.EDI(Security.Totaling = 0);
        //   IF Security.Totaling IN [2,5] THEN BEGIN
        //     CurrForm.Totaling.VISIBLE(FALSE);
        //     SETRANGE(Totaling);
        //   END;
        //   IF CurrForm.Balance.EDI THEN
        //     CurrForm.Balance.EDI(Security.Balance = 0);
        //   IF Security.Balance IN [2,5] THEN BEGIN
        //     CurrForm.Balance.VISIBLE(FALSE);
        //     SETRANGE(Balance);
        //   END;
        //   IF CurrForm."Consol. Translation Method".EDI THEN
        //     CurrForm."Consol. Translation Method".EDI(Security."Consol. Translation Method" = 0);
        //   IF Security."Consol. Translation Method" IN [2,5] THEN BEGIN
        //     CurrForm."Consol. Translation Method".VISIBLE(FALSE);
        //     SETRANGE("Consol. Translation Method");
        //   END;
        //   IF CurrForm."Consol. Debit Acc.".EDI THEN
        //     CurrForm."Consol. Debit Acc.".EDI(Security."Consol. Debit Acc." = 0);
        //   IF Security."Consol. Debit Acc." IN [2,5] THEN BEGIN
        //     CurrForm."Consol. Debit Acc.".VISIBLE(FALSE);
        //     SETRANGE("Consol. Debit Acc.");
        //   END;
        //   IF CurrForm."Consol. Credit Acc.".EDI THEN
        //     CurrForm."Consol. Credit Acc.".EDI(Security."Consol. Credit Acc." = 0);
        //   IF Security."Consol. Credit Acc." IN [2,5] THEN BEGIN
        //     CurrForm."Consol. Credit Acc.".VISIBLE(FALSE);
        //     SETRANGE("Consol. Credit Acc.");
        //   END;
        //   IF CurrForm."Gen. Posting Type".EDI THEN
        //     CurrForm."Gen. Posting Type".EDI(Security."Gen. Posting Type" = 0);
        //   IF Security."Gen. Posting Type" IN [2,5] THEN BEGIN
        //     CurrForm."Gen. Posting Type".VISIBLE(FALSE);
        //     SETRANGE("Gen. Posting Type");
        //   END;
        //   IF CurrForm."Gen. Bus. Posting Group".EDI THEN
        //     CurrForm."Gen. Bus. Posting Group".EDI(Security."Gen. Bus. Posting Group" = 0);
        //   IF Security."Gen. Bus. Posting Group" IN [2,5] THEN BEGIN
        //     CurrForm."Gen. Bus. Posting Group".VISIBLE(FALSE);
        //     SETRANGE("Gen. Bus. Posting Group");
        //   END;
        //   IF CurrForm."Gen. Prod. Posting Group".EDI THEN
        //     CurrForm."Gen. Prod. Posting Group".EDI(Security."Gen. Prod. Posting Group" = 0);
        //   IF Security."Gen. Prod. Posting Group" IN [2,5] THEN BEGIN
        //     CurrForm."Gen. Prod. Posting Group".VISIBLE(FALSE);
        //     SETRANGE("Gen. Prod. Posting Group");
        //   END;
        //   IF CurrForm."VAT Bus. Posting Group".EDI THEN
        //     CurrForm."VAT Bus. Posting Group".EDI(Security."VAT Bus. Posting Group" = 0);
        //   IF Security."VAT Bus. Posting Group" IN [2,5] THEN BEGIN
        //     CurrForm."VAT Bus. Posting Group".VISIBLE(FALSE);
        //     SETRANGE("VAT Bus. Posting Group");
        //   END;
        //   IF CurrForm."VAT Prod. Posting Group".EDI THEN
        //     CurrForm."VAT Prod. Posting Group".EDI(Security."VAT Prod. Posting Group" = 0);
        //   IF Security."VAT Prod. Posting Group" IN [2,5] THEN BEGIN
        //     CurrForm."VAT Prod. Posting Group".VISIBLE(FALSE);
        //     SETRANGE("VAT Prod. Posting Group");
        //   END;
        //   IF CurrForm."Additional-Currency Net Change".EDI THEN
        //     CurrForm."Additional-Currency Net Change".EDI(Security."Additional-Currency Net Change" = 0);
        //   IF Security."Additional-Currency Net Change" IN [2,5] THEN BEGIN
        //     CurrForm."Additional-Currency Net Change".VISIBLE(FALSE);
        //     SETRANGE("Additional-Currency Net Change");
        //   END;
        //   IF CurrForm."Add.-Currency Balance at Date".EDI THEN
        //     CurrForm."Add.-Currency Balance at Date".EDI(Security."Add.-Currency Balance at Date" = 0);
        //   IF Security."Add.-Currency Balance at Date" IN [2,5] THEN BEGIN
        //     CurrForm."Add.-Currency Balance at Date".VISIBLE(FALSE);
        //     SETRANGE("Add.-Currency Balance at Date");
        //   END;
        //   IF CurrForm."Additional-Currency Balance".EDI THEN
        //     CurrForm."Additional-Currency Balance".EDI(Security."Additional-Currency Balance" = 0);
        //   IF Security."Additional-Currency Balance" IN [2,5] THEN BEGIN
        //     CurrForm."Additional-Currency Balance".VISIBLE(FALSE);
        //     SETRANGE("Additional-Currency Balance");
        //   END;
        //   IF CurrForm."Default IC Partner G/L Acc. No".EDI THEN
        //     CurrForm."Default IC Partner G/L Acc. No".EDI(Security."Default IC Partner G/L Acc. No" = 0);
        //   IF Security."Default IC Partner G/L Acc. No" IN [2,5] THEN BEGIN
        //     CurrForm."Default IC Partner G/L Acc. No".VISIBLE(FALSE);
        //     SETRANGE("Default IC Partner G/L Acc. No");
        //   END;
        //   IF CurrForm."Name 2".EDI THEN
        //     CurrForm."Name 2".EDI(Security."Name 2" = 0);
        //   IF Security."Name 2" IN [2,5] THEN BEGIN
        //     CurrForm."Name 2".VISIBLE(FALSE);
        //     SETRANGE("Name 2");
        //   END;
        //   //ALLEDK 040313

    END;
}