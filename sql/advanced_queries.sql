-- Advanced Queries for CyberThreats Database

-- 1. List all threat groups along with their aliases
SELECT TG.TG_name, A.Alias
FROM ThreatGroup TG
LEFT JOIN Alias A ON TG.TG_name = A.TG_name
ORDER BY TG.TG_name;

-- 2. Find all threat groups suspected to be duplicates
SELECT TD.TG_name1, TD.TG_name2
FROM TG_duplicate TD;

-- 3. List all attacks along with all aliases of their threat group
SELECT A.A_name, AL.Alias
FROM Attack A
JOIN Campaign C ON A.C_name = C.C_name
JOIN ThreatGroup TG ON C.TG_name = TG.TG_name
LEFT JOIN Alias AL ON TG.TG_name = AL.TG_name
ORDER BY A.A_name;

-- 4. Find all campaigns where duplicate threat groups are involved
SELECT DISTINCT C.C_name, TG1.TG_name AS TG1, TG2.TG_name AS TG2
FROM Campaign C
JOIN ThreatGroup TG1 ON C.TG_name = TG1.TG_name
JOIN TG_duplicate TD ON TG1.TG_name = TD.TG_name1
JOIN ThreatGroup TG2 ON TD.TG_name2 = TG2.TG_name;

-- 5. List all attacks and tools used along with threat group aliases
SELECT A.A_name, AT.AT_name, AL.Alias
FROM Uses U
JOIN Attack A ON U.AttackID = A.AttackID AND U.C_name = A.C_name
JOIN AttackTool AT ON U.AT_name = AT.AT_name
JOIN Campaign C ON A.C_name = C.C_name
JOIN ThreatGroup TG ON C.TG_name = TG.TG_name
LEFT JOIN Alias AL ON TG.TG_name = AL.TG_name;

-- 6. List all targets attacked by threat groups with aliases
SELECT DISTINCT T.T_name, TG.TG_name, AL.Alias
FROM AimsAt AA
JOIN Target T ON AA.TargetID = T.TargetID
JOIN Attack A ON AA.AttackID = A.AttackID AND AA.C_name = A.C_name
JOIN Campaign C ON A.C_name = C.C_name
JOIN ThreatGroup TG ON C.TG_name = TG.TG_name
LEFT JOIN Alias AL ON TG.TG_name = AL.TG_name
ORDER BY T.T_name;

-- 7. Count the number of attacks per alias
SELECT AL.Alias, COUNT(A.AttackID) AS AttackCount
FROM Alias AL
JOIN ThreatGroup TG ON AL.TG_name = TG.TG_name
JOIN Campaign C ON TG.TG_name = C.TG_name
JOIN Attack A ON C.C_name = A.C_name
GROUP BY AL.Alias
ORDER BY AttackCount DESC;

-- 8. List publications related to campaigns involving duplicate threat groups
SELECT P.Title, P.C_name, TG1.TG_name AS TG1, TG2.TG_name AS TG2
FROM Publication P
JOIN Campaign C ON P.C_name = C.C_name
JOIN ThreatGroup TG1 ON C.TG_name = TG1.TG_name
JOIN TG_duplicate TD ON TG1.TG_name = TD.TG_name1
JOIN ThreatGroup TG2 ON TD.TG_name2 = TG2.TG_name;

-- 9. Find all targets attacked by multiple threat groups (using duplicates)
SELECT T.T_name, COUNT(DISTINCT TG.TG_name) AS ThreatGroupCount
FROM AimsAt AA
JOIN Target T ON AA.TargetID = T.TargetID
JOIN Attack A ON AA.AttackID = A.AttackID AND AA.C_name = A.C_name
JOIN Campaign C ON A.C_name = C.C_name
JOIN ThreatGroup TG ON C.TG_name = TG.TG_name
GROUP BY T.T_name
HAVING COUNT(DISTINCT TG.TG_name) > 1;

-- 10. List all campaigns, their threat groups, aliases, and financial damage of attacks
SELECT C.C_name, TG.TG_name, AL.Alias, A.A_name, A.Financial_Damage
FROM Campaign C
JOIN ThreatGroup TG ON C.TG_name = TG.TG_name
LEFT JOIN Alias AL ON TG.TG_name = AL.TG_name
JOIN Attack A ON C.C_name = A.C_name
ORDER BY C.C_name, A.A_name;
