# Relational Schema – CyberThreats Database

This document describes the logical (relational) schema of the CyberThreats database.
It lists all tables, their attributes, and the primary and foreign key relationships
between them.

---

## Sponsor
Sponsor(
S_name PK,
Country
)

## ThreatGroup
ThreatGroup(
TG_name PK,
S_name FK → Sponsor(S_name)
)

## Alias
Alias(
Alias PK,
TG_name PK, FK → ThreatGroup(TG_name)
)

## Campaign
Campaign(
C_name PK,
TG_name FK → ThreatGroup(TG_name),
StartDate,
EndDate
)

## Attack
Attack(
AttackID PK,
C_name PK, FK → Campaign(C_name),
A_name,
Financial_Damage
)

## AttackTool
AttackTool(
AT_name PK,
Type
)

## Uses
Uses(
AttackID PK, FK → Attack(AttackID),
C_name PK, FK → Campaign(C_name),
AT_name PK, FK → AttackTool(AT_name)
)

## Target
Target(
TargetID PK,
T_name,
Sector,
Location
)

## AimsAt
AimsAt(
TargetID PK, FK → Target(TargetID),
AttackID PK,
C_name PK,
FK → Attack(AttackID, C_name)
)

## ResearchCompany
ResearchCompany(
RC_name PK
)

## Publication
Publication(
PublicationID PK,
RC_name PK, FK → ResearchCompany(RC_name),
C_name FK → Campaign(C_name),
Title,
Damage,
Publication_Type,
Modification
)

## About
About(
C_name PK, FK → Campaign(C_name),
PublicationID PK,
RC_name FK → Publication(PublicationID, RC_name),
Date
)

---

## Notes
- PK = Primary Key  
- FK = Foreign Key  
- Composite primary keys are used where necessary to uniquely identify records.
- The schema supports tracking threat groups, campaigns, attacks, tools, targets,
  and related research publications.



