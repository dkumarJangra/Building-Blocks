page 80000 "BBG Profile"
{
    Caption = 'BBG Profile';
    PageType = RoleCenter;
    ApplicationArea = All;

    layout
    {
        area(rolecenter)
        {
            part("Company Information Card Part"; "Company Information Card Part")
            {
                ApplicationArea = all;
            }
            part(Control104; "Headline RC Order Processor")
            {
                ApplicationArea = Basic, Suite;
                // Visible = false;
            }
            // part(Control1901851508; "Purchase Agent Activities")
            // {
            //     AccessByPermission = TableData "Sales Shipment Header" = R;
            //     ApplicationArea = Basic, Suite;
            // }
            part(Control1901851508; "SO Processor Activities")
            {
                AccessByPermission = TableData "Sales Shipment Header" = R;
                ApplicationArea = Basic, Suite;
            }

            // part(VendorCue; VendorStatusCue)
            // {
            //     ApplicationArea = Basic, Suite;
            // }
            part("Emails"; "Email Activities")
            {
                ApplicationArea = Basic, Suite;
                // Visible = false;
            }

            part("User Tasks Activities"; "User Tasks Activities")
            {
                ApplicationArea = Suite;
                Visible = false;
            }

            part(ApprovalsActivities; "Approvals Activities")
            {
                ApplicationArea = Suite;
            }
            part(Control14; "Team Member Activities")
            {
                ApplicationArea = Suite;
                Visible = false;
            }
            part(Control1907692008; "My Customers")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control1; "Trailing Sales Orders Chart")
            {
                AccessByPermission = TableData "Sales Shipment Header" = R;
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            part(Control4; "My Job Queue")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            part(Control1905989608; "My Items")
            {
                AccessByPermission = TableData "My Item" = R;
                ApplicationArea = Basic, Suite;
            }
#if not CLEAN21
            //  part(Control13; "Power BI Report Spinner Part")   //Comment 11082025
            // {
            //     ApplicationArea = Basic, Suite;
            //     ObsoleteState = Pending;
            //     ObsoleteReason = 'Replaced by PowerBIEmbeddedReportPart';
            //     Visible = false;
            //     ObsoleteTag = '21.0';
            // }
#endif
            part(PowerBIEmbeddedReportPart; "Power BI Embedded Report Part")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control21; "Report Inbox Part")
            {
                AccessByPermission = TableData "Report Inbox" = R;
                ApplicationArea = Suite;
            }
            systempart(Control1901377608; MyNotes)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        area(embedding)
        {
            ToolTip = 'Manage sales processes, view KPIs, and access your favorite items and customers.';

            action(Centres)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Pending Project List';
                Image = Item;
                RunObject = Page 50416;
                //RunPageLink = "Parent Job" = const(true);
            }
            //  action(AllJob)
            //  {
            //      ApplicationArea = Basic, Suite;
            //      Caption = 'All Jobs';
            //      Image = Customer;
            //      RunObject = Page "Job List";
            //  }

            //  action(ProjectOverview)
            //  {
            //      ApplicationArea = Basic, Suite;
            //      Caption = 'Project Overview';
            //      RunObject = Page "Projects Overview";
            //  }
            //  action("SW Centre Detail1")
            //  {
            //      ApplicationArea = Basic, Suite;
            //      Caption = 'SW Centre Detail';
            //      RunObject = Page "SW Centre Detail";
            //      RunPageLink = Centre = const(true);
            //      ToolTip = 'Executes the SW Centre Detail List action.';
            //  }
            //  action("SW Centre/Client Detail")
            //  {
            //      ApplicationArea = Basic, Suite;
            //      Caption = 'SW Client Detail';
            //      RunObject = Page "SW Centre/Client Detail";
            //      RunPageLink = Centre = const(false);
            //      ToolTip = 'Executes the SW Centre/Client Detail List action.';
            //  }

        }

        area(sections)
        {

            group("Real Estate")
            {
                Caption = 'Real Estate';
                Image = Sales;
                group(RealEstateActivities)
                {
                    Caption = 'Activities';
                    group(ActivitiesLists)
                    {
                        Caption = 'Lists';
                        action("Application List (POC)")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Application List (POC)';
                            Image = ApplicationWorksheet;
                            RunObject = Page "Application List (POC)";
                        }

                        action("Confirm Order List (POC)")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Confirm Order List (POC)';
                            Image = OrderList;
                            RunObject = Page "Confirm Order List (POC)";
                            //ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                        }
                        action("Confirmed Order List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Confirmed Order List';
                            Image = OrderList;
                            RunObject = Page "Unit List";
                            //ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                        }


                    }
                    group(ActivitiesOperations)
                    {
                        Caption = 'Operations';
                        action("Member to Member list")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Member to Member list';
                            RunObject = Page "Member to Member list";
                        }
                        action("Associate_ Member Trans. List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Associate_ Member Trans. List';
                            RunObject = Page "Associate_ Member Trans. List";
                        }
                        action("MJV/AJVM Pending Entries")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'MJV/AJVM Pending Entries';
                            RunObject = Page "MJV/AJVM Pending Entries";
                        }
                        action("Unit Allocation List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Unit Allocation List';
                            RunObject = Page "Unit Allocation List";
                        }
                        action("Customer Allocation List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Customer Allocation List';
                            RunObject = Page "Customer Allocation List";
                        }
                        action("Application Discount List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Application Discount List';
                            RunObject = Page "Application Discount List";
                        }
                        action("Plot Calcellation List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Plot Calcellation List';
                            RunObject = Page "Plot Calcellation List";
                        }
                        action("Unit Vacate /Member Change List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Unit Vacate /Member Change List';
                            RunObject = Page "Unit Vacate /MemberChange List";
                        }
                        action("Refund/Neg. Adj. List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Refund/Neg. Adj. List';
                            RunObject = Page "Refund/Neg. Adj. List";
                        }

                    }
                    group(ActivitiesProject)
                    {
                        Caption = 'Project';
                        action("Job List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Job List';
                            RunObject = Page "Job List";
                        }
                        action("Project List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Project List';
                            RunObject = Page "Project List";
                        }
                        action("Location List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Location List';
                            RunObject = Page "Location List";
                        }
                        action("Project wise Milestone Details")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Project wise Milestone Details';
                            RunObject = Page "Project wise Milestone Details";
                        }
                        action("Charge type Update")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Charge type Update';
                            RunObject = Page "Charge type Update";
                        }
                        action("Charge Type Archive")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Charge Type Archive';
                            RunObject = Page "Charge Type Archive";
                        }
                        action("Project Price Summary")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Project Price Summary';
                            RunObject = report "Project Price Summary";
                        }


                    }

                    group(ActivitiesCommission)
                    {
                        Caption = 'Commission';
                        action("Commission Code List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Commission Code List';
                            RunObject = Page "Project Type List";
                        }
                        action("Region/Rank  List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Region/Rank  List';
                            RunObject = Page "Region/Rank  List";
                        }
                        action("Rank Code List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Rank Code List';
                            RunObject = Page "Rank Code";
                        }
                        action("Rank List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Rank List';
                            RunObject = Page "Rank List";
                        }
                        action("Commission Structure")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Commission Structure';
                            RunObject = Page "Commission Structure";
                        }
                        action("Commission Entry View Form")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Commission Entry View Form';
                            RunObject = Page "Commission Entry View Form";
                        }


                    }
                    group(ActivitiesTravel)
                    {
                        Caption = 'Travel';
                        action("Travel Setup List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Travel Setup List';
                            RunObject = Page "Travel Setup List";
                        }
                        action("Travel List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Travel List';
                            RunObject = Page "Travel List";
                        }
                        action("Travel List for Approval")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Travel List for Approval';
                            RunObject = Page "Travel List for Approval";
                        }
                        action("Travel Approved List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Travel Approved List';
                            RunObject = Page "Travel Approved List";
                        }
                        action("Travel Generation Approved")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Travel Generation Approved';
                            RunObject = Page "Travel Generation Approved";
                        }
                        action("Travel Generation")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Travel Generation';
                            RunObject = Page "Travel List";
                        }

                    }
                    group(ActivitiesIncentive)
                    {
                        Caption = 'Incentive';
                        action("Incentive List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Incentive List';
                            RunObject = page "Incentive List";
                        }
                        action("Incentive Detail Entry")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Incentive Detail Entry';
                            RunObject = Page "Incentive Detail Entry";
                        }
                        action("Incentive Summary")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Incentive Summary';
                            RunObject = Page "Incentive Summary";
                        }
                        action("Team Incentive Details")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Team Incentive Details';
                            RunObject = Page "Team Incentive Details";
                        }
                        action("Posted Payable Form")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Posted Payable Form';
                            RunObject = Page "Posted Payable Form";
                        }
                        action("Posted Voucher List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Posted Voucher List';
                            RunObject = Page "Posted Voucher List";
                        }
                        action("Associate Payment Form Incentive")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Associate Payment Form Incentive';
                            RunObject = Page "Associate Payment Form Incenti";
                        }
                    }
                    group(ActivitiesGiftCustomer)
                    {
                        Caption = 'Gift-Customer';
                        action("Gold Coin Setup List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Gold Coin Setup List';
                            RunObject = page "Gold Coin SetupList";
                        }
                        action("Gold Coin Eligibility")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Gold Coin Eligibility';
                            RunObject = Page "Gold Coin Eligibility";
                        }
                        action("Gold Coin Eligibility for Approval")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Gold Coin Eligibility for Approval';
                            RunObject = Page "Gold Coin Eligibility App";
                        }
                        action("Silver Coin Eligibility")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Silver Coin Eligibility';
                            RunObject = Page "Silver Coin Eligibility";
                        }
                        action("Silver Coin Eligibility Approval")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Silver Coin Eligibility Approval';
                            RunObject = Page "Silver Coin Eligibility App";
                        }
                        action("Approved Gold Coin Eligibility")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Approved Gold Coin Eligibility';
                            RunObject = Page "Gold Coin Eligibility1";
                        }
                        action("Gold Issue List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Gold Issue List';
                            RunObject = Page "Regular Gold/Silver Issue List";
                        }
                        action("Gold Recovery List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Gold Recovery List';
                            RunObject = Page "Gold/Silver Recovery List";
                        }
                        action("Direct Gold/Silver Issue List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Direct Gold/Silver Issue List';
                            RunObject = Page "Direct Gold/Silver Issue List";
                        }
                        action("Regular Gold/Silver Issue List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Regular Gold/Silver Issue List';
                            RunObject = Page "Regular Gold/Silver Issue List";
                        }
                        action("Consumption Note to Associate")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Consumption Note to Associate';
                            RunObject = Page "Consumption Note to Associate";
                        }
                        action("Posted Consumption List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Posted Consumption List';
                            RunObject = Page "Posted Consumption List";
                        }
                        action("Posted Gold Coin List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Posted Gold Coin List';
                            RunObject = Page "Posted Gold Coin List";
                        }
                        action("Customer Gift Setup")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Customer Gift Setup';
                            RunObject = Page "Customer Gift Setup";
                        }
                        action("Project Wise Developmnt Charge Setup")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Project Wise Developmnt Charge Setup';
                            RunObject = Page "Project Wise Developmnt Charge";
                        }
                        action("Project Wise R2 Gold_Silver List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Project Wise R2 Gold_Silver List';
                            RunObject = Page "ProjectWise R2 Gold_SilverList";
                        }
                    }
                    group(ActivitiesUnit)
                    {
                        Caption = 'Unit';
                        action("Unit Master List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Unit Master List';
                            RunObject = page "Unit Master List";
                        }
                        action("Unit Life Cycle")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Unit Life Cycle';
                            RunObject = Page "Unit Life Cycle";
                        }
                        action("Unit Block/UnBlock")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Unit Block/UnBlock';
                            RunObject = Page "Unit Block/UnBlock";
                        }
                        action("Unit Card List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Unit Card List';
                            RunObject = Page "Unit Master List";
                        }
                        action("Unit Upload")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Unit Upload';
                            //RunObject = xmlport 97748;
                        }
                        action("Unit Approval")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Unit Approval';
                            RunObject = Page "Unit Approval Form";
                        }
                        action("Unit Master log Entries")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Unit Master log Entries';
                            RunObject = Page 60780;
                        }
                    }
                    group(ActivitiesPayment)
                    {
                        Caption = 'Payment';
                        action("Associate Payment Window")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Associate Payment Window';
                            RunObject = page "Associate Payment Form";
                        }
                        action("Pending Purchase Invoice")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Pending Purchase Invoice';
                            RunObject = Page "Pending Voucher Post";
                        }
                        action("Application Payment Entry List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Application Payment Entry List';
                            RunObject = Page "Application Payment Entry List";
                        }
                        action("Posted Associate Payment Form")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Posted Associate Payment Form';
                            RunObject = Page "Posted Associate Payment Form";
                        }
                        action("Associate Bank - Adv Payments")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Associate Bank - Adv Payments';
                            RunObject = page "Associate Adv Pay Incnt & Comm";
                        }
                        action("Direct Incentive Payment")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Direct Incentive Payment';
                            RunObject = Page "Direct Incentive Payment";
                        }
                        action("Associate Advance Payment")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Associate Advance Payment';
                            RunObject = Page "Associate Advance Payment";
                        }
                        action("Pending Associate Payment List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Pending Associate Payment List';
                            RunObject = Page "Pending Associate Payment List";
                        }
                        action("Posted Associate Paymt List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Posted Associate Paymt List';
                            RunObject = Page "Posted Associate Paymt List";
                        }
                        action("Pending Approval Direct Incentive")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Pending Approval Direct Incentive';
                            //RunObject = Page 60798;
                        }
                    }
                    group(ActivitiesBatch)
                    {
                        Caption = 'Batch';
                        action("Upload Associate Mobile Data")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Upload Associate Mobile Data';
                            //RunObject = xmlport 97750;
                        }
                        action("Upload block Associate for Team positive report")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Upload block Associate for Team positive report';
                            RunObject = xmlport "Upload block Ass Team positive";
                        }
                        action("SMS Log Details")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'SMS Log Details';
                            RunObject = Page "SMS Log Details";
                        }
                        action("Refund Change Log Details")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Refund Change Log Details';
                            RunObject = Page "Refund Change Log Details";
                        }
                        action("Pre-Deactivate Vendor List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Pre-Deactivate Vendor List';
                            RunObject = page "Pre-Deactivate Vendor List";
                        }
                        action("Yearly Pre-Deactivate VendList")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Yearly Pre-Deactivate VendList';
                            RunObject = Page "Yearly Pre-Deactivate VendList";
                        }
                        action("BBG App wise Commission Base amt")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'App wise Commission Base amt';
                            RunObject = xmlport "App wise Commission Base amt";
                        }

                    }
                    group(ActivitiesCorrection)
                    {
                        Caption = 'Correction';
                        action("Posted Narrations")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Posted Narrations';
                            RunObject = page "Posted Narration";
                        }
                        action("Cust. Refund Cheque Correction")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Cust. Refund Cheque Correction';
                            RunObject = Page "Cust. Refund Cheque Correction";
                        }
                        action("Correction Unit Block/UnBlock")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Unit Block/UnBlock';
                            RunObject = Page "Unit Block/UnBlock";
                        }
                        action("Gold Coin Date Correction")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Gold Coin Date Correction';
                            RunObject = Page "Gold Coin Date Correction";
                        }
                        action("Posting Date Correction")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Posting Date Correction';
                            RunObject = page "Posting Date Correction";
                        }
                        action("Customer Correction")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Customer Correction';
                            RunObject = Page "Customer Correction";
                        }
                        action("Associate Correction")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Associate Correction';
                            RunObject = Page "Associate Correction";
                        }
                        action("Associate Adjust Form")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Associate Adjust Form';
                            RunObject = Page "Associate Adjust Form";
                        }
                        action("Associate Bank Correction")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Associate Bank Correction';
                            RunObject = Page "Associate Bank Correction";
                        }
                        action("Ass. Cheque Correction")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Ass. Cheque Correction';
                            RunObject = Page "Ass. Cheque Correction";
                        }
                        action("Bank Account No. Correction")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Bank Account No. Correction';
                            RunObject = Page "Bank Account No. Correction";
                        }
                        action("Customer Cheque Correction")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Customer Cheque Correction';
                            RunObject = Page "Cheque Correction Posted Doc";
                        }
                        action("Refund Bank Acc. No.Correction")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Refund Bank Acc. No.Correction';
                            RunObject = Page "Refund Bank Acc. No.Correction";
                        }
                        action("Application Cheque Status")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Application Cheque Status';
                            RunObject = Page "Application Cheque Status";
                        }
                    }
                    group(ActivitiesTableView)
                    {
                        Caption = 'Table View';
                        action("new application payment entry")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'new application payment entry';
                            RunObject = page "new application payment entry";
                        }
                        action("RB Release Form")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'RB Release Form';
                            RunObject = Page "RB Release Form";
                        }
                        action("TravelPayment Details")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'TravelPayment Details';
                            RunObject = Page "TravelPayment Details";
                        }
                        action("Travel Payment Entry View")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Travel Payment Entry View';
                            RunObject = Page "Travel Payment Entry View";
                        }
                        action("TableView Commission Entry View Form")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Commission Entry View Form';
                            RunObject = page "Commission Entry View Form";
                        }
                        action("New Confirmed Order List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'New Confirmed Order List';
                            RunObject = Page "New Confirmed Order List";
                        }
                        action("Reversal Entries")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Reversal Entries';
                            RunObject = Page "Reversal Entries";
                        }
                        action("Target Vs Achivements")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Target Vs Achivements';
                            RunObject = Page "Target Vs Achivements";
                        }
                        action("Deactivate Vendor List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Deactivate Vendor List';
                            RunObject = Page "Deactivate Vendor List";
                        }
                        action("Associate Hierarcy with App.")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Associate Hierarcy with App.';
                            RunObject = Page "Associate Hierarcy with App.";
                        }
                        action("Unit & commission Calculate")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Unit & commission Calculate';
                            RunObject = Page "Unit & commission Calculate";
                        }
                    }
                    group(ActivitiesFoodCourt)
                    {
                        Caption = 'Food Court';
                        action("Food Court Details")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Food Court Details';
                            RunObject = page "Food Court Details";
                        }
                        action("Coupon Name List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Coupon Name List';
                            RunObject = Page "Coupon Name List";
                        }
                        action("Coupon Type List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Coupon Type List';
                            RunObject = Page "Coupon Type List";
                        }
                        action("Food Type List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Food Type List';
                            RunObject = Page "Food Type List";
                        }
                        action("Food Team List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Food Team List';
                            RunObject = page "Food Team List";
                        }
                    }
                    group(ActivitiesPRLCPlotRegistration)
                    {
                        Caption = 'PRLC Plot Registration';
                        action("Plot Registration List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Plot Registration List';
                            RunObject = page "Plot Registration List";
                        }
                    }
                    group(ActivitiesEvent)
                    {
                        Caption = 'Event';
                        action("Event Details")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Event Details';
                            RunObject = page "Event Details";
                        }
                        action("Associate Event Details")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Associate Event Details';
                            RunObject = Page "Associate Event Details";
                        }
                    }
                    group(ActivitiesLoanEMI)
                    {
                        Caption = 'Loan EMI';
                        action("Loan EMI Master")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Loan EMI Master';
                            RunObject = page "Loan EMI Master";
                        }
                        action("Loan EMI Document List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Loan EMI Document List';
                            RunObject = Page "Loan EMI Document List";
                        }
                    }
                    group(ActivitiesRequestedApproved)
                    {
                        Caption = 'Requested Approved';
                        action("Approved Requests List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Approved Requests List';
                            RunObject = page "Approved Requests List";
                        }
                        action("Request to Approve Documents")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Request to Approve Documents';
                            RunObject = Page "Request to Approve Documents";
                        }
                        action("Approval Workflow Process")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Approval Workflow Process';
                            RunObject = Page "Approval Workflow Process Audt";
                        }
                    }
                    group(ActivitiesTargetDetail)
                    {
                        Caption = 'Target Detail';
                        action("Target Request Page")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Target Request Page';
                            //RunObject = page "Target Request Page";
                        }
                        action("Target submission Entry Detail")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Target submission Entry Detail';
                            //RunObject = Page "Target submission Entry Detail";
                        }
                        action("Associate Target Matrix")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Associate Target Matrix';
                            RunObject = Page "Associate Target Matrix";
                        }
                        action("Target Submitted from Associate")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Target Submitted from Associate';
                            //RunObject = Page "Target Submitted from Associate";
                        }
                        action("Registration Target Details")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Registration Target Details';
                            RunObject = Page "Registration Target Details";
                        }
                        action("Team Target Details")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Team Target Details';
                            RunObject = Page "Team Target Details";
                        }
                    }
                }
                group(RealEstateBankReco)
                {
                    Caption = 'Bank Reco';
                    action("Bank Acc. Reconciliation List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Bank Acc. Reconciliation List';
                        Image = BankAccount;
                        RunObject = Page "Bank Acc. Reconciliation List";

                    }
                    action("Export Bank Ledger Entry")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Export Bank Ledger Entry';
                        Image = Export;
                        //RunObject = xmlport 50022;

                    }
                    action("Import Bank Ledger Entry")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Import Bank Ledger Entry';
                        Image = Import;
                        //RunObject = xmlport 50023;

                    }
                    action("Bank Acc Statement Lines")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Bank Acc Statement Lines';
                        Image = BankAccount;
                        RunObject = Page "Bank Acc Statement Lines";

                    }
                    action("Non-Display Bank Account List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Non-Display Bank Account List';
                        Image = BankAccount;
                        RunObject = Page "Non-Display Bank Account List";

                    }

                }

                group(RealEstateMobileApplication)
                {
                    Caption = 'Mobile Application';
                    action("Reporting Office List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Reporting Office List';
                        Image = List;
                        RunObject = Page "Reporting Office List";
                    }
                    action("Customer Login Details")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer Login Details';
                        Image = Customer;
                        RunObject = Page "Customer Login Details";
                    }
                    action("New Cluster List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Cluster List';
                        Image = List;
                        RunObject = Page "New Cluster List";
                    }
                    action("Updation of plot details")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Updation of plot details';
                        Image = UpdateDescription;
                        //RunObject = Page 60800;
                    }
                    action("Land Vendor Login Dtld.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Land Vendor Login Dtld.';
                        Image = ValidateEmailLoggingSetup;
                        //RunObject = Page 60801;
                    }
                    action("New Land Requested Details")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Land Requested Details';
                        Image = ViewDetails;
                        //RunObject = Page 60802;
                    }
                    action("Land Vendor OTP details")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Land Vendor OTP details';
                        Image = Vendor;
                        //RunObject = Page 60803;
                    }
                    action("Land Vendor Helpdesk Details")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Land Vendor Helpdesk Details';
                        Image = Vendor;
                        //RunObject = Page 60804;
                    }
                    action("User wise Report Details")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'User wise Report Details';
                        Image = ViewDetails;
                        //RunObject = Page "User wise Report Details";
                    }
                }

                group(RealEstateCRM)
                {
                    Caption = 'CRM';

                    action("Lead List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Lead List';
                        Image = List;
                        RunObject = Page "Lead List";
                    }
                    action("Customer Allocate CRM List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer Allocate CRM List';
                        Image = List;
                        RunObject = Page "Customer Allocate CRM List";
                    }
                    action("Customer Lead Details List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer Lead Details List';
                        Image = List;
                        RunObject = Page "Customer Lead Details List";
                    }
                    action("OTP Details list")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'OTP Details list';
                        Image = List;
                        RunObject = Page "OTP Details list";
                    }
                    action("Associate Lead Menu List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Associate Lead Menu List';
                        Image = List;
                        RunObject = Page "Associate Lead Menu List";
                    }
                    action("Lead Induction List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Lead Induction List';
                        Image = List;
                        RunObject = Page "Lead Induction List";
                    }
                    action("Archive Lead Details Data")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Archive Lead Details Data';
                        Image = Archive;
                        RunObject = Page "Archive Lead Details Data";
                    }
                    action("Customer Campiagn")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer Campiagn';
                        Image = Customer;
                        RunObject = Page "Customer Campiagn";
                    }
                    action("Customer Booking Request Dtd.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer Booking Request Dtd.';
                        Image = Customer;
                        RunObject = Page "Customer Booking Request Dtd.";
                    }
                    action("Customer Helpdesk Details")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer Helpdesk Details';
                        Image = Customer;
                        RunObject = Page "Customer Helpdesk Details";
                    }
                    action("Customer Appl. calim details")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer Appl. calim details';
                        Image = Customer;
                        RunObject = Page "Customer Appl. calim details";
                    }
                    action("Channel Partner Lead List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Channel Partner Lead List';
                        Image = List;
                        //RunObject = Page 60790;
                    }
                    action("CP Leader Master List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'CP Leader Master List';
                        Image = List;
                        //RunObject = Page 60792;
                    }
                }

                group(RealEstateJagriti)
                {
                    Caption = 'Jagriti';
                    action("Jagriti Customer Details List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Jagriti Customer Details List';
                        Image = List;
                        RunObject = Page "Jagriti Customer Details List";
                    }
                    action("Jagrati Assoicate Details List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Jagrati Assoicate Details List';
                        Image = List;
                        RunObject = Page "Jagrati Assoicate Details List";
                    }
                    action("Jagriti Pending Approval Entry")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Jagriti Pending Approval Entry';
                        Image = Entries;
                        RunObject = Page "Jagriti Pending Approval Entry";
                    }
                    action("Jagriti Approval Site wise Setup")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Jagriti Approval Site wise Setup';
                        Image = Setup;
                        RunObject = Page "Jagriti Approval Site wise";
                    }
                    action("Jagrati Reporting Details")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Jagrati Reporting Details';
                        Image = ViewDetails;
                        RunObject = Page "Jagrati Reporting Leaders";
                    }
                    action("Special Jagrati Associate List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Special Jagrati Associate List';
                        Image = List;
                        //RunObject = Page 60781;
                    }
                }

                group(RealEstateLandProcess)
                {
                    Caption = 'Land Process';
                    action("Land Lead List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Land Lead List';
                        Image = List;
                        RunObject = Page "Land Lead List";
                    }
                    action("Land Opportunity List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Land Opportunity List';
                        Image = List;
                        RunObject = Page "Land Opportunity List";
                    }
                    action("Land Agreement List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Land Agreement List';
                        Image = List;
                        RunObject = Page "Land Agreement List";
                    }
                    action("BBG Setups")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'BBG Setups';
                        Image = Setup;
                        RunObject = Page "BBG Setups";
                    }
                    action("Assembly Orders")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Assembly Orders';
                        Image = Order;
                        RunObject = Page "Assembly Orders";
                    }
                    action("Land Sale Document Temp List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Land Sale Document Temp List';
                        Image = List;
                        RunObject = Page "Land Sale Document Temp List";
                    }
                }

                group(RealEstateGamification)
                {
                    Caption = 'Gamification';
                    action("Batch Detail Master List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Batch Detail Master List';
                        Image = List;
                        RunObject = Page "Batch Detail Master List";
                    }
                    action("Gamification Details")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Gamification Details';
                        Image = List;
                        RunObject = Page "Gamification Details";
                    }
                    action("Gamification Summary")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Gamification Summary';
                        Image = List;
                        RunObject = Page "Gamification Summary";
                    }
                    action("Gamification Team Hierarchy")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Gamification Team Hierarchy';
                        Image = List;
                        RunObject = Page "Gamification Team Hierarchy";
                    }
                    group(NewGamification)
                    {
                        Caption = 'New Gamification';
                        action("New Gamification Ind/Team Data")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'New Gamification Ind/Team Data';
                            Image = List;
                            RunObject = Page "New Gamification Ind/Team Data";
                        }
                    }
                }

                group(RealEstateReports)
                {
                    Caption = 'Reports';
                    group(BankReco)
                    {
                        Caption = 'Bank Reco';
                        action("Upload Bank Account Stmt Lines")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Upload Bank Account Stmt Lines';
                            //RunObject = xmlport 97759;
                        }
                    }
                    group(Correction)
                    {
                        Caption = 'Correction';
                        action("Upload Associate Blacklist")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Upload Associate Blacklist';
                            //RunObject = xmlport 97754;
                        }
                    }

                }
                group(RealEstateBatch)
                {
                    Caption = 'Batch';
                    action("User Setup Date Change")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'User Setup Date Change';
                        RunObject = report "User Setup Date Change";
                    }
                    action("Plot Vacate Auto Batch")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Plot Vacate Auto Batch';
                        RunObject = report "Plot Vacate Auto Batch";
                    }
                    action("OD Adjustment in Companies")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'OD Adjustment in Companies';
                        RunObject = report "OD Adjustment in Companies";
                    }
                    action("Receipt not Transfered in Comp")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Receipt not Transfered in Comp';
                        RunObject = page "Receipt not Transfered in Comp";
                    }
                    action("Associate Upload")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Associate Upload';
                        //RunObject = report 97735;
                    }
                    action("Upload Associate Responsibility center")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Upload Associate Responsibility center';
                        //RunObject = xmlport 97752;
                    }
                }

                group(RealEstateJobQueue)
                {
                    Caption = 'Job Queue';
                    action("Report Request Web/Mb List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Report Request Web/Mb List';
                        Image = List;
                        RunObject = Page "Report Request Web/Mb List";
                    }
                    action("Project wise Gold Proj. Setup")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Project wise Gold Proj. Setup';
                        Image = Setup;
                        RunObject = Page "Project wise Gold Proj. Setup";
                    }
                    action("Sub Team Master")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sub Team Master';
                        Image = List;
                        RunObject = Page "Sub Team Master";
                    }
                    action("Leader Master")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Leader Master';
                        Image = List;
                        RunObject = Page "Leader Master";
                    }
                    action("BBGSetups")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'BBG Setups';
                        Image = Setup;
                        RunObject = Page "BBG Setups";
                    }
                    action("Team Master List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Team Master List';
                        Image = List;
                        RunObject = Page "Team Master List";
                    }
                    action("Gamification User Setup")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Gamification User Setup';
                        Image = UserSetup;
                        RunObject = Page "Gamification User Setup";
                    }
                }

                group(RealEstateSetups)
                {
                    Caption = 'Setups';
                    action("Document Setup")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document Setup';
                        Image = Setup;
                        RunObject = Page "Document Setup";
                    }
                    action("Receipt Transfer in LLP Log")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Receipt Transfer in LLP Log';
                        Image = List;
                        RunObject = Page "Receipt Transfer in LLP Log";
                    }
                }
            }

            group(ChangeUserResponsibilityCenter)
            {
                Caption = 'User Resp. Center Selection';
                Image = Setup;
                action("User Resp. Center Selection")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'User Resp. Center Selection';
                    Image = UserSetup;
                    RunObject = Page "User Resp. Center Selection";
                    ToolTip = 'View or edit detailed information for the Location List';
                }
            }
            group("Finance & Accounts")
            {
                Caption = 'Finance & Accounts';
                group(FinMasters)
                {
                    Caption = 'Masters';
                    action(COA)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Chart of Account';
                        Image = Customer;
                        RunObject = Page "Chart of Accounts";
                    }
                    action(Bank)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Bank';
                        Image = Customer;
                        RunObject = Page "Bank Account List";
                    }
                    // action(Loan)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Loan';
                    //     Image = Customer;
                    //     RunObject = Page "Loan Master List";
                    // }
                    action(FinItems)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Items';
                        Image = Item;
                        RunObject = Page "Item List";
                        ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                    }
                    action(FinCustomers)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customers';
                        Image = Customer;
                        RunObject = Page "Customer List";
                        ToolTip = 'View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.';
                    }
                    action(FinVendors)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Vendors';
                        Image = Vendor;
                        RunObject = Page "Vendor List";
                        ToolTip = 'View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.';
                    }
                    // action(FinBOQMaster)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Services (Purchase)';
                    //     Image = Vendor;
                    //     RunObject = Page "BOQ Service Master List";
                    //     ToolTip = 'View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.';
                    // }
                    // action(FinBOQSaleMaster)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Service (Sales)';
                    //     Image = Customer;
                    //     RunObject = Page "BOQ Service Sale Master List";
                    // }

                }
                group(FinTransaction)
                {
                    Caption = 'Transactions';
                }
                group(FinAsset)
                {
                    Caption = 'Fixed Asset';
                    action(FixedAssetList)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Fixed Assets';
                        Image = Customer;
                        RunObject = Page "Fixed Asset List";
                    }

                    action(FixedAssetGLJou)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Fixed Assets G/L Journal';
                        Image = Customer;
                        RunObject = Page "Fixed Asset G/L Journal";
                    }
                    action(FixedAssetJou)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Fixed Assets Journal';
                        Image = Customer;
                        RunObject = Page "Fixed Asset Journal";
                    }
                    action(FAReclassJou)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'FA Reclass Journal';
                        Image = Customer;
                        RunObject = Page "FA Reclass. Journal";
                    }
                    action(CalcFADepr)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Calculate FA Depreciation';
                        Image = Customer;
                        RunObject = report "Calculate FA Depreciation";
                    }
                }
                group(FASLBTransfer)
                {
                    Caption = 'FA & SLB Transfer';

                    // group(TrfOut)
                    // {
                    //     Caption = 'Transfer OUT';
                    //     action(TransferSaleInv)
                    //     {
                    //         ApplicationArea = Basic, Suite;
                    //         Caption = 'FA Transfer Out';
                    //         Image = Customer;
                    //         RunObject = Page "Transfer Sales List";
                    //     }
                    //     action(SLBSaleInv)
                    //     {
                    //         ApplicationArea = Basic, Suite;
                    //         Caption = 'SLB Transfer Out';
                    //         Image = Customer;
                    //         RunObject = Page "SLB Sales List";
                    //     }

                    //     action(TransferSaleCrMemo)
                    //     {
                    //         ApplicationArea = Basic, Suite;
                    //         Caption = 'FA Transfer Out Cr. Memo';
                    //         Image = Customer;
                    //         RunObject = Page "Transfer Sales Credit Memos";
                    //     }
                    // }
                    // group(TrfIN)
                    // {
                    //     Caption = 'Transfer IN';
                    //     action(TransferPurchInv)
                    //     {
                    //         ApplicationArea = Basic, Suite;
                    //         Caption = 'FA Transfer IN';
                    //         Image = Customer;
                    //         RunObject = Page "Transfer Purchase List";
                    //     }
                    //     action(SLBPurchInv)
                    //     {
                    //         ApplicationArea = Basic, Suite;
                    //         Caption = 'SLB Transfer IN';
                    //         Image = Customer;
                    //         RunObject = Page "SLB Purchase List";
                    //     }

                    // }


                }
                group(FinPostedDoc)
                {
                    Caption = 'Posted Document';
                    action(GLRegister)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'G/L Registers';
                        Image = Customer;
                        RunObject = Page "G/L Registers";
                    }
                    action(GLEntries)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'General Ledger Entries';
                        Image = Customer;
                        RunObject = Page "General Ledger Entries";
                    }
                }
                group(FinTask)
                {
                    Caption = 'Tasks';
                    action(CashRcpt)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Cas&h Receipt Voucher';
                        Image = Customer;
                        RunObject = Page "Cash Receipt Voucher";
                    }
                    action(CashPymt)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Cas&h Payment Voucher';
                        Image = Customer;
                        RunObject = Page "Cash Payment Voucher";
                    }
                    action(BankRcpt)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Bank Receipt Voucher';
                        Image = Customer;
                        RunObject = Page "Bank Receipt Voucher";
                    }
                    action(BankPymt)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Bank Payment Voucher';
                        Image = Customer;
                        RunObject = Page "Bank Payment Voucher";
                    }
                    action(ContraVoucher)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Contra Voucher';
                        Image = Customer;
                        RunObject = Page "Contra Voucher";
                    }

                    action(PymtJournal)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Journal Voucher';
                        Image = Customer;
                        RunObject = Page "Journal Voucher";
                    }
                    action(GenJournal)
                    {
                        ApplicationArea = All;
                        Caption = 'General Journal';
                        Image = Customer;
                        RunObject = Page "General Journal";
                    }
                    action(ReccJournal)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Recurring Journal';
                        Image = Customer;
                        RunObject = Page "Recurring General Journal";
                    }
                    // action(PymtSplitJournal)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Payment Split Journal';
                    //     Image = Customer;
                    //     RunObject = Page "Payment Split Journal";
                    // }
                    action(BankAccReco)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Bank Acc. Reconciliation';
                        Image = Customer;
                        RunObject = Page "Bank Acc. Reconciliation List";
                    }
                }
                group(FimMIS)
                {
                    Caption = 'MIS';
                    action(TrialBalance)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = '&G/L Trial Balance';
                        Image = Customer;
                        RunObject = Page "Trial Balance";
                    }
                }
                group(FinReports)
                {
                    Caption = 'Reports';
                    action(DayBook)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Day Book';
                        Image = Customer;
                        RunObject = Report "Day Book";
                    }
                    action(BankBook)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Bank Book';
                        Image = Customer;
                        RunObject = Report "Bank Book";
                    }
                    action(CashBook)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Cash Book';
                        Image = Customer;
                        RunObject = Report "Cash Book";
                    }
                    action(FinLedger)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ledger';
                        Image = Customer;
                        RunObject = Report Ledger;
                    }
                    action(VoucherRegister)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Voucher Register';
                        Image = Customer;
                        RunObject = Report "Voucher Register";
                    }
                    action(PostedVoucher)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Voucher';
                        Image = Customer;
                        RunObject = Report "Posted Voucher";
                    }
                    action(AgedAccRecv)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aged Accounts Receivable';
                        Image = Customer;
                        RunObject = Report "Aged Accounts Receivable";
                    }
                    action(CustomerBalanceToDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer - Balance to Date';
                        Image = Customer;
                        RunObject = Report "Customer - Balance to Date";
                    }
                    action(AgedAccPayable)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Aged Accounts Payable';
                        Image = Customer;
                        RunObject = Report "Aged Accounts Payable";
                    }
                    // action(BankReconciliation)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Bank Reco. Statement';
                    //     Image = Customer;
                    //     RunObject = Report "SWBank Reconciliation";
                    // }


                }
                group(FinSetup)
                {
                    Caption = 'Set Up';
                    action(GenLedgerSetup)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'General Ledger Setup';
                        Image = Customer;
                        RunObject = Page "General Ledger Setup";
                    }
                }
                group(FinDebt)
                {
                    Caption = 'Deb&t';
                    // action(LoanManagementList)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Loan Management';
                    //     RunObject = page "Loan List";
                    // }
                    // action(LoanScheduler)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Loan Scheduler';
                    //     RunObject = report "Loan Scheduler";
                    // }
                }
            }

            group(Procurement)
            {
                Caption = 'Procurement';
                Image = FiledPosted;
                group(ProcMasters)
                {
                    Caption = 'Masters';
                    action(ProcVendors)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Vendors';
                        Image = Vendor;
                        RunObject = Page "Vendor List";
                        ToolTip = 'View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.';
                    }
                    // action(SecDepVendors)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Security Deposit - Vendor';
                    //     Image = Vendor;
                    //     RunObject = Page "Security Deposit - Vendor";
                    //     ToolTip = 'View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.';
                    // }
                    action(ProcItems)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item List';
                        Image = Item;
                        RunObject = Page "Item List";
                        ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                    }
                    action(ProcJobMasterList)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Job Master List';
                        Image = JobLines;
                        RunObject = Page "Job Master List";
                        //ToolTip = 'View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.';
                    }
                    action(ProcItemJournalTemplateList)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item Journal Template List';
                        Image = Item;
                        RunObject = Page "Item Journal Template List";
                    }
                    // action(City)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'City Master';
                    //     Image = Item;
                    //     RunObject = Page "City Master";
                    // }

                }
                group(ProcTransaction)
                {
                    Caption = 'Transactions';
                    action("Purchase Request List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Purchase Request List';
                        RunObject = Page "Purchase Request List";
                    }
                    action("Purchase Quotes")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Purchase Quotes';
                        RunObject = Page "Purchase Quotes";
                    }
                    action("Purchase Order List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Purchase Orders';
                        RunObject = Page "Purchase Order List";
                    }
                    action("JES List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'JES List';
                        RunObject = Page "JES List";
                    }
                    action("GRN List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'GRN List';
                        RunObject = Page "GRN List";
                    }
                    action("Purchase Invoices")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Purchase Invoices';
                        RunObject = Page "Purchase Invoices";
                    }
                    // action("PR VS PO Status")
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'PR VS PO Status';
                    //     RunObject = report 50044;
                    // }
                    group(ProcurementRegular)
                    {
                        Caption = 'Procurement - Regular';
                        Visible = false;

                        // action("Master RFQ List")
                        // {
                        //     ApplicationArea = Basic, Suite;
                        //     Caption = 'Master RFQ List';
                        //     RunObject = Page "Master RFQ List";
                        //     ToolTip = 'Executes the Master RFQ List action.';

                        // }
                        action("Enquiry List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Enquiry List';
                            RunObject = Page "Enquiry List";
                            ToolTip = 'Executes the Enquiry List action.';

                        }
                        action("Purchase & Service Quotes")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Purchase & Service Quotes';
                            RunObject = Page "Purchase Quotes";
                            ToolTip = 'Executes the Purchase & Service Quotes action.';

                        }
                        // action("Award Note List")
                        // {
                        //     ApplicationArea = Basic, Suite;
                        //     Caption = 'Award Note List';
                        //     RunObject = Page "Award Note List";
                        //     ToolTip = 'Executes the Award Note List action.';

                        // }
                        // action("Purchase Orders-Regular")
                        // {
                        //     ApplicationArea = Basic, Suite;
                        //     Caption = 'Purchase Orders-Regular';
                        //     RunObject = Page "Purchase Orders-Regular";
                        //     ToolTip = 'Executes the Purchase Orders-Regular action.';

                        // }


                        // action("Goods Receipt-Goods List Reg")
                        // {
                        //     ApplicationArea = Basic, Suite;
                        //     Caption = 'Goods Receipt-Goods List';
                        //     RunObject = Page "Goods Receipt List";
                        //     ToolTip = 'Executes the Goods Receipt-Goods List action.';
                        // }
                        // action("Goods Receipt List - JES Reg")
                        // {
                        //     ApplicationArea = Basic, Suite;
                        //     Caption = 'Work Receipt List - JES';
                        //     RunObject = Page "Goods Receipt List-JES";
                        //     ToolTip = 'Executes the Goods Receipt-JES List action.';
                        // }


                        // action("Purchase Invoices-Regular")
                        // {
                        //     ApplicationArea = Basic, Suite;
                        //     Caption = 'Purchase Invoices-Regular';
                        //     RunObject = Page "Purchase Invoices-Regular";
                        //     ToolTip = 'Executes the Purchase Invoices-Regular action.';

                        // }
                        // action("Purchase Invoices-Work Order Reg")
                        // {
                        //     ApplicationArea = Basic, Suite;
                        //     Caption = 'Purchase Invoices-Work Order';
                        //     RunObject = Page "Purchase Invoices-Work Order";
                        //     ToolTip = 'Executes the Purchase Invoices-Work Order action.';

                        // }

                    }

                    action("Purchase Credit Memo")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Purchase Cr. Memo List';
                        RunObject = Page "Purchase Credit Memos";
                        ToolTip = 'Executes the Purchase Credit Memo List action.';
                    }
                    // action("Material Issue List")
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Material Issue List';
                    //     RunObject = Page "Material Issue List";
                    //     ToolTip = 'Executes the Material Issue List action.';
                    // }

                }
                group(ProcPostedDoc)
                {
                    Caption = 'Posted Documents';
                    action(PostedPurchRcpt)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Purchase Receipts';
                        RunObject = Page "Posted Purchase Receipts";
                    }
                    action(PostedGRNList)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted GRN List';
                        RunObject = Page "Posted GRN List";
                    }
                    action(PostedPurchInv)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Purchase Invoices';
                        RunObject = Page "Posted Purchase Invoices";
                    }
                    action(PostedReturnShpt)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Return Shipments';
                        RunObject = Page "Posted Return Shipments";
                    }
                    action(PostedPurchCrMemo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Purchase Credit Memos';
                        RunObject = Page "Posted Purchase Credit Memos";
                    }
                    // action(PostedMaterialIssueList)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Posted Material Issue List';
                    //     RunObject = Page "Posted Material Issue List";
                    // }
                }
                group(ProcReports)
                {
                    Caption = 'Reports';
                    // action(PaymentSheet)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Payment Sheet';
                    //     Image = Customer;
                    //     RunObject = Report "Payment Sheet";
                    // }
                    // action(PurchPriceItem)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Purchase Price - Item';
                    //     Image = Customer;
                    //     RunObject = Report "Purchase Price Item SW";
                    // }
                    // action("Proc PR vs PO Status")
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'PR VS PO Status';
                    //     RunObject = Report 50044;
                    // }
                    action(VendList)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Vendor - List';
                        Image = Customer;
                        RunObject = Report "Vendor - List";
                    }
                    action(VendReg)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Vendor Register';
                        Image = Customer;
                        RunObject = Report "Vendor Register";
                    }
                    action(VendDetailTrialBal)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Vendor - Detail Trial Balance';
                        Image = Customer;
                        RunObject = Report "Vendor - Detail Trial Balance";
                    }
                    action(VendOrderSummary)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Vendor - Order Summary';
                        Image = Customer;
                        RunObject = Report "Vendor - Order Summary";
                    }
                    action(VendOrderDetail)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Vendor - Order Detail';
                        Image = Customer;
                        RunObject = Report "Vendor - Order Detail";
                    }
                    action(VendPurchaseList)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Vendor - Purchase List';
                        Image = Customer;
                        RunObject = Report "Vendor - Purchase List";
                    }
                    action(VendLabel)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Vendor - Labels';
                        Image = Customer;
                        RunObject = Report "Vendor - Labels";
                    }
                    action(VendTop10List)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Vendor - Top 10 List';
                        Image = Customer;
                        RunObject = Report "Vendor - Top 10 List";
                    }
                    action(VendItemPurchase)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Vendor/Item Purchases';
                        Image = Customer;
                        RunObject = Report "Vendor/Item Purchases";
                    }
                    // action(PurchaseRegister)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Purchase Register';
                    //     Image = Customer;
                    //     RunObject = Report "Purchase Register";
                    // }
                    // action(FARReport)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'FAR Report';
                    //     Image = Customer;
                    //     RunObject = report "FAR Report";
                    // }
                    action(ItemByLocation)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item By Location';
                        RunObject = page "Items by Location";
                    }
                    action(Navigate2)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Navigate';
                        RunObject = Page Navigate;
                    }
                }
                group(ProcSetup)
                {
                    Caption = 'Set Up';
                    action(PurchPayableSetup)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Purchase & Payable Setup';
                        RunObject = Page "Purchases & Payables Setup";
                    }
                    // action(PurchasePriceItem)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Purchase Price - Item';
                    //     RunObject = Page "Purchase Prices SW";
                    // }
                    // action(PurchasePriceService)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Purchase Price - Service';
                    //     RunObject = Page "Purchase Prices Service";
                    // }
                }
            }

            group(Inventory)
            {
                Caption = 'Inventory';
                group(InvMasters)
                {
                    Caption = 'Masters';
                    action(InvItems)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Items';
                        Image = Item;
                        RunObject = Page "Item List";
                        ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                    }


                }
                group(InvTransaction)
                {
                    Caption = 'Tra.nsactions';
                    action(TransferOrder)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Transfer List';
                        Image = Item;
                        RunObject = Page "Transfer Orders";
                    }

                }
                group(InvPostedDoc)
                {
                    Caption = 'Posted Document';
                    action(PostedTrfShpt)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Transfer Shipments';
                        Image = Item;
                        RunObject = Page "Posted Transfer Shipments";
                    }
                    action(PostedTrfRcpt)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Transfer Receipts';
                        Image = Item;
                        RunObject = Page "Posted Transfer Receipts";
                    }

                }
                // group(InvTask)
                // {
                //     Caption = 'Tasks';
                //     action(UploadItemExtendedText)
                //     {
                //         ApplicationArea = Basic, Suite;
                //         Caption = 'Upload Item Extended Text';
                //         Image = Item;
                //         RunObject = xmlport "Upload Item Extended Text";
                //     }
                //     action(UploadBOQExtendedText)
                //     {
                //         ApplicationArea = Basic, Suite;
                //         Caption = 'Upload BOQ Extended Text';
                //         Image = Item;
                //         RunObject = xmlport "Upload BOQ Extended Text";
                //     }
                // }
                group(InvReports)
                {
                    Caption = 'Reports';
                    action(ItemAgeCompQty)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item Age Composition - Qty.';
                        Image = Customer;
                        RunObject = Report "Item Age Composition - Qty.";
                    }
                    action(ItemAgeCompValue)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item Age Composition - Value';
                        Image = Customer;
                        RunObject = Report "Item Age Composition - Value";
                    }
                    action(ItemExpQty)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item Expiration - Quantity';
                        Image = Customer;
                        RunObject = Report "Item Expiration - Quantity";
                    }
                    action(InventoryList)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Inventory - List';
                        Image = Customer;
                        RunObject = Report "Inventory - List";
                    }
                    action(ItemRegQty)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Item Register - Quantity';
                        Image = Customer;
                        RunObject = Report "Item Register - Quantity";
                    }
                    action(InvOrderDetails)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Inventory Order Details';
                        Image = Customer;
                        RunObject = Report "Inventory Order Details";
                    }
                    action(InvPurchaseOrder)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Inventory Purchase Orders';
                        Image = Customer;
                        RunObject = Report "Inventory Purchase Orders";
                    }
                    action(InvTop10List)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Inventory - Top 10 List';
                        Image = Customer;
                        RunObject = Report "Inventory - Top 10 List";
                    }
                    action(InvValuation)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Inventory Valuation';
                        Image = Item;
                        RunObject = report "Inventory Valuation";
                    }
                }
                group(InvSetup)
                {
                    Caption = 'Set Up';
                    action(InvtSetup)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Inventory Setup';
                        Image = Item;
                        RunObject = Page "Inventory Setup";
                    }
                }
            }
            group(Sales)
            {
                Caption = 'Sales';
                Image = FiledPosted;
                group(SaleMasters)
                {
                    Caption = 'Masters';
                    action(SaleItems)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Items';
                        Image = Item;
                        RunObject = Page "Item List";
                        ToolTip = 'View or edit detailed information for the products that you trade in. The item card can be of type Inventory or Service to specify if the item is a physical unit or a labor time unit. Here you also define if items in inventory or on incoming orders are automatically reserved for outbound documents and whether order tracking links are created between demand and supply to reflect planning actions.';
                    }
                    action(SaleCustomers)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customers';
                        Image = Customer;
                        RunObject = Page "Customer List";
                        ToolTip = 'View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.';
                    }
                    // action(SecDepCustomer)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Security Deposit - Customer';
                    //     Image = Vendor;
                    //     RunObject = Page "Security Deposit - Customer";
                    //     ToolTip = 'View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.';
                    // }
                    // action(MainHead)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Main Head';
                    //     Image = Customer;
                    //     RunObject = Page "Main Head";
                    // }
                    // action(PLHead)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'PL Head';
                    //     Image = Customer;
                    //     RunObject = Page "PL Head";
                    // }
                    // action(MISSupp)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'MIS Supplimentary';
                    //     Image = Customer;
                    //     RunObject = Page "MIS Supplimentary";
                    // }
                    // action(BOQSaleMaster)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Service (Sales)';
                    //     Image = Customer;
                    //     RunObject = Page "BOQ Service Sale Master List";
                    // }
                }
                group(SaleTransaction)
                {
                    Caption = 'Transactions';
                    action(SaleOrder)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sales Orders';
                        Image = Customer;
                        RunObject = Page "Sales Order List";
                    }
                    // action(SaleInvoice)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Client Invoices';
                    //     Image = Customer;
                    //     RunObject = Page "Client Invoice List";
                    // }

                    // action(SaleInvoicePrimary)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Sales Invoices - Primary';
                    //     Image = Customer;
                    //     RunObject = Page "Sales Invoice - Project";
                    // }
                    // action(SaleInvoiceSupp)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Sales Invoices - Supplimentary';
                    //     Image = Customer;
                    //     RunObject = Page "Sales Invoice - Supp";
                    // }
                    // action(SaleInvoiceVarSupp)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Sales Invoices - Var Supplimentary';
                    //     Image = Customer;
                    //     RunObject = Page "Sales Invoice - Var. Supp";
                    // }
                    action(SaleRetOrder)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sales Return Order';
                        Image = Customer;
                        RunObject = Page "Sales Return Order";
                    }
                    action(SaleCrMemo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sales Cr. Memo';
                        Image = Customer;
                        RunObject = Page "Sales Credit Memos";
                    }

                }
                group(SalePostedDoc)
                {
                    Caption = 'Posted Document';
                    action(PostedSalesShpt)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Sales Shipments';
                        Image = Customer;
                        RunObject = Page "Posted Sales Shipments";
                    }
                    action(PostedSalesInv)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Sales Invoices';
                        Image = Customer;
                        RunObject = Page "Posted Sales Invoices";
                    }
                    action(PostedSalesCrMemo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Sales Credit Memos';
                        Image = Customer;
                        RunObject = Page "Posted Sales Credit Memos";
                    }
                    // action(PaymentApplication)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Payment Application';
                    //     Image = Customer;
                    //     RunObject = Page "Payment Application SW";
                    // }
                }
                group(SaleTask)
                {
                    Caption = 'Tasks';
                    action(SalesPrice)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sales &Prices';
                        Image = Customer;
                        RunObject = Page "Sales Prices";
                    }
                }
                group(SaleReports)
                {
                    Caption = 'Reports';
                    // action(SalesRegister)
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Sales Register';
                    //     Image = Customer;
                    //     RunObject = Report "Sales Inv Line/Sales Cr. Memo";
                    // }
                    action(CustomerList)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer - List';
                        Image = Customer;
                        RunObject = Report "Customer - List";
                    }
                    action(CustomerRegister)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer Register';
                        Image = Customer;
                        RunObject = Report "Customer Register";
                    }
                    action(CustomerDetailTrialBal)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer - Detail Trial Bal.';
                        Image = Customer;
                        RunObject = Report "Customer - Detail Trial Bal.";
                    }
                    action(CustomerOrderSummary)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer - Order Summary';
                        Image = Customer;
                        RunObject = Report "Customer - Order Summary";
                    }
                    action(CustomerOrderDetail)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer - Order Detail';
                        Image = Customer;
                        RunObject = Report "Customer - Order Detail";
                    }
                    action(CustomerLabels)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer - Labels';
                        Image = Customer;
                        RunObject = Report "Customer - Labels";
                    }
                    action(CustomerTop10List)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer - Top 10 List';
                        Image = Customer;
                        RunObject = Report "Customer - Top 10 List";
                    }
                    action(CustomerPymtRcpt)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer - Payment Receipt';
                        Image = Customer;
                        RunObject = Report "Customer - Payment Receipt";
                    }
                    action(SalesStatistics)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sales Statistics';
                        Image = Customer;
                        RunObject = Report "Sales Statistics";
                    }
                    action(CustomerItemSales)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer/Item Sales';
                        Image = Customer;
                        RunObject = Report "Customer/Item Sales";
                    }
                }
                group(SaleSetup)
                {
                    Caption = 'Set Up';
                    action(SalesRecvSetup)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sales & Receivables Setup';
                        Image = Customer;
                        RunObject = Page "Sales & Receivables Setup";
                    }
                }
            }



            group(ClearTax)
            {
                Caption = 'Clear Tax';

                // group(MaxITC)
                // {
                //     Caption = 'Max ITC';
                //     action(MaxITCSetup)
                //     {
                //         ApplicationArea = Basic, Suite;
                //         Caption = 'MaxITC Setup';
                //         RunObject = page "ClearComp MaxITC Setup";
                //     }
                //     action(MaxITCGenData)
                //     {
                //         ApplicationArea = Basic, Suite;
                //         Caption = 'MaxITC Transfer Data';
                //         RunObject = report "ClearComp MaxITC Transfer Data";
                //     }
                //     action(MaxITCTransList)
                //     {
                //         ApplicationArea = Basic, Suite;
                //         Caption = 'MaxITC Transaction List';
                //         RunObject = page "ClearComp MaxITC Trans. list";
                //     }
                //     action(MaxITCIngestedData)
                //     {
                //         ApplicationArea = Basic, Suite;
                //         Caption = 'MaxITC Ingested Data';
                //         RunObject = page "Clearcomp MaxITC Trans. Data";
                //     }
                //     action(MaxITCApilogs)
                //     {
                //         ApplicationArea = Basic, Suite;
                //         Caption = 'MaxITC Api logs';
                //         RunObject = page "ClearComp MaxITC Logs";
                //     }
                //     action(MaxITCPaymentlogs)
                //     {
                //         ApplicationArea = Basic, Suite;
                //         Caption = 'MaxITC Payment logs';
                //         RunObject = page "ClearComp MaxITC Payment Log";
                //     }
                // }


                // group(ClearGST)
                // {
                //     Caption = 'Clear GST';

                //     action(GSTSetup)
                //     {
                //         ApplicationArea = Basic, Suite;
                //         Caption = 'GST Setup';
                //         RunObject = Page "Clear GST Setup";
                //     }
                //     action(GSTGenerateData)
                //     {
                //         ApplicationArea = Basic, Suite;
                //         Caption = 'Generate Data';
                //         RunObject = report "Clear Generate data";
                //     }
                //     action(IngestDatatoPortal)
                //     {
                //         ApplicationArea = Basic, Suite;
                //         Caption = 'Ingest Data to Portal';
                //         RunObject = codeunit "Clear Send request";
                //     }
                //     action(UnSyncTransaction)
                //     {
                //         ApplicationArea = Basic, Suite;
                //         Caption = 'Un-Sync Transactions';
                //         RunObject = Page "Clear Transactions";
                //     }
                //     action(SyncedTransactions)
                //     {
                //         ApplicationArea = Basic, Suite;
                //         Caption = 'Synced Transactions';
                //         RunObject = Page "Clear Synced Transactions";
                //     }
                //     action(Apilogs)
                //     {
                //         ApplicationArea = Basic, Suite;
                //         Caption = 'Api logs';
                //         RunObject = page "Clear API logs";
                //     }
                // }
                /*
                group(EWay)
                {
                    Caption = 'E-Way';

                    action(SalesInvEWay)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sales Inv E-Way';
                        RunObject = Page "ClearComp Sales E-Way Invoice";
                    }
                    action(SalesCrMemoEWay)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sales Cr. Memo E-Way';
                        RunObject = Page "ClearComp Sales E-Way CR.memo";
                    }
                    action(PurchReturnEWay)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Purch. Return E-Way';
                        RunObject = Page "ClearComp Purch. Ret E-WayInv";
                    }
                    action(TransferShipmentEWay)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Transfer Shipment E-Way';
                        RunObject = Page "ClearComp Transf. Shp E-WayInv";
                    }
                    action(EWayBillRequest)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'E-Way Bill Request';
                        RunObject = Page "ClearComp E-Way Bill Requests";
                    }
                }
                */
                // group(EInvoice)
                // {
                //     Caption = 'E-Invoice';

                //     action(EInvoiceSetup)
                //     {
                //         ApplicationArea = Basic, Suite;
                //         Caption = 'E-Invoice Setup';
                //         RunObject = Page "ClearComp E-Invoice Setup";
                //     }
                //     action(GenerateEInvoice)
                //     {
                //         ApplicationArea = Basic, Suite;
                //         Caption = 'Generate E-Invoice';
                //         RunObject = report "ClearComp Generate IRN";
                //     }
                //     action(EInvApilogs)
                //     {
                //         ApplicationArea = Basic, Suite;
                //         Caption = 'Api logs';
                //         RunObject = page "ClearComp E-Invoice Logs";
                //     }
                //     action(ApiMessagelogs)
                //     {
                //         ApplicationArea = Basic, Suite;
                //         Caption = 'Api Message logs';
                //         RunObject = page "ClearComp Interface Msg Log";
                //     }
                // }

            }

            group(Administration)
            {
                Caption = 'Administration';
                group(AdminTableView)
                {
                    Caption = 'Table View';
                    action("Payment Transaction Details")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Payment Transaction Details';
                        RunObject = Page "Customer Payment Tran. Details";
                    }
                    action("Vendor with Blacklist")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Vendor with Blacklist';
                        RunObject = Page "Vendor with Blacklist";
                    }
                }
                group(AdminSetups)
                {
                    Caption = 'Setups';
                    action("Unit Setup")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Unit Setup';
                        RunObject = Page "Unit Setup";
                    }
                    action("Customer List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Customer List';
                        RunObject = Page "Customer List";
                    }
                    action("Vendor List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Vendor List';
                        RunObject = Page "Vendor List";
                    }
                    action("Vendor - Others")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Vendor - Others';
                        RunObject = Page "Vendor Card for others";
                    }
                    action("Sales & Receivables Setup")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sales & Receivables Setup';
                        RunObject = Page "Sales & Receivables Setup";
                    }
                    action("User Resp. Center Setup")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'User Resp. Center Setup';
                        RunObject = Page "User Resp center Setup";

                    }
                    action("Jobs Setup")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Jobs Setup';
                        RunObject = Page "Jobs Setup";
                    }
                    action("Company wise G/L")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Company wise G/L';
                        RunObject = Page "Company wise G/L";
                    }
                }
                group(AdminWeb)
                {
                    Caption = 'Web';

                    action("Web log Entries")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Web log Entries';
                        RunObject = Page "Web log Entries";
                    }
                    action("Assocaite Web Staging Form")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Assocaite Web Staging Form';
                        RunObject = Page "Assocaite Web Staging Form";
                    }
                    action("Associate Eleg Staging")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Associate Eleg Staging';
                        //RunObject = Page 97910;
                    }
                    action("Asst Elig Web Unit Vacate")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Asst Elig Web Unit Vacate';
                        RunObject = Page "Asst Elig Web Unit Vacate";
                    }
                    action("New Booking/ Allotment/ TA")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Booking/ Allotment/ TA';
                        RunObject = report "New Booking/Allotment/TA50096";
                    }
                    action("New CommissionEligibility 33057771")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New CommissionEligibility 33057771';
                        RunObject = report "New CommissionEligibility50082";
                    }
                }
                group(AdminSMS)
                {
                    Caption = 'SMS';
                    action("Common SMS")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Common SMS';
                        RunObject = Page "Common SMS";
                    }
                }
                group(AdminJobQueue)
                {
                    Caption = 'Job Queue';
                    // action("Job Queues")
                    // {
                    //     ApplicationArea = Basic, Suite;
                    //     Caption = 'Job Queues';
                    //     RunObject = Page 670;
                    // }
                    action("Job Queue Entry Card")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Job Queue Entry Card';
                        RunObject = Page "Job Queue Entry Card";
                    }
                    action("Job Queue Category List")
                    {
                        Caption = 'Job Queue Category List';
                        ApplicationArea = all;
                        RunObject = page "Job Queue Category List";
                    }
                    action("Job Queue Log Entries")
                    {
                        Caption = 'Job Queue Log Entries';
                        ApplicationArea = all;
                        RunObject = page "Job Queue Log Entries";
                    }
                    action("Job Queue Reset")
                    {
                        Caption = 'Job Queue Reset';
                        ApplicationArea = all;
                        RunObject = page "Job Queue Reset";
                    }
                }
                group(AdminEmailSetup)
                {
                    Caption = 'Email Setup';
                    action("SMTP Mail Setup")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'SMTP Mail Setup';
                        //RunObject = Page 409;
                    }
                    action("Associate Report details")
                    {
                        Caption = 'Associate Report details';
                        ApplicationArea = all;
                        RunObject = page "Associate Report details";
                    }
                    action("Associate Report List_Jobqueue")
                    {
                        Caption = 'Associate Report List_Jobqueue';
                        ApplicationArea = all;
                        RunObject = page "Associate Report List_Jobqueue";
                    }
                    action(AdminUnitSetup)
                    {
                        Caption = 'Unit Setup';
                        ApplicationArea = all;
                        RunObject = page "Unit Setup";
                    }
                }
                group(AdminAssociateElegonWebSetup)
                {
                    Caption = 'Associate Eleg. on Web Setup';
                    action(AssocaiteWebStagingForm)
                    {
                        Caption = 'Assocaite Web Staging Form';
                        ApplicationArea = Basic, Suite;
                        RunObject = page "Assocaite Web Staging Form";
                    }
                    action(AsstEligWebUnitVacate)
                    {
                        Caption = 'Asst Elig Web Unit Vacate';
                        ApplicationArea = all;
                        RunObject = page "Asst Elig Web Unit Vacate";
                    }
                    action(UserSetupDateChange)
                    {
                        Caption = 'User Setup Date Change';
                        ApplicationArea = all;
                        RunObject = report "User Setup Date Change";
                    }
                }
                group(AdminDataport)
                {
                    Caption = 'Data port';
                    action("G/L Data Export")
                    {
                        Caption = 'G/L Data Export';
                        ApplicationArea = all;
                        RunObject = xmlport 50082;
                    }
                    action("TDS to Vend data upload")
                    {
                        Caption = 'TDS to Vend data upload';
                        ApplicationArea = all;
                        RunObject = xmlport 50080;
                    }
                    action("General Jnl Line Upload")
                    {
                        Caption = 'General Jnl Line Upload';
                        ApplicationArea = all;
                        RunObject = xmlport "General Jnl Line Upload";
                    }
                    action("DMSUniversal XMLport")
                    {
                        Caption = 'DMS Universal XMLport';
                        ApplicationArea = all;

                        RunObject = xmlport "DMSUniversal XMLport";
                    }

                    action("Upload Block Ass. Team Positive")
                    {
                        Caption = 'Upload Block Ass. Team Positive';
                        ApplicationArea = all;

                        RunObject = xmlport "Upload block Ass Team positive";
                    }

                    action("District-Mandal upload XMLport")
                    {
                        Caption = 'District/Mandal upload XMLport';
                        ApplicationArea = all;

                        RunObject = xmlport "District and Mandal uploader";
                    }

                    action("Update GL Cheuque No.")
                    {
                        Caption = 'Update GL Cheuque No. XmlPort';
                        ApplicationArea = all;

                        RunObject = xmlport "Update GLEntry Cheque No.";
                    }

                }
                group(AdminMobileApplication)
                {
                    Caption = 'Mobile Application';
                    action("Associate Login Details")
                    {
                        Caption = 'Associate Login Details';
                        ApplicationArea = all;
                        RunObject = page "Associate Login Details";
                    }
                    action("BBG Payment Transaction Details")
                    {
                        Caption = 'Payment Transaction Details';
                        ApplicationArea = all;
                        RunObject = page "Customer Payment Tran. Details";
                    }
                }

                group(XMLPORTS)
                {
                    Caption = 'Data Uploader';
                    action("No. Series Header Upload")
                    {
                        Caption = 'No. Series Header Upload';
                        ApplicationArea = all;
                        RunObject = xmlport "No. Series Header upload";
                    }
                    action("No. Series Line Upload")
                    {
                        Caption = 'No. Series Lines Upload';
                        ApplicationArea = all;
                        RunObject = xmlport "No Series Line Part";
                    }
                    action("General Journal Line Upload")
                    {
                        Caption = 'General Journal Line Upload';
                        ApplicationArea = all;
                        RunObject = xmlport "General Jnl Line Upload";
                    }
                }

            }
        }
    }
}


