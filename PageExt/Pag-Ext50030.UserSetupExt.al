pageextension 50030 "BBG User Setup Ext" extends "User Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Time Sheet Admin.")
        {
            field("Approver ID"; Rec."Approver ID")
            {
                ApplicationArea = All;
            }
            field("Sales Amount Approval Limit"; Rec."Sales Amount Approval Limit")
            {
                ApplicationArea = All;
            }
            field("Purchase Amount Approval Limit"; Rec."Purchase Amount Approval Limit")
            {
                ApplicationArea = All;
            }
            field("Unlimited Sales Approval"; Rec."Unlimited Sales Approval")
            {
                ApplicationArea = All;
            }
            field("Unlimited Purchase Approval"; Rec."Unlimited Purchase Approval")
            {
                ApplicationArea = All;
            }
            field(Substitute; Rec.Substitute)
            {
                ApplicationArea = All;
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = All;
            }
            field("Request Amount Approval Limit"; Rec."Request Amount Approval Limit")
            {
                ApplicationArea = All;
            }
            field("Unlimited Request Approval"; Rec."Unlimited Request Approval")
            {
                ApplicationArea = All;
            }
            field("Approval Administrator"; Rec."Approval Administrator")
            {
                ApplicationArea = All;
            }
            field("Allow FA Posting From"; Rec."Allow FA Posting From")
            {
                ApplicationArea = All;
            }
            field("Allow FA Posting To"; Rec."Allow FA Posting To")
            {
                ApplicationArea = All;
            }
            field("Allow Receipt on LLP Project"; Rec."Allow Receipt on LLP Project")
            {
                ApplicationArea = All;
            }
            field("Application Closed"; Rec."Application Closed")
            {
                ApplicationArea = All;
            }
            field("Responsibility Center"; Rec."Responsibility Center")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
            {
                ApplicationArea = All;
            }
            field(Multilogin; Rec.Multilogin)
            {
                ApplicationArea = All;
            }
            field(NEFT; Rec.NEFT)
            {
                ApplicationArea = All;
            }
            field("Stop Back Date"; Rec."Stop Back Date")
            {
                ApplicationArea = All;
            }
            field("Back Date Margin Days"; Rec."Back Date Margin Days")
            {
                ApplicationArea = All;
            }
            field("MM Chain Management"; Rec."MM Chain Management")
            {
                ApplicationArea = All;
            }
            field("Certificate Print"; Rec."Certificate Print")
            {
                ApplicationArea = All;
            }
            field("Dupl.Cert Print"; Rec."Dupl.Cert Print")
            {
                ApplicationArea = All;
            }
            field("Rep. Cert Print"; Rec."Rep. Cert Print")
            {
                ApplicationArea = All;
            }
            field("Assn. cert print"; Rec."Assn. cert print")
            {
                ApplicationArea = All;
            }
            field("ReAssn. cert print"; Rec."ReAssn. cert print")
            {
                ApplicationArea = All;
            }
            field("TDS Report"; Rec."TDS Report")
            {
                ApplicationArea = All;
            }
            field("NEFT Modification Permission"; Rec."NEFT Modification Permission")
            {
                ApplicationArea = All;
            }
            field("MM Joining"; Rec."MM Joining")
            {
                ApplicationArea = All;
            }
            field(Reverse; Rec.Reverse)
            {
                ApplicationArea = All;
            }
            field("MM Payable Management"; Rec."MM Payable Management")
            {
                ApplicationArea = All;
            }
            field("Voucher Reprint"; Rec."Voucher Reprint")
            {
                ApplicationArea = All;
            }
            field(Branch; Rec.Branch)
            {
                ApplicationArea = All;
            }
            field("Flash LC/BG Message"; Rec."Flash LC/BG Message")
            {
                ApplicationArea = All;
            }
            field("User Branch"; Rec."User Branch")
            {
                ApplicationArea = All;
            }
            field("Application Template BatchName"; Rec."Application Template BatchName")
            {
                ApplicationArea = All;
            }
            field("Commission Report Cuttoff Date"; Rec."Commission Report Cuttoff Date")
            {
                ApplicationArea = All;
            }
            field("LD Amount Post"; Rec."LD Amount Post")
            {
                ApplicationArea = All;
            }
            field("Project Approve"; Rec."Project Approve")
            {
                ApplicationArea = All;
            }
            field("Project Creation"; Rec."Project Creation")
            {
                ApplicationArea = All;
            }
            field("Project Re-Open"; Rec."Project Re-Open")
            {
                ApplicationArea = All;
            }
            field("Unit Creation"; Rec."Unit Creation")
            {
                ApplicationArea = All;
            }
            field("Unit Approval"; Rec."Unit Approval")
            {
                ApplicationArea = All;
            }
            field("Unit Re-Open"; Rec."Unit Re-Open")
            {
                ApplicationArea = All;
            }
            field("Associate Creation"; Rec."Associate Creation")
            {
                ApplicationArea = All;
            }
            field("Associate Approval"; Rec."Associate Approval")
            {
                ApplicationArea = All;
            }
            field("Associate Re-Open"; Rec."Associate Re-Open")
            {
                ApplicationArea = All;
            }
            field("Associate Rank Change"; Rec."Associate Rank Change")
            {
                ApplicationArea = All;
            }
            field("Setups Approval"; Rec."Setups Approval")
            {
                ApplicationArea = All;
            }
            field("Setups Creation"; Rec."Setups Creation")
            {
                ApplicationArea = All;
            }
            field("Project Release"; Rec."Project Release")
            {
                ApplicationArea = All;
            }
            field("Refund Amount Modify"; Rec."Refund Amount Modify")
            {
                ApplicationArea = All;
            }
            field("MJV Post"; Rec."MJV Post")
            {
                ApplicationArea = All;
            }
            field("AJVM Post"; Rec."AJVM Post")
            {
                ApplicationArea = All;
            }
            field("Discount Post"; Rec."Discount Post")
            {
                ApplicationArea = All;
            }
            field("Refund Post"; Rec."Refund Post")
            {
                ApplicationArea = All;
            }
            field("After Refund Rcpt Post"; Rec."After Refund Rcpt Post")
            {
                ApplicationArea = All;
            }
            field("Allow for Trading Project"; Rec."Allow for Trading Project")
            {
                ApplicationArea = All;
            }
            field("Allow for Non Trading Project"; Rec."Allow for Non Trading Project")
            {
                ApplicationArea = All;
            }
            field("Non IBA Vendor Creation"; Rec."Non IBA Vendor Creation")
            {
                ApplicationArea = All;
            }
            field("Branch Specific"; Rec."Branch Specific")
            {
                ApplicationArea = All;
            }
            field("Default Branch Code"; Rec."Default Branch Code")
            {
                ApplicationArea = All;
            }
            field("Mail Printer Name"; Rec."Mail Printer Name")
            {
                ApplicationArea = All;
            }
            field("Permission Group Code"; Rec."Permission Group Code")
            {
                ApplicationArea = All;
            }
            field("Thumb Impression SMS"; Rec."Thumb Impression SMS")
            {
                ApplicationArea = All;
            }
            field("Registration to SRO SMS"; Rec."Registration to SRO SMS")
            {
                ApplicationArea = All;
            }
            field("Doc Issue from TR DESK SMS"; Rec."Doc Issue from TR DESK SMS")
            {
                ApplicationArea = All;
            }
            field("Sweet Box Issuefrom TRDESk SMS"; Rec."Sweet Box Issuefrom TRDESk SMS")
            {
                ApplicationArea = All;
            }
            field("Allow Re-Send SMS"; Rec."Allow Re-Send SMS")
            {
                ApplicationArea = All;
            }
            field("Report ID - 50041 - Run"; Rec."Report ID - 50041 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 50011 - Run"; Rec."Report ID - 50011 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 97855 - Run"; Rec."Report ID - 97855 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 97782 - Run"; Rec."Report ID - 97782 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 97893 - Run"; Rec."Report ID - 97893 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 97896 - Run"; Rec."Report ID - 97896 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 50082 - Run"; Rec."Report ID - 50082 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 50096 - Run"; Rec."Report ID - 50096 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 50011 - Excel"; Rec."Report ID - 50011 - Excel")
            {
                ApplicationArea = All;
            }
            field("Report ID - 97782 - Excel"; Rec."Report ID - 97782 - Excel")
            {
                ApplicationArea = All;
            }
            field("Report ID - 50081 - Run"; Rec."Report ID - 50081 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 50098 - Run"; Rec."Report ID - 50098 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 50049 - Run"; Rec."Report ID - 50049 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 50015 - Run"; Rec."Report ID - 50015 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 97846 - Run"; Rec."Report ID - 97846 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 50017 - Run"; Rec."Report ID - 50017 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 97916 - Run"; Rec."Report ID - 97916 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 97804 - Run"; Rec."Report ID - 97804 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 50038 - Run"; Rec."Report ID - 50038 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 50064 - Run"; Rec."Report ID - 50064 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 50057 - Run"; Rec."Report ID - 50057 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 97825 - Run"; Rec."Report ID - 97825 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 97877 - Run"; Rec."Report ID - 97877 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 16567 - Run"; Rec."Report ID - 16567 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 50037 - Run"; Rec."Report ID - 50037 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 97832 - Run"; Rec."Report ID - 97832 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 97838 - Run"; Rec."Report ID - 97838 - Run")
            {
                ApplicationArea = All;
            }
            field("Report ID - 50081 - Excel"; Rec."Report ID - 50081 - Excel")
            {
                ApplicationArea = All;
            }
            field("Report ID - 50049 - Excel"; Rec."Report ID - 50049 - Excel")
            {
                ApplicationArea = All;
            }
            field("Report ID - 97916 - Excel"; Rec."Report ID - 97916 - Excel")
            {
                ApplicationArea = All;
            }
            field("Report ID - 97877 - Excel"; Rec."Report ID - 97877 - Excel")
            {
                ApplicationArea = All;
            }
            field("Vendor Delete Permission"; Rec."Vendor Delete Permission")
            {
                ApplicationArea = All;
            }
            field("Reserve Ass. Payment"; Rec."Reserve Ass. Payment")
            {
                ApplicationArea = All;
            }
            field("Create Associate Manual"; Rec."Create Associate Manual")
            {
                ApplicationArea = All;
            }
            field("Change Unit Company Name"; Rec."Change Unit Company Name")
            {
                ApplicationArea = All;
            }
            field("Allow Mobile App"; Rec."Allow Mobile App")
            {
                ApplicationArea = All;
            }
            field("Allow Associate Payment"; Rec."Allow Associate Payment")
            {
                ApplicationArea = All;
            }
            field("Allow Unit/Project"; Rec."Allow Unit/Project")
            {
                ApplicationArea = All;
            }
            field("Allow User Setup Modify"; Rec."Allow User Setup Modify")
            {
                ApplicationArea = All;
            }
            field("Mobile Payment Status modify"; Rec."Mobile Payment Status modify")
            {
                ApplicationArea = All;
            }
            field("Associate Payment Approval"; Rec."Associate Payment Approval")
            {
                ApplicationArea = All;
            }
            field("Bank Payment Voucher Verify"; Rec."Bank Payment Voucher Verify")
            {
                ApplicationArea = All;
            }
            field("Bank Receipt Voucher Verify"; Rec."Bank Receipt Voucher Verify")
            {
                ApplicationArea = All;
            }
            field("Cash Receipt Voucher Verify"; Rec."Cash Receipt Voucher Verify")
            {
                ApplicationArea = All;
            }
            field("Cash Payment Voucher Verify"; Rec."Cash Payment Voucher Verify")
            {
                ApplicationArea = All;
            }
            field("General Journal Voucher Verify"; Rec."General Journal Voucher Verify")
            {
                ApplicationArea = All;
            }
            field("Journal Voucher Verify"; Rec."Journal Voucher Verify")
            {
                ApplicationArea = All;
            }
            field("Contra Voucher Verify"; Rec."Contra Voucher Verify")
            {
                ApplicationArea = All;
            }
            field("Aplication Option Setup Create"; Rec."Aplication Option Setup Create")
            {
                Caption = 'Application Option Setup Create';
                ApplicationArea = All;
            }
            field("UTR No. Upload"; Rec."UTR No. Upload")
            {
                ApplicationArea = All;
            }
            field("Registration Status Modify"; Rec."Registration Status Modify")
            {
                ApplicationArea = All;
            }
            field("Import Document"; Rec."Import Document")
            {
                ApplicationArea = All;
            }
            field("Plot Reg. Stage 1 and 7"; Rec."Plot Reg. Stage 1 and 7")
            {
                ApplicationArea = All;
            }
            field("Plot Reg. Stage 3"; Rec."Plot Reg. Stage 3")
            {
                ApplicationArea = All;
            }
            field("Plot Reg. Stage 2"; Rec."Plot Reg. Stage 2")
            {
                ApplicationArea = All;
            }
            field("Plot Reg. Stage 4_5_6_ 8"; Rec."Plot Reg. Stage 4_5_6_ 8")
            {
                ApplicationArea = All;
            }
            field("Allow Gold/Silver Restriction"; Rec."Allow Gold/Silver Restriction")
            {
                ApplicationArea = All;
            }
            field("Refund SMS Submission"; Rec."Refund SMS Submission")
            {
                ApplicationArea = All;
            }
            field("Refund SMS Initiation"; Rec."Refund SMS Initiation")
            {
                ApplicationArea = All;
            }
            field("Refund SMS Verification"; Rec."Refund SMS Verification")
            {
                ApplicationArea = All;
            }
            field("Refund SMS Approval"; Rec."Refund SMS Approval")
            {
                ApplicationArea = All;
            }
            field("Refund SMS Completed"; Rec."Refund SMS Completed")
            {
                ApplicationArea = All;
            }
            field("Refund Reject Submission"; Rec."Refund Reject Submission")
            {
                ApplicationArea = All;
            }
            field("Refund Reject Initiation"; Rec."Refund Reject Initiation")
            {
                ApplicationArea = All;
            }
            field("Refund Reject Verification"; Rec."Refund Reject Verification")
            {
                ApplicationArea = All;
            }
            field("Refund Reject Approval"; Rec."Refund Reject Approval")
            {
                ApplicationArea = All;
            }
            field("Refund Reject Payment"; Rec."Refund Reject Payment")
            {
                ApplicationArea = All;
            }
            field("Direct Refund"; Rec."Direct Refund")
            {
                ApplicationArea = All;
            }
            field("Show Deactivate Associates"; Rec."Show Deactivate Associates")
            {
                ApplicationArea = All;
            }
            field("Update Customer Coupon"; Rec."Update Customer Coupon")
            {
                ApplicationArea = All;
            }
            field("Display Name in Jagriti"; Rec."Display Name in Jagriti")
            {
                ApplicationArea = All;
            }
            field("Allow Back Date Posting"; Rec."Allow Back Date Posting")
            {
                ApplicationArea = All;
            }
            field("Gamification Start Date"; Rec."Gamification Start Date")
            {
                ApplicationArea = All;
            }
            field("Gamification End Date"; Rec."Gamification End Date")
            {
                ApplicationArea = All;
            }
            field("New Comm Str on Job Allow"; Rec."New Comm Str on Job Allow")
            {
                ApplicationArea = All;
            }
            field("View of Chart of Account"; Rec."View of Chart of Account")
            {
                ApplicationArea = All;
            }
            field("View of BALedger Entry"; Rec."View of BALedger Entry")
            {
                ApplicationArea = All;
            }
            field("View All Vendor ledger Entries"; Rec."View All Vendor ledger Entries")
            {
                ApplicationArea = All;
            }
            field("Target Functionality"; Rec."Target Functionality")
            {
                ApplicationArea = All;
            }
            field("Allow PI SI Unit Price on CO"; Rec."Allow PI SI Unit Price on CO")
            {
                ApplicationArea = All;
            }
            field("BSP4 Update on Project Mster"; Rec."BSP4 Update on Project Mster")
            {
                ApplicationArea = All;
            }
            field("Spl. Inct. Bonanza Approver ID"; Rec."Spl. Inct. Bonanza Approver ID")
            {
                Caption = 'Special Incentive Bonanza Approver ID';
                ApplicationArea = All;
            }
            field("Allow Users Modify"; Rec."Allow Users Modify")
            {
                ApplicationArea = all;
            }
            field("Modify Posted Narration "; Rec."Modify Posted Narration")  //060325 Added new field
            {
                ApplicationArea = all;
            }
            field("Modify Comm/Refund Schedule"; Rec."Modify Comm/Refund Schedule")    //110525  added new field
            {
                Caption = 'Modify Commission/Refund Payment Schedule';
                ApplicationArea = all;
            }
            field("Asso/Cust. Notification Upload"; Rec."Asso/Cust. Notification Upload")    //110525  added new field
            {
                Caption = 'Associate/Customer Notification Upload';
                ApplicationArea = all;
            }
            field("Allow Region Code Change"; Rec."Allow Region Code Change")  //Code added 06102025
            {
                ApplicationArea = all;
            }


        }
    }

    actions
    {
        // Add changes to page actions here
        addfirst(Processing)
        {
            group("BBG")
            {
                action("Update User Setup Date")
                {
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report "User Setup Date Change";
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        myInt: Integer;
}