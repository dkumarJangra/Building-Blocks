page 60672 "LAND R3 - LEGAL CHECK Card"
{
    AutoSplitKey = true;
    PageType = Card;
    SourceTable = "Land R-2 PPR  Document List";
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
            }
            group("MANDATORY REVENUE RECORD")
            {
                field("KHASRA FOR 1954-55"; Rec."KHASRA FOR 1954-55")
                {
                }
                field("CHESALA FOR 1955-58"; Rec."CHESALA FOR 1955-58")
                {
                }
                field(SETHWAR; Rec.SETHWAR)
                {
                }
                field("SUPPLEMENTARY SETWAR"; Rec."SUPPLEMENTARY SETWAR")
                {
                }
                field("NO PT CERTIFICATE"; Rec."NO PT CERTIFICATE")
                {
                }
                field("PT REGISTER EXTRACT"; Rec."PT REGISTER EXTRACT")
                {
                }
                field("WASOOL BAKI REGISTER EXTRACT"; Rec."WASOOL BAKI REGISTER EXTRACT")
                {
                    Caption = 'WASOOL BAKI REGISTER EXTRACT';
                }
                field("FAISAL PATTI REGISTER EXTRACT"; Rec."FAISAL PATTI REGISTER EXTRACT")
                {
                    Caption = 'FAISAL PATTI REGISTER EXTRACT';
                }
                field("AYAKAR BANDH EXTRACT"; Rec."AYAKAR BANDH EXTRACT")
                {
                }
                field("VILLAGE NAKSHA"; Rec."VILLAGE NAKSHA")
                {
                }
                field(TIPPONS; Rec.TIPPONS)
                {
                }
                field("TONCH NAKSHA"; Rec."TONCH NAKSHA")
                {
                }
                field("OLD ROR FOR 1979-80"; Rec."OLD ROR FOR 1979-80")
                {
                }
                field("NEW ROR 1989-90"; Rec."NEW ROR 1989-90")
                {
                }
                field("ADANGALS/PH1958-59 TO Dt."; Rec."ADANGALS/PH1958-59 TO Dt.")
                {
                    Caption = 'ADANGALS / PAHANI 1958-59 TO TILL DATE';
                }
                field("1B ROR ONLINE EXTRACT"; Rec."1B ROR ONLINE EXTRACT")
                {
                }
                field("VILLAGE 1A REGISTER EXTRACT"; Rec."VILLAGE 1A REGISTER EXTRACT")
                {
                    Caption = 'VILLAGE 1A REGISTER EXTRACT';
                }
                field("VILLAGE 1B REGISTER EXTRACT"; Rec."VILLAGE 1B REGISTER EXTRACT")
                {
                }
                field("PATTADAR PASSBOOK"; Rec."PATTADAR PASSBOOK")
                {
                }
                field("TITLE DEED PASSBOOK"; Rec."TITLE DEED PASSBOOK")
                {
                }
                field("PATTA CERTIFICATE BY TAHSILDAR"; Rec."PATTA CERTIFICATE BY TAHSILDAR")
                {
                }
                field("LAND USE CERTIFICATE"; Rec."LAND USE CERTIFICATE")
                {
                }
            }
            group("OPTIONAL REVENUE RECORD")
            {
                field("1950 Pahani"; Rec."1950 Pahani")
                {
                    Caption = '1950 Pahani (In Case Khasra of 1954 is not found)';
                }
                field("Prohinitory Register at Tahsil"; Rec."Prohinitory Register at Tahsil")
                {
                    Caption = 'PROHIBITORY REGISTER AT TAHSILDAR OFFICE';
                }
                field("CONVERSION ORDERS WHERE ISSUED"; Rec."CONVERSION ORDERS WHERE ISSUED")
                {
                    Caption = 'CONVERSION ORDERS WHERE ISSUED';
                }
            }
            group("TITLE LINK DOCUMENTS")
            {
                field("Title Deeds / Sale Deeds"; Rec."Title Deeds / Sale Deeds")
                {
                    Caption = 'TITLE DEEDS / SALE DEEDS OF THE PRESENT VENDOR';
                }
                field("Link Doc for minimum of 30 Yr"; Rec."Link Doc for minimum of 30 Yr")
                {
                    Caption = 'LINK DOCUMENTS FOR A MINIMUM OF 30 YEARS';
                }
            }
            group("IN CASE OF ANCESTRAL PROPERTIES")
            {
                field("DEATH CERTIFICATE"; Rec."DEATH CERTIFICATE")
                {
                }
                field("WILL, IF ANY"; Rec."WILL, IF ANY")
                {
                }
                field("FAMILY MEMBERS CERTIFICATE"; Rec."FAMILY MEMBERS CERTIFICATE")
                {
                }
                field("SUCCESSION CERTIFICATE"; Rec."SUCCESSION CERTIFICATE")
                {
                    Caption = 'SUCCESSION CERTIFICATE / VIRASAT PROCEEDINGS';
                }
                field("Legal Certificate by Court"; Rec."Legal Certificate by Court")
                {
                    Caption = 'LEGAL HEIR CERTIFICATE BY COURT';
                }
                field("Family partition"; Rec."Family partition")
                {
                    Caption = 'FAMILY PARTITION / SETTLEMENT DEEDS';
                }
            }
            group("IN CASE OF ARTIFICIAL JURIDICAL PERSONS")
            {
                Caption = 'IN CASE OF ARTIFICIAL JURIDICAL PERSONS';
            }
            group("IN CASE OF COMPANY")
            {
                field("MOA/AOA"; Rec."MOA/AOA")
                {
                }
                field("CERTIFICATE OF INCORPORATION"; Rec."CERTIFICATE OF INCORPORATION")
                {
                }
                field("BOARD RESOLUTION"; Rec."BOARD RESOLUTION")
                {
                }
                field("List of Directors"; Rec."List of Directors")
                {
                }
                field("REGISTER OF CHARGES COMP."; Rec."REGISTER OF CHARGES COMP.")
                {
                }
            }
            group("IN CASE OF FIRMS/ LLP/ TRUST/ SOCIETY")
            {
                Caption = 'IN CASE OF FIRMS/ LLP/ TRUST/ SOCIETY';
                field("PARTNERSHIP DEED / DEED"; Rec."PARTNERSHIP DEED / DEED")
                {
                }
                field("CERTIFICATE OF REGISTRATION"; Rec."CERTIFICATE OF REGISTRATION")
                {
                }
                field("LIST OF PARTNERS/MEMBERS"; Rec."LIST OF PARTNERS/MEMBERS")
                {
                }
                field("Auth. / Reso. By due process"; Rec."Auth. / Reso. By due process")
                {
                }
                field("REGISTER OF CHARGES"; Rec."REGISTER OF CHARGES")
                {
                }
            }
            group("IN CASE OF LITIGATIONS")
            {
                Caption = 'IN CASE OF LITIGATIONS';
                field("Planint Copy and Written stat."; Rec."Planint Copy and Written stat.")
                {
                    Caption = 'PLAINT COPY AND WRITTEN STATEMENT ALONG WITH MATERIAL PAPERS FILED';
                }
                field("COUNTER COPY"; Rec."COUNTER COPY")
                {
                }
                field("ORDER COPY"; Rec."ORDER COPY")
                {
                    Caption = 'ORDER COPY or JUDGMENT COPY OR DECREE';
                }
            }
            group("IN CASE OF GOVT CLAIMS")
            {
                Caption = 'IN CASE OF GOVT CLAIMS';
                field("38E CERTIFICATE IN CASE OF PT"; Rec."38E CERTIFICATE IN CASE OF PT")
                {
                    Caption = '38E CERTIFICATE IN CASE OF PT';
                }
                field("ORC CERT. IN CASE OF INAM"; Rec."ORC CERT. IN CASE OF INAM")
                {
                    Caption = 'ORC CERTIFICATE IN CASE OF INAM';
                }
                field("NOC IN CASE OF WAQF"; Rec."NOC IN CASE OF WAQF")
                {
                    Caption = 'NOC IN CASE OF WAQF / BHOODAN';
                }
                field("NOC FROM IRRIGATION"; Rec."NOC FROM IRRIGATION")
                {
                }
                field("NOC FROM FOREST DEPT"; Rec."NOC FROM FOREST DEPT")
                {
                    Caption = 'NOC FROM FOREST DEPT (IN CASE OF ABUTTING FOREST LANDS)';
                }
            }
            group("SRO RECORD")
            {
                Caption = 'SRO RECORD';
                field("PROHIBITORY REGISTER UNDER 22A"; Rec."PROHIBITORY REGISTER UNDER 22A")
                {
                    Caption = 'PROHIBITORY REGISTER UNDER SEC.22A';
                }
                field("MARKET VALUE STATEMENT"; Rec."MARKET VALUE STATEMENT")
                {
                }
                field("UPTO DATE EC FOR LAST 50 YEARS"; Rec."UPTO DATE EC FOR LAST 50 YEARS")
                {
                    Caption = 'UPTO DATE EC FOR LAST 50 YEARS';
                }
                field("RH, IF REQUIRED"; Rec."RH, IF REQUIRED")
                {
                }
            }
            group("IN CASE OF OPEN PLOTS")
            {
                Caption = 'IN CASE OF OPEN PLOTS';
                field("DEMARCATION CERTIFICATE FROM"; Rec."DEMARCATION CERTIFICATE FROM")
                {
                    Caption = 'DEMARCATION CERTIFICATE FROM AD(SLR)';
                }
                field("DTCP/HMDA/GHMC TLP PROCEEDING"; Rec."DTCP/HMDA/GHMC TLP PROCEEDING")
                {
                    Caption = 'DTCP / HMDA / GHMC TLP PROCEEDING';
                }
                field("DTCP/HMDA/GHMC APPROVED TLP"; Rec."DTCP/HMDA/GHMC APPROVED TLP")
                {
                    Caption = 'DTCP / HMDA / GHMC APPROVED TLP PLAN';
                }
                field("GP APPROVAL LETTER"; Rec."GP APPROVAL LETTER")
                {
                    Caption = 'GP APPROVAL LETTER, IF APPLICABLE';
                }
                field("REGD. GIFT DEED FOR PUBLIC"; Rec."REGD. GIFT DEED FOR PUBLIC")
                {
                    Caption = 'REGD. GIFT DEED FOR PUBLIC AREAS';
                }
                field("FINAL LAYOUT, IF AVAILABLE"; Rec."FINAL LAYOUT, IF AVAILABLE")
                {
                    Caption = 'FINAL LAYOUT, IF AVAILABLE';
                }
                field("COMPLETION CERTIFICATE"; Rec."COMPLETION CERTIFICATE")
                {
                    Caption = 'COMPLETION CERTIFICATE, IF AVAILABLE';
                }
                field("RERA REGISTRATION CERTIFICATE"; Rec."RERA REGISTRATION CERTIFICATE")
                {
                    Caption = 'RERA REGISTRATION CERTIFICATE';
                }
            }
            group(RECOMMENDED)
            {
                field("PAPER PUBLICATION"; Rec."PAPER PUBLICATION")
                {
                }
            }
        }
    }

    actions
    {
    }
}

