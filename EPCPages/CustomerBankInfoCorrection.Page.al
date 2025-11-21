page 97943 "Customer Bank Info Correction"
{
    Caption = 'Customer Bank Information';
    DeleteAllowed = false;
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(BondNo; BondNo)
                {
                    Caption = 'BondNo';

                    trigger OnValidate()
                    var
                        Customer: Record Customer;
                        CustomerBankAccount: Record "Customer Bank Account";
                    begin
                        Bond.GET(BondNo);
                        CustomerNo := Bond."Customer No.";
                        CustomerName := '';
                        Customer.GET(CustomerNo);
                        CustomerName := Customer.Name;
                        CustomerCode := Bond."Return Bank Account Code";

                        CustomerBankAccount.GET(CustomerNo, CustomerCode);
                        BankName := CustomerBankAccount.Name;
                        IFSCCode := CustomerBankAccount."SWIFT Code";
                        BankBranchNo := CustomerBankAccount."Bank Branch No.";
                        Name2 := CustomerBankAccount."Name 2";
                        BankAccountNo := CustomerBankAccount."Bank Account No.";
                    end;
                }
                field(CustomerNo; CustomerNo)
                {
                    Caption = 'Customer No';
                    Editable = false;
                }
                field(CustomerName; CustomerName)
                {
                    Caption = 'Customer Name';
                    Editable = false;
                    Enabled = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("GetDescription.GetNoOfBankAc(CustomerNo)";
                GetDescription.GetNoOfBankAc(CustomerNo))
                {
                    Caption = 'No of Records';
                    Enabled = false;

                    trigger OnDrillDown()
                    var
                        CustomerBankAccount: Record "Customer Bank Account";
                    //CustomerBankInformation: Page 82;
                    begin
                        CustomerBankAccount.SETRANGE("Customer No.", CustomerNo);
                        //CustomerBankInformation.Settableview(CustomerBankAccount);
                        //CustomerBankInformation.Run;
                        PAGE.RUNMODAL(Page::"Customer Bank Account List", CustomerBankAccount)
                    end;
                }
                group("Bank Information")
                {
                    Caption = 'Bank Information';
                    field(CustomerCode; CustomerCode)
                    {
                        Caption = 'Code';
                        Editable = false;
                    }
                    field(BankName; BankName)
                    {
                        Caption = 'Name';
                        Style = Strong;
                        StyleExpr = TRUE;
                    }
                    field(IFSCCode; IFSCCode)
                    {
                        Caption = 'IFSC Code';
                    }
                    field(BankBranchNo; BankBranchNo)
                    {
                        Caption = 'Bank Branch No.';
                    }
                    field(Name2; Name2)
                    {
                        Caption = 'Branch Name';
                    }
                    field(BankAccountNo; BankAccountNo)
                    {
                        Caption = 'Bank Account No.';
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Confirm)
            {
                Caption = 'Update';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    CustomerBankAccount: Record "Customer Bank Account";
                    ReleaseBondApplication: Codeunit "Release Unit Application";
                begin
                    IF NOT CONFIRM('Do you want to save the record') THEN
                        EXIT;

                    ReleaseBondApplication.InsertBondHistory(BondNo, 'Neft Bank Detail Changed', 1, BondNo);
                    CustomerBankAccount.GET(CustomerNo, CustomerCode);
                    CustomerBankAccount.Name := BankName;
                    CustomerBankAccount."SWIFT Code" := IFSCCode;
                    CustomerBankAccount."Bank Branch No." := BankBranchNo;
                    CustomerBankAccount."Name 2" := Name2;
                    CustomerBankAccount."Bank Account No." := BankAccountNo;
                    CustomerBankAccount."Entry Completed" := TRUE;
                    CustomerBankAccount.MODIFY;
                    CustomerBankAccount.Checking;
                    COMMIT;
                    MESSAGE('Done');

                    CustomerName := '';
                    CustomerNo := '';
                    CustomerCode := '';
                    BankName := '';
                    IFSCCode := '';
                    BankBranchNo := '';
                    Name2 := '';
                    BankAccountNo := '';
                    BondNo := '';
                end;
            }
            action(Detail)
            {
                Caption = 'Detail';
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                var
                    CustomerBankAccount: Record "Customer Bank Account";
                //CustomerBankInformation: Page 82;
                begin
                    CustomerBankAccount.SETRANGE("Customer No.", CustomerNo);
                    //CustomerBankInformation.Settableview(CustomerBankAccount);
                    //CustomerBankInformation.Run;
                    PAGE.RUNMODAL(Page::"Customer Bank Account List", CustomerBankAccount)
                end;
            }
            action(OK)
            {
                Caption = 'OK';
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        UserSetup.GET(USERID);
        IF NOT UserSetup.NEFT THEN
            ERROR('Not Authorised to view this page');
    end;

    var
        Txt001: Label 'Bond No. - %1 is not found in Bond Entry Table.';
        Txt002: Label 'Please select Bond with Return Payment mode NEFT.';
        CustomerName: Text[50];
        Txt003: Label 'Do you want to confirm the record?';
        Txt004: Label 'Please select Bond with Return Payment mode NEFT.';
        Txt005: Label 'Duplicate Entry';
        Txt006: Label 'No Records Found';
        UserSetup: Record "User Setup";
        GetDescription: Codeunit GetDescription;
        Txt007: Label 'Confirm the NEFT details.';
        CustomerNo: Code[20];
        CustomerCode: Code[20];
        IFSCCode: Code[20];
        BankBranchNo: Text[20];
        Name2: Text[50];
        BankAccountNo: Text[30];
        BankName: Text[50];
        Bond: Record "Confirmed Order";
        BondNo: Code[20];


    procedure SetBondNo(BondNo: Code[20]; BondHoderNo: Code[20])
    var
        Bond: Record "Confirmed Order";
    begin
    end;


    procedure GetBankCode(var BanlCode: Code[20])
    begin
    end;


    procedure ConfirmNeft()
    var
        CustomerBankAccount: Record "Customer Bank Account";
        Customer: Record Customer;
        Application: Record Application;
    begin
        /*IF CONFIRM(Txt007) THEN
          IF NOT "Entry Completed" THEN BEGIN
            TESTFIELD(Code);
            TESTFIELD(Name);      //Bank Name
            TESTFIELD("SWIFT Code");
            TESTFIELD("Bank Branch No.");
            TESTFIELD("Name 2");  //Branch Name
            TESTFIELD("Bank Account No.");
            "Entry Completed" := TRUE;
            MODIFY;
          END;
        */

    end;
}

