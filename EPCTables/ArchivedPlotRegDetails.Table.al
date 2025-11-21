table 60700 "Archived Plot Reg Details"
{
    Caption = 'Plot Registration Details';
    DataPerCompany = false;

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
            NotBlank = true;
        }
        field(2; "Customer No."; Code[20])
        {
            Editable = false;
            TableRelation = Customer;
        }
        field(3; "Introducer Code"; Code[20])
        {
            Caption = 'IBA Code';
            Editable = false;
            TableRelation = Vendor WHERE("BBG Vendor Category" = FILTER("IBA(Associates)"),
                                          "BBG Status" = FILTER(Active | Provisional));
        }
        field(4; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(5; "User Code"; Code[50])
        {
            Editable = false;
            TableRelation = User;
        }
        field(6; Amount; Decimal)
        {
            Editable = false;
        }
        field(7; "Posting Date"; Date)
        {
            Editable = false;
        }
        field(8; "Document Date"; Date)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(9; "Amount Received"; Decimal)
        {
            Caption = 'Amount Received';
            Editable = false;
        }
        field(10; "Company Name"; Text[30])
        {
            Editable = false;
            TableRelation = Company;
        }
        field(11; "Unit Payment Plan"; Code[20])
        {
            Editable = false;
            TableRelation = "App. Charge Code".Code WHERE("Sub Payment Plan" = FILTER(true));
        }
        field(12; "Unit Plan Name"; Text[50])
        {
            Editable = false;
        }
        field(13; "Min. Allotment Amount"; Decimal)
        {
            Editable = false;
        }
        field(14; "Member Name"; Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Unit Code"; Code[20])
        {
            Editable = false;
        }
        field(16; "Application Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Open,,,,,,,,,,,,Registered,Cancelled,Vacate,Forfeit';
            OptionMembers = Open,Documented,"Cash Dispute","Documentation Dispute",Verified,Active,"Death Claim","Maturity Claim","Maturity Dispute",Matured,Dispute,"Blocked (Loan)",Registered,Cancelled,Vacate,Forfeit;
        }
        field(17; "Form32 Thumb impression form-1"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Plot Registration Req. form-1"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Aadhar card details -1"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "PAN card details -1"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Photo - 1"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Form32 Thumb imp. form -2"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Plot Registration Req. form-2"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Aadhar card details -2"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "PAN card details -2"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Photo -2"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(27; Payment; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Customer info"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Organizational info"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Project info"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Statutory info"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Sale deed info etc."; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Generation of Challan"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(34; "Doc send to SRO for Reg."; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(35; Registration; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Registration No."; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Doc received from SRO"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(38; "Registration details in NAV"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39; "Reg. Doc. Customer Receipt"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Send for Approval (Stage-1)"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(41; "Sender USER Id (Stage-1)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(42; "Approved By (Stage-1)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(43; "Approved (Stage-1)"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(44; "Approved Date (Stage-1)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(45; "Send for Appl.Date(Stage-1)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(46; "Send for Approval (Stage-2)"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(47; "Sender USER Id (Stage-2)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(48; "Approved By (Stage-2)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(49; "Approved (Stage-2)"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Approved Date (Stage-2)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(51; "Send for Appl.Date(Stage-2)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52; "Send for Approval (Stage-3)"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(53; "Sender USER Id (Stage-3)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(54; "Approved By (Stage-3)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(55; "Approved (Stage-3)"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(56; "Approved Date (Stage-3)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(57; "Send for Appl.Date(Stage-3)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(58; "Send for Approval (Stage-4)"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(59; "Sender USER Id (Stage-4)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60; "Approved By (Stage-4)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(61; "Approved (Stage-4)"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(62; "Approved Date (Stage-4)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(63; "Send for Appl.Date(Stage-4)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(64; "Send for Approval (Stage-5)"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(65; "Sender USER Id (Stage-5)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(66; "Approved By (Stage-5)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(67; "Approved (Stage-5)"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(68; "Approved Date (Stage-5)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(69; "Send for Appl.Date(Stage-5)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(70; "Send for Approval (Stage-6)"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(71; "Sender USER Id (Stage-6)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(72; "Approved By (Stage-6)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(73; "Approved (Stage-6)"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(74; "Approved Date (Stage-6)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(75; "Send for Appl.Date(Stage-6)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(76; "Send for Approval (Stage-7)"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(77; "Sender USER Id (Stage-7)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(78; "Approved By (Stage-7)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(79; "Approved (Stage-7)"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(80; "Approved Date (Stage-7)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(81; "Send for Appl.Date(Stage-7)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(89; "Form32 User Id"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90; "Form 32 Responsibility Center"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(91; "Plot Reg User Id"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(92; "Plot Reg. Resp Center"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(93; "AAdhar Card User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(94; "AAdhar Card Resp Center"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(95; "PAN User Id"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(96; "PAN Resp Center"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(97; "Photo User Id"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(98; "Photo Resp Center"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(99; "Form32 Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(100; "Plot Reg Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(101; "AAdhar Card Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(102; "PAN Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(103; "Photo Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(104; "Gen of Challan USERID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(105; "Gen of Challan RespCenter"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(106; "Gen of Challan Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(107; "Doc Send SRO USERID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(108; "Doc Send SRO RespCenter"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(109; "Doc Send SRO Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(110; "Customer Info USERID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(111; "Customer Info RespCenter"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(112; "Customer Info Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(113; "Org. info USERID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(114; "Org. info RespCenter"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(115; "Org. info Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(116; "Proj. info USERID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(117; "Proj. info RespCenter"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(118; "Proj. info Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(119; "Statury info USERID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(120; "Statury info RespCenter"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(121; "Statury info Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(122; "Sale Deed info USERID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(123; "Sale Deed info RespCenter"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(124; "Sale Deed info Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(125; "Stage 1 Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(126; "Stage 2 Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(127; "Stage 3 Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(128; "Stage 4 Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(129; "Stage 5 Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(130; "Stage 6 Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(131; "Stage 7 Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(132; "Open Stage"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(134; "Registration Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(135; "Reg. Office"; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(136; "Registration In Favour Of"; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(137; "Registered/Office Name"; Text[70])
        {
            DataClassification = ToBeClassified;
        }
        field(138; "Reg. Address"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(139; "Father/Husband Name"; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(140; "Branch Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(141; "Registered City"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = State;
        }
        field(142; "Zip Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";
        }
        field(143; "Reg./Cancle Reg. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(144; "Reg./Cancle Reg. Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(145; "Customer PAN No."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(146; "Customer Aadhar No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(147; "LLP Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(148; "LLP Address"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(149; "LLP Address 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(150; "Project Name"; Text[100])
        {
            CalcFormula = Lookup("Responsibility Center".Name WHERE(Code = FIELD("Shortcut Dimension 1 Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(151; "Plot No."; Code[20])
        {
            CalcFormula = Lookup("New Confirmed Order"."Unit Code" WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(152; "Plot Extent"; Decimal)
        {
            CalcFormula = Lookup("New Confirmed Order"."Saleable Area" WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(153; "Representative Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(154; "LLP Registration Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(155; "Plot Dimension"; Text[70])
        {
            DataClassification = ToBeClassified;
        }
        field(156; "Generation of Challan No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(157; "Transaction ID"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(158; "Transaction Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(160; "Representative Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
            end;
        }
        field(161; "Sale Deed Received Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(162; "Customer Sale Deed"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(163; "Link Book Received"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(164; "Link Book User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(165; "Link Book Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(166; "PRLC Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Rectification,Cancellation';
            OptionMembers = " ",Rectification,Cancellation;
        }
        field(167; "Send SMS Stage-1"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(168; "Send SMS Stage-1 Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(169; "Send SMS Generation of Challan"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(170; "Send SMS Challan Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(171; "Send SMS Doc send SRO for Reg."; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(172; "Send SMS Doc SRO Reg. DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(173; "Send SMS Doc received from SRO"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(174; "Send SMS Doc received SRO Dt.T"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(175; "Send SMS Reg. Doc. Cust Rcpt"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(176; "Send SMS Reg Doc Cust DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(177; "Remarks 1"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(178; "Remarks 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(179; "Remarks 3"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(180; "Remarks 4"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(181; "Remarks 5"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(182; "Remarks 6"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(183; "Remarks 7"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(184; "Remarks 8"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(185; "Unit Facing"; Option)
        {
            CalcFormula = Lookup("Unit Master".Facing WHERE("No." = FIELD("Unit Code")));
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'NA,East,West,North,South,NorthWest,SouthEast,NorthEast,SouthWest';
            OptionMembers = NA,East,West,North,South,NorthWest,SouthEast,NorthEast,SouthWest;
        }
        field(186; "Ageing Days 1"; Code[5])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(187; "Ageing Days 2"; Code[5])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(188; "Ageing Days 3"; Code[5])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(189; "Ageing Days 4"; Code[5])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(190; "Ageing Days 5"; Code[5])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(191; "Ageing Days 6"; Code[5])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(192; "Ageing Days 7"; Code[5])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(193; "Current Remarks"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(194; "Current Days"; Code[5])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50000; "Archive No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.", "Archive No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

