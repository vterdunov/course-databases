WITH RECURSIVE Subordinates AS (
    -- Базовый случай: прямые подчиненные сотрудника Ивана Иванова (EmployeeID = 1)
    SELECT
        EmployeeID,
        Name,
        ManagerID,
        DepartmentID,
        RoleID
    FROM
        Employees
    WHERE
        ManagerID = 1

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
        Subordinates s ON e.ManagerID = s.EmployeeID
)

-- Получаем подробную информацию о каждом сотруднике
SELECT
    s.EmployeeID,
    s.Name,
    s.ManagerID,
    COALESCE(d.DepartmentName, 'NULL') AS Department,
    COALESCE(r.RoleName, 'NULL') AS Role,
    COALESCE((
        SELECT STRING_AGG(p.ProjectName, ', ')
        FROM Projects p
        WHERE p.DepartmentID = s.DepartmentID
    ), 'NULL') AS Projects,
    COALESCE((
        SELECT STRING_AGG(t.TaskName, ', ')
        FROM Tasks t
        WHERE t.AssignedTo = s.EmployeeID
    ), 'NULL') AS Tasks
FROM
    Subordinates s
LEFT JOIN
    Departments d ON s.DepartmentID = d.DepartmentID
LEFT JOIN
    Roles r ON s.RoleID = r.RoleID
ORDER BY
    s.Name;
