table 60678 "Land R-1 PPR Document Lis_1"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Document Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(67; "Village Name"; Text[50])
        {
            CalcFormula = Lookup("Land Lead/Opp Header"."Village Name" WHERE("Document No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                UpdateLandArea;
            end;
        }
        field(68; "Mandalam Name"; Text[50])
        {
            CalcFormula = Lookup("Land Lead/Opp Header"."Mandalam Name" WHERE("Document No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                UpdateLandArea;
            end;
        }
        field(69; "Post Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code"
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                UpdateLandArea;
            end;
        }
        field(70; "Total Land Area"; Text[80])
        {
            CalcFormula = Lookup("Land Lead/Opp Header"."Total Land Area in Text" WHERE("Document No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(71; "Type of the land"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Agriculture,Non-Agriculture';
            OptionMembers = " ",Agriculture,"Non-Agriculture";

            trigger OnValidate()
            begin
                UpdateLandArea;
            end;
        }
        field(72; "Distance from Main road"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(73; "Length (land facing the road)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Length (land facing the road)';
        }
        field(74; "Taste of Water"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Sweet,Salt';
            OptionMembers = Sweet,Salt;
        }
        field(75; "Bore well purpose  (in Feet's)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(76; "Any HT / LT line running"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Any HT / LT line running through the land';
        }
        field(77; "Distance of a Polluting Indust"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Distance of a Polluting industry, if any, within 2 km radius of the proposed land (in km)';
        }
        field(78; "Distance of a slum area"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Distance of a slum area, if any, within 2 km radius of the proposed land (in km)';
        }
        field(79; "Is there a Nalla / Canal /Pond"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Is there a Nalla / canal / pond within the land';
        }
        field(80; "if yes, please mention"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = ' if yes, please mention the statutory restrictions of acquiring such land';
        }
        field(81; "Distance of the Drainage"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Distance of the nearby Drainage facility (in km)';
        }
        field(82; "Soil Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Red,Black Cotton,Rocky,Other';
            OptionMembers = " ",Red,"Black Cotton",Rocky,Other;
        }
        field(83; "Whether ULC is applicable"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(84; "Whether ALC is applicable"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(85; "Is it an assigned land"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(86; "Is land belong to SC/ST/BC"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Is land belonging to an SC/ST/BC';
        }
        field(87; "Is land under Master Plan"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Is the land covered under Master plan';
        }
        field(88; "Is the land within TUDA/VUDA"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Is the land within the TUDA / VUDA / HMDA / HUDA limits';
        }
        field(89; "Is there any layout nearby"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90; "if yes, please mention details"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'if yes, please mention the details';
        }
        field(91; "Ownership of the land"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Family Property,Partnership Property,Individual Owner,Self Acquired,Other';
            OptionMembers = "Family Property","Partnership Property","Individual Owner","Self Acquired",Other;
        }
        field(92; Name; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(93; "Email Id"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(94; "Mobile No"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(95; "Is Gram Samaj land lying"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Is Gram Samaj land lying within proposed land';
        }
        field(96; "Railway station"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(97; Airport; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(98; "Bus stand"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(99; "Police station"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(100; "Main market"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(101; "Educational institutes"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(102; "Collectorate/ MRO / Panchayat"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(103; Hospital; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(104; Bank; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(105; "Electrical sub station"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(106; "Telephone exchange"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(107; "Rate quoted (in Rs. / Acre)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(108; "Market rate (in Rs. / Acre)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(109; "Government valuation (in Rs.)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(110; "Approx. Reg. charges (in Rs.)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Approximate Registration charges (in Rs.)';
        }
        field(111; "Land conversion charge(in Rs.)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Land conversion charges if it is agriculture (in Rs.)';
        }
        field(112; "Layout approval charge(in Rs.)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Layout approval charge(in Rs.)';
        }
        field(113; "Land development status"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Land development status i.e. whether any development taken up if so extent';
        }
        field(114; "if yes, please mention Detail"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = ' if yes, please mention the details';
        }
        field(115; "Approx. Development cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Approx. Development cost (in Rs. / sq. yards.)';
        }
        field(116; "Nature of offer"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Direct Sale,Joint Venture,Joint Director,Sales Mandate,Other';
            OptionMembers = "Direct Sale","Joint Venture","Joint Director","Sales Mandate",Other;
        }
        field(117; "Estimated project cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Estimated project cost (in Rs.)';
        }
        field(118; "Land cost (in Rs.)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(119; "Compliances cost (in Rs.)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(120; "Development cost (in Rs.)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(121; "Misc. Costs (in Rs.)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(122; "Total cost (in Rs.)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(123; "Saleable area in (sq. yards)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(124; "Rate at which plot Cost fixed"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Rate at which plot cost can be fixed (in Rs. / sq. yard)';
        }
        field(125; "Total plot sale amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Total plot sale amount (in Rs.)';
        }
        field(126; "Associates payouts (in Rs.)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(127; "Administrative expens (in Rs.)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Administrative expenses (in Rs.)';
        }
        field(128; "Misc. expenses (in Rs.)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(129; "Gross profit (in Rs.)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(130; "Net profit (in Rs.)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(131; "Approx. rate of other Projects"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Approximate rate of other projects in the nearby areas, if any (in Rs. / sq. yard)';
        }
        field(132; "Any other useful information"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(171; "User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(172; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(173; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(174; "State Code"; Code[10])
        {
            Caption = 'State Code';
            DataClassification = ToBeClassified;
            TableRelation = State;
        }
        field(176; "NALA /CANAL"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(178; "HT/LT  Lines"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(179; "GRAMA  SAMJAN/KHAMTM"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(180; "Approach Road"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(181; "Remark for APPROACH ROAD"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(182; "POSITIONNAL IDENTIFICATION"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(183; "Remark for Positional Identify"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(184; "RAILWAY TRACK DISTANCE"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(185; "FOREST ZONE"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(186; "Remark for FOREST ZONE"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(187; "ENVIRONEMENT CLEARENCE"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(188; "INFRA DEVELOPMENT ACTIVTY"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = '(INCASE OF AQUARING DEVELEOPED PLOTS)';
        }
        field(189; "ESTAMATED COST FOR YARD"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(190; "Remarks NALA /CANAL"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(191; "Remarks HT/LT  Lines"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(192; "RemarksRAILWAY TRACK DISTANCE"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Document Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    var
        LandLeadOppHeader: Record "Land Lead/Opp Header";
    begin
        LandLeadOppHeader.RESET;
        LandLeadOppHeader.SETRANGE("Document Type", LandLeadOppHeader."Document Type"::Opportunity);
        LandLeadOppHeader.SETRANGE("Document No.", "Document No.");
        IF LandLeadOppHeader.FINDFIRST THEN
            LandLeadOppHeader.TESTFIELD("Lead Status", LandLeadOppHeader."Lead Status"::" ");

        LandLeadOppHeader.RESET;
        LandLeadOppHeader.SETRANGE("Document Type", LandLeadOppHeader."Document Type"::Lead);
        LandLeadOppHeader.SETRANGE("Document No.", "Document No.");
        IF LandLeadOppHeader.FINDFIRST THEN
            LandLeadOppHeader.TESTFIELD("Lead Status", LandLeadOppHeader."Lead Status"::" ");
    end;

    var
        LandLeadOppHeader: Record "Land Lead/Opp Header";


    procedure UpdateLandArea()
    begin
    end;
}

