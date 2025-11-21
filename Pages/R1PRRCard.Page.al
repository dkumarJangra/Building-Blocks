page 60675 "R-1 PRR Card"
{
    AutoSplitKey = true;
    PageType = Card;
    SourceTable = "Land R-1 PPR Document Lis_1";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field("Village Name"; Rec."Village Name")
                {
                }
                field("Mandalam Name"; Rec."Mandalam Name")
                {
                }
                field("State Code"; Rec."State Code")
                {
                }
                field("Post Code"; Rec."Post Code")
                {
                }
                field("Total Land Area"; Rec."Total Land Area")
                {
                    Caption = 'Total area of the land (in Acres)';
                }
                field("Type of the land"; Rec."Type of the land")
                {
                }
                field("Distance from Main road"; Rec."Distance from Main road")
                {
                    Caption = 'Distance from Main road / Highway (in km)';
                }
                field("Length (land facing the road)"; Rec."Length (land facing the road)")
                {
                    Caption = 'Length of the land facing the road (in km)';
                }
                field("Taste of Water"; Rec."Taste of Water")
                {
                }
                field("Bore well purpose  (in Feet's)"; Rec."Bore well purpose  (in Feet's)")
                {
                    Caption = 'At what depth, water is available under the land for bore well purpose  (in Feet''s)';
                }
                field("Any HT / LT line running"; Rec."Any HT / LT line running")
                {
                    Caption = 'Any HT / LT line running through the land';
                }
                field("Distance of a Polluting Indust"; Rec."Distance of a Polluting Indust")
                {
                    Caption = 'Distance of a Polluting industry, if any, within 2 km radius of the proposed land (in km)';
                }
                field("Distance of a slum area"; Rec."Distance of a slum area")
                {
                    Caption = 'Distance of a slum area, if any, within 2 km radius of the proposed land (in km)';
                }
                field("Is there a Nalla / Canal /Pond"; Rec."Is there a Nalla / Canal /Pond")
                {
                    Caption = 'Is there a Nalla / canal / pond within the land';
                }
                field("if yes, please mention"; Rec."if yes, please mention")
                {
                    Caption = 'if yes, please mention the statutory restrictions of acquiring such land';
                }
                field("Distance of the Drainage"; Rec."Distance of the Drainage")
                {
                    Caption = 'Distance of the nearby Drainage facility (in km)';
                }
                field("Soil Type"; Rec."Soil Type")
                {
                }
                field("Whether ULC is applicable"; Rec."Whether ULC is applicable")
                {
                }
                field("Whether ALC is applicable"; Rec."Whether ALC is applicable")
                {
                }
                field("Is it an assigned land"; Rec."Is it an assigned land")
                {
                }
                field("Is land belong to SC/ST/BC"; Rec."Is land belong to SC/ST/BC")
                {
                    Caption = 'Is land belonging to an SC/ST/BC';
                }
                field("Is land under Master Plan"; Rec."Is land under Master Plan")
                {
                    Caption = 'Is the land covered under Master plan';
                }
                field("Is the land within TUDA/VUDA"; Rec."Is the land within TUDA/VUDA")
                {
                    Caption = 'Is the land within the TUDA / VUDA / HMDA / HUDA limits';
                }
                field("Is there any layout nearby"; Rec."Is there any layout nearby")
                {
                }
                field("if yes, please mention details"; Rec."if yes, please mention details")
                {
                    Caption = 'if yes, please mention the details';
                }
                field("Ownership of the land"; Rec."Ownership of the land")
                {
                }
                field("Is Gram Samaj land lying"; Rec."Is Gram Samaj land lying")
                {
                    Caption = 'Is Gram Samaj land lying within proposed land';
                }
            }
            group("Contact Person Details")
            {
                field(Name; Rec.Name)
                {
                }
                field("Email Id"; Rec."Email Id")
                {
                }
                field("Mobile No"; Rec."Mobile No")
                {
                }
            }
            group("Distance from: (in km)")
            {
                field("Railway station"; Rec."Railway station")
                {
                }
                field(Airport; Rec.Airport)
                {
                }
                field("Bus stand"; Rec."Bus stand")
                {
                }
                field("Police station"; Rec."Police station")
                {
                }
                field("Main market"; Rec."Main market")
                {
                }
                field("Educational institutes"; Rec."Educational institutes")
                {
                }
                field("Collectorate/ MRO / Panchayat"; Rec."Collectorate/ MRO / Panchayat")
                {
                    Caption = 'Collectorate/ MRO / Panchayat';
                }
                field(Hospital; Rec.Hospital)
                {
                }
                field(Bank; Rec.Bank)
                {
                }
                field("Electrical sub station"; Rec."Electrical sub station")
                {
                }
                field("Telephone exchange"; Rec."Telephone exchange")
                {
                }
            }
            group(Others)
            {
                field("Rate quoted (in Rs. / Acre)"; Rec."Rate quoted (in Rs. / Acre)")
                {
                }
                field("Market rate (in Rs. / Acre)"; Rec."Market rate (in Rs. / Acre)")
                {
                }
                field("Government valuation (in Rs.)"; Rec."Government valuation (in Rs.)")
                {
                    Caption = 'Government valuation (in Rs.)';
                }
                field("Approx. Reg. charges (in Rs.)"; Rec."Approx. Reg. charges (in Rs.)")
                {
                    Caption = 'Approximate Registration charges (in Rs.)';
                }
                field("Land conversion charge(in Rs.)"; Rec."Land conversion charge(in Rs.)")
                {
                    Caption = 'Land conversion charges if it is agriculture (in Rs.)';
                }
                field("Layout approval charge(in Rs.)"; Rec."Layout approval charge(in Rs.)")
                {
                    Caption = 'Layout approval charges (in Rs.)';
                }
                field("Land development status"; Rec."Land development status")
                {
                    Caption = 'Land development status i.e. whether any development taken up if so extent';
                }
                field("if yes, please mention Detail"; Rec."if yes, please mention Detail")
                {
                    Caption = 'if yes, please mention the details';
                }
                field("Approx. Development cost"; Rec."Approx. Development cost")
                {
                    Caption = 'Approx. Development cost (in Rs. / sq. yards.)';
                }
                field("Nature of offer"; Rec."Nature of offer")
                {
                }
            }
            group("Cost Calculations")
            {
                field("Estimated project cost"; Rec."Estimated project cost")
                {
                    Caption = '          Estimated project cost (in Rs.)';
                }
                field("Land cost (in Rs.)"; Rec."Land cost (in Rs.)")
                {
                }
                field("Compliances cost (in Rs.)"; Rec."Compliances cost (in Rs.)")
                {
                }
                field("Development cost (in Rs.)"; Rec."Development cost (in Rs.)")
                {
                }
                field("Misc. Costs (in Rs.)"; Rec."Misc. Costs (in Rs.)")
                {
                }
                field("Total cost (in Rs.)"; Rec."Total cost (in Rs.)")
                {
                }
            }
            group("Estimated profits")
            {
                field("Saleable area in (sq. yards)"; Rec."Saleable area in (sq. yards)")
                {
                }
                field("Rate at which plot Cost fixed"; Rec."Rate at which plot Cost fixed")
                {
                    Caption = 'Rate at which plot cost can be fixed (in Rs. / sq. yard)';
                }
                field("Total plot sale amount"; Rec."Total plot sale amount")
                {
                    Caption = 'Total plot sale amount (in Rs.)';
                }
                field("Associates payouts (in Rs.)"; Rec."Associates payouts (in Rs.)")
                {
                    Caption = 'Associates payouts (in Rs.)';
                }
                field("Administrative expens (in Rs.)"; Rec."Administrative expens (in Rs.)")
                {
                    Caption = 'Administrative expenses (in Rs.)';
                }
                field("Misc. expenses (in Rs.)"; Rec."Misc. expenses (in Rs.)")
                {
                }
                field("Gross profit (in Rs.)"; Rec."Gross profit (in Rs.)")
                {
                }
                field("Net profit (in Rs.)"; Rec."Net profit (in Rs.)")
                {
                }
            }
            group(Others_1)
            {
                field("Approx. rate of other Projects"; Rec."Approx. rate of other Projects")
                {
                    Caption = 'Approximate rate of other projects in the nearby areas, if any (in Rs. / sq. yard)';
                }
                field("Any other useful information"; Rec."Any other useful information")
                {
                    Caption = 'Any other useful information';
                }
                field("User ID"; Rec."User ID")
                {
                }
                field(Date; Rec.Date)
                {
                }
                field("NALA /CANAL"; Rec."NALA /CANAL")
                {
                }
                field("Remarks NALA /CANAL"; Rec."Remarks NALA /CANAL")
                {
                    Caption = 'Remarks';
                }
                field("HT/LT  Lines"; Rec."HT/LT  Lines")
                {
                }
                field("Remarks HT/LT  Lines"; Rec."Remarks HT/LT  Lines")
                {
                    Caption = 'Remarks';
                }
                field("GRAMA  SAMJAN/KHAMTM"; Rec."GRAMA  SAMJAN/KHAMTM")
                {
                }
                field("Approach Road"; Rec."Approach Road")
                {
                }
                field("Remark for APPROACH ROAD"; Rec."Remark for APPROACH ROAD")
                {
                    Caption = 'Remarks';
                }
                field("POSITIONNAL IDENTIFICATION"; Rec."POSITIONNAL IDENTIFICATION")
                {
                }
                field("Remark for Positional Identify"; Rec."Remark for Positional Identify")
                {
                    Caption = 'Remarks';
                }
                field("RAILWAY TRACK DISTANCE"; Rec."RAILWAY TRACK DISTANCE")
                {
                }
                field("RemarksRAILWAY TRACK DISTANCE"; Rec."RemarksRAILWAY TRACK DISTANCE")
                {
                    Caption = 'Remarks';
                }
                field("FOREST ZONE"; Rec."FOREST ZONE")
                {
                }
                field("Remark for FOREST ZONE"; Rec."Remark for FOREST ZONE")
                {
                    Caption = 'Remarks';
                }
                field("ENVIRONEMENT CLEARENCE"; Rec."ENVIRONEMENT CLEARENCE")
                {
                }
                field("INFRA DEVELOPMENT ACTIVTY"; Rec."INFRA DEVELOPMENT ACTIVTY")
                {
                }
                field("ESTAMATED COST FOR YARD"; Rec."ESTAMATED COST FOR YARD")
                {
                }
            }
        }
    }

    actions
    {
    }
}

