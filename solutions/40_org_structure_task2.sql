WITH RECURSIVE Subordinates AS (
    -- Базовый случай: прямые подчиненные сотрудника Ивана Иванова (EmployeeID = 1)
    SELECT
        EmployeeID,
        Name as EmployeeName,
        ManagerID,
        DepartmentID,
        RoleID
    FROM
        Employees
    WHERE
        ManagerID = 1  -- Начало с непосредственных подчиненных Ивана Иванова

    UNION ALL

    -- Рекурсивный случай: подчиненные подчиненных
    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM
        Employees e
    INNER JOIN
        Subordinates s ON e.ManagerID = s.EmployeeID  -- Рекурсивное добавление подчиненных
)

-- Получаем подробную информацию о каждом сотруднике и дополнительную статистику
SELECT
    s.EmployeeID,
    s.EmployeeName,
    s.ManagerID,
    d.DepartmentName,
    r.RoleName,
    COALESCE(
        (SELECT STRING_AGG(p.ProjectName, ', ')
         FROM Projects p
         WHERE p.DepartmentID = s.DepartmentID),
        'NULL'
    ) AS ProjectNames,                                       -- NULL → 'NULL'
    COALESCE(
        (SELECT STRING_AGG(t.TaskName, ', ')
         FROM Tasks t
         WHERE t.AssignedTo = s.EmployeeID),
        'NULL'
    ) AS TaskNames,                                         -- NULL → 'NULL'
    (SELECT COUNT(*)
     FROM Tasks t
     WHERE t.AssignedTo = s.EmployeeID) AS TotalTasks,

    (SELECT COUNT(*)
     FROM Employees e
     WHERE e.ManagerID = s.EmployeeID) AS TotalSubordinates
FROM
    Subordinates s
LEFT JOIN
    Departments d ON s.DepartmentID = d.DepartmentID
LEFT JOIN
    Roles r ON s.RoleID = r.RoleID
ORDER BY
    s.EmployeeName;
