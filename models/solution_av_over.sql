


SELECT
    emp_id,
    emp_name,
    department,
    salary,
    AVG(salary) OVER () AS avg_salary,
    CASE
        WHEN salary > AVG(salary) OVER ()
            THEN 'Above Average'
        ELSE 'Below Average'
    END AS salary_flag
FROM RAW_DATA.employee