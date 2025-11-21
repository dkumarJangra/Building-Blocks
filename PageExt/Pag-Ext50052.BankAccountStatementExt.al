pageextension 50052 "BBG Bank Account Statement Ext" extends "Bank Account Statement"
{
    DeleteAllowed = false;
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("&Card")
        {
            action(Update)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    BankAccStatmntLine: Record "Bank Account Statement Line";
                    AppPayEntry: Record "Application Payment Entry";
                    PostPayment: Codeunit PostPayment;
                begin
                    BankAccStatmntLine.RESET;
                    BankAccStatmntLine.SETRANGE("Bank Account No.", Rec."Bank Account No.");
                    BankAccStatmntLine.SETRANGE("Statement No.", Rec."Statement No.");
                    IF BankAccStatmntLine.FINDSET THEN
                        REPEAT
                            BankAccStatmntLine.CALCFIELDS("Application No.");
                            AppPayEntry.RESET;
                            AppPayEntry.SETRANGE("Document No.", BankAccStatmntLine."Application No.");
                            AppPayEntry.SETRANGE("Cheque Status", AppPayEntry."Cheque Status"::" ");
                            AppPayEntry.SETRANGE("Cheque No./ Transaction No.", BankAccStatmntLine."Check No.");
                            IF AppPayEntry.FINDFIRST THEN
                                PostPayment.ChequeClearance(AppPayEntry, BankAccStatmntLine."Value Date");
                        UNTIL BankAccStatmntLine.NEXT = 0;
                end;
            }

        }
    }

    var
        myInt: Integer;
}