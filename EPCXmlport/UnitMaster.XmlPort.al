xmlport 50008 "Unit Master"
{
    Direction = Both;
    Format = Xml;
    FormatEvaluate = Legacy;

    schema
    {
        textelement(UnitMaster)
        {
            MaxOccurs = Once;
            tableelement("Unit Master"; "Unit Master")
            {
                MaxOccurs = Unbounded;
                XmlName = 'UnitDetails';
                UseTemporary = true;
                fieldelement(No; "Unit Master"."No.")
                {
                }
                fieldelement(Web_Portal_Status; "Unit Master"."Web Portal Status")
                {
                }
                fieldelement(Non_Usable; "Unit Master"."Non Usable")
                {
                }
                fieldelement(Associate_Code; "Unit Master"."Associate Code")
                {
                }
                fieldelement(Associate_Name; "Unit Master"."Associate Name")
                {
                }
                fieldelement(Reserve; "Unit Master".Reserve)
                {
                }
                fieldelement("No._of_Plots_for_Incentive_Cal"; "Unit Master"."No. of Plots for Incentive Cal")
                {
                }
                fieldelement(Block_SubType; "Unit Master"."Block SubType")
                {
                }
                fieldelement(Unit_for_Company; "Unit Master"."Unit for Company")
                {
                }
                fieldelement(PLC_Applicable; "Unit Master"."PLC Applicable")
                {
                }
                fieldelement(East_Boundary; "Unit Master"."East Boundary")
                {
                }
                fieldelement(West_Boundary; "Unit Master"."West Boundary")
                {
                }
                fieldelement(North_Boundary; "Unit Master"."North Boundary")
                {
                }
                fieldelement(South_Boundary; "Unit Master"."South Boundary")
                {
                }
                fieldelement(Mortgage; "Unit Master".Mortgage)
                {
                }
                fieldelement(hundredfeetroad; "Unit Master"."100 feet Road")
                {
                }
                fieldelement(Approve; "Unit Master".Approve)
                {
                }
                fieldelement("App._Payment_Plan"; "Unit Master"."App. Payment Plan")
                {
                }
                fieldelement(Regd_Numbers; "Unit Master"."Regd Numbers")
                {
                }
                fieldelement(Regd_date; "Unit Master"."Regd date")
                {
                }
                fieldelement(Payment_plan_Code; "Unit Master"."Payment plan Code")
                {
                }
                fieldelement(Doj; "Unit Master".Doj)
                {
                }
                fieldelement(Ldp; "Unit Master".Ldp)
                {
                }
                fieldelement(Minimum_Booking_Amount; "Unit Master"."Minimum Booking Amount")
                {
                }
                fieldelement(Vacate_by_Job_Queue; "Unit Master"."Vacate by Job Queue")
                {
                }
                fieldelement(Vacate_by_Job_Queue_DAtetime; "Unit Master"."Vacate by Job Queue DAtetime")
                {
                }
                fieldelement(Old_Status; "Unit Master"."Old Status")
                {
                }
                fieldelement(Plot_hold_for_Mobile_App; "Unit Master"."Plot hold for Mobile App")
                {
                }
                fieldelement(Plot_hold_USER_ID__Mobile_App; "Unit Master"."Plot hold USER ID _Mobile App")
                {
                }
                fieldelement(Unit_Category; "Unit Master"."Unit Category")
                {
                }
                fieldelement(Creation_Date; "Unit Master"."Creation Date")
                {
                }
                fieldelement(Modify_Date; "Unit Master"."Modify Date")
                {
                }
                fieldelement(Modify_Time; "Unit Master"."Modify Time")
                {
                }
                fieldelement(Modified_By; "Unit Master"."Modified By")
                {
                }
                fieldelement(Super_Area; "Unit Master"."Super Area")
                {
                }
                fieldelement(Saleable_Area; "Unit Master"."Saleable Area")
                {
                }
                fieldelement(Carpet_Area; "Unit Master"."Carpet Area")
                {
                }
                fieldelement(Efficiencypercentage; "Unit Master"."Efficiency (%)")
                {
                }
                fieldelement(Sales_Rate; "Unit Master"."Sales Rate")
                {
                }
                fieldelement(PLCpercentage; "Unit Master"."PLC (%)")
                {
                }
                fieldelement(Lease_Zone_Code; "Unit Master"."Lease Zone Code")
                {
                }
                fieldelement(Unit_Type; "Unit Master"."Unit Type")
                {
                }
                fieldelement(Lease_Rate; "Unit Master"."Lease Rate")
                {
                }
                fieldelement(Sales_Blocked; "Unit Master"."Sales Blocked")
                {
                }
                fieldelement(Lease_Blocked; "Unit Master"."Lease Blocked")
                {
                }
                fieldelement(Project_Price_Group; "Unit Master"."Project Price Group")
                {
                }
                fieldelement(Sales_Order_Count; "Unit Master"."Sales Order Count")
                {
                }
                fieldelement(Lease_Order_Count; "Unit Master"."Lease Order Count")
                {
                }
                fieldelement(Constructed_Property; "Unit Master"."Constructed Property")
                {
                }
                fieldelement(Type; "Unit Master".Type)
                {
                }
                fieldelement(Project_Code; "Unit Master"."Project Code")
                {
                }
                fieldelement(Sub_Project_Code; "Unit Master"."Sub Project Code")
                {
                }
                fieldelement("Sell_to_Customer_No."; "Unit Master"."Sell to Customer No.")
                {
                }
                fieldelement("Broker_No."; "Unit Master"."Broker No.")
                {
                }
                fieldelement("Floor_No."; "Unit Master"."Floor No.")
                {
                }
                fieldelement(Description; "Unit Master".Description)
                {
                }
                fieldelement(Base_Unit_of_Measure; "Unit Master"."Base Unit of Measure")
                {
                }
                fieldelement(Payment_Plan; "Unit Master"."Payment Plan")
                {
                }
                fieldelement(Facing; "Unit Master".Facing)
                {
                }
                fieldelement("Size-East"; "Unit Master"."Size-East")
                {
                }
                fieldelement("Size-West"; "Unit Master"."Size-West")
                {
                }
                fieldelement("Size-North"; "Unit Master"."Size-North")
                {
                }
                fieldelement("Size-South"; "Unit Master"."Size-South")
                {
                }
                fieldelement("Min._Allotment_Amount"; "Unit Master"."Min. Allotment Amount")
                {
                }
                fieldelement(Status; "Unit Master".Status)
                {
                }
                fieldelement(sixtyfeetroad; "Unit Master"."60 feet Road")
                {
                }
                fieldelement(Freeze; "Unit Master".Freeze)
                {
                }
                fieldelement(Total_Value; "Unit Master"."Total Value")
                {
                }
                fieldelement(Project_Name; "Unit Master"."Project Name")
                {
                }
                fieldelement(Customer_Code; "Unit Master"."Customer Code")
                {
                }
                fieldelement("No._of_Plots"; "Unit Master"."No. of Plots")
                {
                }
                fieldelement("Old_No."; "Unit Master"."Old No.")
                {
                }
                fieldelement(Corner; "Unit Master".Corner)
                {
                }
                fieldelement(Comment_for_Unit_Block; "Unit Master"."Comment for Unit Block")
                {
                }
                fieldelement(Version; "Unit Master".Version)
                {
                }
                fieldelement(Archived; "Unit Master".Archived)
                {
                }
                fieldelement(Blocked; "Unit Master".Blocked)
                {
                }
                fieldelement(Company_Name; "Unit Master"."Company Name")
                {
                }
                fieldelement(Plot_Cost; "Unit Master"."Plot Cost")
                {
                }
                fieldelement(Customer_Name; "Unit Master"."Customer Name")
                {
                }
                fieldelement("Registration_No."; "Unit Master"."Registration No.")
                {
                }
                fieldelement(Unit_Registered; "Unit Master"."Unit Registered")
                {
                }
                fieldelement(Special_Units; "Unit Master"."Special Units")
                {
                }
                fieldelement(Check_unit_Alloted; "Unit Master"."Check unit Alloted")
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


    procedure SetunitMaster(TempUnitMaster: Record "Unit Master" temporary)
    begin
        "Unit Master".INIT;
        "Unit Master" := TempUnitMaster;
        "Unit Master".INSERT;
    end;
}

