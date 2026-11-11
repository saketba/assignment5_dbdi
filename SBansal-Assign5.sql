-- Question 1
SELECT quantityOnHand
FROM item
WHERE itemDescription LIKE '%antibiotics%';

-- Question 2
SELECT volunteerName
FROM volunteer
WHERE volunteerTelephone NOT LIKE '2%'
AND volunteerName NOT LIKE '% Jones';

-- Question 3
SELECT DISTINCT volunteer.volunteerName
FROM volunteer
JOIN assignment
    ON volunteer.volunteerId = assignment.volunteerId
JOIN task
    ON assignment.taskCode = task.taskCode
JOIN task_type
    ON task.taskTypeId = task_type.taskTypeId
WHERE task_type.taskTypeName = 'transporting';

-- Question 4
SELECT taskDescription
FROM task
WHERE taskCode NOT IN (
    SELECT taskCode
    FROM assignment
);

-- Question 5
SELECT DISTINCT package_type.packageTypeName
FROM package_type
JOIN package
    ON package_type.packageTypeId = package.packageTypeId
JOIN package_contents
    ON package.packageId = package_contents.packageId
JOIN item
    ON package_contents.itemId = item.itemId
WHERE item.itemDescription LIKE '%bottle%';

-- Question 6
SELECT itemDescription
FROM item
WHERE itemId NOT IN (
    SELECT itemId
    FROM package_contents
);

-- Question 7
SELECT taskDescription
FROM task
WHERE taskCode IN (
    SELECT assignment.taskCode
    FROM assignment
    JOIN volunteer
        ON assignment.volunteerId = volunteer.volunteerId
    WHERE volunteer.volunteerAddress LIKE '%NJ%'
);

-- Question 8
SELECT volunteerName
FROM volunteer
WHERE volunteerId IN (
    SELECT volunteerId
    FROM assignment
    WHERE startDateTime >= '2021-01-01'
      AND startDateTime < '2021-07-01'
);

-- Question 9
SELECT volunteerName
FROM volunteer
WHERE volunteerId IN (
    SELECT assignment.volunteerId
    FROM assignment
    JOIN package
        ON assignment.taskCode = package.taskCode
    JOIN package_contents
        ON package.packageId = package_contents.packageId
    JOIN item
        ON package_contents.itemId = item.itemId
    WHERE item.itemDescription LIKE '%spam%'
);

-- Question 10
SELECT itemDescription
FROM item
WHERE itemId IN (
    SELECT package_contents.itemId
    FROM package_contents
    JOIN item
        ON package_contents.itemId = item.itemId
    WHERE package_contents.itemQuantity * item.itemValue = 100
);

-- Question 11
SELECT task_status.taskStatusName,
       COUNT(DISTINCT assignment.volunteerId) AS volunteerCount
FROM task_status
JOIN task
    ON task_status.taskStatusId = task.taskStatusId
JOIN assignment
    ON task.taskCode = assignment.taskCode
GROUP BY task_status.taskStatusId, task_status.taskStatusName
ORDER BY volunteerCount DESC;

-- Question 12
SELECT taskCode,
       SUM(packageWeight) AS totalWeight
FROM package
GROUP BY taskCode
ORDER BY totalWeight DESC
LIMIT 1;

-- Question 13
SELECT COUNT(*) AS taskCount
FROM task
JOIN task_type
    ON task.taskTypeId = task_type.taskTypeId
WHERE task_type.taskTypeName <> 'packing';

-- Question 14
SELECT item.itemDescription
FROM item
JOIN package_contents
    ON item.itemId = package_contents.itemId
JOIN package
    ON package_contents.packageId = package.packageId
LEFT JOIN assignment
    ON package.taskCode = assignment.taskCode
GROUP BY item.itemId, item.itemDescription
HAVING COUNT(DISTINCT assignment.volunteerId) < 3;

-- Question 15
SELECT package_contents.packageId,
       SUM(package_contents.itemQuantity * item.itemValue) AS totalValue
FROM package_contents
JOIN item
    ON package_contents.itemId = item.itemId
GROUP BY package_contents.packageId
HAVING totalValue > 100
ORDER BY totalValue ASC;