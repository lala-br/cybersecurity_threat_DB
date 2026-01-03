-- Sample Queries for CyberThreats Database

-- 1. List all sponsors
SELECT * FROM Sponsor;

-- 2. List all threat groups with their sponsors
SELECT TG.TG_name, S.S_name AS Sponsor
FROM ThreatGroup TG
JOIN Sponsor S ON TG.S_name = S.S_name;

-- 3. Find all aliases for a given threat group
SELECT Alias
FROM Alias
WHERE TG_name = 'APT28';

-- 4. List all campaigns and the threat groups behind them
SELECT C.C_name, TG.TG_name
FROM Campaign C
JOIN ThreatGroup TG ON C.TG_name = TG.TG_name;

-- 5. List all attacks with their campaign and financial damage
SELECT A.A_name, C.C_name, A.Financial_Damage
FROM Attack A
JOIN Campaign C ON A.C_name = C.C_name;

-- 6. Find all attacks that use a specific tool
SELECT A.A_name, AT.AT_name
FROM Uses U
JOIN Attack A ON U.AttackID = A.AttackID AND U.C_name = A.C_name
JOIN AttackTool AT ON U.AT_name = AT.AT_name
WHERE AT.AT_name = 'SUNBURST';

-- 7. List all targets of a specific attack
SELECT T.T_name, T.Sector, T.Location
FROM AimsAt AA
JOIN Target T ON AA.TargetID = T.TargetID
JOIN Attack A ON AA.AttackID = A.AttackID AND AA.C_name = A.C_name
WHERE A.A_name = 'SW_Backdoor';

-- 8. List all publications for a given campaign
SELECT P.Title, P.Publication_Type, RC.RC_name
FROM Publication P
JOIN ResearchCompany RC ON P.RC_name = RC.RC_name
WHERE P.C_name = 'SolarWinds';

-- 9. List campaigns along with the number of attacks in each
SELECT C.C_name, COUNT(A.AttackID) AS AttackCount
FROM Campaign C
LEFT JOIN Attack A ON C.C_name = A.C_name
GROUP BY C.C_name;

-- 10. Find campaigns that target a specific sector (e.g., Government)
SELECT DISTINCT C.C_name, TG.TG_name
FROM Campaign C
JOIN Attack A ON C.C_name = A.C_name
JOIN AimsAt AA ON A.AttackID = AA.AttackID AND A.C_name = AA.C_name
JOIN Target T ON AA.TargetID = T.TargetID
JOIN ThreatGroup TG ON C.TG_name = TG.TG_name
WHERE T.Sector = 'Government';

