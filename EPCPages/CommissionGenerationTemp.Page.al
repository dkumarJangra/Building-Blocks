page 50007 "Commission Generation Temp"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            field(ComDate; ComDate)
            {
                Caption = 'Commission Cutoff Date';
                MultiLine = true;
            }
            field(IntroducerCode; IntroducerCode)
            {
                Caption = 'Associate Code';
                TableRelation = Vendor WHERE("BBG Vendor Category" = FILTER("IBA(Associates)"),
                                              "BBG Status" = FILTER(Active | Provisional));
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Commission Generation")
            {
                Caption = 'Commission Generation';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CommEligibilityTemp.DELETEALL;


                    IF ComDate = 0D THEN
                        ERROR('Please define Commission Date');
                    // ALLE MM Code Commented as Member of table has been removed in NAV 2016
                    /*
                    MemberOf.RESET;
                    MemberOf.SETRANGE(MemberOf."User ID",USERID);
                    MemberOf.SETRANGE(MemberOf."Role ID",'A_COMMISSIONGENRATE');
                    IF MemberOf.FINDFIRST THEN BEGIN
                    */
                    // ALLE MM Code Commented as Member of table has been removed in NAV 2016
                    CLEAR(CommisionGen);
                    CommisionGen.CreateBondandCommissionTemp(ComDate, IntroducerCode);
                    MESSAGE('Commission Generated Successfully');
                    //END;// ALLE MM Code Commented as Member of table has been removed in NAV 2016
                    // ELSE
                    // ERROR('You do not have permission of role :A_COMMISSIONGENRATE');

                end;
            }
        }
    }

    var
        CommisionGen: Codeunit "Unit and Comm. Creation Job";
        ComDate: Date;
        IntroducerCode: Code[20];
        CommEligibilityTemp: Record "Commission Eligibility Temp";
}

